package com.fpt.capstone.savinghourmarket.entity;

import com.fpt.capstone.savinghourmarket.common.EnableDisableStatus;
import com.fpt.capstone.savinghourmarket.common.StaffRole;
import com.fpt.capstone.savinghourmarket.model.StaffCreateRequestBody;
import com.fpt.capstone.savinghourmarket.util.Utils;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.io.UnsupportedEncodingException;
import java.util.UUID;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class Staff {
    @Id
    @UuidGenerator
    private UUID id;

    @Column(columnDefinition = "varchar(50)")
    private String fullName;

    @Column(columnDefinition = "varchar(255)")
    private String email;

    @Column(columnDefinition = "text")
    private String avatarUrl;

    @Column(columnDefinition = "varchar(15)")
    private String role;

    @Column(columnDefinition = "tinyint")
    private Integer status;

    public Staff(StaffCreateRequestBody staffCreateRequestBody, StaffRole role) throws UnsupportedEncodingException {
        this.fullName = staffCreateRequestBody.getFullName();
        this.email = staffCreateRequestBody.getEmail();
        this.role = role.toString();
        this.avatarUrl = Utils.generatePublicImageUrlFirebaseStorage("public/default-avatar.jpg");
        this.status = EnableDisableStatus.ENABLE.ordinal();
    }
}
