package com.fpt.capstone.savinghourmarket.config;

import com.google.maps.GeoApiContext;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GoogleServiceConfig {
    @Value("AIzaSyA9ZGqIsMJKMcpqjgGZXKW2QBNMmgXCX2g")
    private String apiKey;

    @Bean
    GeoApiContext geoApiContext() {
        GeoApiContext context = new GeoApiContext.Builder()
                .apiKey(apiKey)
                .build();
        return context;
    }
}
