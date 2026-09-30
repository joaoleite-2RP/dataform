# Deduplicação Incremental com Dataform e BigQuery

## 1. Objetivo

Documentar a implementação da etapa de **deduplicação incremental** utilizando Dataform e BigQuery.

A deduplicação deve:

- processar dados novos ou potencialmente alterados;
- evitar reconstruir a tabela inteira a cada execução;
- identificar múltiplas versões do mesmo registro;
- manter a versão válida conforme uma regra definida;
- atualizar registros existentes quando uma versão mais recente chegar;
- inserir registros novos;
- utilizar particionamento para reduzir o volume processado;
- preservar RAW e a camada normalizada.

---

## 2. Posição na arquitetura

```text
PostgreSQL
    |
    v
Dataflow / Pipeline
    |
    v
RAW — BigQuery
    |
    v
NORMALIZAÇÃO — Dataform
    |
    v
Tabela/View Normalizada
    |
    v
DEDUPLICAÇÃO INCREMENTAL — Dataform
    |
    v
Tabela Deduplicada / Curated
    |
    v
Consumo Analítico
```

A deduplicação deve consumir a camada normalizada e não a RAW diretamente.

---

## 3. Por que utilizar `type: "incremental"`

Na primeira execução, a tabela é criada.

Nas execuções seguintes, o Dataform pode processar somente a parcela necessária dos dados.

```text
Primeira execução
    ↓
Processamento completo
    ↓
Tabela deduplicada criada

Execuções seguintes
    ↓
Identificação dos dados novos/alterados
    ↓
Deduplicação da janela incremental
    ↓
Atualização + inserção
    ↓
Tabela final
```

Isso é importante para tabelas de grande volume.

---

## 4. Estrutura básica

```sql
config {
  type: "incremental",

  uniqueKey: ["id_cliente"],

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)"
  }
}

SELECT
    id_cliente,
    nome,
    valor,
    dth_atualizacao
FROM ${ref("tb_cliente_normalizada")}

${when(incremental(), `
WHERE dth_atualizacao >= (
    SELECT COALESCE(
        MAX(dth_atualizacao),
        TIMESTAMP("1900-01-01")
    )
    FROM ${self()}
)`, "")}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_cliente
    ORDER BY dth_atualizacao DESC
) = 1
```

Esse código é um modelo. A chave, timestamp e janela devem ser definidos por tabela.

---

## 5. `type: "incremental"`

```sql
config {
  type: "incremental"
}
```

Indica que o objeto será tratado como tabela incremental.

A função:

```sql
${when(incremental(), `...`, `...`)}
```

permite alterar o comportamento entre a primeira execução e as execuções seguintes.

---

## 6. `uniqueKey`

Exemplo:

```sql
uniqueKey: ["id_cliente"]
```

Representa a chave lógica da entidade.

Se já existir:

```text
id_cliente = 100
```

e chegar uma versão mais recente do mesmo cliente, o registro existente deve ser atualizado em vez de simplesmente gerar outra linha.

Para chave composta:

```sql
uniqueKey: [
  "id_cliente",
  "id_produto"
]
```

A chave deve refletir a identidade lógica do registro e ser validada contra a origem PostgreSQL.

---

## 7. Deduplicação com `ROW_NUMBER()`

A regra mais comum é:

```sql
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_cliente
    ORDER BY dth_atualizacao DESC
) = 1
```

Interpretação:

```text
PARTITION BY
    ↓
agrupa registros da mesma entidade

ORDER BY DESC
    ↓
registro mais recente primeiro

ROW_NUMBER() = 1
    ↓
mantém somente a versão mais recente
```

Exemplo de entrada:

```text
id_cliente | nome  | dth_atualizacao
-----------+-------+----------------
10         | JOAO  | 2026-09-27 10:00
10         | JOAO  | 2026-09-28 10:00
10         | JOAO  | 2026-09-29 10:00
20         | MARIA | 2026-09-29 08:00
```

Resultado:

```text
id_cliente | nome  | dth_atualizacao
-----------+-------+----------------
10         | JOAO  | 2026-09-29 10:00
20         | MARIA | 2026-09-29 08:00
```

---

## 8. Por que não utilizar somente `SELECT DISTINCT`

`DISTINCT` remove apenas linhas completamente iguais.

Exemplo:

```text
id | nome | dth_atualizacao
---+------+----------------
10 | JOAO | 10:00
10 | JOAO | 10:05
```

As linhas continuam diferentes.

A deduplicação precisa definir:

1. qual é a chave;
2. o que caracteriza duplicidade;
3. qual versão deve sobreviver.

---

## 9. Filtro incremental

Uma possibilidade é utilizar o maior timestamp já existente:

