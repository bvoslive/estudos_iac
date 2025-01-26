# Projeto de Previsão de Churn com Terraform e AWS

## Descrição
Este projeto utiliza o Terraform para provisionar uma infraestrutura na AWS que suporta um sistema de previsão de churn. A ideia é conseguir prever quais clientes vão se desligar para que as ações necessárias possam ser tomadas para reter esses clientes.

## Estrutura do Projeto

- **Dockerfile**: Configuração para criação do ambiente Docker, garantindo portabilidade e consistência.
- **model_config**:
  - `model_deploy`: Scripts e configurações para realizar o deploy do modelo.
  - `model_training`: Scripts para treinar o modelo de churn.

## Tecnologias Utilizadas

- **Terraform**: Para gerenciar e provisionar a infraestrutura na AWS.
- **AWS**: Serviços como S3, Lambda, e SageMaker para armazenar dados, executar funções e treinar o modelo.
- **Docker**: Para containerização do ambiente.
- **Python**: Desenvolvimento do modelo de churn e scripts auxiliares.
- **Flask**: microframework para construir aplicações web rápidas e simples.

## Arquitetura
A solução é composta pelos seguintes componentes na AWS:

1. **S3 (Simple Storage Service)**: Armazena os dados brutos e processados.
2. **EC2 (Elastic Compute Cloud)**: Fornece capacidade de computação escalável na nuvem
3. **IAM (Identity and Access Management)**: Gerencia permissões e políticas de acesso aos serviços.

## Funcionalidades
- **Provisionamento Automatizado**: Utiliza o Terraform para criar e configurar todos os recursos necessários na AWS.
- **Treinamento do Modelo**: Utiliza SageMaker para criar um modelo de machine learning.
- **Predição de Churn**: Disponibiliza uma API para predizer se um cliente está propenso a churn.

## Requisitos
Para executar este projeto, você precisará de:

- Conta AWS com permissões adequadas
- Terraform instalado na máquina local
- Docker instalado em máquina local
- AWS CLI configurada
- Dados de entrada para treinamento do modelo
