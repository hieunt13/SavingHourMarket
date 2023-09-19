package com.fpt.capstone.savinghourmarket.repository;

import com.fpt.capstone.savinghourmarket.entity.Customer;
import com.fpt.capstone.savinghourmarket.entity.Order;
import com.fpt.capstone.savinghourmarket.entity.OrderGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface OrderRepository extends JpaRepository<Order, UUID> {
    List<Order> findOrderByOrderGroupIsNull();

    List<Order> findOrderByStatus(Integer status);

    List<Order> findOrderByCustomer(Customer customer);
}
