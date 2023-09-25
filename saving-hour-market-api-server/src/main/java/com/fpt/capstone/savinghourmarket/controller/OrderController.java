package com.fpt.capstone.savinghourmarket.controller;

import com.fpt.capstone.savinghourmarket.entity.Order;
import com.fpt.capstone.savinghourmarket.entity.OrderGroup;
import com.fpt.capstone.savinghourmarket.exception.BadRequestException;
import com.fpt.capstone.savinghourmarket.exception.NoSuchOrderException;
import com.fpt.capstone.savinghourmarket.exception.OrderCancellationNotAllowedException;
import com.fpt.capstone.savinghourmarket.exception.ResourceNotFoundException;
import com.fpt.capstone.savinghourmarket.model.OrderCreate;
import com.fpt.capstone.savinghourmarket.model.OrderProduct;
import com.fpt.capstone.savinghourmarket.service.OrderService;
import com.google.firebase.auth.FirebaseAuthException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "/api/order/")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping("/getAll")
    public ResponseEntity<List<Order>> getAll() throws NoSuchOrderException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchAll());
    }

    @GetMapping("/getOrdersToSpecificLocations")
    public ResponseEntity<List<Order>> getListOfOrdersNotInGroup() throws NoSuchOrderException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchAllNotInGroup());
    }

    @GetMapping("/getGroupOfOrders")
    public ResponseEntity<List<OrderGroup>> getListOfOrdersWithGroup() throws NoSuchOrderException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchAllWithGroup());
    }

    @GetMapping("/getOrdersByStatus")
    public ResponseEntity<List<Order>> getListOfOrdersByStatus(@RequestParam Integer status) throws NoSuchOrderException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchByStatus(status));
    }

    @GetMapping("/getCustomerOrders")
    public ResponseEntity<List<Order>> getCustomerOrder(@RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken) throws ResourceNotFoundException, NoSuchOrderException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchCustomerOrder(jwtToken));
    }

    @GetMapping("/getCustomerOrdersByStatus")
    public ResponseEntity<List<Order>> getCustomerOrderByStatus(@RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken, @RequestHeader(name = "Status", defaultValue = "4") Integer status) throws ResourceNotFoundException, NoSuchOrderException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchCustomerOrderByStatus(jwtToken, status));
    }

    @GetMapping("/getOrderDetailById/{id}")
    public ResponseEntity<List<OrderProduct>> getOrderDetailById(@PathVariable UUID id) throws ResourceNotFoundException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchOrderDetail(id));
    }

    @PutMapping("/createOrder")
    public ResponseEntity<String> getCustomerOrder(@RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken , @Valid @RequestBody OrderCreate order, BindingResult bindingResult) throws ResourceNotFoundException, FirebaseAuthException, IOException, BadRequestException {
        if (bindingResult.hasErrors()) {
            throw  new BadRequestException("Validation error while creating");
        }
        return ResponseEntity.status(HttpStatus.OK).body(orderService.createOrder(jwtToken,order));
    }

    @PutMapping("/cancelOrder/{id}")
    public ResponseEntity<String> cancelOrder(@PathVariable UUID id) throws ResourceNotFoundException, OrderCancellationNotAllowedException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.cancelOrder(id));
    }

}
