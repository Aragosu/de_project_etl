-- 1. STG - уровень
drop table if exists public.pvv5_stg_accounts;
drop table if exists public.pvv5_stg_clients;
drop table if exists public.pvv5_stg_cards;
drop table if exists public.pvv5_stg_blacklist;
drop table if exists public.pvv5_stg_terminals;
drop table if exists public.pvv5_stg_transactions;
-- 2. DIM - уровень
drop table if exists public.pvv5_dwh_dim_clients_hist;
drop table if exists public.pvv5_dwh_dim_accounts_hist;
drop table if exists public.pvv5_dwh_dim_cards_hist;
drop table if exists public.pvv5_dwh_dim_terminals_hist;
drop table if exists public.pvv5_dwh_fact_transactions;
drop table if exists public.pvv5_dwh_fact_passport_blacklist;
-- 3. REP - уровень
drop table if exists public.pvv5_rep_fraud;

-- =======================================================================================================================
-- ================================================== 1. STG - уровень ===================================================
-- =======================================================================================================================


CREATE TABLE if not exists public.pvv5_stg_accounts (
	account_num	varchar(20) NULL,
	valid_to	date NULL,
	client 		varchar(10) NULL,
	create_dt	timestamp(0) NULL,
	update_dt	timestamp(0) NULL
);

CREATE TABLE if not exists public.pvv5_stg_clients (
	client_id			varchar(10) NULL,
	last_name			varchar(20) NULL,
	first_name			varchar(20) NULL,
	patronymic			varchar(20) NULL,
	date_of_birth		date NULL,
	passport_num 		varchar(15) NULL,
	passport_valid_to 	date NULL,
	phone 				varchar(16) NULL,
	create_dt			timestamp(0) NULL,
	update_dt			timestamp(0) NULL
);

CREATE TABLE if not exists public.pvv5_stg_cards (
	card_num	varchar(20) NULL,
	account_num	varchar(20) NULL,
	create_dt	timestamp(0) NULL,
	update_dt	timestamp(0) NULL
);

CREATE TABLE if not exists public.pvv5_stg_blacklist (
	"date"		date NULL,
	passport	varchar(20) null
);

CREATE TABLE if not exists public.pvv5_stg_terminals (
	terminal_id 		varchar(10) null,
	terminal_type 		varchar(20) null,
	terminal_city 		varchar(100) null,
	terminal_address 	varchar(200) null
);

CREATE TABLE if not exists public.pvv5_stg_transactions (
	transaction_id 		int8 null,
	transaction_date 	varchar(20) null,
	amount		 		float4 null,
	card_num		 	varchar(20) null,
	oper_type			varchar(10) null,
	oper_result			varchar(10) null,
	terminal			varchar(10) null
);


-- =======================================================================================================================
-- ================================================== 2. DIM - уровень ===================================================
-- =======================================================================================================================


-- ================================================== Таблицы формы SCD2

drop table if exists public.pvv5_dwh_dim_clients_hist;
drop table if exists public.pvv5_dwh_dim_accounts_hist;
drop table if exists public.pvv5_dwh_dim_cards_hist;
drop table if exists public.pvv5_dwh_dim_terminals_hist;
drop table if exists public.pvv5_dwh_fact_transactions;
drop table if exists public.pvv5_dwh_fact_passport_blacklist;
drop table if exists public.pvv5_rep_fraud;

CREATE TABLE if not exists public.pvv5_dwh_dim_clients_hist (
	client_id			varchar(10) null,-- unique,
	last_name			varchar(20) NULL,
	first_name			varchar(20) NULL,
	patronymic			varchar(20) NULL,
	date_of_birth		date NULL,
	passport_num 		varchar(15) NULL,
	passport_valid_to 	date NULL,
	phone 				varchar(16) NULL,
	effective_from		timestamp(0) null,
	effective_to		timestamp(0) null,
	deleted_flg			bool
);


CREATE TABLE if not exists public.pvv5_dwh_dim_accounts_hist (
	account_num		varchar(20) null,-- unique,
	valid_to		date NULL,
	client 			varchar(10) NULL,
	effective_from	timestamp(0) null,
	effective_to	timestamp(0) null,
	deleted_flg		bool
--	,foreign key (client) references public.pvv5_dim_clients(client_id)
);

CREATE TABLE if not exists public.pvv5_dwh_dim_cards_hist (
	card_num		varchar(20) null,-- unique,
	account_num		varchar(20) NULL,
	effective_from	timestamp(0) null,
	effective_to	timestamp(0) null,
	deleted_flg		bool
--	,foreign key (account_num) references public.pvv5_dim_accounts(account_num)
);

CREATE TABLE if not exists public.pvv5_dwh_dim_terminals_hist (
	terminal_id 		varchar(10) null,-- unique,
	terminal_type 		varchar(20) null,
	terminal_city 		varchar(100) null,
	terminal_address 	varchar(200) null,
	effective_from		timestamp(0) null,
	effective_to		timestamp(0) null,
	deleted_flg			bool
);

-- ================================================== Остальные таблицы
CREATE TABLE if not exists public.pvv5_dwh_fact_transactions (
	trans_id 	varchar null,
	trans_date 	timestamp null,
	card_num	varchar(20) null,
	oper_type	varchar(10) null,
	amt			decimal null,
	oper_result	varchar(10) null,
	terminal	varchar(10) null
--	,foreign key (card_num) references public.pvv5_dim_cards(card_num),
--	,foreign key (terminal) references public.pvv5_dim_terminals(terminal_id)
);

CREATE TABLE if not exists public.pvv5_dwh_fact_passport_blacklist (
	entry_dt date NULL,
	passport varchar(20) null
);


-- =======================================================================================================================
-- ================================================== 3. REP - уровень ===================================================
-- =======================================================================================================================

CREATE TABLE if not exists public.pvv5_rep_fraud (
	event_dt	date NULL,
	passport	varchar(20) null,
	fio			varchar(100) null,
	phone		varchar(16) NULL,
	event_type	varchar(50) null,
	report_dt	date NULL
);
