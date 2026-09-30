# Documentação Técnica — Normalização e Deduplicação com Dataform

## 1. Objetivo

Definir a arquitetura e os scripts necessários para normalização e deduplicação das tabelas provenientes do PostgreSQL, já ingeridas no BigQuery por meio do pipeline/Dataflow.

A proposta utiliza o Dataform como camada de transformação dentro do ecossistema GCP, mantendo separadas:

- ingestão dos dados;
- normalização;
- deduplicação;
- consumo analítico.

A ingestão não faz parte deste documento, pois já está implementada e validada.

---

## 2. Arquitetura

```text
PostgreSQL
    |
    v
Dataflow / Pipeline
    |
    v
RAW — BigQuery
    |
    +-----------------------------+
    |                             |
    v                             |
NORMALIZAÇÃO                      |
    |                             |
    +-------------+---------------+
                  |
                  v
DEDUPLICAÇÃO
                  |
                  v
CAMADA FINAL / CURATED
                  |
                  v
Consumo / Analytics
```

A regra fundamental é que a deduplicação consuma a camada normalizada. Dessa forma, alterações nas regras de normalização não precisam ser replicadas diretamente na lógica de deduplicação.

---

# 3. Organização dos scripts Dataform

Sugestão de estrutura:

```text
definitions/
├── normalized/
│   ├── tb_cliente.sqlx
│   ├── tb_transacao.sqlx
│   └── tb_produto.sqlx
│
├── deduplicated/
│   ├── tb_cliente_dedup.sqlx
│   ├── tb_transacao_dedup.sqlx
│   └── tb_produto_dedup.sqlx
│
└── assertions/
    ├── assert_cliente.sqlx
    └── assert_transacao.sqlx
```

Fluxo de dependência:

```text
raw.tb_cliente
      |
      v
normalized.tb_cliente
      |
      v
deduplicated.tb_cliente
```

A utilização de `${ref()}` deve ser preferida para estabelecer as dependências entre as ações do Dataform.

---

# 4. Normalização

## 4.1 Objetivo

A normalização tem como finalidade padronizar os dados provenientes da camada RAW antes que eles sejam utilizados pela deduplicação ou pelas camadas analíticas.

Exemplos de responsabilidades:

- padronização de tipos;
- conversão de datas e timestamps;
- tratamento de valores nulos;
- padronização de nomes;
- conversões seguras;
- padronização de strings;
- criação de campos auxiliares;
- aplicação de regras simples de transformação.

A normalização não deve decidir qual registro duplicado deve sobreviver.

---

# 5. Normalização utilizando VIEW

## 5.1 Quando utilizar

A VIEW pode ser utilizada quando:

- a transformação é simples;
- o volume processado não justifica materialização;
- a camada normalizada não será consultada repetidamente;
- não existe necessidade de armazenar fisicamente o resultado;
- a prioridade é reduzir armazenamento.

## 5.2 Exemplo

```sql
config {
  type: "view"
}

SELECT
    CAST(id AS INT64) AS id,
    UPPER(nome) AS nome,
    SAFE_CAST(valor AS NUMERIC) AS valor,
    SAFE_CAST(data_atualizacao AS TIMESTAMP) AS dth_atualizacao
FROM ${ref("tb_cliente_raw")}
```

### Características

```text
RAW
 |
 v
VIEW NORMALIZADA
 |
 v
DEDUPLICAÇÃO
```

A transformação é executada quando a VIEW é consultada.

---

# 6. Normalização utilizando TABLE

## 6.1 Quando utilizar

A TABLE é recomendada quando:

- o volume é significativo;
- a transformação será reutilizada;
- a deduplicação processará a mesma camada repetidamente;
- é necessário particionar;
- é necessário clusterizar;
- deseja-se uma fronteira física entre RAW e dados tratados.

## 6.2 Exemplo

```sql
config {
  type: "table",

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)"
  }
}

SELECT
    CAST(id AS INT64) AS id,
    UPPER(nome) AS nome,
    SAFE_CAST(valor AS NUMERIC) AS valor,
    SAFE_CAST(data_atualizacao AS TIMESTAMP) AS dth_atualizacao
FROM ${ref("tb_cliente_raw")}
```

Fluxo:

```text
RAW
 |
 v
TABLE NORMALIZADA
 |
 v
DEDUPLICAÇÃO
```

A transformação passa a ser materializada no BigQuery.

---

# 7. Deduplicação

## 7.1 Objetivo

A deduplicação tem como objetivo identificar registros que representam a mesma entidade lógica e manter somente o registro definido pela regra de negócio.

A deduplicação não deve utilizar `SELECT DISTINCT` como regra geral.

`DISTINCT` remove somente registros completamente iguais.

Exemplo:

```text
id | nome | valor | dth_atualizacao
---+------+-------+----------------
10 | JOAO | 100   | 10:00
10 | JOAO | 100   | 10:05
```

