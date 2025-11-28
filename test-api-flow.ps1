# =========================================
# Script de Teste Automatizado - API Sistema de Roupas
# =========================================

$baseUrl = "http://localhost:8080"
$headers = @{
    "Content-Type" = "application/xml"
    "Accept" = "application/xml"
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  INICIANDO TESTES DA API" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Funcao auxiliar para fazer requisicoes
function Invoke-ApiRequest {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Body = $null,
        [string]$Description
    )
    
    Write-Host ("► " + $Description) -ForegroundColor Yellow
    Write-Host ("  Endpoint: " + $Method + " " + $Endpoint) -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = "$baseUrl$Endpoint"
            Method = $Method
            Headers = $headers
        }
        
        if ($Body) {
            $params.Body = $Body
        }
        
        $response = Invoke-RestMethod @params
        Write-Host "  OK Sucesso!" -ForegroundColor Green
        Write-Host ""
        return $response
    }
    catch {
        Write-Host ("  X Erro: " + $_.Exception.Message) -ForegroundColor Red
        Write-Host ""
        return $null
    }
}

# Funcao para extrair valor de um elemento XML
function Get-XmlValue {
    param(
        [xml]$XmlContent,
        [string]$ElementName
    )
    
    $element = $XmlContent.SelectSingleNode("//$ElementName")
    if ($element) {
        return $element.InnerText
    }
    return $null
}

# =========================================
# 1. CRIAR USUARIO
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  1. CRIANDO USUARIO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$userBody = @"
<user>
    <name>Maria Silva</name>
    <email>maria.silva@email.com</email>
    <phone>11987654321</phone>
    <address>Rua das Flores, 123 - Sao Paulo, SP</address>
    <role>CUSTOMER</role>
</user>
"@

