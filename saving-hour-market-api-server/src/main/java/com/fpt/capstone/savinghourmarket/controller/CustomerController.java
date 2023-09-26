package com.fpt.capstone.savinghourmarket.controller;

import com.fpt.capstone.savinghourmarket.entity.Customer;
import com.fpt.capstone.savinghourmarket.model.CustomerPasswordRequestBody;
import com.fpt.capstone.savinghourmarket.model.CustomerRegisterRequestBody;
import com.fpt.capstone.savinghourmarket.model.CustomerUpdateRequestBody;
import com.fpt.capstone.savinghourmarket.service.CustomerService;
import com.fpt.capstone.savinghourmarket.util.Utils;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

@RestController
@RequestMapping("/api/customer")
@RequiredArgsConstructor
public class CustomerController {

    private final CustomerService customerService;

    private final FirebaseAuth firebaseAuth;

    @RequestMapping(value = "/registerWithEmailPassword", method = RequestMethod.POST , consumes = {"application/json"}, produces = {"application/json"})
    public ResponseEntity<Customer> register(@Valid @RequestBody CustomerRegisterRequestBody customerRegisterRequestBody) throws FirebaseAuthException, UnsupportedEncodingException {
        Customer customer = customerService.register(customerRegisterRequestBody);
        return ResponseEntity.status(HttpStatus.OK).body(customer);
    }

    @RequestMapping(value = "/getInfoAfterGoogleLogged", method = RequestMethod.GET)
    public ResponseEntity<Customer> getInfoGoogleLogged(@Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        String email = Utils.validateIdToken(idToken, firebaseAuth);
        Customer customer = customerService.getInfoGoogleLogged(email);
        return ResponseEntity.status(HttpStatus.OK).body(customer);
    }

    @RequestMapping(value = "getInfo", method = RequestMethod.GET)
    public ResponseEntity<Customer> getInfo(@Parameter(hidden = true)  @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        String email = Utils.validateIdToken(idToken, firebaseAuth);
        Customer customer = customerService.getInfo(email);
        return ResponseEntity.status(HttpStatus.OK).body(customer);
    }

    @RequestMapping(value = "/updateInfo", method = RequestMethod.PUT , consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<Customer> updateInfo(@RequestPart CustomerUpdateRequestBody customerUpdateRequestBody, @RequestPart(required = false)  MultipartFile imageFile, @Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken) throws FirebaseAuthException, IOException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        String email = Utils.validateIdToken(idToken, firebaseAuth);
        Customer customer = customerService.updateInfo(customerUpdateRequestBody, email, imageFile);
        return ResponseEntity.status(HttpStatus.OK).body(customer);
    }

    @RequestMapping(value = "/updatePassword", method = RequestMethod.PUT)
    public ResponseEntity<Void> updatePassword(@RequestBody CustomerPasswordRequestBody customerPasswordRequestBody, @Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        String email = Utils.validateIdToken(idToken, firebaseAuth);
        customerService.updatePassword(customerPasswordRequestBody, email);
        return ResponseEntity.status(HttpStatus.OK).body(null);
    }

}