```sql
${when(incremental(), `
WHERE dth_atualizacao >= (
    SELECT COALESCE(
        MAX(dth_atualizacao),
        TIMESTAMP("1900-01-01")
    )
    FROM ${self()}
)`, "")}
```

Fluxo:

```text
Tabela existente
      ↓
MAX(dth_atualizacao)
      ↓
Identificar registros posteriores
      ↓
Processar parcela incremental
```

Essa estratégia deve ser avaliada com cuidado quando existirem dados atrasados.

---

## 10. Problema dos registros atrasados

Suponha:

```text
Último timestamp processado:
2026-09-29 10:00
```

Depois chega:

```text
id = 100
dth_atualizacao = 2026-09-29 09:30
```

Com:

```sql
WHERE dth_atualizacao > "2026-09-29 10:00"
```

o registro seria ignorado.

Isso pode acontecer quando:

- a origem envia registros fora de ordem;
- existe atraso na ingestão;
- ocorre reprocessamento;
- uma atualização antiga chega posteriormente.

Por isso, uma janela de reprocessamento pode ser mais robusta.

---

## 11. Janela incremental

Exemplo:

```sql
WHERE dth_atualizacao >= TIMESTAMP_SUB(
    CURRENT_TIMESTAMP(),
    INTERVAL 1 DAY
)
```

Conceitualmente:

```text
dados antigos ────────────────████████████
                               ↑
                         janela de 1 dia
```

A janela deve considerar o atraso máximo esperado da origem mais uma margem de segurança.

Possíveis janelas:

```text
1 hora
6 horas
12 horas
1 dia
3 dias
7 dias
```

Não existe um valor universalmente correto.

---

## 12. Particionamento

A tabela final pode ser particionada por data:

```sql
bigquery: {
  partitionBy: "DATE(dth_atualizacao)"
}
```

Exemplo:

```text
2026-09-25
2026-09-26
2026-09-27
2026-09-28
2026-09-29
```

O particionamento e a regra de deduplicação são conceitos diferentes.

### Deduplicação

```text
Qual registro permanece?
```

### Particionamento

```text
Como os dados são organizados fisicamente?
```

Se a regra for uma linha por `id_cliente`, o `id_cliente` continua sendo a chave lógica mesmo que a tabela seja particionada por `dth_atualizacao`.

---

## 13. `updatePartitionFilter`

Quando aplicável:

```sql
config {
  type: "incremental",

  uniqueKey: ["id_cliente"],

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)",

    updatePartitionFilter:
      "dth_atualizacao >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)"
  }
}
```

O objetivo é limitar as partições consideradas durante a atualização.

A janela deve ser compatível com o comportamento de atraso dos dados.

---

## 14. `self()`

```sql
${self()}
```

faz referência à própria tabela que está sendo construída.

Pode ser usado para obter o último timestamp processado:

```sql
SELECT MAX(dth_atualizacao)
FROM ${self()}
```

Fluxo:

```text
${self()}
    ↓
MAX(timestamp)
    ↓
Identificar novos dados
```

---

## 15. Primeira execução

Como a tabela ainda não existe:

```text
incremental() = false
```

O filtro incremental não é aplicado.

```text
Tabela não existe
      ↓
SELECT completo
      ↓
ROW_NUMBER()
      ↓
Tabela deduplicada criada
```

---

## 16. Execução incremental

Nas execuções seguintes:

```text
Tabela existe
      ↓
incremental() = true
      ↓
Aplicar filtro incremental
      ↓
Obter dados novos/alterados
      ↓
ROW_NUMBER()
      ↓
Deduplicação
      ↓
INSERT / UPDATE
      ↓
Tabela final
```

---

## 17. Exemplo de evolução

### Primeira execução

```text
id | valor | timestamp
---+-------+----------------
1  | 100   | 2026-09-28 10:00
2  | 200   | 2026-09-28 11:00
3  | 300   | 2026-09-28 12:00
```

Resultado:

```text
id | valor | timestamp
---+-------+----------------
1  | 100   | 2026-09-28 10:00
2  | 200   | 2026-09-28 11:00
3  | 300   | 2026-09-28 12:00
```

### Segunda execução

Chegam:

```text
id | valor | timestamp
---+-------+----------------
2  | 250   | 2026-09-29 09:00
4  | 400   | 2026-09-29 10:00
```

Resultado esperado:

```text
id | valor | timestamp
---+-------+----------------
1  | 100   | 2026-09-28 10:00
2  | 250   | 2026-09-29 09:00
3  | 300   | 2026-09-28 12:00
4  | 400   | 2026-09-29 10:00
```

O registro antigo do `id = 2` deixa de representar a versão válida.

---

## 18. Novo registro x registro atualizado

A lógica incremental precisa tratar os dois casos.

### Registro novo

```text
id = 100
```

não existe na tabela.

Resultado:

```text
INSERT
```

