package com.fpt.capstone.savinghourmarket.service.serviceImpl;

import com.fpt.capstone.savinghourmarket.common.AdditionalResponseCode;
import com.fpt.capstone.savinghourmarket.common.EnableDisableStatus;
import com.fpt.capstone.savinghourmarket.common.SortType;
import com.fpt.capstone.savinghourmarket.common.Status;
import com.fpt.capstone.savinghourmarket.entity.*;
import com.fpt.capstone.savinghourmarket.exception.InvalidExcelFileDataException;
import com.fpt.capstone.savinghourmarket.exception.InvalidInputException;
import com.fpt.capstone.savinghourmarket.exception.ItemNotFoundException;
import com.fpt.capstone.savinghourmarket.exception.ResourceNotFoundException;
import com.fpt.capstone.savinghourmarket.model.*;
import com.fpt.capstone.savinghourmarket.repository.*;
import com.fpt.capstone.savinghourmarket.service.ProductCategoryService;
import com.fpt.capstone.savinghourmarket.service.ProductService;
import com.fpt.capstone.savinghourmarket.service.ProductSubCategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFPictureData;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final ProductCategoryRepository productCategoryRepository;
    private final ProductSubCategoryRepository productSubCategoryRepository;
    private final SupermarketRepository supermarketRepository;
    private final ProductCategoryService productCategoryService;
    private final ProductSubCategoryService productSubCategoryService;
    private final PickupPointRepository pickupPointRepository;
    private final ProductBatchRepository productBatchRepository;
    private final SupermarketAddressRepository supermarketAddressRepository;

    @Override
    public ProductListResponseBody getProductsForStaff(Boolean isExpiredShown, String name, String supermarketId, String productCategoryId, String productSubCategoryId, EnableDisableStatus status, Integer page, Integer limit, SortType quantitySortType, SortType expiredSortType, SortType priceSort) {
        Sort sortable = Sort.by("expiredDate").ascending();
//        if(quantitySortType.equals("ASC") ){
//            sortable = Sort.by("expiredDate").ascending();
//        }else if (quantitySortType.equals("DESC")) {
//            sortable = Sort.by("expiredDate").ascending();
//        }else if (quantitySortType.equals("ASC")){
//            sortable = Sort.by("expiredDate").ascending();
//        }else {
//            sortable = Sort.by("expiredDate").descending();
//        }

        if (quantitySortType != null) {
            sortable = quantitySortType.toString().equals("ASC") ? Sort.by("quantity").ascending() : Sort.by("quantity").descending();
        }

        if (priceSort != null) {
            sortable = priceSort.toString().equals("ASC") ? Sort.by("price").ascending() : Sort.by("price").descending();
        }

        if (expiredSortType != null) {
            sortable = expiredSortType.toString().equals("ASC") ? Sort.by("expiredDate").ascending() : Sort.by("expiredDate").descending();
        }

        Pageable pageableWithSort = PageRequest.of(page, limit);
        Page<Product> result = productRepository.getProductsForStaff(supermarketId == null ? null : UUID.fromString(supermarketId)
                , name
                , productCategoryId == null ? null : UUID.fromString(productCategoryId)
                , productSubCategoryId == null ? null : UUID.fromString(productSubCategoryId)
                , status == null ? EnableDisableStatus.ENABLE.ordinal() : status.ordinal()
                , isExpiredShown
                , pageableWithSort);

        int totalPage = result.getTotalPages();
        long totalProduct = result.getTotalElements();

        List<Product> productList = result.stream().toList();

        return new ProductListResponseBody(productList, totalPage, totalProduct);
    }

