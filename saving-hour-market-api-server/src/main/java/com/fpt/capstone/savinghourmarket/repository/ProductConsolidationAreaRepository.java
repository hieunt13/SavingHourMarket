package com.fpt.capstone.savinghourmarket.repository;

import com.fpt.capstone.savinghourmarket.entity.ProductConsolidationArea;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository

public interface ProductConsolidationAreaRepository extends JpaRepository<ProductConsolidationArea, UUID> {

    @Query("SELECT a FROM ProductConsolidationArea a " +
            "LEFT JOIN FETCH a.pickupPointList " +
            "WHERE " +
            "((:status IS NULL) OR (a.status = :status))")
    List<ProductConsolidationArea> getAllWithPickupPoint(Integer status);

    Optional<ProductConsolidationArea> findByAddress(String address);

    @Query("SELECT a FROM ProductConsolidationArea a " +
            "WHERE a.latitude = :latitude AND a.longitude = :longitude")
    Optional<ProductConsolidationArea> findByLongitudeAndLatitude(Double latitude, Double longitude);

    @Query("SELECT pca FROM ProductConsolidationArea  pca WHERE pca.id IN :productConsolidationAreaIdList ")
    List<ProductConsolidationArea> getAllByIdList(List<UUID> productConsolidationAreaIdList);
}