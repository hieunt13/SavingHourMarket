package com.fpt.capstone.savinghourmarket.service;

import com.fpt.capstone.savinghourmarket.entity.Configuration;

import java.io.IOException;

public interface SystemConfigurationService {
    Configuration getConfiguration() throws IOException;

    Configuration updateConfiguration(Configuration configurationUpdateBody) throws IOException;
}