//    @Override
//    public ProductListCustomerResponseBody getProductsForCustomer(String name, String supermarketId, String productCategoryId, String productSubCategoryId, Integer page, Integer limit, SortType quantitySortType, SortType expiredSortType, SortType priceSort, UUID pickupPointId) {
//
//        if(!pickupPointRepository.findById(pickupPointId).isPresent()){
//            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.PICKUP_POINT_NOT_FOUND.getCode()), AdditionalResponseCode.PICKUP_POINT_NOT_FOUND.toString());
//        }
//
//        Sort sortable = Sort.by("productBatchList.expiredDate").ascending();
//
//        if (quantitySortType != null) {
////            sortable = quantitySortType.toString().equals("ASC") ? Sort.by("productBatchList_quantity").ascending() : Sort.by("productBatchList_quantity").descending();
//
//        }
//
//        if (priceSort != null) {
////            sortable = priceSort.toString().equals("ASC") ? Sort.by("productBatchList_price").ascending() : Sort.by("productBatchList_price").descending();
//        }
//
//        if (expiredSortType != null) {
////            sortable = expiredSortType.toString().equals("ASC") ? Sort.by("productBatchList_expiredDate").ascending() : Sort.by("productBatchList_expiredDate").descending();
//        }
//
////        Pageable pageableWithSort = PageRequest.of(page, limit, sortable);
//        Pageable pageableWithSort = PageRequest.of(page, limit, sortable);
//
//        Page<Product> result = productRepository.getProductsForCustomer(supermarketId == null ? null : UUID.fromString(supermarketId)
//                , name
//                , productCategoryId == null ? null : UUID.fromString(productCategoryId)
//                , productSubCategoryId == null ? null : UUID.fromString(productSubCategoryId)
//                , pickupPointId
//                , pageableWithSort);
//
//        int totalPage = result.getTotalPages();
//        long totalProduct = result.getTotalElements();
//
//        List<Product> productList = result.stream().toList();
//
//        HashMap<UUID ,ProductDisplayCustomer> productDisplayCustomerHashMap = new HashMap<>();
//
//
//        for (Product product : productList) {
//            productDisplayCustomerHashMap.put(product.getId(), new ProductDisplayCustomer(product));
//        }
//
//        for (Product product : productList) {
//            HashMap<String, ProductBatchDisplayCustomer> similarBatchTrackingHashmap = new HashMap<>();
//            for (ProductBatch productBatch : product.getProductBatchList()) {
//                if(similarBatchTrackingHashmap.containsKey(productBatch.getExpiredDate().toString())){
//                    // add id to same expired date batch
//                   similarBatchTrackingHashmap.get(productBatch.getExpiredDate().toString()).getIdList().add(productBatch.getId());
//                    // add quantity to same expired date batch
//                   similarBatchTrackingHashmap.get(productBatch.getExpiredDate().toString()).setQuantity(similarBatchTrackingHashmap.get(productBatch.getExpiredDate().toString()).getQuantity() + productBatch.getQuantity());
//                } else {
//                    similarBatchTrackingHashmap.put(productBatch.getExpiredDate().toString(), new ProductBatchDisplayCustomer(productBatch));
//                }
//            }
//            // sort batch with expired date
//            List<ProductBatchDisplayCustomer> productBatchDisplayCustomerList = similarBatchTrackingHashmap.values().stream().collect(Collectors.toList());
//            productBatchDisplayCustomerList.sort((o1, o2) -> o1.getExpiredDate().compareTo(o2.getExpiredDate()));
//            productDisplayCustomerHashMap.get(product.getId()).setProductBatchList(productBatchDisplayCustomerList);
//        }
//
////        List<ProductDisplayCustomer> productDisplayCustomerList = productDisplayCustomerHashMap.values().stream().collect(Collectors.toList());
//        // sort by expired date
//
////        if (quantitySortType != null) {
//////            sortable = quantitySortType.toString().equals("ASC") ? Sort.by("productBatchList_quantity").ascending() : Sort.by("productBatchList_quantity").descending();
////            productDisplayCustomerList.sort((o1, o2) -> quantitySortType.toString().equals("ASC") ?
////                    o1.getProductBatchList().get(0).getQuantity().compareTo(o2.getProductBatchList().get(0).getQuantity())
////                    : o2.getProductBatchList().get(0).getQuantity().compareTo(o1.getProductBatchList().get(0).getQuantity()));
////
////        }
////
////        if (priceSort != null) {
//////            sortable = priceSort.toString().equals("ASC") ? Sort.by("productBatchList_price").ascending() : Sort.by("productBatchList_price").descending();
////            productDisplayCustomerList.sort((o1, o2) -> priceSort.toString().equals("ASC") ?
////                    o1.getProductBatchList().get(0).getPrice().compareTo(o2.getProductBatchList().get(0).getPrice())
////                    : o2.getProductBatchList().get(0).getPrice().compareTo(o1.getProductBatchList().get(0).getPrice()));
////
////        }
//
////        if (expiredSortType != null) {
////            productDisplayCustomerList.sort((o1, o2) -> expiredSortType.toString().equals("ASC") ?
////                    o1.getProductBatchList().get(0).getExpiredDate().compareTo(o2.getProductBatchList().get(0).getExpiredDate())
////                    : o2.getProductBatchList().get(0).getExpiredDate().compareTo(o1.getProductBatchList().get(0).getExpiredDate()));
////        }
////
////        if(expiredSortType == null && priceSort == null && quantitySortType == null) {
////            productDisplayCustomerList.sort((o1, o2) -> o1.getProductBatchList().get(0).getExpiredDate().compareTo(o2.getProductBatchList().get(0).getExpiredDate()));
////
////        }
//
//        return new ProductListCustomerResponseBody(productDisplayCustomerHashMap.values().stream().collect(Collectors.toList()), totalPage, totalProduct);
//    }


    @Override
    public ProductListCustomerResponseBody getProductsForCustomer(String name, String supermarketId, String productCategoryId, String productSubCategoryId, Integer page, Integer limit, SortType quantitySortType, SortType expiredSortType, SortType priceSort, UUID pickupPointId) {

        if (!pickupPointRepository.findById(pickupPointId).isPresent()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.PICKUP_POINT_NOT_FOUND.getCode()), AdditionalResponseCode.PICKUP_POINT_NOT_FOUND.toString());
        }

        Sort sortable = Sort.by("expiredDate").ascending();

//        if (quantitySortType != null) {
//            sortable = quantitySortType.toString().equals("ASC") ? Sort.by("quantity").ascending() : Sort.by("quantity").descending();
//
//        }

        if (priceSort != null) {
            sortable = priceSort.toString().equals("ASC") ? Sort.by("price").ascending() : Sort.by("price").descending();
        }

        if (expiredSortType != null) {
            sortable = expiredSortType.toString().equals("ASC") ? Sort.by("expiredDate").ascending() : Sort.by("expiredDate").descending();
        }

        Pageable pageableWithSort = PageRequest.of(page, limit, sortable);

        Page<Object[]> result = productRepository.getProductsNearestExpiredBatchForCustomer(supermarketId == null ? null : UUID.fromString(supermarketId)
                , name
                , productCategoryId == null ? null : UUID.fromString(productCategoryId)
                , productSubCategoryId == null ? null : UUID.fromString(productSubCategoryId)
                , pickupPointId
                , pageableWithSort);

        int totalPage = result.getTotalPages();
        long totalProduct = result.getTotalElements();

        List<ProductDisplayCustomer> productDisplayCustomerList = new ArrayList<>();
        HashMap<UUID, ProductDisplayCustomer> productDisplayCustomerHashMap = new HashMap<>();

        // get product sort with nearest product batch (no grouping id)
        for (Object[] objects : result) {
            LocalDate nearestBatchExpiredDate = (LocalDate) objects[0];
            Integer nearestBatchPrice = (Integer) objects[1];
            Integer nearestBatchPriceOriginal = (Integer) objects[2];
            Product nearestBatchProduct = (Product) objects[3];
//            Long nearestBatchTotalQuantity = (Long) objects[4];

            ProductDisplayCustomer productDisplayCustomerTemp = new ProductDisplayCustomer(nearestBatchExpiredDate, nearestBatchPrice
                    , nearestBatchPriceOriginal, nearestBatchProduct);
            productDisplayCustomerList.add(productDisplayCustomerTemp);
            productDisplayCustomerHashMap.put(productDisplayCustomerTemp.getId(), productDisplayCustomerTemp);
        }

        // sort by quantity
