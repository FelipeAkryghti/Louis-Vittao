package com.unilopers.roupas.controller;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

// import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.unilopers.roupas.domain.InstallmentPayment;
import com.unilopers.roupas.domain.Orders;
import com.unilopers.roupas.repository.InstallmentPaymentRepository;
import com.unilopers.roupas.repository.OrderRepository;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/installmentpayment")
@RequiredArgsConstructor
public class InstallmentPaymentController {

    private final InstallmentPaymentRepository repository;
    private final OrderRepository orderRepository;

    @GetMapping(value = "/all", produces = MediaType.APPLICATION_XML_VALUE)
    public List<InstallmentPayment> getAll() {
        return repository.findAll();
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<InstallmentPayment> getById(@PathVariable UUID id) {
        Optional<InstallmentPayment> payment = repository.findById(id);
        return payment.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping(value = "/create", consumes = MediaType.APPLICATION_XML_VALUE, produces = MediaType.APPLICATION_XML_VALUE)
    public InstallmentPayment create(@RequestBody InstallmentPayment body) {
        if (body.getOrder() == null || body.getOrder().getOrderId() == null) {
            throw new RuntimeException("order.orderId é obrigatório");
        }

        Orders order = orderRepository.findById(body.getOrder().getOrderId())
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));

        InstallmentPayment payment = new InstallmentPayment();
        payment.setOrder(order);
        payment.setInstallmentNumber(body.getInstallmentNumber());
        payment.setAmount(body.getAmount());
        payment.setMaturity(body.getMaturity());
        payment.setPaid(body.getPaid());
        payment.setPaymentDate(body.getPaymentDate());
        payment.setMethod(body.getMethod());

        return repository.save(payment);
    }

    @PutMapping(value = "/update/{id}", consumes = MediaType.APPLICATION_XML_VALUE, produces = MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<InstallmentPayment> update(@PathVariable UUID id, @RequestBody InstallmentPayment body) {
        InstallmentPayment entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Parcela não encontrada"));

        if (body.getOrder() != null && body.getOrder().getOrderId() != null) {
            Orders order = orderRepository.findById(body.getOrder().getOrderId())
                    .orElseThrow(() -> new RuntimeException("Pedido não encontrado"));
            entity.setOrder(order);
        }

        entity.setInstallmentNumber(body.getInstallmentNumber());
        entity.setAmount(body.getAmount());
        entity.setMaturity(body.getMaturity());
        entity.setPaid(body.getPaid());
        entity.setPaymentDate(body.getPaymentDate());
        entity.setMethod(body.getMethod());

        return ResponseEntity.ok(repository.save(entity));
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        if (!repository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
