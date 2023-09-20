package com.fpt.capstone.savinghourmarket.common;

public enum AdditionalResponseCode {
    REVOKED_ID_TOKEN(401),
    UNVERIFIED_EMAIL(403);

    private int code;

    AdditionalResponseCode(int code) {
        this.code = code;
    }

    public int getCode() {
        return this.code;
    }
}