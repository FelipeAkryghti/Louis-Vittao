# 🧪 Guia Completo de Testes - Sistema de Roupas

Este documento contém instruções detalhadas para testar todo o fluxo do sistema usando Postman.

---

## 📋 Pré-requisitos

1. **Aplicação rodando:** Execute `./mvnw spring-boot:run`
2. **Postman instalado**
3. **Base URL:** `http://localhost:8080`

---

## 🎯 Fluxo Completo de Testes

### **Ordem de execução:**
1. Criar User
2. Criar Products
3. Criar Inventory Movements (entrada de estoque)
4. Criar Order
5. Criar Order Items
6. Criar Inventory Movements (saída de estoque)
7. Criar Payment Installments
8. Consultas e validações

---

## 1️⃣ **CRIAR USUÁRIO**

**Endpoint:** `POST http://localhost:8080/api/user/create`

**Body (XML):**
```xml
<user>
    <name>Maria Silva</name>
    <email>maria.silva@email.com</email>
    <phone>11987654321</phone>
    <address>Rua das Flores, 123 - São Paulo, SP</address>
    <role>CUSTOMER</role>
</user>
```

**Resposta esperada:**
```xml
<user>
    <userId>a1b2c3d4-e5f6-7890-abcd-ef1234567890</userId>
    <name>Maria Silva</name>
    <email>maria.silva@email.com</email>
    <phone>11987654321</phone>
    <address>Rua das Flores, 123 - São Paulo, SP</address>
    <role>CUSTOMER</role>
</user>
```

📝 **IMPORTANTE:** Copie o `userId` retornado!

---

## 2️⃣ **CRIAR PRODUTOS**

### **Produto 1: Camiseta Polo**

**Endpoint:** `POST http://localhost:8080/api/product/create`

**Body (XML):**
```xml
<product>
    <name>Camiseta Polo Masculina</name>
    <category>Camisetas</category>
    <color>Azul Marinho</color>
    <size>M</size>
    <price>89.90</price>
    <active>true</active>
</product>
```

**Resposta esperada:**
```xml
<product>
    <productId>b2c3d4e5-f6g7-8901-bcde-fg2345678901</productId>
    <name>Camiseta Polo Masculina</name>
    <category>Camisetas</category>
    <color>Azul Marinho</color>
    <size>M</size>
    <price>89.90</price>
    <active>true</active>
</product>
```

📝 **IMPORTANTE:** Copie o `productId` (Produto 1)

---

### **Produto 2: Calça Jeans**

**Endpoint:** `POST http://localhost:8080/api/product/create`

**Body (XML):**
```xml
<product>
    <name>Calça Jeans Slim</name>
    <category>Calças</category>
    <color>Azul Escuro</color>
    <size>42</size>
    <price>159.90</price>
    <active>true</active>
</product>
```

📝 **IMPORTANTE:** Copie o `productId` (Produto 2)

---

### **Produto 3: Jaqueta**

**Endpoint:** `POST http://localhost:8080/api/product/create`

**Body (XML):**
```xml
<product>
    <name>Jaqueta de Couro</name>
    <category>Jaquetas</category>
    <color>Preta</color>
    <size>G</size>
    <price>299.90</price>
    <active>true</active>
</product>
```

📝 **IMPORTANTE:** Copie o `productId` (Produto 3)

---

## 3️⃣ **CRIAR MOVIMENTAÇÕES DE ESTOQUE (ENTRADA)**

### **Entrada - Camiseta Polo**

**Endpoint:** `POST http://localhost:8080/api/inventory-movements/create`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID_DA_CAMISETA</productId>
    <type>IN</type>
    <quantity>100</quantity>
    <date>2025-11-28</date>
    <reason>Compra de estoque inicial - Fornecedor XYZ</reason>
</inventoryMovement>
```

---

### **Entrada - Calça Jeans**

**Endpoint:** `POST http://localhost:8080/api/inventory-movements/create`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID_DA_CALCA</productId>
    <type>IN</type>
    <quantity>75</quantity>
    <date>2025-11-28</date>
    <reason>Compra de estoque inicial - Fornecedor ABC</reason>
