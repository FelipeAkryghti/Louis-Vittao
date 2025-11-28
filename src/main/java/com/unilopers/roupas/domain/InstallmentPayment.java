package com.unilopers.roupas.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "tb_installment_payment")
@JacksonXmlRootElement(localName = "installmentPayment")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InstallmentPayment {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "installment_payment_id")
    @JacksonXmlProperty(localName = "installmentPaymentId")
    private UUID installmentPaymentId;

    @Column(name = "created_at")
    @JacksonXmlProperty(localName = "createdAt")
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "order_id", nullable = false)
    @JacksonXmlProperty(localName = "order")
    private Orders order;

    @Column(name = "installment_number")
    @JacksonXmlProperty(localName = "installmentNumber")
    private Integer installmentNumber;

    @Column(name = "amount")
    @JacksonXmlProperty(localName = "amount")
    private Double amount;

    @Column(name = "maturity")
    @JacksonXmlProperty(localName = "maturity")
    private LocalDate maturity;

    @Column(name = "paid")
    @JacksonXmlProperty(localName = "paid")
    private Boolean paid;

    @Column(name = "payment_date")
    @JacksonXmlProperty(localName = "paymentDate")
    private LocalDate paymentDate;

    @Column(name = "method", length = 255)
    @JacksonXmlProperty(localName = "method")
    private String method;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
