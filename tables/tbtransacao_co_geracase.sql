SELECT

  -- Identificador e chaves lógicas
  SAFE_CAST(JSON_VALUE(data, '$.trscogc_id') AS INT64) AS trscogc_id,
  SAFE_CAST(JSON_VALUE(data, '$.cli_id') AS INT64) AS cli_id,
  SAFE_CAST(JSON_VALUE(data, '$.cta_id') AS INT64) AS cta_id,
  SAFE_CAST(JSON_VALUE(data, '$.fla_id') AS INT64) AS fla_id,
  SAFE_CAST(JSON_VALUE(data, '$.trs_id') AS INT64) AS trs_id,

  -- Conversões seguras de valores numéricos
  SAFE_CAST(JSON_VALUE(data, '$.crt_id') AS NUMERIC) AS crt_id,
  SAFE_CAST(JSON_VALUE(data, '$.trs_id_retorno') AS INT64) AS trs_id_retorno,
  SAFE_CAST(JSON_VALUE(data, '$.usu_id_ins') AS INT64) AS usu_id_ins,
  SAFE_CAST(JSON_VALUE(data, '$.usu_id_upd') AS INT64) AS usu_id_upd,
  SAFE_CAST(JSON_VALUE(data, '$.grp_cd') AS INT64) AS grp_cd,
  SAFE_CAST(JSON_VALUE(data, '$.org_cd') AS INT64) AS org_cd,
  SAFE_CAST(JSON_VALUE(data, '$.regrexpr_id') AS INT64) AS regrexpr_id,
  SAFE_CAST(JSON_VALUE(data, '$.regrhead_cd') AS INT64) AS regrhead_cd,

  -- STRING OR TEXT
  SAFE_CAST(JSON_VALUE(data, '$.servanl_cd') AS STRING) AS servanl_cd,
  SAFE_CAST(JSON_VALUE(data, '$.msgitfhead_id') AS STRING) AS msgitfhead_id,

  -- Padronização de datas e timestamps
  SAFE_CAST(JSON_VALUE(data, '$.trs_dh') AS TIMESTAMP) AS trs_dh,
  SAFE_CAST(JSON_VALUE(data, '$.trscogc_dh') AS TIMESTAMP) AS trscogc_dh,
  SAFE_CAST(JSON_VALUE(data, '$.trscogc_dh_usuario_ins') AS TIMESTAMP) AS trscogc_dh_usuario_ins,
  SAFE_CAST(JSON_VALUE(data, '$.trscogc_dh_usuario_upd') AS TIMESTAMP) AS trscogc_dh_usuario_upd,

  -- Metadado de auditoria do processamento
  dth_insert

FROM
  `prj-case-blbq-us.raw_novucard.evento_tb_transacao_co_geracase`


WHERE dth_insert >= TIMESTAMP('2024-01-01')