</inventoryMovement>
```

---

### **Entrada - Jaqueta**

**Endpoint:** `POST http://localhost:8080/api/inventory-movements/create`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID_DA_JAQUETA</productId>
    <type>IN</type>
    <quantity>50</quantity>
    <date>2025-11-28</date>
    <reason>Compra de estoque inicial - Fornecedor DEF</reason>
</inventoryMovement>
```

---

## 4️⃣ **CRIAR PEDIDO**

**Endpoint:** `POST http://localhost:8080/api/order/create`

**Body (XML):**
```xml
<order>
    <createdAt>2025-11-28</createdAt>
    <status>PENDING</status>
    <totalAmount>549.70</totalAmount>
    <discount>0.00</discount>
    <notes>Pedido realizado via site - Cliente solicitou entrega rápida</notes>
    <user>
        <userId>COLE_AQUI_O_USER_ID</userId>
    </user>
</order>
```

**Resposta esperada:**
```xml
<order>
    <orderId>c3d4e5f6-g7h8-9012-cdef-gh3456789012</orderId>
    <createdAt>2025-11-28</createdAt>
    <status>PENDING</status>
    <totalAmount>549.70</totalAmount>
    <discount>0.00</discount>
    <notes>Pedido realizado via site - Cliente solicitou entrega rápida</notes>
    <user>
        <userId>a1b2c3d4-e5f6-7890-abcd-ef1234567890</userId>
    </user>
</order>
```

📝 **IMPORTANTE:** Copie o `orderId`

---

## 5️⃣ **CRIAR ITENS DO PEDIDO**

### **Item 1: 2x Camiseta Polo**

**Endpoint:** `POST http://localhost:8080/api/orderitem/create`

**Body (XML):**
```xml
<orderItem>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <product>
        <productId>COLE_AQUI_O_PRODUCT_ID_DA_CAMISETA</productId>
    </product>
    <quantity>2</quantity>
    <unitPrice>89.90</unitPrice>
</orderItem>
```

**Resposta esperada:**
```xml
<orderItem>
    <orderItemId>d4e5f6g7-h8i9-0123-defg-hi4567890123</orderItemId>
    <order>
        <orderId>c3d4e5f6-g7h8-9012-cdef-gh3456789012</orderId>
    </order>
    <product>
        <productId>b2c3d4e5-f6g7-8901-bcde-fg2345678901</productId>
    </product>
    <quantity>2</quantity>
    <unitPrice>89.90</unitPrice>
    <subtotal>179.80</subtotal>
</orderItem>
```

---

### **Item 2: 1x Calça Jeans**

**Endpoint:** `POST http://localhost:8080/api/orderitem/create`

**Body (XML):**
```xml
<orderItem>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <product>
        <productId>COLE_AQUI_O_PRODUCT_ID_DA_CALCA</productId>
    </product>
    <quantity>1</quantity>
    <unitPrice>159.90</unitPrice>
</orderItem>
```

---

### **Item 3: 1x Jaqueta**

**Endpoint:** `POST http://localhost:8080/api/orderitem/create`

**Body (XML):**
```xml
<orderItem>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <product>
        <productId>COLE_AQUI_O_PRODUCT_ID_DA_JAQUETA</productId>
    </product>
    <quantity>1</quantity>
    <unitPrice>299.90</unitPrice>
</orderItem>
```

---

## 6️⃣ **CRIAR MOVIMENTAÇÕES DE ESTOQUE (SAÍDA)**

### **Saída - Camiseta Polo (2 unidades vendidas)**

**Endpoint:** `POST http://localhost:8080/api/inventory-movements/create`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID_DA_CAMISETA</productId>
    <type>OUT</type>
    <quantity>2</quantity>
    <date>2025-11-28</date>
    <reason>Venda - Pedido c3d4e5f6-g7h8-9012-cdef-gh3456789012</reason>
</inventoryMovement>
```

---

### **Saída - Calça Jeans (1 unidade vendida)**

**Endpoint:** `POST http://localhost:8080/api/inventory-movements/create`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID_DA_CALCA</productId>
    <type>OUT</type>
    <quantity>1</quantity>
    <date>2025-11-28</date>
    <reason>Venda - Pedido c3d4e5f6-g7h8-9012-cdef-gh3456789012</reason>