Os registros continuam diferentes devido ao timestamp.

Nesse caso, a deduplicação deve utilizar uma chave lógica e uma regra de sobrevivência.

---

# 8. Regra de deduplicação

Para cada tabela devem ser definidos:

| Elemento | Descrição |
|---|---|
| Chave | Identifica logicamente o registro |
| Critério de duplicidade | Define quando dois registros são considerados duplicados |
| Regra de sobrevivência | Define qual registro permanece |
| Timestamp | Campo utilizado para ordenar versões |
| Partição | Campo utilizado para particionamento físico |

Exemplo:

```text
Tabela: tb_cliente

Chave:
    id_cliente

Duplicidade:
    mesmo id_cliente

Registro sobrevivente:
    maior dth_atualizacao

Partição:
    DATE(dth_atualizacao)
```

---

# 9. Deduplicação utilizando VIEW

## 9.1 Exemplo

```sql
config {
  type: "view"
}

SELECT *
FROM ${ref("tb_cliente_normalizada")}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_cliente
    ORDER BY dth_atualizacao DESC
) = 1
```

Fluxo:

```text
RAW
 |
 v
VIEW NORMALIZADA
 |
 v
VIEW DEDUPLICADA
 |
 v
CONSUMO
```

## 9.2 Vantagens

- menor utilização de armazenamento;
- implementação simples;
- dados sempre derivados da origem atual;
- adequada para transformações leves.

## 9.3 Desvantagens

- processamento pode ser repetido a cada consulta;
- consultas podem ficar mais pesadas;
- a deduplicação não é materializada;
- pode não ser adequada para grandes volumes.

---

# 10. Deduplicação utilizando TABLE

## 10.1 Exemplo

```sql
config {
  type: "table",

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)"
  }
}

SELECT *
FROM ${ref("tb_cliente_normalizada")}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_cliente
    ORDER BY dth_atualizacao DESC
) = 1
```

Fluxo:

```text
RAW
 |
 v
TABLE NORMALIZADA
 |
 v
TABLE DEDUPLICADA
 |
 v
CONSUMO
```

## 10.2 Vantagens

- resultado materializado;
- melhor reutilização;
- possibilidade de particionamento;
- possibilidade de clustering;
- maior controle sobre custo e desempenho;
- camada final mais estável para consumo.

## 10.3 Desvantagens

- maior armazenamento;
- necessidade de atualização;
- maior complexidade operacional.

---

# 11. Particionamento por timestamp

O particionamento deve ser definido separadamente da regra de deduplicação.

A deduplicação responde:

> Qual registro deve permanecer?

O particionamento responde:

> Como os dados devem ser organizados fisicamente para melhorar processamento e leitura?

Exemplo:

```sql
bigquery: {
  partitionBy: "DATE(dth_atualizacao)"
}
```

É importante escolher um timestamp que represente adequadamente a atualização ou o ciclo de vida do registro.

Possíveis candidatos:

- `created_at`;
- `updated_at`;
- `dth_insert`;
- `dth_atualizacao`;
- outro timestamp definido pela origem.

---

# 12. Atenção à deduplicação e partições

Não se deve presumir que a deduplicação deva ocorrer apenas dentro da partição.

Exemplo:

```text
id = 123

2026-01-01
2026-02-01
2026-09-01
```

Se a regra for manter apenas um registro por `id`, a lógica precisa considerar as versões do registro independentemente da partição.

O particionamento não deve alterar a definição de duplicidade.

---

# 13. VIEW x TABLE

| Característica | VIEW | TABLE |
|---|---|---|
| Armazena resultado | Não | Sim |
| Custo de armazenamento | Menor | Maior |
| Processamento recorrente | Maior | Menor |
| Particionamento | Limitado | Sim |
| Clustering | Não aplicável como tabela materializada | Sim |
| Reutilização | Boa para baixo volume | Melhor para alto volume |
| Camada intermediária | Adequada | Adequada |
| Grandes volumes | Deve ser avaliada | Geralmente mais adequada |
| Performance previsível | Menor | Maior |

---

# 14. Estratégia recomendada

A decisão deve ser feita por tabela e não necessariamente de forma global.

Uma possibilidade inicial é:

```text
RAW
 |
 v
NORMALIZED TABLE
 |
 v
DEDUPLICATED TABLE
 |
 v
CONSUMO
```

Essa arquitetura cria duas fronteiras físicas:

```text
RAW
   ↓
NORMALIZED
   ↓
CURATED
```

A VIEW pode ser utilizada quando a transformação for simples e o volume ou frequência de consumo não justificar materialização.

---

# 15. Exemplo completo

## 15.1 Normalização

Arquivo:

```text
definitions/normalized/tb_cliente.sqlx
```

```sql
config {
  type: "table",

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)"
  }
}

SELECT
    CAST(id_cliente AS INT64) AS id_cliente,
    UPPER(TRIM(nome)) AS nome,
    SAFE_CAST(valor AS NUMERIC) AS valor,
    SAFE_CAST(dth_atualizacao AS TIMESTAMP) AS dth_atualizacao
FROM ${ref("tb_cliente_raw")}
```

