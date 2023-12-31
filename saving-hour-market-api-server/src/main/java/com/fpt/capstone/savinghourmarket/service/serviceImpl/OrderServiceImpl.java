package com.fpt.capstone.savinghourmarket.service.serviceImpl;

import com.fpt.capstone.savinghourmarket.common.*;
import com.fpt.capstone.savinghourmarket.entity.*;
import com.fpt.capstone.savinghourmarket.exception.*;
import com.fpt.capstone.savinghourmarket.model.*;
import com.fpt.capstone.savinghourmarket.repository.*;
import com.fpt.capstone.savinghourmarket.service.FirebaseService;
import com.fpt.capstone.savinghourmarket.service.OrderService;
import com.fpt.capstone.savinghourmarket.service.SystemConfigurationService;
import com.fpt.capstone.savinghourmarket.util.Utils;
import com.fpt.capstone.savinghourmarket.util.kmean.Centroid;
import com.fpt.capstone.savinghourmarket.util.kmean.HaversineDistance;
import com.fpt.capstone.savinghourmarket.util.kmean.KMeans;
import com.fpt.capstone.savinghourmarket.util.kmean.Record;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfWriter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.glxn.qrgen.QRCode;
import net.glxn.qrgen.image.ImageType;
import org.modelmapper.ModelMapper;
import org.redisson.api.RLock;
import org.redisson.api.RMapCache;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AuthorizationServiceException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URI;
import java.sql.Date;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final FirebaseAuth firebaseAuth;

    private RedissonClient redissonClient;

    @Autowired
    public void setRedissonClient(RedissonClient redissonClient) {
        this.redissonClient = redissonClient;
    }

    private final OrderRepository repository;

    private final OrderDetailRepository orderDetailRepository;

    private final ProductRepository productRepository;

    private final ProductBatchRepository productBatchRepository;

    private final OrderGroupRepository orderGroupRepository;

    private final OrderBatchRepository orderBatchRepository;

    private final TimeFrameRepository timeFrameRepository;

    private final PickupPointRepository pickupPointRepository;

    private final CustomerRepository customerRepository;

    private final StaffRepository staffRepository;

    private final DiscountRepository discountRepository;

    private final SystemConfigurationService systemConfigurationService;

    private final ProductConsolidationAreaRepository productConsolidationAreaRepository;
    private final ConfigurationRepository configurationRepository;

    @Value("${goong-api-key}")
    private String goongApiKey;
    @Value("${goong-distance-matrix-url}")
    private String goongDistanceMatrixUrl;

    private String generateOrderCode(LocalDateTime createOrderDate) {
//        if(counter.equals(999999)) {
//            counter.set(1);
//        }
//        long count = counter.incrementAndGet();
        int nextCount = repository.findByCreateDate(createOrderDate.toLocalDate()).size() + 1;

        String zeros = "";
        for (int i = 1; i <= 6 - String.valueOf(nextCount).length(); i++) {
            zeros = zeros + "0";
        }
        String orderId = "SHMORD" + createOrderDate.getDayOfMonth() + createOrderDate.getMonthValue() + String.valueOf(createOrderDate.getYear()).substring(2, 4) + zeros + nextCount;


        return orderId;
    }

    @Override
    public OrderGroupPageResponse fetchOrderGroups(String staffEmail,
                                                   OrderStatus status,
                                                   SortType deliverDateSortType,
                                                   LocalDate deliverDate,
                                                   Boolean getOldOrderGroup,
                                                   UUID timeFrameId,
                                                   UUID pickupPointId,
                                                   UUID delivererId,
                                                   Integer page,
                                                   Integer size) throws ResourceNotFoundException {
        Sort sortable = null;

        if (deliverDateSortType != null) {
            if (deliverDateSortType.equals(SortType.ASC)) {
                sortable = Sort.by("deliverDate").ascending();
            } else {
                sortable = Sort.by("deliverDate").descending();
            }
        }
        Pageable pageableWithSort;
        if (sortable != null) {
            pageableWithSort = PageRequest.of(page, size, sortable);
        } else {
            pageableWithSort = PageRequest.of(page, size);
        }
        Staff staff = staffRepository.findByEmail(staffEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + staffEmail));
        List<Staff> staffManaged = staff.getDeliverStaffList();

        Page<OrderGroup> result = orderGroupRepository.findByTimeFrameOrPickupPointOrDeliverDate(
                getOldOrderGroup,
                timeFrameId,
                pickupPointId,
                delivererId,
                deliverDate,
                pageableWithSort);
        int totalPage = result.getTotalPages();
        long totalGroups = result.getTotalElements();
        OrderGroupPageResponse response = new OrderGroupPageResponse();
        Configuration configuration = configurationRepository.findAll().get(0);
        List<OrderGroup> orderGroups = result.stream().toList();
        if (status != null) {
            orderGroups.forEach(orderGroup -> {
                //Filter order list of each group by status
                List<Order> orderFilter = orderGroup.getOrderList()
                        .stream()
                        .filter(order ->
                                (order.getStatus().equals(status.ordinal()) && ((order.getPaymentMethod() == 1 && order.getPaymentStatus() == 1) || order.getPaymentMethod() == 0))
                                        &&
                                        ((order.getStatus() > OrderStatus.PROCESSING.ordinal() && order.getStatus() <= OrderStatus.PACKAGED.ordinal())
                                                || (order.getStatus() > OrderStatus.PACKAGED.ordinal() && staff.getRole().equals(StaffRole.STAFF_DLV_0.toString()))
                                                || ((order.getStatus() > OrderStatus.PACKAGED.ordinal() && staff.getRole().equals(StaffRole.STAFF_DLV_1.toString())) && staffManaged.stream().anyMatch(staff1 -> staff1.equals(order.getDeliverer())))
                                                || (order.getStatus() == OrderStatus.PROCESSING.ordinal() && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS))))
                        )
                        .toList();
                orderGroup.setOrderList(orderFilter);
            });
            response.setOrderGroups(orderGroups.stream().filter(orderGroup -> orderGroup.getOrderList().size() > 0).toList());
        } else {
            response.setOrderGroups(orderGroups);
        }
        response.setTotalPages(totalPage);
        response.setTotalGroups(totalGroups);
        return response;
    }

    @Override
    public List<OrderGroup> fetchOrderGroupsForPackageStaff(String staffEmail, SortType deliverDateSortType, LocalDate deliverDate, Boolean getOldOrderGroup, UUID timeFrameId, UUID pickupPointId, UUID delivererId, Integer page, Integer size) throws ResourceNotFoundException {
        Staff staff = staffRepository.findByEmail(staffEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + staffEmail));
        List<PickupPoint> pickupPointListOfStaff = staff.getPickupPoint();
        Sort sortable = null;

        if (deliverDateSortType != null) {
            if (deliverDateSortType.equals(SortType.ASC)) {
                sortable = Sort.by("deliverDate").ascending();
            } else {
                sortable = Sort.by("deliverDate").descending();
            }
        }
        Pageable pageableWithSort;
        if (sortable != null) {
            pageableWithSort = PageRequest.of(page, size, sortable);
        } else {
            pageableWithSort = PageRequest.of(page, size);
        }
        Configuration configuration = configurationRepository.findAll().get(0);
        List<OrderGroup> orderGroups = orderGroupRepository.findByTimeFrameOrPickupPointOrDeliverDateForPackageStaff(
                pickupPointListOfStaff,
                getOldOrderGroup,
                timeFrameId,
                pickupPointId,
                delivererId,
                deliverDate,
                pageableWithSort);
        orderGroups.forEach(orderGroup -> {
            List<Order> orders = orderGroup.getOrderList()
                    .stream().filter(order -> ((order.getPaymentMethod() == 1 && order.getPaymentStatus() == 1)
                            || order.getPaymentMethod() == 0)
                            &&
                            ((order.getStatus() > OrderStatus.PROCESSING.ordinal() && order.getPackager().equals(staff))
                                    || (order.getStatus() == OrderStatus.PROCESSING.ordinal() && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS)))))
                    .toList();
            orderGroup.setOrderList(orders);
        });
        return orderGroups;
    }

    @Override
    public Map<UUID, List<OrderProductForPackage>> getProductOrderDetailAfterPackaging(UUID supermarketId, UUID pickupPointId, String staffEmail, Integer page, Integer size) throws ResourceNotFoundException {
        Staff staff = staffRepository.findByEmail(staffEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + staffEmail));
        Pageable pageable;
        pageable = PageRequest.of(page, size);

        List<OrderDetail> orderDetailList = orderDetailRepository.findOrderDetailsByOrderPackaging(staff.getPickupPoint(), pickupPointId, supermarketId, staff.getId(), pageable);
        List<OrderProductForPackage> orderProductForPackages = new ArrayList<>();
        orderDetailList.forEach(orderDetail -> orderDetail.getOrderDetailProductBatches().forEach(orderDetailProductBatch -> {
            ModelMapper mapper = new ModelMapper();
            OrderProductForPackage orderProductForPackage = new OrderProductForPackage();

            Product product = orderDetail.getProduct();
            mapper.map(product, orderProductForPackage);
            orderProductForPackage.setProductConsolidationArea(orderDetail.getOrder().getProductConsolidationArea());
            orderProductForPackage.setBoughtQuantity(orderDetailProductBatch.getBoughtQuantity());
            orderProductForPackage.setExpiredDate(orderDetailProductBatch.getProductBatch().getExpiredDate());
            orderProductForPackage.setSupermarketAddress(orderDetailProductBatch.getProductBatch().getSupermarketAddress());

            OrderPackaging orderPackaging = new OrderPackaging();
            mapper.map(orderDetail.getOrder(), orderPackaging);
            orderProductForPackage.setOrderPackage(orderPackaging);

            List<String> productImageList = new ArrayList<>();
            orderDetail.getProduct().getProductImageList().forEach(image -> {
                String imageUrl = image.getImageUrl();
                productImageList.add((imageUrl));
            });
            orderProductForPackage.setImageUrlImageList(productImageList);
            orderProductForPackages.add(orderProductForPackage);
        }));

        Map<UUID, List<OrderProductForPackage>> productWithAddress;
        productWithAddress = orderProductForPackages.stream()
                .collect(Collectors.groupingBy(
                        orderProduct -> orderProduct.getSupermarketAddress().getId()
                ));

        return productWithAddress;
    }

    @Override
    public List<Order> fetchOrdersForCustomer(String jwtToken,
                                              String totalPriceSortType,
                                              String createdTimeSortType,
                                              String deliveryDateSortType,
                                              OrderStatus orderStatus,
                                              Boolean isPaid,
                                              int page,
                                              int limit) throws FirebaseAuthException {
        return repository.findOrderForCustomer(
                Utils.getCustomerEmail(jwtToken, firebaseAuth),
                orderStatus == null ? null : orderStatus.ordinal(),
                isPaid,
                getPageableWithSort(totalPriceSortType, createdTimeSortType, deliveryDateSortType, page, limit));
    }

    @Override
    public List<OrderBatch> fetchOrderBatches(String staffEmail, UUID timeFrameId, Integer status, Boolean getOldOrderBatch, SortType deliverDateSortType, LocalDate deliveryDate, UUID delivererID) throws ResourceNotFoundException {
        Sort sortable = null;

        if (deliverDateSortType != null) {
            if (deliverDateSortType.equals(SortType.ASC)) {
                sortable = Sort.by("deliverDate").ascending();
            } else {
                sortable = Sort.by("deliverDate").descending();
            }
        }
        Staff staff = staffRepository.findByEmail(staffEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + staffEmail));
        List<Staff> staffManaged = staff.getDeliverStaffList();
        List<OrderBatch> orderBatches = orderBatchRepository.findByDistrictOrDeliverDate(
                timeFrameId,
                getOldOrderBatch,
                deliveryDate,
                delivererID,
                sortable);
        if (status != null) {
            orderBatches.forEach(orderBatch -> {
                List<Order> orderFilter = orderBatch.getOrderList()
                        .stream()
                        .filter(order -> order.getStatus().equals(status)
                                &&
                                ((order.getStatus() < OrderStatus.DELIVERING.ordinal()) || (order.getStatus() > OrderStatus.PACKAGED.ordinal() && staff.getRole().equals(StaffRole.STAFF_DLV_0.toString()))
                                        || ((order.getStatus() > OrderStatus.PACKAGED.ordinal() && staff.getRole().equals(StaffRole.STAFF_DLV_1.toString())) && staffManaged.stream().anyMatch(staff1 -> staff1.equals(order.getDeliverer())))
                                )
                        ).toList();
                orderBatch.setOrderList(orderFilter);
            });
            return orderBatches.stream().filter(orderBatch -> orderBatch.getOrderList().size() > 0).toList();
        }
        return orderBatches;
    }

    @Override
    public String confirmPackaging(UUID orderId, String staffEmail, UUID productConsolidationAreaId) throws IOException, ResourceNotFoundException, InterruptedException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy đơn hàng với ID " + orderId));
        RLock rLock = redissonClient.getFairLock(orderId.toString());
        boolean res = rLock.tryLock(5, 10, TimeUnit.SECONDS);
        if (res) {
            try {
                rLock.lock();
                Staff staff = staffRepository.findByEmail(staffEmail).orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nhân viên với email: " + staffEmail));
                ProductConsolidationArea productConsolidationArea = productConsolidationAreaRepository.findById(productConsolidationAreaId)
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy điểm tập kết với ID: " + productConsolidationAreaId));
                Configuration configuration = configurationRepository.findAll().get(0);
                if (order.getPackager() == null && order.getStatus() == 0 && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS))) {
                    order.setPackager(staff);
                    order.setProductConsolidationArea(productConsolidationArea);
                    order.setStatus(OrderStatus.PACKAGING.ordinal());
                    repository.save(order);
                    FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đang tiến hành đóng gói!", order.getCustomer().getId().toString());
                } else {
                    throw new IllegalArgumentException("Đơn hàng này đang được đóng gói bởi nhân viên khác!");
                }
            } finally {
                rLock.unlock();
            }
        } else {
            throw new IllegalArgumentException("Đơn hàng này đang được đóng gói bởi nhân viên khác!");
        }
        return "Đơn hàng này đã được nhận đóng gói thành công!";
    }

    @Override
    @Transactional
    public String editProductConsolidationArea(UUID orderId, UUID productConsolidationAreaId) throws ResourceNotFoundException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy đơn hàng với ID " + orderId));
        ProductConsolidationArea productConsolidationArea = productConsolidationAreaRepository.findById(productConsolidationAreaId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy điểm tập kết với ID: " + productConsolidationAreaId));
        if (order.getProductConsolidationArea() != null && order.getStatus() == OrderStatus.PACKAGING.ordinal()) {
            order.setProductConsolidationArea(productConsolidationArea);
        } else {
            return "Đơn hàng này chưa được nhận đóng gói nên không thể sửa điểm tập kết!";
        }
        return "Đơn hàng này đã sửa điểm tập kết thành công!";
    }

    @Override
    public String confirmPackagingGroup(UUID orderGroupId, String staffEmail, UUID productConsolidationAreaId) throws NoSuchOrderException, IOException, ResourceNotFoundException, InterruptedException {
        OrderGroup orderGroup = orderGroupRepository.findById(orderGroupId)
                .orElseThrow(() -> new NoSuchOrderException("Không tìm thấy nhóm đơn hàng với ID " + orderGroupId));
        Staff staff = staffRepository.findByEmail(staffEmail).orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nhân viên với email: " + staffEmail));
        RLock rLock = redissonClient.getFairLock(orderGroup.getId().toString());
        boolean res = rLock.tryLock(10, 10, TimeUnit.SECONDS);
        if (res) {
            try {
                rLock.lock();
                if (orderGroup.getProductConsolidationArea() != null) {
                    List<Order> orderProcessingList = orderGroup.getOrderList().stream().filter(order -> order.getStatus() == 0).toList();
                    if (orderProcessingList.size() == 0) {
                        throw new IllegalArgumentException("Nhóm đơn hàng này không còn đơn hàng nào đang chờ xác nhận!");
                    }
                    for (Order order : orderProcessingList) {
                        Configuration configuration = configurationRepository.findAll().get(0);
                        if (order.getPackager() == null && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS)) && (order.getPaymentMethod() == 0 || (order.getPaymentMethod() == 1 && order.getPaymentStatus() == 1))) {
                            order.setPackager(staff);
                            order.setProductConsolidationArea(orderGroup.getProductConsolidationArea());
                            order.setStatus(OrderStatus.PACKAGING.ordinal());
                            repository.save(order);
                            FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đang tiến hành đóng gói!", order.getCustomer().getId().toString());
                        } else {
                            throw new IllegalArgumentException("Nhóm đơn hàng này đang được đóng gói bởi nhân viên khác!");
                        }
                    }
                } else {
                    ProductConsolidationArea productConsolidationArea = productConsolidationAreaRepository.findById(productConsolidationAreaId)
                            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy điểm tập kết với ID: " + productConsolidationAreaId));
                    orderGroup.setProductConsolidationArea(productConsolidationArea);
                    for (Order order : orderGroup.getOrderList().stream().filter(order -> order.getStatus() == 0).toList()) {
                        Configuration configuration = configurationRepository.findAll().get(0);
                        if (order.getPackager() == null && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS)) && (order.getPaymentMethod() == 0 || (order.getPaymentMethod() == 1 && order.getPaymentStatus() == 1))) {
                            order.setPackager(staff);
                            order.setProductConsolidationArea(productConsolidationArea);
                            order.setStatus(OrderStatus.PACKAGING.ordinal());
                            repository.save(order);
                            FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đang tiến hành đóng gói!", order.getCustomer().getId().toString());
                        } else {
                            throw new IllegalArgumentException("Nhóm đơn hàng này đang được đóng gói bởi nhân viên khác!");
                        }
                    }
                }
            } finally {
                rLock.unlock();
            }
        } else {
            throw new IllegalArgumentException("Nhóm đơn hàng này đang được đóng gói bởi nhân viên khác!");
        }
        return "Nhóm đơn hàng này đã được nhận đóng gói thành công!";
    }

    @Override
    @Transactional
    public String editProductConsolidationAreaGroup(UUID orderGroupId, UUID productConsolidationAreaId) throws NoSuchOrderException, ResourceNotFoundException {
        OrderGroup orderGroup = orderGroupRepository.findById(orderGroupId)
                .orElseThrow(() -> new NoSuchOrderException("Không tìm thấy nhóm đơn hàng với ID " + orderGroupId));
        ProductConsolidationArea productConsolidationArea = productConsolidationAreaRepository.findById(productConsolidationAreaId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy điểm tập kết với ID: " + productConsolidationAreaId));
        for (Order order : orderGroup.getOrderList()) {
            order.setProductConsolidationArea(productConsolidationArea);
        }
        return "Nhóm đơn hàng này đã được thay đổi điểm tập kết thành công!";
    }

    @Override
    @Transactional
    public String confirmPackagedGroup(UUID orderGroupId, String staffEmail) throws NoSuchOrderException, IOException, ResourceNotFoundException {
        OrderGroup orderGroup = orderGroupRepository.findById(orderGroupId)
                .orElseThrow(() -> new NoSuchOrderException("Không tìm thấy nhóm đơn hàng với ID " + orderGroupId));
        Staff staff = staffRepository.findByEmail(staffEmail).orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nhân viên với email: " + staffEmail));
        for (Order order : orderGroup.getOrderList().stream().filter(order -> order.getStatus() == 1).toList()) {
            if (orderGroup.getDeliverer() != null) {
                order.setDeliverer(orderGroup.getDeliverer());
//                order.setPackager(staff);
                order.setStatus(OrderStatus.DELIVERING.ordinal());
                FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đã hoàn thành giai đoạn đóng gói!", order.getCustomer().getId().toString());
            } else {
                order.setPackager(staff);
                order.setStatus(OrderStatus.PACKAGED.ordinal());
                FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đã hoàn thành giai đoạn đóng gói!", order.getCustomer().getId().toString());
            }
        }
        FirebaseService.sendPushNotification("SHM", "Có nhóm đơn hàng mới đã đóng gói xong cần được giao!", "MANAGER_NOTIFICATION");
        return "Nhóm đơn hàng này đã được nhận đóng gói thành công!";
    }

    @Override
    @Transactional
    public String confirmPackaged(UUID orderId, String staffEmail) throws NoSuchOrderException, IOException, ResourceNotFoundException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        Staff staff = staffRepository.findByEmail(staffEmail).orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nhân viên với email: " + staffEmail));
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_ORD.toString())) {
            if (order.getStatus() == OrderStatus.PACKAGING.ordinal()) {
                order.setPackager(staff);
                order.setStatus(OrderStatus.PACKAGED.ordinal());
                FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đã hoàn thành giai đoạn đóng gói!", order.getCustomer().getId().toString());
                FirebaseService.sendPushNotification("SHM", "Có đơn hàng mới đã đóng gói xong cần được giao!", "MANAGER_NOTIFICATION");
            } else {
                return "Đơn hàng này chưa được nhận đóng gói (PACKAGING)!";
            }
        } else {
            return "Nhân viên này không phải là nhân Viên ĐÓNG GÓI!";
        }
        return "Đơn hàng này đã đóng gói xong!";
    }

    @Override
    @Transactional
    public String confirmSucceeded(UUID orderId, String staffEmail) throws IOException, NoSuchOrderException, ResourceNotFoundException {
        Staff staff = staffRepository.findByEmail(staffEmail).orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nhân viên với email: " + staffEmail));
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        if (order.getDeliveryDate().toLocalDate().equals(LocalDate.now()) && order.getDeliverer().equals(staff) && order.getStatus() == OrderStatus.DELIVERING.ordinal()) {
            order.setStatus(OrderStatus.SUCCESS.ordinal());
            FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đã được giao thành công! Hãy đánh giá dịch vụ của chúng tôi để đóng góp xây dưng hệ thống tốt hơn!", order.getCustomer().getId().toString());
        } else {
            if (!order.getDeliveryDate().toLocalDate().equals(LocalDate.now())) {
                return "Đơn hàng này chưa tới ngày giao!";
            } else if (!order.getDeliverer().equals(staff)) {
                return "Nhân viên này không trùng với nhân viên được giao cho đơn hàng này!";
            } else if (order.getStatus() != OrderStatus.DELIVERING.ordinal()) {
                return "Đơn hàng này đã được !";
            }
        }
        return "Đơn hàng này xác nhận giao thành công!";
    }

    @Override
    @Transactional
    public String confirmFail(UUID orderId, String staffEmail) throws IOException, NoSuchOrderException, ResourceNotFoundException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        Staff staff = staffRepository.findByEmail(staffEmail).orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy nhân viên với email: " + staffEmail));
        if (order.getDeliverer().getId().equals(staff.getId())) {
            if(order.getDeliveryDate().toLocalDate().equals(LocalDate.now())){
                order.setPackager(staff);
                order.setStatus(OrderStatus.FAIL.ordinal());
                FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " đã không thể giao! Bạn vui lòng liên hệ nhân viên để được hỗ trợ giao lại!", order.getCustomer().getId().toString());
            } else {
                return "Đơn hàng này chưa tới ngày giao!";
            }
        } else {
            return "Không phải nhân viên giao hàng này đảm nhận!";
        }
        return "Đơn hàng xác nhận giao thất bại!";
    }

    @Override
    public String assignDeliverToOrderGroupOrBatch(String emailManager, UUID orderGroupId, UUID orderBatchId, UUID staffId) throws NoSuchOrderException, ConflictGroupAndBatchException, IOException, ResourceNotFoundException, InterruptedException {
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new ResourceNotFoundException("No staff found with this id " + staffId));
        Staff manager = staffRepository.findByEmail(emailManager).orElseThrow(() -> new ResourceNotFoundException("No manager found with this id " + staffId));
        if (!manager.getDeliverStaffList().stream().anyMatch(staff1 -> staff1.equals(staff))) {
            throw new IllegalArgumentException("Nhân viên này không trong quyền quản lý của bạn!");
        }
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_DLV_0.toString())) {
            if (orderGroupId != null && orderBatchId == null) {
                OrderGroup orderGroup = orderGroupRepository.findById(orderGroupId)
                        .orElseThrow(() -> new NoSuchOrderException("No group found with this group id " + orderGroupId));
                RLock rLock = redissonClient.getFairLock(orderGroup.getId().toString());
                boolean res = rLock.tryLock(10, 10, TimeUnit.SECONDS);
                if (res) {
                    try {
                        rLock.lock();
                        for (Order order : orderGroup.getOrderList()) {
                            if (order.getStatus() == OrderStatus.PACKAGED.ordinal()) {
                                order.setDeliverer(staff);
                                order.setStatus(OrderStatus.DELIVERING.ordinal());
                                FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " chuẩn bị được giao!", order.getCustomer().getId().toString());
                            } else if (order.getStatus() == OrderStatus.DELIVERING.ordinal() && manager.getDeliverStaffList().stream().anyMatch(staff1 -> staff1.equals(order.getDeliverer()))) {
                                order.setDeliverer(staff);
                            } else {
                                throw new IllegalArgumentException("Nhóm đơn hàng này đã được quản lý bởi quản lý khác!");
                            }
                            repository.save(order);
                        }
                        orderGroup.setDeliverer(staff);
                        orderGroupRepository.save(orderGroup);
                    } finally {
                        rLock.unlock();
                    }
                } else {
                    throw new IllegalArgumentException("Nhóm đơn hàng này đang được quản lý bởi quản lý khác!");
                }
            } else if (orderGroupId == null && orderBatchId != null) {
                OrderBatch orderBatch = orderBatchRepository.findById(orderBatchId)
                        .orElseThrow(() -> new NoSuchOrderException("No batch found with this batch id " + orderBatchId));
                RLock rLock = redissonClient.getFairLock(orderBatch.getId().toString());
                boolean res = rLock.tryLock(10, 10, TimeUnit.SECONDS);
                if (res) {
                    try {
                        rLock.lock();
                        for (Order order : orderBatch.getOrderList()) {
                            if (order.getStatus() == OrderStatus.PACKAGED.ordinal()) {
                                order.setStatus(OrderStatus.DELIVERING.ordinal());
                                order.setDeliverer(staff);
                                FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " chuẩn bị được giao!", order.getCustomer().getId().toString());
                            } else if (order.getStatus() == OrderStatus.DELIVERING.ordinal() && manager.getDeliverStaffList().stream().anyMatch(staff1 -> staff1.equals(order.getDeliverer()))) {
                                order.setDeliverer(staff);
                            } else {
                                throw new IllegalArgumentException("Nhóm đơn hàng này đã được quản lý bởi quản lý khác!");
                            }
                            repository.save(order);
                        }
                        orderBatch.setDeliverer(staff);
                        orderBatchRepository.save(orderBatch);
                    } finally {
                        rLock.unlock();
                    }
                } else {
                    throw new IllegalArgumentException("Nhóm đơn hàng này đang được quản lý bởi quản lý khác!");
                }
            } else {
                throw new ConflictGroupAndBatchException("Group or batch must be specified");
            }
        } else {
            return "Staff with id" + staffId + "is not DELIVERER STAFF";
        }

        return "Nhóm được phân công cho nhân viên " + staff.getFullName() + " thành công!";
    }

    @Override
    public String assignDeliverToOrder(String emailManager, UUID orderId, UUID staffId) throws ResourceNotFoundException, IOException, InterruptedException {
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new ResourceNotFoundException("No staff found with this id " + staffId));
        Staff manager = staffRepository.findByEmail(emailManager).orElseThrow(() -> new ResourceNotFoundException("No manager found with this email " + emailManager));
        if (!manager.getDeliverStaffList().stream().anyMatch(staff1 -> staff1.equals(staff))) {
            throw new IllegalArgumentException("Nhân viên này không trong quyền quản lý của bạn!");
        }
        Order order = repository.findById(orderId).orElseThrow(() -> new ResourceNotFoundException("No order found with this id " + orderId));
        RLock rLock = redissonClient.getFairLock(order.getId().toString());
        boolean res = rLock.tryLock(5, 10, TimeUnit.SECONDS);
        if (res) {
            try {
                rLock.lock();
                if (order.getStatus() == OrderStatus.DELIVERING.ordinal() && manager.getDeliverStaffList().stream().anyMatch(staff1 -> staff1.equals(order.getDeliverer()))) {
                    order.setDeliverer(staff);
                    repository.save(order);
                } else if (order.getStatus() == OrderStatus.PACKAGED.ordinal()) {
                    order.setDeliverer(staff);
                    order.setStatus(OrderStatus.DELIVERING.ordinal());
                    repository.save(order);
                    FirebaseService.sendPushNotification("SHM", "Đơn hàng " + order.getCode() + " chuẩn bị được giao!", order.getCustomer().getId().toString());
                } else {
                    throw new IllegalArgumentException("Đơn hàng này đã được quản lý bởi người khác!");
                }
            } finally {
                rLock.unlock();
            }
        } else {
            throw new IllegalArgumentException("Đơn hàng này đang được quản lý bởi quản lý khác!");
        }

        return "Nhân viên " + staff.getFullName() + " được phân công giao hàng thành công!";
    }

    @Override
    public List<Order> fetchOrdersForStaff(String staffEmail,
                                           UUID timeFrameId,
                                           String totalPriceSortType,
                                           String createdTimeSortType,
                                           String deliveryDateSortType,
                                           Boolean getOldOrder,
                                           Date deliveryDate,
                                           OrderStatus orderStatus,
                                           UUID packagerId,
                                           UUID delivererId,
                                           Boolean isPaid,
                                           Boolean isGrouped,
                                           Boolean isBatched,
                                           int page,
                                           int limit) throws ResourceNotFoundException {
        Configuration configuration = configurationRepository.findAll().get(0);
        Staff staff = staffRepository.findByEmail(staffEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + staffEmail));
        List<Staff> staffManaged = staff.getDeliverStaffList();
        return repository.findOrderForStaff(
                        staffManaged,
                        getOldOrder,
                        deliveryDate,
                        packagerId,
                        delivererId,
                        timeFrameId,
                        orderStatus == null ? null : orderStatus.ordinal(),
                        isGrouped,
                        isBatched,
                        isPaid,
                        getPageableWithSort(totalPriceSortType,
                                createdTimeSortType,
                                deliveryDateSortType,
                                page,
                                limit)
                ).stream()
                .filter(order -> order.getStatus() > OrderStatus.PROCESSING.ordinal() ||
                        (order.getStatus() == OrderStatus.PROCESSING.ordinal()
                                && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS)))).toList();
    }

    @Override
    public List<Order> fetchOrdersForPackageStaff(String totalPriceSortType,
                                                  String createdTimeSortType,
                                                  String deliveryDateSortType,
                                                  Boolean getOldOrder,
                                                  UUID pickupPointId,
                                                  UUID timeFrameId,
                                                  Date deliveryDate,
                                                  OrderStatus orderStatus,
                                                  String email,
                                                  Boolean isPaid,
                                                  DeliveryMethod deliveryMethod,
                                                  int page,
                                                  int limit) throws ResourceNotFoundException {
        Staff staff = staffRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + email));
        List<PickupPoint> pickupPointListOfStaff = staff.getPickupPoint();
        Configuration configuration = configurationRepository.findAll().get(0);
        return repository.findOrderForPackageStaff(
                        staff.getId(),
                        pickupPointId,
                        timeFrameId,
                        deliveryDate,
                        getOldOrder,
                        pickupPointListOfStaff,
                        orderStatus == null ? null : orderStatus.ordinal(),
                        deliveryMethod.ordinal(),
                        isPaid,
                        getPageableWithSort(totalPriceSortType,
                                createdTimeSortType,
                                deliveryDateSortType,
                                page,
                                limit)
                ).stream()
                .filter(order -> order.getStatus() > OrderStatus.PROCESSING.ordinal() ||
                        (order.getStatus() == OrderStatus.PROCESSING.ordinal()
                                && LocalDateTime.now().isAfter(order.getCreatedTime().plus(configuration.getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS)))).toList();

    }

    @Override
    public OrderWithDetails fetchOrderDetail(UUID id) throws ResourceNotFoundException {
        log.info("Fetching order detail of order_id " + id);
        Order order = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("No order with id " + id));

        OrderWithDetails orderWithDetails = new OrderWithDetails();
        orderWithDetails.setId(order.getId());
        orderWithDetails.setCode(order.getCode());
        orderWithDetails.setReceiverName(order.getReceiverName());
        orderWithDetails.setReceiverPhone(order.getReceiverPhone());
        orderWithDetails.setQrCodeUrl(order.getQrCodeUrl());
        orderWithDetails.setTotalPrice(order.getTotalPrice());
        orderWithDetails.setCreatedTime(order.getCreatedTime());
        orderWithDetails.setAddressDeliver(order.getAddressDeliver());
        orderWithDetails.setTotalDiscountPrice(order.getTotalDiscountPrice());
        orderWithDetails.setDeliveryDate(order.getDeliveryDate());
        orderWithDetails.setCustomer(order.getCustomer());
        orderWithDetails.setPaymentStatus(order.getPaymentStatus());
        orderWithDetails.setPaymentMethod(order.getPaymentMethod());
        orderWithDetails.setShippingFee(order.getShippingFee());
        orderWithDetails.setStatus(order.getStatus());
        orderWithDetails.setTransaction(order.getTransaction());
        orderWithDetails.setTimeFrame(order.getTimeFrame());
        orderWithDetails.setPickupPoint(order.getPickupPoint());
        orderWithDetails.setIsFeedback(order.getIsFeedBack());

        List<OrderDetail> orderDetails = order.getOrderDetailList();
        List<OrderProduct> orderProducts = orderDetails.stream()
                .map(o -> {
                    //Map product to model orderProduct
                    OrderProduct orderProduct = new OrderProduct();
                    orderProduct.setId(o.getId());
                    orderProduct.setProductPrice(o.getProductPrice());
                    orderProduct.setProductOriginalPrice(o.getProductOriginalPrice());
                    orderProduct.setBoughtQuantity(o.getBoughtQuantity());

                    Product product = o.getProduct();
                    orderProduct.setName(product.getName());
                    orderProduct.setUnit(product.getUnit());
                    orderProduct.setImages(product.getProductImageList());
                    orderProduct.setDescription(product.getDescription());
                    orderProduct.setProductSubCategory(product.getProductSubCategory().getName());
                    orderProduct.setProductCategory(product.getProductSubCategory().getProductCategory().getName());
                    orderProduct.setStatus(product.getStatus());

                    List<OrderProductBatch> orderProductBatches = new ArrayList<>();
                    List<OrderDetailProductBatch> orderDetailProductBatches = o.getOrderDetailProductBatches();
                    for (OrderDetailProductBatch orderDetail_productBatch : orderDetailProductBatches) {
                        OrderProductBatch orderProductBatch = new OrderProductBatch();
                        orderProductBatch.setSupermarketName(orderDetail_productBatch.getProductBatch().getSupermarketAddress().getSupermarket().getName());
                        orderProductBatch.setSupermarketAddress(orderDetail_productBatch.getProductBatch().getSupermarketAddress().getAddress());
                        orderProductBatch.setBoughtQuantity(orderDetail_productBatch.getBoughtQuantity());
                        orderProductBatch.setExpiredDate(orderDetail_productBatch.getProductBatch().getExpiredDate());
                        orderProductBatches.add(orderProductBatch);
                    }
                    orderProduct.setOrderDetailProductBatches(orderProductBatches);
                    return orderProduct;
                }).toList();
        orderWithDetails.setOrderDetailList(orderProducts);
        return orderWithDetails;
    }

    @Override
    public String cancelOrder(String jwtToken, UUID id) throws ResourceNotFoundException, OrderCancellationNotAllowedException, FirebaseAuthException, IOException {
        String email = Utils.getCustomerEmail(jwtToken, firebaseAuth);
        Customer customer = customerRepository
                .findByEmail(email)
                .orElseThrow(() -> new AuthorizationServiceException("Access denied with this account: " + email));
        if (customer == null) {
            return "Fail to canceled order " + id;
        }
        Order order = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("No order with id " + id));
        if (order.getCreatedTime().isBefore(LocalDateTime.now().plus(systemConfigurationService.getConfiguration().getTimeAllowedForOrderCancellation(), ChronoUnit.HOURS))) {
            if (order.getOrderGroup() != null) {
                order.setOrderGroup(null);
            }

            if (order.getOrderBatch() != null) {
                order.setOrderBatch(null);
            }

            if (order.getStatus() == OrderStatus.PROCESSING.ordinal()) {
                order.setStatus(OrderStatus.CANCEL.ordinal());
                List<OrderDetail> orderDetails = order.getOrderDetailList();
                increaseProductQuantity(orderDetails);
                List<Discount> discounts = order.getDiscountList();
                if (discounts != null && discounts.size() > 0) {
                    increaseDiscountQuantity(order.getDiscountList());
                }
            } else {
                throw new OrderCancellationNotAllowedException("Order with id " + id + " is already in " + order.getStatus().toString() + " process");
            }
            repository.save(order);
        } else {
            throw new OrderCancellationNotAllowedException("Đơn hàng đã quá thời gian huỷ cho phép là " + systemConfigurationService.getConfiguration().getTimeAllowedForOrderCancellation() + " tiếng kể từ khi đặt hàng!");
        }

        return "Successfully canceled order " + id;
    }

    @Override
    public String cancelPackageOrder(UUID id, String staffEmail) throws ResourceNotFoundException, OrderCancellationNotAllowedException {
        Staff staff = staffRepository.findByEmail(staffEmail)
                .orElseThrow(() -> new ResourceNotFoundException("No staff with id " + staffEmail));
        Order order = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("No order with id " + id));

        if (order.getOrderGroup() != null) {
            order.setOrderGroup(null);
        }

        if (order.getOrderBatch() != null) {
            order.setOrderBatch(null);
        }

        if (order.getStatus() == OrderStatus.PROCESSING.ordinal() || order.getStatus() == OrderStatus.PACKAGING.ordinal()) {
            order.setStatus(OrderStatus.CANCEL.ordinal());
            order.setPackager(staff);
            List<OrderDetail> orderDetails = order.getOrderDetailList();
            increaseProductQuantity(orderDetails);
            List<Discount> discounts = order.getDiscountList();
            if (discounts != null && discounts.size() > 0) {
                increaseDiscountQuantity(order.getDiscountList());
            }
        } else {
            throw new OrderCancellationNotAllowedException("Order with id " + id + " is already in " + order.getStatus().toString() + " process");
        }
        repository.save(order);
        return "Successfully canceled order " + id;
    }

    @Override
    @Transactional
    public String deleteOrder(String jwtToken, UUID id) throws FirebaseAuthException, ResourceNotFoundException, OrderDeletionNotAllowedException {
        String email = Utils.getCustomerEmail(jwtToken, firebaseAuth);
        Customer customer = customerRepository
                .findByEmail(email)
                .orElseThrow(() -> new AuthorizationServiceException("Access denied with this account: " + email));
        if (customer == null) {
            return "Fail to delete order " + id;
        }
        Order order = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("No order with id " + id));

        if (order.getOrderGroup() != null) {
            order.setOrderGroup(null);
        }

        if (order.getOrderBatch() != null) {
            order.setOrderBatch(null);
        }

        if (order.getStatus() == OrderStatus.PROCESSING.ordinal()) {
            List<OrderDetail> orderDetails = order.getOrderDetailList();
            increaseProductQuantity(orderDetails);
            if (order.getDiscountList() != null & order.getDiscountList().size() > 0) {
                increaseDiscountQuantity(order.getDiscountList());
            }

        } else {
            throw new OrderDeletionNotAllowedException("Order with id " + id + " is already in " + order.getStatus().toString() + " process");
        }
        repository.deleteById(order.getId());
        return "Successfully deleted  order " + id;
    }

    @Override
    @Transactional
    public String deleteOrderWithoutAuthen(UUID id) throws ResourceNotFoundException, OrderDeletionNotAllowedException {
        Order order = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("No order with id " + id));

        if (order.getOrderGroup() != null) {
            order.setOrderGroup(null);
        }

        if (order.getOrderBatch() != null) {
            order.setOrderBatch(null);
        }

        if (order.getStatus() == OrderStatus.PROCESSING.ordinal()) {
            List<OrderDetail> orderDetails = order.getOrderDetailList();
            increaseProductQuantity(orderDetails);
            if (order.getDiscountList() != null & order.getDiscountList().size() > 0) {
                increaseDiscountQuantity(order.getDiscountList());
            }

        } else {
            throw new OrderDeletionNotAllowedException("Order with id " + id + " is already in " + order.getStatus().toString() + " process");
        }
        repository.deleteById(order.getId());
        return "Successfully deleted  order " + id;
    }

    @Override
    public List<OrderBatch> batchingForStaff(Date deliverDate, UUID timeFrameId, Integer batchQuantity, UUID productConsolidationAreaId) throws ResourceNotFoundException {
//        TimeFrame timeFrame = timeFrameRepository.findById(timeFrameId)
//                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy time-frame với id: " + timeFrameId));
//
//        List<Order> ordersWithoutGroups = repository.findOrderWithoutGroups(timeFrame, deliverDate);
//
//        int MIN_POINTS = batchQuantity; // Minimum number of points for a cluster
//
//        // Define the epsilon (ε) value in degrees for a 10 km radius
//        double epsilonInDegrees = 0.0897;
//
//        // Create a DBSCAN clusterer with the specified epsilon and distance measure
//        DBSCANClusterer<Order> clusterer = new DBSCANClusterer<>(epsilonInDegrees, MIN_POINTS, new DistanceMeasure() {
//            @Override
//            public double compute(double[] doubles, double[] doubles1) throws DimensionMismatchException {
//                return 0;
//            }
//        });
//        // Perform clustering
//        List<Cluster<Order>> clusters = clusterer.cluster(ordersWithoutGroups);
//
//        List<OrderBatch> orderBatches = new ArrayList<>();
//        // Process the clusters as needed
//        for (Cluster<Order> cluster : clusters) {
//            List<Order> clusterOrders = cluster.getPoints();
//            OrderBatch orderBatch = new OrderBatch();
//            orderBatch.setOrderList(clusterOrders);
//            orderBatches.add(orderBatch);
//            // Handle each cluster of orders
//        }
//
//        return orderBatches;
        TimeFrame timeFrame = timeFrameRepository.findById(timeFrameId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy time-frame với id: " + timeFrameId));
        ProductConsolidationArea productConsolidationArea = productConsolidationAreaRepository.findById(productConsolidationAreaId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy product-consolidation-area với id: " + productConsolidationAreaId));
        List<Order> ordersWithoutGroups = repository.findOrderWithoutGroups(timeFrame.getId(), deliverDate, productConsolidationArea.getId());
//        List<Order> dummies = new ArrayList<>();
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Group 1-1 predict (Gan vinhome)").receiverPhone("0972779175").latitude((float) 10.82658).longitude((float) 106.82865).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Group 1-2 predict (Gan vinhome)").receiverPhone("0972779175").latitude((float) 10.84717).longitude((float) 106.83026).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Group 1-3 predict (Gan vinhome)").receiverPhone("0972779175").latitude((float) 10.82806).longitude((float) 106.83131).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Group 2-1 predit (Le van viet gan truong)").receiverPhone("0972779175").latitude((float) 10.84549).longitude((float) 106.79671).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Group 2-2 predit (Le van viet gan truong)").receiverPhone("0972779175").latitude((float) 10.84148).longitude((float) 106.81005).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Group 2-3 or 3 predit (xa lo hn)").receiverPhone("0972779175").latitude((float) 10.83598).longitude((float) 106.76767).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Duplicate 1-2").receiverPhone("0972779175").latitude((float) 10.84717).longitude((float) 106.83026).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("30a Ấp 7, Xuân Thới Thượng, Hóc Môn, Thành phố Hồ Chí Minh, Việt Nam").receiverPhone("0972779175").latitude((float) 10.8419923).longitude((float) 106.5866278).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("Đường Bà Điểm 4/21 Ấp Tiền Lân, Tiền Lân, Hóc Môn, Thành phố Hồ Chí Minh, Việt Nam").receiverPhone("0972779175").latitude((float) 10.8419923).longitude((float) 106.5866278).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("5/15V XTT4, Bà Điểm, Hóc Môn, Thành phố Hồ Chí Minh 71700, Việt Nam").receiverPhone("0972779175").latitude((float) 10.8393158).longitude((float) 106.5853618).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("311 Tân Kỳ Tân Quý, Tân Sơn Nhì, Tân Phú, Thành phố Hồ Chí Minh, Việt Nam").receiverPhone("0972779175").latitude((float) 10.80004).longitude((float) 106.6227574).status(OrderStatus.PROCESSING.ordinal()).build());
//        dummies.add(Order.builder().id(UUID.randomUUID()).totalPrice(10000).totalDiscountPrice(200).shippingFee(3000).createdTime(LocalDateTime.now()).deliveryDate(Date.valueOf("2023-10-19")).paymentMethod(PaymentMethod.COD.ordinal()).paymentStatus(PaymentStatus.UNPAID.ordinal()).addressDeliver("155 Nguyễn Cửu Đàm, Tân Sơn Nhì, Tân Phú, Thành phố Hồ Chí Minh 700000, Việt Nam").receiverPhone("0972779175").latitude((float) 10.80004).longitude((float) 106.6227574).status(OrderStatus.PROCESSING.ordinal()).build());


        List<OrderBatch> orderBatchList = new ArrayList<>();
        if (ordersWithoutGroups.size() > 0) {
            List<Record> records = new ArrayList<>();

            for (Order order : ordersWithoutGroups) {
                Record record = new Record();
                record.setOrder(order);
                record.setFeatures(Map.of("latitude", order.getLatitude().doubleValue(), "longitude", order.getLongitude().doubleValue()));
                records.add(record);
            }

            Map<Centroid, List<Record>> clusters = KMeans.fit(records, batchQuantity, new HaversineDistance(), 100);


            for (Map.Entry<Centroid, List<Record>> cluster : clusters.entrySet()) {
                OrderBatch orderBatch = new OrderBatch();
                orderBatch.setDeliverDate(deliverDate.toLocalDate());
                orderBatch.setTimeFrame(timeFrame);
                orderBatch.setOrderList(cluster.getValue().stream().map(Record::getOrder).collect(Collectors.toList()));
                orderBatchList.add(orderBatch);
            }
        }


        return orderBatchList;
    }


    // GOONG IMPLEMENT

    @Override
    public ShippingFeeDetailResponseBody getShippingFeeDetail(Double latitude, Double longitude, UUID pickupPointId) throws IOException {
//        int numberOfSuggestion = 3;
        Optional<PickupPoint> pickupPoint = pickupPointRepository.findById(pickupPointId);
        if (pickupPoint.isEmpty()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.PICKUP_POINT_NOT_FOUND.getCode()), AdditionalResponseCode.PICKUP_POINT_NOT_FOUND.toString());
        }
        Configuration configuration = systemConfigurationService.getConfiguration();
