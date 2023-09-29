package com.fpt.capstone.savinghourmarket.repository;

import com.fpt.capstone.savinghourmarket.entity.OrderBatch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface OrderBatchRepository extends JpaRepository<OrderBatch, UUID> {
    Optional<OrderBatch> findByDistrictAndDeliverDate(String district, LocalDate deliveryDate);

    @Query("SELECT ob from OrderBatch  ob " +
            "WHERE " +
            "((:district IS NULL) OR (ob.district = :district)) " +
            "AND " +
            "((:deliveryDate IS NULL) OR (ob.deliverDate = :deliveryDate))")
    List<OrderBatch> findByDistrictOrDeliverDate(String district, LocalDate deliveryDate);
}