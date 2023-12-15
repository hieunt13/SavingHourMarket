package com.fpt.capstone.savinghourmarket.common;

public enum AdditionalResponseCode {
    REVOKED_ID_TOKEN(401),
    UNVERIFIED_EMAIL(403),
    EMAIL_ALREADY_EXISTS(403),
    STAFF_ACCESS_FORBIDDEN(403),
    STAFF_NOT_FOUND(404),
    SUPERMARKET_ADDRESS_NOT_FOUND(404),
    SUPERMARKET_ADDRESS_IN_PRODUCT_BATCH(403),
    SYSTEM_IS_NOT_IN_MAINTAINING_STATE(409),
    FEEDBACK_NOT_FOUND(404),
    DISCOUNT_NOT_FOUND(404),
    ORDER_NOT_FOUND(404),
    PICKUP_POINT_NOT_FOUND(404),
    PICKUP_POINT_IS_IN_PROCESSING_ORDER(403),
    TIME_FRAME_NOT_FOUND(404),
    ORDER_BATCH_NOT_FOUND(404),
    ORDER_GROUP_NOT_FOUND(404),
    TIME_FRAME_IS_IN_PROCESSING_ORDER(403),
    PRODUCT_CONSOLIDATION_AREA_NOT_FOUND(404),
    PRODUCT_CONSOLIDATION_AREA_IS_IN_PROCESSING_ORDER(403),
    CUSTOMER_HAVING_PROCESSING_ORDER(403),
    STAFF_IS_IN_PROCESSING_ORDER(403),
    STAFF_IS_IN_PROCESSING_ORDER_IN_SELECTED_PICKUP_POINT(403),
    SELF_STATUS_CHANGE_NOT_ALLOWED(403),
    SELF_ROLE_CHANGE_NOT_ALLOWED(403),
    CUSTOMER_NOT_FOUND(404),
    DISABLE_SUPERMARKET_FORBIDDEN(403),
    SUPERMARKET_NOT_FOUND(404),
    REQUIRED_E_PAYMENT(403),
    PRODUCT_NOT_FOUND(404),
    BATCHING_CONFLICT(409),
    PRODUCT_CATEGORY_NOT_FOUND(404),
    PRODUCT_SUB_CATEGORY_NOT_FOUND(404),
    ORDER_IS_PAID(403),
    TRANSACTION_NOT_FOUND(404),
    TRANSACTION_IS_REFUNDED(403);

    private int code;

    AdditionalResponseCode(int code) {
        this.code = code;
    }

    public int getCode() {
        return this.code;
    }
}