//        if (quantitySortType != null) {
//            productDisplayCustomerList.sort((o1, o2) -> quantitySortType.toString().equals("ASC")? o1.getNearestExpiredBatch().getQuantity().compareTo(o2.getNearestExpiredBatch().getQuantity())
//                    : o2.getNearestExpiredBatch().getQuantity().compareTo(o1.getNearestExpiredBatch().getQuantity()));
//        }

        List<UUID> productIdTargetList = productDisplayCustomerList.stream().map(productDisplayCustomer -> productDisplayCustomer.getId()).collect(Collectors.toList());

        List<Product> productWithAvailableBatch = productRepository.findProductWithAvailableBatch(productIdTargetList, pickupPointId);

        for (Product product : productWithAvailableBatch) {
            ProductDisplayCustomer productDisplayCustomerTemp = productDisplayCustomerHashMap.get(product.getId());
            // hashmap use to group batch id
            HashMap<LocalDate, ProductBatchDisplayCustomer> productBatchDisplayCustomerHashMap = new HashMap<>();
            for (ProductBatch productBatch : product.getProductBatchList()) {
                // check if same expired date then add id to nearest expired date batch
                if (productBatch.getExpiredDate().equals(productDisplayCustomerTemp.getNearestExpiredBatch().getExpiredDate())) {
                    productDisplayCustomerTemp.getNearestExpiredBatch().getIdList().add(productBatch.getId());
                    productDisplayCustomerTemp.getNearestExpiredBatch().setQuantity(productDisplayCustomerTemp.getNearestExpiredBatch().getQuantity() + productBatch.getQuantity());
                } else {
                    // map and handle same expired date batch
                    if (productBatchDisplayCustomerHashMap.containsKey(productBatch.getExpiredDate())) {
                        ProductBatchDisplayCustomer productBatchDisplayCustomerTemp = productBatchDisplayCustomerHashMap.get(productBatch.getExpiredDate());
                        productBatchDisplayCustomerTemp.getIdList().add(productBatch.getId());
                        productBatchDisplayCustomerTemp.setQuantity(productBatchDisplayCustomerTemp.getQuantity() + productBatch.getQuantity());
                    } else {
                        productBatchDisplayCustomerHashMap.put(productBatch.getExpiredDate(), new ProductBatchDisplayCustomer(productBatch));
                    }
                }
            }
            // map product batch hash map to list
            List<ProductBatchDisplayCustomer> productBatchDisplayCustomerList = productBatchDisplayCustomerHashMap.values().stream().collect(Collectors.toList());
            // sort list batch by expired date ASC
            productBatchDisplayCustomerList.sort((o1, o2) -> o1.getExpiredDate().compareTo(o2.getExpiredDate()));
            productDisplayCustomerTemp.getOtherProductBatchList().addAll(productBatchDisplayCustomerList);
        }


        return new ProductListCustomerResponseBody(productDisplayCustomerList, totalPage, totalProduct);
    }


    @Override
    public List<SaleReportSupermarketMonthlyResponseBody> getSaleReportSupermarket(UUID supermarketId, Integer year) {
        LocalDate currentDate = LocalDate.now();
        if (!supermarketRepository.findById(supermarketId).isPresent()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.SUPERMARKET_NOT_FOUND.getCode()), AdditionalResponseCode.SUPERMARKET_NOT_FOUND.toString());
        }
        if (year == null) {
            year = currentDate.getYear();
        }

        List<Object[]> resultList = productRepository.getProductsReportForSupermarket(supermarketId, year);

        // map result
        List<SaleReportSupermarketMonthlyResponseBody> saleReportSupermarketMonthlyList = resultList.stream().map(result -> (SaleReportSupermarketMonthlyResponseBody) result[1]).collect(Collectors.toList());
        HashMap<Integer, SaleReportSupermarketMonthlyResponseBody> saleReportSupermarketMonthHashMap = new HashMap<>();

        saleReportSupermarketMonthlyList.stream().forEach(saleReportSupermarketMonthlyResponseBody -> {
            saleReportSupermarketMonthHashMap.put(saleReportSupermarketMonthlyResponseBody.getMonthValue(), saleReportSupermarketMonthlyResponseBody);
        });

        for (int i = 1; i <= 12; i++) {
            if (!saleReportSupermarketMonthHashMap.containsKey(i)) {
                SaleReportSupermarketMonthlyResponseBody saleReportSupermarketMonthlyResponseBody = new SaleReportSupermarketMonthlyResponseBody(i, Long.parseLong("0"), Long.parseLong("0"));
                saleReportSupermarketMonthlyList.add(saleReportSupermarketMonthlyResponseBody);
            }
        }

        saleReportSupermarketMonthlyList.sort((o1, o2) -> o1.getMonthValue() - o2.getMonthValue());

