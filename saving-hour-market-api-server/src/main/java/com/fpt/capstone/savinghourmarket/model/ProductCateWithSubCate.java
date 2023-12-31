package com.fpt.capstone.savinghourmarket.model;

import java.util.List;
import java.util.UUID;

public interface ProductCateWithSubCate {
    UUID getId();

    String getName();

    Integer getStatus();

    List<ProductSubCateOnly> getProductSubCategories();
}
