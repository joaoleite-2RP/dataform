## Descrição
A tabela `tbtransacao_co_resptrs` armazena informações sobre as respostas das transações.
 
## Colunas
 
| Nome da Coluna | Tipo de Dado | Descrição |
|---|---|---|
| trs_id | bigint | ID da transação. |
| trscort_id | integer | ID da resposta da transação. |
| grp_cd | integer | Código do grupo. |
| regrhead_cd | integer | Código do cabeçalho da regra. |
| regrexpr_id | integer | ID da expressão da regra. |
| trscort_dh | timestamp | Data e hora da resposta. |
| trscort_prm1 | character varying | Parâmetro 1. |
| trscort_prm2 | character varying | Parâmetro 2. |
| trscort_prm3 | character varying | Parâmetro 3. |
| usu_id_ins | integer | ID do usuário que inseriu o registro. |
| trscort_dh_usuario_ins | timestamp | Data de inserção do registro. |
| usu_id_upd | integer | ID do usuário que atualizou o registro. |
| trscort_dh_usuario_upd | timestamp | Data de atualização do registro. |
| trscort_execucao_ctrl | character varying | Controle de execução. |
| trscort_execucao_ctrl_erro | character varying | Erro de controle de execução. |
| servanl_cd | character varying | Código do serviço de análise. |
 
 
# Dicionário de Dados - Tabela tbtransacao_co_geracase
 
## Descrição
A tabela `tbtransacao_co_geracase` armazena informações sobre a geração de casos para transações.
 
## Colunas
 
| Nome da Coluna | Tipo de Dado | Descrição |
|---|---|---|
| trs_id | bigint | ID da transação. |
| trscogc_id | integer | ID da geração do caso. |
| org_cd | integer | Código da organização. |
| fla_id | integer | ID da fila. |
| grp_cd | integer | Código do grupo. |
| regrhead_cd | integer | Código do cabeçalho da regra. |
| regrexpr_id | integer | ID da expressão da regra. |
| cli_id | bigint | ID do cliente. |
| cta_id | bigint | ID da conta. |
| crt_id | numeric | ID do cartão. |
| trs_dh | timestamp | Data e hora da transação. |
| trscogc_dh | timestamp | Data e hora da geração do caso. |
| usu_id_ins | integer | ID do usuário que inseriu o registro. |
| trscogc_dh_usuario_ins | timestamp | Data de inserção do registro. |
| usu_id_upd | integer | ID do usuário que atualizou o registro. |
| trscogc_dh_usuario_upd | timestamp | Data de atualização do registro. |
| servanl_cd | character varying | Código do serviço de análise. |
| trs_id_retorno | bigint | ID de retorno da transação. |
| msgitfhead_id | character varying | ID do cabeçalho da interface de mensagem. |
 
### Colunas de Data e Hora de Inserção/Atualização
 
As colunas que registram a data e hora de inserção e atualização são:
 
* `trscort_dh_usuario_ins`: Data de inserção do registro.
* `trscort_dh_usuario_upd`: Data de atualização do registro.
 
### Principais Colunas
 
As principais colunas da tabela `tbtransacao_co_resptrs` são:
 
* Identificar os identificadores primários: `trs_id`, `trscort_id`.
* Identificar os principais identificadores de negócio: `grp_cd`.
* Identificar os principais timestamps de resposta da transação: `trscort_dh`.
* Identificar campos descritivos importantes ou semelhantes a chaves estrangeiras: `regrhead_cd`, `regrexpr_id`.
* Identificar campos de controle de execução: `trscort_execucao_ctrl`.