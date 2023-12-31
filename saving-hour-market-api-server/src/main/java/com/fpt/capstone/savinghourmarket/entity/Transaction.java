package com.fpt.capstone.savinghourmarket.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class Transaction {
    @Id
    @UuidGenerator
    private UUID id;

    @Column(columnDefinition = "tinyint")
    private Integer paymentMethod;

    @Column(columnDefinition = "datetime(0)")
    private LocalDateTime paymentTime;

    private Integer amountOfMoney;

    @Column(columnDefinition = "varchar(15)")
    private String transactionNo;

    @ManyToOne(
            fetch = FetchType.LAZY
    )
    @JoinColumn(
            name = "order_id",
            referencedColumnName = "id"
    )
    @JsonIgnore
    private Order order;

    @OneToOne
    @JoinColumn(
            name = "refund_id",
            referencedColumnName = "id"
    )
    private Transaction refundTransaction;
}
