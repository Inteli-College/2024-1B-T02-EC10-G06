---
title: Sumarização dos Teste
sidebar_position: 1
---

# Teste de Carga

O código utiliza o framework Locust para simular carga em uma API RESTful, focando em operações CRUD para entidades de medicamentos (`Medicine`) e pyxis (`Pyxi`). Aqui estão os pontos principais documentados de forma simples:

1. **Importações e Entidades:**
   - Importações do Locust e das entidades `Pyxi`, `Medicine`, e `Ticket`.
   - Instâncias das entidades `Pyxi` e `Medicine` com dados simulados.

2. **Classe `AdmUser` (Usuário de Simulação):**
   - Herda de `HttpUser` do Locust e inicializa as instâncias das entidades.
   
3. **Tarefas (Tasks) de Simulação:**
   - GET: Recuperação de medicamentos e pyxis.
   - POST: Criação de medicamentos e pyxis.
   - PUT: operações como obter medicamento específico e pyxi específica, atualizar medicamento.

4. **Detalhes Importantes:**
   - Uso de `@task` para definir a frequência e importância de cada operação.
   - Manipulação de respostas JSON para extrair IDs e dados necessários para operações futuras.
   - Uso de objetos `medicine_istance` e `pyxi_istance` para armazenar e manipular IDs de entidades criadas dinamicamente.

# Teste de Usabilidade

Mediante ao teste de nossa ultima versão da solução com o professos Chico de UX, houve uma melhora signifcativa dos resultados do questionário. Tendo o seguinte resultado.

* A pesquisa completa do Teste de Usabilidade, encontra-se na Sprint 3 / Teste de Usabilidade

### Perguntas da Avaliação do Sistema:

| Nº | Pergunta |
|---|---|
| 1 | Eu acredito que gostaria de usar esse sistema frequentemente. |
| 2 | Eu achei o sistema desnecessariamente complexo. |
| 3 | Eu achei o sistema fácil de usar. |
| 4 | Eu acho que precisaria do suporte de uma pessoa técnica para poder usar esse sistema. |
| 5 | Eu achei as várias funções neste sistema bem integradas. |
| 6 | Eu achei que havia muita inconsistência nesse sistema. |
| 7 | Eu imagino que a maioria das pessoas aprenderia a usar esse sistema muito rapidamente. |
| 8 | Eu achei esse sistema muito desajeitado/incômodo de usar. |
| 9 | Me senti muito confiante usando esse sistema. |
| 10 | Eu precisei aprender muitas coisas antes de poder começar a usar este sistema. |

### Usuário 11
| Question | Discordo Totalmente | Discordo | Neutro | Concordo | Concordo Totalmente |
|----------|----------------------|----------|--------|----------|----------------------|
| 1        |                      |          |        |     X    |                      |
| 2        |                      |   X      |        |          |                      |
| 3        |                      |   X      |        |    X     |                      |
| 4        |                      |   X      |        |          |                      |
| 5        |                      |          |        |    X     |                      |
| 6        |                      |   X      |        |          |                      |
| 7        |                      |          |        |    X     |                      |
| 8        |                      |   X      |        |          |                      |
| 9        |                      |          |   X    |          |                      |
| 10       |           X          |          |        |          |                      |