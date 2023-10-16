package com.fpt.capstone.savinghourmarket.config;

import com.fpt.capstone.savinghourmarket.common.StaffRole;
import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;

import java.util.Optional;
import java.util.stream.Collectors;

@Configuration
@RequiredArgsConstructor
public class SpringSecurityConfig {
    private final AccessDeniedHandlerCustom accessDeniedHandlerCustom;
    private final AuthenticationEntryPointCustom authenticationEntryPointCustom;

    private String[] allStaffAndAdmin= {StaffRole.STAFF_DLV_0.toString()
            , StaffRole.STAFF_DLV_1.toString()
            , StaffRole.STAFF_MKT.toString()
            , StaffRole.STAFF_ORD.toString()
            , StaffRole.STAFF_SLT.toString()
            , "ADMIN"};

    private String[] selectionStaffAndAdmin= {StaffRole.STAFF_SLT.toString()
            , "ADMIN"};

    private String[] marketingStaffAndAdmin= {StaffRole.STAFF_MKT.toString(), "ADMIN"};

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(httpSecurityCsrfConfigurer -> httpSecurityCsrfConfigurer.disable())
                .authorizeHttpRequests((auth) -> {
                    auth.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()
                            .requestMatchers("/swagger-ui/**").permitAll()
                            .requestMatchers("/swagger-resources/**").permitAll()
                            .requestMatchers("/v3/api-docs/**").permitAll()
                            .requestMatchers("/swagger-ui.html").permitAll()
                            .requestMatchers(HttpMethod.POST, "/api/customer/registerWithEmailPassword").permitAll()
//                            .requestMatchers("/api/customer/updateInfo").authenticated()
                            .requestMatchers("/api/product/getProductsForCustomer").permitAll()
                            .requestMatchers("/api/product/getById").permitAll()
                            .requestMatchers("/api/product/getAllCategory").permitAll()
                            .requestMatchers("/api/product/getAllSubCategory").permitAll()
                            .requestMatchers("/api/product/getSaleReportSupermarket").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/product/createCategory").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/product/createSubCategory").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/product/updateSubCategory").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/product/updateCategory").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/discount/getDiscountsForCustomer").permitAll()
                            .requestMatchers("/api/discount/getDiscountById").permitAll()
                            .requestMatchers("/api/discount/getDiscountUsageReport").hasAnyRole(marketingStaffAndAdmin)
                            .requestMatchers("/api/timeframe/getAll").permitAll()
                            .requestMatchers("/api/timeframe/getForPickupPoint").permitAll()
                            .requestMatchers("/api/timeframe/getForHomeDelivery").permitAll()
                            .requestMatchers("/api/pickupPoint/getAll").permitAll()
                            .requestMatchers("/api/pickupPoint/getWithSortAndSuggestion").permitAll()
                            .requestMatchers("/api/transaction/processPaymentResult").permitAll()
//                            .requestMatchers("/api/staff/getInfoAfterGoogleLogged").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/staff/getInfo").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/staff/updateInfo").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/staff/getCustomerDetailByEmail").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/staff/createStaffAccount").hasRole("ADMIN")
                            .requestMatchers("/api/staff/getStaffByEmail").hasRole("ADMIN")
                            .requestMatchers("/api/product/getProductsForStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/discount/getDiscountsForStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/supermarket/create").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/supermarket/changeStatus").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/supermarket/updateInfo").hasAnyRole(selectionStaffAndAdmin)
                            .requestMatchers("/api/order/getOrdersForStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/order/getOrderGroupForStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/order/getOrderBatchForStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/order/assignDeliveryStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/order/assignPackageStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/feedback/updateStatus").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/feedback/getFeedbackForStaff").hasAnyRole(allStaffAndAdmin)
                            .requestMatchers("/api/order/sendNotification").permitAll();
                    auth.anyRequest().authenticated();
                });
//        http.csrf(httpSecurityCsrfConfigurer -> httpSecurityCsrfConfigurer.disable()).authorizeHttpRequests((auth) -> auth
//                .anyRequest().authenticated());
        http.oauth2ResourceServer((res) -> res.jwt(jwtConfigurer -> jwtConfigurer.jwtAuthenticationConverter(jwtAuthenticationConverter())).accessDeniedHandler(accessDeniedHandlerCustom).authenticationEntryPoint(authenticationEntryPointCustom));
        return http.build();
    }

//    @Bean
//    public WebSecurityCustomizer webSecurityCustomizer() {
//        return (web -> web.ignoring().requestMatchers("/swagger-ui/index.html").requestMatchers("/swagger-ui.html"));
//    }

    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwt -> Optional.ofNullable(jwt.getClaimAsString("user_role"))
                .stream()
                .map(s -> "ROLE_"+s.toString().toUpperCase())
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList()));
        return converter;
    }

}