### Registro atualizado

```text
id = 100
```

já existe, mas chega uma versão mais recente.

Resultado esperado:

```text
UPDATE / MERGE
```

Portanto:

```text
Incremental
   |
   +-- novo -------> INSERT
   |
   +-- existente --> UPDATE
```

---

## 19. Critério de sobrevivência

A regra deve ser determinística.

Exemplo:

```sql
ORDER BY dth_atualizacao DESC
```

Se houver timestamps iguais, utilizar um critério adicional:

```sql
ORDER BY
    dth_atualizacao DESC,
    dth_insert DESC
```

ou outro campo que permita desempate.

Isso evita resultados indeterminados.

---

## 20. Script completo de referência

```sql
config {
  type: "incremental",

  uniqueKey: ["id_cliente"],

  bigquery: {
    partitionBy: "DATE(dth_atualizacao)",

    updatePartitionFilter:
      "dth_atualizacao >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)"
  }
}

SELECT
    id_cliente,
    nome,
    valor,
    dth_atualizacao

FROM ${ref("tb_cliente_normalizada")}

${when(incremental(), `
WHERE dth_atualizacao >= TIMESTAMP_SUB(
    CURRENT_TIMESTAMP(),
    INTERVAL 7 DAY
)
`, "")}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_cliente
    ORDER BY dth_atualizacao DESC
) = 1
```

Este é um modelo. Os seguintes elementos devem ser definidos por tabela:

```text
id_cliente
dth_atualizacao
7 DAY
regra de sobrevivência
```

---

## 21. Validações

### Verificar duplicidade

```sql
SELECT
    id_cliente,
    COUNT(*) AS quantidade
FROM ${ref("tb_cliente_dedup")}
GROUP BY id_cliente
HAVING COUNT(*) > 1
```

Resultado esperado:

```text
0 registros
```

### Verificar chave nula

```sql
SELECT COUNT(*) AS quantidade
FROM ${ref("tb_cliente_dedup")}
WHERE id_cliente IS NULL
```

### Verificar timestamp nulo

```sql
SELECT COUNT(*) AS quantidade
FROM ${ref("tb_cliente_dedup")}
WHERE dth_atualizacao IS NULL
```

---

## 22. Assertions

Regras críticas podem ser implementadas como assertions.

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

Se a consulta retornar registros, a regra de unicidade foi violada.

---

## 23. Preservação da camada RAW

A deduplicação não deve sobrescrever os dados originais.

```text
RAW
 |
 +-- dados originais
 +-- duplicidades
 +-- estrutura original
 |
 v
NORMALIZAÇÃO
 |
 v
DEDUPLICAÇÃO
```

Isso permite:

- auditoria;
- reprocessamento;
- investigação;
- alteração das regras;
- comparação entre origem e destino.

---

## 24. Checklist

Antes de colocar uma tabela em produção:

- [ ] Chave lógica identificada.
- [ ] Critério de duplicidade definido.
- [ ] Timestamp identificado.
- [ ] Regra de sobrevivência definida.
- [ ] Critério de desempate definido, quando necessário.
- [ ] `type: "incremental"` configurado.
- [ ] `uniqueKey` configurado.
- [ ] Filtro incremental definido.
- [ ] Registros atrasados avaliados.
- [ ] Janela incremental definida.
- [ ] Particionamento definido.
- [ ] `updatePartitionFilter` avaliado.
- [ ] RAW preservada.
- [ ] Camada normalizada independente da deduplicação.
- [ ] Validação de duplicidade criada.
- [ ] Assertions criadas para regras críticas.

---

## 25. Fluxo final

```text
                    RAW
                     |
                     v
              NORMALIZAÇÃO
                     |
                     v
          TABELA NORMALIZADA
                     |
                     v
          FILTRO INCREMENTAL
                     |
                     v
             DADOS RECENTES
                     |
                     v
               ROW_NUMBER
                     |
                     v
             DEDUPLICAÇÃO
                     |
                     v
          UNIQUE KEY / UPDATE
             /                         /                       INSERT             UPDATE
           |                  |
           +--------+---------+
                    |
                    v
           TABELA DEDUPLICADA
                    |
                    v
               PARTICIONADA
                    |
                    v
                 CONSUMO
```

## 26. Resumo

A deduplicação incremental deve ser entendida como um processo de **manutenção da tabela deduplicada**, e não apenas como uma inserção de novos registros.

A implementação deve combinar:

```text
type: "incremental"
        +
uniqueKey
        +
filtro incremental
        +
ROW_NUMBER()
        +
regra de sobrevivência
        +
particionamento
        +
validação
```

O desenho final deve ser definido individualmente para cada tabela, principalmente em relação à chave, ao timestamp, à janela de reprocessamento e à regra que determina qual versão deve permanecer.
