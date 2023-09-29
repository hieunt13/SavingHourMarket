package com.fpt.capstone.savinghourmarket.model;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SupermarketCreateRequestBody {

    @NotNull
    private String name;

    @NotNull
    private String address;

    @NotNull
    private String phone;
}