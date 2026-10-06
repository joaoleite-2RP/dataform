# Dicionário de Dados - Tabela tbtransacao
 
## Descrição
A tabela `tbtransacao` armazena informações sobre as transações realizadas.
 
## Colunas
 
| Nome da Coluna | Tipo de Dado | Descrição |
|---|---|---|
| trs_id | bigint | ID da transação. |
| crt_id | numeric | ID do cartão. |
| trs_nr_cartao | character varying | Número do cartão. |
| trs_dh | timestamp | Data e hora da transação. |
| trs_cd_autorizacao | character varying | Código de autorização. |
| trs_vl_local | numeric | Valor local da transação. |
| trs_vl_faturado | numeric | Valor faturado da transação. |
| trs_dh_validade_cartao | integer | Data de validade do cartão. |
| trs_vl_score | numeric | Valor do score. |
| pais_sg | character varying | Sigla do país. |
| moe_sg | character varying | Sigla da moeda. |
| ramatv_cd | smallint | Código do ramo de atividade. |
| trs_cd_pos | character varying | Código do POS. |
| trs_cd_acquirer | character varying | Código do adquirente. |
| trs_cd_estab | character varying | Código do estabelecimento. |
| trs_nm_estab | character varying | Nome do estabelecimento. |
| trs_nm_cidade_estab | character varying | Cidade do estabelecimento. |
| trs_sg_uf_estab | character varying | UF do estabelecimento. |
| trs_cd_cep_estab | integer | CEP do estabelecimento. |
| trs_cd_resposta | character varying | Código de resposta. |
| trs_vl_lim_disp_compra | numeric | Limite disponível para compra. |
| trs_vl_lim_disp_saque | numeric | Limite disponível para saque. |
| reacode_cd | character varying | Código da razão. |
| trs_cd_terminal | character varying | Código do terminal. |
| trs_tx_reg004 | character varying | Registro 004. |
| trs_fl_suspeita | character varying | Flag de suspeita de fraude. |
| trs_cd_entmode | character varying | Modo de entrada. |
| trs_nr_qtde_parc | integer | Quantidade de parcelas. |
| cli_id | bigint | ID do cliente. |
| cta_id | bigint | ID da conta. |
| org_cd | integer | Código da organização. |
| usu_id_ins | integer | ID do usuário de inserção. |
| trs_dh_usuario_ins | timestamp | Data de inserção. |
| usu_id_upd | integer | ID do usuário de atualização. |
| trs_dh_usuario_upd | timestamp | Data de atualização. |
| resptrs_id | integer | ID da resposta da transação. |
| cli_nr | character varying | Número do cliente. |
| cli_nr_cpf_cnpj | character varying | CPF/CNPJ do cliente. |
| trs_cd_rede1 | integer | Código da rede 1. |
| trs_vl_score1 | integer | Score da rede 1. |
| trs_cd_rede2 | integer | Código da rede 2. |
| trs_vl_score2 | integer | Score da rede 2. |
| trs_cd_rede3 | integer | Código da rede 3. |
| trs_vl_score3 | integer | Score da rede 3. |
| trs_cd_rede4 | integer | Código da rede 4. |
| trs_vl_score4 | integer | Score da rede 4. |
| trs_cd_rede5 | integer | Código da rede 5. |
| trs_vl_score5 | integer | Score da rede 5. |
| trs_cd_rede6 | integer | Código da rede 6. |
| trs_vl_score6 | integer | Score da rede 6. |
| trs_cd_rede7 | integer | Código da rede 7. |
| trs_vl_score7 | integer | Score da rede 7. |
| trs_cd_rede8 | integer | Código da rede 8. |
| trs_vl_score8 | integer | Score da rede 8. |
| trs_cd_rede9 | integer | Código da rede 9. |
| trs_vl_score9 | integer | Score da rede 9. |
| trs_cd_rede10 | integer | Código da rede 10. |
| trs_vl_score10 | integer | Score da rede 10. |
| trs_id_exec_rede1 | integer | ID de execução da rede 1. |
| trs_id_exec_rede2 | integer | ID de execução da rede 2. |
| trs_id_exec_rede3 | integer | ID de execução da rede 3. |
| trs_id_exec_rede4 | integer | ID de execução da rede 4. |
| trs_id_exec_rede5 | integer | ID de execução da rede 5. |
| trs_id_exec_rede6 | integer | ID de execução da rede 6. |
| trs_id_exec_rede7 | integer | ID de execução da rede 7. |
| trs_id_exec_rede8 | integer | ID de execução da rede 8. |
| trs_id_exec_rede9 | integer | ID de execução da rede 9. |
| trs_id_exec_rede10 | integer | ID de execução da rede 10. |
| autzmsglog_id | integer | ID do log de autorização. |
| trs_ds_origem_switcher | character varying | Origem do switcher. |
| trs_neu_id_score | smallint | ID do score neural. |
| trs_neu_rede_fxini | smallint | Faixa inicial da rede neural. |
| trs_neu_rede_fxfim | smallint | Faixa final da rede neural. |
| trs_token_age | smallint | Idade do token. |
| trs_token_req_id | numeric | ID da requisição do token. |
| trs_token_trcount | smallint | Contagem de transações do token. |
| trs_token_type | smallint | Tipo de token. |
| trs_trn_tokenizada | character varying | Transação tokenizada. |
| trs_tp_msg_entrada | character varying | Tipo de mensagem de entrada. |
| trs_nbr_token_ativo | smallint | Número de tokens ativos. |
| trs_nbr_token_inati | smallint | Número de tokens inativos. |
| trs_nbr_token_suspe | smallint | Número de tokens suspeitos. |
| trs_token_prv_score | smallint | Score do provedor de token. |
| trs_cd_bco | smallint | Código do banco. |
| trs_fl_tipo_pagamento | character varying | Tipo de pagamento. |
| trs_nr_bco_agencia | integer | Agência bancária. |
| trs_dg_bco_agencia | character varying | Dígito da agência. |
| trs_nr_bco_conta | numeric | Conta bancária. |
| trs_dg_bco_conta | character varying | Dígito da conta. |
| trs_dg_bco_agenciaconta_vf | character varying | Dígito verificador da agência/conta. |
| trs_msg_cli_requisitada | character varying | Mensagem requisitada pelo cliente. |
| trs_device_type | integer | Tipo de dispositivo. |
| trs_device_languagecode | character varying | Código de idioma do dispositivo. |
| trs_pan_source | integer | Fonte do PAN. |
| trs_token_acc_score | integer | Score da conta do token. |
| trs_token_dev_score | integer | Score do dispositivo do token. |
| trs_token_reason_code | character varying | Código de razão do token. |
| trs_device_id1 | character varying | ID do dispositivo 1. |
| trs_device_id2 | character varying | ID do dispositivo 2. |
| trs_device_id3 | character varying | ID do dispositivo 3. |
| trs_device_number | character varying | Número do dispositivo. |
| trs_ip_address | character varying | Endereço IP. |
| trs_geolcl_lattd | character varying | Latitude. |
| trs_geolcl_lngtd | character varying | Longitude. |
| trs_tp_mensagem | character varying | Tipo de mensagem. |
| trs_nr_nsu | numeric | NSU. |
| trs_nr_cta | character varying | Número da conta. |
| trs_nr_cartao_mask | character varying | Cartão mascarado. |
| trs_crd_adtnal_cvc_cvv2 | numeric | CVC/CVV2. |
| trs_fin_address_vfreq | numeric | Requisição de verificação de endereço. |
| trs_fin_address_vfresp | character varying | Resposta da verificação de endereço. |
| trs_fin_adtnal_bhserv | character varying | Serviço de comportamento adicional. |
| trs_fin_adtnal_ecomm_aut | numeric | Autenticação de e-commerce. |
| trs_fin_adtnal_ecomm_sec | numeric | Segurança de e-commerce. |
| trs_fin_adtnal_ecommucaf | numeric | E-commerce UCAF. |
| trs_fin_adtnal_frauddata | character varying | Dados de fraude. |
| trs_fin_adtnal_sec_adiss | character varying | Adicional de segurança. |
| trs_fin_adtnal_secsrvdat | character varying | Dados de serviço de segurança. |
| trs_fin_adtnal_secsrvind | character varying | Indicador de serviço de segurança. |
| trs_fin_adtnal_ucaf | character varying | UCAF. |
| trs_fin_adtnal_ucafaavct | character varying | UCAF AAVCT. |
| trs_fin_advmsg_adv_rcode | numeric | Código de aviso de mensagem. |
| trs_fin_billing_currcode | numeric | Código da moeda de faturamento. |
| trs_fin_card_valid_code | character varying | Código de validação do cartão. |
| trs_fin_cep_cdd | numeric | CEP. |
| trs_fin_cuotas_plan_type | character varying | Tipo de plano de cotas. |
| trs_fin_ecommcqi_cit_id | character varying | ID do CIT. |
| trs_fin_hosted_mobphone | character varying | Celular hospedado. |
| trs_fin_id_request_code | numeric | Código de requisição de ID. |
| trs_fin_merchant_advcode | character varying | Código de aviso do comerciante. |
| trs_fin_merfraud_scor_rc | character varying | Código de razão do score de fraude. |
| trs_fin_merfraud_scor_sc | numeric | Score de fraude. |
| trs_fin_network_finan_cd | character varying | Código da rede financeira. |
| trs_fin_panmap_acc_nr | numeric | Número da conta do PAN map. |
| trs_fin_panmap_acc_nr_id | character varying | ID da conta do PAN map. |
| trs_fin_panmap_exp_date | numeric | Data de expiração do PAN map. |
| trs_fin_panmap_tk_asslvl | numeric | Nível de assinatura do token. |
| trs_fin_panmap_tk_req_id | numeric | ID de requisição do token. |
| trs_fin_paym_ch_dev_type | character varying | Tipo de dispositivo do canal de pagamento. |
| trs_fin_paypass_ncftreqr | character varying | Requerente de PayPass. |
| trs_fin_pos_card_capcapa | numeric | Capacidade do cartão no POS. |
| trs_fin_pos_card_presenc | numeric | Presença do cartão no POS. |
| trs_fin_pos_cardh_actter | numeric | Terminal de ação do portador. |
| trs_fin_pos_cardh_presen | character varying | Presença do portador. |
| trs_fin_pos_country_code | numeric | Código do país do POS. |
| trs_fin_pos_term_attend | numeric | Atendimento do terminal. |
| trs_fin_pos_term_capab | numeric | Capacidade do terminal. |
| trs_fin_pos_term_locat | numeric | Localização do terminal. |
| trs_fin_pos_termpinentmd | numeric | Modo de entrada de PIN do terminal. |
| trs_fin_pos_trs_security | numeric | Segurança da transação. |
| trs_fin_pos_trs_status | numeric | Status da transação. |
| trs_fin_posecc_fnl_auth | numeric | Autenticação final do POS. |
| trs_fin_posecc_mertfrdsc | numeric | Score de fraude do comerciante. |
| trs_fin_posecc_ptaprterm | numeric | Terminal de aprovação do ponto. |
| trs_fin_posecc_prammterm | numeric | Terminal de aprovação do programa. |
| trs_fin_process_code | numeric | Código de processamento. |
| trs_fin_process_cdfacc | numeric | Conta de código de processamento. |
| trs_fin_process_cdtacc | numeric | Conta de código de processamento. |
| trs_fin_process_cdtrstp | numeric | Tipo de transação do código de processamento. |
| trs_fin_stan_code | numeric | Código STAN. |
| trs_fin_wallet_prgdt | character varying | Dados do programa da carteira. |
| trs_fin_wallet_prgdtwtid | character varying | ID da carteira do programa. |
| trs_cp_a1pos1 | character varying | Campo customizado A1P1. |
| trs_cp_a1pos2 | character varying | Campo customizado A1P2. |
| trs_cp_n1pos1 | numeric | Campo customizado N1P1. |
| trs_cp_n1pos2 | numeric | Campo customizado N1P2. |
| trs_cp_a3pos1 | character varying | Campo customizado A3P1. |
| trs_cp_a3pos2 | character varying | Campo customizado A3P2. |
| trs_cp_n3pos1 | numeric | Campo customizado N3P1. |
| trs_cp_n3pos2 | numeric | Campo customizado N3P2. |
| trs_cp_a5pos1 | character varying | Campo customizado A5P1. |
| trs_cp_a5pos2 | character varying | Campo customizado A5P2. |
| trs_cp_n6pos1 | numeric | Campo customizado N6P1. |
| trs_cp_n6pos2 | numeric | Campo customizado N6P2. |
| trs_cp_n8pos1 | numeric | Campo customizado N8P1. |
| trs_cp_n8pos2 | numeric | Campo customizado N8P2. |
| trs_cp_a10pos1 | character varying | Campo customizado A10P1. |
| trs_cp_a10pos2 | character varying | Campo customizado A10P2. |
| trs_cp_n16pos1 | numeric | Campo customizado N16P1. |
| trs_cp_n16pos2 | numeric | Campo customizado N16P2. |
| trs_cp_a30pos1 | character varying | Campo customizado A30P1. |
| trs_cp_a30pos2 | character varying | Campo customizado A30P2. |
| trs_cp_a50pos1 | character varying | Campo customizado A50P1. |
| trs_cp_a50pos2 | character varying | Campo customizado A50P2. |
| trs_cp_a100pos1 | character varying | Campo customizado A100P1. |
| trs_cp_a100pos2 | character varying | Campo customizado A100P2. |
| trs_cd_grupo | numeric | Código do grupo. |
| trs_cd_regra | numeric | Código da regra. |
| trs_cd_rede_neural | numeric | Código da rede neural. |
| trs_vl_score_neural | numeric | Score da rede neural. |
| trs_certif_cvv2 | character varying | Certificado CVV2. |
| trs_id_req_token | numeric | ID de requisição do token. |
| trs_nivel_segur_token | numeric | Nível de segurança do token. |
| trs_pan | character varying | PAN. |
| trs_token_psn | numeric | PSN do token. |
| trs_token_expiration | numeric | Expiração do token. |
| trs_token_status | numeric | Status do token. |
| trs_token_result | numeric | Resultado do token. |
| trs_emv_result | numeric | Resultado EMV. |
| trs_token_constraint | numeric | Restrição do token. |
| trs_date_time_constraint | character varying | Restrição de data e hora. |
| trs_amount_constraint | character varying | Restrição de valor. |
| trs_usage_constraint | character varying | Restrição de uso. |
| trs_token_atc_results | numeric | Resultados ATC do token. |
| trs_cve_token | numeric | CVE do token. |
| trs_mcc_constraint | character varying | Restrição de MCC. |
| trs_msg_type_identifier | character varying | Identificador do tipo de mensagem. |
| trs_cpi_ds1 | character varying | Descrição CPI 1. |
| trs_cpi_vl1 | numeric | Valor CPI 1. |
| trs_cpi_ds2 | character varying | Descrição CPI 2. |
| trs_cpi_vl2 | numeric | Valor CPI 2. |
| trs_cpi_ds3 | character varying | Descrição CPI 3. |
| trs_cpi_vl3 | numeric | Valor CPI 3. |
| trs_cpi_ds4 | character varying | Descrição CPI 4. |
| trs_cpi_vl4 | numeric | Valor CPI 4. |
| trs_cpi_ds5 | character varying | Descrição CPI 5. |
| trs_cpi_vl5 | numeric | Valor CPI 5. |
| trs_id_externo | numeric | ID externo. |
| trs_cd_estab_cad | character varying | Código do estabelecimento cadastrado. |
| trs_mn_estab_cad | character varying | Nome do estabelecimento cadastrado. |
| trs_fl_atualiza | character varying | Flag de atualização. |
| servanl_cd | character varying | Código de análise do serviço. |
| trs_tp_resp_class | character varying | Tipo de resposta da classificação. |
| trs_cd_resp_class | character varying | Código de resposta da classificação. |
| trs_ds_resp_class | character varying | Descrição da resposta da classificação. |
| trs_fg_chageback | character varying | Flag de chargeback. |
| trs_dh_chageback | timestamp | Data do chargeback. |
| trs_vl_chargeback | numeric | Valor do chargeback. |
| trs_cd_user_chargeback | character varying | Usuário do chargeback. |
| trs_nm_user_chargeback | character varying | Nome do usuário do chargeback. |
| trs_ds_comm_chargeback | character varying | Comentário do chargeback. |
| trs_id_externo_cpl | character varying | ID externo complementar. |
| trs_nr_bin | numeric | BIN. |
| trs_password_present | character varying | Senha presente. |
| trs_token_id | numeric | ID do token. |
| trs_wallet_id | numeric | ID da carteira. |
| trs_device_id_wallet | numeric | ID do dispositivo da carteira. |
| trs_st_card | character varying | Status do cartão. |
| trs_vl_total_limit | numeric | Limite total. |
| trs_ds_card_network | character varying | Rede do cartão. |
| trs_tp_card_type | character varying | Tipo do cartão. |
| trs_chip_crypt_inf_data | character varying | Dados de informação criptografada do chip. |
| trs_chip_transaction_date | character varying | Data da transação do chip. |
| trs_chip_transaction_type | character varying | Tipo de transação do chip. |
| trs_chip_amount_authorized | character varying | Valor autorizado do chip. |
| trs_chip_trans_currency_code | character varying | Código da moeda da transação do chip. |
| trs_chip_app_interchange_profile | character varying | Perfil de intercâmbio da aplicação do chip. |
| trs_chip_terminal_country_code | character varying | Código do país do terminal do chip. |
| trs_chip_cardholder_verif_method | character varying | Método de verificação do portador do chip. |
| trs_chip_terminal_capabilities | character varying | Capacidades do terminal do chip. |
| trs_chip_amount_other | character varying | Outro valor do chip. |
| trs_chip_atc | character varying | ATC do chip. |
| trs_chip_tvr | character varying | TVR do chip. |
| trs_chip_issuer_app_data | character varying | Dados da aplicação do emissor do chip. |
| trs_denial_code | character varying | Código de negação. |
| trs_has_cvv_data | character varying | Possui dados de CVV. |
| trs_pin_valid_offline | character varying | PIN válido offline. |
| trs_arqc_valid_st | character varying | Status de validação do ARQC. |
| trs_arqc_valid_reason | character varying | Razão de validação do ARQC. |
| trs_chip_signature_valid_st | character varying | Status de validação da assinatura do chip. |
| trs_chip_signature_valid_reason | character varying | Razão de validação da assinatura do chip. |
| trs_chip_values_valid_st | character varying | Status de validação dos valores do chip. |
| trs_chip_values_valid_reason | character varying | Razão de validação dos valores do chip. |
| trs_currency_valid_st | character varying | Status de validação da moeda. |
| trs_currency_valid_reason | character varying | Razão de validação da moeda. |
| trs_cvm_valid_st | character varying | Status de validação do CVM. |
| trs_cvm_valid_reason | character varying | Razão de validação do CVM. |
| trs_magnetic_stripe_valid_st | character varying | Status de validação da tarja magnética. |
| trs_magnetic_stripe_valid_reason | character varying | Razão de validação da tarja magnética. |
| trs_terminal_capability_valid_st | character varying | Status de validação da capacidade do terminal. |
| trs_terminal_capability_valid_reason | character varying | Razão de validação da capacidade do terminal. |
| trs_program_config_valid_st | character varying | Status de validação da configuração do programa. |
| trs_program_config_valid_reason | character varying | Razão de validação da configuração do programa. |
| trs_card_atc_valid_st | character varying | Status de validação do ATC do cartão. |
| trs_card_atc_valid_reason | character varying | Razão de validação do ATC do cartão. |
| trs_contactless_valid_st | character varying | Status de validação do contactless. |
| trs_contactless_valid_reason | character varying | Razão de validação do contactless. |
| trs_account_type_valid_st | character varying | Status de validação do tipo de conta. |
| trs_account_type_valid_reason | character varying | Razão de validação do tipo de conta. |
| trs_card_inp_exp_date_valid_st | character varying | Status de validação da data de expiração inserida. |
| trs_card_inp_exp_date_valid_reason | character varying | Razão de validação da data de expiração inserida. |
| trs_card_valid_until_valid_st | character varying | Status de validação da data de validade do cartão. |
| trs_card_valid_until_valid_reason | character varying | Razão de validação da data de validade do cartão. |
| trs_card_exp_date_valid_st | character varying | Status de validação da data de expiração do cartão. |
| trs_card_exp_date_valid_reason | character varying | Razão de validação da data de expiração do cartão. |
| trs_card_st_valid_st | character varying | Status de validação do status do cartão. |
| trs_card_st_valid_reason | character varying | Razão de validação do status do cartão. |
| trs_card_exists_valid_st | character varying | Status de validação da existência do cartão. |
| trs_card_exists_valid_reason | character varying | Razão de validação da existência do cartão. |
| trs_card_token_valid_st | character varying | Status de validação do token do cartão. |
| trs_card_token_valid_reason | character varying | Razão de validação do token do cartão. |
| trs_card_token_st_valid_st | character varying | Status de validação do status do token do cartão. |
| trs_card_token_st_valid_reason | character varying | Razão de validação do status do token do cartão. |
| trs_password_attempts_valid_st | character varying | Status de validação das tentativas de senha. |
| trs_password_attempts_valid_reason | character varying | Razão de validação das tentativas de senha. |
| trs_account_limits_valid_st | character varying | Status de validação dos limites da conta. |
| trs_account_limits_valid_reason | character varying | Razão de validação dos limites da conta. |
| trs_account_st_valid_st | character varying | Status de validação do status da conta. |
| trs_account_st_valid_reason | character varying | Razão de validação do status da conta. |
| trs_max_trs_temp_card_valid_st | character varying | Status de validação do máximo de transações do cartão temporário. |
| trs_max_trs_temp_card_valid_reason | character varying | Razão de validação do máximo de transações do cartão temporário. |
| trs_operation_valid_st | character varying | Status de validação da operação. |
| trs_operation_valid_reason | character varying | Razão de validação da operação. |
| trs_credit_limit_valid_st | character varying | Status de validação do limite de crédito. |
| trs_credit_limit_valid_reason | character varying | Razão de validação do limite de crédito. |
| trs_card_trs_limit_valid_st | character varying | Status de validação do limite de transação do cartão. |
| trs_card_trs_limit_valid_reason | character varying | Razão de validação do limite de transação do cartão. |
| trs_zero_balance_valid_st | character varying | Status de validação de saldo zero. |
| trs_zero_balance_valid_reason | character varying | Razão de validação de saldo zero. |
| trs_ledger_valid_st | character varying | Status de validação do razão. |
| trs_ledger_valid_reason | character varying | Razão de validação do razão. |
| trs_rules_valid_st | character varying | Status de validação das regras. |
| trs_rules_valid_reason | character varying | Razão de validação das regras. |
| trs_internal_error_valid_st | character varying | Status de validação de erro interno. |
| trs_internal_error_valid_reason | character varying | Razão de validação de erro interno. |
| trs_authentication_data | character varying | Dados de autenticação. |
| trs_vl_max_credit_limit | numeric | Limite máximo de crédito. |
| trs_field_tag | numeric | Tag do campo. |
| trs_version_table | numeric | Versão da tabela. |
| trs_transaction_cycle | numeric | Ciclo da transação. |
| trs_utility_provider_code | numeric | Código do provedor de utilidade. |
| trs_dh_due | timestamp | Data de vencimento. |
| trs_vl_due | numeric | Valor de vencimento. |
| trs_reversal_mti | numeric | MTI de reversão. |
| trs_reversal_nsu | numeric | NSU de reversão. |
| trs_dh_reversal | timestamp | Data da reversão. |
| trs_verification_data | numeric | Dados de verificação. |
| trs_criptografy_version | character varying | Versão da criptografia. |
| trs_reversal_nsu_host | character varying | NSU do host de reversão. |
| trs_nsu_host | character varying | NSU do host. |
| trs_transaction_mode | character varying | Modo da transação. |
| trs_transaction_type | character varying | Tipo da transação. |
| trs_cavv_response_code | character varying | Código de resposta do CAVV. |
| trs_product_id | character varying | ID do produto. |
| trs_rec_payment_transaction | character | Transação de pagamento recorrente. |
| trs_dh_card_unlock | timestamp | Data de desbloqueio do cartão. |
 
### Colunas de Data e Hora de Inserção/Atualização
As colunas que registram a data e hora de inserção e atualização são:
- `trs_dh_usuario_ins`: Data de inserção.
- `trs_dh_usuario_upd`: Data de atualização.
 
### Principais Colunas
As principais colunas da tabela `tbtransacao` são:
- `trs_id`: ID da transação (Chave Primária).
- `crt_id`: ID do cartão (Chave Estrangeira).
- `cli_id`: ID do cliente (Chave Estrangeira).
- `cta_id`: ID da conta (Chave Estrangeira).
- `org_cd`: Código da organização (Chave Estrangeira).
- `trs_nr_cartao`: Número do cartão.
- `trs_dh`: Data e hora da transação.
- `trs_cd_autorizacao`: Código de autorização.
- `trs_vl_local`: Valor local da transação.
- `trs_vl_faturado`: Valor faturado da transação.
- `trs_vl_score`: Valor do score.
- `pais_sg`: Sigla do país.
- `moe_sg`: Sigla da moeda.
- `ramatv_cd`: Código do ramo de atividade.
- `trs_fl_suspeita`: Flag de suspeita de fraude.
- `trs_tp_msg_entrada`: Tipo de mensagem de entrada.