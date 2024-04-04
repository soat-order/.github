#!/bin/bash

#Buildando os containers
echo "Baixando os repositórios"
git clone https://github.com/soat-order/soat-order-food.git
git clone https://github.com/soat-order/soat-order-status.git
git clone https://github.com/soat-order/soat-order-payment.git

echo "Buildando os containers"
sudo docker-compose -f  $PWD/soat-order-food/ci/docker-compose-local.yml up -d
sudo docker-compose -f $PWD/soat-order-status/ci/docker-compose-local.yml up -d
sudo docker-compose -f $PWD/soat-order-payment/ci/docker-compose-local.yml up -d
sleep 30

#Autenticar
echo -e "\n\nAutenticando na aplicação com usuario soat-order"
curl --request POST --url http://localhost:8000/soat-order-food/v1/auth/singup --header 'Content-Type: application/json' --data '{"username": "soat.order",	"password": "food",	"email": "soat.order@fiap.com.br"}'

#Pegar o authorization token
sleep 5
echo -e "\n\nPegando o auth token"
response=$(curl -s --request POST --url http://localhost:8000/soat-order-food/v1/auth/login/token --header 'Authorization: Basic c29hdC5vcmRlcjpmb29k')
bToken=$(echo "$response" | jq -r '.access_token')
echo -e "\n\nAtribuimos o $bToken a variável bToken"

#Cadastrar e Ativar Cliente
echo -e "\n\nCadastrando o cliente Professor"
curl --request POST --url http://localhost:8000/soat-order-food/v1/customers/ --header 'Content-Type: application/json' --data '{"name": "Professor",	"documentNumber": "123.456.123-45",	"email": "professor@fiap.com.br",	"phoneNumber": "11912345678"}'
sleep 5
response=$(curl -s --request GET --url http://localhost:8000/soat-order-food/v1/customers/ --header "Authorization: Bearer $bToken")
nomeCliente="Professor"
id=$(echo "$response" | jq -r --arg nomeCliente "$nomeCliente" '.data[] | select(.name == $nomeCliente) | .id')
echo -e "\n\nCliente cadastrado $nomeCliente: $id"
curl --request PUT --url http://localhost:8000/soat-order-food/v1/customers/$id/inactive --header 'Content-Type: application/json' --data '{"inactive": false}'        

#Cadastrar e Ver Produtos
echo -e "\n\nCadastrando produto Coca350"
curl --request POST --url http://localhost:8000/soat-order-food/v1/products/ --header 'Content-Type: application/json' --data '{"code": "COCA350",	"name": "COCA COLA LATA 350ML",	"amount": 6.00,	"type": "BEBIDA"}'
sleep 5
curl --request GET --url http://localhost:8000/soat-order-food/v1/products/
echo -e "\n\nProduto Coca350 cadastrado"

#Fazer e Ver Pedidos
echo -e "\n\nFazendo o pedido do cliente Professor de uma Coca350"
curl --request POST --url http://localhost:8000/soat-order-food/v1/orders/ --header 'Content-Type: application/json' --data '{"customerName": "Professor",	"customerIdentify": "123.456.123-45",	"items": [{"productCode": "COCA350", "quantity": 1.00, "note": "TEMPERATURA AMBIENTE"}]}'
sleep 5
response=$(curl -s --request GET --url http://localhost:8000/soat-order-food/v1/orders/)
echo -e "\n\n $response"
orderId=$(echo "$response" | jq -r '.data | sort_by(.issueDateTime) | reverse | .[0].id')
status=$(echo "$response" | jq -r '.data | sort_by(.issueDateTime) | reverse | .[0].status')
echo -e "\n\nPedido do cliente $nomeCliente cadastrado com o id $orderId com o status $status"
echo "\n\n teste"

#Realizar pagamento
echo -e "\n\nRealizando pagamento"
sleep 5
curl -s -v --request POST --url http://localhost:8001/soat-order-payment/v1/payments/ --header 'Content-Type: application/json' --data "{\"orderId\": \"$orderId\", \"payments\": [{\"type\": \"CREDIT_CARD\", \"amountPaid\": 15.00}, {\"type\": \"MONEY\", \"amountPaid\": 2.00}]}"
echo -e "\n\nPagamento do $orderId realizado"

#Atualização de Status por pagamento
echo -e "\n\nAtualizando o status do pedido em decorrência do pagamento"
sleep 5
response=$(curl -s --request GET --url http://localhost:8000/soat-order-food/v1/orders/)
echo -e "\n\n$response"
status=$(echo "$response" | jq -r '.data | sort_by(.issueDateTime) | reverse | .[0].status')
echo -e "\n\nPedido $orderId atualizado para $status"

#Atualização de Status para em Preparação
echo -e "\n\nAlterando o status do pedido recebido pela cozinha"
curl --request PUT --url http://localhost:8000/soat-order-food/v1/orders/$orderId/status/in_preparation
sleep 5
response=$(curl -s --request GET --url http://localhost:8000/soat-order-food/v1/orders/)
echo -e "\n\n$response"
status=$(echo "$response" | jq -r '.data | sort_by(.issueDateTime) | reverse | .[0].status')
echo -e "\n\nCozinha alterou o status do pedido $orderId para $status"

#Atualização de Status para Finalizado
echo -e "\n\nAlterando o status do pedido finalizado pela cozinha"
curl --request PUT --url http://localhost:8000/soat-order-food/v1/orders/$orderId/status/finished
sleep 5
response=$(curl -s --request GET --url http://localhost:8000/soat-order-food/v1/orders/)
echo -e "\n\n$response"
status=$(echo "$response" | jq -r '.data | sort_by(.issueDateTime) | reverse | .[0].status')
echo -e "\n\nCozinha alterou o status do pedido $orderId para $status"

#Cliente solicitou exclusão de cadastro
echo -e "\n\nCliente solicitou a exclusão do cadastro"
curl --request PUT --url http://localhost:8000/soat-order-food/v1/customers/$id/inactive --header 'Content-Type: application/json' --data '{"inactive": true}'
sleep 5
curl -s --request GET --url http://localhost:8000/soat-order-food/v1/customers/ --header "Authorization: Bearer $bToken"

#Removendo os containers
echo -e "\n\nRemovendo os containers"
sudo docker-compose -f  $PWD/soat-order-food/ci/docker-compose-local.yml down
sudo docker-compose -f  $PWD/soat-order-status/ci/docker-compose-local.yml down
sudo docker-compose -f  $PWD/soat-order-status/ci/docker-compose-local.yml down

echo "Limpando os repositórios"
sudo rm -R $PWD/soat-order-food
sudo rm -R $PWD/soat-order-status
sudo rm -R $PWD/soat-order-payment