$userResponse = Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/user/create' `
    -Body $userBody `
    -Description 'Criando usuario Maria Silva'

if (-not $userResponse) {
    Write-Host 'ERRO CRITICO: Nao foi possivel criar o usuario. Abortando testes.' -ForegroundColor Red
    exit 1
}

$userId = Get-XmlValue -XmlContent ([xml]$userResponse.OuterXml) -ElementName 'userId'
Write-Host ("  User ID: " + $userId) -ForegroundColor Magenta
Write-Host ""

# =========================================
# 2. CRIAR PRODUTOS
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  2. CRIANDO PRODUTOS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Produto 1: Camiseta Polo
$product1Body = @"
<product>
    <name>Camiseta Polo Masculina</name>
    <category>Camisetas</category>
    <color>Azul Marinho</color>
    <size>M</size>
    <price>89.90</price>
    <active>true</active>
</product>
"@

$product1Response = Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/product/create' `
    -Body $product1Body `
    -Description 'Criando Camiseta Polo'
$product1Id = Get-XmlValue -XmlContent ([xml]$product1Response.OuterXml) -ElementName 'productId'
Write-Host ("  Product 1 ID: " + $product1Id) -ForegroundColor Magenta
Write-Host ""

# Produto 2: Calca Jeans
$product2Body = @"
<product>
    <name>Calca Jeans Slim</name>
    <category>Calcas</category>
    <color>Azul Escuro</color>
    <size>42</size>
    <price>159.90</price>
    <active>true</active>
</product>
"@

$product2Response = Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/product/create' `
    -Body $product2Body `
    -Description 'Criando Calca Jeans'
$product2Id = Get-XmlValue -XmlContent ([xml]$product2Response.OuterXml) -ElementName 'productId'
Write-Host ("  Product 2 ID: " + $product2Id) -ForegroundColor Magenta
Write-Host ""

# Produto 3: Jaqueta
$product3Body = @"
<product>
    <name>Jaqueta de Couro</name>
    <category>Jaquetas</category>
    <color>Preta</color>
    <size>G</size>
    <price>299.90</price>
    <active>true</active>
</product>
"@

$product3Response = Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/product/create' `
    -Body $product3Body `
    -Description 'Criando Jaqueta de Couro'
$product3Id = Get-XmlValue -XmlContent ([xml]$product3Response.OuterXml) -ElementName 'productId'
Write-Host ("  Product 3 ID: " + $product3Id) -ForegroundColor Magenta
Write-Host ""

# =========================================
# 3. CRIAR MOVIMENTACOES DE ESTOQUE (ENTRADA)
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  3. REGISTRANDO ENTRADA DE ESTOQUE" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Entrada Camiseta
$inventoryIn1Body = @"
<inventoryMovement>
    <productId>$product1Id</productId>
    <type>IN</type>
    <quantity>100</quantity>
    <date>2025-11-28</date>
    <reason>Compra de estoque inicial - Fornecedor XYZ</reason>
</inventoryMovement>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/inventory-movements/create' `
    -Body $inventoryIn1Body `
    -Description 'Entrada: 100 Camisetas Polo' | Out-Null

# Entrada Calca
$inventoryIn2Body = @"
<inventoryMovement>
    <productId>$product2Id</productId>
    <type>IN</type>
    <quantity>75</quantity>
    <date>2025-11-28</date>
    <reason>Compra de estoque inicial - Fornecedor ABC</reason>
</inventoryMovement>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/inventory-movements/create' `
    -Body $inventoryIn2Body `
    -Description 'Entrada: 75 Calcas Jeans' | Out-Null

# Entrada Jaqueta
$inventoryIn3Body = @"
<inventoryMovement>
    <productId>$product3Id</productId>
    <type>IN</type>
    <quantity>50</quantity>
    <date>2025-11-28</date>
    <reason>Compra de estoque inicial - Fornecedor DEF</reason>
</inventoryMovement>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/inventory-movements/create' `
    -Body $inventoryIn3Body `
    -Description 'Entrada: 50 Jaquetas de Couro' | Out-Null

# =========================================
# 4. CRIAR PEDIDO
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  4. CRIANDO PEDIDO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$orderBody = @"
<order>
    <createdAt>2025-11-28</createdAt>
    <status>PENDING</status>
    <totalAmount>549.70</totalAmount>
    <discount>0.00</discount>
    <notes>Pedido realizado via site - Cliente solicitou entrega rapida</notes>
    <user>
        <userId>$userId</userId>
    </user>
</order>
"@

$orderResponse = Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/order/create' `
    -Body $orderBody `
    -Description 'Criando pedido'
$orderId = Get-XmlValue -XmlContent ([xml]$orderResponse.OuterXml) -ElementName 'orderId'
Write-Host ("  Order ID: " + $orderId) -ForegroundColor Magenta
Write-Host ""

# =========================================
# 5. CRIAR ITENS DO PEDIDO
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  5. ADICIONANDO ITENS AO PEDIDO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Item 1: 2x Camiseta
$orderItem1Body = @"
<orderItem>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <product>
        <productId>$product1Id</productId>
    </product>
    <quantity>2</quantity>
    <unitPrice>89.90</unitPrice>
</orderItem>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/orderitem/create' `
    -Body $orderItem1Body `
    -Description 'Item 1: 2x Camiseta Polo (R$ 179,80)' | Out-Null

# Item 2: 1x Calca
$orderItem2Body = @"
<orderItem>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <product>
        <productId>$product2Id</productId>
    </product>
    <quantity>1</quantity>
    <unitPrice>159.90</unitPrice>
</orderItem>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/orderitem/create' `
    -Body $orderItem2Body `
    -Description 'Item 2: 1x Calca Jeans (R$ 159,90)' | Out-Null

# Item 3: 1x Jaqueta
$orderItem3Body = @"
<orderItem>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <product>
        <productId>$product3Id</productId>
    </product>
    <quantity>1</quantity>
    <unitPrice>299.90</unitPrice>
</orderItem>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/orderitem/create' `
    -Body $orderItem3Body `
    -Description 'Item 3: 1x Jaqueta de Couro (R$ 299,90)' | Out-Null

# =========================================
# 6. CRIAR MOVIMENTACOES DE ESTOQUE (SAIDA)
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  6. REGISTRANDO SAIDA DE ESTOQUE" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Saida Camiseta
$inventoryOut1Body = @"
<inventoryMovement>
    <productId>$product1Id</productId>
    <type>OUT</type>
    <quantity>2</quantity>
    <date>2025-11-28</date>
    <reason>Venda - Pedido $orderId</reason>
</inventoryMovement>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/inventory-movements/create' `
    -Body $inventoryOut1Body `
    -Description 'Saida: 2 Camisetas Polo' | Out-Null

# Saida Calca
$inventoryOut2Body = @"
<inventoryMovement>
    <productId>$product2Id</productId>
    <type>OUT</type>
    <quantity>1</quantity>
    <date>2025-11-28</date>
    <reason>Venda - Pedido $orderId</reason>
</inventoryMovement>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/inventory-movements/create' `
    -Body $inventoryOut2Body `
    -Description 'Saida: 1 Calca Jeans' | Out-Null

# Saida Jaqueta
$inventoryOut3Body = @"
<inventoryMovement>
    <productId>$product3Id</productId>
    <type>OUT</type>
    <quantity>1</quantity>
    <date>2025-11-28</date>
    <reason>Venda - Pedido $orderId</reason>
</inventoryMovement>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/inventory-movements/create' `
    -Body $inventoryOut3Body `
    -Description 'Saida: 1 Jaqueta de Couro' | Out-Null

# =========================================
# 7. CRIAR PARCELAS DE PAGAMENTO
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  7. CRIANDO PARCELAS DE PAGAMENTO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Parcela 1/3
$installment1Body = @"
<installmentPayment>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <installmentNumber>1</installmentNumber>
    <amount>183.23</amount>
    <maturity>2025-12-28</maturity>
    <paid>false</paid>
    <method>CREDIT_CARD</method>
</installmentPayment>
"@

$installment1Response = Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/installmentpayment/create' `
    -Body $installment1Body `
    -Description 'Parcela 1/3: R$ 183,23 (Venc: 28/12/2025)'
$installment1Id = Get-XmlValue -XmlContent ([xml]$installment1Response.OuterXml) -ElementName 'installmentPaymentId'

# Parcela 2/3
$installment2Body = @"
<installmentPayment>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <installmentNumber>2</installmentNumber>
    <amount>183.23</amount>
    <maturity>2026-01-28</maturity>
    <paid>false</paid>
    <method>CREDIT_CARD</method>
</installmentPayment>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/installmentpayment/create' `
    -Body $installment2Body `
    -Description 'Parcela 2/3: R$ 183,23 (Venc: 28/01/2026)' | Out-Null

# Parcela 3/3
$installment3Body = @"
<installmentPayment>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <installmentNumber>3</installmentNumber>
    <amount>183.24</amount>
    <maturity>2026-02-28</maturity>
    <paid>false</paid>
    <method>CREDIT_CARD</method>
</installmentPayment>
"@

Invoke-ApiRequest `
    -Method 'POST' `
    -Endpoint '/api/installmentpayment/create' `
    -Body $installment3Body `
    -Description 'Parcela 3/3: R$ 183,24 (Venc: 28/02/2026)' | Out-Null

# =========================================
# 8. CONSULTAS E VALIDACOES
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  8. EXECUTANDO CONSULTAS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/user/all' `
    -Description 'Listando todos os usuarios' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/product/all' `
    -Description 'Listando todos os produtos' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/inventory-movements/all' `
    -Description 'Listando todas as movimentacoes' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint ('/api/inventory-movements/product/' + $product1Id) `
    -Description 'Movimentacoes da Camiseta Polo' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/inventory-movements/type/IN' `
    -Description 'Movimentacoes tipo IN' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/inventory-movements/type/OUT' `
    -Description 'Movimentacoes tipo OUT' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/order/all' `
    -Description 'Listando todos os pedidos' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint ('/api/order/' + $orderId) `
    -Description 'Buscando pedido especifico' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/orderitem/all' `
    -Description 'Listando todos os itens de pedido' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint ('/api/orderitem/by-order?orderId=' + $orderId) `
    -Description 'Itens do pedido especifico' | Out-Null
Invoke-ApiRequest `
    -Method 'GET' `
    -Endpoint '/api/installmentpayment/all' `
    -Description 'Listando todas as parcelas' | Out-Null

