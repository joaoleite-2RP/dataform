  SELECT

    -- Identificador e chaves lógicas
    SAFE_CAST(JSON_VALUE(data, '$.trscort_id') AS INT64) AS trscort_id,
    SAFE_CAST(JSON_VALUE(data, '$.trs_id') AS INT64) AS trs_id,

    -- Conversões seguras de valores numéricos
    SAFE_CAST(JSON_VALUE(data, '$.grp_cd') AS INT64) AS grp_cd,
    SAFE_CAST(JSON_VALUE(data, '$.regrhead_cd') AS INT64) AS regrhead_cd,
    SAFE_CAST(JSON_VALUE(data, '$.regrexpr_id') AS INT64) AS regrexpr_id,
    SAFE_CAST(JSON_VALUE(data, '$.usu_id_ins') AS INT64) AS usu_id_ins,
    SAFE_CAST(JSON_VALUE(data, '$.usu_id_upd') AS INT64) AS usu_id_upd,

    -- STRING
    SAFE_CAST(JSON_VALUE(data, '$.servanl_cd') AS STRING) AS servanl_cd,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_prm1') AS STRING) AS trscort_prm1,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_prm2') AS STRING) AS trscort_prm2,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_prm3') AS STRING) AS trscort_prm3,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_execucao_ctrl') AS STRING) AS trscort_execucao_ctrl,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_execucao_ctrl_erro') AS STRING) AS trscort_execucao_ctrl_erro,

    -- Padronização de datas e timestamps
    SAFE_CAST(JSON_VALUE(data, '$.trscort_dh') AS TIMESTAMP) AS trscort_dh,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_dh_usuario_ins') AS TIMESTAMP) AS trscort_dh_usuario_ins,
    SAFE_CAST(JSON_VALUE(data, '$.trscort_dh_usuario_upd') AS TIMESTAMP) AS trscort_dh_usuario_upd,

    -- Metadado de auditoria do processamento
    dth_insert

  FROM
    `prj-case-blbq-us.raw_novucard.evento_tb_transacao_co_resptrs`


  WHERE dth_insert >= TIMESTAMP('2024-01-01')