//        PickupPointSuggestionResponseBody closetPickupPoint;
        Integer shippingFee = configuration.getInitialShippingFee();
//        List<PickupPoint> pickupPoints = pickupPointRepository.getAllSortByDistance(latitude, longitude);
//        List<PickupPointSuggestionResponseBody> pickupPointSuggestionResponseBodyList = new ArrayList<>();
        List<LatLngModel> destinations = new ArrayList<>();
        destinations.add(new LatLngModel(pickupPoint.get().getLatitude(), pickupPoint.get().getLongitude()));
        LatLngModel origin = new LatLngModel(latitude, longitude);
        PickupPointSuggestionResponseBody pickupPointSuggestionResult = new PickupPointSuggestionResponseBody(pickupPoint.get());

//        for (PickupPoint pickupPoint : pickupPoints) {
//            // using 0 because pickup point at index 0 will be deleted and next index will be 0
//            pickupPointSuggestionResponseBodyList.add(new PickupPointSuggestionResponseBody(pickupPoint));
//            destinations.add(new LatLngModel(pickupPoint.getLatitude().doubleValue(), pickupPoint.getLongitude().doubleValue()));
//        }

        // fetch goong api
        String apiKeyParam = "api_key=" + goongApiKey;
        String vehicleParam = "vehicle=bike";
        String originParam = "origins=" + origin;
        String destinationParam = "destinations=" + destinations.stream().map(LatLngModel::toString).collect(Collectors.joining("%7C"));
        String goongMatrixDistanceRequest = goongDistanceMatrixUrl + "?" + originParam + "&" + destinationParam + "&" + vehicleParam + "&" + apiKeyParam;
        RestTemplate restTemplate = new RestTemplate();
        URI goongMatrixDistanceRequestURI = URI.create(goongMatrixDistanceRequest);
        GoongDistanceMatrixResult goongDistanceMatrixResult = restTemplate.getForObject(goongMatrixDistanceRequestURI, GoongDistanceMatrixResult.class);


        for (GoongDistanceMatrixRow goongDistanceMatrixRow : goongDistanceMatrixResult.getRows()) {
//            int i = 0;
            for (GoongDistanceMatrixElement goongDistanceMatrixElement : goongDistanceMatrixRow.getElements()) {
                pickupPointSuggestionResult.setDistance(goongDistanceMatrixElement.getDistance().getText());
                pickupPointSuggestionResult.setDistanceInValue(goongDistanceMatrixElement.getDistance().getValue());
//                pickupPointSuggestionResponseBodyList.get(i).setDistance(goongDistanceMatrixElement.getDistance().getText());
//                pickupPointSuggestionResponseBodyList.get(i).setDistanceInValue(goongDistanceMatrixElement.getDistance().getValue());
//                i++;
            }
        }