# =========================================
# 9. ATUALIZAR REGISTROS
# =========================================
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  9. ATUALIZANDO REGISTROS" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Marcar primeira parcela como paga
$updateInstallment1Body = @"
<installmentPayment>
    <order>
        <orderId>$orderId</orderId>
    </order>
    <installmentNumber>1</installmentNumber>
    <amount>183.23</amount>
    <maturity>2025-12-28</maturity>
    <paid>true</paid>
    <paymentDate>2025-11-28</paymentDate>
    <method>CREDIT_CARD</method>
</installmentPayment>
"@

Invoke-ApiRequest `
    -Method 'PUT' `
    -Endpoint ('/api/installmentpayment/update/' + $installment1Id) `
    -Body $updateInstallment1Body `
    -Description 'Marcando parcela 1 como paga' | Out-Null

# Atualizar status do pedido para COMPLETED
$updateOrderBody = @"
<order>
    <createdAt>2025-11-28</createdAt>
    <status>COMPLETED</status>
    <totalAmount>549.70</totalAmount>
    <discount>0.00</discount>
    <notes>Pedido entregue com sucesso - Cliente satisfeito</notes>
    <user>
        <userId>$userId</userId>
    </user>
</order>
"@

Invoke-ApiRequest `
    -Method 'PUT' `
    -Endpoint ('/api/order/update/' + $orderId) `
    -Body $updateOrderBody `
    -Description 'Atualizando pedido para COMPLETED' | Out-Null

