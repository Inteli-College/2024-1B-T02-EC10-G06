# Funcionalidades do Sitema

# Descrição das Rotas

## Pyxis

### Obter todos os Pyxis

- **Método:** GET
- **Endpoint:** `/pyxis/`
- **Descrição:** Retorna todos os Pyxis cadastrados no sistema.
- **Resposta de Sucesso (200):** JSON Array
  - Esquema:

    ```json
    {
      "type": "array",
      {
      "type": "object",
      "properties": {
        "id": {
          "type": "string"
        },
        "description": {
          "type": "string"
        },
        "medicines": {
          "type": "object"
        }
      },
      "required": ["id", "description", "medicines"]
    }
    }
    ```

### Criar um novo Pyxis

- **Método:** POST
- **Endpoint:** `/pyxis/`
- **Descrição:** Cria um novo Pyxis no sistema.
- **Corpo da Requisição:** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "description": {
          "type": "string",
          "title": "description"
        },
        "medicines": {
          "type": "object",
          "title": "Medicines"
        }
      },
      "required": ["description", "medicines"]
    }
    ```

- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "id": {
          "type": "string"
        },
        "description": {
          "type": "string"
        },
        "medicines": {
          "type": "object"
        }
      },
      "required": ["id", "description", "medicines"]
    }
    ```

### Obter detalhes de um Pyxis específico

- **Método:** GET
- **Endpoint:** `/pyxis/{pyxi_id}`
- **Descrição:** Retorna os detalhes de um Pyxis específico.
- **Parâmetros de Path:**
  - `pyxi_id`: ID do Pyxis
- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "id": {
          "type": "string"
        },
        "description": {
          "type": "string"
        },
        "medicines": {
          "type": "object"
        }
      },
      "required": ["id", "description", "medicines"]
    }
    ```

### Atualizar um Pyxis existente

- **Método:** PUT
- **Endpoint:** `/pyxis/{pyxi_id}`
- **Descrição:** Atualiza os detalhes de um Pyxis existente.
- **Parâmetros de Path:**
  - `pyxi_id`: ID do Pyxis
- **Corpo da Requisição:** JSON
  - Esquema:
  
    ```json
      {
      "type": "object",
      "properties": {
        "status": {
          "type": "string",
          "title": "Status"
        }
      },
      "required": ["status"]
    }

    ```

- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
      {
      "type": "object",
      "properties": {
        "status": {
          "type": "string",
          "title": "Status"
        }
      },
      "required": ["status"]
    }

    ```

### Deletar um Pyxis existente

- **Método:** DELETE
- **Endpoint:** `/pyxis/{pyxi_id}`
- **Descrição:** Remove um Pyxis existente do sistema.
- **Parâmetros de Path:**
  - `pyxi_id`: ID do Pyxis
- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "id": {
          "type": "string",
          "title": "Id"
        },
        "status": {
          "type": "string",
          "title": "Status"
        }
      },
      "required": ["id", "status"]
    }

    ```

## Medicines

### Obter todos os Medicines

- **Método:** GET
- **Endpoint:** `/medicines/`
- **Descrição:** Retorna todos os Medicines cadastrados no sistema.
- **Resposta de Sucesso (200):** JSON Array
  - Esquema:

    ```json
    {
    "type": "object",
    "properties": {
      "id": {
        "type": "string",
        "title": "Id"
      },
      "name": {
        "type": "string",
        "title": "Name"
      },
      "description": {
        "type": "string",
        "title": "description"
      }
    },
    "required": ["id", "name", "description"]
  }

    ```

### Criar um novo Medicine

- **Método:** POST
- **Endpoint:** `/medicines/`
- **Descrição:** Cria um novo Medicine no sistema.
- **Corpo da Requisição:** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "name": {
          "type": "string",
          "title": "Name"
        },
        "description": {
          "type": "string",
          "title": "description"
        }
      },
      "required": ["name", "description"]
    }

    ```

- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "id": {
          "type": "string",
          "title": "Id"
        },
        "name": {
          "type": "string",
          "title": "Name"
        },
        "description": {
          "type": "string",
          "title": "description"
        }
      },
      "required": ["id", "name", "description"]
    }
    ```

### Obter detalhes de um Medicine específico

- **Método:** GET
- **Endpoint:** `/medicines/{medicine_id}`
- **Descrição:** Retorna os detalhes de um Medicine específico.
- **Parâmetros de Path:**
  - `medicine_id`: ID do Medicine
- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "id": {
          "type": "string",
          "title": "Id"
        },
        "name": {
          "type": "string",
          "title": "Name"
        },
        "description": {
          "type": "string",
          "title": "description"
        }
      },
      "required": ["id", "name", "description"]
    }
    ```

### Atualizar um Medicine existente

- **Método:** PUT
- **Endpoint:** `/medicines/{medicine_id}`
- **Descrição:** Atualiza os detalhes de um Medicine existente.
- **Parâmetros de Path:**
  - `medicine_id`: ID do Medicine
- **Corpo da Requisição:** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "name": {
          "type": "string",
          "title": "Name"
        },
        "description": {
          "type": "string",
          "title": "description"
        }
      },
      "required": ["name", "description"]
    }

    ```

- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "type": "object",
      "properties": {
        "id": {
          "type": "string",
          "title": "Id"
        },
        "name": {
          "type": "string",
          "title": "Name"
        },
        "description": {
          "type": "string",
          "title": "description"
        }
      },
      "required": ["id", "name", "description"]
    }
    ```

### Deletar um Medicine existente

- **Método:** DELETE
- **Endpoint:** `/medicines/{medicine_id}`
- **Descrição:** Remove um Medicine existente do sistema.
- **Parâmetros de Path:**
  - `medicine_id`: ID do Medicine
- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/MedicinesDelete"
    }
    ```

## Tickets

### Obter todos os Tickets

- **Método:** GET
- **Endpoint:** `/tickets/`
- **Descrição:** Retorna todos os Tickets cadastrados no sistema.
- **Resposta de Sucesso (200):** JSON Array
  - Esquema:

    ```json
    {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/TicketBase"
      }
    }
    ```

### Criar um novo Ticket

- **Método:** POST
- **Endpoint:** `/tickets/`
- **Descrição:** Cria um novo Ticket no sistema.
- **Corpo da Requisição:** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/TicketCreate"
    }
    ```

- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/TicketCreateResponse"
    }
    ```

### Obter detalhes de um Ticket específico

- **Método:** GET
- **Endpoint:** `/tickets/{ticket_id}`
- **Descrição:** Retorna os detalhes de um Ticket específico.
- **Parâmetros de Path:**
  - `ticket_id`: ID do Ticket
- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/TicketBase"
    }
    ```

### Atualizar um Ticket existente

- **Método:** PUT
- **Endpoint:** `/tickets/{ticket_id}`
- **Descrição:** Atualiza os detalhes de um Ticket existente.
- **Parâmetros de Path:**
  - `ticket_id`: ID do Ticket
- **Corpo da Requisição:** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/TicketCreate"
    }
    ```

- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/TicketResponse"
    }
    ```

### Deletar um Ticket existente

- **Método:** DELETE
- **Endpoint:** `/tickets/{ticket_id}`
- **Descrição:** Remove um Ticket existente do sistema.
- **Parâmetros de Path:**
  - `ticket_id`: ID do Ticket
- **Resposta de Sucesso (200):** JSON
  - Esquema:

    ```json
    {
      "$ref": "#/components/schemas/TicketResponse"
    }
    ```
