package com.fpt.capstone.savinghourmarket.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UuidGenerator;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
@Table(name = "orders")
public class Order {

//    public Order(Order order) {
//        this.id = order.getId();
//        this.receiverName = order.getReceiverName();
//        this.receiverPhone = order.getReceiverPhone();
//        this.orderDetailList = order.getOrderDetailList();
//    }

    @Id
    @UuidGenerator
    private UUID id;

    private String code;

    private Integer shippingFee;

    private Integer totalPrice;

    private String receiverPhone;

    private String receiverName;

    private Boolean isFeedBack;

    @Column(columnDefinition = "decimal(23,20)")
    private Float longitude;

    @Column(columnDefinition = "decimal(22,20)")
    private Float latitude;

    private Integer totalDiscountPrice;

    @CreationTimestamp
    @Column(columnDefinition = "datetime(0)")
    private LocalDateTime createdTime;

    private Date deliveryDate;

    @Column(columnDefinition = "text")
    private String qrCodeUrl;

    @Column(columnDefinition = "tinyint")
    private Integer status;

    @Column(columnDefinition = "tinyint")
    private Integer paymentMethod;

    @Column(columnDefinition = "tinyint")
    private Integer deliveryMethod;

    @Column(columnDefinition = "varchar(255)")
    private String addressDeliver;

    @Column(columnDefinition = "tinyint")
    private Integer paymentStatus;

    @ManyToOne()
    @JoinColumn(
            name = "packager_id",
            referencedColumnName = "id"
    )
    private Staff packager;

    @ManyToOne()
    @JoinColumn(
            name = "deliverer_id",
            referencedColumnName = "id"
    )
    private Staff deliverer;

    @ManyToOne()
    @JoinColumn(
            name = "customer_id",
            referencedColumnName = "id"
    )
    private Customer customer;

    @ManyToOne()
    @JoinColumn(
            name = "time_frame_id",
            referencedColumnName = "id"
    )
    private TimeFrame timeFrame;

    @ManyToOne()
    @JoinColumn(
            name = "pickup_point_id",
            referencedColumnName = "id"
    )
    private PickupPoint pickupPoint;

    @ManyToMany
    @JoinTable(
            name = "discount_order",
            joinColumns = @JoinColumn(name = "order_id"),
            inverseJoinColumns = @JoinColumn(name = "discount_id")
    )
    private List<Discount> discountList;

    @OneToMany(
            mappedBy = "order"
    )
    @JsonIgnore
    private List<Transaction> transaction;

    @ManyToOne(
    )
    @JoinColumn(
            name = "order_group_id",
            referencedColumnName = "id"
    )
    @JsonIgnore
    private OrderGroup orderGroup;

    @ManyToOne(
            fetch = FetchType.LAZY
    )
    @JoinColumn(
            name = "order_batch_id",
            referencedColumnName = "id"
    )
    @JsonIgnore
    private OrderBatch orderBatch;

    @ManyToOne()
    @JoinColumn(
            name = "product_consolidation_area_id",
            referencedColumnName = "id"
    )
    private ProductConsolidationArea productConsolidationArea;

    @OneToMany(
            mappedBy = "order",
            cascade = CascadeType.ALL
    )
    @JsonIgnore
    private List<OrderDetail> orderDetailList;

    @OneToOne(mappedBy = "order", fetch = FetchType.LAZY)
    @JsonIgnore
    private FeedBack feedBack;
}