# =========================================
# RELATORIO FINAL
# =========================================
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  TESTES CONCLUIDOS COM SUCESSO!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

Write-Host "RESUMO DO FLUXO EXECUTADO:" -ForegroundColor Cyan
Write-Host ""
Write-Host "OK Usuario criado: Maria Silva" -ForegroundColor White
Write-Host ("  ID: " + $userId) -ForegroundColor Gray
Write-Host ""
Write-Host "OK Produtos criados: 3" -ForegroundColor White
Write-Host ("  - Camiseta Polo: " + $product1Id) -ForegroundColor Gray
Write-Host ("  - Calca Jeans: " + $product2Id) -ForegroundColor Gray
Write-Host ("  - Jaqueta: " + $product3Id) -ForegroundColor Gray
Write-Host ""
Write-Host "OK Movimentacoes de estoque:" -ForegroundColor White
Write-Host "  - 3 entradas (IN): 100 + 75 + 50 unidades" -ForegroundColor Gray
Write-Host "  - 3 saidas (OUT): 2 + 1 + 1 unidades" -ForegroundColor Gray
Write-Host ""
Write-Host "OK Pedido criado:" -ForegroundColor White
Write-Host ("  ID: " + $orderId) -ForegroundColor Gray
Write-Host "  Total: R$ 549,70" -ForegroundColor Gray
Write-Host "  Status: COMPLETED" -ForegroundColor Gray
Write-Host "  Itens: 3 produtos vendidos" -ForegroundColor Gray
Write-Host ""
Write-Host "OK Pagamento:" -ForegroundColor White
Write-Host "  3 parcelas de R$ 183,23 / R$ 183,23 / R$ 183,24" -ForegroundColor Gray
Write-Host "  1a parcela: PAGA OK" -ForegroundColor Gray
Write-Host "  2a e 3a parcelas: PENDENTES" -ForegroundColor Gray
Write-Host ""
Write-Host "ESTOQUE FINAL ESPERADO:" -ForegroundColor Cyan
Write-Host "  - Camiseta Polo: 98 unidades (100 - 2)" -ForegroundColor White
Write-Host "  - Calca Jeans: 74 unidades (75 - 1)" -ForegroundColor White
Write-Host "  - Jaqueta: 49 unidades (50 - 1)" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
