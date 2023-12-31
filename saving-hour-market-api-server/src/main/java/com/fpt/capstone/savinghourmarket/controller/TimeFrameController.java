package com.fpt.capstone.savinghourmarket.controller;

import com.fpt.capstone.savinghourmarket.common.AdditionalResponseCode;
import com.fpt.capstone.savinghourmarket.common.DeliverMethodAvailableTimeFrame;
import com.fpt.capstone.savinghourmarket.common.EnableDisableStatus;
import com.fpt.capstone.savinghourmarket.common.SystemStatus;
import com.fpt.capstone.savinghourmarket.entity.Configuration;
import com.fpt.capstone.savinghourmarket.entity.TimeFrame;
import com.fpt.capstone.savinghourmarket.exception.SystemNotInMaintainStateException;
import com.fpt.capstone.savinghourmarket.model.EnableDisableStatusChangeBody;
import com.fpt.capstone.savinghourmarket.model.TimeFrameCreateUpdateBody;
import com.fpt.capstone.savinghourmarket.model.TimeFrameListResponseBody;
import com.fpt.capstone.savinghourmarket.service.SystemConfigurationService;
import com.fpt.capstone.savinghourmarket.service.TimeFrameService;
import com.fpt.capstone.savinghourmarket.util.Utils;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping(value = "/api/timeframe")
public class TimeFrameController {

    private final FirebaseAuth firebaseAuth;
    private final TimeFrameService timeFrameService;
    private final SystemConfigurationService systemConfigurationService;

    @RequestMapping(value = "/getAll", method = RequestMethod.GET)
    public ResponseEntity<List<TimeFrame>> getAll() {
        List<TimeFrame> timeFrameList = timeFrameService.getAll();
        return ResponseEntity.status(HttpStatus.OK).body(timeFrameList);
    }

    @RequestMapping(value = "/getAllForStaff", method = RequestMethod.GET)
    public ResponseEntity<List<TimeFrame>> getAllForStaff(@Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken
            , @RequestParam(required = false) EnableDisableStatus enableDisableStatus) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        Utils.validateIdToken(idToken, firebaseAuth);
        List<TimeFrame> timeFrameList = timeFrameService.getAllForStaff(enableDisableStatus);
        return ResponseEntity.status(HttpStatus.OK).body(timeFrameList);
    }

    @RequestMapping(value = "/getAllForAdmin", method = RequestMethod.GET)
    public ResponseEntity<TimeFrameListResponseBody> getAllForAdmin(@Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken
//            , @RequestParam(required = false) DeliverMethodAvailableTimeFrame deliveryMethodAvailable
            , @RequestParam(required = false) EnableDisableStatus enableDisableStatus
            , @RequestParam(defaultValue = "0") Integer page
            , @RequestParam(defaultValue = "5") Integer limit) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        Utils.validateIdToken(idToken, firebaseAuth);
        TimeFrameListResponseBody timeFrameListResponseBody = timeFrameService.getAllForAdmin(enableDisableStatus, page, limit);
        return ResponseEntity.status(HttpStatus.OK).body(timeFrameListResponseBody);
    }


    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public ResponseEntity<TimeFrame> create(@Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken
            , @RequestBody @Valid TimeFrameCreateUpdateBody timeFrameCreateUpdateBody) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        Utils.validateIdToken(idToken, firebaseAuth);
//        Configuration configuration = systemConfigurationService.getConfiguration();
//        if(configuration.getSystemStatus() != SystemStatus.MAINTAINING.ordinal()){
//            throw new SystemNotInMaintainStateException(HttpStatus.valueOf(AdditionalResponseCode.SYSTEM_IS_NOT_IN_MAINTAINING_STATE.getCode()), AdditionalResponseCode.SYSTEM_IS_NOT_IN_MAINTAINING_STATE.toString());
//        }
        TimeFrame timeFrame = timeFrameService.create(timeFrameCreateUpdateBody);
        return ResponseEntity.status(HttpStatus.OK).body(timeFrame);
    }

    @RequestMapping(value = "/update", method = RequestMethod.PUT)
    public ResponseEntity<TimeFrame> update(@Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken
            , @RequestBody @Valid TimeFrameCreateUpdateBody timeFrameUpdateBody
            , @RequestParam UUID timeFrameId) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        Utils.validateIdToken(idToken, firebaseAuth);
        Configuration configuration = systemConfigurationService.getConfiguration();
        if(configuration.getSystemStatus() != SystemStatus.MAINTAINING.ordinal()){
            throw new SystemNotInMaintainStateException(HttpStatus.valueOf(AdditionalResponseCode.SYSTEM_IS_NOT_IN_MAINTAINING_STATE.getCode()), AdditionalResponseCode.SYSTEM_IS_NOT_IN_MAINTAINING_STATE.toString());
        }
        TimeFrame timeFrame = timeFrameService.update(timeFrameUpdateBody, timeFrameId);
        return ResponseEntity.status(HttpStatus.OK).body(timeFrame);
    }

    @RequestMapping(value = "/updateStatus", method = RequestMethod.PUT)
    public ResponseEntity<TimeFrame> updateStatus(@Parameter(hidden = true) @RequestHeader(HttpHeaders.AUTHORIZATION) String jwtToken
            , @RequestBody @Valid EnableDisableStatusChangeBody enableDisableStatusChangeBody) throws FirebaseAuthException {
        String idToken = Utils.parseBearTokenToIdToken(jwtToken);
        Utils.validateIdToken(idToken, firebaseAuth);
        Configuration configuration = systemConfigurationService.getConfiguration();
        if(configuration.getSystemStatus() != SystemStatus.MAINTAINING.ordinal()){
            throw new SystemNotInMaintainStateException(HttpStatus.valueOf(AdditionalResponseCode.SYSTEM_IS_NOT_IN_MAINTAINING_STATE.getCode()), AdditionalResponseCode.SYSTEM_IS_NOT_IN_MAINTAINING_STATE.toString());
        }
        TimeFrame timeFrame = timeFrameService.updateStatus(enableDisableStatusChangeBody);
        return ResponseEntity.status(HttpStatus.OK).body(timeFrame);
    }

    @RequestMapping(value = "/getForPickupPoint", method = RequestMethod.GET)
    public ResponseEntity<List<TimeFrame>> getForPickupPoint() {
        List<TimeFrame> timeFrameList = timeFrameService.getForPickupPoint();
        return ResponseEntity.status(HttpStatus.OK).body(timeFrameList);
    }



    @RequestMapping(value = "/getForHomeDelivery", method = RequestMethod.GET)
    public ResponseEntity<List<TimeFrame>> getForHomeDelivery() {
        List<TimeFrame> timeFrameList = timeFrameService.getForHomeDelivery();
        return ResponseEntity.status(HttpStatus.OK).body(timeFrameList);
    }
}