</inventoryMovement>
```

---

### **Saída - Jaqueta (1 unidade vendida)**

**Endpoint:** `POST http://localhost:8080/api/inventory-movements/create`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID_DA_JAQUETA</productId>
    <type>OUT</type>
    <quantity>1</quantity>
    <date>2025-11-28</date>
    <reason>Venda - Pedido c3d4e5f6-g7h8-9012-cdef-gh3456789012</reason>
</inventoryMovement>
```

---

## 7️⃣ **CRIAR PARCELAS DE PAGAMENTO**

### **Parcela 1/3**

**Endpoint:** `POST http://localhost:8080/api/installmentpayment/create`

**Body (XML):**
```xml
<installmentPayment>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <installmentNumber>1</installmentNumber>
    <amount>183.23</amount>
    <maturity>2025-12-28</maturity>
    <paid>false</paid>
    <method>CREDIT_CARD</method>
</installmentPayment>
```

---

### **Parcela 2/3**

**Endpoint:** `POST http://localhost:8080/api/installmentpayment/create`

**Body (XML):**
```xml
<installmentPayment>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <installmentNumber>2</installmentNumber>
    <amount>183.23</amount>
    <maturity>2026-01-28</maturity>
    <paid>false</paid>
    <method>CREDIT_CARD</method>
</installmentPayment>
```

---

### **Parcela 3/3**

**Endpoint:** `POST http://localhost:8080/api/installmentpayment/create`

**Body (XML):**
```xml
<installmentPayment>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <installmentNumber>3</installmentNumber>
    <amount>183.24</amount>
    <maturity>2026-02-28</maturity>
    <paid>false</paid>
    <method>CREDIT_CARD</method>
</installmentPayment>
```

---

## 8️⃣ **CONSULTAS E VALIDAÇÕES**

### **Listar todos os usuários**
```
GET http://localhost:8080/api/user/all
```

### **Listar todos os produtos**
```
GET http://localhost:8080/api/product/all
```

### **Listar todas as movimentações de estoque**
```
GET http://localhost:8080/api/inventory-movements/all
```

### **Buscar movimentações por produto (Camiseta)**
```
GET http://localhost:8080/api/inventory-movements/product/{productId_da_camiseta}
```
**Resultado esperado:** 2 movimentações (1 IN de 100 unidades + 1 OUT de 2 unidades)

### **Buscar movimentações por tipo IN**
```
GET http://localhost:8080/api/inventory-movements/type/IN
```
**Resultado esperado:** 3 movimentações (entrada dos 3 produtos)

### **Buscar movimentações por tipo OUT**
```
GET http://localhost:8080/api/inventory-movements/type/OUT
```
**Resultado esperado:** 3 movimentações (saída dos 3 produtos vendidos)

### **Listar todos os pedidos**
```
GET http://localhost:8080/api/order/all
```

### **Buscar pedido por ID**
```
GET http://localhost:8080/api/order/{orderId}
```

### **Listar todos os itens de pedido**
```
GET http://localhost:8080/api/orderitem/all
```
**Resultado esperado:** 3 itens (2 camisetas, 1 calça, 1 jaqueta)

### **Buscar itens por pedido**
```
GET http://localhost:8080/api/orderitem/by-order?orderId={orderId}
```

### **Listar todas as parcelas**
```
GET http://localhost:8080/api/installmentpayment/all
```
**Resultado esperado:** 3 parcelas

### **Buscar parcela por ID**
```
GET http://localhost:8080/api/installmentpayment/{installmentPaymentId}
```

---

## 9️⃣ **ATUALIZAR REGISTROS**

### **Marcar primeira parcela como paga**

**Endpoint:** `PUT http://localhost:8080/api/installmentpayment/update/{installmentPaymentId_da_parcela_1}`

**Body (XML):**
```xml
<installmentPayment>
    <order>
        <orderId>COLE_AQUI_O_ORDER_ID</orderId>
    </order>
    <installmentNumber>1</installmentNumber>
    <amount>183.23</amount>
    <maturity>2025-12-28</maturity>
    <paid>true</paid>
    <paymentDate>2025-11-28</paymentDate>
    <method>CREDIT_CARD</method>
</installmentPayment>
```

---

### **Atualizar status do pedido para COMPLETED**

**Endpoint:** `PUT http://localhost:8080/api/order/update/{orderId}`

