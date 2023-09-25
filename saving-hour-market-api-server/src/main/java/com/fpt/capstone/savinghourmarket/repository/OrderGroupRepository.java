package com.fpt.capstone.savinghourmarket.repository;

import com.fpt.capstone.savinghourmarket.entity.OrderGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface OrderGroupRepository extends JpaRepository<OrderGroup, UUID> {
    Optional<OrderGroup> findByTimeFrameIdAndPickupPointId(UUID timeFrameId, UUID pickupPointId);
}