## 15.2 Deduplicação

Arquivo:

```text
definitions/deduplicated/tb_cliente.sqlx
```

```sql
config {
  type: "table",

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)"
  }
}

SELECT *
FROM ${ref("tb_cliente")}
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_cliente
    ORDER BY dth_atualizacao DESC
) = 1
```

---

# 16. Validações

Cada tabela deve possuir validações antes de ser disponibilizada para consumo.

## 16.1 Verificação de duplicidade

```sql
SELECT
    id_cliente,
    COUNT(*) AS quantidade
FROM ${ref("tb_cliente")}
GROUP BY id_cliente
HAVING COUNT(*) > 1
```

Na camada deduplicada, o resultado esperado deve ser zero registros quando a regra for uma linha por `id_cliente`.

## 16.2 Verificação de NULL na chave

```sql
SELECT COUNT(*) AS quantidade
FROM ${ref("tb_cliente")}
WHERE id_cliente IS NULL
```

## 16.3 Verificação do timestamp

```sql
SELECT COUNT(*) AS quantidade
FROM ${ref("tb_cliente")}
WHERE dth_atualizacao IS NULL
```

A regra para timestamps nulos deve ser definida individualmente, pois nem toda tabela terá o mesmo comportamento.

---

# 17. Assertions no Dataform

As regras críticas podem ser implementadas utilizando assertions.

Exemplo conceitual:

```sql
config {
  type: "assertion"
}

SELECT
    id_cliente
FROM ${ref("tb_cliente_dedup")}
GROUP BY id_cliente
HAVING COUNT(*) > 1
```

Se a consulta retornar registros, a assertion deve indicar que a regra de unicidade foi violada.

---

# 18. Separação entre dados desnormalizados e dados tratados

A camada RAW deve permanecer preservada.

```text
RAW
 |
 +---- origem original
 |
 +---- não sobrescrever
 |
 +---- não deduplicar diretamente
 |
 v
NORMALIZED
 |
 v
DEDUPLICATED
```

A deduplicação deve gerar uma nova camada, evitando alterar os dados brutos.

Isso permite:

- auditoria;
- reprocessamento;
- comparação entre origem e destino;
- investigação de problemas;
- alteração das regras sem perda dos dados originais.

---

# 19. Regras que precisam ser definidas por tabela

Antes da implementação definitiva, deve ser criada uma matriz:

| Tabela | Chave | Critério de duplicidade | Registro sobrevivente | Timestamp | Partição | Tipo |
|---|---|---|---|---|---|---|
| `tb_cliente` | `id_cliente` | `id_cliente` | maior atualização | `dth_atualizacao` | `DATE(dth_atualizacao)` | TABLE |
| `tb_transacao` | definir | definir | definir | definir | definir | TABLE/VIEW |
| `tb_produto` | definir | definir | definir | definir | definir | TABLE/VIEW |

Essa matriz deve ser preenchida antes da implementação final.

---

# 20. Critérios para escolha entre VIEW e TABLE

A escolha deve considerar:

1. Volume da tabela.
2. Frequência de atualização.
3. Frequência de consulta.
4. Complexidade da transformação.
5. Necessidade de particionamento.
6. Necessidade de clustering.
7. Custo de processamento.
8. Necessidade de auditoria.
9. Reutilização da camada normalizada.
10. Tempo esperado de execução.

Não é necessário utilizar o mesmo tipo de objeto para todas as tabelas.

---

# 21. Fluxo final proposto

```text
                    PostgreSQL
                         |
                         v
                 Dataflow / Pipeline
                         |
                         v
                 +---------------+
                 |      RAW      |
                 +---------------+
                         |
                         v
                 +---------------+
                 |  NORMALIZED   |
                 | View / Table  |
                 +---------------+
                         |
                         v
                 +---------------+
                 | DEDUPLICATED  |
                 | View / Table  |
                 +---------------+
                         |
                         v
                 +---------------+
                 |    CURATED    |
                 +---------------+
                         |
                         v
                 Looker / Analytics
```

## Princípios da arquitetura

- RAW não deve ser sobrescrita pela transformação.
- Normalização e deduplicação devem ser processos independentes.
- Deduplicação deve consumir a camada normalizada.
- `SELECT DISTINCT` não deve ser utilizado como regra genérica de deduplicação.
- Cada tabela deve possuir uma regra explícita de chave e sobrevivência.
- Particionamento não deve definir a regra de duplicidade.
- VIEW e TABLE podem coexistir na arquitetura.
- Tabelas de maior volume ou maior reutilização tendem a se beneficiar da materialização.
- As regras críticas devem possuir validações/assertions.
- A solução deve preservar rastreabilidade entre RAW, NORMALIZED e DEDUPLICATED.