**Body (XML):**
```xml
<order>
    <createdAt>2025-11-28</createdAt>
    <status>COMPLETED</status>
    <totalAmount>549.70</totalAmount>
    <discount>0.00</discount>
    <notes>Pedido entregue com sucesso - Cliente satisfeito</notes>
    <user>
        <userId>COLE_AQUI_O_USER_ID</userId>
    </user>
</order>
```

---

### **Ajustar quantidade de estoque**

**Endpoint:** `PUT http://localhost:8080/api/inventory-movements/update/{movementId}`

**Body (XML):**
```xml
<inventoryMovement>
    <productId>COLE_AQUI_O_PRODUCT_ID</productId>
    <type>IN</type>
    <quantity>105</quantity>
    <date>2025-11-28</date>
    <reason>Ajuste de inventário - Recontagem de estoque</reason>
</inventoryMovement>
```

---

## 🔟 **DELETAR REGISTROS (OPCIONAL)**

⚠️ **ATENÇÃO:** Execute os deletes na ordem inversa para evitar problemas de integridade referencial!

### **1. Deletar parcelas**
```
DELETE http://localhost:8080/api/installmentpayment/delete/{installmentPaymentId}
```

### **2. Deletar itens do pedido**
```
DELETE http://localhost:8080/api/orderitem/delete/{orderItemId}
```

### **3. Deletar movimentações de estoque**
```
DELETE http://localhost:8080/api/inventory-movements/delete/{movementId}
```

### **4. Deletar pedido**
```
DELETE http://localhost:8080/api/order/delete/{orderId}
```

### **5. Deletar produtos**
```
DELETE http://localhost:8080/api/product/delete/{productId}
```

### **6. Deletar usuário**
```
DELETE http://localhost:8080/api/user/delete/{userId}
```

---

## ✅ **CHECKLIST DE VALIDAÇÃO**

Após executar todos os testes, valide:

- [ ] ✅ Usuário criado com sucesso
- [ ] ✅ 3 produtos criados
- [ ] ✅ 3 movimentações de entrada (IN) registradas
- [ ] ✅ 1 pedido criado com status PENDING
- [ ] ✅ 3 itens adicionados ao pedido
- [ ] ✅ 3 movimentações de saída (OUT) registradas
- [ ] ✅ 3 parcelas de pagamento criadas
- [ ] ✅ Consulta por produto retorna movimentações corretas
- [ ] ✅ Consulta por tipo IN retorna 3 registros
- [ ] ✅ Consulta por tipo OUT retorna 3 registros
- [ ] ✅ Parcela marcada como paga (paid=true)
- [ ] ✅ Status do pedido atualizado para COMPLETED
- [ ] ✅ Todas as consultas retornam XML

---

## 📊 **RESULTADO ESPERADO DO FLUXO COMPLETO**

### **Estoque Final:**
- **Camiseta Polo:** 100 (entrada) - 2 (saída) = **98 unidades**
- **Calça Jeans:** 75 (entrada) - 1 (saída) = **74 unidades**
- **Jaqueta:** 50 (entrada) - 1 (saída) = **49 unidades**

### **Financeiro:**
- **Total do pedido:** R$ 549,70 (R$ 179,80 + R$ 159,90 + R$ 299,90 - R$ 89,90)
- **Parcelas:** 3x de R$ 183,23 / R$ 183,23 / R$ 183,24
- **1ª parcela:** Paga ✅
- **2ª e 3ª parcelas:** Pendentes ⏳

---

## 🎯 **DICAS IMPORTANTES**

1. **Sempre copie os IDs retornados** nas respostas para usar nas próximas requisições
2. **Siga a ordem dos testes** para evitar erros de relacionamento
3. **Verifique se a aplicação está rodando** antes de iniciar os testes
4. **Não é necessário adicionar headers** - os controllers já estão configurados para XML
5. **Use IDs reais** - substitua todos os `COLE_AQUI_O_*_ID` pelos valores corretos

---

## 🐛 **TROUBLESHOOTING**

### Erro 400 - Bad Request
- Verifique se substituiu todos os IDs pelos valores reais
- Confirme que o XML está bem formatado

### Erro 404 - Not Found
- Verifique se o endpoint está correto
- Confirme se a aplicação está rodando

### Erro 500 - Internal Server Error
- Verifique os logs da aplicação
- Confirme se os relacionamentos (User, Product, Order) existem

---

**🎉 Pronto! Agora você tem um guia completo para testar todo o sistema!**
