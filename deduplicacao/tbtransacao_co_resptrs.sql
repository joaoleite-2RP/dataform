config {
  type: "table",
  schema: "novucard_deduplication",
  tags: ["deduplicated", "novucard_deduplication", "tbtransacao_co_resptrs"],
  description: "Modelo de Deduplicação completa (TABLE) da tabela tbtransacao_co_resptrs. Identifica registros lógicos duplicados e preserva apenas a versão mais recente via QUALIFY ROW_NUMBER().",
  bigquery: {
    partitionBy: "DATE(trscort_dh)",
    clusterBy: ["trscort_id", "trs_id"]
  }
}


/*
  ==============================================================================
  OBJETIVO DA DEDUPLICAÇÃO (TABLE / CURATED) - tbtransacao_co_resptrs:
  ------------------------------------------------------------------------------
  - Consome SEMPRE a camada normalizada: ${ref("tbtransacao_co_resptrs")}.
  - Regra de Unicidade: Define a chave lógica primária (trscort_id).
  - Regra de Sobrevivência: Define qual versão prevalece (maior timestamp de atualização/inserção).
  - Critério de Desempate: Segundo critério para garantir determinismo (maior dth_insert).
  
  POR QUE NÃO USAR DISTINCT:
  - O SELECT DISTINCT remove apenas linhas 100% idênticas em todas as colunas.
  - Registros com atualizações em campos de status/auditoria manteriam múltiplas versões.
  
  ATENÇÃO AO PARTICIONAMENTO:
  - O particionamento físico (bigquery.partitionBy) organiza os dados em disco por data do evento.
  - A janela da deduplicação (PARTITION BY trscort_id) avalia toda a base para evitar duplicações
    entre partições distintas.
  ==============================================================================
*/

SELECT
    trscort_id,
    trs_id,
    grp_cd,
    regrhead_cd,
    regrexpr_id,
    usu_id_ins,
    usu_id_upd,
    servanl_cd,
    trscort_prm1,
    trscort_prm2,
    trscort_prm3,
    trscort_execucao_ctrl,
    trscort_execucao_ctrl_erro,
    trscort_dh,
    trscort_dh_usuario_ins,
    trscort_dh_usuario_upd,
    dth_insert,
    CURRENT_TIMESTAMP() AS dth_processamento

-- Consome a camada normalizada
FROM ${ref("view_raw_tbtransacao_co_resptrs")}

-- Filtra apenas o registro mais recente para cada chave lógica
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY trscort_id
    ORDER BY
        COALESCE(trscort_dh_usuario_upd, trscort_dh_usuario_ins, trscort_dh) DESC,
        dth_insert DESC
) = 1


/*
  ==============================================================================
  PONTOS DE ATENÇÃO E DECISÕES DE ARQUITETURA:
  ==============================================================================

  1. CHAVE DE UNICIDADE (PARTITION BY trscort_id):
     - 'trscort_id' é o identificador único da resposta da transação (Chave Primária).
     - PONTO DE ATENÇÃO: Caso no modelo relacional a chave lógica seja composta entre a transação
       e a resposta, a partição da window function pode ser ajustada para:
       `PARTITION BY trscort_id, trs_id` (ou `PARTITION BY trs_id, regrhead_cd` se houver regra de negócio específica).
       Mantemos 'trscort_id' como chave padrão conforme o dicionário de dados.

  2. REGRA DE SOBREVIVÊNCIA E TRATAMENTO DE NULOS:
     - No BigQuery, ordenações 'ORDER BY campo DESC' colocam registros com valor NULL no início (NULLS FIRST).
     - Como 'trscort_dh_usuario_upd' é nulo quando o registro ainda não sofreu update, ordenar diretamente
       por ele faria versões não atualizadas vencerem versões que foram atualizadas.
     - SOLUÇÃO ADOTADA: `COALESCE(trscort_dh_usuario_upd, trscort_dh_usuario_ins, trscort_dh) DESC`.
       Dessa forma, caso não haja timestamp de update, utiliza-se a data de inserção do registro,
       e como fallback a data do evento da resposta.

  3. CRITÉRIO DE DESEMPATE DETERMINÍSTICO:
     - `dth_insert DESC` é utilizado como segundo critério no ORDER BY. Isso garante que, caso dois eventos
       tenham o mesmo timestamp de auditoria, o último lote ingerido pelo pipeline no BigQuery prevaleça.

  4. PARTICIONAMENTO FÍSICO (bigquery.partitionBy):
     - Definido como `DATE(trscort_dh)`, que reflete a data em que a resposta da transação de fato ocorreu
       no negócio.
     - PONTO DE ATENÇÃO: Caso o time de Engenharia de Dados prefira particionar pelo ciclo de vida
       técnico da ingestão, pode-se alterar para `DATE(dth_insert)` ou `DATE(trscort_dh_usuario_ins)`.

  5. CLUSTERIZAÇÃO (bigquery.clusterBy):
     - Definida como `["trscort_id", "trs_id"]` para otimizar pesquisas diretas pela chave primária da
       resposta e viabilizar JOINs de alta performance com a tabela principal de transações (`tbtransacao`).
  ==============================================================================
*/
