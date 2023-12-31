package com.fpt.capstone.savinghourmarket.service.serviceImpl;


import com.fpt.capstone.savinghourmarket.common.SystemStatus;
import com.fpt.capstone.savinghourmarket.entity.Configuration;
import com.fpt.capstone.savinghourmarket.exception.InvalidInputException;
import com.fpt.capstone.savinghourmarket.repository.ConfigurationRepository;
import com.fpt.capstone.savinghourmarket.service.SystemConfigurationService;
import com.fpt.capstone.savinghourmarket.util.Utils;
import jakarta.json.*;
import jakarta.json.stream.JsonGenerator;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class ConfigurationSystemServiceImpl implements SystemConfigurationService {

//    @Value("classpath:admin_configuration.json")
//    private Resource adminConfigurationResource;

    private final ConfigurationRepository configurationRepository;

    @Override
    @Transactional
    public Configuration updateConfiguration(Configuration configurationUpdateBody) throws IOException {
        HashMap errorFields = new HashMap<>();

        if(configurationUpdateBody.getLimitOfOrders() <= 0) {
            errorFields.put("limitOfOrdersError", "Value must be higher than 0");
        }

//        if(configurationUpdateBody.getSystemStatus() != 0 && configurationUpdateBody.getSystemStatus() != 1) {
//            errorFields.put("systemStatusError", "Value must be 0 (Maintaining) or 1 (Active)");
//        }

//        if(configurationUpdateBody.getNumberOfSuggestedPickupPoint() <= 0) {
//            errorFields.put("numberOfSuggestedPickupPointError", "Value must be higher than 0");
//        }

        if(configurationUpdateBody.getExtraShippingFeePerKilometer() < 1000) {
            errorFields.put("extraShippingFeePerKilometerError", "Value must be higher or equal 1000VND");
        }

        if(configurationUpdateBody.getMinKmDistanceForExtraShippingFee() <= 0) {
            errorFields.put("minKmDistanceForExtraShippingFeeError", "Value must be higher than 0");
        }

        if(configurationUpdateBody.getInitialShippingFee() < 1000) {
            errorFields.put("initialShippingFeeError", "Value must be higher or equal 1000VND");
        }

        if(configurationUpdateBody.getDeleteUnpaidOrderTime() <= 0) {
            errorFields.put("deleteUnpaidOrderTimeError", "Value must be higher than 0");
        }

        if(configurationUpdateBody.getTimeAllowedForOrderCancellation() < 0) {
            errorFields.put("timeAllowedForOrderCancellationError", "Value must not be lower than 0");
        }

        if(configurationUpdateBody.getAllowableOrderDateThreshold() <= 0) {
            errorFields.put("allowableOrderDateThresholdError", "Value must not be lower than or equal 0");
        }

        if(errorFields.size() > 0){
            throw new InvalidInputException(HttpStatus.UNPROCESSABLE_ENTITY, HttpStatus.UNPROCESSABLE_ENTITY.getReasonPhrase().toUpperCase().replace(" ", "_"), errorFields);
        }

        Configuration configuration = getConfiguration();

//        configuration.setSystemStatus(configurationUpdateBody.getSystemStatus());
        configuration.setLimitOfOrders(configurationUpdateBody.getLimitOfOrders());
//        configuration.setNumberOfSuggestedPickupPoint(configurationUpdateBody.getNumberOfSuggestedPickupPoint());
        configuration.setDeleteUnpaidOrderTime(configurationUpdateBody.getDeleteUnpaidOrderTime());
        configuration.setInitialShippingFee(configurationUpdateBody.getInitialShippingFee());
        configuration.setMinKmDistanceForExtraShippingFee(configurationUpdateBody.getMinKmDistanceForExtraShippingFee());
        configuration.setExtraShippingFeePerKilometer(configurationUpdateBody.getExtraShippingFeePerKilometer());
        configuration.setTimeAllowedForOrderCancellation(configurationUpdateBody.getTimeAllowedForOrderCancellation());
        configuration.setAllowableOrderDateThreshold(configurationUpdateBody.getAllowableOrderDateThreshold());
//        JsonObjectBuilder configurationBuilder = Json.createObjectBuilder();
//
//        configurationBuilder.add("systemStatus", configurationUpdateBody.getSystemStatus());
//        configurationBuilder.add("limitOfOrders",  configurationUpdateBody.getLimitOfOrders());
//        configurationBuilder.add("numberOfSuggestedPickupPoint",  configurationUpdateBody.getNumberOfSuggestedPickupPoint());
//        configurationBuilder.add("deleteUnpaidOrderTime",  configurationUpdateBody.getDeleteUnpaidOrderTime());
//        configurationBuilder.add("initialShippingFee", configurationUpdateBody.getInitialShippingFee());
//        configurationBuilder.add("minKmDistanceForExtraShippingFee", configurationUpdateBody.getMinKmDistanceForExtraShippingFee());
//        configurationBuilder.add("extraShippingFeePerKilometer", configurationUpdateBody.getExtraShippingFeePerKilometer());
//        configurationBuilder.add("timeAllowedForOrderCancellation", configurationUpdateBody.getTimeAllowedForOrderCancellation());
//
//        JsonObject configurationJsonObject = configurationBuilder.build();
//
//        OutputStream os = new FileOutputStream(adminConfigurationResource.getFile());
//
//        JsonWriter jsonWriter;
//
//        Map< String, Boolean > config = new HashMap < String, Boolean > ();
//        config.put(JsonGenerator.PRETTY_PRINTING, true);
//
//        JsonWriterFactory factory = Json.createWriterFactory(config);
//        jsonWriter = factory.createWriter(os);
//
//        jsonWriter.writeObject(configurationJsonObject);
//
//        jsonWriter.close();
//        os.close();

        return configuration;
    }

    @Override
    @Transactional
    public Map<String, Integer> updateSystemState(SystemStatus systemState) {
//        HashMap errorFields = new HashMap<>();
        Configuration configuration = getConfiguration();
        configuration.setSystemStatus(systemState == null ? SystemStatus.ACTIVE.ordinal() : systemState.ordinal());
        return Map.of("systemStatus", configuration.getSystemStatus());
    }

    @Override
    public Configuration getConfiguration() {
        Configuration configuration = configurationRepository.findAll().get(0);
        return configuration;
    }
}
