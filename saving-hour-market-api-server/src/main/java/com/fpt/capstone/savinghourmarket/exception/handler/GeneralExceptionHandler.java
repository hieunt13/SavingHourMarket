package com.fpt.capstone.savinghourmarket.exception.handler;

import com.fpt.capstone.savinghourmarket.exception.*;
import com.fpt.capstone.savinghourmarket.model.ApiError;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;

@RestControllerAdvice
public class GeneralExceptionHandler {
    @ExceptionHandler(ItemNotFoundException.class)
    public ResponseEntity<ApiError> itemNotFoundException(ItemNotFoundException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason());
        return ResponseEntity.status(e.getStatusCode()).body(apiError);
    }

    @ExceptionHandler(InvalidInputException.class)
    public ResponseEntity<ApiError> invalidUserInputExceptionHandler(InvalidInputException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason(), e.getErrorFields());
        return ResponseEntity.status(e.getStatusCode().value()).body(apiError);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiError> illegalArgumentExceptionHandler(IllegalArgumentException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), HttpStatus.CONFLICT.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT.value()).body(apiError);
    }

    @ExceptionHandler(SystemNotInMaintainStateException.class)
    public ResponseEntity<ApiError> systemNotInMaintainStateExceptionHandler(SystemNotInMaintainStateException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason());
        return ResponseEntity.status(e.getStatusCode()).body(apiError);
    }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<ApiError> conflictExceptionHandler(ConflictException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason());
        return ResponseEntity.status(e.getStatusCode()).body(apiError);
    }
}
