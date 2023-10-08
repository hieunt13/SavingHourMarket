package com.fpt.capstone.savinghourmarket.controller;

import com.fpt.capstone.savinghourmarket.common.FeedbackObject;
import com.fpt.capstone.savinghourmarket.common.FeedbackStatus;
import com.fpt.capstone.savinghourmarket.common.SortType;
import com.fpt.capstone.savinghourmarket.entity.FeedBack;
import com.fpt.capstone.savinghourmarket.exception.FeedBackNotFoundException;
import com.fpt.capstone.savinghourmarket.exception.ResourceNotFoundException;
import com.fpt.capstone.savinghourmarket.model.FeedbackCreate;
import com.fpt.capstone.savinghourmarket.service.FeedBackService;
import com.google.firebase.auth.FirebaseAuthException;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("api/feedback")
public class FeedBackController {

    @Autowired
    private FeedBackService feedBackService;

    @PutMapping("/create")
    public ResponseEntity<String> createFeedback(@RequestHeader(HttpHeaders.AUTHORIZATION) @Parameter(hidden = true) String jwtToken,
                                                 @Valid @RequestBody FeedbackCreate feedBackCreate) throws ResourceNotFoundException, FirebaseAuthException {
        return ResponseEntity.status(HttpStatus.OK).body(feedBackService.createFeedback(jwtToken, feedBackCreate));
    }

    @PutMapping("/updateStatus")
    public ResponseEntity<String> updateStatus(@RequestParam UUID feedbackId, @RequestParam FeedbackStatus status) {
        return ResponseEntity.status(HttpStatus.OK).body(feedBackService.updateStatus(feedbackId, status));
    }

    @GetMapping("/getFeedbackForCustomer")
    public ResponseEntity<List<FeedBack>> getFeedbackForCustomer(@RequestHeader(HttpHeaders.AUTHORIZATION) @Parameter(hidden = true) String jwtToken,
                                                                 @RequestParam(required = false) SortType rateSortType,
                                                                 @RequestParam(required = false) FeedbackObject feedbackObject,
                                                                 @RequestParam(required = false) FeedbackStatus feedbackStatus,
                                                                 @RequestParam(defaultValue = "0") int page,
                                                                 @RequestParam(defaultValue = "5") int size) throws ResourceNotFoundException, FirebaseAuthException, FeedBackNotFoundException {
        return ResponseEntity.status(HttpStatus.OK).body(feedBackService.getFeedbackForCustomer(jwtToken, rateSortType, feedbackObject, feedbackStatus, page, size));
    }

    @GetMapping("/getFeedbackForStaff")
    public ResponseEntity<List<FeedBack>> getFeedbackForStaff(
            @RequestParam(required = false) UUID customerId,
            @RequestParam(required = false) SortType rateSortType,
            @RequestParam(required = false) FeedbackObject feedbackObject,
            @RequestParam(required = false) FeedbackStatus feedbackStatus,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size) throws ResourceNotFoundException, FirebaseAuthException, FeedBackNotFoundException {
        return ResponseEntity.status(HttpStatus.OK).body(feedBackService.getFeedbackForStaff(customerId, rateSortType, feedbackObject, feedbackStatus, page, size));

    }
}