//        pickupPointSuggestionResponseBodyList.sort((o1, o2) -> (int) (o1.getDistanceInValue() - o2.getDistanceInValue()));

//        closetPickupPoint = pickupPointSuggestionResponseBodyList.get(0);

        // convert m to km
//        int distance = closetPickupPoint.getDistanceInValue().intValue() / 1000;
        int distance = pickupPointSuggestionResult.getDistanceInValue().intValue() / 1000;

        if (distance > configuration.getMinKmDistanceForExtraShippingFee()) {
            shippingFee += (distance - 2) * configuration.getExtraShippingFeePerKilometer();
        }

        ShippingFeeDetailResponseBody shippingFeeDetailResponseBody = new ShippingFeeDetailResponseBody();
        shippingFeeDetailResponseBody.setClosestPickupPoint(pickupPointSuggestionResult);
        shippingFeeDetailResponseBody.setShippingFee(shippingFee);

        return shippingFeeDetailResponseBody;
    }

    @Override
    @Transactional
    public Order editDeliverDate(UUID orderId, Date deliverDate) throws ResourceNotFoundException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id " + orderId));
        order.getOrderDetailList().forEach(orderDetail -> orderDetail.getOrderDetailProductBatches().forEach(productBatch -> {
            LocalDate expDateOrderProduct = productBatch.getProductBatch().getExpiredDate();
            if (deliverDate.toLocalDate().isAfter(expDateOrderProduct)) {
                LinkedHashMap<String, String> errorFieldsFile = new LinkedHashMap<>();
                errorFieldsFile.put("Lỗi sản phẩm quá hạn khi thay đổi ngày giao " + deliverDate, "Sản phẩm " + orderDetail.getProduct().getName() + " trong đơn hàng có lô HSD: " + expDateOrderProduct + "!");
                throw new InvalidExcelFileDataException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFieldsFile);
            }
        }));
        order.setDeliveryDate(deliverDate);
        order.setStatus(OrderStatus.PACKAGED.ordinal());
        order.setDeliverer(null);
        if (order.getDeliveryMethod() == DeliveryMethod.PICKUP_POINT.ordinal()) {
            OrderGroup group;
            Optional<OrderGroup> orderGroup = orderGroupRepository
                    .findByTimeFrameIdAndPickupPointIdAndDeliverDate(
                            order.getTimeFrame().getId(),
                            order.getPickupPoint().getId(),
                            order.getDeliveryDate().toLocalDate()
                    );
            if (orderGroup.isPresent()) {
                group = orderGroup.get();
                if(group.getProductConsolidationArea() != null){
                    order.setProductConsolidationArea(group.getProductConsolidationArea());
                }
            } else {
                OrderGroup orderGroupNew = new OrderGroup();
                orderGroupNew.setTimeFrame(timeFrameRepository.findById(order.getTimeFrame().getId())
                        .orElseThrow(() -> new ResourceNotFoundException("No time-frame found with id " + order.getTimeFrame().getId())));
                orderGroupNew.setPickupPoint(pickupPointRepository.findById(order.getPickupPoint().getId())
                        .orElseThrow(() -> new ResourceNotFoundException("No pick-up point found with id " + order.getPickupPoint().getId())));
                orderGroupNew.setDeliverDate(order.getDeliveryDate().toLocalDate());
                orderGroupNew.setProductConsolidationArea(order.getProductConsolidationArea());
                group = orderGroupRepository.save(orderGroupNew);
            }
            order.setOrderGroup(group);
        } else {
            order.setOrderBatch(null);
        }
        return order;
    }

