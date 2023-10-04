package com.fpt.capstone.savinghourmarket.controller;

import com.fpt.capstone.savinghourmarket.common.District;
import com.fpt.capstone.savinghourmarket.common.OrderStatus;
import com.fpt.capstone.savinghourmarket.common.SortType;
import com.fpt.capstone.savinghourmarket.entity.Order;
import com.fpt.capstone.savinghourmarket.entity.OrderBatch;
import com.fpt.capstone.savinghourmarket.entity.OrderGroup;
import com.fpt.capstone.savinghourmarket.entity.TimeFrame;
import com.fpt.capstone.savinghourmarket.exception.*;
import com.fpt.capstone.savinghourmarket.model.OrderCreate;
import com.fpt.capstone.savinghourmarket.model.OrderProduct;
import com.fpt.capstone.savinghourmarket.model.OrderWithDetails;
import com.fpt.capstone.savinghourmarket.service.FirebaseService;
import com.fpt.capstone.savinghourmarket.service.OrderService;
import com.google.firebase.auth.FirebaseAuthException;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.apache.http.HttpResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "/api/order/")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping("/getOrdersForCustomer")
    public ResponseEntity<List<Order>> getOrdersForCustomer(@RequestHeader(HttpHeaders.AUTHORIZATION) @Parameter(hidden = true) String jwtToken,
                                                        @RequestParam(required = false) SortType totalPriceSortType,
                                                        @RequestParam(required = false) SortType createdTimeSortType,
                                                        @RequestParam(required = false) SortType deliveryDateSortType,
                                                        @RequestParam(required = false) OrderStatus orderStatus,
                                                        @RequestParam(required = false) Boolean isPaid,
                                                        @RequestParam(defaultValue = "0")  Integer page,
                                                        @RequestParam(defaultValue = "10") Integer size)
            throws ResourceNotFoundException, NoSuchOrderException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchOrdersForCustomer(jwtToken,
                totalPriceSortType == null ? null : totalPriceSortType.name(),
                createdTimeSortType == null ? null : createdTimeSortType.name(),
                deliveryDateSortType == null ? null : deliveryDateSortType.name(),
                orderStatus,
                isPaid,
                page,
                size));
    }

    @GetMapping("/getOrdersForStaff")
    public ResponseEntity<List<Order>> getOrdersForStaff(@RequestParam(required = false) SortType totalPriceSortType,
                                                        @RequestParam(required = false) SortType createdTimeSortType,
                                                        @RequestParam(required = false) SortType deliveryDateSortType,
                                                        @RequestParam(required = false) OrderStatus orderStatus,
                                                        @RequestParam(required = false) UUID packagerId,
                                                        @RequestParam(required = false) Boolean isPaid,
                                                        @RequestParam(required = false) Boolean isGrouped,
                                                        @RequestParam(defaultValue = "0")  Integer page,
                                                        @RequestParam(defaultValue = "10") Integer size) throws ResourceNotFoundException, NoSuchOrderException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchOrdersForStaff(
                totalPriceSortType == null ? null : totalPriceSortType.name(),
                createdTimeSortType == null ? null : createdTimeSortType.name(),
                deliveryDateSortType == null ? null : deliveryDateSortType.name(),
                orderStatus,
                packagerId,
                isPaid,
                isGrouped,
                page,
                size)
        );
    }

    @GetMapping("/getOrderGroupForStaff")
    public ResponseEntity<List<OrderGroup>> getOrderGroupForStaff(@RequestParam(required = false) LocalDate deliverDate,
                                                                  @RequestParam(required = false) UUID timeFrameId,
                                                                  @RequestParam(required = false) UUID pickupPointId,
                                                                  @RequestParam(required = false) UUID delivererId ) throws NoSuchOrderException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchOrderGroups(deliverDate,timeFrameId,pickupPointId,delivererId));
    }

    @GetMapping("/getOrderBatchForStaff")
    public ResponseEntity<List<OrderBatch>> getOrderBatchForStaff(@RequestParam(required = false) District district, @RequestParam(required = false) LocalDate deliveryDate) throws NoSuchOrderException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchOrderBatches(district,deliveryDate));
    }

    @GetMapping("/getOrderDetail/{id}")
    public ResponseEntity<OrderWithDetails> getOrderDetail(@PathVariable UUID id) throws ResourceNotFoundException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.fetchOrderDetail(id));
    }


    @PutMapping("/createOrder")
    public ResponseEntity<Order> createOrder(@RequestHeader(HttpHeaders.AUTHORIZATION) @Parameter(hidden = true) String jwtToken,@Valid @RequestBody OrderCreate order) throws Exception {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.createOrder(jwtToken, order));
    }

    @PutMapping("/cancelOrder/{id}")
    public ResponseEntity<String> cancelOrder(@RequestHeader(HttpHeaders.AUTHORIZATION) @Parameter(hidden = true) String jwtToken, @PathVariable UUID id) throws ResourceNotFoundException, OrderCancellationNotAllowedException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.cancelOrder(jwtToken,id));
    }

    @PutMapping("/assignPackageStaff")
    public ResponseEntity<String> assignStaff(@RequestParam UUID orderId, @RequestParam UUID staffId) throws NoSuchOrderException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.assignPackager(orderId,staffId));
    }

    @PutMapping("/assignDeliveryStaff")
    public ResponseEntity<String> assignDeliveryStaffToGroupOrBatch(@RequestParam(required = false) UUID orderGroupId,
                                                                    @RequestParam(required = false) UUID orderBatchId,
                                                                    @RequestParam UUID staffId) throws NoSuchOrderException, ConflictGroupAndBatchException {
        return ResponseEntity.status(HttpStatus.OK).body(orderService.assignDeliverToOrderGroupOrBatch(orderGroupId,orderBatchId,staffId));
    }

    @PostMapping("/sendNotification")
    public ResponseEntity<HttpResponse> sendNotification(@RequestParam String title,@RequestParam String message,@RequestParam String topic) throws IOException {
        return ResponseEntity.status(HttpStatus.OK).body(FirebaseService.sendPushNotification(title,message,topic));
    }

}
