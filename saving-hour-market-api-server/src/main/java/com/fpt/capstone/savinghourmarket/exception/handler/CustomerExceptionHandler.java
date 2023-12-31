package com.fpt.capstone.savinghourmarket.exception.handler;

import com.fpt.capstone.savinghourmarket.exception.DisableCustomerForbiddenException;
import com.fpt.capstone.savinghourmarket.exception.InvalidExcelFileDataException;
import com.fpt.capstone.savinghourmarket.exception.InvalidInputException;
import com.fpt.capstone.savinghourmarket.exception.ResourceNotFoundException;
import com.fpt.capstone.savinghourmarket.model.ApiError;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;

@RestControllerAdvice
public class CustomerExceptionHandler {
    @ExceptionHandler(InvalidInputException.class)
    public ResponseEntity<ApiError> invalidUserInputExceptionHandler(InvalidInputException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason(), e.getErrorFields());
        return ResponseEntity.status(e.getStatusCode().value()).body(apiError);
    }

    @ExceptionHandler(InvalidExcelFileDataException.class)
    public ResponseEntity<ApiError> invalidUserInputExceptionHandler(InvalidExcelFileDataException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason(), e.getErrorFields());
        return ResponseEntity.status(e.getStatusCode().value()).body(apiError);
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ResponseEntity<ApiError> handleResourceNotFoundException (Exception e){
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ApiError(LocalDateTime.now().toString(), HttpStatus.NOT_FOUND.value(),e.getMessage()));
    }

    @ExceptionHandler(DisableCustomerForbiddenException.class)
    public ResponseEntity<ApiError> disableCustomerForbiddenExceptionHandler(DisableCustomerForbiddenException e) {
        ApiError apiError = new ApiError(LocalDateTime.now().toString(), e.getStatusCode().value(), e.getReason());
        return ResponseEntity.status(e.getStatusCode().value()).body(apiError);
    }
}