//    @Override
//    public Order chooseConsolidationArea(UUID orderId, UUID consolidationAreaId) throws ResourceNotFoundException {
//        Order order = repository.findById(orderId)
//                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id " + orderId));
//        ProductConsolidationArea productConsolidationArea = productConsolidationAreaRepository.findById(consolidationAreaId)
//                .orElseThrow(() -> new ResourceNotFoundException("ConsolidationArea not found with id " + consolidationAreaId));
//        if (order.getPickupPoint().getProductConsolidationAreaList().stream().anyMatch(pca -> pca.equals(productConsolidationArea))) {
//            order.setProductConsolidationArea(productConsolidationArea);
//        } else {
//            throw new ResourceNotFoundException("Điểm tập kết không tìm thấy trong danh sách các điểm tập kết của pickup point trong đơn hàng!");
//        }
//        return order;
//    }

    @Override
    public ReportOrdersResponse getReportOrders(OrderReportMode mode, LocalDate startDate, LocalDate endDate, Integer month, Integer year) {
        ReportOrdersResponse reportOrdersResponse = new ReportOrdersResponse();
        switch (mode) {
            case ALL -> {
                List<Object[]> resultDate = repository.getOrdersReportByDay(startDate != null ? startDate.atStartOfDay() : null, endDate != null ? endDate.atTime(LocalTime.MAX) : null, month, year);
                List<OrderReport> reportListDate = new ArrayList<>();
                for (Object[] row : resultDate) {
                    Date reportDate = (Date) row[0];
                    Long processingCount = (Long) row[1];
                    Long packagingCount = (Long) row[2];
                    Long packagedCount = (Long) row[3];
                    Long deliveringCount = (Long) row[4];
                    Long successCount = (Long) row[5];
                    Long failCount = (Long) row[6];
                    Long cancelCount = (Long) row[7];

                    if (processingCount > 0 || packagingCount > 0 || packagedCount > 0 || deliveringCount > 0 || successCount > 0 || failCount > 0 || cancelCount > 0) {
                        OrderReport report = new OrderReport(reportDate, processingCount, packagingCount, packagedCount, deliveringCount, successCount, failCount, cancelCount);
                        reportListDate.add(report);
                    }
                }

                List<Object[]> resultMonth = repository.getOrdersReportByMonth(month, year);
                LinkedHashMap<Integer, List<OrderReportMonth>> reportListMonth = new LinkedHashMap<>();
                for (Object[] row : resultMonth) {
                    Integer yearResult = (Integer) row[0];
                    List<OrderReportMonth> listForYear = reportListMonth.get(yearResult);

                    int monthResult = (int) row[1];
                    Long successCount = (Long) row[2];
                    Long failCount = (Long) row[3];
                    Long cancelCount = (Long) row[4];

                    if (successCount > 0 || failCount > 0 || cancelCount > 0) {
                        if (listForYear == null) {
                            listForYear = new ArrayList<>();
                            OrderReportMonth report = new OrderReportMonth(monthResult, successCount, failCount, cancelCount);
                            listForYear.add(report);
                            reportListMonth.put(yearResult, listForYear);
                        } else {
                            OrderReportMonth report = new OrderReportMonth(monthResult, successCount, failCount, cancelCount);
                            listForYear.add(report);
                            listForYear.sort(Comparator.comparing(OrderReportMonth::getMonth));
                            reportListMonth.put(yearResult, listForYear);
                        }
                    }
                }

                List<Object[]> resultYear = repository.getOrdersReportByYear(year);
                List<OrderReportYear> reportListYear = new ArrayList<>();
                for (Object[] row : resultYear) {
                    int yearResult = (int) row[0];
                    Long successCount = (Long) row[1];
                    Long failCount = (Long) row[2];
                    Long cancelCount = (Long) row[3];
                    if (successCount > 0 || failCount > 0 || cancelCount > 0) {
                        OrderReportYear report = new OrderReportYear(yearResult, successCount, failCount, cancelCount);
                        reportListYear.add(report);
                    }
                }

                reportListDate.sort(Comparator.comparing(OrderReport::getDate));
                reportListYear.sort(Comparator.comparing(OrderReportYear::getYear));
                reportOrdersResponse.setOrdersReportByDay(reportListDate);
                reportOrdersResponse.setOrdersReportByMonth(reportListMonth);
                reportOrdersResponse.setOrdersReportByYear(reportListYear);
            }
            case DATE -> {
                List<Object[]> resultDate = repository.getOrdersReportByDay(startDate != null ? startDate.atStartOfDay() : null, endDate != null ? endDate.atTime(LocalTime.MAX) : null, month, year);
                List<OrderReport> reportListDate = new ArrayList<>();
                for (Object[] row : resultDate) {
                    Date reportDate = (Date) row[0];
                    Long processingCount = (Long) row[1];
                    Long packagingCount = (Long) row[2];
                    Long packagedCount = (Long) row[3];
                    Long deliveringCount = (Long) row[4];
                    Long successCount = (Long) row[5];
                    Long failCount = (Long) row[6];
                    Long cancelCount = (Long) row[7];

                    if (processingCount > 0 || packagingCount > 0 || packagedCount > 0 || deliveringCount > 0 || successCount > 0 || failCount > 0 || cancelCount > 0) {
                        OrderReport report = new OrderReport(reportDate, processingCount, packagingCount, packagedCount, deliveringCount, successCount, failCount, cancelCount);
                        reportListDate.add(report);
                    }
                }
                reportListDate.sort(Comparator.comparing(OrderReport::getDate));
                reportOrdersResponse.setOrdersReportByDay(reportListDate);
            }
            case MONTH -> {
                List<Object[]> resultMonth = repository.getOrdersReportByMonth(month, year);
                LinkedHashMap<Integer, List<OrderReportMonth>> reportListMonth = new LinkedHashMap<>();
                for (Object[] row : resultMonth) {
                    Integer yearResult = (Integer) row[0];
                    List<OrderReportMonth> listForYear = reportListMonth.get(yearResult);

                    int monthResult = (int) row[1];
                    Long successCount = (Long) row[2];
                    Long failCount = (Long) row[3];
                    Long cancelCount = (Long) row[4];

                    if (successCount > 0 || failCount > 0 || cancelCount > 0) {
                        if (listForYear == null) {
                            listForYear = new ArrayList<>();
                            OrderReportMonth report = new OrderReportMonth(monthResult, successCount, failCount, cancelCount);
                            listForYear.add(report);
                            reportListMonth.put(yearResult, listForYear);
                        } else {
                            OrderReportMonth report = new OrderReportMonth(monthResult, successCount, failCount, cancelCount);
                            listForYear.add(report);
                            listForYear.sort(Comparator.comparing(OrderReportMonth::getMonth));
                            reportListMonth.put(yearResult, listForYear);
                        }
                    }
                }
                reportOrdersResponse.setOrdersReportByMonth(reportListMonth);
            }
            case YEAR -> {
                List<Object[]> resultYear = repository.getOrdersReportByYear(year);
                List<OrderReportYear> reportListYear = new ArrayList<>();
                for (Object[] row : resultYear) {
                    int yearResult = (int) row[0];
                    Long successCount = (Long) row[1];
                    Long failCount = (Long) row[2];
                    Long cancelCount = (Long) row[3];
                    if (successCount > 0 || failCount > 0 || cancelCount > 0) {
                        OrderReportYear report = new OrderReportYear(yearResult, successCount, failCount, cancelCount);
                        reportListYear.add(report);
                    }
                }
                reportListYear.sort(Comparator.comparing(OrderReportYear::getYear));
                reportOrdersResponse.setOrdersReportByYear(reportListYear);
            }
        }

        return reportOrdersResponse;
    }

    @Override
    @Transactional
    public List<OrderBatch> createBatches(List<OrderBatchCreateBody> orderBatchCreateBodyList) throws InterruptedException {
        List<OrderBatch> orderBatchList = new ArrayList<>();
        if (orderBatchCreateBodyList.size() > 0) {
            RLock rLock = redissonClient.getFairLock(orderBatchCreateBodyList.get(0).getDeliverDate().toString()+","+orderBatchCreateBodyList.get(0).getTimeFrameId()+","+orderBatchCreateBodyList.get(0).getProductConsolidationAreaId());
            boolean res = rLock.tryLock(0, 25, TimeUnit.SECONDS);
            if (res) {
                try {
                    HashMap<String, String> errorFields = new HashMap<>();
                    for (OrderBatchCreateBody orderBatchCreateBody : orderBatchCreateBodyList) {
                        if (errorFields.size() > 0) {
                            break;
                        }

                        Optional<TimeFrame> timeFrame = timeFrameRepository.findTimeFrameActiveById(orderBatchCreateBody.getTimeFrameId());
                        if (timeFrame.isEmpty()) {
                            errorFields.put("timeFrameIdError", "No time frame id " + orderBatchCreateBody.getTimeFrameId() + " found");
                        }

                        Optional<ProductConsolidationArea> productConsolidationArea = productConsolidationAreaRepository.findConsolidationAreaActiveById(orderBatchCreateBody.getProductConsolidationAreaId());
                        if (productConsolidationArea.isEmpty()) {
                            errorFields.put("productConsolidationAreaIdError", "No product consolidation area id" + orderBatchCreateBody.getProductConsolidationAreaId() + " found");
                        }

                        if (orderBatchCreateBody.getDeliverDate().isBefore(LocalDate.now())) {
                            errorFields.put("deliverDateError", "Date value must be equal or after current date");
                        }

                        List<Order> orderTrackList = new ArrayList<>();
                        if (!errorFields.containsKey("timeFrameIdError") && !errorFields.containsKey("deliverDateError")) {
                            orderTrackList = repository.findOrderByIdListWithDeliveredStatus(orderBatchCreateBody.getOrderIdList(), timeFrame.get().getId(), Date.valueOf(orderBatchCreateBody.getDeliverDate()));
                            HashMap<UUID, Order> orderTrackHashMap = new HashMap<>();
                            orderTrackList.forEach(order -> orderTrackHashMap.put(order.getId(), order));
                            List<UUID> orderIdNotFoundList = new ArrayList<>();
                            for (UUID orderId : orderBatchCreateBody.getOrderIdList()) {
                                if (!orderTrackHashMap.containsKey(orderId)) {
                                    orderIdNotFoundList.add(orderId);
                                }
                            }
                            if (orderIdNotFoundList.size() > 0) {
                                errorFields.put("orderIdListError", "Order ids '" + orderIdNotFoundList.stream().map(Objects::toString).collect(Collectors.joining(",")) + "' not found or not meet condition");
                            }
                        }

                        if (errorFields.size() > 0) {
                            throw new InvalidInputException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
                        }

                        Double averageLatitude = orderTrackList.size() > 0 ? (orderTrackList.stream().mapToDouble(order -> order.getLatitude()).sum() / orderTrackList.size()) : 0;
                        Double averageLongitude = orderTrackList.size() > 0 ? (orderTrackList.stream().mapToDouble(order -> order.getLongitude()).sum() / orderTrackList.size()) : 0;

                        OrderBatch orderBatch = new OrderBatch();
                        orderBatch.setDeliverDate(orderBatchCreateBody.getDeliverDate());
                        orderBatch.setTimeFrame(timeFrame.get());
                        orderBatch.setProductConsolidationArea(productConsolidationArea.get());
                        orderBatch.setAverageLatitude(averageLatitude);
                        orderBatch.setAverageLongitude(averageLongitude);
                        orderBatch.setOrderList(orderTrackList);
                        for (Order order : orderTrackList) {
                            order.setOrderBatch(orderBatch);
                        }
                        orderBatchList.add(orderBatchRepository.save(orderBatch));
                    }
                } finally {
                    rLock.unlock();
                }
            } else {
                throw new ConflictException(HttpStatus.valueOf(AdditionalResponseCode.BATCHING_CONFLICT.getCode()), AdditionalResponseCode.BATCHING_CONFLICT.toString());
            }

        }
        return orderBatchList;
    }

    @Override
    public DeliverManagerReport getDeliverManagerDailyReport(UUID deliverManagerId, LocalDate reportDate) {
        if (reportDate == null) {
            reportDate = LocalDate.now();
        }
        Optional<Staff> deliverManager = staffRepository.findById(deliverManagerId);
        if (!deliverManager.isPresent()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.STAFF_NOT_FOUND.getCode()), AdditionalResponseCode.STAFF_NOT_FOUND.toString());
        }

        Long successDeliveredOrder = Long.parseLong("0");
        Long failDeliveredOrder = Long.parseLong("0");
        Long packagedOrder = Long.parseLong("0");
        Long deliveringOrder = Long.parseLong("0");

        List<Object[]> reportOrderForManager = repository.getDailyReportOrderForManager(reportDate);
        for (Object[] result : reportOrderForManager) {
            successDeliveredOrder = (Long) result[1];
            failDeliveredOrder = (Long) result[2];
            packagedOrder = (Long) result[3];
            deliveringOrder = (Long) result[4];
        }

        List<DeliverReport> deliverReportList = deliverManager.get().getDeliverStaffList().stream().map(DeliverReport::new).collect(Collectors.toList());

        for (DeliverReport deliverReport : deliverReportList) {
            List<Object[]> reportOrderForDeliverStaff = repository.getDailyReportOrderDeliverStaff(deliverReport.getStaff().getId(), reportDate);
            for (Object[] result : reportOrderForDeliverStaff) {
                deliverReport.setSuccessDeliveredOrder((Long) result[1]);
                deliverReport.setFailDeliveredOrder((Long) result[2]);
                deliverReport.setDeliveringOrder((Long) result[3]);
                deliverReport.setAssignedOrder((Long) result[4]);
            }
        }

        return new DeliverManagerReport(successDeliveredOrder, failDeliveredOrder, packagedOrder, deliveringOrder, deliverReportList);
    }

    @Override
    public DeliverManagerReport getDeliverManagerReport(UUID deliverManagerId, Integer year, Month month) {

        Optional<Staff> deliverManager = staffRepository.findById(deliverManagerId);
        if (!deliverManager.isPresent()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.STAFF_NOT_FOUND.getCode()), AdditionalResponseCode.STAFF_NOT_FOUND.toString());
        }

        Long successDeliveredOrder = Long.parseLong("0");
        Long failDeliveredOrder = Long.parseLong("0");
        Long packagedOrder = Long.parseLong("0");
        Long deliveringOrder = Long.parseLong("0");

        List<Object[]> reportOrderForManager = repository.getReportOrderForManager(year, month == null ? null : month.getMonthInNumber());
        for (Object[] result : reportOrderForManager) {
            successDeliveredOrder = result[0] == null ? 0 : (Long) result[0];
            failDeliveredOrder = result[1] == null ? 0 : (Long) result[1];
            packagedOrder = result[2] == null ? 0 : (Long) result[2];
            deliveringOrder = result[3] == null ? 0 : (Long) result[3];
        }

        List<DeliverReport> deliverReportList = deliverManager.get().getDeliverStaffList().stream().map(DeliverReport::new).collect(Collectors.toList());

        for (DeliverReport deliverReport : deliverReportList) {
            List<Object[]> reportOrderForDeliverStaff = repository.getReportOrderDeliverStaff(deliverReport.getStaff().getId(), year, month == null ? null : month.getMonthInNumber());
            for (Object[] result : reportOrderForDeliverStaff) {
                deliverReport.setSuccessDeliveredOrder((Long) result[1]);
                deliverReport.setFailDeliveredOrder((Long) result[2]);
                deliverReport.setDeliveringOrder((Long) result[3]);
                deliverReport.setAssignedOrder((Long) result[4]);
            }
        }

        return new DeliverManagerReport(successDeliveredOrder, failDeliveredOrder, packagedOrder, deliveringOrder, deliverReportList);
    }

    @Override
    public String printOrderPackaging(UUID orderId, String staffEmail) throws ResourceNotFoundException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id " + orderId));

        try (ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream()) {
            com.itextpdf.text.Document pdfDocument = new com.itextpdf.text.Document();
            PdfWriter.getInstance(pdfDocument, byteArrayOutputStream);

            pdfDocument.open();

            int titleFontSize = 36;
            int bodyFontSize = 28;
            String fontFamilyBody = new ClassPathResource("AndikaNewBasic-R.ttf").getURL().toExternalForm();

            // Add content to the iText PDF document directly
            addParagraph(pdfDocument, "Mã đơn hàng: " + order.getId().toString(), titleFontSize, fontFamilyBody, true);
            addParagraph(pdfDocument, "Địa chỉ giao: " + order.getAddressDeliver(), bodyFontSize, fontFamilyBody, false);
            addParagraph(pdfDocument, "Khung giờ giao: " + order.getTimeFrame().getFromHour() + " đến " + order.getTimeFrame().getToHour(), bodyFontSize, fontFamilyBody, false);
            addParagraph(pdfDocument, "Ngày giao: " + order.getDeliveryDate(), bodyFontSize, fontFamilyBody, false);
            addParagraph(pdfDocument, "Tên KH: " + order.getReceiverName(), bodyFontSize, fontFamilyBody, false);
            addParagraph(pdfDocument, "SĐT: " + order.getReceiverPhone(), bodyFontSize, fontFamilyBody, false);

            // Create a Locale for Vietnam
            Locale locale = new Locale("vi", "VN");

            // Create a NumberFormat for the currency
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(locale);
            addParagraph(pdfDocument, "Tổng tiền: " + currencyFormat.format(order.getTotalPrice()) + "đ", bodyFontSize, fontFamilyBody, false);

            pdfDocument.close();

            // Save the document to a byte array
            return FirebaseService.uploadPdfToStorage(byteArrayOutputStream, orderId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static void addParagraph(com.itextpdf.text.Document document, String text, int fontSize, String fontFamily, boolean bold) throws DocumentException, IOException {
        BaseFont baseFont = BaseFont.createFont(fontFamily, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        Font font = new Font(baseFont, fontSize);

        if (bold) {
            font.setStyle(Font.BOLD);
        }

        Paragraph paragraph = new Paragraph(new Chunk(text, font));
        document.add(paragraph);
    }

    // GOOGLE MAP IMPLEMENT
//    @Override
//    public ShippingFeeDetailResponseBody getShippingFeeDetail(Double latitude, Double longitude) throws IOException, InterruptedException, ApiException {
//        int numberOfClosestPickupPointPicked = 3;
//        PickupPointSuggestionResponseBody closetPickupPoint;
//        Integer shippingFee = 10000;
//        List<PickupPoint> pickupPoints = pickupPointRepository.getAllSortByDistance(latitude, longitude);
//        List<PickupPointSuggestionResponseBody> pickupPointSuggestionResponseBodyList = new ArrayList<>();
//        List<LatLng> latLngs = new ArrayList<>();
//        for(int i = 0; i < numberOfClosestPickupPointPicked; i++) {
//            pickupPointSuggestionResponseBodyList.add(new PickupPointSuggestionResponseBody(pickupPoints.get(i)));
//            latLngs.add(new LatLng(pickupPoints.get(i).getLatitude(), pickupPoints.get(i).getLongitude()));
//        }
//
//        DistanceMatrixApiRequest req = DistanceMatrixApi.newRequest(geoApiContext);
//        DistanceMatrix distanceMatrix = req
//                .origins(new LatLng(latitude, longitude))
//                .destinations(
//                        latLngs.toArray(new LatLng[numberOfClosestPickupPointPicked])
//                )
//                .await();
//
//        Iterator distanceMatrixRowsIterator = Arrays.stream(distanceMatrix.rows).iterator();
//        if (distanceMatrixRowsIterator.hasNext()){
//            int i = 0;
//            DistanceMatrixRow distanceMatrixRow = (DistanceMatrixRow) distanceMatrixRowsIterator.next();
//            Iterator distanceMatrixElementsIterator = Arrays.stream(distanceMatrixRow.elements).iterator();
//            while (distanceMatrixElementsIterator.hasNext()){
//                DistanceMatrixElement distanceMatrixElement = (DistanceMatrixElement) distanceMatrixElementsIterator.next();
//                pickupPointSuggestionResponseBodyList.get(i).setDistance(distanceMatrixElement.distance.humanReadable);
//                pickupPointSuggestionResponseBodyList.get(i).setDistanceInValue(distanceMatrixElement.distance.inMeters);
//                i++;
//            }
//        }
//
//        pickupPointSuggestionResponseBodyList.sort((o1, o2) -> (int) (o1.getDistanceInValue() - o2.getDistanceInValue()));
//
//        closetPickupPoint = pickupPointSuggestionResponseBodyList.get(0);
//
//        // convert m to km
//        int distance = closetPickupPoint.getDistanceInValue().intValue() / 1000;
//
//        if(distance > 2) {
//            shippingFee += (distance - 2)*1000;
//        }
//
//        ShippingFeeDetailResponseBody shippingFeeDetailResponseBody = new ShippingFeeDetailResponseBody();
//        shippingFeeDetailResponseBody.setClosestPickupPoint(closetPickupPoint);
//        shippingFeeDetailResponseBody.setShippingFee(shippingFee);
//
//        return shippingFeeDetailResponseBody;
//    }

    @Override
    public Order createOrder(String jwtToken, OrderCreate orderCreate) throws Exception {
        log.info("Creating new order");
        String email = Utils.getCustomerEmail(jwtToken, firebaseAuth);
        Customer customer = customerRepository
                .findByEmail(email)
                .orElseThrow(() -> new AuthorizationServiceException("Access denied with this account: " + email));
        Order orderCreated = null;
        if (repository.getOrdersProcessing(customer.getEmail()).size() < systemConfigurationService.getConfiguration().getLimitOfOrders()) {
            RLock rLock = redissonClient.getFairLock("createOrderLock");
            boolean res = rLock.tryLock(100, 10, TimeUnit.SECONDS);
            if (res) {
                try {
                    orderCreated = createOrderTransact(orderCreate, customer);
                } finally {
                    rLock.unlock();
                }
            }
        } else {
            throw new CustomerLimitOrderProcessingException("Bạn hiện đang có 3 đơn hàng đang chờ xác nhận!");
        }

        if (orderCreated.getPaymentMethod() == PaymentMethod.VNPAY.ordinal()) {
            RMapCache<UUID, Object> map = redissonClient.getMapCache("orderCreatedMap");
            map.put(orderCreated.getId(), 0, (systemConfigurationService.getConfiguration().getDeleteUnpaidOrderTime() * 60) + 1, TimeUnit.MINUTES);
        }

        return orderCreated;
    }

    @Transactional(rollbackFor = {ResourceNotFoundException.class, InterruptedException.class, IOException.class, OutOfProductQuantityException.class})
    Order createOrderTransact(OrderCreate orderCreate, Customer customer) throws ResourceNotFoundException, InterruptedException, IOException, OutOfProductQuantityException {
        Order order = setOrderData(orderCreate, customer);

        if (orderCreate.getDeliveryMethod().equals(DeliveryMethod.PICKUP_POINT)) {
            groupingOrder(order, orderCreate);
        }

        List<OrderDetail> orderDetails = getOrderDetails(order, orderCreate);
        order.setOrderDetailList(orderDetails);
        mapDiscountsToOrder(order, orderCreate.getDiscountID());
        Order orderSaved = repository.save(order);

        mapTransactionToOrder(orderSaved, orderCreate.getTransaction());
        String qrCodeUrl = generateAndUploadQRCode(orderSaved);
        orderSaved.setQrCodeUrl(qrCodeUrl);
        orderSaved.setCode(generateOrderCode(orderSaved.getCreatedTime()));

        return repository.save(orderSaved);
    }

    private Order setOrderData(OrderCreate orderCreate, Customer customer) throws ResourceNotFoundException {
        Order order = new Order();
        order.setCustomer(customer);
        order.setReceiverName(orderCreate.getReceiverName());
        order.setReceiverPhone(orderCreate.getReceiverPhone());
        order.setShippingFee(orderCreate.getShippingFee());
        order.setTotalPrice(orderCreate.getTotalPrice());
        order.setDeliveryMethod(orderCreate.getDeliveryMethod().ordinal());
        order.setTotalDiscountPrice(orderCreate.getTotalDiscountPrice());
        order.setDeliveryDate(Date.valueOf(orderCreate.getDeliveryDate()));
        order.setPaymentStatus(orderCreate.getPaymentStatus().ordinal());
        order.setStatus(OrderStatus.PROCESSING.ordinal());
        order.setPaymentMethod(orderCreate.getPaymentMethod());
        order.setAddressDeliver(orderCreate.getAddressDeliver());
        order.setLongitude(orderCreate.getLongitude());
        order.setLatitude(orderCreate.getLatitude());
        order.setCreatedTime(LocalDateTime.now());
        order.setPickupPoint(pickupPointRepository.findById(orderCreate.getPickupPointId())
                .orElseThrow(() -> new ResourceNotFoundException("No pick-up point found with id " + orderCreate.getPickupPointId())));
        order.setTimeFrame(timeFrameRepository.findById(orderCreate.getTimeFrameId())
                .orElseThrow(() -> new ResourceNotFoundException("Time frame không tìm thấy với id: " + orderCreate.getTimeFrameId())));
        return order;
    }

    private void groupingOrder(Order order, OrderCreate orderCreate) throws ResourceNotFoundException {
        OrderGroup group;
        Optional<OrderGroup> orderGroup = orderGroupRepository
                .findByTimeFrameIdAndPickupPointIdAndDeliverDate(
                        orderCreate.getTimeFrameId(),
                        orderCreate.getPickupPointId(),
                        orderCreate.getDeliveryDate()
                );
        if (orderGroup.isPresent()) {
            group = orderGroup.get();
        } else {
            OrderGroup orderGroupNew = createNewOrderGroup(orderCreate);
            group = orderGroupRepository.save(orderGroupNew);
        }
        order.setOrderGroup(group);
    }

    private OrderGroup createNewOrderGroup(OrderCreate orderCreate) throws ResourceNotFoundException {
        OrderGroup orderGroupNew = new OrderGroup();
        orderGroupNew.setTimeFrame(timeFrameRepository.findById(orderCreate.getTimeFrameId())
                .orElseThrow(() -> new ResourceNotFoundException("No time-frame found with id " + orderCreate.getTimeFrameId())));
        orderGroupNew.setPickupPoint(pickupPointRepository.findById(orderCreate.getPickupPointId())
                .orElseThrow(() -> new ResourceNotFoundException("No pick-up point found with id " + orderCreate.getPickupPointId())));
        orderGroupNew.setDeliverDate(orderCreate.getDeliveryDate());
        return orderGroupNew;
    }

    private void mapDiscountsToOrder(Order order, List<UUID> discountIds) throws ResourceNotFoundException, OutOfProductQuantityException {
        if (!discountIds.isEmpty()) {
            List<Discount> discounts = new ArrayList<>();
            for (UUID discountId : discountIds) {
                Discount discount = discountRepository
                        .findById(discountId)
                        .orElseThrow(() -> new ResourceNotFoundException("Discount not found with id" + discountId));
                decrementDiscountQuantity(discount);
                discounts.add(discount);
            }
            order.setDiscountList(discounts);
        }
    }

    private void decrementDiscountQuantity(Discount discount) throws OutOfProductQuantityException {
        Integer quantity = discount.getQuantity();
        if (discount.getQuantity() == 0) {
            throw new OutOfProductQuantityException(discount.getName() + "đã hết lượt sử dụng!");
        } else {
            discount.setQuantity(quantity - 1);
        }
    }

    private String generateAndUploadQRCode(Order order) throws IOException {
        ByteArrayOutputStream qrCode = generateQRCodeImage(order.getId());
        return FirebaseService.uploadQRCodeToStorage(qrCode, order.getId());
    }

    private void mapTransactionToOrder(Order order, Transaction transaction) {
        List<Transaction> transactions = new ArrayList<>();
        transactions.add(transaction);
        order.setTransaction(transactions);
    }

    private List<OrderDetail> getOrderDetails(Order order, OrderCreate orderCreate) throws OutOfProductQuantityException, ResourceNotFoundException {
        List<OrderDetail> orderDetails = new ArrayList<>();
        for (OrderProductCreate orderProductCreate : orderCreate.getOrderDetailList()) {
            OrderDetail orderDetail = mapOrderProductCreateToOrderDetail(order, orderProductCreate);
            orderDetails.add(orderDetail);
        }
        return orderDetails;
    }

    private OrderDetail mapOrderProductCreateToOrderDetail(Order order, OrderProductCreate orderProductCreate) throws OutOfProductQuantityException, ResourceNotFoundException {
        OrderDetail orderDetail = new OrderDetail();
        orderDetail.setOrder(order);
        orderDetail.setProductPrice(orderProductCreate.getProductPrice());
        orderDetail.setProductOriginalPrice(orderProductCreate.getProductOriginalPrice());
        orderDetail.setBoughtQuantity(orderProductCreate.getBoughtQuantity());
        Product product = productRepository.findById(orderProductCreate.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException("Sản phẩm không tìm thấy với id: " + orderProductCreate.getProductId()));
        orderDetail.setProduct(product);

        //get list of product's batch then sort ascending by quantity
        List<UUID> productBatchIds = orderProductCreate.getProductBatchIds();
        List<ProductBatch> productBatches = new ArrayList<>();
        for (UUID id : productBatchIds) {
            ProductBatch productBatch = productBatchRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Lô sản phẩm không tìm thấy với id: " + id));
            productBatches.add(productBatch);
        }
        productBatches.sort(Comparator.comparingInt(ProductBatch::getQuantity));

        //check if product batches total quantity is enough or not
        int totalQuantityOfProductBatches = productBatches.stream().mapToInt(ProductBatch::getQuantity).sum();
        int boughtQuantity = orderProductCreate.getBoughtQuantity();
        if (boughtQuantity > totalQuantityOfProductBatches) {
            throw new OutOfProductQuantityException(product.getName() + " HSD: " + productBatches.get(0).getExpiredDate() + " chỉ còn " + totalQuantityOfProductBatches + " sản phẩm!");
        }

        //decrease quantity of product's batch then persist orderDetailProductBatches
        List<OrderDetailProductBatch> orderDetailProductBatches = new ArrayList<>();
        for (ProductBatch productBatch : productBatches) {
            OrderDetailProductBatch orderDetailProductBatch = new OrderDetailProductBatch();

            if (boughtQuantity > 0 && boughtQuantity > productBatch.getQuantity()) {
                orderDetailProductBatch.setBoughtQuantity(productBatch.getQuantity());
                boughtQuantity -= productBatch.getQuantity();
                productBatch.setQuantity(0);

                orderDetailProductBatch.setProductBatch(productBatch);
                orderDetailProductBatch.setOrderDetail(orderDetail);
            } else if (boughtQuantity > 0 && boughtQuantity <= productBatch.getQuantity()) {
                orderDetailProductBatch.setBoughtQuantity(boughtQuantity);
                productBatch.setQuantity(productBatch.getQuantity() - boughtQuantity);
                boughtQuantity = 0;

                orderDetailProductBatch.setProductBatch(productBatch);
                orderDetailProductBatch.setOrderDetail(orderDetail);
            }
            orderDetailProductBatches.add(orderDetailProductBatch);
        }
        orderDetail.setOrderDetailProductBatches(orderDetailProductBatches);

        return orderDetail;
    }

    private Pageable getPageableWithSort(String totalPriceSortType, String createdTimeSortType, String deliveryDateSortType, int page, int limit) {
        Sort sortable = null;
        if (totalPriceSortType != null && totalPriceSortType.equals("ASC")) {
            sortable = Sort.by("totalPrice").ascending();
        } else if (totalPriceSortType != null && totalPriceSortType.equals("DESC")) {
            sortable = Sort.by("totalPrice").descending();
        } else if (createdTimeSortType != null && createdTimeSortType.equals("ASC")) {
            sortable = Sort.by("createdTime").ascending();
        } else if (createdTimeSortType != null && createdTimeSortType.equals("DESC")) {
            sortable = Sort.by("createdTime").descending();
        } else if (deliveryDateSortType != null && deliveryDateSortType.equals("ASC")) {
            sortable = Sort.by("deliveryDate").ascending();
        } else if (deliveryDateSortType != null && deliveryDateSortType.equals("DESC")) {
            sortable = Sort.by("deliveryDate").descending();
        }
        Pageable pageableWithSort;
        if (sortable != null) {
            pageableWithSort = PageRequest.of(page, limit, sortable);
        } else {
            pageableWithSort = PageRequest.of(page, limit);
        }

        return pageableWithSort;
    }

    private ByteArrayOutputStream generateQRCodeImage(UUID orderId) throws IOException {
        try {
            return QRCode.from(orderId.toString())
                    .withSize(200, 200)
                    .to(ImageType.PNG)
                    .stream();
        } catch (Exception e) {
            e.printStackTrace();
            throw new IOException("Error generating QR code");
        }
    }

    private void increaseProductQuantity(List<OrderDetail> orderDetails) {
        for (OrderDetail orderDetail : orderDetails) {
            List<OrderDetailProductBatch> orderDetailProductBatches = orderDetail.getOrderDetailProductBatches();
            orderDetailProductBatches.forEach(orderDetail_productBatch -> {
                ProductBatch productBatch = orderDetail_productBatch.getProductBatch();
                productBatch.setQuantity(productBatch.getQuantity() + orderDetail_productBatch.getBoughtQuantity());
                productBatchRepository.save(productBatch);
            });
        }
    }

    private void increaseDiscountQuantity(List<Discount> discounts) {
        for (Discount discount : discounts) {
            discount.setQuantity(discount.getQuantity() + 1);
            discountRepository.save(discount);
        }
    }
}
