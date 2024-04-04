# README

### Instruções para rodar a aplicação:
Para rodar o serviço: Clonar todos os trës endpoints realizar o docker-compose de cada serviço. Como funciona a aplicação: Com o pedido, a API soat-order-food posta na fila do SQS (payment billing) e depois a API Soat-order-payment consome a fila do SQS. Se estiver tudo certo, ele tenta fazer o pagamento no pay bill. Se der sucesso, ele posta na fila de ask payment receipt, caso contrário ele posta na fila de erro. A api soat-order-status consome essas duas filas e, de acordo o que tiver o received, é dado sequencia ao pedido. 

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
