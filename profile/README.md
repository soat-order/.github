# README

### Instruções para rodar a aplicação:
Para rodar a aplicação: 1) Clonar o repositório de todos os trës endpoints (Food, Payment e Status), 2) realizar o docker-compose de cada serviço 3) Usar a documentaçâo da Collections para testar (https://github.com/soat-order/.github/blob/main/Insomnia_SOAT_ORDER_FIAP_20240403.json).

Como funciona a aplicação: Com o microsserviço Food é possível autenticar e buscar o token (/v1/auth/singup; /v1/auth/login/token), cadastrar e ver clientes (/v1/customers), realizar exclusaçâo lógica dos clientes (/v1/customers/$cliente-token/inactive), cadastrar e ver produtos (/v1/products), realizar e ver pedidos (/v1/orders). O microsserviço Payment é utilizado para postar o id do pedido com as informações de pagamento na fila do SQS (/v1/payments), que será consumida pelo microsserviço Status.

### Justificativa do Padrão SAGA escolhido:
Por dificuldades em levantar um cluster em nuvem pública, e também pela dificuldade em seguir o padrão de arquitetura clean e de microsserviços com Python (linguagem que utilizamos na primeira entrega sem saber que elas seriam incrementais), o padrão SAGA escolhido foi o coreografado, por oferecer uma abordagem descentralizada para transações, reduzindo o acoplamento centralizado ao permitir que cada serviço tome decisões localmente com base nos eventos observados. Isso permite que, apesar das dificuldades encontradas durante o desenvolvimento, nos conseguimos fazer um sistema escalável, resiliente e flexível, pois cada um dos serviços (food, payment e status) possa gerenciar seus próprios eventos de compensação em caso de falha, facilitando também a evolução do sistema ao longo do tempo. Além disso, essa abordagem pode reduzir a latência, pois as decisões são tomadas localmente sem a necessidade de comunicações adicionais com um orquestrador central, resultando em tempos de resposta mais rápidos e uma melhor experiência para o usuário final.

### Links com os Repositórios de cada Microsserviço:
Soat-Order-Food (pedido): https://github.com/soat-order/soat-order-food

Soat-Order-Payment (pagamento): https://github.com/soat-order/soat-order-payment

Soat-Order-Status (status): https://github.com/soat-order/soat-order-status

### Links com evidência dos relatórios de SAST:
Soat-Order-Food: https://github.com/soat-order/.github/blob/main/SAST%20-%20ZAP%20-%20Soat-Order-Food.png

Soat-Order-Payment: https://github.com/soat-order/.github/blob/main/SAST%20-%20ZAP%20-%20Soat-Order-Payment.png

Soat-Order-Status: https://github.com/soat-order/.github/blob/main/SAST%20-%20ZAP%20-%20Soat-Order-Status.png

### Links com os relatórios do DAST:
Soat-Order-Food: https://github.com/soat-order/.github/blob/main/DAST%20-%20ZAP%20-%20Soat-Order-Food.zip

Soat-Order-Payment: https://github.com/soat-order/.github/blob/main/DAST%20-%20ZAP%20-%20Soat-Order-Payment.zip

Soat-Order-Status: https://github.com/soat-order/.github/blob/main/DAST%20-%20ZAP%20-%20Soat-Order-Status.zip

### Link com o Relatório RIPD: 
https://github.com/soat-order/.github/blob/main/RIPD%20-%20Relat%C3%B3rio%20de%20Impacto%20de%20Prote%C3%A7%C3%A3o%20de%20Dados.docx

### Link com o desenho para arquitetura:
https://github.com/soat-order/.github/blob/main/Diagrama%20de%20Arquitetura%20Soat-Order-App.pdf

### Link para o Vídeo com a aplicação rodando:
https://github.com/soat-order/.github/blob/main/Video%20POC%20Soat-Order-App.mp4
