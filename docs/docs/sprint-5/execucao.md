---
title: Execução do Projeto
sidebar_position: 2
---

# Introdução

Para a execução total do projeto, existem duas etapas, a do Backend e a do Frontend, pois um depende do outro e são duas essências. Segue a baixo os passos que devem ser seguidos

## Backend

O backend pode ser instalado e executado em uma máquina EC2 por exemplo na AWZ ou na Azure, ou ainda uma local, desde que os dispositivos consiguam se conectar na mesma, via rede.

* Os comandos abaixo, são executados em uma máquina com o SO Ubutun, caso Windows, procure os comandos equivalentes.

## Pré-requisitos
Antes de começar, certifique-se de que sua máquina atende aos seguintes pré-requisitos:
- Docker instalado
- Git instalado

## Passos

### 1. Clone o Repositório do Projeto
Abra um terminal e execute o comando abaixo para clonar o repositório do projeto:

```sh
git clone https://github.com/Inteli-College/2024-1B-T02-EC10-G06.git
```

### 2. Navegue até o Diretório do Projeto
Entre no diretório do projeto clonado:

```sh
cd 2024-1B-T02-EC10-G06/src'
```

### 3. Verifique o Arquivo docker-compose.yml
Certifique-se de que o arquivo `docker-compose.yml` está presente no diretório do projeto e está configurado corretamente.

```sh
ls
```

* Espera-se enxegar depois dessa execução de comando varios arquivos, incluindo esses:

*docker-compose.yaml*

### 4. Configure as Variáveis de Ambiente
Dentro da pasta src execulte o seguinte comando:

```env
./out.bat
```

### 5. Execute o Docker Compose
Para subir os containers definidos no arquivo `docker-compose.yml`, execute o comando:

```sh
docker-compose up
```


### 7. Acesse o Projeto
Dependendo da configuração do seu `docker-compose.yml`, o projeto estará acessível em um URL específico, como `http://localhost:8000`. Por se um backend, não existe uma interface gráfica, sendo apenas as definições das regras de negócios e dos microserviços.