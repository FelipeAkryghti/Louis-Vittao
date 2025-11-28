package com.unilopers.roupas.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.unilopers.roupas.domain.InstallmentPayment;

public interface InstallmentPaymentRepository extends JpaRepository<InstallmentPayment, UUID> {
    // Métodos customizados podem ser adicionados aqui
}
