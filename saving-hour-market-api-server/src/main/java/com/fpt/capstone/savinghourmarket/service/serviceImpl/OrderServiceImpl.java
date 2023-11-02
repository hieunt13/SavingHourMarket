package com.fpt.capstone.savinghourmarket.service.serviceImpl;

import com.fpt.capstone.savinghourmarket.common.*;
import com.fpt.capstone.savinghourmarket.entity.*;
import com.fpt.capstone.savinghourmarket.exception.*;
import com.fpt.capstone.savinghourmarket.model.*;
import com.fpt.capstone.savinghourmarket.repository.*;
import com.fpt.capstone.savinghourmarket.service.CustomerService;
import com.fpt.capstone.savinghourmarket.service.FirebaseService;
import com.fpt.capstone.savinghourmarket.service.OrderService;
import com.fpt.capstone.savinghourmarket.util.Utils;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.maps.GeoApiContext;
import com.google.maps.errors.ApiException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.glxn.qrgen.QRCode;
import net.glxn.qrgen.image.ImageType;
import org.redisson.api.RLock;
import org.redisson.api.RMapCache;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.AuthorizationServiceException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URI;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final FirebaseAuth firebaseAuth;

    private final GeoApiContext geoApiContext;

    private RedissonClient redissonClient;

    @Autowired
    public void setRedissonClient(RedissonClient redissonClient) {
        this.redissonClient = redissonClient;
    }

    @Autowired
    private OrderRepository repository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductBatchRepository productBatchRepository;

    @Autowired
    private OrderGroupRepository orderGroupRepository;

    @Autowired
    private OrderBatchRepository orderBatchRepository;

    @Autowired
    private TimeFrameRepository timeFrameRepository;

    @Autowired
    private PickupPointRepository pickupPointRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private DiscountRepository discountRepository;