//        productEntityReportList.stream().forEach(product -> {
//            saleReportResponseBody.getProductSaleReportList().add(new ProductSaleReport(product));
//            saleReportResponseBody.setTotalSale(saleReportResponseBody.getTotalSale() + product.getQuantity());
//            saleReportResponseBody.setTotalIncome(saleReportResponseBody.getTotalIncome() + product.getPrice());
//        });
        return saleReportSupermarketMonthlyList;
    }


    @Override
    @Transactional
    public Product getById(UUID id) {
        Optional<Product> product = productRepository.findByIdCustom(id);
        if (!product.isPresent()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.PRODUCT_NOT_FOUND.getCode()), AdditionalResponseCode.PRODUCT_NOT_FOUND.toString());
        }
        return product.get();
    }

    @Override
    public List<ProductCateWithSubCate> getAllCategory() {
        List<ProductCateWithSubCate> productCategoryList = productCategoryRepository.getAllProductCategoryWithSubCate();
        return productCategoryList;
    }

    @Override
    public List<ProductSubCateOnly> getAllSubCategory() {
        List<ProductSubCateOnly> productSubCateOnlyList = productSubCategoryRepository.findAllSubCategoryOnly();
        return productSubCateOnlyList;
    }

    @Override
    public ProductCategory createCategory(ProductCategoryCreateBody productCategoryCreateBody) {
        return productCategoryService.createCategory(productCategoryCreateBody);
    }

    @Override
    public ProductSubCategory createSubCategory(ProductSubCategoryCreateBody productSubCategoryCreateBody) {
        return productSubCategoryService.createSubCategory(productSubCategoryCreateBody);
    }

    @Override
    public ProductCategory updateProductCategory(ProductCategoryUpdateBody productCategoryUpdateBody, UUID categoryId) {
        return productCategoryService.updateCategory(productCategoryUpdateBody, categoryId);
    }

    @Override
    public ProductSubCategory updateProductSubCategory(ProductSubCategoryUpdateBody productSubCategoryUpdateBody, UUID subCategoryId) {
        return productSubCategoryService.updateSubCategory(productSubCategoryUpdateBody, subCategoryId);
    }

    @Override
    public List<Product> createProductList(List<Product> productList) throws ResourceNotFoundException {
//        LinkedHashMap<String, String> errorFields = new LinkedHashMap<>();
//        List<Product> productsSaved = new ArrayList<>();
//        for (Product product : productList) {
//            if (product.getName().length() > 50) {
//                errorFields.put("Lỗi nhập tên sản phẩm của sản phẩm " + product.getName(), "Tên sản phẩm chỉ có tối đa 50 kí tự!");
//            }
//
//            if (product.getPrice() < 0) {
//                errorFields.put("Lỗi nhập giá bán của sản phẩm " + product.getName(), "Giá bán không thế âm!");
//            }
//
//            if (product.getPriceOriginal() < 0) {
//                errorFields.put("Lỗi nhập giá gốc của sản phẩm " + product.getName(), "Giá gốc không thế âm!");
//            }
//
//            if (product.getQuantity() <= 0) {
//                errorFields.put("Lỗi nhập số lượng của sản phẩm " + product.getName(), "Số lượng sản phẩm không thể âm hoặc bằng 0!");
//            }
//
//            if (product.getExpiredDate().isBefore(LocalDate.now().plus(product.getProductSubCategory().getAllowableDisplayThreshold(), ChronoUnit.DAYS))) {
//                errorFields.put("Lỗi nhập ngày hết hạn của sản phẩm " + product.getName(), "Ngày hết hạn phải sau ngày hiện tại cộng thêm số ngày điều kiện cho hàng cận hạn sử dụng có trong SUBCATEGORY!");
//            }
//
//            if (product.getProductSubCategory().getId() == null && product.getProductSubCategory().getName().length() > 50) {
//                errorFields.put("Lỗi nhập tên SubCategory của sản phẩm " + product.getName(), "Tên sản phẩm chỉ có tối đa 50 kí tự!");
//            }
//
//            if (product.getProductSubCategory().getId() == null && product.getProductSubCategory().getAllowableDisplayThreshold() <= 0) {
//                errorFields.put("Lỗi nhập AllowableDisplayThreshold của sản phẩm " + product.getName(), "AllowableDisplayThreshold không thể âm hoặc bằng 0!");
//            }
//
//            if (product.getProductSubCategory().getId() == null && product.getProductSubCategory().getProductCategory().getName().length() > 50) {
//                errorFields.put("Lỗi nhập tên category của sản phẩm " + product.getName(), "Tên category chỉ có tối đa 50 kí tự!");
//            }
//
//            if (product.getSupermarket().getId() == null && product.getSupermarket().getName().length() > 50) {
//                errorFields.put("Lỗi nhập tên siêu thị của sản phẩm " + product.getName(), "Tên siêu thị chỉ có tối đa 50 kí tự!");
//            }
//
//            List<SupermarketAddress> supermarketAddressList = product.getSupermarket().getSupermarketAddressList();
//            for (SupermarketAddress address : supermarketAddressList) {
//                if (address.getAddress().length() > 255) {
//                    errorFields.put("Lỗi nhập địa chỉ siêu thị của sản phẩm " + product.getName() + address.getAddress(), "Địa chỉ siêu thị chỉ có tối đa 255 kí tự!");
//                }
//            }
//
//            Pattern pattern;
//            Matcher matcher;
//            pattern = Pattern.compile("^(0|84)(2(0[3-9]|1[0-6|8|9]|2[0-2|5-9]|3[2-9]|4[0-9]|5[1|2|4-9]|6[0-3|9]|7[0-7]|8[0-9]|9[0-4|6|7|9])|3[2-9]|5[5|6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])([0-9]{7})$");
//            matcher = pattern.matcher(product.getSupermarket().getPhone());
//            if (!matcher.matches()) {
//                errorFields.put("Lỗi nhập số điện thoại siêu thị của sản phẩm " + product.getName(), "Số điện thoại siêu thị không hợp lệ!");
//            }
//
//            UUID productSubCategoryId = product.getProductSubCategory().getId();
//            if (!productSubCategoryRepository.findById(productSubCategoryId).isPresent()) {
//                errorFields.put("Lỗi loại sản phảm phụ của sản phẩm " + product.getName(), "Loại sản phảm phụ không tìm thấy với id: " + productSubCategoryId);
//            }
//
//            UUID supermarketId = product.getSupermarket().getId();
//            if (!supermarketRepository.findById(supermarketId).isPresent()) {
//                errorFields.put("Lỗi thông tin siêu thị của sản phẩm " + product.getName(), "Siêu thị không tìm thấy với id: " + productSubCategoryId);
//            }
//
//        }
//
//        if (errorFields.size() > 0) {
//            throw new InvalidExcelFileDataException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
//        }
//
//        productList.stream().forEach(product -> {
//            Product productSaved = productRepository.save(product);
//            productsSaved.add(productSaved);
//        });

        return null;
    }

    public List<RevenueReportMonthly> getRevenueReportForEachMonth(Integer year) {
        LocalDate currentDate = LocalDate.now();

        if (year == null) {
            year = currentDate.getYear();
        }

        List<Object[]> revenueResult = productRepository.getRevenueReportMonthly(year);
        // map result
        List<RevenueReportMonthly> revenueReportMonthlyList = revenueResult.stream().map(result -> (RevenueReportMonthly) result[1]).collect(Collectors.toList());
        HashMap<Integer, RevenueReportMonthly> reportMonthlyHashMap = new HashMap<>();
        revenueReportMonthlyList.stream().forEach(revenueReportMonthly -> {
            reportMonthlyHashMap.put(revenueReportMonthly.getMonthValue(), revenueReportMonthly);
        });

        // 12 months
        for (int i = 1; i <= 12; i++) {
            if (!reportMonthlyHashMap.containsKey(i)) {
                RevenueReportResponseBody revenueReportResponseBody = new RevenueReportResponseBody(null, null, null);
                revenueReportMonthlyList.add(new RevenueReportMonthly(i, revenueReportResponseBody));
            }
        }

        revenueReportMonthlyList.sort((o1, o2) -> o1.getMonthValue() - o2.getMonthValue());
//        revenueReportResponseBody.setTotalIncome((RevenueReportResponseBody) revenueResult[0]);
//        revenueReportResponseBody.setTotalInvestment((Long) revenueResult[1]);
//        revenueReportResponseBody.setTotalSale((Long) revenueResult[2]);

//        revenueReportResponseBody.setTotalDifferentAmount(revenueReportResponseBody.getTotalIncome()- revenueReportResponseBody.getTotalPriceOriginal());

        return revenueReportMonthlyList;
    }

    @Override
    public List<RevenueReportYearly> getRevenueReportForEachYear() {
        Integer appBuildYear = 2023;
        Integer currentYear = LocalDate.now().getYear();

        List<Object[]> revenueResult = productRepository.getRevenueReportYearly(appBuildYear, currentYear);
        // map result
        List<RevenueReportYearly> revenueReportYearlyList = revenueResult.stream().map(result -> (RevenueReportYearly) result[1]).collect(Collectors.toList());
        HashMap<Integer, RevenueReportYearly> reportYearlyHashMap = new HashMap<>();
        revenueReportYearlyList.stream().forEach(revenueReportYearly -> {
            reportYearlyHashMap.put(revenueReportYearly.getYearValue(), revenueReportYearly);
        });

        // 12 months
        for (int i = appBuildYear; i <= currentYear; i++) {
            if (!reportYearlyHashMap.containsKey(i)) {
                RevenueReportResponseBody revenueReportResponseBody = new RevenueReportResponseBody(null, null, null);
                revenueReportYearlyList.add(new RevenueReportYearly(i, revenueReportResponseBody));
            }
        }

        revenueReportYearlyList.sort((o1, o2) -> o1.getYearValue() - o2.getYearValue());

        return revenueReportYearlyList;
    }

    @Override
    public List<SupermarketSaleReportResponseBody> getAllSupermarketSaleReport(Integer year) {
        LocalDate currentDate = LocalDate.now();
        if (year == null) {
            year = currentDate.getYear();
        }
        List<Supermarket> rawSupermarketList = supermarketRepository.findAll();
        List<SupermarketSaleReportResponseBody> allSupermarketSaleReportResponseBodyList = new ArrayList<>();
        allSupermarketSaleReportResponseBodyList.addAll(rawSupermarketList.stream().map(SupermarketSaleReportResponseBody::new).collect(Collectors.toList()));

        List<SupermarketSaleReportResponseBody> result = productRepository.getSupermarketsSaleReport(year);
        HashMap<UUID, SupermarketSaleReportResponseBody> resultHashmap = new HashMap<>();
        result.stream().forEach(supermarketSaleReportResponseBody -> {
            resultHashmap.put(supermarketSaleReportResponseBody.getId(), supermarketSaleReportResponseBody);
        });
        for (SupermarketSaleReportResponseBody saleReportResponseBody : allSupermarketSaleReportResponseBodyList) {
            if (resultHashmap.containsKey(saleReportResponseBody.getId())) {
                saleReportResponseBody.setTotalSale(resultHashmap.get(saleReportResponseBody.getId()).getTotalSale());
                saleReportResponseBody.setTotalIncome(resultHashmap.get(saleReportResponseBody.getId()).getTotalIncome());
            }
        }

        return allSupermarketSaleReportResponseBodyList;
    }

    @Override
    public List<CateOderQuantityResponseBody> getOrderTotalAllCategorySupermarket(UUID supermarketId, Integer year) {
        LocalDate currentDate = LocalDate.now();

        if (!supermarketRepository.findById(supermarketId).isPresent()) {
            throw new ItemNotFoundException(HttpStatus.valueOf(AdditionalResponseCode.SUPERMARKET_NOT_FOUND.getCode()), AdditionalResponseCode.SUPERMARKET_NOT_FOUND.toString());
        }

        if (year == null) {
            year = currentDate.getYear();
        }

        List<ProductCategory> rawProductCategoryList = productCategoryRepository.findAll();
        List<CateOderQuantityResponseBody> cateOderQuantityResponseList = rawProductCategoryList.stream().map(productCategory -> new CateOderQuantityResponseBody(productCategory.getId(), productCategory.getName(), Long.parseLong("0"))).collect(Collectors.toList());


        List<CateOderQuantityResponseBody> result = productRepository.getOrderTotalAllCategoryReport(supermarketId, year);
        HashMap<UUID, CateOderQuantityResponseBody> cateOderQuantityResponseHashmap = new HashMap<>();
        result.stream().forEach(cateOderQuantityResponseBody -> {
            cateOderQuantityResponseHashmap.put(cateOderQuantityResponseBody.getCategoryId(), cateOderQuantityResponseBody);
        });

        for (CateOderQuantityResponseBody cateOderQuantityResponseBody : cateOderQuantityResponseList) {
            if (cateOderQuantityResponseHashmap.containsKey(cateOderQuantityResponseBody.getCategoryId())) {
                cateOderQuantityResponseBody.setTotalOrderQuantity(cateOderQuantityResponseHashmap.get(cateOderQuantityResponseBody.getCategoryId()).getTotalOrderQuantity());
            }
        }

        cateOderQuantityResponseList.sort((o1, o2) -> o2.getTotalOrderQuantity() - o1.getTotalOrderQuantity());

        return cateOderQuantityResponseList;
    }

    @Override
    public CategoryListResponseBody getCategoryForStaff(String name, EnableDisableStatus status, Integer page, Integer limit) {
        Pageable pageable = PageRequest.of(page, limit);
        Page<ProductCateWithSubCate> result = productCategoryRepository.getAllProductCategoryWithSubCateForStaff(name, pageable);
        int totalPage = result.getTotalPages();
        long totalCategory = result.getTotalElements();
        List<ProductCateWithSubCate> productCateWithSubCateList = result.stream().toList();

        return new CategoryListResponseBody(productCateWithSubCateList, totalPage, totalCategory);
    }

    @Override
    public SubCategoryListResponseBody getSubCategoryForStaff(String name, EnableDisableStatus status, UUID productCategoryId, Integer page, Integer limit) {
        Pageable pageable = PageRequest.of(page, limit);
        Page<ProductSubCateOnly> result = productSubCategoryRepository.findAllSubCategoryOnlyForStaff(name, productCategoryId == null ? null : productCategoryId, pageable);
        int totalPage = result.getTotalPages();
        long totalSubCategory = result.getTotalElements();
        List<ProductSubCateOnly> productSubCateOnlyList = result.stream().toList();

        return new SubCategoryListResponseBody(productSubCateOnlyList, totalPage, totalSubCategory);
    }

    @Override
    public Product updateProduct(Product product) throws ResourceNotFoundException {
//        HashMap<String, String> errorFields = new HashMap<>();
//
//        if (productRepository.findById(product.getId()).isEmpty()) {
//            throw new ResourceNotFoundException("Sản phảm không tìm thấy với id: " + product.getId());
//        }
//
//        if (product.getName().length() > 50) {
//            errorFields.put("Lỗi nhập tên sản phẩm", "Tên sản phẩm chỉ có tối đa 50 kí tự!");
//        }
//
//        if (product.getPrice() < 0 || product.getPriceOriginal() < 0) {
//            errorFields.put("Lỗi nhập giá", "Giá bán không thế âm!");
//        }
//
//        if (product.getQuantity() <= 0) {
//            errorFields.put("Lỗi nhập số lượng", "Số lượng sản phẩm không thể âm hoặc bằng 0!");
//        }
//
//        if (product.getExpiredDate().isBefore(LocalDate.now().plus(product.getProductSubCategory().getAllowableDisplayThreshold(), ChronoUnit.DAYS))) {
//            errorFields.put("Lỗi nhập ngày hết hạn", "Ngày hết hạn phải sau ngày hiện tại cộng thêm số ngày điều kiện cho hàng cận hạn sử dụng có trong SUBCATEGORY!");
//        }
//
//        if (errorFields.size() > 0) {
//            throw new InvalidInputException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
//        }
//
//        UUID productSubCategoryId = product.getProductSubCategory().getId();
//        if (productSubCategoryRepository.findById(productSubCategoryId).isEmpty()) {
//            throw new ResourceNotFoundException("Loại sản phảm phụ không tìm thấy với id: " + productSubCategoryId);
//        }
//
//        UUID supermarketId = product.getSupermarket().getId();
//        if (supermarketRepository.findById(supermarketId).isEmpty()) {
//            throw new ResourceNotFoundException("Siêu thị không tìm thấy với id: " + productSubCategoryId);
//        }

        return null;
    }

    @Override
    public Product disableProduct(UUID productId) throws ResourceNotFoundException {
        Optional<Product> product = productRepository.findById(productId);
        if (product.isEmpty()) {
            throw new ResourceNotFoundException("Sản phảm không tìm thấy với id: " + productId);
        }
        product.get().setStatus(Status.DISABLE.ordinal());

        return productRepository.save(product.get());
    }

    @Override
    @Transactional
    public Product createProduct(ProductCreate productCreate) throws ResourceNotFoundException {
        HashMap<String, String> errorFields = new HashMap<>();
        Product product = new Product();
        if (productCreate.getName().length() > 50) {
            errorFields.put("Lỗi nhập tên sản phẩm", "Tên sản phẩm chỉ có tối đa 50 kí tự!");
        }

        if (productCreate.getProductSubCategory().getId() == null && productCreate.getProductSubCategory().getName().length() > 50) {
            errorFields.put("Lỗi nhập tên SubCategory", "Tên sản phẩm chỉ có tối đa 50 kí tự!");
        }

        if (productCreate.getProductSubCategory().getId() == null && productCreate.getProductSubCategory().getAllowableDisplayThreshold() <= 0) {
            errorFields.put("Lỗi nhập AllowableDisplayThreshold", "AllowableDisplayThreshold không thể âm hoặc bằng 0!");
        }

        if (productCreate.getProductSubCategory().getProductCategory().getId() == null && productCreate.getProductSubCategory().getProductCategory().getName().length() > 50) {
            errorFields.put("Lỗi nhập tên category", "Tên category chỉ có tối đa 50 kí tự!");
        }

        Optional<Supermarket> supermarket = supermarketRepository.findById(productCreate.getSupermarketId());
        if (supermarket.isEmpty()) {
            errorFields.put("Lỗi không tìm thấy", "Siêu thị không tìm thấy với id: " + productCreate.getSupermarketId());
        }

        for (ProductBatchCreate productBatch : productCreate.getProductBatchList()) {
            if (productBatch.getPrice() < 0 || productBatch.getPriceOriginal() < 0) {
                errorFields.put("Lỗi nhập giá cho lô HSD " + productBatch.getExpiredDate(), "Giá bán không thế âm!");
            }

            Integer althd = productCreate.getProductSubCategory().getId() != null ?
                    productSubCategoryRepository.findById(productCreate.getProductSubCategory().getId())
                            .orElseThrow(() -> new ResourceNotFoundException("Product Sub Category không tìm thấy với id: " + productCreate.getProductSubCategory().getId())).getAllowableDisplayThreshold() : productCreate.getProductSubCategory().getAllowableDisplayThreshold();

            if (productBatch.getExpiredDate().isBefore(LocalDate.now().plus(althd, ChronoUnit.DAYS))) {
                errorFields.put("Lỗi nhập ngày hết hạn cho lô HSD " + productBatch.getExpiredDate(), "Ngày hết hạn phải sau ngày hiện tại cộng thêm số ngày điều kiện cho hàng cận hạn sử dụng có trong SUBCATEGORY!");
            }
        }


        if (errorFields.size() > 0) {
            throw new InvalidInputException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
        }


        List<ProductBatch> productBatchList = new ArrayList<>();
        for (ProductBatchCreate productBatchCreate : productCreate.getProductBatchList()) {
            for (ProductBatchAddress productBatchAddress : productBatchCreate.getProductBatchAddresses()) {
                Optional<SupermarketAddress> supermarketAddress = supermarketAddressRepository.findById(productBatchAddress.getSupermarketAddressId());
                if (supermarketAddress.isPresent() && supermarket.isPresent() && supermarketAddress.get().getSupermarket().getId().equals(supermarket.get().getId())) {
                    ProductBatch productBatch = new ProductBatch();
                    productBatch.setPrice(productBatchCreate.getPrice());
                    productBatch.setPriceOriginal(productBatchCreate.getPriceOriginal());
                    productBatch.setExpiredDate(productBatchCreate.getExpiredDate());
                    productBatch.setQuantity(productBatchAddress.getQuantity());
                    productBatch.setSupermarketAddress(supermarketAddress.get());
                    productBatchList.add(productBatch);
                } else {
                    throw new ResourceNotFoundException("Địa chỉ siêu thị cho lô HSD: " + productBatchCreate.getExpiredDate() + " không tìm thấy với id hoặc không có trong danh sách địa chỉ của siêu thị: " + supermarket.get().getName());
                }
            }
        }

        ModelMapper modelMapper = new ModelMapper();
        modelMapper.map(productCreate, product);
        product.setSupermarket(supermarket.get());
        product.setProductBatchList(productBatchList);
        product.setStatus(Status.ENABLE.ordinal());

        UUID productCategoryId = product.getProductSubCategory().getProductCategory().getId();
        UUID productSubCategoryId = product.getProductSubCategory().getId();

        //Save new product Category if id is null
        if (productSubCategoryId == null) {
            if (productCategoryId != null) {
                product.getProductSubCategory()
                        .setProductCategory(productCategoryRepository.findById(productCategoryId)
                                .orElseThrow(() -> new ResourceNotFoundException("Product Category không tìm thấy với id: " + productCategoryId)));
            } else {
                ProductCategory productCategoryNew = productCategoryRepository.save(product.getProductSubCategory().getProductCategory());
                product.getProductSubCategory().setProductCategory(productCategoryNew);
            }
        }

        //Save new product sub Category if id is null
        product.setProductSubCategory(productSubCategoryId != null ?
                productSubCategoryRepository.findById(productSubCategoryId)
                        .orElseThrow(() -> new ResourceNotFoundException("Product Sub Category không tìm thấy với id: " + productSubCategoryId))
                :
                productSubCategoryRepository.save(product.getProductSubCategory()));


        return productRepository.save(product);
    }

    @Override
    public List<Product> createProductByExcel(MultipartFile file) throws IOException, InvalidExcelFileDataException {
//        LinkedHashMap<String, String> errorFields = new LinkedHashMap<>();
//
//        Workbook workbook;
//        if (isXLSFile(file)) {
//            workbook = new HSSFWorkbook(file.getInputStream());
//        } else if (isXLSXFile(file)) {
//            workbook = new XSSFWorkbook(file.getInputStream());
//        } else {
//            errorFields.put("Invalid file type", "File này có định dạng không phải excel!");
//            throw new InvalidExcelFileDataException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
//        }
//
//        List<Product> productList = new ArrayList();
//        LinkedHashMap<Integer, ByteArrayOutputStream> productImages = new LinkedHashMap<>();
//        Sheet sheet = workbook.getSheetAt(0);
//        //Get first row as title
//        Row titleRow = sheet.getRow(0);
//        List lst = workbook.getAllPictures();
//
//        //Get all images
//        int imageRow = 1;
//        for (Iterator it = lst.iterator(); it.hasNext(); ) {
//
//            PictureData pict = (PictureData) it.next();
//
//            String ext = pict.suggestFileExtension();
//
//            byte[] data = pict.getData();
//            ByteArrayOutputStream productImageByteArrayOutputStream = new ByteArrayOutputStream();
//            productImageByteArrayOutputStream.write(data, 0, data.length);
//            if (ext.equals("png")) {
//                productImages.put(imageRow, productImageByteArrayOutputStream);
//            } else if (ext.equals("jpeg")) {
//                productImages.put(imageRow, productImageByteArrayOutputStream);
//            }
//            imageRow++;
//        }
//
//        int rowIndex = 0;
//        for (Row row : sheet) {
//            if (rowIndex != 0 && row != null) {
//                Product product = new Product();
//                ProductSubCategory productSubCategory = new ProductSubCategory();
//                Supermarket supermarket = new Supermarket();
//                int cellIndex = 0;
//                for (Cell cell : row) {
//                    log.info(titleRow.getCell(cellIndex) + ", " + row.getCell(cellIndex));
//                    validateAndGetProductData(sheet, product, row, titleRow, cell, errorFields, cellIndex);
//                    validateAndGetProductSubCateData(sheet, productSubCategory, row, titleRow, cell, errorFields, cellIndex);
//                    validateAndGetSupermarketData(supermarket, row, titleRow, cell, errorFields, cellIndex);
//                    cellIndex++;
//                }
//
//                if (cellIndex > 0) {
//
//                    Optional<ProductSubCategory> productSubCategoryExistedCheck = productSubCategoryRepository.findByName(productSubCategory.getName());
//                    if (productSubCategoryExistedCheck.isPresent()) {
//                        productSubCategory = productSubCategoryExistedCheck.get();
//                    } else {
//                        errorFields.put("Lỗi xử lí tên loại sản phẩm phụ tại STT " + row.getCell(0), productSubCategory.getName() + " không tìm thấy trong hệ thống!");
//                    }
//
//
//                    Optional<Supermarket> supermarketExistedCheck = supermarketRepository.findByName(supermarket.getName());
//                    if (supermarketExistedCheck.isPresent()) {
//                        supermarket = supermarketExistedCheck.get();
//                    } else {
//                        errorFields.put("Lỗi xử lí tên siêu thị tại STT " + row.getCell(0), supermarket.getName() + " không tìm thấy trong hệ thống!");
//                    }
//
//                    if (productSubCategory.getAllowableDisplayThreshold() != null && product.getExpiredDate() != null && product.getExpiredDate().isBefore(LocalDate.now().plus(productSubCategory.getAllowableDisplayThreshold(), ChronoUnit.DAYS))) {
//                        errorFields.put("Lỗi xử lí HSD tại STT " + row.getCell(0), "HSD phải sau ngày hiện tại cộng thêm số ngày điều kiện cho hàng cận hạn sử dụng có trong SUBCATEGORY!");
//                    }
//
//                    if (productImages.get((int) row.getCell(0).getNumericCellValue()) != null) {
//                        String imageUrl = FirebaseService.uploadImageToStorage(productImages.get((int) row.getCell(0).getNumericCellValue()), product.getName());
//                        product.setImageUrl(imageUrl);
//                    }
//                    product.setStatus(Status.ENABLE.ordinal());
//                    product.setProductSubCategory(productSubCategory);
//                    product.setSupermarket(supermarket);
//                    productList.add(product);
//                }
//
//            }
//            rowIndex++;
//        }
//
//        if (errorFields.size() > 0) {
//            throw new InvalidExcelFileDataException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
//        }

        return null;
    }

    private static boolean isXLSXFile(MultipartFile file) {
        try {
            new XSSFWorkbook(file.getInputStream());
            return true; // Successfully opened as XLSX workbook
        } catch (Exception e) {
            return false; // Failed to open as XLSX workbook
        }
    }

    private static boolean isXLSFile(MultipartFile file) {
        try {
            new HSSFWorkbook(file.getInputStream());
            return true; // Successfully opened as XLS workbook
        } catch (Exception e) {
            return false; // Failed to open as XLS workbook
        }
    }

    private static void validateAndGetProductData(Sheet sheet, Product product, Row row, Row titleRow,
                                                  Cell cell, LinkedHashMap<String, String> errorFields, int cellIndex) {
//        XSSFSheet xssfSheet = (XSSFSheet) sheet;
//        List<XSSFPictureData> pictures = xssfSheet.getWorkbook().getAllPictures();
//        Pattern pattern;
//        Matcher matcher;
//        switch (titleRow.getCell(cellIndex).toString()) {
//            case "Tên":
//                if (cell.getCellType().equals(CellType.STRING)) {
//                    String productName = cell.getStringCellValue();
//                    if (productName.length() > 50) {
//                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
//                    } else {
//                        product.setName(productName.trim().replaceAll("\\s+", " "));
//                    }
//                } else {
//                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.STRING);
//                }
//                break;
//            case "Giá bán":
//                if (cell.getCellType().equals(CellType.NUMERIC)) {
//                    int price = (int) cell.getNumericCellValue();
//                    if (price < 0) {
//                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
//                    } else {
//                        product.setPrice(price);
//                    }
//                } else {
//                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.NUMERIC);
//                }
//                break;
//            case "Giá gốc":
//                if (cell.getCellType().equals(CellType.NUMERIC)) {
//                    int priceOriginal = (int) cell.getNumericCellValue();
//                    if (priceOriginal < 0) {
//                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
//                    } else {
//                        product.setPriceOriginal(priceOriginal);
//                    }
//                } else {
//                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.NUMERIC);
//                }
//                break;
//            case "Mô tả sản phẩm":
//                if (cell.getCellType().equals(CellType.STRING)) {
//                    product.setDescription(cell.getStringCellValue().trim().replaceAll("\\s+", " "));
//                } else {
//                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.STRING);
//                }
//                break;
//            case "Ngày HSD":
//                if (cell.getCellType().equals(CellType.NUMERIC)) {
//                    if (DateUtil.isCellDateFormatted(cell)) {
//                        product.setExpiredDate(convertDateToLocalDate(cell.getDateCellValue()));
//                    } else {
//                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
//                    }
//                } else {
//                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.NUMERIC);
//                }
//                break;
//            case "Số lượng":
//                if (cell.getCellType().equals(CellType.NUMERIC)) {
//                    int priceOriginal = (int) cell.getNumericCellValue();
//                    if (priceOriginal < 0) {
//                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
//                    } else {
//                        product.setQuantity(priceOriginal);
//                    }
//                } else {
//                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.NUMERIC);
//                }
//
//                break;
//        }
    }

    private static void validateAndGetProductSubCateData(Sheet sheet, ProductSubCategory productSubCategory, Row row, Row titleRow,
                                                         Cell cell, LinkedHashMap<String, String> errorFields, int cellIndex) {
        XSSFSheet xssfSheet = (XSSFSheet) sheet;
        List<XSSFPictureData> pictures = xssfSheet.getWorkbook().getAllPictures();
        Pattern pattern;
        Matcher matcher;
        switch (titleRow.getCell(cellIndex).toString()) {
            case "Tên loại sản phẩm phụ":
                if (cell.getCellType().equals(CellType.STRING)) {
                    String productSubCateName = cell.getStringCellValue();
                    if (productSubCateName.length() > 50) {
                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
                    } else {
                        productSubCategory.setName(productSubCateName.trim().replaceAll("\\s+", " "));
                    }
                } else {
                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.STRING);
                }
                break;
        }
    }

    private static void validateAndGetSupermarketData(Supermarket supermarket, Row row, Row titleRow,
                                                      Cell cell, LinkedHashMap<String, String> errorFields, int cellIndex) {
        Pattern pattern;
        Matcher matcher;
        switch (titleRow.getCell(cellIndex).toString()) {
            case "Tên siêu thị":
                if (cell.getCellType().equals(CellType.STRING)) {
                    String supermarketName = cell.getStringCellValue();
                    if (supermarketName.length() > 50) {
                        putValidateDataError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString());
                    } else {
                        supermarket.setName(supermarketName.trim().replaceAll("\\s+", " "));
                    }
                } else {
                    putFormatError(errorFields, row.getCell(0).toString(), titleRow.getCell(cellIndex).toString(), CellType.STRING);
                }
                break;
        }
    }

    private static void putFormatError(LinkedHashMap<String, String> errorFields, String STT, String title, CellType cellType) {
        switch (cellType) {
            case STRING ->
                    errorFields.put("Lỗi định dạng " + title + " tại STT " + STT, title + " có định dạng không phải là Chữ");
            case NUMERIC ->
                    errorFields.put("Lỗi định dạng " + title + " tại STT " + STT, title + " có định dạng không phải là Số");
        }
    }

    private static void putValidateDataError(LinkedHashMap<String, String> errorFields, String STT, String title) {
        switch (title) {
            case "Tên":
                errorFields.put("Lỗi xứ lí tên sản phẩm tại STT " + STT, title + " có quá 50 kí tự!");
                break;
            case "Giá bán":
                errorFields.put("Lỗi xứ lí giá bán sản phẩm tại STT " + STT, title + " đang âm!");
                break;
            case "Giá gốc":
                errorFields.put("Lỗi xứ lí giá gốc sản phẩm tại STT " + STT, title + " đang âm!");
                break;
            case "Mô tả sản phẩm":
                break;
            case "Ngày HSD":
                errorFields.put("Lỗi xử lí HSD sản phẩm tại STT " + STT, title + "không phải là " + " dữ liệu dạng DATE");
                break;
            case "Số lượng":
                errorFields.put("Lỗi xứ lí số lượng sản phẩm tại STT " + STT, title + " đang âm!");
                break;
            case "Ảnh sản phẩm":
                break;
            case "Tên loại sản phẩm phụ":
                errorFields.put("Lỗi xứ lí tên loại sản phẩm phụ tại STT " + STT, title + " có quá 50 kí tự!");
                break;
            case "Tên siêu thị":
                errorFields.put("Lỗi xứ lí Tên siêu thị phụ tại STT " + STT, title + " có quá 50 kí tự!");
                break;
        }
    }

    private static LocalDate convertDateToLocalDate(Date date) {
        // Convert Date to GregorianCalendar
        GregorianCalendar calendar = new GregorianCalendar();
        calendar.setTime(date);

        // Convert GregorianCalendar to Instant
        Instant instant = calendar.toInstant();

        // Convert Instant to LocalDateTime
        LocalDate localDate = LocalDate.from(instant.atZone(ZoneId.systemDefault()).toLocalDateTime());

        return localDate;
    }

}
