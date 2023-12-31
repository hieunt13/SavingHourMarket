package com.fpt.capstone.savinghourmarket.exception;

import lombok.Getter;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;

@Getter
public class InvalidInputException extends ResponseStatusException {
    private HashMap errorFields;
    public InvalidInputException(HttpStatusCode status, String message, HashMap errorFields) {
        super(status, message);
        this.errorFields = errorFields;
    }
}