//    private final ConfigurationRepository configurationRepository;

    @Value("${goong-api-key}")
    private String goongApiKey;
    @Value("${goong-distance-matrix-url}")
    private String goongDistanceMatrixUrl;

    @Override
    public List<OrderGroup> fetchOrderGroups(LocalDate deliverDate, UUID timeFrameId, UUID pickupPointId, UUID delivererId) throws NoSuchOrderException, FirebaseAuthException {
        List<OrderGroup> orderGroups = orderGroupRepository.findByTimeFrameOrPickupPointOrDeliverDate(timeFrameId, pickupPointId, delivererId, deliverDate);
        if (orderGroups.isEmpty()) {
            throw new NoSuchOrderException("No such order group left on system");
        }
        return orderGroups;
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
        List<Order> orders = repository.findOrderForCustomer(
                Utils.getCustomerEmail(jwtToken, firebaseAuth),
                orderStatus == null ? null : orderStatus.ordinal(),
                isPaid,
                getPageableWithSort(totalPriceSortType, createdTimeSortType, deliveryDateSortType, page, limit));
        return orders;
    }

    @Override
    public List<OrderBatch> fetchOrderBatches(District district, LocalDate deliveryDate, UUID delivererID) {
        List<OrderBatch> orderBatches = orderBatchRepository.findByDistrictOrDeliverDate(
                district != null ? district.getDistrictName() : null,
                deliveryDate,
                delivererID);
        return orderBatches;
    }

    @Override
    @Transactional
    public String confirmPackaging(UUID orderId, UUID staffId) throws NoSuchOrderException, IOException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new NoSuchElementException("Không tìm thấy nhân viên với ID: " + staffId));
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_ORD.toString())) {
            order.setPackager(staff);
            order.setStatus(OrderStatus.PACKAGING.ordinal());
            FirebaseService.sendPushNotification("SHM", "Đơn hàng đang tiến hành đóng gói!", order.getCustomer().getId().toString());
        } else {
            return "Nhân viên này không phải là nhân Viên ĐÓNG GÓI!";
        }
        return "Đơn hàng này đã được nhận đóng gói thành công!";
    }

    @Override
    @Transactional
    public String confirmPackaged(UUID orderId, UUID staffId) throws NoSuchOrderException, IOException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new NoSuchElementException("Không tìm thấy nhân viên với ID: " + staffId));
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_ORD.toString())) {
            order.setPackager(staff);
            order.setStatus(OrderStatus.PACKAGED.ordinal());
            FirebaseService.sendPushNotification("SHM", "Đơn hàng đã được đóng gói!", order.getCustomer().getId().toString());
        } else {
            return "Nhân viên này không phải là nhân Viên ĐÓNG GÓI!";
        }
        return "Đơn hàng này đã đóng gói xong!";
    }

    @Override
    public String confirmSucceeded(UUID orderId, UUID staffId) throws IOException, NoSuchOrderException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new NoSuchElementException("Không tìm thấy nhân viên với ID: " + staffId));
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_DLV_0.toString())) {
            order.setPackager(staff);
            order.setStatus(OrderStatus.SUCCESS.ordinal());
            FirebaseService.sendPushNotification("SHM", "Đơn hàng đã được giao thành công! Hãy đánh giá dịch vụ của chúng tôi để đóng góp xây dưng hệ thống tốt hơn!", order.getCustomer().getId().toString());
        } else {
            return "Nhân viên này không phải là nhân Viên GIAO HÀNG!";
        }
        return "Đơn hàng này đã giao thành công!";
    }

    @Override
    public String confirmFail(UUID orderId, UUID staffId) throws IOException, NoSuchOrderException {
        Order order = repository.findById(orderId)
                .orElseThrow(() -> new NoSuchOrderException("No order found with this id " + orderId));
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new NoSuchElementException("Không tìm thấy nhân viên với ID: " + staffId));
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_DLV_0.toString())) {
            order.setPackager(staff);
            order.setStatus(OrderStatus.FAIL.ordinal());
            FirebaseService.sendPushNotification("SHM", "Đơn hàng đã không thể giao! Bạn vui lòng liên hệ nhân viên để được hỗ trợ giao lại!", order.getCustomer().getId().toString());
        } else {
            return "Nhân viên này không phải là nhân Viên GIAO HÀNG!";
        }
        return "Đơn hàng này đã giao thành công!";
    }

    @Override
    public String assignDeliverToOrderGroupOrBatch(UUID orderGroupId, UUID orderBatchId, UUID staffId) throws NoSuchOrderException, ConflictGroupAndBatchException, IOException {
        Staff staff = staffRepository.findById(staffId).orElseThrow(() -> new NoSuchElementException("No staff found with this id " + staffId));
        if (staff.getRole().equalsIgnoreCase(StaffRole.STAFF_DLV_0.toString())) {
            if (orderGroupId != null && orderBatchId == null) {
                OrderGroup orderGroup = orderGroupRepository.findById(orderGroupId)
                        .orElseThrow(() -> new NoSuchOrderException("No group found with this group id " + orderGroupId));
                for (Order order : orderGroup.getOrderList()) {
                    if (order.getStatus() == OrderStatus.PACKAGED.ordinal()) {
                        order.setStatus(OrderStatus.DELIVERING.ordinal());
                        FirebaseService.sendPushNotification("SHM", "Đơn hàng chuẩn bị được giao!", order.getCustomer().getId().toString());
                    } else {
                        return "Đơn hàng " + order.getId() + " chưa được đóng gói!";
                    }
                }
                orderGroup.setDeliverer(staff);
            } else if (orderGroupId == null && orderBatchId != null) {
                OrderBatch orderBatch = orderBatchRepository.findById(orderBatchId)
                        .orElseThrow(() -> new NoSuchOrderException("No batch found with this batch id " + orderBatchId));
                for (Order order : orderBatch.getOrderList()) {
                    if (order.getStatus() == OrderStatus.PACKAGED.ordinal()) {
                        order.setStatus(OrderStatus.DELIVERING.ordinal());
                        FirebaseService.sendPushNotification("SHM", "Đơn hàng chuẩn bị được giao!", order.getCustomer().getId().toString());
                    } else {
                        return "Đơn hàng " + order.getId() + " chưa được đóng gói!";
                    }
                }
                orderBatch.setDeliverer(staff);
            } else {
                throw new ConflictGroupAndBatchException("Group or batch must be specified");
            }
        } else {
            return "Staff with id" + staffId + "is not DELIVERER LEVEL 0";
        }

        return "Staff with id" + staffId + "set successfully";
    }

    @Override
    public List<Order> fetchOrdersForStaff(String totalPriceSortType,
                                           String createdTimeSortType,
                                           String deliveryDateSortType,
                                           Date deliveryDate,
                                           OrderStatus orderStatus,
                                           UUID packagerId,
                                           UUID delivererId,
                                           Boolean isPaid,
                                           Boolean isGrouped,
                                           int page,
                                           int limit) {
        List<Order> orders = repository.findOrderForStaff(
                deliveryDate,
                packagerId,
                delivererId,
                orderStatus == null ? null : orderStatus.ordinal(),
                isGrouped,
                isPaid,
                getPageableWithSort(totalPriceSortType,
                        createdTimeSortType,
                        deliveryDateSortType,
                        page,
                        limit)
        );
        return orders;
    }

    @Override
    public List<Order> fetchOrdersForPackageStaff(String totalPriceSortType,
                                                  String createdTimeSortType,
                                                  String deliveryDateSortType,
                                                  UUID pickupPointId,
                                                  Date deliveryDate,
                                                  OrderStatus orderStatus,
                                                  String email,
                                                  Boolean isPaid,
                                                  Boolean isGrouped,
                                                  int page,
                                                  int limit) throws ResourceNotFoundException {
        List<PickupPoint> pickupPointListOfStaff = staffRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Nhân viên không tìm thấy với email " + email)).getPickupPoint();
        List<Order> orders = repository.findOrderForPackageStaff(
                pickupPointId,
                deliveryDate,
                pickupPointListOfStaff,
                orderStatus == null ? null : orderStatus.ordinal(),
                isGrouped,
                isPaid,
                getPageableWithSort(totalPriceSortType,
                        createdTimeSortType,
                        deliveryDateSortType,
                        page,
                        limit)
        );
        return orders;
    }

    @Override
    public OrderWithDetails fetchOrderDetail(UUID id) throws ResourceNotFoundException {
        log.info("Fetching order detail of order_id " + id);
        Order order = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("No order with id " + id));

        OrderWithDetails orderWithDetails = new OrderWithDetails();
        orderWithDetails.setId(order.getId());
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
                    orderProduct.setImageUrl(product.getImageUrl());
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
    public String cancelOrder(String jwtToken, UUID id) throws ResourceNotFoundException, OrderCancellationNotAllowedException, FirebaseAuthException {
        String email = Utils.getCustomerEmail(jwtToken, firebaseAuth);
        Customer customer = customerRepository
                .findByEmail(email)
                .orElseThrow(() -> new AuthorizationServiceException("Access denied with this account: " + email));
        if (customer == null) {
            return "Fail to canceled order " + id;
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
    public String deleteOrderWithoutAuthen(UUID id) throws FirebaseAuthException, ResourceNotFoundException, OrderDeletionNotAllowedException {
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
    public List<OrderBatch> batchingForStaff(Date deliverDate, UUID timeFrameId, Integer batchQuantity) throws ResourceNotFoundException {
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
        return null;
    }


    // GOONG IMPLEMENT

    @Override
    public ShippingFeeDetailResponseBody getShippingFeeDetail(Double latitude, Double longitude) throws IOException, InterruptedException, ApiException {
//        int numberOfSuggestion = 3;
        Configuration configuration = Utils.getAdminConfiguration();
        PickupPointSuggestionResponseBody closetPickupPoint;
        Integer shippingFee = configuration.getInitialShippingFee();
        List<PickupPoint> pickupPoints = pickupPointRepository.getAllSortByDistance(latitude, longitude);
        List<PickupPointSuggestionResponseBody> pickupPointSuggestionResponseBodyList = new ArrayList<>();
        List<LatLngModel> destinations = new ArrayList<>();
        LatLngModel origin = new LatLngModel(latitude, longitude);
        for (PickupPoint pickupPoint : pickupPoints) {
            // using 0 because pickup point at index 0 will be deleted and next index will be 0
            pickupPointSuggestionResponseBodyList.add(new PickupPointSuggestionResponseBody(pickupPoint));
            destinations.add(new LatLngModel(pickupPoint.getLatitude().doubleValue(), pickupPoint.getLongitude().doubleValue()));
        }

        // fetch goong api
        String apiKeyParam = "api_key=" + goongApiKey;
        String vehicleParam = "vehicle=bike";
        String originParam = "origins=" + origin;
        String destinationParam = "destinations=" + destinations.stream().map(latLngModel -> latLngModel.toString()).collect(Collectors.joining("%7C"));
        String goongMatrixDistanceRequest = goongDistanceMatrixUrl + "?" + originParam + "&" + destinationParam + "&" + vehicleParam + "&" + apiKeyParam;
        RestTemplate restTemplate = new RestTemplate();
        URI goongMatrixDistanceRequestURI = URI.create(goongMatrixDistanceRequest);
        GoongDistanceMatrixResult goongDistanceMatrixResult = restTemplate.getForObject(goongMatrixDistanceRequestURI, GoongDistanceMatrixResult.class);


        for (GoongDistanceMatrixRow goongDistanceMatrixRow : goongDistanceMatrixResult.getRows()) {
            int i = 0;
            for (GoongDistanceMatrixElement goongDistanceMatrixElement : goongDistanceMatrixRow.getElements()) {
                pickupPointSuggestionResponseBodyList.get(i).setDistance(goongDistanceMatrixElement.getDistance().getText());
                pickupPointSuggestionResponseBodyList.get(i).setDistanceInValue(goongDistanceMatrixElement.getDistance().getValue());
                i++;
            }
        }

        pickupPointSuggestionResponseBodyList.sort((o1, o2) -> (int) (o1.getDistanceInValue() - o2.getDistanceInValue()));

        closetPickupPoint = pickupPointSuggestionResponseBodyList.get(0);

        // convert m to km
        int distance = closetPickupPoint.getDistanceInValue().intValue() / 1000;

        if (distance > configuration.getMinKmDistanceForExtraShippingFee()) {
            shippingFee += (distance - 2) * configuration.getExtraShippingFeePerKilometer();
        }

        ShippingFeeDetailResponseBody shippingFeeDetailResponseBody = new ShippingFeeDetailResponseBody();
        shippingFeeDetailResponseBody.setClosestPickupPoint(closetPickupPoint);
        shippingFeeDetailResponseBody.setShippingFee(shippingFee);

        return shippingFeeDetailResponseBody;
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
        if (repository.getOrdersProcessing(customer.getEmail()).size() < Utils.getAdminConfiguration().getLimitOfOrders()) {
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
            map.put(orderCreated.getId(), 0, 31, TimeUnit.MINUTES);
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
        return repository.save(orderSaved);
    }


    private Order setOrderData(OrderCreate orderCreate, Customer customer) throws ResourceNotFoundException, InterruptedException {
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
                .orElseThrow(() -> new NoSuchElementException("No pick-up point found with id " + orderCreate.getPickupPointId())));
        order.setTimeFrame(timeFrameRepository.findById(orderCreate.getTimeFrameId())
                .orElseThrow(() -> new ResourceNotFoundException("Time frame không tìm thấy với id: " + orderCreate.getTimeFrameId())));
        return order;
    }

    private void groupingOrder(Order order, OrderCreate orderCreate) {
        OrderGroup group = null;
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

    private OrderGroup createNewOrderGroup(OrderCreate orderCreate) {
        OrderGroup orderGroupNew = new OrderGroup();
        orderGroupNew.setTimeFrame(timeFrameRepository.findById(orderCreate.getTimeFrameId())
                .orElseThrow(() -> new NoSuchElementException("No time-frame found with id " + orderCreate.getTimeFrameId())));
        orderGroupNew.setPickupPoint(pickupPointRepository.findById(orderCreate.getPickupPointId())
                .orElseThrow(() -> new NoSuchElementException("No pick-up point found with id " + orderCreate.getPickupPointId())));
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

    private List<OrderDetail> getOrderDetails(Order order, OrderCreate orderCreate) throws OutOfProductQuantityException, ResourceNotFoundException, InterruptedException {
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
            // 10 3 3 4 || 10 11 12 13 || 10 3 11
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
