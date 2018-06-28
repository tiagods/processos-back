--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.9
-- Dumped by pg_dump version 9.6.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: negocio_ultimo_negocio_function(); Type: FUNCTION; Schema: public; Owner: developer
--

CREATE FUNCTION public.negocio_ultimo_negocio_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
  -- Aqui temos um bloco IF que confirmará o tipo de operação.
  IF (TG_OP = 'INSERT') THEN
  	IF(NEW.neg_classe = 'Empresa') THEN
    	UPDATE empresa SET emp_ult_negocio_cod=NEW.neg_cod WHERE emp_cod=NEW.neg_empresa_cod;
    ELSIF(NEW.neg_classe= 'Pessoa') THEN
    	UPDATE pessoa SET pes_ult_negocio_cod=NEW.neg_cod WHERE pes_cod=NEW.neg_pessoa_cod;
    ELSIF(NEW.neg_classe= 'Prospeccao') THEN
    	UPDATE prospeccao SET pro_ult_negocio_cod=NEW.neg_cod WHERE pro_cod=NEW.neg_prospeccao_cod;
    END IF;
  RETURN NEW;
  ELSIF (TG_OP = 'UPDATE') THEN
  -- Aqui tive que avisar que o objeto pode ser alterado, se houver alteracao sera relizado um update
  	IF(NEW.neg_classe != OLD.neg_classe) THEN
		IF(OLD.neg_classe = 'Empresa') THEN
			UPDATE empresa SET emp_ult_negocio_cod=
			(select max(neg_cod) from negocio where neg_empresa_cod=OLD.neg_empresa_cod) 
			WHERE emp_cod=OLD.neg_empresa_cod;
		ELSIF(OLD.neg_classe= 'Pessoa') THEN
			UPDATE pessoa SET pes_ult_negocio_cod=
			(select max(neg_cod) from negocio where neg_pessoa_cod=OLD.neg_pessoa_cod)
			WHERE pes_cod=OLD.neg_pessoa_cod;
		ELSIF(OLD.neg_classe= 'Prospeccao') THEN
			UPDATE prospeccao SET pro_ult_negocio_cod=
			(select max(neg_cod) from negocio where neg_prospeccao_cod=OLD.neg_prospeccao_cod)
			WHERE p.pro_cod=OLD.neg_prospeccao_cod;
		END IF;
	END IF;
	IF(NEW.neg_classe = 'Empresa') THEN
    	UPDATE empresa SET emp_ult_negocio_cod=NEW.neg_cod WHERE emp_cod=NEW.neg_empresa_cod;
		IF(NEW.neg_empresa_cod != OLD.neg_empresa_cod) THEN
			UPDATE empresa SET emp_ult_negocio_cod=
			(select max(neg_cod) from negocio where neg_empresa_cod=OLD.neg_empresa_cod) 
			WHERE emp_cod=OLD.neg_empresa_cod;
		END IF;
    ELSIF(NEW.neg_classe= 'Pessoa') THEN
    	UPDATE pessoa SET pes_ult_negocio_cod=NEW.neg_cod WHERE pes_cod=NEW.neg_pessoa_cod;
		IF(NEW.neg_pessoa_cod != OLD.neg_pessoa_cod) THEN
			UPDATE pessoa SET pes_ult_negocio_cod=OLD.neg_cod WHERE pes_cod=OLD.neg_pessoa_cod;
		END IF;
    ELSIF(NEW.neg_classe= 'Prospeccao') THEN
    	UPDATE prospeccao SET pro_ult_negocio_cod=NEW.neg_cod WHERE pro_cod=NEW.neg_prospeccao_cod;
		IF(NEW.neg_prospeccao_cod != OLD.neg_prospeccao_cod) THEN
			UPDATE prospeccao SET pro_ult_negocio_cod=OLD.neg_cod WHERE pro_cod=OLD.neg_prospeccao_cod;
		END IF;
    END IF;
  RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
  	IF(OLD.neg_classe = 'Empresa') THEN
    	UPDATE empresa SET emp_ult_negocio_cod=
        (select max(neg_cod) from negocio where neg_empresa_cod=OLD.neg_empresa_cod) 
        WHERE emp_cod=OLD.neg_empresa_cod;
    ELSIF(OLD.neg_classe= 'Pessoa') THEN
    	UPDATE pessoa SET pes_ult_negocio_cod=
        (select max(neg_cod) from negocio where neg_pessoa_cod=OLD.neg_pessoa_cod)
        WHERE pes_cod=OLD.neg_pessoa_cod;
    ELSIF(OLD.neg_classe= 'Prospeccao') THEN
    	UPDATE prospeccao SET pro_ult_negocio_cod=
        (select max(neg_cod) from negocio where neg_prospeccao_cod=OLD.neg_prospeccao_cod)
        WHERE p.pro_cod=OLD.neg_prospeccao_cod;
    END IF;
  RETURN OLD;
  END IF;
  RETURN NULL;
  END;
  $$;


ALTER FUNCTION public.negocio_ultimo_negocio_function() OWNER TO developer;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categoria; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.categoria (
    cat_cod integer NOT NULL,
    cat_nome character varying(100)
);


ALTER TABLE public.categoria OWNER TO developer;

--
-- Name: categoria_cat_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.categoria_cat_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categoria_cat_cod_seq OWNER TO developer;

--
-- Name: categoria_cat_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.categoria_cat_cod_seq OWNED BY public.categoria.cat_cod;


--
-- Name: cidade; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.cidade (
    cid_cod integer NOT NULL,
    cid_nome character varying(150),
    cid_estado character varying(2),
    cid_cod_extra character varying(255)
);


ALTER TABLE public.cidade OWNER TO developer;

--
-- Name: TABLE cidade; Type: COMMENT; Schema: public; Owner: developer
--

COMMENT ON TABLE public.cidade IS 'cadastro de cidades e seus estados';


--
-- Name: cidade_cid_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.cidade_cid_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cidade_cid_cod_seq OWNER TO developer;

--
-- Name: cidade_cid_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.cidade_cid_cod_seq OWNED BY public.cidade.cid_cod;


--
-- Name: empresa; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.empresa (
    emp_cod integer NOT NULL,
    emp_nome character varying(200),
    emp_cnpj character varying(100),
    emp_end_logradouro character varying(200),
    emp_end_nome character varying(200),
    emp_end_complemento character varying(255),
    emp_end_numero character varying(255),
    emp_end_bairro character varying(150),
    emp_end_cep character varying(9),
    emp_cidade_cod integer,
    emp_telefone character varying(255),
    emp_celular character varying(255),
    emp_email character varying(200),
    emp_site character varying(200),
    emp_criadoem timestamp without time zone,
    emp_criadopor_cod integer,
    emp_origem_cod integer,
    emp_atendente_cod integer,
    emp_servico_cod integer,
    emp_categoria_cod integer,
    emp_nivel_cod integer,
    emp_apelido_cod character varying(255),
    emp_razao_cod character varying(255),
    emp_ult_negocio_cod integer
);


ALTER TABLE public.empresa OWNER TO developer;

--
-- Name: TABLE empresa; Type: COMMENT; Schema: public; Owner: developer
--

COMMENT ON TABLE public.empresa IS 'registro de empresas';


--
-- Name: empresa_emp_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.empresa_emp_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.empresa_emp_cod_seq OWNER TO developer;

--
-- Name: empresa_emp_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.empresa_emp_cod_seq OWNED BY public.empresa.emp_cod;


--
-- Name: funcao; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.funcao (
    fun_cod integer NOT NULL,
    fun_nome character varying(100)
);


ALTER TABLE public.funcao OWNER TO developer;

--
-- Name: TABLE funcao; Type: COMMENT; Schema: public; Owner: developer
--

COMMENT ON TABLE public.funcao IS 'relação de funcoes usuarios dos usuarios';


--
-- Name: funcao_fun_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.funcao_fun_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.funcao_fun_cod_seq OWNER TO developer;

--
-- Name: funcao_fun_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.funcao_fun_cod_seq OWNED BY public.funcao.fun_cod;


--
-- Name: lista; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.lista (
    lis_cod integer NOT NULL,
    lis_nome character varying(100),
    lis_detalhes character varying(255),
    lis_criadoem timestamp without time zone,
    lis_criadopor_cod integer
);


ALTER TABLE public.lista OWNER TO developer;

--
-- Name: lista_lis_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.lista_lis_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lista_lis_cod_seq OWNER TO developer;

--
-- Name: lista_lis_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.lista_lis_cod_seq OWNED BY public.lista.lis_cod;


--
-- Name: negocio; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.negocio (
    neg_cod integer NOT NULL,
    neg_nome character varying(200),
    neg_datainicio date,
    neg_datafim date,
    neg_classe character varying(255),
    neg_criadoem timestamp without time zone,
    neg_criadopor_cod integer,
    neg_sta_cod integer,
    neg_eta_cod integer,
    neg_atendente_cod integer,
    neg_andcontato timestamp without time zone,
    neg_andenvioproposta timestamp without time zone,
    neg_andfollowup timestamp without time zone,
    neg_andfechamento timestamp without time zone,
    neg_andindefinida timestamp without time zone,
    neg_empresa_cod integer,
    neg_pessoa_cod integer,
    neg_honorario numeric(19,2),
    neg_origem_cod integer,
    neg_servico_cod integer,
    neg_categoria_cod integer,
    neg_nivel_cod integer,
    neg_descricao text,
    neg_motivoperda character varying(100),
    neg_detalhesperda text,
    neg_dataperda date,
    neg_datafinalizacao date,
    neg_prospeccao_cod integer
);


ALTER TABLE public.negocio OWNER TO developer;

--
-- Name: negocio_documento; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.negocio_documento (
    neg_doc_cod integer NOT NULL,
    neg_doc_nome character varying(255),
    neg_doc_usuario integer,
    neg_doc_data timestamp without time zone,
    neg_doc_url character varying(255),
    neg_doc_negocio_cod integer,
    neg_doc_descricao character varying(255)
);


ALTER TABLE public.negocio_documento OWNER TO developer;

--
-- Name: negocio_documento_neg_doc_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.negocio_documento_neg_doc_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.negocio_documento_neg_doc_cod_seq OWNER TO developer;

--
-- Name: negocio_documento_neg_doc_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.negocio_documento_neg_doc_cod_seq OWNED BY public.negocio_documento.neg_doc_cod;


--
-- Name: negocio_etapa; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.negocio_etapa (
    neg_eta_cod integer NOT NULL,
    neg_eta_nome character varying(100)
);


ALTER TABLE public.negocio_etapa OWNER TO developer;

--
-- Name: negocio_etapa_neg_eta_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.negocio_etapa_neg_eta_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.negocio_etapa_neg_eta_cod_seq OWNER TO developer;

--
-- Name: negocio_etapa_neg_eta_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.negocio_etapa_neg_eta_cod_seq OWNED BY public.negocio_etapa.neg_eta_cod;


--
-- Name: negocio_neg_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.negocio_neg_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.negocio_neg_cod_seq OWNER TO developer;

--
-- Name: negocio_neg_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.negocio_neg_cod_seq OWNED BY public.negocio.neg_cod;


--
-- Name: negocio_status; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.negocio_status (
    neg_sta_cod integer NOT NULL,
    neg_sta_nome character varying(100)
);


ALTER TABLE public.negocio_status OWNER TO developer;

--
-- Name: negocio_status_neg_sta_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.negocio_status_neg_sta_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.negocio_status_neg_sta_cod_seq OWNER TO developer;

--
-- Name: negocio_status_neg_sta_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.negocio_status_neg_sta_cod_seq OWNED BY public.negocio_status.neg_sta_cod;


--
-- Name: nivel; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.nivel (
    niv_cod integer NOT NULL,
    niv_nome character varying(100)
);


ALTER TABLE public.nivel OWNER TO developer;

--
-- Name: nivel_niv_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.nivel_niv_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nivel_niv_cod_seq OWNER TO developer;

--
-- Name: nivel_niv_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.nivel_niv_cod_seq OWNED BY public.nivel.niv_cod;


--
-- Name: origem; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.origem (
    ori_cod integer NOT NULL,
    ori_nome character varying(100)
);


ALTER TABLE public.origem OWNER TO developer;

--
-- Name: origem_ori_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.origem_ori_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.origem_ori_cod_seq OWNER TO developer;

--
-- Name: origem_ori_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.origem_ori_cod_seq OWNED BY public.origem.ori_cod;


--
-- Name: pessoa; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.pessoa (
    pes_cod integer NOT NULL,
    pes_nome character varying(200),
    pes_cpf character varying(11),
    pes_nasc character varying(10),
    pes_logradouro character varying(200),
    pes_end_nome character varying(200),
    pes_end_complemento character varying(255),
    pes_end_numero character varying(255),
    pes_end_bairro character varying(150),
    pes_end_cep character varying(9),
    pes_cidade_cod integer,
    pes_telefone character varying(255),
    pes_celular character varying(255),
    pes_email character varying(200),
    pes_site character varying(200),
    pes_criadoem timestamp without time zone,
    pes_criadopor_cod integer,
    pes_origem_cod integer,
    pes_atendente_cod integer,
    pes_servico_cod integer,
    pes_categoria_cod integer,
    pes_nivel_cod integer,
    pes_apelido_cod character varying(255),
    pes_razao_cod character varying(255),
    pes_ult_negocio_cod integer
);


ALTER TABLE public.pessoa OWNER TO developer;

--
-- Name: pessoa_pes_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.pessoa_pes_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pessoa_pes_cod_seq OWNER TO developer;

--
-- Name: pessoa_pes_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.pessoa_pes_cod_seq OWNED BY public.pessoa.pes_cod;


--
-- Name: pro_tipo_contato; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.pro_tipo_contato (
    pro_tipo_contato_cod integer NOT NULL,
    pro_tipo_contato_nome character varying(255)
);


ALTER TABLE public.pro_tipo_contato OWNER TO developer;

--
-- Name: pro_tipo_contato_pro_tipo_contato_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.pro_tipo_contato_pro_tipo_contato_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pro_tipo_contato_pro_tipo_contato_cod_seq OWNER TO developer;

--
-- Name: pro_tipo_contato_pro_tipo_contato_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.pro_tipo_contato_pro_tipo_contato_cod_seq OWNED BY public.pro_tipo_contato.pro_tipo_contato_cod;


--
-- Name: prospeccao; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.prospeccao (
    pro_cod integer NOT NULL,
    pro_nome character varying(255),
    pro_responsavel character varying(255),
    pro_departamento character varying(255),
    pro_endereco character varying(255),
    pro_telefone character varying(255),
    pro_celular character varying(255),
    pro_email character varying(200),
    pro_site character varying(200),
    pro_criadoem timestamp without time zone,
    pro_criadopor_cod integer,
    pro_origem_cod integer,
    pro_origem_detalhes text,
    pro_resumo text,
    pro_apresentacao text,
    pro_atendente_cod integer,
    pro_servico_cod integer,
    pro_convite_eventos integer,
    pro_material integer,
    pro_newsletter integer,
    pro_tipo_contato integer,
    pro_ult_negocio_cod integer
);


ALTER TABLE public.prospeccao OWNER TO developer;

--
-- Name: prospeccao_pro_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.prospeccao_pro_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prospeccao_pro_cod_seq OWNER TO developer;

--
-- Name: prospeccao_pro_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.prospeccao_pro_cod_seq OWNED BY public.prospeccao.pro_cod;


--
-- Name: prospeccao_rel_lista; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.prospeccao_rel_lista (
    lis_rel_cod integer NOT NULL,
    pro_rel_cod integer NOT NULL
);


ALTER TABLE public.prospeccao_rel_lista OWNER TO developer;

--
-- Name: servico; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.servico (
    ser_cod integer NOT NULL,
    ser_nome character varying(100)
);


ALTER TABLE public.servico OWNER TO developer;

--
-- Name: servico_agregado; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.servico_agregado (
    ser_agr_cod integer NOT NULL,
    ser_agr_nome character varying(100)
);


ALTER TABLE public.servico_agregado OWNER TO developer;

--
-- Name: servico_agregado_ser_agr_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.servico_agregado_ser_agr_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servico_agregado_ser_agr_cod_seq OWNER TO developer;

--
-- Name: servico_agregado_ser_agr_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.servico_agregado_ser_agr_cod_seq OWNED BY public.servico_agregado.ser_agr_cod;


--
-- Name: servico_contratado; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.servico_contratado (
    ser_con_cod integer NOT NULL,
    ser_con_valor numeric(19,2),
    ser_con_servicoagregado_cod integer,
    ser_con_negocio_cod integer
);


ALTER TABLE public.servico_contratado OWNER TO developer;

--
-- Name: servico_contratado_ser_con_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.servico_contratado_ser_con_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servico_contratado_ser_con_cod_seq OWNER TO developer;

--
-- Name: servico_contratado_ser_con_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.servico_contratado_ser_con_cod_seq OWNED BY public.servico_contratado.ser_con_cod;


--
-- Name: servico_ser_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.servico_ser_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servico_ser_cod_seq OWNER TO developer;

--
-- Name: servico_ser_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.servico_ser_cod_seq OWNED BY public.servico.ser_cod;


--
-- Name: tarefa; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.tarefa (
    tar_cod integer NOT NULL,
    tar_nome text,
    tar_dataevento timestamp without time zone,
    tar_classe character varying(100),
    tar_criadoem timestamp without time zone,
    tar_criadopor_cod integer,
    tar_tip_tar_cod integer,
    tar_atendente_cod integer,
    tar_pessoa_cod integer,
    tar_empresa_cod integer,
    tar_negocio_cod integer,
    tar_finalizado integer,
    tar_alertaenviado integer,
    tar_prospeccao_cod integer
);


ALTER TABLE public.tarefa OWNER TO developer;

--
-- Name: tarefa_tar_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.tarefa_tar_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tarefa_tar_cod_seq OWNER TO developer;

--
-- Name: tarefa_tar_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.tarefa_tar_cod_seq OWNED BY public.tarefa.tar_cod;


--
-- Name: tipo_tarefa; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.tipo_tarefa (
    tip_tar_cod integer NOT NULL,
    tip_tar_nome character varying(100)
);


ALTER TABLE public.tipo_tarefa OWNER TO developer;

--
-- Name: tipo_tarefa_tip_tar_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.tipo_tarefa_tip_tar_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_tarefa_tip_tar_cod_seq OWNER TO developer;

--
-- Name: tipo_tarefa_tip_tar_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.tipo_tarefa_tip_tar_cod_seq OWNED BY public.tipo_tarefa.tip_tar_cod;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.usuario (
    usu_cod integer NOT NULL,
    usu_login character varying(100),
    usu_nome character varying(255),
    usu_senha character varying(255),
    usu_email character varying(200),
    usu_criadoem timestamp without time zone,
    usu_criadopor_cod integer,
    usu_ultimoacesso timestamp without time zone,
    usu_totaltarefas integer,
    usu_totaltarefaspendentes integer,
    usu_totalempresas integer,
    usu_totalnegocios integer,
    usu_departamento_cod integer,
    usu_funcao_cod integer,
    usu_totalvendas numeric(19,2),
    usu_ativo integer
);


ALTER TABLE public.usuario OWNER TO developer;

--
-- Name: usuario_acesso; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.usuario_acesso (
    usu_ace_cod integer NOT NULL,
    usu_ace_data timestamp without time zone,
    usu_ace_usuario_id integer,
    usu_ace_maquina character varying(100)
);


ALTER TABLE public.usuario_acesso OWNER TO developer;

--
-- Name: usuario_acesso_usu_ace_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.usuario_acesso_usu_ace_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_acesso_usu_ace_cod_seq OWNER TO developer;

--
-- Name: usuario_acesso_usu_ace_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.usuario_acesso_usu_ace_cod_seq OWNED BY public.usuario_acesso.usu_ace_cod;


--
-- Name: usuario_departamento; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.usuario_departamento (
    usu_dep_cod integer NOT NULL,
    usu_dep_nome character varying(100)
);


ALTER TABLE public.usuario_departamento OWNER TO developer;

--
-- Name: usuario_departamento_usu_dep_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.usuario_departamento_usu_dep_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_departamento_usu_dep_cod_seq OWNER TO developer;

--
-- Name: usuario_departamento_usu_dep_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.usuario_departamento_usu_dep_cod_seq OWNED BY public.usuario_departamento.usu_dep_cod;


--
-- Name: usuario_log; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.usuario_log (
    usu_log_cod integer NOT NULL,
    usu_log_data timestamp without time zone,
    usu_log_usuario_id integer,
    usu_log_menu character varying(50),
    usu_log_acao character varying(50),
    usu_log_descricao character varying(255),
    usu_log_maquina character varying(100)
);


ALTER TABLE public.usuario_log OWNER TO developer;

--
-- Name: usuario_log_usu_log_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.usuario_log_usu_log_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_log_usu_log_cod_seq OWNER TO developer;

--
-- Name: usuario_log_usu_log_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.usuario_log_usu_log_cod_seq OWNED BY public.usuario_log.usu_log_cod;


--
-- Name: usuario_usu_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.usuario_usu_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_usu_cod_seq OWNER TO developer;

--
-- Name: usuario_usu_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.usuario_usu_cod_seq OWNED BY public.usuario.usu_cod;


--
-- Name: versao_app; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.versao_app (
    id integer NOT NULL,
    versao character varying(100) NOT NULL,
    detalhes text,
    historico timestamp without time zone NOT NULL
);


ALTER TABLE public.versao_app OWNER TO developer;

--
-- Name: versao_app_id_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.versao_app_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versao_app_id_seq OWNER TO developer;

--
-- Name: versao_app_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.versao_app_id_seq OWNED BY public.versao_app.id;


--
-- Name: versao_db; Type: TABLE; Schema: public; Owner: developer
--

CREATE TABLE public.versao_db (
    ver_cod integer NOT NULL,
    ver_nome character varying(100),
    ver_detalhes character varying(255),
    ver_data date
);


ALTER TABLE public.versao_db OWNER TO developer;

--
-- Name: versao_db_ver_cod_seq; Type: SEQUENCE; Schema: public; Owner: developer
--

CREATE SEQUENCE public.versao_db_ver_cod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.versao_db_ver_cod_seq OWNER TO developer;

--
-- Name: versao_db_ver_cod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: developer
--

ALTER SEQUENCE public.versao_db_ver_cod_seq OWNED BY public.versao_db.ver_cod;


--
-- Name: categoria cat_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.categoria ALTER COLUMN cat_cod SET DEFAULT nextval('public.categoria_cat_cod_seq'::regclass);


--
-- Name: cidade cid_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.cidade ALTER COLUMN cid_cod SET DEFAULT nextval('public.cidade_cid_cod_seq'::regclass);


--
-- Name: empresa emp_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.empresa ALTER COLUMN emp_cod SET DEFAULT nextval('public.empresa_emp_cod_seq'::regclass);


--
-- Name: funcao fun_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.funcao ALTER COLUMN fun_cod SET DEFAULT nextval('public.funcao_fun_cod_seq'::regclass);


--
-- Name: lista lis_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.lista ALTER COLUMN lis_cod SET DEFAULT nextval('public.lista_lis_cod_seq'::regclass);


--
-- Name: negocio neg_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.negocio ALTER COLUMN neg_cod SET DEFAULT nextval('public.negocio_neg_cod_seq'::regclass);


--
-- Name: negocio_documento neg_doc_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.negocio_documento ALTER COLUMN neg_doc_cod SET DEFAULT nextval('public.negocio_documento_neg_doc_cod_seq'::regclass);


--
-- Name: negocio_etapa neg_eta_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.negocio_etapa ALTER COLUMN neg_eta_cod SET DEFAULT nextval('public.negocio_etapa_neg_eta_cod_seq'::regclass);


--
-- Name: negocio_status neg_sta_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.negocio_status ALTER COLUMN neg_sta_cod SET DEFAULT nextval('public.negocio_status_neg_sta_cod_seq'::regclass);


--
-- Name: nivel niv_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.nivel ALTER COLUMN niv_cod SET DEFAULT nextval('public.nivel_niv_cod_seq'::regclass);


--
-- Name: origem ori_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.origem ALTER COLUMN ori_cod SET DEFAULT nextval('public.origem_ori_cod_seq'::regclass);


--
-- Name: pessoa pes_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.pessoa ALTER COLUMN pes_cod SET DEFAULT nextval('public.pessoa_pes_cod_seq'::regclass);


--
-- Name: pro_tipo_contato pro_tipo_contato_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.pro_tipo_contato ALTER COLUMN pro_tipo_contato_cod SET DEFAULT nextval('public.pro_tipo_contato_pro_tipo_contato_cod_seq'::regclass);


--
-- Name: prospeccao pro_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.prospeccao ALTER COLUMN pro_cod SET DEFAULT nextval('public.prospeccao_pro_cod_seq'::regclass);


--
-- Name: servico ser_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.servico ALTER COLUMN ser_cod SET DEFAULT nextval('public.servico_ser_cod_seq'::regclass);


--
-- Name: servico_agregado ser_agr_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.servico_agregado ALTER COLUMN ser_agr_cod SET DEFAULT nextval('public.servico_agregado_ser_agr_cod_seq'::regclass);


--
-- Name: servico_contratado ser_con_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.servico_contratado ALTER COLUMN ser_con_cod SET DEFAULT nextval('public.servico_contratado_ser_con_cod_seq'::regclass);


--
-- Name: tarefa tar_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.tarefa ALTER COLUMN tar_cod SET DEFAULT nextval('public.tarefa_tar_cod_seq'::regclass);


--
-- Name: tipo_tarefa tip_tar_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.tipo_tarefa ALTER COLUMN tip_tar_cod SET DEFAULT nextval('public.tipo_tarefa_tip_tar_cod_seq'::regclass);


--
-- Name: usuario usu_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.usuario ALTER COLUMN usu_cod SET DEFAULT nextval('public.usuario_usu_cod_seq'::regclass);


--
-- Name: usuario_acesso usu_ace_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.usuario_acesso ALTER COLUMN usu_ace_cod SET DEFAULT nextval('public.usuario_acesso_usu_ace_cod_seq'::regclass);


--
-- Name: usuario_departamento usu_dep_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.usuario_departamento ALTER COLUMN usu_dep_cod SET DEFAULT nextval('public.usuario_departamento_usu_dep_cod_seq'::regclass);


--
-- Name: usuario_log usu_log_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.usuario_log ALTER COLUMN usu_log_cod SET DEFAULT nextval('public.usuario_log_usu_log_cod_seq'::regclass);


--
-- Name: versao_app id; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.versao_app ALTER COLUMN id SET DEFAULT nextval('public.versao_app_id_seq'::regclass);


--
-- Name: versao_db ver_cod; Type: DEFAULT; Schema: public; Owner: developer
--

ALTER TABLE ONLY public.versao_db ALTER COLUMN ver_cod SET DEFAULT nextval('public.versao_db_ver_cod_seq'::regclass);


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.categoria (cat_cod, cat_nome) FROM stdin;
1	Indefinida
4	Concorrente
5	Fornecedor
6	Parceiro
2	Novo Cliente
3	Ex-Cliente
7	Cliente
\.


--
-- Name: categoria_cat_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.categoria_cat_cod_seq', 7, true);


--
-- Data for Name: cidade; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.cidade (cid_cod, cid_nome, cid_estado, cid_cod_extra) FROM stdin;
1	Alta Floresta D'Oeste	RO	1100015
2	Alto Alegre dos Parecis	RO	1100379
3	Alto Paraíso	RO	1100403
4	Alvorada D'Oeste	RO	1100346
5	Ariquemes	RO	1100023
6	Buritis	RO	1100452
7	Cabixi	RO	1100031
8	Cacaulândia	RO	1100601
9	Cacoal	RO	1100049
10	Campo Novo de Rondônia	RO	1100700
11	Candeias do Jamari	RO	1100809
12	Castanheiras	RO	1100908
13	Cerejeiras	RO	1100056
14	Chupinguaia	RO	1100924
15	Colorado do Oeste	RO	1100064
16	Corumbiara	RO	1100072
17	Costa Marques	RO	1100080
18	Cujubim	RO	1100940
19	Espigão D'Oeste	RO	1100098
20	Governador Jorge Teixeira	RO	1101005
21	Guajará-Mirim	RO	1100106
22	Itapuã do Oeste	RO	1101104
23	Jaru	RO	1100114
24	Ji-Paraná	RO	1100122
25	Machadinho D'Oeste	RO	1100130
26	Ministro Andreazza	RO	1101203
27	Mirante da Serra	RO	1101302
28	Monte Negro	RO	1101401
29	Nova Brasilândia D'Oeste	RO	1100148
30	Nova Mamoré	RO	1100338
31	Nova União	RO	1101435
32	Novo Horizonte do Oeste	RO	1100502
33	Ouro Preto do Oeste	RO	1100155
34	Parecis	RO	1101450
35	Pimenta Bueno	RO	1100189
36	Pimenteiras do Oeste	RO	1101468
37	Porto Velho	RO	1100205
38	Presidente Médici	RO	1100254
39	Primavera de Rondônia	RO	1101476
40	Rio Crespo	RO	1100262
41	Rolim de Moura	RO	1100288
42	Santa Luzia D'Oeste	RO	1100296
43	São Felipe D'Oeste	RO	1101484
44	São Francisco do Guaporé	RO	1101492
45	São Miguel do Guaporé	RO	1100320
46	Seringueiras	RO	1101500
47	Teixeirópolis	RO	1101559
48	Theobroma	RO	1101609
49	Urupá	RO	1101708
50	Vale do Anari	RO	1101757
51	Vale do Paraíso	RO	1101807
52	Vilhena	RO	1100304
53	Acrelândia	AC	1200013
54	Assis Brasil	AC	1200054
55	Brasiléia	AC	1200104
56	Bujari	AC	1200138
57	Capixaba	AC	1200179
58	Cruzeiro do Sul	AC	1200203
59	Epitaciolândia	AC	1200252
60	Feijó	AC	1200302
61	Jordão	AC	1200328
62	Mâncio Lima	AC	1200336
63	Manoel Urbano	AC	1200344
64	Marechal Thaumaturgo	AC	1200351
65	Plácido de Castro	AC	1200385
66	Porto Acre	AC	1200807
67	Porto Walter	AC	1200393
68	Rio Branco	AC	1200401
69	Rodrigues Alves	AC	1200427
70	Santa Rosa do Purus	AC	1200435
71	Sena Madureira	AC	1200500
72	Senador Guiomard	AC	1200450
73	Tarauacá	AC	1200609
74	Xapuri	AC	1200708
75	Alvarães	AM	1300029
76	Amaturá	AM	1300060
77	Anamã	AM	1300086
78	Anori	AM	1300102
79	Apuí	AM	1300144
80	Atalaia do Norte	AM	1300201
81	Autazes	AM	1300300
82	Barcelos	AM	1300409
83	Barreirinha	AM	1300508
84	Benjamin Constant	AM	1300607
85	Beruri	AM	1300631
86	Boa Vista do Ramos	AM	1300680
87	Boca do Acre	AM	1300706
88	Borba	AM	1300805
89	Caapiranga	AM	1300839
90	Canutama	AM	1300904
91	Carauari	AM	1301001
92	Careiro	AM	1301100
93	Careiro da Várzea	AM	1301159
94	Coari	AM	1301209
95	Codajás	AM	1301308
96	Eirunepé	AM	1301407
97	Envira	AM	1301506
98	Fonte Boa	AM	1301605
99	Guajará	AM	1301654
100	Humaitá	AM	1301704
101	Ipixuna	AM	1301803
102	Iranduba	AM	1301852
103	Itacoatiara	AM	1301902
104	Itamarati	AM	1301951
105	Itapiranga	AM	1302009
106	Japurá	AM	1302108
107	Juruá	AM	1302207
108	Jutaí	AM	1302306
109	Lábrea	AM	1302405
110	Manacapuru	AM	1302504
111	Manaquiri	AM	1302553
112	Manaus	AM	1302603
113	Manicoré	AM	1302702
114	Maraã	AM	1302801
115	Maués	AM	1302900
116	Nhamundá	AM	1303007
117	Nova Olinda do Norte	AM	1303106
118	Novo Airão	AM	1303205
119	Novo Aripuanã	AM	1303304
120	Parintins	AM	1303403
121	Pauini	AM	1303502
122	Presidente Figueiredo	AM	1303536
123	Rio Preto da Eva	AM	1303569
124	Santa Isabel do Rio Negro	AM	1303601
125	Santo Antônio do Içá	AM	1303700
126	São Gabriel da Cachoeira	AM	1303809
127	São Paulo de Olivença	AM	1303908
128	São Sebastião do Uatumã	AM	1303957
129	Silves	AM	1304005
130	Tabatinga	AM	1304062
131	Tapauá	AM	1304104
132	Tefé	AM	1304203
133	Tonantins	AM	1304237
134	Uarini	AM	1304260
135	Urucará	AM	1304302
136	Urucurituba	AM	1304401
137	Alto Alegre	RR	1400050
138	Amajari	RR	1400027
139	Boa Vista	RR	1400100
140	Bonfim	RR	1400159
141	Cantá	RR	1400175
142	Caracaraí	RR	1400209
143	Caroebe	RR	1400233
144	Iracema	RR	1400282
145	Mucajaí	RR	1400308
146	Normandia	RR	1400407
147	Pacaraima	RR	1400456
148	Rorainópolis	RR	1400472
149	São João da Baliza	RR	1400506
150	São Luiz	RR	1400605
151	Uiramutã	RR	1400704
152	Abaetetuba	PA	1500107
153	Abel Figueiredo	PA	1500131
154	Acará	PA	1500206
155	Afuá	PA	1500305
156	Água Azul do Norte	PA	1500347
157	Alenquer	PA	1500404
158	Almeirim	PA	1500503
159	Altamira	PA	1500602
160	Anajás	PA	1500701
161	Ananindeua	PA	1500800
162	Anapu	PA	1500859
163	Augusto Corrêa	PA	1500909
164	Aurora do Pará	PA	1500958
165	Aveiro	PA	1501006
166	Bagre	PA	1501105
167	Baião	PA	1501204
168	Bannach	PA	1501253
169	Barcarena	PA	1501303
170	Belém	PA	1501402
171	Belterra	PA	1501451
172	Benevides	PA	1501501
173	Bom Jesus do Tocantins	PA	1501576
174	Bonito	PA	1501600
175	Bragança	PA	1501709
176	Brasil Novo	PA	1501725
177	Brejo Grande do Araguaia	PA	1501758
178	Breu Branco	PA	1501782
179	Breves	PA	1501808
180	Bujaru	PA	1501907
181	Cachoeira do Arari	PA	1502004
182	Cachoeira do Piriá	PA	1501956
183	Cametá	PA	1502103
184	Canaã dos Carajás	PA	1502152
185	Capanema	PA	1502202
186	Capitão Poço	PA	1502301
187	Castanhal	PA	1502400
188	Chaves	PA	1502509
189	Colares	PA	1502608
190	Conceição do Araguaia	PA	1502707
191	Concórdia do Pará	PA	1502756
192	Cumaru do Norte	PA	1502764
193	Curionópolis	PA	1502772
194	Curralinho	PA	1502806
195	Curuá	PA	1502855
196	Curuçá	PA	1502905
197	Dom Eliseu	PA	1502939
198	Eldorado dos Carajás	PA	1502954
199	Faro	PA	1503002
200	Floresta do Araguaia	PA	1503044
201	Garrafão do Norte	PA	1503077
202	Goianésia do Pará	PA	1503093
203	Gurupá	PA	1503101
204	Igarapé-Açu	PA	1503200
205	Igarapé-Miri	PA	1503309
206	Inhangapi	PA	1503408
207	Ipixuna do Pará	PA	1503457
208	Irituia	PA	1503507
209	Itaituba	PA	1503606
210	Itupiranga	PA	1503705
211	Jacareacanga	PA	1503754
212	Jacundá	PA	1503804
213	Juruti	PA	1503903
214	Limoeiro do Ajuru	PA	1504000
215	Mãe do Rio	PA	1504059
216	Magalhães Barata	PA	1504109
217	Marabá	PA	1504208
218	Maracanã	PA	1504307
219	Marapanim	PA	1504406
220	Marituba	PA	1504422
221	Medicilândia	PA	1504455
222	Melgaço	PA	1504505
223	Mocajuba	PA	1504604
224	Moju	PA	1504703
225	Monte Alegre	PA	1504802
226	Muaná	PA	1504901
227	Nova Esperança do Piriá	PA	1504950
228	Nova Ipixuna	PA	1504976
229	Nova Timboteua	PA	1505007
230	Novo Progresso	PA	1505031
231	Novo Repartimento	PA	1505064
232	Óbidos	PA	1505106
233	Oeiras do Pará	PA	1505205
234	Oriximiná	PA	1505304
235	Ourém	PA	1505403
236	Ourilândia do Norte	PA	1505437
237	Pacajá	PA	1505486
238	Palestina do Pará	PA	1505494
239	Paragominas	PA	1505502
240	Parauapebas	PA	1505536
241	Pau D'Arco	PA	1505551
242	Peixe-Boi	PA	1505601
243	Piçarra	PA	1505635
244	Placas	PA	1505650
245	Ponta de Pedras	PA	1505700
246	Portel	PA	1505809
247	Porto de Moz	PA	1505908
248	Prainha	PA	1506005
249	Primavera	PA	1506104
250	Quatipuru	PA	1506112
251	Redenção	PA	1506138
252	Rio Maria	PA	1506161
253	Rondon do Pará	PA	1506187
254	Rurópolis	PA	1506195
255	Salinópolis	PA	1506203
256	Salvaterra	PA	1506302
257	Santa Bárbara do Pará	PA	1506351
258	Santa Cruz do Arari	PA	1506401
259	Santa Isabel do Pará	PA	1506500
260	Santa Luzia do Pará	PA	1506559
261	Santa Maria das Barreiras	PA	1506583
262	Santa Maria do Pará	PA	1506609
263	Santana do Araguaia	PA	1506708
264	Santarém	PA	1506807
265	Santarém Novo	PA	1506906
266	Santo Antônio do Tauá	PA	1507003
267	São Caetano de Odivelas	PA	1507102
268	São Domingos do Araguaia	PA	1507151
269	São Domingos do Capim	PA	1507201
270	São Félix do Xingu	PA	1507300
271	São Francisco do Pará	PA	1507409
272	São Geraldo do Araguaia	PA	1507458
273	São João da Ponta	PA	1507466
274	São João de Pirabas	PA	1507474
275	São João do Araguaia	PA	1507508
276	São Miguel do Guamá	PA	1507607
277	São Sebastião da Boa Vista	PA	1507706
278	Sapucaia	PA	1507755
279	Senador José Porfírio	PA	1507805
280	Soure	PA	1507904
281	Tailândia	PA	1507953
282	Terra Alta	PA	1507961
283	Terra Santa	PA	1507979
284	Tomé-Açu	PA	1508001
285	Tracuateua	PA	1508035
286	Trairão	PA	1508050
287	Tucumã	PA	1508084
288	Tucuruí	PA	1508100
289	Ulianópolis	PA	1508126
290	Uruará	PA	1508159
291	Vigia	PA	1508209
292	Viseu	PA	1508308
293	Vitória do Xingu	PA	1508357
294	Xinguara	PA	1508407
295	Amapá	AP	1600105
296	Calçoene	AP	1600204
297	Cutias	AP	1600212
298	Ferreira Gomes	AP	1600238
299	Itaubal	AP	1600253
300	Laranjal do Jari	AP	1600279
301	Macapá	AP	1600303
302	Mazagão	AP	1600402
303	Oiapoque	AP	1600501
304	Pedra Branca do Amapari	AP	1600154
305	Porto Grande	AP	1600535
306	Pracuúba	AP	1600550
307	Santana	AP	1600600
308	Serra do Navio	AP	1600055
309	Tartarugalzinho	AP	1600709
310	Vitória do Jari	AP	1600808
311	Abreulândia	TO	1700251
312	Aguiarnópolis	TO	1700301
313	Aliança do Tocantins	TO	1700350
314	Almas	TO	1700400
315	Alvorada	TO	1700707
316	Ananás	TO	1701002
317	Angico	TO	1701051
318	Aparecida do Rio Negro	TO	1701101
319	Aragominas	TO	1701309
320	Araguacema	TO	1701903
321	Araguaçu	TO	1702000
322	Araguaína	TO	1702109
323	Araguanã	TO	1702158
324	Araguatins	TO	1702208
325	Arapoema	TO	1702307
326	Arraias	TO	1702406
327	Augustinópolis	TO	1702554
328	Aurora do Tocantins	TO	1702703
329	Axixá do Tocantins	TO	1702901
330	Babaçulândia	TO	1703008
331	Bandeirantes do Tocantins	TO	1703057
332	Barra do Ouro	TO	1703073
333	Barrolândia	TO	1703107
334	Bernardo Sayão	TO	1703206
335	Bom Jesus do Tocantins	TO	1703305
336	Brasilândia do Tocantins	TO	1703602
337	Brejinho de Nazaré	TO	1703701
338	Buriti do Tocantins	TO	1703800
339	Cachoeirinha	TO	1703826
340	Campos Lindos	TO	1703842
341	Cariri do Tocantins	TO	1703867
342	Carmolândia	TO	1703883
343	Carrasco Bonito	TO	1703891
344	Caseara	TO	1703909
345	Centenário	TO	1704105
346	Chapada da Natividade	TO	1705102
347	Chapada de Areia	TO	1704600
348	Colinas do Tocantins	TO	1705508
349	Colméia	TO	1716703
350	Combinado	TO	1705557
351	Conceição do Tocantins	TO	1705607
352	Couto Magalhães	TO	1706001
353	Cristalândia	TO	1706100
354	Crixás do Tocantins	TO	1706258
355	Darcinópolis	TO	1706506
356	Dianópolis	TO	1707009
357	Divinópolis do Tocantins	TO	1707108
358	Dois Irmãos do Tocantins	TO	1707207
359	Dueré	TO	1707306
360	Esperantina	TO	1707405
361	Fátima	TO	1707553
362	Figueirópolis	TO	1707652
363	Filadélfia	TO	1707702
364	Formoso do Araguaia	TO	1708205
365	Fortaleza do Tabocão	TO	1708254
366	Goianorte	TO	1708304
367	Goiatins	TO	1709005
368	Guaraí	TO	1709302
369	Gurupi	TO	1709500
370	Ipueiras	TO	1709807
371	Itacajá	TO	1710508
372	Itaguatins	TO	1710706
373	Itapiratins	TO	1710904
374	Itaporã do Tocantins	TO	1711100
375	Jaú do Tocantins	TO	1711506
376	Juarina	TO	1711803
377	Lagoa da Confusão	TO	1711902
378	Lagoa do Tocantins	TO	1711951
379	Lajeado	TO	1712009
380	Lavandeira	TO	1712157
381	Lizarda	TO	1712405
382	Luzinópolis	TO	1712454
383	Marianópolis do Tocantins	TO	1712504
384	Mateiros	TO	1712702
385	Maurilândia do Tocantins	TO	1712801
386	Miracema do Tocantins	TO	1713205
387	Miranorte	TO	1713304
388	Monte do Carmo	TO	1713601
389	Monte Santo do Tocantins	TO	1713700
390	Muricilândia	TO	1713957
391	Natividade	TO	1714203
392	Nazaré	TO	1714302
393	Nova Olinda	TO	1714880
394	Nova Rosalândia	TO	1715002
395	Novo Acordo	TO	1715101
396	Novo Alegre	TO	1715150
397	Novo Jardim	TO	1715259
398	Oliveira de Fátima	TO	1715507
399	Palmas	TO	1721000
400	Palmeirante	TO	1715705
401	Palmeiras do Tocantins	TO	1713809
402	Palmeirópolis	TO	1715754
403	Paraíso do Tocantins	TO	1716109
404	Paranã	TO	1716208
405	Pau D'Arco	TO	1716307
406	Pedro Afonso	TO	1716505
407	Peixe	TO	1716604
408	Pequizeiro	TO	1716653
409	Pindorama do Tocantins	TO	1717008
410	Piraquê	TO	1717206
411	Pium	TO	1717503
412	Ponte Alta do Bom Jesus	TO	1717800
413	Ponte Alta do Tocantins	TO	1717909
414	Porto Alegre do Tocantins	TO	1718006
415	Porto Nacional	TO	1718204
416	Praia Norte	TO	1718303
417	Presidente Kennedy	TO	1718402
418	Pugmil	TO	1718451
419	Recursolândia	TO	1718501
420	Riachinho	TO	1718550
421	Rio da Conceição	TO	1718659
422	Rio dos Bois	TO	1718709
423	Rio Sono	TO	1718758
424	Sampaio	TO	1718808
425	Sandolândia	TO	1718840
426	Santa Fé do Araguaia	TO	1718865
427	Santa Maria do Tocantins	TO	1718881
428	Santa Rita do Tocantins	TO	1718899
429	Santa Rosa do Tocantins	TO	1718907
430	Santa Tereza do Tocantins	TO	1719004
431	Santa Terezinha do Tocantins	TO	1720002
432	São Bento do Tocantins	TO	1720101
433	São Félix do Tocantins	TO	1720150
434	São Miguel do Tocantins	TO	1720200
435	São Salvador do Tocantins	TO	1720259
436	São Sebastião do Tocantins	TO	1720309
437	São Valério	TO	1720499
438	Silvanópolis	TO	1720655
439	Sítio Novo do Tocantins	TO	1720804
440	Sucupira	TO	1720853
441	Taguatinga	TO	1720903
442	Taipas do Tocantins	TO	1720937
443	Talismã	TO	1720978
444	Tocantínia	TO	1721109
445	Tocantinópolis	TO	1721208
446	Tupirama	TO	1721257
447	Tupiratins	TO	1721307
448	Wanderlândia	TO	1722081
449	Xambioá	TO	1722107
450	Açailândia	MA	2100055
451	Afonso Cunha	MA	2100105
452	Água Doce do Maranhão	MA	2100154
453	Alcântara	MA	2100204
454	Aldeias Altas	MA	2100303
455	Altamira do Maranhão	MA	2100402
456	Alto Alegre do Maranhão	MA	2100436
457	Alto Alegre do Pindaré	MA	2100477
458	Alto Parnaíba	MA	2100501
459	Amapá do Maranhão	MA	2100550
460	Amarante do Maranhão	MA	2100600
461	Anajatuba	MA	2100709
462	Anapurus	MA	2100808
463	Apicum-Açu	MA	2100832
464	Araguanã	MA	2100873
465	Araioses	MA	2100907
466	Arame	MA	2100956
467	Arari	MA	2101004
468	Axixá	MA	2101103
469	Bacabal	MA	2101202
470	Bacabeira	MA	2101251
471	Bacuri	MA	2101301
472	Bacurituba	MA	2101350
473	Balsas	MA	2101400
474	Barão de Grajaú	MA	2101509
475	Barra do Corda	MA	2101608
476	Barreirinhas	MA	2101707
477	Bela Vista do Maranhão	MA	2101772
478	Belágua	MA	2101731
479	Benedito Leite	MA	2101806
480	Bequimão	MA	2101905
481	Bernardo do Mearim	MA	2101939
482	Boa Vista do Gurupi	MA	2101970
483	Bom Jardim	MA	2102002
484	Bom Jesus das Selvas	MA	2102036
485	Bom Lugar	MA	2102077
486	Brejo	MA	2102101
487	Brejo de Areia	MA	2102150
488	Buriti	MA	2102200
489	Buriti Bravo	MA	2102309
490	Buriticupu	MA	2102325
491	Buritirana	MA	2102358
492	Cachoeira Grande	MA	2102374
493	Cajapió	MA	2102408
494	Cajari	MA	2102507
495	Campestre do Maranhão	MA	2102556
496	Cândido Mendes	MA	2102606
497	Cantanhede	MA	2102705
498	Capinzal do Norte	MA	2102754
499	Carolina	MA	2102804
500	Carutapera	MA	2102903
501	Caxias	MA	2103000
502	Cedral	MA	2103109
503	Central do Maranhão	MA	2103125
504	Centro do Guilherme	MA	2103158
505	Centro Novo do Maranhão	MA	2103174
506	Chapadinha	MA	2103208
507	Cidelândia	MA	2103257
508	Codó	MA	2103307
509	Coelho Neto	MA	2103406
510	Colinas	MA	2103505
511	Conceição do Lago-Açu	MA	2103554
512	Coroatá	MA	2103604
513	Cururupu	MA	2103703
514	Davinópolis	MA	2103752
515	Dom Pedro	MA	2103802
516	Duque Bacelar	MA	2103901
517	Esperantinópolis	MA	2104008
518	Estreito	MA	2104057
519	Feira Nova do Maranhão	MA	2104073
520	Fernando Falcão	MA	2104081
521	Formosa da Serra Negra	MA	2104099
522	Fortaleza dos Nogueiras	MA	2104107
523	Fortuna	MA	2104206
524	Godofredo Viana	MA	2104305
525	Gonçalves Dias	MA	2104404
526	Governador Archer	MA	2104503
527	Governador Edison Lobão	MA	2104552
528	Governador Eugênio Barros	MA	2104602
529	Governador Luiz Rocha	MA	2104628
530	Governador Newton Bello	MA	2104651
531	Governador Nunes Freire	MA	2104677
532	Graça Aranha	MA	2104701
533	Grajaú	MA	2104800
534	Guimarães	MA	2104909
535	Humberto de Campos	MA	2105005
536	Icatu	MA	2105104
537	Igarapé do Meio	MA	2105153
538	Igarapé Grande	MA	2105203
539	Imperatriz	MA	2105302
540	Itaipava do Grajaú	MA	2105351
541	Itapecuru Mirim	MA	2105401
542	Itinga do Maranhão	MA	2105427
543	Jatobá	MA	2105450
544	Jenipapo dos Vieiras	MA	2105476
545	João Lisboa	MA	2105500
546	Joselândia	MA	2105609
547	Junco do Maranhão	MA	2105658
548	Lago da Pedra	MA	2105708
549	Lago do Junco	MA	2105807
550	Lago dos Rodrigues	MA	2105948
551	Lago Verde	MA	2105906
552	Lagoa do Mato	MA	2105922
553	Lagoa Grande do Maranhão	MA	2105963
554	Lajeado Novo	MA	2105989
555	Lima Campos	MA	2106003
556	Loreto	MA	2106102
557	Luís Domingues	MA	2106201
558	Magalhães de Almeida	MA	2106300
559	Maracaçumé	MA	2106326
560	Marajá do Sena	MA	2106359
561	Maranhãozinho	MA	2106375
562	Mata Roma	MA	2106409
563	Matinha	MA	2106508
564	Matões	MA	2106607
565	Matões do Norte	MA	2106631
566	Milagres do Maranhão	MA	2106672
567	Mirador	MA	2106706
568	Miranda do Norte	MA	2106755
569	Mirinzal	MA	2106805
570	Monção	MA	2106904
571	Montes Altos	MA	2107001
572	Morros	MA	2107100
573	Nina Rodrigues	MA	2107209
574	Nova Colinas	MA	2107258
575	Nova Iorque	MA	2107308
576	Nova Olinda do Maranhão	MA	2107357
577	Olho d'Água das Cunhãs	MA	2107407
578	Olinda Nova do Maranhão	MA	2107456
579	Paço do Lumiar	MA	2107506
580	Palmeirândia	MA	2107605
581	Paraibano	MA	2107704
582	Parnarama	MA	2107803
583	Passagem Franca	MA	2107902
584	Pastos Bons	MA	2108009
585	Paulino Neves	MA	2108058
586	Paulo Ramos	MA	2108108
587	Pedreiras	MA	2108207
588	Pedro do Rosário	MA	2108256
589	Penalva	MA	2108306
590	Peri Mirim	MA	2108405
591	Peritoró	MA	2108454
592	Pindaré-Mirim	MA	2108504
593	Pinheiro	MA	2108603
594	Pio XII	MA	2108702
595	Pirapemas	MA	2108801
596	Poção de Pedras	MA	2108900
597	Porto Franco	MA	2109007
598	Porto Rico do Maranhão	MA	2109056
599	Presidente Dutra	MA	2109106
600	Presidente Juscelino	MA	2109205
601	Presidente Médici	MA	2109239
602	Presidente Sarney	MA	2109270
603	Presidente Vargas	MA	2109304
604	Primeira Cruz	MA	2109403
605	Raposa	MA	2109452
606	Riachão	MA	2109502
607	Ribamar Fiquene	MA	2109551
608	Rosário	MA	2109601
609	Sambaíba	MA	2109700
610	Santa Filomena do Maranhão	MA	2109759
611	Santa Helena	MA	2109809
612	Santa Inês	MA	2109908
613	Santa Luzia	MA	2110005
614	Santa Luzia do Paruá	MA	2110039
615	Santa Quitéria do Maranhão	MA	2110104
616	Santa Rita	MA	2110203
617	Santana do Maranhão	MA	2110237
618	Santo Amaro do Maranhão	MA	2110278
619	Santo Antônio dos Lopes	MA	2110302
620	São Benedito do Rio Preto	MA	2110401
621	São Bento	MA	2110500
622	São Bernardo	MA	2110609
623	São Domingos do Azeitão	MA	2110658
624	São Domingos do Maranhão	MA	2110708
625	São Félix de Balsas	MA	2110807
626	São Francisco do Brejão	MA	2110856
627	São Francisco do Maranhão	MA	2110906
628	São João Batista	MA	2111003
629	São João do Carú	MA	2111029
630	São João do Paraíso	MA	2111052
631	São João do Soter	MA	2111078
632	São João dos Patos	MA	2111102
633	São José de Ribamar	MA	2111201
634	São José dos Basílios	MA	2111250
635	São Luís	MA	2111300
636	São Luís Gonzaga do Maranhão	MA	2111409
637	São Mateus do Maranhão	MA	2111508
638	São Pedro da Água Branca	MA	2111532
639	São Pedro dos Crentes	MA	2111573
640	São Raimundo das Mangabeiras	MA	2111607
641	São Raimundo do Doca Bezerra	MA	2111631
642	São Roberto	MA	2111672
643	São Vicente Ferrer	MA	2111706
644	Satubinha	MA	2111722
645	Senador Alexandre Costa	MA	2111748
646	Senador La Rocque	MA	2111763
647	Serrano do Maranhão	MA	2111789
648	Sítio Novo	MA	2111805
649	Sucupira do Norte	MA	2111904
650	Sucupira do Riachão	MA	2111953
651	Tasso Fragoso	MA	2112001
652	Timbiras	MA	2112100
653	Timon	MA	2112209
654	Trizidela do Vale	MA	2112233
655	Tufilândia	MA	2112274
656	Tuntum	MA	2112308
657	Turiaçu	MA	2112407
658	Turilândia	MA	2112456
659	Tutóia	MA	2112506
660	Urbano Santos	MA	2112605
661	Vargem Grande	MA	2112704
662	Viana	MA	2112803
663	Vila Nova dos Martírios	MA	2112852
664	Vitória do Mearim	MA	2112902
665	Vitorino Freire	MA	2113009
666	Zé Doca	MA	2114007
667	Acauã	PI	2200053
668	Agricolândia	PI	2200103
669	Água Branca	PI	2200202
670	Alagoinha do Piauí	PI	2200251
671	Alegrete do Piauí	PI	2200277
672	Alto Longá	PI	2200301
673	Altos	PI	2200400
674	Alvorada do Gurguéia	PI	2200459
675	Amarante	PI	2200509
676	Angical do Piauí	PI	2200608
677	Anísio de Abreu	PI	2200707
678	Antônio Almeida	PI	2200806
679	Aroazes	PI	2200905
680	Aroeiras do Itaim	PI	2200954
681	Arraial	PI	2201002
682	Assunção do Piauí	PI	2201051
683	Avelino Lopes	PI	2201101
684	Baixa Grande do Ribeiro	PI	2201150
685	Barra D'Alcântara	PI	2201176
686	Barras	PI	2201200
687	Barreiras do Piauí	PI	2201309
688	Barro Duro	PI	2201408
689	Batalha	PI	2201507
690	Bela Vista do Piauí	PI	2201556
691	Belém do Piauí	PI	2201572
692	Beneditinos	PI	2201606
693	Bertolínia	PI	2201705
694	Betânia do Piauí	PI	2201739
695	Boa Hora	PI	2201770
696	Bocaina	PI	2201804
697	Bom Jesus	PI	2201903
698	Bom Princípio do Piauí	PI	2201919
699	Bonfim do Piauí	PI	2201929
700	Boqueirão do Piauí	PI	2201945
701	Brasileira	PI	2201960
702	Brejo do Piauí	PI	2201988
703	Buriti dos Lopes	PI	2202000
704	Buriti dos Montes	PI	2202026
705	Cabeceiras do Piauí	PI	2202059
706	Cajazeiras do Piauí	PI	2202075
707	Cajueiro da Praia	PI	2202083
708	Caldeirão Grande do Piauí	PI	2202091
709	Campinas do Piauí	PI	2202109
710	Campo Alegre do Fidalgo	PI	2202117
711	Campo Grande do Piauí	PI	2202133
712	Campo Largo do Piauí	PI	2202174
713	Campo Maior	PI	2202208
714	Canavieira	PI	2202251
715	Canto do Buriti	PI	2202307
716	Capitão de Campos	PI	2202406
717	Capitão Gervásio Oliveira	PI	2202455
718	Caracol	PI	2202505
719	Caraúbas do Piauí	PI	2202539
720	Caridade do Piauí	PI	2202554
721	Castelo do Piauí	PI	2202604
722	Caxingó	PI	2202653
723	Cocal	PI	2202703
724	Cocal de Telha	PI	2202711
725	Cocal dos Alves	PI	2202729
726	Coivaras	PI	2202737
727	Colônia do Gurguéia	PI	2202752
728	Colônia do Piauí	PI	2202778
729	Conceição do Canindé	PI	2202802
730	Coronel José Dias	PI	2202851
731	Corrente	PI	2202901
732	Cristalândia do Piauí	PI	2203008
733	Cristino Castro	PI	2203107
734	Curimatá	PI	2203206
735	Currais	PI	2203230
736	Curral Novo do Piauí	PI	2203271
737	Curralinhos	PI	2203255
738	Demerval Lobão	PI	2203305
739	Dirceu Arcoverde	PI	2203354
740	Dom Expedito Lopes	PI	2203404
741	Dom Inocêncio	PI	2203453
742	Domingos Mourão	PI	2203420
743	Elesbão Veloso	PI	2203503
744	Eliseu Martins	PI	2203602
745	Esperantina	PI	2203701
746	Fartura do Piauí	PI	2203750
747	Flores do Piauí	PI	2203800
748	Floresta do Piauí	PI	2203859
749	Floriano	PI	2203909
750	Francinópolis	PI	2204006
751	Francisco Ayres	PI	2204105
752	Francisco Macedo	PI	2204154
753	Francisco Santos	PI	2204204
754	Fronteiras	PI	2204303
755	Geminiano	PI	2204352
756	Gilbués	PI	2204402
757	Guadalupe	PI	2204501
758	Guaribas	PI	2204550
759	Hugo Napoleão	PI	2204600
760	Ilha Grande	PI	2204659
761	Inhuma	PI	2204709
762	Ipiranga do Piauí	PI	2204808
763	Isaías Coelho	PI	2204907
764	Itainópolis	PI	2205003
765	Itaueira	PI	2205102
766	Jacobina do Piauí	PI	2205151
767	Jaicós	PI	2205201
768	Jardim do Mulato	PI	2205250
769	Jatobá do Piauí	PI	2205276
770	Jerumenha	PI	2205300
771	João Costa	PI	2205359
772	Joaquim Pires	PI	2205409
773	Joca Marques	PI	2205458
774	José de Freitas	PI	2205508
775	Juazeiro do Piauí	PI	2205516
776	Júlio Borges	PI	2205524
777	Jurema	PI	2205532
778	Lagoa Alegre	PI	2205557
779	Lagoa de São Francisco	PI	2205573
780	Lagoa do Barro do Piauí	PI	2205565
781	Lagoa do Piauí	PI	2205581
782	Lagoa do Sítio	PI	2205599
783	Lagoinha do Piauí	PI	2205540
784	Landri Sales	PI	2205607
785	Luís Correia	PI	2205706
786	Luzilândia	PI	2205805
787	Madeiro	PI	2205854
788	Manoel Emídio	PI	2205904
789	Marcolândia	PI	2205953
790	Marcos Parente	PI	2206001
791	Massapê do Piauí	PI	2206050
792	Matias Olímpio	PI	2206100
793	Miguel Alves	PI	2206209
794	Miguel Leão	PI	2206308
795	Milton Brandão	PI	2206357
796	Monsenhor Gil	PI	2206407
797	Monsenhor Hipólito	PI	2206506
798	Monte Alegre do Piauí	PI	2206605
799	Morro Cabeça no Tempo	PI	2206654
800	Morro do Chapéu do Piauí	PI	2206670
801	Murici dos Portelas	PI	2206696
802	Nazaré do Piauí	PI	2206704
803	Nazária 	PI	2206720
804	Nossa Senhora de Nazaré	PI	2206753
805	Nossa Senhora dos Remédios	PI	2206803
806	Nova Santa Rita	PI	2207959
807	Novo Oriente do Piauí	PI	2206902
808	Novo Santo Antônio	PI	2206951
809	Oeiras	PI	2207009
810	Olho D'Água do Piauí	PI	2207108
811	Padre Marcos	PI	2207207
812	Paes Landim	PI	2207306
813	Pajeú do Piauí	PI	2207355
814	Palmeira do Piauí	PI	2207405
815	Palmeirais	PI	2207504
816	Paquetá	PI	2207553
817	Parnaguá	PI	2207603
818	Parnaíba	PI	2207702
819	Passagem Franca do Piauí	PI	2207751
820	Patos do Piauí	PI	2207777
821	Pau D'Arco do Piauí	PI	2207793
822	Paulistana	PI	2207801
823	Pavussu	PI	2207850
824	Pedro II	PI	2207900
825	Pedro Laurentino	PI	2207934
826	Picos	PI	2208007
827	Pimenteiras	PI	2208106
828	Pio IX	PI	2208205
829	Piracuruca	PI	2208304
830	Piripiri	PI	2208403
831	Porto	PI	2208502
832	Porto Alegre do Piauí	PI	2208551
833	Prata do Piauí	PI	2208601
834	Queimada Nova	PI	2208650
835	Redenção do Gurguéia	PI	2208700
836	Regeneração	PI	2208809
837	Riacho Frio	PI	2208858
838	Ribeira do Piauí	PI	2208874
839	Ribeiro Gonçalves	PI	2208908
840	Rio Grande do Piauí	PI	2209005
841	Santa Cruz do Piauí	PI	2209104
842	Santa Cruz dos Milagres	PI	2209153
843	Santa Filomena	PI	2209203
844	Santa Luz	PI	2209302
845	Santa Rosa do Piauí	PI	2209377
846	Santana do Piauí	PI	2209351
847	Santo Antônio de Lisboa	PI	2209401
848	Santo Antônio dos Milagres	PI	2209450
849	Santo Inácio do Piauí	PI	2209500
850	São Braz do Piauí	PI	2209559
851	São Félix do Piauí	PI	2209609
852	São Francisco de Assis do Piauí	PI	2209658
853	São Francisco do Piauí	PI	2209708
854	São Gonçalo do Gurguéia	PI	2209757
855	São Gonçalo do Piauí	PI	2209807
856	São João da Canabrava	PI	2209856
857	São João da Fronteira	PI	2209872
858	São João da Serra	PI	2209906
859	São João da Varjota	PI	2209955
860	São João do Arraial	PI	2209971
861	São João do Piauí	PI	2210003
862	São José do Divino	PI	2210052
863	São José do Peixe	PI	2210102
864	São José do Piauí	PI	2210201
865	São Julião	PI	2210300
866	São Lourenço do Piauí	PI	2210359
867	São Luis do Piauí	PI	2210375
868	São Miguel da Baixa Grande	PI	2210383
869	São Miguel do Fidalgo	PI	2210391
870	São Miguel do Tapuio	PI	2210409
871	São Pedro do Piauí	PI	2210508
872	São Raimundo Nonato	PI	2210607
873	Sebastião Barros	PI	2210623
874	Sebastião Leal	PI	2210631
875	Sigefredo Pacheco	PI	2210656
876	Simões	PI	2210706
877	Simplício Mendes	PI	2210805
878	Socorro do Piauí	PI	2210904
879	Sussuapara	PI	2210938
880	Tamboril do Piauí	PI	2210953
881	Tanque do Piauí	PI	2210979
882	Teresina	PI	2211001
883	União	PI	2211100
884	Uruçuí	PI	2211209
885	Valença do Piauí	PI	2211308
886	Várzea Branca	PI	2211357
887	Várzea Grande	PI	2211407
888	Vera Mendes	PI	2211506
889	Vila Nova do Piauí	PI	2211605
890	Wall Ferraz	PI	2211704
891	Abaiara	CE	2300101
892	Acarape	CE	2300150
893	Acaraú	CE	2300200
894	Acopiara	CE	2300309
895	Aiuaba	CE	2300408
896	Alcântaras	CE	2300507
897	Altaneira	CE	2300606
898	Alto Santo	CE	2300705
899	Amontada	CE	2300754
900	Antonina do Norte	CE	2300804
901	Apuiarés	CE	2300903
902	Aquiraz	CE	2301000
903	Aracati	CE	2301109
904	Aracoiaba	CE	2301208
905	Ararendá	CE	2301257
906	Araripe	CE	2301307
907	Aratuba	CE	2301406
908	Arneiroz	CE	2301505
909	Assaré	CE	2301604
910	Aurora	CE	2301703
911	Baixio	CE	2301802
912	Banabuiú	CE	2301851
913	Barbalha	CE	2301901
914	Barreira	CE	2301950
915	Barro	CE	2302008
916	Barroquinha	CE	2302057
917	Baturité	CE	2302107
918	Beberibe	CE	2302206
919	Bela Cruz	CE	2302305
920	Boa Viagem	CE	2302404
921	Brejo Santo	CE	2302503
922	Camocim	CE	2302602
923	Campos Sales	CE	2302701
924	Canindé	CE	2302800
925	Capistrano	CE	2302909
926	Caridade	CE	2303006
927	Cariré	CE	2303105
928	Caririaçu	CE	2303204
929	Cariús	CE	2303303
930	Carnaubal	CE	2303402
931	Cascavel	CE	2303501
932	Catarina	CE	2303600
933	Catunda	CE	2303659
934	Caucaia	CE	2303709
935	Cedro	CE	2303808
936	Chaval	CE	2303907
937	Choró	CE	2303931
938	Chorozinho	CE	2303956
939	Coreaú	CE	2304004
940	Crateús	CE	2304103
941	Crato	CE	2304202
942	Croatá	CE	2304236
943	Cruz	CE	2304251
944	Deputado Irapuan Pinheiro	CE	2304269
945	Ererê	CE	2304277
946	Eusébio	CE	2304285
947	Farias Brito	CE	2304301
948	Forquilha	CE	2304350
949	Fortaleza	CE	2304400
950	Fortim	CE	2304459
951	Frecheirinha	CE	2304509
952	General Sampaio	CE	2304608
953	Graça	CE	2304657
954	Granja	CE	2304707
955	Granjeiro	CE	2304806
956	Groaíras	CE	2304905
957	Guaiúba	CE	2304954
958	Guaraciaba do Norte	CE	2305001
959	Guaramiranga	CE	2305100
960	Hidrolândia	CE	2305209
961	Horizonte	CE	2305233
962	Ibaretama	CE	2305266
963	Ibiapina	CE	2305308
964	Ibicuitinga	CE	2305332
965	Icapuí	CE	2305357
966	Icó	CE	2305407
967	Iguatu	CE	2305506
968	Independência	CE	2305605
969	Ipaporanga	CE	2305654
970	Ipaumirim	CE	2305704
971	Ipu	CE	2305803
972	Ipueiras	CE	2305902
973	Iracema	CE	2306009
974	Irauçuba	CE	2306108
975	Itaiçaba	CE	2306207
976	Itaitinga	CE	2306256
977	Itapagé	CE	2306306
978	Itapipoca	CE	2306405
979	Itapiúna	CE	2306504
980	Itarema	CE	2306553
981	Itatira	CE	2306603
982	Jaguaretama	CE	2306702
983	Jaguaribara	CE	2306801
984	Jaguaribe	CE	2306900
985	Jaguaruana	CE	2307007
986	Jardim	CE	2307106
987	Jati	CE	2307205
988	Jijoca de Jericoacoara	CE	2307254
989	Juazeiro do Norte	CE	2307304
990	Jucás	CE	2307403
991	Lavras da Mangabeira	CE	2307502
992	Limoeiro do Norte	CE	2307601
993	Madalena	CE	2307635
994	Maracanaú	CE	2307650
995	Maranguape	CE	2307700
996	Marco	CE	2307809
997	Martinópole	CE	2307908
998	Massapê	CE	2308005
999	Mauriti	CE	2308104
1000	Meruoca	CE	2308203
1001	Milagres	CE	2308302
1002	Milhã	CE	2308351
1003	Miraíma	CE	2308377
1004	Missão Velha	CE	2308401
1005	Mombaça	CE	2308500
1006	Monsenhor Tabosa	CE	2308609
1007	Morada Nova	CE	2308708
1008	Moraújo	CE	2308807
1009	Morrinhos	CE	2308906
1010	Mucambo	CE	2309003
1011	Mulungu	CE	2309102
1012	Nova Olinda	CE	2309201
1013	Nova Russas	CE	2309300
1014	Novo Oriente	CE	2309409
1015	Ocara	CE	2309458
1016	Orós	CE	2309508
1017	Pacajus	CE	2309607
1018	Pacatuba	CE	2309706
1019	Pacoti	CE	2309805
1020	Pacujá	CE	2309904
1021	Palhano	CE	2310001
1022	Palmácia	CE	2310100
1023	Paracuru	CE	2310209
1024	Paraipaba	CE	2310258
1025	Parambu	CE	2310308
1026	Paramoti	CE	2310407
1027	Pedra Branca	CE	2310506
1028	Penaforte	CE	2310605
1029	Pentecoste	CE	2310704
1030	Pereiro	CE	2310803
1031	Pindoretama	CE	2310852
1032	Piquet Carneiro	CE	2310902
1033	Pires Ferreira	CE	2310951
1034	Poranga	CE	2311009
1035	Porteiras	CE	2311108
1036	Potengi	CE	2311207
1037	Potiretama	CE	2311231
1038	Quiterianópolis	CE	2311264
1039	Quixadá	CE	2311306
1040	Quixelô	CE	2311355
1041	Quixeramobim	CE	2311405
1042	Quixeré	CE	2311504
1043	Redenção	CE	2311603
1044	Reriutaba	CE	2311702
1045	Russas	CE	2311801
1046	Saboeiro	CE	2311900
1047	Salitre	CE	2311959
1048	Santa Quitéria	CE	2312205
1049	Santana do Acaraú	CE	2312007
1050	Santana do Cariri	CE	2312106
1051	São Benedito	CE	2312304
1052	São Gonçalo do Amarante	CE	2312403
1053	São João do Jaguaribe	CE	2312502
1054	São Luís do Curu	CE	2312601
1055	Senador Pompeu	CE	2312700
1056	Senador Sá	CE	2312809
1057	Sobral	CE	2312908
1058	Solonópole	CE	2313005
1059	Tabuleiro do Norte	CE	2313104
1060	Tamboril	CE	2313203
1061	Tarrafas	CE	2313252
1062	Tauá	CE	2313302
1063	Tejuçuoca	CE	2313351
1064	Tianguá	CE	2313401
1065	Trairi	CE	2313500
1066	Tururu	CE	2313559
1067	Ubajara	CE	2313609
1068	Umari	CE	2313708
1069	Umirim	CE	2313757
1070	Uruburetama	CE	2313807
1071	Uruoca	CE	2313906
1072	Varjota	CE	2313955
1073	Várzea Alegre	CE	2314003
1074	Viçosa do Ceará	CE	2314102
1075	Acari	RN	2400109
1076	Açu	RN	2400208
1077	Afonso Bezerra	RN	2400307
1078	Água Nova	RN	2400406
1079	Alexandria	RN	2400505
1080	Almino Afonso	RN	2400604
1081	Alto do Rodrigues	RN	2400703
1082	Angicos	RN	2400802
1083	Antônio Martins	RN	2400901
1084	Apodi	RN	2401008
1085	Areia Branca	RN	2401107
1086	Arês	RN	2401206
1087	Augusto Severo	RN	2401305
1088	Baía Formosa	RN	2401404
1089	Baraúna	RN	2401453
1090	Barcelona	RN	2401503
1091	Bento Fernandes	RN	2401602
1092	Bodó	RN	2401651
1093	Bom Jesus	RN	2401701
1094	Brejinho	RN	2401800
1095	Caiçara do Norte	RN	2401859
1096	Caiçara do Rio do Vento	RN	2401909
1097	Caicó	RN	2402006
1098	Campo Redondo	RN	2402105
1099	Canguaretama	RN	2402204
1100	Caraúbas	RN	2402303
1101	Carnaúba dos Dantas	RN	2402402
1102	Carnaubais	RN	2402501
1103	Ceará-Mirim	RN	2402600
1104	Cerro Corá	RN	2402709
1105	Coronel Ezequiel	RN	2402808
1106	Coronel João Pessoa	RN	2402907
1107	Cruzeta	RN	2403004
1108	Currais Novos	RN	2403103
1109	Doutor Severiano	RN	2403202
1110	Encanto	RN	2403301
1111	Equador	RN	2403400
1112	Espírito Santo	RN	2403509
1113	Extremoz	RN	2403608
1114	Felipe Guerra	RN	2403707
1115	Fernando Pedroza	RN	2403756
1116	Florânia	RN	2403806
1117	Francisco Dantas	RN	2403905
1118	Frutuoso Gomes	RN	2404002
1119	Galinhos	RN	2404101
1120	Goianinha	RN	2404200
1121	Governador Dix-Sept Rosado	RN	2404309
1122	Grossos	RN	2404408
1123	Guamaré	RN	2404507
1124	Ielmo Marinho	RN	2404606
1125	Ipanguaçu	RN	2404705
1126	Ipueira	RN	2404804
1127	Itajá	RN	2404853
1128	Itaú	RN	2404903
1129	Jaçanã	RN	2405009
1130	Jandaíra	RN	2405108
1131	Janduís	RN	2405207
1132	Januário Cicco	RN	2405306
1133	Japi	RN	2405405
1134	Jardim de Angicos	RN	2405504
1135	Jardim de Piranhas	RN	2405603
1136	Jardim do Seridó	RN	2405702
1137	João Câmara	RN	2405801
1138	João Dias	RN	2405900
1139	José da Penha	RN	2406007
1140	Jucurutu	RN	2406106
1141	Jundiá	RN	2406155
1142	Lagoa d'Anta	RN	2406205
1143	Lagoa de Pedras	RN	2406304
1144	Lagoa de Velhos	RN	2406403
1145	Lagoa Nova	RN	2406502
1146	Lagoa Salgada	RN	2406601
1147	Lajes	RN	2406700
1148	Lajes Pintadas	RN	2406809
1149	Lucrécia	RN	2406908
1150	Luís Gomes	RN	2407005
1151	Macaíba	RN	2407104
1152	Macau	RN	2407203
1153	Major Sales	RN	2407252
1154	Marcelino Vieira	RN	2407302
1155	Martins	RN	2407401
1156	Maxaranguape	RN	2407500
1157	Messias Targino	RN	2407609
1158	Montanhas	RN	2407708
1159	Monte Alegre	RN	2407807
1160	Monte das Gameleiras	RN	2407906
1161	Mossoró	RN	2408003
1162	Natal	RN	2408102
1163	Nísia Floresta	RN	2408201
1164	Nova Cruz	RN	2408300
1165	Olho-d'Água do Borges	RN	2408409
1166	Ouro Branco	RN	2408508
1167	Paraná	RN	2408607
1168	Paraú	RN	2408706
1169	Parazinho	RN	2408805
1170	Parelhas	RN	2408904
1171	Parnamirim	RN	2403251
1172	Passa e Fica	RN	2409100
1173	Passagem	RN	2409209
1174	Patu	RN	2409308
1175	Pau dos Ferros	RN	2409407
1176	Pedra Grande	RN	2409506
1177	Pedra Preta	RN	2409605
1178	Pedro Avelino	RN	2409704
1179	Pedro Velho	RN	2409803
1180	Pendências	RN	2409902
1181	Pilões	RN	2410009
1182	Poço Branco	RN	2410108
1183	Portalegre	RN	2410207
1184	Porto do Mangue	RN	2410256
1185	Presidente Juscelino	RN	2410306
1186	Pureza	RN	2410405
1187	Rafael Fernandes	RN	2410504
1188	Rafael Godeiro	RN	2410603
1189	Riacho da Cruz	RN	2410702
1190	Riacho de Santana	RN	2410801
1191	Riachuelo	RN	2410900
1192	Rio do Fogo	RN	2408953
1193	Rodolfo Fernandes	RN	2411007
1194	Ruy Barbosa	RN	2411106
1195	Santa Cruz	RN	2411205
1196	Santa Maria	RN	2409332
1197	Santana do Matos	RN	2411403
1198	Santana do Seridó	RN	2411429
1199	Santo Antônio	RN	2411502
1200	São Bento do Norte	RN	2411601
1201	São Bento do Trairí	RN	2411700
1202	São Fernando	RN	2411809
1203	São Francisco do Oeste	RN	2411908
1204	São Gonçalo do Amarante	RN	2412005
1205	São João do Sabugi	RN	2412104
1206	São José de Mipibu	RN	2412203
1207	São José do Campestre	RN	2412302
1208	São José do Seridó	RN	2412401
1209	São Miguel	RN	2412500
1210	São Miguel do Gostoso	RN	2412559
1211	São Paulo do Potengi	RN	2412609
1212	São Pedro	RN	2412708
1213	São Rafael	RN	2412807
1214	São Tomé	RN	2412906
1215	São Vicente	RN	2413003
1216	Senador Elói de Souza	RN	2413102
1217	Senador Georgino Avelino	RN	2413201
1218	Serra de São Bento	RN	2413300
1219	Serra do Mel	RN	2413359
1220	Serra Negra do Norte	RN	2413409
1221	Serrinha	RN	2413508
1222	Serrinha dos Pintos	RN	2413557
1223	Severiano Melo	RN	2413607
1224	Sítio Novo	RN	2413706
1225	Taboleiro Grande	RN	2413805
1226	Taipu	RN	2413904
1227	Tangará	RN	2414001
1228	Tenente Ananias	RN	2414100
1229	Tenente Laurentino Cruz	RN	2414159
1230	Tibau	RN	2411056
1231	Tibau do Sul	RN	2414209
1232	Timbaúba dos Batistas	RN	2414308
1233	Touros	RN	2414407
1234	Triunfo Potiguar	RN	2414456
1235	Umarizal	RN	2414506
1236	Upanema	RN	2414605
1237	Várzea	RN	2414704
1238	Venha-Ver	RN	2414753
1239	Vera Cruz	RN	2414803
1240	Viçosa	RN	2414902
1241	Vila Flor	RN	2415008
1242	Água Branca	PB	2500106
1243	Aguiar	PB	2500205
1244	Alagoa Grande	PB	2500304
1245	Alagoa Nova	PB	2500403
1246	Alagoinha	PB	2500502
1247	Alcantil	PB	2500536
1248	Algodão de Jandaíra	PB	2500577
1249	Alhandra	PB	2500601
1250	Amparo	PB	2500734
1251	Aparecida	PB	2500775
1252	Araçagi	PB	2500809
1253	Arara	PB	2500908
1254	Araruna	PB	2501005
1255	Areia	PB	2501104
1256	Areia de Baraúnas	PB	2501153
1257	Areial	PB	2501203
1258	Aroeiras	PB	2501302
1259	Assunção	PB	2501351
1260	Baía da Traição	PB	2501401
1261	Bananeiras	PB	2501500
1262	Baraúna	PB	2501534
1263	Barra de Santa Rosa	PB	2501609
1264	Barra de Santana	PB	2501575
1265	Barra de São Miguel	PB	2501708
1266	Bayeux	PB	2501807
1267	Belém	PB	2501906
1268	Belém do Brejo do Cruz	PB	2502003
1269	Bernardino Batista	PB	2502052
1270	Boa Ventura	PB	2502102
1271	Boa Vista	PB	2502151
1272	Bom Jesus	PB	2502201
1273	Bom Sucesso	PB	2502300
1274	Bonito de Santa Fé	PB	2502409
1275	Boqueirão	PB	2502508
1276	Borborema	PB	2502706
1277	Brejo do Cruz	PB	2502805
1278	Brejo dos Santos	PB	2502904
1279	Caaporã	PB	2503001
1280	Cabaceiras	PB	2503100
1281	Cabedelo	PB	2503209
1282	Cachoeira dos Índios	PB	2503308
1283	Cacimba de Areia	PB	2503407
1284	Cacimba de Dentro	PB	2503506
1285	Cacimbas	PB	2503555
1286	Caiçara	PB	2503605
1287	Cajazeiras	PB	2503704
1288	Cajazeirinhas	PB	2503753
1289	Caldas Brandão	PB	2503803
1290	Camalaú	PB	2503902
1291	Campina Grande	PB	2504009
1292	Tacima	PB	2516409
1293	Capim	PB	2504033
1294	Caraúbas	PB	2504074
1295	Carrapateira	PB	2504108
1296	Casserengue	PB	2504157
1297	Catingueira	PB	2504207
1298	Catolé do Rocha	PB	2504306
1299	Caturité	PB	2504355
1300	Conceição	PB	2504405
1301	Condado	PB	2504504
1302	Conde	PB	2504603
1303	Congo	PB	2504702
1304	Coremas	PB	2504801
1305	Coxixola	PB	2504850
1306	Cruz do Espírito Santo	PB	2504900
1307	Cubati	PB	2505006
1308	Cuité	PB	2505105
1309	Cuité de Mamanguape	PB	2505238
1310	Cuitegi	PB	2505204
1311	Curral de Cima	PB	2505279
1312	Curral Velho	PB	2505303
1313	Damião	PB	2505352
1314	Desterro	PB	2505402
1315	Diamante	PB	2505600
1316	Dona Inês	PB	2505709
1317	Duas Estradas	PB	2505808
1318	Emas	PB	2505907
1319	Esperança	PB	2506004
1320	Fagundes	PB	2506103
1321	Frei Martinho	PB	2506202
1322	Gado Bravo	PB	2506251
1323	Guarabira	PB	2506301
1324	Gurinhém	PB	2506400
1325	Gurjão	PB	2506509
1326	Ibiara	PB	2506608
1327	Igaracy	PB	2502607
1328	Imaculada	PB	2506707
1329	Ingá	PB	2506806
1330	Itabaiana	PB	2506905
1331	Itaporanga	PB	2507002
1332	Itapororoca	PB	2507101
1333	Itatuba	PB	2507200
1334	Jacaraú	PB	2507309
1335	Jericó	PB	2507408
1336	João Pessoa	PB	2507507
1337	Juarez Távora	PB	2507606
1338	Juazeirinho	PB	2507705
1339	Junco do Seridó	PB	2507804
1340	Juripiranga	PB	2507903
1341	Juru	PB	2508000
1342	Lagoa	PB	2508109
1343	Lagoa de Dentro	PB	2508208
1344	Lagoa Seca	PB	2508307
1345	Lastro	PB	2508406
1346	Livramento	PB	2508505
1347	Logradouro	PB	2508554
1348	Lucena	PB	2508604
1349	Mãe d'Água	PB	2508703
1350	Malta	PB	2508802
1351	Mamanguape	PB	2508901
1352	Manaíra	PB	2509008
1353	Marcação	PB	2509057
1354	Mari	PB	2509107
1355	Marizópolis	PB	2509156
1356	Massaranduba	PB	2509206
1357	Mataraca	PB	2509305
1358	Matinhas	PB	2509339
1359	Mato Grosso	PB	2509370
1360	Maturéia	PB	2509396
1361	Mogeiro	PB	2509404
1362	Montadas	PB	2509503
1363	Monte Horebe	PB	2509602
1364	Monteiro	PB	2509701
1365	Mulungu	PB	2509800
1366	Natuba	PB	2509909
1367	Nazarezinho	PB	2510006
1368	Nova Floresta	PB	2510105
1369	Nova Olinda	PB	2510204
1370	Nova Palmeira	PB	2510303
1371	Olho d'Água	PB	2510402
1372	Olivedos	PB	2510501
1373	Ouro Velho	PB	2510600
1374	Parari	PB	2510659
1375	Passagem	PB	2510709
1376	Patos	PB	2510808
1377	Paulista	PB	2510907
1378	Pedra Branca	PB	2511004
1379	Pedra Lavrada	PB	2511103
1380	Pedras de Fogo	PB	2511202
1381	Pedro Régis	PB	2512721
1382	Piancó	PB	2511301
1383	Picuí	PB	2511400
1384	Pilar	PB	2511509
1385	Pilões	PB	2511608
1386	Pilõezinhos	PB	2511707
1387	Pirpirituba	PB	2511806
1388	Pitimbu	PB	2511905
1389	Pocinhos	PB	2512002
1390	Poço Dantas	PB	2512036
1391	Poço de José de Moura	PB	2512077
1392	Pombal	PB	2512101
1393	Prata	PB	2512200
1394	Princesa Isabel	PB	2512309
1395	Puxinanã	PB	2512408
1396	Queimadas	PB	2512507
1397	Quixabá	PB	2512606
1398	Remígio	PB	2512705
1399	Riachão	PB	2512747
1400	Riachão do Bacamarte	PB	2512754
1401	Riachão do Poço	PB	2512762
1402	Riacho de Santo Antônio	PB	2512788
1403	Riacho dos Cavalos	PB	2512804
1404	Rio Tinto	PB	2512903
1405	Salgadinho	PB	2513000
1406	Salgado de São Félix	PB	2513109
1407	Santa Cecília	PB	2513158
1408	Santa Cruz	PB	2513208
1409	Santa Helena	PB	2513307
1410	Santa Inês	PB	2513356
1411	Santa Luzia	PB	2513406
1412	Santa Rita	PB	2513703
1413	Santa Teresinha	PB	2513802
1414	Santana de Mangueira	PB	2513505
1415	Santana dos Garrotes	PB	2513604
1416	Joca Claudino	PB	2513653
1417	Santo André	PB	2513851
1418	São Bentinho	PB	2513927
1419	São Bento	PB	2513901
1420	São Domingos	PB	2513968
1421	São Domingos do Cariri	PB	2513943
1422	São Francisco	PB	2513984
1423	São João do Cariri	PB	2514008
1424	São João do Rio do Peixe	PB	2500700
1425	São João do Tigre	PB	2514107
1426	São José da Lagoa Tapada	PB	2514206
1427	São José de Caiana	PB	2514305
1428	São José de Espinharas	PB	2514404
1429	São José de Piranhas	PB	2514503
1430	São José de Princesa	PB	2514552
1431	São José do Bonfim	PB	2514602
1432	São José do Brejo do Cruz	PB	2514651
1433	São José do Sabugi	PB	2514701
1434	São José dos Cordeiros	PB	2514800
1435	São José dos Ramos	PB	2514453
1436	São Mamede	PB	2514909
1437	São Miguel de Taipu	PB	2515005
1438	São Sebastião de Lagoa de Roça	PB	2515104
1439	São Sebastião do Umbuzeiro	PB	2515203
1440	Sapé	PB	2515302
1441	Seridó	PB	2515401
1442	Serra Branca	PB	2515500
1443	Serra da Raiz	PB	2515609
1444	Serra Grande	PB	2515708
1445	Serra Redonda	PB	2515807
1446	Serraria	PB	2515906
1447	Sertãozinho	PB	2515930
1448	Sobrado	PB	2515971
1449	Solânea	PB	2516003
1450	Soledade	PB	2516102
1451	Sossêgo	PB	2516151
1452	Sousa	PB	2516201
1453	Sumé	PB	2516300
1454	Taperoá	PB	2516508
1455	Tavares	PB	2516607
1456	Teixeira	PB	2516706
1457	Tenório	PB	2516755
1458	Triunfo	PB	2516805
1459	Uiraúna	PB	2516904
1460	Umbuzeiro	PB	2517001
1461	Várzea	PB	2517100
1462	Vieirópolis	PB	2517209
1463	Vista Serrana	PB	2505501
1464	Zabelê	PB	2517407
1465	Abreu e Lima	PE	2600054
1466	Afogados da Ingazeira	PE	2600104
1467	Afrânio	PE	2600203
1468	Agrestina	PE	2600302
1469	Água Preta	PE	2600401
1470	Águas Belas	PE	2600500
1471	Alagoinha	PE	2600609
1472	Aliança	PE	2600708
1473	Altinho	PE	2600807
1474	Amaraji	PE	2600906
1475	Angelim	PE	2601003
1476	Araçoiaba	PE	2601052
1477	Araripina	PE	2601102
1478	Arcoverde	PE	2601201
1479	Barra de Guabiraba	PE	2601300
1480	Barreiros	PE	2601409
1481	Belém de Maria	PE	2601508
1482	Belém do São Francisco	PE	2601607
1483	Belo Jardim	PE	2601706
1484	Betânia	PE	2601805
1485	Bezerros	PE	2601904
1486	Bodocó	PE	2602001
1487	Bom Conselho	PE	2602100
1488	Bom Jardim	PE	2602209
1489	Bonito	PE	2602308
1490	Brejão	PE	2602407
1491	Brejinho	PE	2602506
1492	Brejo da Madre de Deus	PE	2602605
1493	Buenos Aires	PE	2602704
1494	Buíque	PE	2602803
1495	Cabo de Santo Agostinho	PE	2602902
1496	Cabrobó	PE	2603009
1497	Cachoeirinha	PE	2603108
1498	Caetés	PE	2603207
1499	Calçado	PE	2603306
1500	Calumbi	PE	2603405
1501	Camaragibe	PE	2603454
1502	Camocim de São Félix	PE	2603504
1503	Camutanga	PE	2603603
1504	Canhotinho	PE	2603702
1505	Capoeiras	PE	2603801
1506	Carnaíba	PE	2603900
1507	Carnaubeira da Penha	PE	2603926
1508	Carpina	PE	2604007
1509	Caruaru	PE	2604106
1510	Casinhas	PE	2604155
1511	Catende	PE	2604205
1512	Cedro	PE	2604304
1513	Chã de Alegria	PE	2604403
1514	Chã Grande	PE	2604502
1515	Condado	PE	2604601
1516	Correntes	PE	2604700
1517	Cortês	PE	2604809
1518	Cumaru	PE	2604908
1519	Cupira	PE	2605004
1520	Custódia	PE	2605103
1521	Dormentes	PE	2605152
1522	Escada	PE	2605202
1523	Exu	PE	2605301
1524	Feira Nova	PE	2605400
1525	Fernando de Noronha	PE	2605459
1526	Ferreiros	PE	2605509
1527	Flores	PE	2605608
1528	Floresta	PE	2605707
1529	Frei Miguelinho	PE	2605806
1530	Gameleira	PE	2605905
1531	Garanhuns	PE	2606002
1532	Glória do Goitá	PE	2606101
1533	Goiana	PE	2606200
1534	Granito	PE	2606309
1535	Gravatá	PE	2606408
1536	Iati	PE	2606507
1537	Ibimirim	PE	2606606
1538	Ibirajuba	PE	2606705
1539	Igarassu	PE	2606804
1540	Iguaraci	PE	2606903
1541	Ilha de Itamaracá	PE	2607604
1542	Inajá	PE	2607000
1543	Ingazeira	PE	2607109
1544	Ipojuca	PE	2607208
1545	Ipubi	PE	2607307
1546	Itacuruba	PE	2607406
1547	Itaíba	PE	2607505
1548	Itambé	PE	2607653
1549	Itapetim	PE	2607703
1550	Itapissuma	PE	2607752
1551	Itaquitinga	PE	2607802
1552	Jaboatão dos Guararapes	PE	2607901
1553	Jaqueira	PE	2607950
1554	Jataúba	PE	2608008
1555	Jatobá	PE	2608057
1556	João Alfredo	PE	2608107
1557	Joaquim Nabuco	PE	2608206
1558	Jucati	PE	2608255
1559	Jupi	PE	2608305
1560	Jurema	PE	2608404
1561	Lagoa do Carro	PE	2608453
1562	Lagoa de Itaenga	PE	2608503
1563	Lagoa do Ouro	PE	2608602
1564	Lagoa dos Gatos	PE	2608701
1565	Lagoa Grande	PE	2608750
1566	Lajedo	PE	2608800
1567	Limoeiro	PE	2608909
1568	Macaparana	PE	2609006
1569	Machados	PE	2609105
1570	Manari	PE	2609154
1571	Maraial	PE	2609204
1572	Mirandiba	PE	2609303
1573	Moreilândia	PE	2614303
1574	Moreno	PE	2609402
1575	Nazaré da Mata	PE	2609501
1576	Olinda	PE	2609600
1577	Orobó	PE	2609709
1578	Orocó	PE	2609808
1579	Ouricuri	PE	2609907
1580	Palmares	PE	2610004
1581	Palmeirina	PE	2610103
1582	Panelas	PE	2610202
1583	Paranatama	PE	2610301
1584	Parnamirim	PE	2610400
1585	Passira	PE	2610509
1586	Paudalho	PE	2610608
1587	Paulista	PE	2610707
1588	Pedra	PE	2610806
1589	Pesqueira	PE	2610905
1590	Petrolândia	PE	2611002
1591	Petrolina	PE	2611101
1592	Poção	PE	2611200
1593	Pombos	PE	2611309
1594	Primavera	PE	2611408
1595	Quipapá	PE	2611507
1596	Quixaba	PE	2611533
1597	Recife	PE	2611606
1598	Riacho das Almas	PE	2611705
1599	Ribeirão	PE	2611804
1600	Rio Formoso	PE	2611903
1601	Sairé	PE	2612000
1602	Salgadinho	PE	2612109
1603	Salgueiro	PE	2612208
1604	Saloá	PE	2612307
1605	Sanharó	PE	2612406
1606	Santa Cruz	PE	2612455
1607	Santa Cruz da Baixa Verde	PE	2612471
1608	Santa Cruz do Capibaribe	PE	2612505
1609	Santa Filomena	PE	2612554
1610	Santa Maria da Boa Vista	PE	2612604
1611	Santa Maria do Cambucá	PE	2612703
1612	Santa Terezinha	PE	2612802
1613	São Benedito do Sul	PE	2612901
1614	São Bento do Una	PE	2613008
1615	São Caitano	PE	2613107
1616	São João	PE	2613206
1617	São Joaquim do Monte	PE	2613305
1618	São José da Coroa Grande	PE	2613404
1619	São José do Belmonte	PE	2613503
1620	São José do Egito	PE	2613602
1621	São Lourenço da Mata	PE	2613701
1622	São Vicente Ferrer	PE	2613800
1623	Serra Talhada	PE	2613909
1624	Serrita	PE	2614006
1625	Sertânia	PE	2614105
1626	Sirinhaém	PE	2614204
1627	Solidão	PE	2614402
1628	Surubim	PE	2614501
1629	Tabira	PE	2614600
1630	Tacaimbó	PE	2614709
1631	Tacaratu	PE	2614808
1632	Tamandaré	PE	2614857
1633	Taquaritinga do Norte	PE	2615003
1634	Terezinha	PE	2615102
1635	Terra Nova	PE	2615201
1636	Timbaúba	PE	2615300
1637	Toritama	PE	2615409
1638	Tracunhaém	PE	2615508
1639	Trindade	PE	2615607
1640	Triunfo	PE	2615706
1641	Tupanatinga	PE	2615805
1642	Tuparetama	PE	2615904
1643	Venturosa	PE	2616001
1644	Verdejante	PE	2616100
1645	Vertente do Lério	PE	2616183
1646	Vertentes	PE	2616209
1647	Vicência	PE	2616308
1648	Vitória de Santo Antão	PE	2616407
1649	Xexéu	PE	2616506
1650	Água Branca	AL	2700102
1651	Anadia	AL	2700201
1652	Arapiraca	AL	2700300
1653	Atalaia	AL	2700409
1654	Barra de Santo Antônio	AL	2700508
1655	Barra de São Miguel	AL	2700607
1656	Batalha	AL	2700706
1657	Belém	AL	2700805
1658	Belo Monte	AL	2700904
1659	Boca da Mata	AL	2701001
1660	Branquinha	AL	2701100
1661	Cacimbinhas	AL	2701209
1662	Cajueiro	AL	2701308
1663	Campestre	AL	2701357
1664	Campo Alegre	AL	2701407
1665	Campo Grande	AL	2701506
1666	Canapi	AL	2701605
1667	Capela	AL	2701704
1668	Carneiros	AL	2701803
1669	Chã Preta	AL	2701902
1670	Coité do Nóia	AL	2702009
1671	Colônia Leopoldina	AL	2702108
1672	Coqueiro Seco	AL	2702207
1673	Coruripe	AL	2702306
1674	Craíbas	AL	2702355
1675	Delmiro Gouveia	AL	2702405
1676	Dois Riachos	AL	2702504
1677	Estrela de Alagoas	AL	2702553
1678	Feira Grande	AL	2702603
1679	Feliz Deserto	AL	2702702
1680	Flexeiras	AL	2702801
1681	Girau do Ponciano	AL	2702900
1682	Ibateguara	AL	2703007
1683	Igaci	AL	2703106
1684	Igreja Nova	AL	2703205
1685	Inhapi	AL	2703304
1686	Jacaré dos Homens	AL	2703403
1687	Jacuípe	AL	2703502
1688	Japaratinga	AL	2703601
1689	Jaramataia	AL	2703700
1690	Jequiá da Praia	AL	2703759
1691	Joaquim Gomes	AL	2703809
1692	Jundiá	AL	2703908
1693	Junqueiro	AL	2704005
1694	Lagoa da Canoa	AL	2704104
1695	Limoeiro de Anadia	AL	2704203
1696	Maceió	AL	2704302
1697	Major Isidoro	AL	2704401
1698	Mar Vermelho	AL	2704906
1699	Maragogi	AL	2704500
1700	Maravilha	AL	2704609
1701	Marechal Deodoro	AL	2704708
1702	Maribondo	AL	2704807
1703	Mata Grande	AL	2705002
1704	Matriz de Camaragibe	AL	2705101
1705	Messias	AL	2705200
1706	Minador do Negrão	AL	2705309
1707	Monteirópolis	AL	2705408
1708	Murici	AL	2705507
1709	Novo Lino	AL	2705606
1710	Olho d'Água das Flores	AL	2705705
1711	Olho d'Água do Casado	AL	2705804
1712	Olho d'Água Grande	AL	2705903
1713	Olivença	AL	2706000
1714	Ouro Branco	AL	2706109
1715	Palestina	AL	2706208
1716	Palmeira dos Índios	AL	2706307
1717	Pão de Açúcar	AL	2706406
1718	Pariconha	AL	2706422
1719	Paripueira	AL	2706448
1720	Passo de Camaragibe	AL	2706505
1721	Paulo Jacinto	AL	2706604
1722	Penedo	AL	2706703
1723	Piaçabuçu	AL	2706802
1724	Pilar	AL	2706901
1725	Pindoba	AL	2707008
1726	Piranhas	AL	2707107
1727	Poço das Trincheiras	AL	2707206
1728	Porto Calvo	AL	2707305
1729	Porto de Pedras	AL	2707404
1730	Porto Real do Colégio	AL	2707503
1731	Quebrangulo	AL	2707602
1732	Rio Largo	AL	2707701
1733	Roteiro	AL	2707800
1734	Santa Luzia do Norte	AL	2707909
1735	Santana do Ipanema	AL	2708006
1736	Santana do Mundaú	AL	2708105
1737	São Brás	AL	2708204
1738	São José da Laje	AL	2708303
1739	São José da Tapera	AL	2708402
1740	São Luís do Quitunde	AL	2708501
1741	São Miguel dos Campos	AL	2708600
1742	São Miguel dos Milagres	AL	2708709
1743	São Sebastião	AL	2708808
1744	Satuba	AL	2708907
1745	Senador Rui Palmeira	AL	2708956
1746	Tanque d'Arca	AL	2709004
1747	Taquarana	AL	2709103
1748	Teotônio Vilela	AL	2709152
1749	Traipu	AL	2709202
1750	União dos Palmares	AL	2709301
1751	Viçosa	AL	2709400
1752	Amparo de São Francisco	SE	2800100
1753	Aquidabã	SE	2800209
1754	Aracaju	SE	2800308
1755	Arauá	SE	2800407
1756	Areia Branca	SE	2800506
1757	Barra dos Coqueiros	SE	2800605
1758	Boquim	SE	2800670
1759	Brejo Grande	SE	2800704
1760	Campo do Brito	SE	2801009
1761	Canhoba	SE	2801108
1762	Canindé de São Francisco	SE	2801207
1763	Capela	SE	2801306
1764	Carira	SE	2801405
1765	Carmópolis	SE	2801504
1766	Cedro de São João	SE	2801603
1767	Cristinápolis	SE	2801702
1768	Cumbe	SE	2801900
1769	Divina Pastora	SE	2802007
1770	Estância	SE	2802106
1771	Feira Nova	SE	2802205
1772	Frei Paulo	SE	2802304
1773	Gararu	SE	2802403
1774	General Maynard	SE	2802502
1775	Gracho Cardoso	SE	2802601
1776	Ilha das Flores	SE	2802700
1777	Indiaroba	SE	2802809
1778	Itabaiana	SE	2802908
1779	Itabaianinha	SE	2803005
1780	Itabi	SE	2803104
1781	Itaporanga d'Ajuda	SE	2803203
1782	Japaratuba	SE	2803302
1783	Japoatã	SE	2803401
1784	Lagarto	SE	2803500
1785	Laranjeiras	SE	2803609
1786	Macambira	SE	2803708
1787	Malhada dos Bois	SE	2803807
1788	Malhador	SE	2803906
1789	Maruim	SE	2804003
1790	Moita Bonita	SE	2804102
1791	Monte Alegre de Sergipe	SE	2804201
1792	Muribeca	SE	2804300
1793	Neópolis	SE	2804409
1794	Nossa Senhora Aparecida	SE	2804458
1795	Nossa Senhora da Glória	SE	2804508
1796	Nossa Senhora das Dores	SE	2804607
1797	Nossa Senhora de Lourdes	SE	2804706
1798	Nossa Senhora do Socorro	SE	2804805
1799	Pacatuba	SE	2804904
1800	Pedra Mole	SE	2805000
1801	Pedrinhas	SE	2805109
1802	Pinhão	SE	2805208
1803	Pirambu	SE	2805307
1804	Poço Redondo	SE	2805406
1805	Poço Verde	SE	2805505
1806	Porto da Folha	SE	2805604
1807	Propriá	SE	2805703
1808	Riachão do Dantas	SE	2805802
1809	Riachuelo	SE	2805901
1810	Ribeirópolis	SE	2806008
1811	Rosário do Catete	SE	2806107
1812	Salgado	SE	2806206
1813	Santa Luzia do Itanhy	SE	2806305
1814	Santa Rosa de Lima	SE	2806503
1815	Santana do São Francisco	SE	2806404
1816	Santo Amaro das Brotas	SE	2806602
1817	São Cristóvão	SE	2806701
1818	São Domingos	SE	2806800
1819	São Francisco	SE	2806909
1820	São Miguel do Aleixo	SE	2807006
1821	Simão Dias	SE	2807105
1822	Siriri	SE	2807204
1823	Telha	SE	2807303
1824	Tobias Barreto	SE	2807402
1825	Tomar do Geru	SE	2807501
1826	Umbaúba	SE	2807600
1827	Abaíra	BA	2900108
1828	Abaré	BA	2900207
1829	Acajutiba	BA	2900306
1830	Adustina	BA	2900355
1831	Água Fria	BA	2900405
1832	Aiquara	BA	2900603
1833	Alagoinhas	BA	2900702
1834	Alcobaça	BA	2900801
1835	Almadina	BA	2900900
1836	Amargosa	BA	2901007
1837	Amélia Rodrigues	BA	2901106
1838	América Dourada	BA	2901155
1839	Anagé	BA	2901205
1840	Andaraí	BA	2901304
1841	Andorinha	BA	2901353
1842	Angical	BA	2901403
1843	Anguera	BA	2901502
1844	Antas	BA	2901601
1845	Antônio Cardoso	BA	2901700
1846	Antônio Gonçalves	BA	2901809
1847	Aporá	BA	2901908
1848	Apuarema	BA	2901957
1849	Araças	BA	2902054
1850	Aracatu	BA	2902005
1851	Araci	BA	2902104
1852	Aramari	BA	2902203
1853	Arataca	BA	2902252
1854	Aratuípe	BA	2902302
1855	Aurelino Leal	BA	2902401
1856	Baianópolis	BA	2902500
1857	Baixa Grande	BA	2902609
1858	Banzaê	BA	2902658
1859	Barra	BA	2902708
1860	Barra da Estiva	BA	2902807
1861	Barra do Choça	BA	2902906
1862	Barra do Mendes	BA	2903003
1863	Barra do Rocha	BA	2903102
1864	Barreiras	BA	2903201
1865	Barro Alto	BA	2903235
1866	Barro Preto	BA	2903300
1867	Barrocas	BA	2903276
1868	Belmonte	BA	2903409
1869	Belo Campo	BA	2903508
1870	Biritinga	BA	2903607
1871	Boa Nova	BA	2903706
1872	Boa Vista do Tupim	BA	2903805
1873	Bom Jesus da Lapa	BA	2903904
1874	Bom Jesus da Serra	BA	2903953
1875	Boninal	BA	2904001
1876	Bonito	BA	2904050
1877	Boquira	BA	2904100
1878	Botuporã	BA	2904209
1879	Brejões	BA	2904308
1880	Brejolândia	BA	2904407
1881	Brotas de Macaúbas	BA	2904506
1882	Brumado	BA	2904605
1883	Buerarema	BA	2904704
1884	Buritirama	BA	2904753
1885	Caatiba	BA	2904803
1886	Cabaceiras do Paraguaçu	BA	2904852
1887	Cachoeira	BA	2904902
1888	Caculé	BA	2905008
1889	Caém	BA	2905107
1890	Caetanos	BA	2905156
1891	Caetité	BA	2905206
1892	Cafarnaum	BA	2905305
1893	Cairu	BA	2905404
1894	Caldeirão Grande	BA	2905503
1895	Camacan	BA	2905602
1896	Camaçari	BA	2905701
1897	Camamu	BA	2905800
1898	Campo Alegre de Lourdes	BA	2905909
1899	Campo Formoso	BA	2906006
1900	Canápolis	BA	2906105
1901	Canarana	BA	2906204
1902	Canavieiras	BA	2906303
1903	Candeal	BA	2906402
1904	Candeias	BA	2906501
1905	Candiba	BA	2906600
1906	Cândido Sales	BA	2906709
1907	Cansanção	BA	2906808
1908	Canudos	BA	2906824
1909	Capela do Alto Alegre	BA	2906857
1910	Capim Grosso	BA	2906873
1911	Caraíbas	BA	2906899
1912	Caravelas	BA	2906907
1913	Cardeal da Silva	BA	2907004
1914	Carinhanha	BA	2907103
1915	Casa Nova	BA	2907202
1916	Castro Alves	BA	2907301
1917	Catolândia	BA	2907400
1918	Catu	BA	2907509
1919	Caturama	BA	2907558
1920	Central	BA	2907608
1921	Chorrochó	BA	2907707
1922	Cícero Dantas	BA	2907806
1923	Cipó	BA	2907905
1924	Coaraci	BA	2908002
1925	Cocos	BA	2908101
1926	Conceição da Feira	BA	2908200
1927	Conceição do Almeida	BA	2908309
1928	Conceição do Coité	BA	2908408
1929	Conceição do Jacuípe	BA	2908507
1930	Conde	BA	2908606
1931	Condeúba	BA	2908705
1932	Contendas do Sincorá	BA	2908804
1933	Coração de Maria	BA	2908903
1934	Cordeiros	BA	2909000
1935	Coribe	BA	2909109
1936	Coronel João Sá	BA	2909208
1937	Correntina	BA	2909307
1938	Cotegipe	BA	2909406
1939	Cravolândia	BA	2909505
1940	Crisópolis	BA	2909604
1941	Cristópolis	BA	2909703
1942	Cruz das Almas	BA	2909802
1943	Curaçá	BA	2909901
1944	Dário Meira	BA	2910008
1945	Dias d'Ávila	BA	2910057
1946	Dom Basílio	BA	2910107
1947	Dom Macedo Costa	BA	2910206
1948	Elísio Medrado	BA	2910305
1949	Encruzilhada	BA	2910404
1950	Entre Rios	BA	2910503
1951	Érico Cardoso	BA	2900504
1952	Esplanada	BA	2910602
1953	Euclides da Cunha	BA	2910701
1954	Eunápolis	BA	2910727
1955	Fátima	BA	2910750
1956	Feira da Mata	BA	2910776
1957	Feira de Santana	BA	2910800
1958	Filadélfia	BA	2910859
1959	Firmino Alves	BA	2910909
1960	Floresta Azul	BA	2911006
1961	Formosa do Rio Preto	BA	2911105
1962	Gandu	BA	2911204
1963	Gavião	BA	2911253
1964	Gentio do Ouro	BA	2911303
1965	Glória	BA	2911402
1966	Gongogi	BA	2911501
1967	Governador Mangabeira	BA	2911600
1968	Guajeru	BA	2911659
1969	Guanambi	BA	2911709
1970	Guaratinga	BA	2911808
1971	Heliópolis	BA	2911857
1972	Iaçu	BA	2911907
1973	Ibiassucê	BA	2912004
1974	Ibicaraí	BA	2912103
1975	Ibicoara	BA	2912202
1976	Ibicuí	BA	2912301
1977	Ibipeba	BA	2912400
1978	Ibipitanga	BA	2912509
1979	Ibiquera	BA	2912608
1980	Ibirapitanga	BA	2912707
1981	Ibirapuã	BA	2912806
1982	Ibirataia	BA	2912905
1983	Ibitiara	BA	2913002
1984	Ibititá	BA	2913101
1985	Ibotirama	BA	2913200
1986	Ichu	BA	2913309
1987	Igaporã	BA	2913408
1988	Igrapiúna	BA	2913457
1989	Iguaí	BA	2913507
1990	Ilhéus	BA	2913606
1991	Inhambupe	BA	2913705
1992	Ipecaetá	BA	2913804
1993	Ipiaú	BA	2913903
1994	Ipirá	BA	2914000
1995	Ipupiara	BA	2914109
1996	Irajuba	BA	2914208
1997	Iramaia	BA	2914307
1998	Iraquara	BA	2914406
1999	Irará	BA	2914505
2000	Irecê	BA	2914604
2001	Itabela	BA	2914653
2002	Itaberaba	BA	2914703
2003	Itabuna	BA	2914802
2004	Itacaré	BA	2914901
2005	Itaeté	BA	2915007
2006	Itagi	BA	2915106
2007	Itagibá	BA	2915205
2008	Itagimirim	BA	2915304
2009	Itaguaçu da Bahia	BA	2915353
2010	Itaju do Colônia	BA	2915403
2011	Itajuípe	BA	2915502
2012	Itamaraju	BA	2915601
2013	Itamari	BA	2915700
2014	Itambé	BA	2915809
2015	Itanagra	BA	2915908
2016	Itanhém	BA	2916005
2017	Itaparica	BA	2916104
2018	Itapé	BA	2916203
2019	Itapebi	BA	2916302
2020	Itapetinga	BA	2916401
2021	Itapicuru	BA	2916500
2022	Itapitanga	BA	2916609
2023	Itaquara	BA	2916708
2024	Itarantim	BA	2916807
2025	Itatim	BA	2916856
2026	Itiruçu	BA	2916906
2027	Itiúba	BA	2917003
2028	Itororó	BA	2917102
2029	Ituaçu	BA	2917201
2030	Ituberá	BA	2917300
2031	Iuiú	BA	2917334
2032	Jaborandi	BA	2917359
2033	Jacaraci	BA	2917409
2034	Jacobina	BA	2917508
2035	Jaguaquara	BA	2917607
2036	Jaguarari	BA	2917706
2037	Jaguaripe	BA	2917805
2038	Jandaíra	BA	2917904
2039	Jequié	BA	2918001
2040	Jeremoabo	BA	2918100
2041	Jiquiriçá	BA	2918209
2042	Jitaúna	BA	2918308
2043	João Dourado	BA	2918357
2044	Juazeiro	BA	2918407
2045	Jucuruçu	BA	2918456
2046	Jussara	BA	2918506
2047	Jussari	BA	2918555
2048	Jussiape	BA	2918605
2049	Lafaiete Coutinho	BA	2918704
2050	Lagoa Real	BA	2918753
2051	Laje	BA	2918803
2052	Lajedão	BA	2918902
2053	Lajedinho	BA	2919009
2054	Lajedo do Tabocal	BA	2919058
2055	Lamarão	BA	2919108
2056	Lapão	BA	2919157
2057	Lauro de Freitas	BA	2919207
2058	Lençóis	BA	2919306
2059	Licínio de Almeida	BA	2919405
2060	Livramento de Nossa Senhora	BA	2919504
2061	Luís Eduardo Magalhães	BA	2919553
2062	Macajuba	BA	2919603
2063	Macarani	BA	2919702
2064	Macaúbas	BA	2919801
2065	Macururé	BA	2919900
2066	Madre de Deus	BA	2919926
2067	Maetinga	BA	2919959
2068	Maiquinique	BA	2920007
2069	Mairi	BA	2920106
2070	Malhada	BA	2920205
2071	Malhada de Pedras	BA	2920304
2072	Manoel Vitorino	BA	2920403
2073	Mansidão	BA	2920452
2074	Maracás	BA	2920502
2075	Maragogipe	BA	2920601
2076	Maraú	BA	2920700
2077	Marcionílio Souza	BA	2920809
2078	Mascote	BA	2920908
2079	Mata de São João	BA	2921005
2080	Matina	BA	2921054
2081	Medeiros Neto	BA	2921104
2082	Miguel Calmon	BA	2921203
2083	Milagres	BA	2921302
2084	Mirangaba	BA	2921401
2085	Mirante	BA	2921450
2086	Monte Santo	BA	2921500
2087	Morpará	BA	2921609
2088	Morro do Chapéu	BA	2921708
2089	Mortugaba	BA	2921807
2090	Mucugê	BA	2921906
2091	Mucuri	BA	2922003
2092	Mulungu do Morro	BA	2922052
2093	Mundo Novo	BA	2922102
2094	Muniz Ferreira	BA	2922201
2095	Muquém de São Francisco	BA	2922250
2096	Muritiba	BA	2922300
2097	Mutuípe	BA	2922409
2098	Nazaré	BA	2922508
2099	Nilo Peçanha	BA	2922607
2100	Nordestina	BA	2922656
2101	Nova Canaã	BA	2922706
2102	Nova Fátima	BA	2922730
2103	Nova Ibiá	BA	2922755
2104	Nova Itarana	BA	2922805
2105	Nova Redenção	BA	2922854
2106	Nova Soure	BA	2922904
2107	Nova Viçosa	BA	2923001
2108	Novo Horizonte	BA	2923035
2109	Novo Triunfo	BA	2923050
2110	Olindina	BA	2923100
2111	Oliveira dos Brejinhos	BA	2923209
2112	Ouriçangas	BA	2923308
2113	Ourolândia	BA	2923357
2114	Palmas de Monte Alto	BA	2923407
2115	Palmeiras	BA	2923506
2116	Paramirim	BA	2923605
2117	Paratinga	BA	2923704
2118	Paripiranga	BA	2923803
2119	Pau Brasil	BA	2923902
2120	Paulo Afonso	BA	2924009
2121	Pé de Serra	BA	2924058
2122	Pedrão	BA	2924108
2123	Pedro Alexandre	BA	2924207
2124	Piatã	BA	2924306
2125	Pilão Arcado	BA	2924405
2126	Pindaí	BA	2924504
2127	Pindobaçu	BA	2924603
2128	Pintadas	BA	2924652
2129	Piraí do Norte	BA	2924678
2130	Piripá	BA	2924702
2131	Piritiba	BA	2924801
2132	Planaltino	BA	2924900
2133	Planalto	BA	2925006
2134	Poções	BA	2925105
2135	Pojuca	BA	2925204
2136	Ponto Novo	BA	2925253
2137	Porto Seguro	BA	2925303
2138	Potiraguá	BA	2925402
2139	Prado	BA	2925501
2140	Presidente Dutra	BA	2925600
2141	Presidente Jânio Quadros	BA	2925709
2142	Presidente Tancredo Neves	BA	2925758
2143	Queimadas	BA	2925808
2144	Quijingue	BA	2925907
2145	Quixabeira	BA	2925931
2146	Rafael Jambeiro	BA	2925956
2147	Remanso	BA	2926004
2148	Retirolândia	BA	2926103
2149	Riachão das Neves	BA	2926202
2150	Riachão do Jacuípe	BA	2926301
2151	Riacho de Santana	BA	2926400
2152	Ribeira do Amparo	BA	2926509
2153	Ribeira do Pombal	BA	2926608
2154	Ribeirão do Largo	BA	2926657
2155	Rio de Contas	BA	2926707
2156	Rio do Antônio	BA	2926806
2157	Rio do Pires	BA	2926905
2158	Rio Real	BA	2927002
2159	Rodelas	BA	2927101
2160	Ruy Barbosa	BA	2927200
2161	Salinas da Margarida	BA	2927309
2162	Salvador	BA	2927408
2163	Santa Bárbara	BA	2927507
2164	Santa Brígida	BA	2927606
2165	Santa Cruz Cabrália	BA	2927705
2166	Santa Cruz da Vitória	BA	2927804
2167	Santa Inês	BA	2927903
2168	Santa Luzia	BA	2928059
2169	Santa Maria da Vitória	BA	2928109
2170	Santa Rita de Cássia	BA	2928406
2171	Santa Teresinha	BA	2928505
2172	Santaluz	BA	2928000
2173	Santana	BA	2928208
2174	Santanópolis	BA	2928307
2175	Santo Amaro	BA	2928604
2176	Santo Antônio de Jesus	BA	2928703
2177	Santo Estêvão	BA	2928802
2178	São Desidério	BA	2928901
2179	São Domingos	BA	2928950
2180	São Felipe	BA	2929107
2181	São Félix	BA	2929008
2182	São Félix do Coribe	BA	2929057
2183	São Francisco do Conde	BA	2929206
2184	São Gabriel	BA	2929255
2185	São Gonçalo dos Campos	BA	2929305
2186	São José da Vitória	BA	2929354
2187	São José do Jacuípe	BA	2929370
2188	São Miguel das Matas	BA	2929404
2189	São Sebastião do Passé	BA	2929503
2190	Sapeaçu	BA	2929602
2191	Sátiro Dias	BA	2929701
2192	Saubara	BA	2929750
2193	Saúde	BA	2929800
2194	Seabra	BA	2929909
2195	Sebastião Laranjeiras	BA	2930006
2196	Senhor do Bonfim	BA	2930105
2197	Sento Sé	BA	2930204
2198	Serra do Ramalho	BA	2930154
2199	Serra Dourada	BA	2930303
2200	Serra Preta	BA	2930402
2201	Serrinha	BA	2930501
2202	Serrolândia	BA	2930600
2203	Simões Filho	BA	2930709
2204	Sítio do Mato	BA	2930758
2205	Sítio do Quinto	BA	2930766
2206	Sobradinho	BA	2930774
2207	Souto Soares	BA	2930808
2208	Tabocas do Brejo Velho	BA	2930907
2209	Tanhaçu	BA	2931004
2210	Tanque Novo	BA	2931053
2211	Tanquinho	BA	2931103
2212	Taperoá	BA	2931202
2213	Tapiramutá	BA	2931301
2214	Teixeira de Freitas	BA	2931350
2215	Teodoro Sampaio	BA	2931400
2216	Teofilândia	BA	2931509
2217	Teolândia	BA	2931608
2218	Terra Nova	BA	2931707
2219	Tremedal	BA	2931806
2220	Tucano	BA	2931905
2221	Uauá	BA	2932002
2222	Ubaíra	BA	2932101
2223	Ubaitaba	BA	2932200
2224	Ubatã	BA	2932309
2225	Uibaí	BA	2932408
2226	Umburanas	BA	2932457
2227	Una	BA	2932507
2228	Urandi	BA	2932606
2229	Uruçuca	BA	2932705
2230	Utinga	BA	2932804
2231	Valença	BA	2932903
2232	Valente	BA	2933000
2233	Várzea da Roça	BA	2933059
2234	Várzea do Poço	BA	2933109
2235	Várzea Nova	BA	2933158
2236	Varzedo	BA	2933174
2237	Vera Cruz	BA	2933208
2238	Vereda	BA	2933257
2239	Vitória da Conquista	BA	2933307
2240	Wagner	BA	2933406
2241	Wanderley	BA	2933455
2242	Wenceslau Guimarães	BA	2933505
2243	Xique-Xique	BA	2933604
2244	Abadia dos Dourados	MG	3100104
2245	Abaeté	MG	3100203
2246	Abre Campo	MG	3100302
2247	Acaiaca	MG	3100401
2248	Açucena	MG	3100500
2249	Água Boa	MG	3100609
2250	Água Comprida	MG	3100708
2251	Aguanil	MG	3100807
2252	Águas Formosas	MG	3100906
2253	Águas Vermelhas	MG	3101003
2254	Aimorés	MG	3101102
2255	Aiuruoca	MG	3101201
2256	Alagoa	MG	3101300
2257	Albertina	MG	3101409
2258	Além Paraíba	MG	3101508
2259	Alfenas	MG	3101607
2260	Alfredo Vasconcelos	MG	3101631
2261	Almenara	MG	3101706
2262	Alpercata	MG	3101805
2263	Alpinópolis	MG	3101904
2264	Alterosa	MG	3102001
2265	Alto Caparaó	MG	3102050
2266	Alto Jequitibá	MG	3153509
2267	Alto Rio Doce	MG	3102100
2268	Alvarenga	MG	3102209
2269	Alvinópolis	MG	3102308
2270	Alvorada de Minas	MG	3102407
2271	Amparo do Serra	MG	3102506
2272	Andradas	MG	3102605
2273	Andrelândia	MG	3102803
2274	Angelândia	MG	3102852
2275	Antônio Carlos	MG	3102902
2276	Antônio Dias	MG	3103009
2277	Antônio Prado de Minas	MG	3103108
2278	Araçaí	MG	3103207
2279	Aracitaba	MG	3103306
2280	Araçuaí	MG	3103405
2281	Araguari	MG	3103504
2282	Arantina	MG	3103603
2283	Araponga	MG	3103702
2284	Araporã	MG	3103751
2285	Arapuá	MG	3103801
2286	Araújos	MG	3103900
2287	Araxá	MG	3104007
2288	Arceburgo	MG	3104106
2289	Arcos	MG	3104205
2290	Areado	MG	3104304
2291	Argirita	MG	3104403
2292	Aricanduva	MG	3104452
2293	Arinos	MG	3104502
2294	Astolfo Dutra	MG	3104601
2295	Ataléia	MG	3104700
2296	Augusto de Lima	MG	3104809
2297	Baependi	MG	3104908
2298	Baldim	MG	3105004
2299	Bambuí	MG	3105103
2300	Bandeira	MG	3105202
2301	Bandeira do Sul	MG	3105301
2302	Barão de Cocais	MG	3105400
2303	Barão de Monte Alto	MG	3105509
2304	Barbacena	MG	3105608
2305	Barra Longa	MG	3105707
2306	Barroso	MG	3105905
2307	Bela Vista de Minas	MG	3106002
2308	Belmiro Braga	MG	3106101
2309	Belo Horizonte	MG	3106200
2310	Belo Oriente	MG	3106309
2311	Belo Vale	MG	3106408
2312	Berilo	MG	3106507
2313	Berizal	MG	3106655
2314	Bertópolis	MG	3106606
2315	Betim	MG	3106705
2316	Bias Fortes	MG	3106804
2317	Bicas	MG	3106903
2318	Biquinhas	MG	3107000
2319	Boa Esperança	MG	3107109
2320	Bocaina de Minas	MG	3107208
2321	Bocaiúva	MG	3107307
2322	Bom Despacho	MG	3107406
2323	Bom Jardim de Minas	MG	3107505
2324	Bom Jesus da Penha	MG	3107604
2325	Bom Jesus do Amparo	MG	3107703
2326	Bom Jesus do Galho	MG	3107802
2327	Bom Repouso	MG	3107901
2328	Bom Sucesso	MG	3108008
2329	Bonfim	MG	3108107
2330	Bonfinópolis de Minas	MG	3108206
2331	Bonito de Minas	MG	3108255
2332	Borda da Mata	MG	3108305
2333	Botelhos	MG	3108404
2334	Botumirim	MG	3108503
2335	Brás Pires	MG	3108701
2336	Brasilândia de Minas	MG	3108552
2337	Brasília de Minas	MG	3108602
2338	Brasópolis	MG	3108909
2339	Braúnas	MG	3108800
2340	Brumadinho	MG	3109006
2341	Bueno Brandão	MG	3109105
2342	Buenópolis	MG	3109204
2343	Bugre	MG	3109253
2344	Buritis	MG	3109303
2345	Buritizeiro	MG	3109402
2346	Cabeceira Grande	MG	3109451
2347	Cabo Verde	MG	3109501
2348	Cachoeira da Prata	MG	3109600
2349	Cachoeira de Minas	MG	3109709
2350	Cachoeira de Pajeú	MG	3102704
2351	Cachoeira Dourada	MG	3109808
2352	Caetanópolis	MG	3109907
2353	Caeté	MG	3110004
2354	Caiana	MG	3110103
2355	Cajuri	MG	3110202
2356	Caldas	MG	3110301
2357	Camacho	MG	3110400
2358	Camanducaia	MG	3110509
2359	Cambuí	MG	3110608
2360	Cambuquira	MG	3110707
2361	Campanário	MG	3110806
2362	Campanha	MG	3110905
2363	Campestre	MG	3111002
2364	Campina Verde	MG	3111101
2365	Campo Azul	MG	3111150
2366	Campo Belo	MG	3111200
2367	Campo do Meio	MG	3111309
2368	Campo Florido	MG	3111408
2369	Campos Altos	MG	3111507
2370	Campos Gerais	MG	3111606
2371	Cana Verde	MG	3111903
2372	Canaã	MG	3111705
2373	Canápolis	MG	3111804
2374	Candeias	MG	3112000
2375	Cantagalo	MG	3112059
2376	Caparaó	MG	3112109
2377	Capela Nova	MG	3112208
2378	Capelinha	MG	3112307
2379	Capetinga	MG	3112406
2380	Capim Branco	MG	3112505
2381	Capinópolis	MG	3112604
2382	Capitão Andrade	MG	3112653
2383	Capitão Enéas	MG	3112703
2384	Capitólio	MG	3112802
2385	Caputira	MG	3112901
2386	Caraí	MG	3113008
2387	Caranaíba	MG	3113107
2388	Carandaí	MG	3113206
2389	Carangola	MG	3113305
2390	Caratinga	MG	3113404
2391	Carbonita	MG	3113503
2392	Careaçu	MG	3113602
2393	Carlos Chagas	MG	3113701
2394	Carmésia	MG	3113800
2395	Carmo da Cachoeira	MG	3113909
2396	Carmo da Mata	MG	3114006
2397	Carmo de Minas	MG	3114105
2398	Carmo do Cajuru	MG	3114204
2399	Carmo do Paranaíba	MG	3114303
2400	Carmo do Rio Claro	MG	3114402
2401	Carmópolis de Minas	MG	3114501
2402	Carneirinho	MG	3114550
2403	Carrancas	MG	3114600
2404	Carvalhópolis	MG	3114709
2405	Carvalhos	MG	3114808
2406	Casa Grande	MG	3114907
2407	Cascalho Rico	MG	3115003
2408	Cássia	MG	3115102
2409	Cataguases	MG	3115300
2410	Catas Altas	MG	3115359
2411	Catas Altas da Noruega	MG	3115409
2412	Catuji	MG	3115458
2413	Catuti	MG	3115474
2414	Caxambu	MG	3115508
2415	Cedro do Abaeté	MG	3115607
2416	Central de Minas	MG	3115706
2417	Centralina	MG	3115805
2418	Chácara	MG	3115904
2419	Chalé	MG	3116001
2420	Chapada do Norte	MG	3116100
2421	Chapada Gaúcha	MG	3116159
2422	Chiador	MG	3116209
2423	Cipotânea	MG	3116308
2424	Claraval	MG	3116407
2425	Claro dos Poções	MG	3116506
2426	Cláudio	MG	3116605
2427	Coimbra	MG	3116704
2428	Coluna	MG	3116803
2429	Comendador Gomes	MG	3116902
2430	Comercinho	MG	3117009
2431	Conceição da Aparecida	MG	3117108
2432	Conceição da Barra de Minas	MG	3115201
2433	Conceição das Alagoas	MG	3117306
2434	Conceição das Pedras	MG	3117207
2435	Conceição de Ipanema	MG	3117405
2436	Conceição do Mato Dentro	MG	3117504
2437	Conceição do Pará	MG	3117603
2438	Conceição do Rio Verde	MG	3117702
2439	Conceição dos Ouros	MG	3117801
2440	Cônego Marinho	MG	3117836
2441	Confins	MG	3117876
2442	Congonhal	MG	3117900
2443	Congonhas	MG	3118007
2444	Congonhas do Norte	MG	3118106
2445	Conquista	MG	3118205
2446	Conselheiro Lafaiete	MG	3118304
2447	Conselheiro Pena	MG	3118403
2448	Consolação	MG	3118502
2449	Contagem	MG	3118601
2450	Coqueiral	MG	3118700
2451	Coração de Jesus	MG	3118809
2452	Cordisburgo	MG	3118908
2453	Cordislândia	MG	3119005
2454	Corinto	MG	3119104
2455	Coroaci	MG	3119203
2456	Coromandel	MG	3119302
2457	Coronel Fabriciano	MG	3119401
2458	Coronel Murta	MG	3119500
2459	Coronel Pacheco	MG	3119609
2460	Coronel Xavier Chaves	MG	3119708
2461	Córrego Danta	MG	3119807
2462	Córrego do Bom Jesus	MG	3119906
2463	Córrego Fundo	MG	3119955
2464	Córrego Novo	MG	3120003
2465	Couto de Magalhães de Minas	MG	3120102
2466	Crisólita	MG	3120151
2467	Cristais	MG	3120201
2468	Cristália	MG	3120300
2469	Cristiano Otoni	MG	3120409
2470	Cristina	MG	3120508
2471	Crucilândia	MG	3120607
2472	Cruzeiro da Fortaleza	MG	3120706
2473	Cruzília	MG	3120805
2474	Cuparaque	MG	3120839
2475	Curral de Dentro	MG	3120870
2476	Curvelo	MG	3120904
2477	Datas	MG	3121001
2478	Delfim Moreira	MG	3121100
2479	Delfinópolis	MG	3121209
2480	Delta	MG	3121258
2481	Descoberto	MG	3121308
2482	Desterro de Entre Rios	MG	3121407
2483	Desterro do Melo	MG	3121506
2484	Diamantina	MG	3121605
2485	Diogo de Vasconcelos	MG	3121704
2486	Dionísio	MG	3121803
2487	Divinésia	MG	3121902
2488	Divino	MG	3122009
2489	Divino das Laranjeiras	MG	3122108
2490	Divinolândia de Minas	MG	3122207
2491	Divinópolis	MG	3122306
2492	Divisa Alegre	MG	3122355
2493	Divisa Nova	MG	3122405
2494	Divisópolis	MG	3122454
2495	Dom Bosco	MG	3122470
2496	Dom Cavati	MG	3122504
2497	Dom Joaquim	MG	3122603
2498	Dom Silvério	MG	3122702
2499	Dom Viçoso	MG	3122801
2500	Dona Eusébia	MG	3122900
2501	Dores de Campos	MG	3123007
2502	Dores de Guanhães	MG	3123106
2503	Dores do Indaiá	MG	3123205
2504	Dores do Turvo	MG	3123304
2505	Doresópolis	MG	3123403
2506	Douradoquara	MG	3123502
2507	Durandé	MG	3123528
2508	Elói Mendes	MG	3123601
2509	Engenheiro Caldas	MG	3123700
2510	Engenheiro Navarro	MG	3123809
2511	Entre Folhas	MG	3123858
2512	Entre Rios de Minas	MG	3123908
2513	Ervália	MG	3124005
2514	Esmeraldas	MG	3124104
2515	Espera Feliz	MG	3124203
2516	Espinosa	MG	3124302
2517	Espírito Santo do Dourado	MG	3124401
2518	Estiva	MG	3124500
2519	Estrela Dalva	MG	3124609
2520	Estrela do Indaiá	MG	3124708
2521	Estrela do Sul	MG	3124807
2522	Eugenópolis	MG	3124906
2523	Ewbank da Câmara	MG	3125002
2524	Extrema	MG	3125101
2525	Fama	MG	3125200
2526	Faria Lemos	MG	3125309
2527	Felício dos Santos	MG	3125408
2528	Felisburgo	MG	3125606
2529	Felixlândia	MG	3125705
2530	Fernandes Tourinho	MG	3125804
2531	Ferros	MG	3125903
2532	Fervedouro	MG	3125952
2533	Florestal	MG	3126000
2534	Formiga	MG	3126109
2535	Formoso	MG	3126208
2536	Fortaleza de Minas	MG	3126307
2537	Fortuna de Minas	MG	3126406
2538	Francisco Badaró	MG	3126505
2539	Francisco Dumont	MG	3126604
2540	Francisco Sá	MG	3126703
2541	Franciscópolis	MG	3126752
2542	Frei Gaspar	MG	3126802
2543	Frei Inocêncio	MG	3126901
2544	Frei Lagonegro	MG	3126950
2545	Fronteira	MG	3127008
2546	Fronteira dos Vales	MG	3127057
2547	Fruta de Leite	MG	3127073
2548	Frutal	MG	3127107
2549	Funilândia	MG	3127206
2550	Galiléia	MG	3127305
2551	Gameleiras	MG	3127339
2552	Glaucilândia	MG	3127354
2553	Goiabeira	MG	3127370
2554	Goianá	MG	3127388
2555	Gonçalves	MG	3127404
2556	Gonzaga	MG	3127503
2557	Gouveia	MG	3127602
2558	Governador Valadares	MG	3127701
2559	Grão Mogol	MG	3127800
2560	Grupiara	MG	3127909
2561	Guanhães	MG	3128006
2562	Guapé	MG	3128105
2563	Guaraciaba	MG	3128204
2564	Guaraciama	MG	3128253
2565	Guaranésia	MG	3128303
2566	Guarani	MG	3128402
2567	Guarará	MG	3128501
2568	Guarda-Mor	MG	3128600
2569	Guaxupé	MG	3128709
2570	Guidoval	MG	3128808
2571	Guimarânia	MG	3128907
2572	Guiricema	MG	3129004
2573	Gurinhatã	MG	3129103
2574	Heliodora	MG	3129202
2575	Iapu	MG	3129301
2576	Ibertioga	MG	3129400
2577	Ibiá	MG	3129509
2578	Ibiaí	MG	3129608
2579	Ibiracatu	MG	3129657
2580	Ibiraci	MG	3129707
2581	Ibirité	MG	3129806
2582	Ibitiúra de Minas	MG	3129905
2583	Ibituruna	MG	3130002
2584	Icaraí de Minas	MG	3130051
2585	Igarapé	MG	3130101
2586	Igaratinga	MG	3130200
2587	Iguatama	MG	3130309
2588	Ijaci	MG	3130408
2589	Ilicínea	MG	3130507
2590	Imbé de Minas	MG	3130556
2591	Inconfidentes	MG	3130606
2592	Indaiabira	MG	3130655
2593	Indianópolis	MG	3130705
2594	Ingaí	MG	3130804
2595	Inhapim	MG	3130903
2596	Inhaúma	MG	3131000
2597	Inimutaba	MG	3131109
2598	Ipaba	MG	3131158
2599	Ipanema	MG	3131208
2600	Ipatinga	MG	3131307
2601	Ipiaçu	MG	3131406
2602	Ipuiúna	MG	3131505
2603	Iraí de Minas	MG	3131604
2604	Itabira	MG	3131703
2605	Itabirinha	MG	3131802
2606	Itabirito	MG	3131901
2607	Itacambira	MG	3132008
2608	Itacarambi	MG	3132107
2609	Itaguara	MG	3132206
2610	Itaipé	MG	3132305
2611	Itajubá	MG	3132404
2612	Itamarandiba	MG	3132503
2613	Itamarati de Minas	MG	3132602
2614	Itambacuri	MG	3132701
2615	Itambé do Mato Dentro	MG	3132800
2616	Itamogi	MG	3132909
2617	Itamonte	MG	3133006
2618	Itanhandu	MG	3133105
2619	Itanhomi	MG	3133204
2620	Itaobim	MG	3133303
2621	Itapagipe	MG	3133402
2622	Itapecerica	MG	3133501
2623	Itapeva	MG	3133600
2624	Itatiaiuçu	MG	3133709
2625	Itaú de Minas	MG	3133758
2626	Itaúna	MG	3133808
2627	Itaverava	MG	3133907
2628	Itinga	MG	3134004
2629	Itueta	MG	3134103
2630	Ituiutaba	MG	3134202
2631	Itumirim	MG	3134301
2632	Iturama	MG	3134400
2633	Itutinga	MG	3134509
2634	Jaboticatubas	MG	3134608
2635	Jacinto	MG	3134707
2636	Jacuí	MG	3134806
2637	Jacutinga	MG	3134905
2638	Jaguaraçu	MG	3135001
2639	Jaíba	MG	3135050
2640	Jampruca	MG	3135076
2641	Janaúba	MG	3135100
2642	Januária	MG	3135209
2643	Japaraíba	MG	3135308
2644	Japonvar	MG	3135357
2645	Jeceaba	MG	3135407
2646	Jenipapo de Minas	MG	3135456
2647	Jequeri	MG	3135506
2648	Jequitaí	MG	3135605
2649	Jequitibá	MG	3135704
2650	Jequitinhonha	MG	3135803
2651	Jesuânia	MG	3135902
2652	Joaíma	MG	3136009
2653	Joanésia	MG	3136108
2654	João Monlevade	MG	3136207
2655	João Pinheiro	MG	3136306
2656	Joaquim Felício	MG	3136405
2657	Jordânia	MG	3136504
2658	José Gonçalves de Minas	MG	3136520
2659	José Raydan	MG	3136553
2660	Josenópolis	MG	3136579
2661	Juatuba	MG	3136652
2662	Juiz de Fora	MG	3136702
2663	Juramento	MG	3136801
2664	Juruaia	MG	3136900
2665	Juvenília	MG	3136959
2666	Ladainha	MG	3137007
2667	Lagamar	MG	3137106
2668	Lagoa da Prata	MG	3137205
2669	Lagoa dos Patos	MG	3137304
2670	Lagoa Dourada	MG	3137403
2671	Lagoa Formosa	MG	3137502
2672	Lagoa Grande	MG	3137536
2673	Lagoa Santa	MG	3137601
2674	Lajinha	MG	3137700
2675	Lambari	MG	3137809
2676	Lamim	MG	3137908
2677	Laranjal	MG	3138005
2678	Lassance	MG	3138104
2679	Lavras	MG	3138203
2680	Leandro Ferreira	MG	3138302
2681	Leme do Prado	MG	3138351
2682	Leopoldina	MG	3138401
2683	Liberdade	MG	3138500
2684	Lima Duarte	MG	3138609
2685	Limeira do Oeste	MG	3138625
2686	Lontra	MG	3138658
2687	Luisburgo	MG	3138674
2688	Luislândia	MG	3138682
2689	Luminárias	MG	3138708
2690	Luz	MG	3138807
2691	Machacalis	MG	3138906
2692	Machado	MG	3139003
2693	Madre de Deus de Minas	MG	3139102
2694	Malacacheta	MG	3139201
2695	Mamonas	MG	3139250
2696	Manga	MG	3139300
2697	Manhuaçu	MG	3139409
2698	Manhumirim	MG	3139508
2699	Mantena	MG	3139607
2700	Mar de Espanha	MG	3139805
2701	Maravilhas	MG	3139706
2702	Maria da Fé	MG	3139904
2703	Mariana	MG	3140001
2704	Marilac	MG	3140100
2705	Mário Campos	MG	3140159
2706	Maripá de Minas	MG	3140209
2707	Marliéria	MG	3140308
2708	Marmelópolis	MG	3140407
2709	Martinho Campos	MG	3140506
2710	Martins Soares	MG	3140530
2711	Mata Verde	MG	3140555
2712	Materlândia	MG	3140605
2713	Mateus Leme	MG	3140704
2714	Mathias Lobato	MG	3171501
2715	Matias Barbosa	MG	3140803
2716	Matias Cardoso	MG	3140852
2717	Matipó	MG	3140902
2718	Mato Verde	MG	3141009
2719	Matozinhos	MG	3141108
2720	Matutina	MG	3141207
2721	Medeiros	MG	3141306
2722	Medina	MG	3141405
2723	Mendes Pimentel	MG	3141504
2724	Mercês	MG	3141603
2725	Mesquita	MG	3141702
2726	Minas Novas	MG	3141801
2727	Minduri	MG	3141900
2728	Mirabela	MG	3142007
2729	Miradouro	MG	3142106
2730	Miraí	MG	3142205
2731	Miravânia	MG	3142254
2732	Moeda	MG	3142304
2733	Moema	MG	3142403
2734	Monjolos	MG	3142502
2735	Monsenhor Paulo	MG	3142601
2736	Montalvânia	MG	3142700
2737	Monte Alegre de Minas	MG	3142809
2738	Monte Azul	MG	3142908
2739	Monte Belo	MG	3143005
2740	Monte Carmelo	MG	3143104
2741	Monte Formoso	MG	3143153
2742	Monte Santo de Minas	MG	3143203
2743	Monte Sião	MG	3143401
2744	Montes Claros	MG	3143302
2745	Montezuma	MG	3143450
2746	Morada Nova de Minas	MG	3143500
2747	Morro da Garça	MG	3143609
2748	Morro do Pilar	MG	3143708
2749	Munhoz	MG	3143807
2750	Muriaé	MG	3143906
2751	Mutum	MG	3144003
2752	Muzambinho	MG	3144102
2753	Nacip Raydan	MG	3144201
2754	Nanuque	MG	3144300
2755	Naque	MG	3144359
2756	Natalândia	MG	3144375
2757	Natércia	MG	3144409
2758	Nazareno	MG	3144508
2759	Nepomuceno	MG	3144607
2760	Ninheira	MG	3144656
2761	Nova Belém	MG	3144672
2762	Nova Era	MG	3144706
2763	Nova Lima	MG	3144805
2764	Nova Módica	MG	3144904
2765	Nova Ponte	MG	3145000
2766	Nova Porteirinha	MG	3145059
2767	Nova Resende	MG	3145109
2768	Nova Serrana	MG	3145208
2769	Nova União	MG	3136603
2770	Novo Cruzeiro	MG	3145307
2771	Novo Oriente de Minas	MG	3145356
2772	Novorizonte	MG	3145372
2773	Olaria	MG	3145406
2774	Olhos-d'Água	MG	3145455
2775	Olímpio Noronha	MG	3145505
2776	Oliveira	MG	3145604
2777	Oliveira Fortes	MG	3145703
2778	Onça de Pitangui	MG	3145802
2779	Oratórios	MG	3145851
2780	Orizânia	MG	3145877
2781	Ouro Branco	MG	3145901
2782	Ouro Fino	MG	3146008
2783	Ouro Preto	MG	3146107
2784	Ouro Verde de Minas	MG	3146206
2785	Padre Carvalho	MG	3146255
2786	Padre Paraíso	MG	3146305
2787	Pai Pedro	MG	3146552
2788	Paineiras	MG	3146404
2789	Pains	MG	3146503
2790	Paiva	MG	3146602
2791	Palma	MG	3146701
2792	Palmópolis	MG	3146750
2793	Papagaios	MG	3146909
2794	Pará de Minas	MG	3147105
2795	Paracatu	MG	3147006
2796	Paraguaçu	MG	3147204
2797	Paraisópolis	MG	3147303
2798	Paraopeba	MG	3147402
2799	Passa Quatro	MG	3147600
2800	Passa Tempo	MG	3147709
2801	Passabém	MG	3147501
2802	Passa-Vinte	MG	3147808
2803	Passos	MG	3147907
2804	Patis	MG	3147956
2805	Patos de Minas	MG	3148004
2806	Patrocínio	MG	3148103
2807	Patrocínio do Muriaé	MG	3148202
2808	Paula Cândido	MG	3148301
2809	Paulistas	MG	3148400
2810	Pavão	MG	3148509
2811	Peçanha	MG	3148608
2812	Pedra Azul	MG	3148707
2813	Pedra Bonita	MG	3148756
2814	Pedra do Anta	MG	3148806
2815	Pedra do Indaiá	MG	3148905
2816	Pedra Dourada	MG	3149002
2817	Pedralva	MG	3149101
2818	Pedras de Maria da Cruz	MG	3149150
2819	Pedrinópolis	MG	3149200
2820	Pedro Leopoldo	MG	3149309
2821	Pedro Teixeira	MG	3149408
2822	Pequeri	MG	3149507
2823	Pequi	MG	3149606
2824	Perdigão	MG	3149705
2825	Perdizes	MG	3149804
2826	Perdões	MG	3149903
2827	Periquito	MG	3149952
2828	Pescador	MG	3150000
2829	Piau	MG	3150109
2830	Piedade de Caratinga	MG	3150158
2831	Piedade de Ponte Nova	MG	3150208
2832	Piedade do Rio Grande	MG	3150307
2833	Piedade dos Gerais	MG	3150406
2834	Pimenta	MG	3150505
2835	Pingo-d'Água	MG	3150539
2836	Pintópolis	MG	3150570
2837	Piracema	MG	3150604
2838	Pirajuba	MG	3150703
2839	Piranga	MG	3150802
2840	Piranguçu	MG	3150901
2841	Piranguinho	MG	3151008
2842	Pirapetinga	MG	3151107
2843	Pirapora	MG	3151206
2844	Piraúba	MG	3151305
2845	Pitangui	MG	3151404
2846	Piumhi	MG	3151503
2847	Planura	MG	3151602
2848	Poço Fundo	MG	3151701
2849	Poços de Caldas	MG	3151800
2850	Pocrane	MG	3151909
2851	Pompéu	MG	3152006
2852	Ponte Nova	MG	3152105
2853	Ponto Chique	MG	3152131
2854	Ponto dos Volantes	MG	3152170
2855	Porteirinha	MG	3152204
2856	Porto Firme	MG	3152303
2857	Poté	MG	3152402
2858	Pouso Alegre	MG	3152501
2859	Pouso Alto	MG	3152600
2860	Prados	MG	3152709
2861	Prata	MG	3152808
2862	Pratápolis	MG	3152907
2863	Pratinha	MG	3153004
2864	Presidente Bernardes	MG	3153103
2865	Presidente Juscelino	MG	3153202
2866	Presidente Kubitschek	MG	3153301
2867	Presidente Olegário	MG	3153400
2868	Prudente de Morais	MG	3153608
2869	Quartel Geral	MG	3153707
2870	Queluzito	MG	3153806
2871	Raposos	MG	3153905
2872	Raul Soares	MG	3154002
2873	Recreio	MG	3154101
2874	Reduto	MG	3154150
2875	Resende Costa	MG	3154200
2876	Resplendor	MG	3154309
2877	Ressaquinha	MG	3154408
2878	Riachinho	MG	3154457
2879	Riacho dos Machados	MG	3154507
2880	Ribeirão das Neves	MG	3154606
2881	Ribeirão Vermelho	MG	3154705
2882	Rio Acima	MG	3154804
2883	Rio Casca	MG	3154903
2884	Rio do Prado	MG	3155108
2885	Rio Doce	MG	3155009
2886	Rio Espera	MG	3155207
2887	Rio Manso	MG	3155306
2888	Rio Novo	MG	3155405
2889	Rio Paranaíba	MG	3155504
2890	Rio Pardo de Minas	MG	3155603
2891	Rio Piracicaba	MG	3155702
2892	Rio Pomba	MG	3155801
2893	Rio Preto	MG	3155900
2894	Rio Vermelho	MG	3156007
2895	Ritápolis	MG	3156106
2896	Rochedo de Minas	MG	3156205
2897	Rodeiro	MG	3156304
2898	Romaria	MG	3156403
2899	Rosário da Limeira	MG	3156452
2900	Rubelita	MG	3156502
2901	Rubim	MG	3156601
2902	Sabará	MG	3156700
2903	Sabinópolis	MG	3156809
2904	Sacramento	MG	3156908
2905	Salinas	MG	3157005
2906	Salto da Divisa	MG	3157104
2907	Santa Bárbara	MG	3157203
2908	Santa Bárbara do Leste	MG	3157252
2909	Santa Bárbara do Monte Verde	MG	3157278
2910	Santa Bárbara do Tugúrio	MG	3157302
2911	Santa Cruz de Minas	MG	3157336
2912	Santa Cruz de Salinas	MG	3157377
2913	Santa Cruz do Escalvado	MG	3157401
2914	Santa Efigênia de Minas	MG	3157500
2915	Santa Fé de Minas	MG	3157609
2916	Santa Helena de Minas	MG	3157658
2917	Santa Juliana	MG	3157708
2918	Santa Luzia	MG	3157807
2919	Santa Margarida	MG	3157906
2920	Santa Maria de Itabira	MG	3158003
2921	Santa Maria do Salto	MG	3158102
2922	Santa Maria do Suaçuí	MG	3158201
2923	Santa Rita de Caldas	MG	3159209
2924	Santa Rita de Ibitipoca	MG	3159407
2925	Santa Rita de Jacutinga	MG	3159308
2926	Santa Rita de Minas	MG	3159357
2927	Santa Rita do Itueto	MG	3159506
2928	Santa Rita do Sapucaí	MG	3159605
2929	Santa Rosa da Serra	MG	3159704
2930	Santa Vitória	MG	3159803
2931	Santana da Vargem	MG	3158300
2932	Santana de Cataguases	MG	3158409
2933	Santana de Pirapama	MG	3158508
2934	Santana do Deserto	MG	3158607
2935	Santana do Garambéu	MG	3158706
2936	Santana do Jacaré	MG	3158805
2937	Santana do Manhuaçu	MG	3158904
2938	Santana do Paraíso	MG	3158953
2939	Santana do Riacho	MG	3159001
2940	Santana dos Montes	MG	3159100
2941	Santo Antônio do Amparo	MG	3159902
2942	Santo Antônio do Aventureiro	MG	3160009
2943	Santo Antônio do Grama	MG	3160108
2944	Santo Antônio do Itambé	MG	3160207
2945	Santo Antônio do Jacinto	MG	3160306
2946	Santo Antônio do Monte	MG	3160405
2947	Santo Antônio do Retiro	MG	3160454
2948	Santo Antônio do Rio Abaixo	MG	3160504
2949	Santo Hipólito	MG	3160603
2950	Santos Dumont	MG	3160702
2951	São Bento Abade	MG	3160801
2952	São Brás do Suaçuí	MG	3160900
2953	São Domingos das Dores	MG	3160959
2954	São Domingos do Prata	MG	3161007
2955	São Félix de Minas	MG	3161056
2956	São Francisco	MG	3161106
2957	São Francisco de Paula	MG	3161205
2958	São Francisco de Sales	MG	3161304
2959	São Francisco do Glória	MG	3161403
2960	São Geraldo	MG	3161502
2961	São Geraldo da Piedade	MG	3161601
2962	São Geraldo do Baixio	MG	3161650
2963	São Gonçalo do Abaeté	MG	3161700
2964	São Gonçalo do Pará	MG	3161809
2965	São Gonçalo do Rio Abaixo	MG	3161908
2966	São Gonçalo do Rio Preto	MG	3125507
2967	São Gonçalo do Sapucaí	MG	3162005
2968	São Gotardo	MG	3162104
2969	São João Batista do Glória	MG	3162203
2970	São João da Lagoa	MG	3162252
2971	São João da Mata	MG	3162302
2972	São João da Ponte	MG	3162401
2973	São João das Missões	MG	3162450
2974	São João del Rei	MG	3162500
2975	São João do Manhuaçu	MG	3162559
2976	São João do Manteninha	MG	3162575
2977	São João do Oriente	MG	3162609
2978	São João do Pacuí	MG	3162658
2979	São João do Paraíso	MG	3162708
2980	São João Evangelista	MG	3162807
2981	São João Nepomuceno	MG	3162906
2982	São Joaquim de Bicas	MG	3162922
2983	São José da Barra	MG	3162948
2984	São José da Lapa	MG	3162955
2985	São José da Safira	MG	3163003
2986	São José da Varginha	MG	3163102
2987	São José do Alegre	MG	3163201
2988	São José do Divino	MG	3163300
2989	São José do Goiabal	MG	3163409
2990	São José do Jacuri	MG	3163508
2991	São José do Mantimento	MG	3163607
2992	São Lourenço	MG	3163706
2993	São Miguel do Anta	MG	3163805
2994	São Pedro da União	MG	3163904
2995	São Pedro do Suaçuí	MG	3164100
2996	São Pedro dos Ferros	MG	3164001
2997	São Romão	MG	3164209
2998	São Roque de Minas	MG	3164308
2999	São Sebastião da Bela Vista	MG	3164407
3000	São Sebastião da Vargem Alegre	MG	3164431
3001	São Sebastião do Anta	MG	3164472
3002	São Sebastião do Maranhão	MG	3164506
3003	São Sebastião do Oeste	MG	3164605
3004	São Sebastião do Paraíso	MG	3164704
3005	São Sebastião do Rio Preto	MG	3164803
3006	São Sebastião do Rio Verde	MG	3164902
3007	São Thomé das Letras	MG	3165206
3008	São Tiago	MG	3165008
3009	São Tomás de Aquino	MG	3165107
3010	São Vicente de Minas	MG	3165305
3011	Sapucaí-Mirim	MG	3165404
3012	Sardoá	MG	3165503
3013	Sarzedo	MG	3165537
3014	Sem-Peixe	MG	3165560
3015	Senador Amaral	MG	3165578
3016	Senador Cortes	MG	3165602
3017	Senador Firmino	MG	3165701
3018	Senador José Bento	MG	3165800
3019	Senador Modestino Gonçalves	MG	3165909
3020	Senhora de Oliveira	MG	3166006
3021	Senhora do Porto	MG	3166105
3022	Senhora dos Remédios	MG	3166204
3023	Sericita	MG	3166303
3024	Seritinga	MG	3166402
3025	Serra Azul de Minas	MG	3166501
3026	Serra da Saudade	MG	3166600
3027	Serra do Salitre	MG	3166808
3028	Serra dos Aimorés	MG	3166709
3029	Serrania	MG	3166907
3030	Serranópolis de Minas	MG	3166956
3031	Serranos	MG	3167004
3032	Serro	MG	3167103
3033	Sete Lagoas	MG	3167202
3034	Setubinha	MG	3165552
3035	Silveirânia	MG	3167301
3036	Silvianópolis	MG	3167400
3037	Simão Pereira	MG	3167509
3038	Simonésia	MG	3167608
3039	Sobrália	MG	3167707
3040	Soledade de Minas	MG	3167806
3041	Tabuleiro	MG	3167905
3042	Taiobeiras	MG	3168002
3043	Taparuba	MG	3168051
3044	Tapira	MG	3168101
3045	Tapiraí	MG	3168200
3046	Taquaraçu de Minas	MG	3168309
3047	Tarumirim	MG	3168408
3048	Teixeiras	MG	3168507
3049	Teófilo Otoni	MG	3168606
3050	Timóteo	MG	3168705
3051	Tiradentes	MG	3168804
3052	Tiros	MG	3168903
3053	Tocantins	MG	3169000
3054	Tocos do Moji	MG	3169059
3055	Toledo	MG	3169109
3056	Tombos	MG	3169208
3057	Três Corações	MG	3169307
3058	Três Marias	MG	3169356
3059	Três Pontas	MG	3169406
3060	Tumiritinga	MG	3169505
3061	Tupaciguara	MG	3169604
3062	Turmalina	MG	3169703
3063	Turvolândia	MG	3169802
3064	Ubá	MG	3169901
3065	Ubaí	MG	3170008
3066	Ubaporanga	MG	3170057
3067	Uberaba	MG	3170107
3068	Uberlândia	MG	3170206
3069	Umburatiba	MG	3170305
3070	Unaí	MG	3170404
3071	União de Minas	MG	3170438
3072	Uruana de Minas	MG	3170479
3073	Urucânia	MG	3170503
3074	Urucuia	MG	3170529
3075	Vargem Alegre	MG	3170578
3076	Vargem Bonita	MG	3170602
3077	Vargem Grande do Rio Pardo	MG	3170651
3078	Varginha	MG	3170701
3079	Varjão de Minas	MG	3170750
3080	Várzea da Palma	MG	3170800
3081	Varzelândia	MG	3170909
3082	Vazante	MG	3171006
3083	Verdelândia	MG	3171030
3084	Veredinha	MG	3171071
3085	Veríssimo	MG	3171105
3086	Vermelho Novo	MG	3171154
3087	Vespasiano	MG	3171204
3088	Viçosa	MG	3171303
3089	Vieiras	MG	3171402
3090	Virgem da Lapa	MG	3171600
3091	Virgínia	MG	3171709
3092	Virginópolis	MG	3171808
3093	Virgolândia	MG	3171907
3094	Visconde do Rio Branco	MG	3172004
3095	Volta Grande	MG	3172103
3096	Wenceslau Braz	MG	3172202
3097	Afonso Cláudio	ES	3200102
3098	Água Doce do Norte	ES	3200169
3099	Águia Branca	ES	3200136
3100	Alegre	ES	3200201
3101	Alfredo Chaves	ES	3200300
3102	Alto Rio Novo	ES	3200359
3103	Anchieta	ES	3200409
3104	Apiacá	ES	3200508
3105	Aracruz	ES	3200607
3106	Atilio Vivacqua	ES	3200706
3107	Baixo Guandu	ES	3200805
3108	Barra de São Francisco	ES	3200904
3109	Boa Esperança	ES	3201001
3110	Bom Jesus do Norte	ES	3201100
3111	Brejetuba	ES	3201159
3112	Cachoeiro de Itapemirim	ES	3201209
3113	Cariacica	ES	3201308
3114	Castelo	ES	3201407
3115	Colatina	ES	3201506
3116	Conceição da Barra	ES	3201605
3117	Conceição do Castelo	ES	3201704
3118	Divino de São Lourenço	ES	3201803
3119	Domingos Martins	ES	3201902
3120	Dores do Rio Preto	ES	3202009
3121	Ecoporanga	ES	3202108
3122	Fundão	ES	3202207
3123	Governador Lindenberg	ES	3202256
3124	Guaçuí	ES	3202306
3125	Guarapari	ES	3202405
3126	Ibatiba	ES	3202454
3127	Ibiraçu	ES	3202504
3128	Ibitirama	ES	3202553
3129	Iconha	ES	3202603
3130	Irupi	ES	3202652
3131	Itaguaçu	ES	3202702
3132	Itapemirim	ES	3202801
3133	Itarana	ES	3202900
3134	Iúna	ES	3203007
3135	Jaguaré	ES	3203056
3136	Jerônimo Monteiro	ES	3203106
3137	João Neiva	ES	3203130
3138	Laranja da Terra	ES	3203163
3139	Linhares	ES	3203205
3140	Mantenópolis	ES	3203304
3141	Marataízes	ES	3203320
3142	Marechal Floriano	ES	3203346
3143	Marilândia	ES	3203353
3144	Mimoso do Sul	ES	3203403
3145	Montanha	ES	3203502
3146	Mucurici	ES	3203601
3147	Muniz Freire	ES	3203700
3148	Muqui	ES	3203809
3149	Nova Venécia	ES	3203908
3150	Pancas	ES	3204005
3151	Pedro Canário	ES	3204054
3152	Pinheiros	ES	3204104
3153	Piúma	ES	3204203
3154	Ponto Belo	ES	3204252
3155	Presidente Kennedy	ES	3204302
3156	Rio Bananal	ES	3204351
3157	Rio Novo do Sul	ES	3204401
3158	Santa Leopoldina	ES	3204500
3159	Santa Maria de Jetibá	ES	3204559
3160	Santa Teresa	ES	3204609
3161	São Domingos do Norte	ES	3204658
3162	São Gabriel da Palha	ES	3204708
3163	São José do Calçado	ES	3204807
3164	São Mateus	ES	3204906
3165	São Roque do Canaã	ES	3204955
3166	Serra	ES	3205002
3167	Sooretama	ES	3205010
3168	Vargem Alta	ES	3205036
3169	Venda Nova do Imigrante	ES	3205069
3170	Viana	ES	3205101
3171	Vila Pavão	ES	3205150
3172	Vila Valério	ES	3205176
3173	Vila Velha	ES	3205200
3174	Vitória	ES	3205309
3175	Angra dos Reis	RJ	3300100
3176	Aperibé	RJ	3300159
3177	Araruama	RJ	3300209
3178	Areal	RJ	3300225
3179	Armação dos Búzios	RJ	3300233
3180	Arraial do Cabo	RJ	3300258
3181	Barra do Piraí	RJ	3300308
3182	Barra Mansa	RJ	3300407
3183	Belford Roxo	RJ	3300456
3184	Bom Jardim	RJ	3300506
3185	Bom Jesus do Itabapoana	RJ	3300605
3186	Cabo Frio	RJ	3300704
3187	Cachoeiras de Macacu	RJ	3300803
3188	Cambuci	RJ	3300902
3189	Campos dos Goytacazes	RJ	3301009
3190	Cantagalo	RJ	3301108
3191	Carapebus	RJ	3300936
3192	Cardoso Moreira	RJ	3301157
3193	Carmo	RJ	3301207
3194	Casimiro de Abreu	RJ	3301306
3195	Comendador Levy Gasparian	RJ	3300951
3196	Conceição de Macabu	RJ	3301405
3197	Cordeiro	RJ	3301504
3198	Duas Barras	RJ	3301603
3199	Duque de Caxias	RJ	3301702
3200	Engenheiro Paulo de Frontin	RJ	3301801
3201	Guapimirim	RJ	3301850
3202	Iguaba Grande	RJ	3301876
3203	Itaboraí	RJ	3301900
3204	Itaguaí	RJ	3302007
3205	Italva	RJ	3302056
3206	Itaocara	RJ	3302106
3207	Itaperuna	RJ	3302205
3208	Itatiaia	RJ	3302254
3209	Japeri	RJ	3302270
3210	Laje do Muriaé	RJ	3302304
3211	Macaé	RJ	3302403
3212	Macuco	RJ	3302452
3213	Magé	RJ	3302502
3214	Mangaratiba	RJ	3302601
3215	Maricá	RJ	3302700
3216	Mendes	RJ	3302809
3217	Mesquita	RJ	3302858
3218	Miguel Pereira	RJ	3302908
3219	Miracema	RJ	3303005
3220	Natividade	RJ	3303104
3221	Nilópolis	RJ	3303203
3222	Niterói	RJ	3303302
3223	Nova Friburgo	RJ	3303401
3224	Nova Iguaçu	RJ	3303500
3225	Paracambi	RJ	3303609
3226	Paraíba do Sul	RJ	3303708
3227	Paraty	RJ	3303807
3228	Paty do Alferes	RJ	3303856
3229	Petrópolis	RJ	3303906
3230	Pinheiral	RJ	3303955
3231	Piraí	RJ	3304003
3232	Porciúncula	RJ	3304102
3233	Porto Real	RJ	3304110
3234	Quatis	RJ	3304128
3235	Queimados	RJ	3304144
3236	Quissamã	RJ	3304151
3237	Resende	RJ	3304201
3238	Rio Bonito	RJ	3304300
3239	Rio Claro	RJ	3304409
3240	Rio das Flores	RJ	3304508
3241	Rio das Ostras	RJ	3304524
3242	Rio de Janeiro	RJ	3304557
3243	Santa Maria Madalena	RJ	3304607
3244	Santo Antônio de Pádua	RJ	3304706
3245	São Fidélis	RJ	3304805
3246	São Francisco de Itabapoana	RJ	3304755
3247	São Gonçalo	RJ	3304904
3248	São João da Barra	RJ	3305000
3249	São João de Meriti	RJ	3305109
3250	São José de Ubá	RJ	3305133
3251	São José do Vale do Rio Preto	RJ	3305158
3252	São Pedro da Aldeia	RJ	3305208
3253	São Sebastião do Alto	RJ	3305307
3254	Sapucaia	RJ	3305406
3255	Saquarema	RJ	3305505
3256	Seropédica	RJ	3305554
3257	Silva Jardim	RJ	3305604
3258	Sumidouro	RJ	3305703
3259	Tanguá	RJ	3305752
3260	Teresópolis	RJ	3305802
3261	Trajano de Moraes	RJ	3305901
3262	Três Rios	RJ	3306008
3263	Valença	RJ	3306107
3264	Varre-Sai	RJ	3306156
3265	Vassouras	RJ	3306206
3266	Volta Redonda	RJ	3306305
3267	Adamantina	SP	3500105
3268	Adolfo	SP	3500204
3269	Aguaí	SP	3500303
3270	Águas da Prata	SP	3500402
3271	Águas de Lindóia	SP	3500501
3272	Águas de Santa Bárbara	SP	3500550
3273	Águas de São Pedro	SP	3500600
3274	Agudos	SP	3500709
3275	Alambari	SP	3500758
3276	Alfredo Marcondes	SP	3500808
3277	Altair	SP	3500907
3278	Altinópolis	SP	3501004
3279	Alto Alegre	SP	3501103
3280	Alumínio	SP	3501152
3281	Álvares Florence	SP	3501202
3282	Álvares Machado	SP	3501301
3283	Álvaro de Carvalho	SP	3501400
3284	Alvinlândia	SP	3501509
3285	Americana	SP	3501608
3286	Américo Brasiliense	SP	3501707
3287	Américo de Campos	SP	3501806
3288	Amparo	SP	3501905
3289	Analândia	SP	3502002
3290	Andradina	SP	3502101
3291	Angatuba	SP	3502200
3292	Anhembi	SP	3502309
3293	Anhumas	SP	3502408
3294	Aparecida	SP	3502507
3295	Aparecida d'Oeste	SP	3502606
3296	Apiaí	SP	3502705
3297	Araçariguama	SP	3502754
3298	Araçatuba	SP	3502804
3299	Araçoiaba da Serra	SP	3502903
3300	Aramina	SP	3503000
3301	Arandu	SP	3503109
3302	Arapeí	SP	3503158
3303	Araraquara	SP	3503208
3304	Araras	SP	3503307
3305	Arco-Íris	SP	3503356
3306	Arealva	SP	3503406
3307	Areias	SP	3503505
3308	Areiópolis	SP	3503604
3309	Ariranha	SP	3503703
3310	Artur Nogueira	SP	3503802
3311	Arujá	SP	3503901
3312	Aspásia	SP	3503950
3313	Assis	SP	3504008
3314	Atibaia	SP	3504107
3315	Auriflama	SP	3504206
3316	Avaí	SP	3504305
3317	Avanhandava	SP	3504404
3318	Avaré	SP	3504503
3319	Bady Bassitt	SP	3504602
3320	Balbinos	SP	3504701
3321	Bálsamo	SP	3504800
3322	Bananal	SP	3504909
3323	Barão de Antonina	SP	3505005
3324	Barbosa	SP	3505104
3325	Bariri	SP	3505203
3326	Barra Bonita	SP	3505302
3327	Barra do Chapéu	SP	3505351
3328	Barra do Turvo	SP	3505401
3329	Barretos	SP	3505500
3330	Barrinha	SP	3505609
3331	Barueri	SP	3505708
3332	Bastos	SP	3505807
3333	Batatais	SP	3505906
3334	Bauru	SP	3506003
3335	Bebedouro	SP	3506102
3336	Bento de Abreu	SP	3506201
3337	Bernardino de Campos	SP	3506300
3338	Bertioga	SP	3506359
3339	Bilac	SP	3506409
3340	Birigui	SP	3506508
3341	Biritiba-Mirim	SP	3506607
3342	Boa Esperança do Sul	SP	3506706
3343	Bocaina	SP	3506805
3344	Bofete	SP	3506904
3345	Boituva	SP	3507001
3346	Bom Jesus dos Perdões	SP	3507100
3347	Bom Sucesso de Itararé	SP	3507159
3348	Borá	SP	3507209
3349	Boracéia	SP	3507308
3350	Borborema	SP	3507407
3351	Borebi	SP	3507456
3352	Botucatu	SP	3507506
3353	Bragança Paulista	SP	3507605
3354	Braúna	SP	3507704
3355	Brejo Alegre	SP	3507753
3356	Brodowski	SP	3507803
3357	Brotas	SP	3507902
3358	Buri	SP	3508009
3359	Buritama	SP	3508108
3360	Buritizal	SP	3508207
3361	Cabrália Paulista	SP	3508306
3362	Cabreúva	SP	3508405
3363	Caçapava	SP	3508504
3364	Cachoeira Paulista	SP	3508603
3365	Caconde	SP	3508702
3366	Cafelândia	SP	3508801
3367	Caiabu	SP	3508900
3368	Caieiras	SP	3509007
3369	Caiuá	SP	3509106
3370	Cajamar	SP	3509205
3371	Cajati	SP	3509254
3372	Cajobi	SP	3509304
3373	Cajuru	SP	3509403
3374	Campina do Monte Alegre	SP	3509452
3375	Campinas	SP	3509502
3376	Campo Limpo Paulista	SP	3509601
3377	Campos do Jordão	SP	3509700
3378	Campos Novos Paulista	SP	3509809
3379	Cananéia	SP	3509908
3380	Canas	SP	3509957
3381	Cândido Mota	SP	3510005
3382	Cândido Rodrigues	SP	3510104
3383	Canitar	SP	3510153
3384	Capão Bonito	SP	3510203
3385	Capela do Alto	SP	3510302
3386	Capivari	SP	3510401
3387	Caraguatatuba	SP	3510500
3388	Carapicuíba	SP	3510609
3389	Cardoso	SP	3510708
3390	Casa Branca	SP	3510807
3391	Cássia dos Coqueiros	SP	3510906
3392	Castilho	SP	3511003
3393	Catanduva	SP	3511102
3394	Catiguá	SP	3511201
3395	Cedral	SP	3511300
3396	Cerqueira César	SP	3511409
3397	Cerquilho	SP	3511508
3398	Cesário Lange	SP	3511607
3399	Charqueada	SP	3511706
3400	Chavantes	SP	3557204
3401	Clementina	SP	3511904
3402	Colina	SP	3512001
3403	Colômbia	SP	3512100
3404	Conchal	SP	3512209
3405	Conchas	SP	3512308
3406	Cordeirópolis	SP	3512407
3407	Coroados	SP	3512506
3408	Coronel Macedo	SP	3512605
3409	Corumbataí	SP	3512704
3410	Cosmópolis	SP	3512803
3411	Cosmorama	SP	3512902
3412	Cotia	SP	3513009
3413	Cravinhos	SP	3513108
3414	Cristais Paulista	SP	3513207
3415	Cruzália	SP	3513306
3416	Cruzeiro	SP	3513405
3417	Cubatão	SP	3513504
3418	Cunha	SP	3513603
3419	Descalvado	SP	3513702
3420	Diadema	SP	3513801
3421	Dirce Reis	SP	3513850
3422	Divinolândia	SP	3513900
3423	Dobrada	SP	3514007
3424	Dois Córregos	SP	3514106
3425	Dolcinópolis	SP	3514205
3426	Dourado	SP	3514304
3427	Dracena	SP	3514403
3428	Duartina	SP	3514502
3429	Dumont	SP	3514601
3430	Echaporã	SP	3514700
3431	Eldorado	SP	3514809
3432	Elias Fausto	SP	3514908
3433	Elisiário	SP	3514924
3434	Embaúba	SP	3514957
3435	Embu	SP	3515004
3436	Embu-Guaçu	SP	3515103
3437	Emilianópolis	SP	3515129
3438	Engenheiro Coelho	SP	3515152
3439	Espírito Santo do Pinhal	SP	3515186
3440	Espírito Santo do Turvo	SP	3515194
3441	Estiva Gerbi	SP	3557303
3442	Estrela do Norte	SP	3515301
3443	Estrela d'Oeste	SP	3515202
3444	Euclides da Cunha Paulista	SP	3515350
3445	Fartura	SP	3515400
3446	Fernando Prestes	SP	3515608
3447	Fernandópolis	SP	3515509
3448	Fernão	SP	3515657
3449	Ferraz de Vasconcelos	SP	3515707
3450	Flora Rica	SP	3515806
3451	Floreal	SP	3515905
3452	Flórida Paulista	SP	3516002
3453	Florínia	SP	3516101
3454	Franca	SP	3516200
3455	Francisco Morato	SP	3516309
3456	Franco da Rocha	SP	3516408
3457	Gabriel Monteiro	SP	3516507
3458	Gália	SP	3516606
3459	Garça	SP	3516705
3460	Gastão Vidigal	SP	3516804
3461	Gavião Peixoto	SP	3516853
3462	General Salgado	SP	3516903
3463	Getulina	SP	3517000
3464	Glicério	SP	3517109
3465	Guaiçara	SP	3517208
3466	Guaimbê	SP	3517307
3467	Guaíra	SP	3517406
3468	Guapiaçu	SP	3517505
3469	Guapiara	SP	3517604
3470	Guará	SP	3517703
3471	Guaraçaí	SP	3517802
3472	Guaraci	SP	3517901
3473	Guarani d'Oeste	SP	3518008
3474	Guarantã	SP	3518107
3475	Guararapes	SP	3518206
3476	Guararema	SP	3518305
3477	Guaratinguetá	SP	3518404
3478	Guareí	SP	3518503
3479	Guariba	SP	3518602
3480	Guarujá	SP	3518701
3481	Guarulhos	SP	3518800
3482	Guatapará	SP	3518859
3483	Guzolândia	SP	3518909
3484	Herculândia	SP	3519006
3485	Holambra	SP	3519055
3486	Hortolândia	SP	3519071
3487	Iacanga	SP	3519105
3488	Iacri	SP	3519204
3489	Iaras	SP	3519253
3490	Ibaté	SP	3519303
3491	Ibirá	SP	3519402
3492	Ibirarema	SP	3519501
3493	Ibitinga	SP	3519600
3494	Ibiúna	SP	3519709
3495	Icém	SP	3519808
3496	Iepê	SP	3519907
3497	Igaraçu do Tietê	SP	3520004
3498	Igarapava	SP	3520103
3499	Igaratá	SP	3520202
3500	Iguape	SP	3520301
3501	Ilha Comprida	SP	3520426
3502	Ilha Solteira	SP	3520442
3503	Ilhabela	SP	3520400
3504	Indaiatuba	SP	3520509
3505	Indiana	SP	3520608
3506	Indiaporã	SP	3520707
3507	Inúbia Paulista	SP	3520806
3508	Ipaussu	SP	3520905
3509	Iperó	SP	3521002
3510	Ipeúna	SP	3521101
3511	Ipiguá	SP	3521150
3512	Iporanga	SP	3521200
3513	Ipuã	SP	3521309
3514	Iracemápolis	SP	3521408
3515	Irapuã	SP	3521507
3516	Irapuru	SP	3521606
3517	Itaberá	SP	3521705
3518	Itaí	SP	3521804
3519	Itajobi	SP	3521903
3520	Itaju	SP	3522000
3521	Itanhaém	SP	3522109
3522	Itaóca	SP	3522158
3523	Itapecerica da Serra	SP	3522208
3524	Itapetininga	SP	3522307
3525	Itapeva	SP	3522406
3526	Itapevi	SP	3522505
3527	Itapira	SP	3522604
3528	Itapirapuã Paulista	SP	3522653
3529	Itápolis	SP	3522703
3530	Itaporanga	SP	3522802
3531	Itapuí	SP	3522901
3532	Itapura	SP	3523008
3533	Itaquaquecetuba	SP	3523107
3534	Itararé	SP	3523206
3535	Itariri	SP	3523305
3536	Itatiba	SP	3523404
3537	Itatinga	SP	3523503
3538	Itirapina	SP	3523602
3539	Itirapuã	SP	3523701
3540	Itobi	SP	3523800
3541	Itu	SP	3523909
3542	Itupeva	SP	3524006
3543	Ituverava	SP	3524105
3544	Jaborandi	SP	3524204
3545	Jaboticabal	SP	3524303
3546	Jacareí	SP	3524402
3547	Jaci	SP	3524501
3548	Jacupiranga	SP	3524600
3549	Jaguariúna	SP	3524709
3550	Jales	SP	3524808
3551	Jambeiro	SP	3524907
3552	Jandira	SP	3525003
3553	Jardinópolis	SP	3525102
3554	Jarinu	SP	3525201
3555	Jaú	SP	3525300
3556	Jeriquara	SP	3525409
3557	Joanópolis	SP	3525508
3558	João Ramalho	SP	3525607
3559	José Bonifácio	SP	3525706
3560	Júlio Mesquita	SP	3525805
3561	Jumirim	SP	3525854
3562	Jundiaí	SP	3525904
3563	Junqueirópolis	SP	3526001
3564	Juquiá	SP	3526100
3565	Juquitiba	SP	3526209
3566	Lagoinha	SP	3526308
3567	Laranjal Paulista	SP	3526407
3568	Lavínia	SP	3526506
3569	Lavrinhas	SP	3526605
3570	Leme	SP	3526704
3571	Lençóis Paulista	SP	3526803
3572	Limeira	SP	3526902
3573	Lindóia	SP	3527009
3574	Lins	SP	3527108
3575	Lorena	SP	3527207
3576	Lourdes	SP	3527256
3577	Louveira	SP	3527306
3578	Lucélia	SP	3527405
3579	Lucianópolis	SP	3527504
3580	Luís Antônio	SP	3527603
3581	Luiziânia	SP	3527702
3582	Lupércio	SP	3527801
3583	Lutécia	SP	3527900
3584	Macatuba	SP	3528007
3585	Macaubal	SP	3528106
3586	Macedônia	SP	3528205
3587	Magda	SP	3528304
3588	Mairinque	SP	3528403
3589	Mairiporã	SP	3528502
3590	Manduri	SP	3528601
3591	Marabá Paulista	SP	3528700
3592	Maracaí	SP	3528809
3593	Marapoama	SP	3528858
3594	Mariápolis	SP	3528908
3595	Marília	SP	3529005
3596	Marinópolis	SP	3529104
3597	Martinópolis	SP	3529203
3598	Matão	SP	3529302
3599	Mauá	SP	3529401
3600	Mendonça	SP	3529500
3601	Meridiano	SP	3529609
3602	Mesópolis	SP	3529658
3603	Miguelópolis	SP	3529708
3604	Mineiros do Tietê	SP	3529807
3605	Mira Estrela	SP	3530003
3606	Miracatu	SP	3529906
3607	Mirandópolis	SP	3530102
3608	Mirante do Paranapanema	SP	3530201
3609	Mirassol	SP	3530300
3610	Mirassolândia	SP	3530409
3611	Mococa	SP	3530508
3612	Mogi das Cruzes	SP	3530607
3613	Mogi Guaçu	SP	3530706
3614	Moji Mirim	SP	3530805
3615	Mombuca	SP	3530904
3616	Monções	SP	3531001
3617	Mongaguá	SP	3531100
3618	Monte Alegre do Sul	SP	3531209
3619	Monte Alto	SP	3531308
3620	Monte Aprazível	SP	3531407
3621	Monte Azul Paulista	SP	3531506
3622	Monte Castelo	SP	3531605
3623	Monte Mor	SP	3531803
3624	Monteiro Lobato	SP	3531704
3625	Morro Agudo	SP	3531902
3626	Morungaba	SP	3532009
3627	Motuca	SP	3532058
3628	Murutinga do Sul	SP	3532108
3629	Nantes	SP	3532157
3630	Narandiba	SP	3532207
3631	Natividade da Serra	SP	3532306
3632	Nazaré Paulista	SP	3532405
3633	Neves Paulista	SP	3532504
3634	Nhandeara	SP	3532603
3635	Nipoã	SP	3532702
3636	Nova Aliança	SP	3532801
3637	Nova Campina	SP	3532827
3638	Nova Canaã Paulista	SP	3532843
3639	Nova Castilho	SP	3532868
3640	Nova Europa	SP	3532900
3641	Nova Granada	SP	3533007
3642	Nova Guataporanga	SP	3533106
3643	Nova Independência	SP	3533205
3644	Nova Luzitânia	SP	3533304
3645	Nova Odessa	SP	3533403
3646	Novais	SP	3533254
3647	Novo Horizonte	SP	3533502
3648	Nuporanga	SP	3533601
3649	Ocauçu	SP	3533700
3650	Óleo	SP	3533809
3651	Olímpia	SP	3533908
3652	Onda Verde	SP	3534005
3653	Oriente	SP	3534104
3654	Orindiúva	SP	3534203
3655	Orlândia	SP	3534302
3656	Osasco	SP	3534401
3657	Oscar Bressane	SP	3534500
3658	Osvaldo Cruz	SP	3534609
3659	Ourinhos	SP	3534708
3660	Ouro Verde	SP	3534807
3661	Ouroeste	SP	3534757
3662	Pacaembu	SP	3534906
3663	Palestina	SP	3535002
3664	Palmares Paulista	SP	3535101
3665	Palmeira d'Oeste	SP	3535200
3666	Palmital	SP	3535309
3667	Panorama	SP	3535408
3668	Paraguaçu Paulista	SP	3535507
3669	Paraibuna	SP	3535606
3670	Paraíso	SP	3535705
3671	Paranapanema	SP	3535804
3672	Paranapuã	SP	3535903
3673	Parapuã	SP	3536000
3674	Pardinho	SP	3536109
3675	Pariquera-Açu	SP	3536208
3676	Parisi	SP	3536257
3677	Patrocínio Paulista	SP	3536307
3678	Paulicéia	SP	3536406
3679	Paulínia	SP	3536505
3680	Paulistânia	SP	3536570
3681	Paulo de Faria	SP	3536604
3682	Pederneiras	SP	3536703
3683	Pedra Bela	SP	3536802
3684	Pedranópolis	SP	3536901
3685	Pedregulho	SP	3537008
3686	Pedreira	SP	3537107
3687	Pedrinhas Paulista	SP	3537156
3688	Pedro de Toledo	SP	3537206
3689	Penápolis	SP	3537305
3690	Pereira Barreto	SP	3537404
3691	Pereiras	SP	3537503
3692	Peruíbe	SP	3537602
3693	Piacatu	SP	3537701
3694	Piedade	SP	3537800
3695	Pilar do Sul	SP	3537909
3696	Pindamonhangaba	SP	3538006
3697	Pindorama	SP	3538105
3698	Pinhalzinho	SP	3538204
3699	Piquerobi	SP	3538303
3700	Piquete	SP	3538501
3701	Piracaia	SP	3538600
3702	Piracicaba	SP	3538709
3703	Piraju	SP	3538808
3704	Pirajuí	SP	3538907
3705	Pirangi	SP	3539004
3706	Pirapora do Bom Jesus	SP	3539103
3707	Pirapozinho	SP	3539202
3708	Pirassununga	SP	3539301
3709	Piratininga	SP	3539400
3710	Pitangueiras	SP	3539509
3711	Planalto	SP	3539608
3712	Platina	SP	3539707
3713	Poá	SP	3539806
3714	Poloni	SP	3539905
3715	Pompéia	SP	3540002
3716	Pongaí	SP	3540101
3717	Pontal	SP	3540200
3718	Pontalinda	SP	3540259
3719	Pontes Gestal	SP	3540309
3720	Populina	SP	3540408
3721	Porangaba	SP	3540507
3722	Porto Feliz	SP	3540606
3723	Porto Ferreira	SP	3540705
3724	Potim	SP	3540754
3725	Potirendaba	SP	3540804
3726	Pracinha	SP	3540853
3727	Pradópolis	SP	3540903
3728	Praia Grande	SP	3541000
3729	Pratânia	SP	3541059
3730	Presidente Alves	SP	3541109
3731	Presidente Bernardes	SP	3541208
3732	Presidente Epitácio	SP	3541307
3733	Presidente Prudente	SP	3541406
3734	Presidente Venceslau	SP	3541505
3735	Promissão	SP	3541604
3736	Quadra	SP	3541653
3737	Quatá	SP	3541703
3738	Queiroz	SP	3541802
3739	Queluz	SP	3541901
3740	Quintana	SP	3542008
3741	Rafard	SP	3542107
3742	Rancharia	SP	3542206
3743	Redenção da Serra	SP	3542305
3744	Regente Feijó	SP	3542404
3745	Reginópolis	SP	3542503
3746	Registro	SP	3542602
3747	Restinga	SP	3542701
3748	Ribeira	SP	3542800
3749	Ribeirão Bonito	SP	3542909
3750	Ribeirão Branco	SP	3543006
3751	Ribeirão Corrente	SP	3543105
3752	Ribeirão do Sul	SP	3543204
3753	Ribeirão dos Índios	SP	3543238
3754	Ribeirão Grande	SP	3543253
3755	Ribeirão Pires	SP	3543303
3756	Ribeirão Preto	SP	3543402
3757	Rifaina	SP	3543600
3758	Rincão	SP	3543709
3759	Rinópolis	SP	3543808
3760	Rio Claro	SP	3543907
3761	Rio das Pedras	SP	3544004
3762	Rio Grande da Serra	SP	3544103
3763	Riolândia	SP	3544202
3764	Riversul	SP	3543501
3765	Rosana	SP	3544251
3766	Roseira	SP	3544301
3767	Rubiácea	SP	3544400
3768	Rubinéia	SP	3544509
3769	Sabino	SP	3544608
3770	Sagres	SP	3544707
3771	Sales	SP	3544806
3772	Sales Oliveira	SP	3544905
3773	Salesópolis	SP	3545001
3774	Salmourão	SP	3545100
3775	Saltinho	SP	3545159
3776	Salto	SP	3545209
3777	Salto de Pirapora	SP	3545308
3778	Salto Grande	SP	3545407
3779	Sandovalina	SP	3545506
3780	Santa Adélia	SP	3545605
3781	Santa Albertina	SP	3545704
3782	Santa Bárbara d'Oeste	SP	3545803
3783	Santa Branca	SP	3546009
3784	Santa Clara d'Oeste	SP	3546108
3785	Santa Cruz da Conceição	SP	3546207
3786	Santa Cruz da Esperança	SP	3546256
3787	Santa Cruz das Palmeiras	SP	3546306
3788	Santa Cruz do Rio Pardo	SP	3546405
3789	Santa Ernestina	SP	3546504
3790	Santa Fé do Sul	SP	3546603
3791	Santa Gertrudes	SP	3546702
3792	Santa Isabel	SP	3546801
3793	Santa Lúcia	SP	3546900
3794	Santa Maria da Serra	SP	3547007
3795	Santa Mercedes	SP	3547106
3796	Santa Rita do Passa Quatro	SP	3547502
3797	Santa Rita d'Oeste	SP	3547403
3798	Santa Rosa de Viterbo	SP	3547601
3799	Santa Salete	SP	3547650
3800	Santana da Ponte Pensa	SP	3547205
3801	Santana de Parnaíba	SP	3547304
3802	Santo Anastácio	SP	3547700
3803	Santo André	SP	3547809
3804	Santo Antônio da Alegria	SP	3547908
3805	Santo Antônio de Posse	SP	3548005
3806	Santo Antônio do Aracanguá	SP	3548054
3807	Santo Antônio do Jardim	SP	3548104
3808	Santo Antônio do Pinhal	SP	3548203
3809	Santo Expedito	SP	3548302
3810	Santópolis do Aguapeí	SP	3548401
3811	Santos	SP	3548500
3812	São Bento do Sapucaí	SP	3548609
3813	São Bernardo do Campo	SP	3548708
3814	São Caetano do Sul	SP	3548807
3815	São Carlos	SP	3548906
3816	São Francisco	SP	3549003
3817	São João da Boa Vista	SP	3549102
3818	São João das Duas Pontes	SP	3549201
3819	São João de Iracema	SP	3549250
3820	São João do Pau d'Alho	SP	3549300
3821	São Joaquim da Barra	SP	3549409
3822	São José da Bela Vista	SP	3549508
3823	São José do Barreiro	SP	3549607
3824	São José do Rio Pardo	SP	3549706
3825	São José do Rio Preto	SP	3549805
3826	São José dos Campos	SP	3549904
3827	São Lourenço da Serra	SP	3549953
3828	São Luís do Paraitinga	SP	3550001
3829	São Manuel	SP	3550100
3830	São Miguel Arcanjo	SP	3550209
3831	São Paulo	SP	3550308
3832	São Pedro	SP	3550407
3833	São Pedro do Turvo	SP	3550506
3834	São Roque	SP	3550605
3835	São Sebastião	SP	3550704
3836	São Sebastião da Grama	SP	3550803
3837	São Simão	SP	3550902
3838	São Vicente	SP	3551009
3839	Sarapuí	SP	3551108
3840	Sarutaiá	SP	3551207
3841	Sebastianópolis do Sul	SP	3551306
3842	Serra Azul	SP	3551405
3843	Serra Negra	SP	3551603
3844	Serrana	SP	3551504
3845	Sertãozinho	SP	3551702
3846	Sete Barras	SP	3551801
3847	Severínia	SP	3551900
3848	Silveiras	SP	3552007
3849	Socorro	SP	3552106
3850	Sorocaba	SP	3552205
3851	Sud Mennucci	SP	3552304
3852	Sumaré	SP	3552403
3853	Suzanápolis	SP	3552551
3854	Suzano	SP	3552502
3855	Tabapuã	SP	3552601
3856	Tabatinga	SP	3552700
3857	Taboão da Serra	SP	3552809
3858	Taciba	SP	3552908
3859	Taguaí	SP	3553005
3860	Taiaçu	SP	3553104
3861	Taiúva	SP	3553203
3862	Tambaú	SP	3553302
3863	Tanabi	SP	3553401
3864	Tapiraí	SP	3553500
3865	Tapiratiba	SP	3553609
3866	Taquaral	SP	3553658
3867	Taquaritinga	SP	3553708
3868	Taquarituba	SP	3553807
3869	Taquarivaí	SP	3553856
3870	Tarabai	SP	3553906
3871	Tarumã	SP	3553955
3872	Tatuí	SP	3554003
3873	Taubaté	SP	3554102
3874	Tejupá	SP	3554201
3875	Teodoro Sampaio	SP	3554300
3876	Terra Roxa	SP	3554409
3877	Tietê	SP	3554508
3878	Timburi	SP	3554607
3879	Torre de Pedra	SP	3554656
3880	Torrinha	SP	3554706
3881	Trabiju	SP	3554755
3882	Tremembé	SP	3554805
3883	Três Fronteiras	SP	3554904
3884	Tuiuti	SP	3554953
3885	Tupã	SP	3555000
3886	Tupi Paulista	SP	3555109
3887	Turiúba	SP	3555208
3888	Turmalina	SP	3555307
3889	Ubarana	SP	3555356
3890	Ubatuba	SP	3555406
3891	Ubirajara	SP	3555505
3892	Uchoa	SP	3555604
3893	União Paulista	SP	3555703
3894	Urânia	SP	3555802
3895	Uru	SP	3555901
3896	Urupês	SP	3556008
3897	Valentim Gentil	SP	3556107
3898	Valinhos	SP	3556206
3899	Valparaíso	SP	3556305
3900	Vargem	SP	3556354
3901	Vargem Grande do Sul	SP	3556404
3902	Vargem Grande Paulista	SP	3556453
3903	Várzea Paulista	SP	3556503
3904	Vera Cruz	SP	3556602
3905	Vinhedo	SP	3556701
3906	Viradouro	SP	3556800
3907	Vista Alegre do Alto	SP	3556909
3908	Vitória Brasil	SP	3556958
3909	Votorantim	SP	3557006
3910	Votuporanga	SP	3557105
3911	Zacarias	SP	3557154
3912	Abatiá	PR	4100103
3913	Adrianópolis	PR	4100202
3914	Agudos do Sul	PR	4100301
3915	Almirante Tamandaré	PR	4100400
3916	Altamira do Paraná	PR	4100459
3917	Alto Paraíso	PR	4128625
3918	Alto Paraná	PR	4100608
3919	Alto Piquiri	PR	4100707
3920	Altônia	PR	4100509
3921	Alvorada do Sul	PR	4100806
3922	Amaporã	PR	4100905
3923	Ampére	PR	4101002
3924	Anahy	PR	4101051
3925	Andirá	PR	4101101
3926	Ângulo	PR	4101150
3927	Antonina	PR	4101200
3928	Antônio Olinto	PR	4101309
3929	Apucarana	PR	4101408
3930	Arapongas	PR	4101507
3931	Arapoti	PR	4101606
3932	Arapuã	PR	4101655
3933	Araruna	PR	4101705
3934	Araucária	PR	4101804
3935	Ariranha do Ivaí	PR	4101853
3936	Assaí	PR	4101903
3937	Assis Chateaubriand	PR	4102000
3938	Astorga	PR	4102109
3939	Atalaia	PR	4102208
3940	Balsa Nova	PR	4102307
3941	Bandeirantes	PR	4102406
3942	Barbosa Ferraz	PR	4102505
3943	Barra do Jacaré	PR	4102703
3944	Barracão	PR	4102604
3945	Bela Vista da Caroba	PR	4102752
3946	Bela Vista do Paraíso	PR	4102802
3947	Bituruna	PR	4102901
3948	Boa Esperança	PR	4103008
3949	Boa Esperança do Iguaçu	PR	4103024
3950	Boa Ventura de São Roque	PR	4103040
3951	Boa Vista da Aparecida	PR	4103057
3952	Bocaiúva do Sul	PR	4103107
3953	Bom Jesus do Sul	PR	4103156
3954	Bom Sucesso	PR	4103206
3955	Bom Sucesso do Sul	PR	4103222
3956	Borrazópolis	PR	4103305
3957	Braganey	PR	4103354
3958	Brasilândia do Sul	PR	4103370
3959	Cafeara	PR	4103404
3960	Cafelândia	PR	4103453
3961	Cafezal do Sul	PR	4103479
3962	Califórnia	PR	4103503
3963	Cambará	PR	4103602
3964	Cambé	PR	4103701
3965	Cambira	PR	4103800
3966	Campina da Lagoa	PR	4103909
3967	Campina do Simão	PR	4103958
3968	Campina Grande do Sul	PR	4104006
3969	Campo Bonito	PR	4104055
3970	Campo do Tenente	PR	4104105
3971	Campo Largo	PR	4104204
3972	Campo Magro	PR	4104253
3973	Campo Mourão	PR	4104303
3974	Cândido de Abreu	PR	4104402
3975	Candói	PR	4104428
3976	Cantagalo	PR	4104451
3977	Capanema	PR	4104501
3978	Capitão Leônidas Marques	PR	4104600
3979	Carambeí	PR	4104659
3980	Carlópolis	PR	4104709
3981	Cascavel	PR	4104808
3982	Castro	PR	4104907
3983	Catanduvas	PR	4105003
3984	Centenário do Sul	PR	4105102
3985	Cerro Azul	PR	4105201
3986	Céu Azul	PR	4105300
3987	Chopinzinho	PR	4105409
3988	Cianorte	PR	4105508
3989	Cidade Gaúcha	PR	4105607
3990	Clevelândia	PR	4105706
3991	Colombo	PR	4105805
3992	Colorado	PR	4105904
3993	Congonhinhas	PR	4106001
3994	Conselheiro Mairinck	PR	4106100
3995	Contenda	PR	4106209
3996	Corbélia	PR	4106308
3997	Cornélio Procópio	PR	4106407
3998	Coronel Domingos Soares	PR	4106456
3999	Coronel Vivida	PR	4106506
4000	Corumbataí do Sul	PR	4106555
4001	Cruz Machado	PR	4106803
4002	Cruzeiro do Iguaçu	PR	4106571
4003	Cruzeiro do Oeste	PR	4106605
4004	Cruzeiro do Sul	PR	4106704
4005	Cruzmaltina	PR	4106852
4006	Curitiba	PR	4106902
4007	Curiúva	PR	4107009
4008	Diamante do Norte	PR	4107108
4009	Diamante do Sul	PR	4107124
4010	Diamante D'Oeste	PR	4107157
4011	Dois Vizinhos	PR	4107207
4012	Douradina	PR	4107256
4013	Doutor Camargo	PR	4107306
4014	Doutor Ulysses	PR	4128633
4015	Enéas Marques	PR	4107405
4016	Engenheiro Beltrão	PR	4107504
4017	Entre Rios do Oeste	PR	4107538
4018	Esperança Nova	PR	4107520
4019	Espigão Alto do Iguaçu	PR	4107546
4020	Farol	PR	4107553
4021	Faxinal	PR	4107603
4022	Fazenda Rio Grande	PR	4107652
4023	Fênix	PR	4107702
4024	Fernandes Pinheiro	PR	4107736
4025	Figueira	PR	4107751
4026	Flor da Serra do Sul	PR	4107850
4027	Floraí	PR	4107801
4028	Floresta	PR	4107900
4029	Florestópolis	PR	4108007
4030	Flórida	PR	4108106
4031	Formosa do Oeste	PR	4108205
4032	Foz do Iguaçu	PR	4108304
4033	Foz do Jordão	PR	4108452
4034	Francisco Alves	PR	4108320
4035	Francisco Beltrão	PR	4108403
4036	General Carneiro	PR	4108502
4037	Godoy Moreira	PR	4108551
4038	Goioerê	PR	4108601
4039	Goioxim	PR	4108650
4040	Grandes Rios	PR	4108700
4041	Guaíra	PR	4108809
4042	Guairaçá	PR	4108908
4043	Guamiranga	PR	4108957
4044	Guapirama	PR	4109005
4045	Guaporema	PR	4109104
4046	Guaraci	PR	4109203
4047	Guaraniaçu	PR	4109302
4048	Guarapuava	PR	4109401
4049	Guaraqueçaba	PR	4109500
4050	Guaratuba	PR	4109609
4051	Honório Serpa	PR	4109658
4052	Ibaiti	PR	4109708
4053	Ibema	PR	4109757
4054	Ibiporã	PR	4109807
4055	Icaraíma	PR	4109906
4056	Iguaraçu	PR	4110003
4057	Iguatu	PR	4110052
4058	Imbaú	PR	4110078
4059	Imbituva	PR	4110102
4060	Inácio Martins	PR	4110201
4061	Inajá	PR	4110300
4062	Indianópolis	PR	4110409
4063	Ipiranga	PR	4110508
4064	Iporã	PR	4110607
4065	Iracema do Oeste	PR	4110656
4066	Irati	PR	4110706
4067	Iretama	PR	4110805
4068	Itaguajé	PR	4110904
4069	Itaipulândia	PR	4110953
4070	Itambaracá	PR	4111001
4071	Itambé	PR	4111100
4072	Itapejara d'Oeste	PR	4111209
4073	Itaperuçu	PR	4111258
4074	Itaúna do Sul	PR	4111308
4075	Ivaí	PR	4111407
4076	Ivaiporã	PR	4111506
4077	Ivaté	PR	4111555
4078	Ivatuba	PR	4111605
4079	Jaboti	PR	4111704
4080	Jacarezinho	PR	4111803
4081	Jaguapitã	PR	4111902
4082	Jaguariaíva	PR	4112009
4083	Jandaia do Sul	PR	4112108
4084	Janiópolis	PR	4112207
4085	Japira	PR	4112306
4086	Japurá	PR	4112405
4087	Jardim Alegre	PR	4112504
4088	Jardim Olinda	PR	4112603
4089	Jataizinho	PR	4112702
4090	Jesuítas	PR	4112751
4091	Joaquim Távora	PR	4112801
4092	Jundiaí do Sul	PR	4112900
4093	Juranda	PR	4112959
4094	Jussara	PR	4113007
4095	Kaloré	PR	4113106
4096	Lapa	PR	4113205
4097	Laranjal	PR	4113254
4098	Laranjeiras do Sul	PR	4113304
4099	Leópolis	PR	4113403
4100	Lidianópolis	PR	4113429
4101	Lindoeste	PR	4113452
4102	Loanda	PR	4113502
4103	Lobato	PR	4113601
4104	Londrina	PR	4113700
4105	Luiziana	PR	4113734
4106	Lunardelli	PR	4113759
4107	Lupionópolis	PR	4113809
4108	Mallet	PR	4113908
4109	Mamborê	PR	4114005
4110	Mandaguaçu	PR	4114104
4111	Mandaguari	PR	4114203
4112	Mandirituba	PR	4114302
4113	Manfrinópolis	PR	4114351
4114	Mangueirinha	PR	4114401
4115	Manoel Ribas	PR	4114500
4116	Marechal Cândido Rondon	PR	4114609
4117	Maria Helena	PR	4114708
4118	Marialva	PR	4114807
4119	Marilândia do Sul	PR	4114906
4120	Marilena	PR	4115002
4121	Mariluz	PR	4115101
4122	Maringá	PR	4115200
4123	Mariópolis	PR	4115309
4124	Maripá	PR	4115358
4125	Marmeleiro	PR	4115408
4126	Marquinho	PR	4115457
4127	Marumbi	PR	4115507
4128	Matelândia	PR	4115606
4129	Matinhos	PR	4115705
4130	Mato Rico	PR	4115739
4131	Mauá da Serra	PR	4115754
4132	Medianeira	PR	4115804
4133	Mercedes	PR	4115853
4134	Mirador	PR	4115903
4135	Miraselva	PR	4116000
4136	Missal	PR	4116059
4137	Moreira Sales	PR	4116109
4138	Morretes	PR	4116208
4139	Munhoz de Melo	PR	4116307
4140	Nossa Senhora das Graças	PR	4116406
4141	Nova Aliança do Ivaí	PR	4116505
4142	Nova América da Colina	PR	4116604
4143	Nova Aurora	PR	4116703
4144	Nova Cantu	PR	4116802
4145	Nova Esperança	PR	4116901
4146	Nova Esperança do Sudoeste	PR	4116950
4147	Nova Fátima	PR	4117008
4148	Nova Laranjeiras	PR	4117057
4149	Nova Londrina	PR	4117107
4150	Nova Olímpia	PR	4117206
4151	Nova Prata do Iguaçu	PR	4117255
4152	Nova Santa Bárbara	PR	4117214
4153	Nova Santa Rosa	PR	4117222
4154	Nova Tebas	PR	4117271
4155	Novo Itacolomi	PR	4117297
4156	Ortigueira	PR	4117305
4157	Ourizona	PR	4117404
4158	Ouro Verde do Oeste	PR	4117453
4159	Paiçandu	PR	4117503
4160	Palmas	PR	4117602
4161	Palmeira	PR	4117701
4162	Palmital	PR	4117800
4163	Palotina	PR	4117909
4164	Paraíso do Norte	PR	4118006
4165	Paranacity	PR	4118105
4166	Paranaguá	PR	4118204
4167	Paranapoema	PR	4118303
4168	Paranavaí	PR	4118402
4169	Pato Bragado	PR	4118451
4170	Pato Branco	PR	4118501
4171	Paula Freitas	PR	4118600
4172	Paulo Frontin	PR	4118709
4173	Peabiru	PR	4118808
4174	Perobal	PR	4118857
4175	Pérola	PR	4118907
4176	Pérola d'Oeste	PR	4119004
4177	Piên	PR	4119103
4178	Pinhais	PR	4119152
4179	Pinhal de São Bento	PR	4119251
4180	Pinhalão	PR	4119202
4181	Pinhão	PR	4119301
4182	Piraí do Sul	PR	4119400
4183	Piraquara	PR	4119509
4184	Pitanga	PR	4119608
4185	Pitangueiras	PR	4119657
4186	Planaltina do Paraná	PR	4119707
4187	Planalto	PR	4119806
4188	Ponta Grossa	PR	4119905
4189	Pontal do Paraná	PR	4119954
4190	Porecatu	PR	4120002
4191	Porto Amazonas	PR	4120101
4192	Porto Barreiro	PR	4120150
4193	Porto Rico	PR	4120200
4194	Porto Vitória	PR	4120309
4195	Prado Ferreira	PR	4120333
4196	Pranchita	PR	4120358
4197	Presidente Castelo Branco	PR	4120408
4198	Primeiro de Maio	PR	4120507
4199	Prudentópolis	PR	4120606
4200	Quarto Centenário	PR	4120655
4201	Quatiguá	PR	4120705
4202	Quatro Barras	PR	4120804
4203	Quatro Pontes	PR	4120853
4204	Quedas do Iguaçu	PR	4120903
4205	Querência do Norte	PR	4121000
4206	Quinta do Sol	PR	4121109
4207	Quitandinha	PR	4121208
4208	Ramilândia	PR	4121257
4209	Rancho Alegre	PR	4121307
4210	Rancho Alegre D'Oeste	PR	4121356
4211	Realeza	PR	4121406
4212	Rebouças	PR	4121505
4213	Renascença	PR	4121604
4214	Reserva	PR	4121703
4215	Reserva do Iguaçu	PR	4121752
4216	Ribeirão Claro	PR	4121802
4217	Ribeirão do Pinhal	PR	4121901
4218	Rio Azul	PR	4122008
4219	Rio Bom	PR	4122107
4220	Rio Bonito do Iguaçu	PR	4122156
4221	Rio Branco do Ivaí	PR	4122172
4222	Rio Branco do Sul	PR	4122206
4223	Rio Negro	PR	4122305
4224	Rolândia	PR	4122404
4225	Roncador	PR	4122503
4226	Rondon	PR	4122602
4227	Rosário do Ivaí	PR	4122651
4228	Sabáudia	PR	4122701
4229	Salgado Filho	PR	4122800
4230	Salto do Itararé	PR	4122909
4231	Salto do Lontra	PR	4123006
4232	Santa Amélia	PR	4123105
4233	Santa Cecília do Pavão	PR	4123204
4234	Santa Cruz de Monte Castelo	PR	4123303
4235	Santa Fé	PR	4123402
4236	Santa Helena	PR	4123501
4237	Santa Inês	PR	4123600
4238	Santa Isabel do Ivaí	PR	4123709
4239	Santa Izabel do Oeste	PR	4123808
4240	Santa Lúcia	PR	4123824
4241	Santa Maria do Oeste	PR	4123857
4242	Santa Mariana	PR	4123907
4243	Santa Mônica	PR	4123956
4244	Santa Tereza do Oeste	PR	4124020
4245	Santa Terezinha de Itaipu	PR	4124053
4246	Santana do Itararé	PR	4124004
4247	Santo Antônio da Platina	PR	4124103
4248	Santo Antônio do Caiuá	PR	4124202
4249	Santo Antônio do Paraíso	PR	4124301
4250	Santo Antônio do Sudoeste	PR	4124400
4251	Santo Inácio	PR	4124509
4252	São Carlos do Ivaí	PR	4124608
4253	São Jerônimo da Serra	PR	4124707
4254	São João	PR	4124806
4255	São João do Caiuá	PR	4124905
4256	São João do Ivaí	PR	4125001
4257	São João do Triunfo	PR	4125100
4258	São Jorge do Ivaí	PR	4125308
4259	São Jorge do Patrocínio	PR	4125357
4260	São Jorge d'Oeste	PR	4125209
4261	São José da Boa Vista	PR	4125407
4262	São José das Palmeiras	PR	4125456
4263	São José dos Pinhais	PR	4125506
4264	São Manoel do Paraná	PR	4125555
4265	São Mateus do Sul	PR	4125605
4266	São Miguel do Iguaçu	PR	4125704
4267	São Pedro do Iguaçu	PR	4125753
4268	São Pedro do Ivaí	PR	4125803
4269	São Pedro do Paraná	PR	4125902
4270	São Sebastião da Amoreira	PR	4126009
4271	São Tomé	PR	4126108
4272	Sapopema	PR	4126207
4273	Sarandi	PR	4126256
4274	Saudade do Iguaçu	PR	4126272
4275	Sengés	PR	4126306
4276	Serranópolis do Iguaçu	PR	4126355
4277	Sertaneja	PR	4126405
4278	Sertanópolis	PR	4126504
4279	Siqueira Campos	PR	4126603
4280	Sulina	PR	4126652
4281	Tamarana	PR	4126678
4282	Tamboara	PR	4126702
4283	Tapejara	PR	4126801
4284	Tapira	PR	4126900
4285	Teixeira Soares	PR	4127007
4286	Telêmaco Borba	PR	4127106
4287	Terra Boa	PR	4127205
4288	Terra Rica	PR	4127304
4289	Terra Roxa	PR	4127403
4290	Tibagi	PR	4127502
4291	Tijucas do Sul	PR	4127601
4292	Toledo	PR	4127700
4293	Tomazina	PR	4127809
4294	Três Barras do Paraná	PR	4127858
4295	Tunas do Paraná	PR	4127882
4296	Tuneiras do Oeste	PR	4127908
4297	Tupãssi	PR	4127957
4298	Turvo	PR	4127965
4299	Ubiratã	PR	4128005
4300	Umuarama	PR	4128104
4301	União da Vitória	PR	4128203
4302	Uniflor	PR	4128302
4303	Uraí	PR	4128401
4304	Ventania	PR	4128534
4305	Vera Cruz do Oeste	PR	4128559
4306	Verê	PR	4128609
4307	Virmond	PR	4128658
4308	Vitorino	PR	4128708
4309	Wenceslau Braz	PR	4128500
4310	Xambrê	PR	4128807
4311	Abdon Batista	SC	4200051
4312	Abelardo Luz	SC	4200101
4313	Agrolândia	SC	4200200
4314	Agronômica	SC	4200309
4315	Água Doce	SC	4200408
4316	Águas de Chapecó	SC	4200507
4317	Águas Frias	SC	4200556
4318	Águas Mornas	SC	4200606
4319	Alfredo Wagner	SC	4200705
4320	Alto Bela Vista	SC	4200754
4321	Anchieta	SC	4200804
4322	Angelina	SC	4200903
4323	Anita Garibaldi	SC	4201000
4324	Anitápolis	SC	4201109
4325	Antônio Carlos	SC	4201208
4326	Apiúna	SC	4201257
4327	Arabutã	SC	4201273
4328	Araquari	SC	4201307
4329	Araranguá	SC	4201406
4330	Armazém	SC	4201505
4331	Arroio Trinta	SC	4201604
4332	Arvoredo	SC	4201653
4333	Ascurra	SC	4201703
4334	Atalanta	SC	4201802
4335	Aurora	SC	4201901
4336	Balneário Arroio do Silva	SC	4201950
4337	Balneário Barra do Sul	SC	4202057
4338	Balneário Camboriú	SC	4202008
4339	Balneário Gaivota	SC	4202073
4340	Balneário Piçarras	SC	4212809
4341	Bandeirante	SC	4202081
4342	Barra Bonita	SC	4202099
4343	Barra Velha	SC	4202107
4344	Bela Vista do Toldo	SC	4202131
4345	Belmonte	SC	4202156
4346	Benedito Novo	SC	4202206
4347	Biguaçu	SC	4202305
4348	Blumenau	SC	4202404
4349	Bocaina do Sul	SC	4202438
4350	Bom Jardim da Serra	SC	4202503
4351	Bom Jesus	SC	4202537
4352	Bom Jesus do Oeste	SC	4202578
4353	Bom Retiro	SC	4202602
4354	Bombinhas	SC	4202453
4355	Botuverá	SC	4202701
4356	Braço do Norte	SC	4202800
4357	Braço do Trombudo	SC	4202859
4358	Brunópolis	SC	4202875
4359	Brusque	SC	4202909
4360	Caçador	SC	4203006
4361	Caibi	SC	4203105
4362	Calmon	SC	4203154
4363	Camboriú	SC	4203204
4364	Campo Alegre	SC	4203303
4365	Campo Belo do Sul	SC	4203402
4366	Campo Erê	SC	4203501
4367	Campos Novos	SC	4203600
4368	Canelinha	SC	4203709
4369	Canoinhas	SC	4203808
4370	Capão Alto	SC	4203253
4371	Capinzal	SC	4203907
4372	Capivari de Baixo	SC	4203956
4373	Catanduvas	SC	4204004
4374	Caxambu do Sul	SC	4204103
4375	Celso Ramos	SC	4204152
4376	Cerro Negro	SC	4204178
4377	Chapadão do Lageado	SC	4204194
4378	Chapecó	SC	4204202
4379	Cocal do Sul	SC	4204251
4380	Concórdia	SC	4204301
4381	Cordilheira Alta	SC	4204350
4382	Coronel Freitas	SC	4204400
4383	Coronel Martins	SC	4204459
4384	Correia Pinto	SC	4204558
4385	Corupá	SC	4204509
4386	Criciúma	SC	4204608
4387	Cunha Porã	SC	4204707
4388	Cunhataí	SC	4204756
4389	Curitibanos	SC	4204806
4390	Descanso	SC	4204905
4391	Dionísio Cerqueira	SC	4205001
4392	Dona Emma	SC	4205100
4393	Doutor Pedrinho	SC	4205159
4394	Entre Rios	SC	4205175
4395	Ermo	SC	4205191
4396	Erval Velho	SC	4205209
4397	Faxinal dos Guedes	SC	4205308
4398	Flor do Sertão	SC	4205357
4399	Florianópolis	SC	4205407
4400	Formosa do Sul	SC	4205431
4401	Forquilhinha	SC	4205456
4402	Fraiburgo	SC	4205506
4403	Frei Rogério	SC	4205555
4404	Galvão	SC	4205605
4405	Garopaba	SC	4205704
4406	Garuva	SC	4205803
4407	Gaspar	SC	4205902
4408	Governador Celso Ramos	SC	4206009
4409	Grão Pará	SC	4206108
4410	Gravatal	SC	4206207
4411	Guabiruba	SC	4206306
4412	Guaraciaba	SC	4206405
4413	Guaramirim	SC	4206504
4414	Guarujá do Sul	SC	4206603
4415	Guatambú	SC	4206652
4416	Herval d'Oeste	SC	4206702
4417	Ibiam	SC	4206751
4418	Ibicaré	SC	4206801
4419	Ibirama	SC	4206900
4420	Içara	SC	4207007
4421	Ilhota	SC	4207106
4422	Imaruí	SC	4207205
4423	Imbituba	SC	4207304
4424	Imbuia	SC	4207403
4425	Indaial	SC	4207502
4426	Iomerê	SC	4207577
4427	Ipira	SC	4207601
4428	Iporã do Oeste	SC	4207650
4429	Ipuaçu	SC	4207684
4430	Ipumirim	SC	4207700
4431	Iraceminha	SC	4207759
4432	Irani	SC	4207809
4433	Irati	SC	4207858
4434	Irineópolis	SC	4207908
4435	Itá	SC	4208005
4436	Itaiópolis	SC	4208104
4437	Itajaí	SC	4208203
4438	Itapema	SC	4208302
4439	Itapiranga	SC	4208401
4440	Itapoá	SC	4208450
4441	Ituporanga	SC	4208500
4442	Jaborá	SC	4208609
4443	Jacinto Machado	SC	4208708
4444	Jaguaruna	SC	4208807
4445	Jaraguá do Sul	SC	4208906
4446	Jardinópolis	SC	4208955
4447	Joaçaba	SC	4209003
4448	Joinville	SC	4209102
4449	José Boiteux	SC	4209151
4450	Jupiá	SC	4209177
4451	Lacerdópolis	SC	4209201
4452	Lages	SC	4209300
4453	Laguna	SC	4209409
4454	Lajeado Grande	SC	4209458
4455	Laurentino	SC	4209508
4456	Lauro Muller	SC	4209607
4457	Lebon Régis	SC	4209706
4458	Leoberto Leal	SC	4209805
4459	Lindóia do Sul	SC	4209854
4460	Lontras	SC	4209904
4461	Luiz Alves	SC	4210001
4462	Luzerna	SC	4210035
4463	Macieira	SC	4210050
4464	Mafra	SC	4210100
4465	Major Gercino	SC	4210209
4466	Major Vieira	SC	4210308
4467	Maracajá	SC	4210407
4468	Maravilha	SC	4210506
4469	Marema	SC	4210555
4470	Massaranduba	SC	4210605
4471	Matos Costa	SC	4210704
4472	Meleiro	SC	4210803
4473	Mirim Doce	SC	4210852
4474	Modelo	SC	4210902
4475	Mondaí	SC	4211009
4476	Monte Carlo	SC	4211058
4477	Monte Castelo	SC	4211108
4478	Morro da Fumaça	SC	4211207
4479	Morro Grande	SC	4211256
4480	Navegantes	SC	4211306
4481	Nova Erechim	SC	4211405
4482	Nova Itaberaba	SC	4211454
4483	Nova Trento	SC	4211504
4484	Nova Veneza	SC	4211603
4485	Novo Horizonte	SC	4211652
4486	Orleans	SC	4211702
4487	Otacílio Costa	SC	4211751
4488	Ouro	SC	4211801
4489	Ouro Verde	SC	4211850
4490	Paial	SC	4211876
4491	Painel	SC	4211892
4492	Palhoça	SC	4211900
4493	Palma Sola	SC	4212007
4494	Palmeira	SC	4212056
4495	Palmitos	SC	4212106
4496	Papanduva	SC	4212205
4497	Paraíso	SC	4212239
4498	Passo de Torres	SC	4212254
4499	Passos Maia	SC	4212270
4500	Paulo Lopes	SC	4212304
4501	Pedras Grandes	SC	4212403
4502	Penha	SC	4212502
4503	Peritiba	SC	4212601
4504	Petrolândia	SC	4212700
4505	Pinhalzinho	SC	4212908
4506	Pinheiro Preto	SC	4213005
4507	Piratuba	SC	4213104
4508	Planalto Alegre	SC	4213153
4509	Pomerode	SC	4213203
4510	Ponte Alta	SC	4213302
4511	Ponte Alta do Norte	SC	4213351
4512	Ponte Serrada	SC	4213401
4513	Porto Belo	SC	4213500
4514	Porto União	SC	4213609
4515	Pouso Redondo	SC	4213708
4516	Praia Grande	SC	4213807
4517	Presidente Castello Branco	SC	4213906
4518	Presidente Getúlio	SC	4214003
4519	Presidente Nereu	SC	4214102
4520	Princesa	SC	4214151
4521	Quilombo	SC	4214201
4522	Rancho Queimado	SC	4214300
4523	Rio das Antas	SC	4214409
4524	Rio do Campo	SC	4214508
4525	Rio do Oeste	SC	4214607
4526	Rio do Sul	SC	4214805
4527	Rio dos Cedros	SC	4214706
4528	Rio Fortuna	SC	4214904
4529	Rio Negrinho	SC	4215000
4530	Rio Rufino	SC	4215059
4531	Riqueza	SC	4215075
4532	Rodeio	SC	4215109
4533	Romelândia	SC	4215208
4534	Salete	SC	4215307
4535	Saltinho	SC	4215356
4536	Salto Veloso	SC	4215406
4537	Sangão	SC	4215455
4538	Santa Cecília	SC	4215505
4539	Santa Helena	SC	4215554
4540	Santa Rosa de Lima	SC	4215604
4541	Santa Rosa do Sul	SC	4215653
4542	Santa Terezinha	SC	4215679
4543	Santa Terezinha do Progresso	SC	4215687
4544	Santiago do Sul	SC	4215695
4545	Santo Amaro da Imperatriz	SC	4215703
4546	São Bento do Sul	SC	4215802
4547	São Bernardino	SC	4215752
4548	São Bonifácio	SC	4215901
4549	São Carlos	SC	4216008
4550	São Cristovão do Sul	SC	4216057
4551	São Domingos	SC	4216107
4552	São Francisco do Sul	SC	4216206
4553	São João Batista	SC	4216305
4554	São João do Itaperiú	SC	4216354
4555	São João do Oeste	SC	4216255
4556	São João do Sul	SC	4216404
4557	São Joaquim	SC	4216503
4558	São José	SC	4216602
4559	São José do Cedro	SC	4216701
4560	São José do Cerrito	SC	4216800
4561	São Lourenço do Oeste	SC	4216909
4562	São Ludgero	SC	4217006
4563	São Martinho	SC	4217105
4564	São Miguel da Boa Vista	SC	4217154
4565	São Miguel do Oeste	SC	4217204
4566	São Pedro de Alcântara	SC	4217253
4567	Saudades	SC	4217303
4568	Schroeder	SC	4217402
4569	Seara	SC	4217501
4570	Serra Alta	SC	4217550
4571	Siderópolis	SC	4217600
4572	Sombrio	SC	4217709
4573	Sul Brasil	SC	4217758
4574	Taió	SC	4217808
4575	Tangará	SC	4217907
4576	Tigrinhos	SC	4217956
4577	Tijucas	SC	4218004
4578	Timbé do Sul	SC	4218103
4579	Timbó	SC	4218202
4580	Timbó Grande	SC	4218251
4581	Três Barras	SC	4218301
4582	Treviso	SC	4218350
4583	Treze de Maio	SC	4218400
4584	Treze Tílias	SC	4218509
4585	Trombudo Central	SC	4218608
4586	Tubarão	SC	4218707
4587	Tunápolis	SC	4218756
4588	Turvo	SC	4218806
4589	União do Oeste	SC	4218855
4590	Urubici	SC	4218905
4591	Urupema	SC	4218954
4592	Urussanga	SC	4219002
4593	Vargeão	SC	4219101
4594	Vargem	SC	4219150
4595	Vargem Bonita	SC	4219176
4596	Vidal Ramos	SC	4219200
4597	Videira	SC	4219309
4598	Vitor Meireles	SC	4219358
4599	Witmarsum	SC	4219408
4600	Xanxerê	SC	4219507
4601	Xavantina	SC	4219606
4602	Xaxim	SC	4219705
4603	Zortéa	SC	4219853
4604	Aceguá	RS	4300034
4605	Água Santa	RS	4300059
4606	Agudo	RS	4300109
4607	Ajuricaba	RS	4300208
4608	Alecrim	RS	4300307
4609	Alegrete	RS	4300406
4610	Alegria	RS	4300455
4611	Almirante Tamandaré do Sul	RS	4300471
4612	Alpestre	RS	4300505
4613	Alto Alegre	RS	4300554
4614	Alto Feliz	RS	4300570
4615	Alvorada	RS	4300604
4616	Amaral Ferrador	RS	4300638
4617	Ametista do Sul	RS	4300646
4618	André da Rocha	RS	4300661
4619	Anta Gorda	RS	4300703
4620	Antônio Prado	RS	4300802
4621	Arambaré	RS	4300851
4622	Araricá	RS	4300877
4623	Aratiba	RS	4300901
4624	Arroio do Meio	RS	4301008
4625	Arroio do Padre	RS	4301073
4626	Arroio do Sal	RS	4301057
4627	Arroio do Tigre	RS	4301206
4628	Arroio dos Ratos	RS	4301107
4629	Arroio Grande	RS	4301305
4630	Arvorezinha	RS	4301404
4631	Augusto Pestana	RS	4301503
4632	Áurea	RS	4301552
4633	Bagé	RS	4301602
4634	Balneário Pinhal	RS	4301636
4635	Barão	RS	4301651
4636	Barão de Cotegipe	RS	4301701
4637	Barão do Triunfo	RS	4301750
4638	Barra do Guarita	RS	4301859
4639	Barra do Quaraí	RS	4301875
4640	Barra do Ribeiro	RS	4301909
4641	Barra do Rio Azul	RS	4301925
4642	Barra Funda	RS	4301958
4643	Barracão	RS	4301800
4644	Barros Cassal	RS	4302006
4645	Benjamin Constant do Sul	RS	4302055
4646	Bento Gonçalves	RS	4302105
4647	Boa Vista das Missões	RS	4302154
4648	Boa Vista do Buricá	RS	4302204
4649	Boa Vista do Cadeado	RS	4302220
4650	Boa Vista do Incra	RS	4302238
4651	Boa Vista do Sul	RS	4302253
4652	Bom Jesus	RS	4302303
4653	Bom Princípio	RS	4302352
4654	Bom Progresso	RS	4302378
4655	Bom Retiro do Sul	RS	4302402
4656	Boqueirão do Leão	RS	4302451
4657	Bossoroca	RS	4302501
4658	Bozano	RS	4302584
4659	Braga	RS	4302600
4660	Brochier	RS	4302659
4661	Butiá	RS	4302709
4662	Caçapava do Sul	RS	4302808
4663	Cacequi	RS	4302907
4664	Cachoeira do Sul	RS	4303004
4665	Cachoeirinha	RS	4303103
4666	Cacique Doble	RS	4303202
4667	Caibaté	RS	4303301
4668	Caiçara	RS	4303400
4669	Camaquã	RS	4303509
4670	Camargo	RS	4303558
4671	Cambará do Sul	RS	4303608
4672	Campestre da Serra	RS	4303673
4673	Campina das Missões	RS	4303707
4674	Campinas do Sul	RS	4303806
4675	Campo Bom	RS	4303905
4676	Campo Novo	RS	4304002
4677	Campos Borges	RS	4304101
4678	Candelária	RS	4304200
4679	Cândido Godói	RS	4304309
4680	Candiota	RS	4304358
4681	Canela	RS	4304408
4682	Canguçu	RS	4304507
4683	Canoas	RS	4304606
4684	Canudos do Vale	RS	4304614
4685	Capão Bonito do Sul	RS	4304622
4686	Capão da Canoa	RS	4304630
4687	Capão do Cipó	RS	4304655
4688	Capão do Leão	RS	4304663
4689	Capela de Santana	RS	4304689
4690	Capitão	RS	4304697
4691	Capivari do Sul	RS	4304671
4692	Caraá	RS	4304713
4693	Carazinho	RS	4304705
4694	Carlos Barbosa	RS	4304804
4695	Carlos Gomes	RS	4304853
4696	Casca	RS	4304903
4697	Caseiros	RS	4304952
4698	Catuípe	RS	4305009
4699	Caxias do Sul	RS	4305108
4700	Centenário	RS	4305116
4701	Cerrito	RS	4305124
4702	Cerro Branco	RS	4305132
4703	Cerro Grande	RS	4305157
4704	Cerro Grande do Sul	RS	4305173
4705	Cerro Largo	RS	4305207
4706	Chapada	RS	4305306
4707	Charqueadas	RS	4305355
4708	Charrua	RS	4305371
4709	Chiapetta	RS	4305405
4710	Chuí	RS	4305439
4711	Chuvisca	RS	4305447
4712	Cidreira	RS	4305454
4713	Ciríaco	RS	4305504
4714	Colinas	RS	4305587
4715	Colorado	RS	4305603
4716	Condor	RS	4305702
4717	Constantina	RS	4305801
4718	Coqueiro Baixo	RS	4305835
4719	Coqueiros do Sul	RS	4305850
4720	Coronel Barros	RS	4305871
4721	Coronel Bicaco	RS	4305900
4722	Coronel Pilar	RS	4305934
4723	Cotiporã	RS	4305959
4724	Coxilha	RS	4305975
4725	Crissiumal	RS	4306007
4726	Cristal	RS	4306056
4727	Cristal do Sul	RS	4306072
4728	Cruz Alta	RS	4306106
4729	Cruzaltense	RS	4306130
4730	Cruzeiro do Sul	RS	4306205
4731	David Canabarro	RS	4306304
4732	Derrubadas	RS	4306320
4733	Dezesseis de Novembro	RS	4306353
4734	Dilermando de Aguiar	RS	4306379
4735	Dois Irmãos	RS	4306403
4736	Dois Irmãos das Missões	RS	4306429
4737	Dois Lajeados	RS	4306452
4738	Dom Feliciano	RS	4306502
4739	Dom Pedrito	RS	4306601
4740	Dom Pedro de Alcântara	RS	4306551
4741	Dona Francisca	RS	4306700
4742	Doutor Maurício Cardoso	RS	4306734
4743	Doutor Ricardo	RS	4306759
4744	Eldorado do Sul	RS	4306767
4745	Encantado	RS	4306809
4746	Encruzilhada do Sul	RS	4306908
4747	Engenho Velho	RS	4306924
4748	Entre Rios do Sul	RS	4306957
4749	Entre-Ijuís	RS	4306932
4750	Erebango	RS	4306973
4751	Erechim	RS	4307005
4752	Ernestina	RS	4307054
4753	Erval Grande	RS	4307203
4754	Erval Seco	RS	4307302
4755	Esmeralda	RS	4307401
4756	Esperança do Sul	RS	4307450
4757	Espumoso	RS	4307500
4758	Estação	RS	4307559
4759	Estância Velha	RS	4307609
4760	Esteio	RS	4307708
4761	Estrela	RS	4307807
4762	Estrela Velha	RS	4307815
4763	Eugênio de Castro	RS	4307831
4764	Fagundes Varela	RS	4307864
4765	Farroupilha	RS	4307906
4766	Faxinal do Soturno	RS	4308003
4767	Faxinalzinho	RS	4308052
4768	Fazenda Vilanova	RS	4308078
4769	Feliz	RS	4308102
4770	Flores da Cunha	RS	4308201
4771	Floriano Peixoto	RS	4308250
4772	Fontoura Xavier	RS	4308300
4773	Formigueiro	RS	4308409
4774	Forquetinha	RS	4308433
4775	Fortaleza dos Valos	RS	4308458
4776	Frederico Westphalen	RS	4308508
4777	Garibaldi	RS	4308607
4778	Garruchos	RS	4308656
4779	Gaurama	RS	4308706
4780	General Câmara	RS	4308805
4781	Gentil	RS	4308854
4782	Getúlio Vargas	RS	4308904
4783	Giruá	RS	4309001
4784	Glorinha	RS	4309050
4785	Gramado	RS	4309100
4786	Gramado dos Loureiros	RS	4309126
4787	Gramado Xavier	RS	4309159
4788	Gravataí	RS	4309209
4789	Guabiju	RS	4309258
4790	Guaíba	RS	4309308
4791	Guaporé	RS	4309407
4792	Guarani das Missões	RS	4309506
4793	Harmonia	RS	4309555
4794	Herval	RS	4307104
4795	Herveiras	RS	4309571
4796	Horizontina	RS	4309605
4797	Hulha Negra	RS	4309654
4798	Humaitá	RS	4309704
4799	Ibarama	RS	4309753
4800	Ibiaçá	RS	4309803
4801	Ibiraiaras	RS	4309902
4802	Ibirapuitã	RS	4309951
4803	Ibirubá	RS	4310009
4804	Igrejinha	RS	4310108
4805	Ijuí	RS	4310207
4806	Ilópolis	RS	4310306
4807	Imbé	RS	4310330
4808	Imigrante	RS	4310363
4809	Independência	RS	4310405
4810	Inhacorá	RS	4310413
4811	Ipê	RS	4310439
4812	Ipiranga do Sul	RS	4310462
4813	Iraí	RS	4310504
4814	Itaara	RS	4310538
4815	Itacurubi	RS	4310553
4816	Itapuca	RS	4310579
4817	Itaqui	RS	4310603
4818	Itati	RS	4310652
4819	Itatiba do Sul	RS	4310702
4820	Ivorá	RS	4310751
4821	Ivoti	RS	4310801
4822	Jaboticaba	RS	4310850
4823	Jacuizinho	RS	4310876
4824	Jacutinga	RS	4310900
4825	Jaguarão	RS	4311007
4826	Jaguari	RS	4311106
4827	Jaquirana	RS	4311122
4828	Jari	RS	4311130
4829	Jóia	RS	4311155
4830	Júlio de Castilhos	RS	4311205
4831	Lagoa Bonita do Sul	RS	4311239
4832	Lagoa dos Três Cantos	RS	4311270
4833	Lagoa Vermelha	RS	4311304
4834	Lagoão	RS	4311254
4835	Lajeado	RS	4311403
4836	Lajeado do Bugre	RS	4311429
4837	Lavras do Sul	RS	4311502
4838	Liberato Salzano	RS	4311601
4839	Lindolfo Collor	RS	4311627
4840	Linha Nova	RS	4311643
4841	Maçambará	RS	4311718
4842	Machadinho	RS	4311700
4843	Mampituba	RS	4311734
4844	Manoel Viana	RS	4311759
4845	Maquiné	RS	4311775
4846	Maratá	RS	4311791
4847	Marau	RS	4311809
4848	Marcelino Ramos	RS	4311908
4849	Mariana Pimentel	RS	4311981
4850	Mariano Moro	RS	4312005
4851	Marques de Souza	RS	4312054
4852	Mata	RS	4312104
4853	Mato Castelhano	RS	4312138
4854	Mato Leitão	RS	4312153
4855	Mato Queimado	RS	4312179
4856	Maximiliano de Almeida	RS	4312203
4857	Minas do Leão	RS	4312252
4858	Miraguaí	RS	4312302
4859	Montauri	RS	4312351
4860	Monte Alegre dos Campos	RS	4312377
4861	Monte Belo do Sul	RS	4312385
4862	Montenegro	RS	4312401
4863	Mormaço	RS	4312427
4864	Morrinhos do Sul	RS	4312443
4865	Morro Redondo	RS	4312450
4866	Morro Reuter	RS	4312476
4867	Mostardas	RS	4312500
4868	Muçum	RS	4312609
4869	Muitos Capões	RS	4312617
4870	Muliterno	RS	4312625
4871	Não-Me-Toque	RS	4312658
4872	Nicolau Vergueiro	RS	4312674
4873	Nonoai	RS	4312708
4874	Nova Alvorada	RS	4312757
4875	Nova Araçá	RS	4312807
4876	Nova Bassano	RS	4312906
4877	Nova Boa Vista	RS	4312955
4878	Nova Bréscia	RS	4313003
4879	Nova Candelária	RS	4313011
4880	Nova Esperança do Sul	RS	4313037
4881	Nova Hartz	RS	4313060
4882	Nova Pádua	RS	4313086
4883	Nova Palma	RS	4313102
4884	Nova Petrópolis	RS	4313201
4885	Nova Prata	RS	4313300
4886	Nova Ramada	RS	4313334
4887	Nova Roma do Sul	RS	4313359
4888	Nova Santa Rita	RS	4313375
4889	Novo Barreiro	RS	4313490
4890	Novo Cabrais	RS	4313391
4891	Novo Hamburgo	RS	4313409
4892	Novo Machado	RS	4313425
4893	Novo Tiradentes	RS	4313441
4894	Novo Xingu	RS	4313466
4895	Osório	RS	4313508
4896	Paim Filho	RS	4313607
4897	Palmares do Sul	RS	4313656
4898	Palmeira das Missões	RS	4313706
4899	Palmitinho	RS	4313805
4900	Panambi	RS	4313904
4901	Pantano Grande	RS	4313953
4902	Paraí	RS	4314001
4903	Paraíso do Sul	RS	4314027
4904	Pareci Novo	RS	4314035
4905	Parobé	RS	4314050
4906	Passa Sete	RS	4314068
4907	Passo do Sobrado	RS	4314076
4908	Passo Fundo	RS	4314100
4909	Paulo Bento	RS	4314134
4910	Paverama	RS	4314159
4911	Pedras Altas	RS	4314175
4912	Pedro Osório	RS	4314209
4913	Pejuçara	RS	4314308
4914	Pelotas	RS	4314407
4915	Picada Café	RS	4314423
4916	Pinhal	RS	4314456
4917	Pinhal da Serra	RS	4314464
4918	Pinhal Grande	RS	4314472
4919	Pinheirinho do Vale	RS	4314498
4920	Pinheiro Machado	RS	4314506
4921	Pirapó	RS	4314555
4922	Piratini	RS	4314605
4923	Planalto	RS	4314704
4924	Poço das Antas	RS	4314753
4925	Pontão	RS	4314779
4926	Ponte Preta	RS	4314787
4927	Portão	RS	4314803
4928	Porto Alegre	RS	4314902
4929	Porto Lucena	RS	4315008
4930	Porto Mauá	RS	4315057
4931	Porto Vera Cruz	RS	4315073
4932	Porto Xavier	RS	4315107
4933	Pouso Novo	RS	4315131
4934	Presidente Lucena	RS	4315149
4935	Progresso	RS	4315156
4936	Protásio Alves	RS	4315172
4937	Putinga	RS	4315206
4938	Quaraí	RS	4315305
4939	Quatro Irmãos	RS	4315313
4940	Quevedos	RS	4315321
4941	Quinze de Novembro	RS	4315354
4942	Redentora	RS	4315404
4943	Relvado	RS	4315453
4944	Restinga Seca	RS	4315503
4945	Rio dos Índios	RS	4315552
4946	Rio Grande	RS	4315602
4947	Rio Pardo	RS	4315701
4948	Riozinho	RS	4315750
4949	Roca Sales	RS	4315800
4950	Rodeio Bonito	RS	4315909
4951	Rolador	RS	4315958
4952	Rolante	RS	4316006
4953	Ronda Alta	RS	4316105
4954	Rondinha	RS	4316204
4955	Roque Gonzales	RS	4316303
4956	Rosário do Sul	RS	4316402
4957	Sagrada Família	RS	4316428
4958	Saldanha Marinho	RS	4316436
4959	Salto do Jacuí	RS	4316451
4960	Salvador das Missões	RS	4316477
4961	Salvador do Sul	RS	4316501
4962	Sananduva	RS	4316600
4963	Santa Bárbara do Sul	RS	4316709
4964	Santa Cecília do Sul	RS	4316733
4965	Santa Clara do Sul	RS	4316758
4966	Santa Cruz do Sul	RS	4316808
4967	Santa Margarida do Sul	RS	4316972
4968	Santa Maria	RS	4316907
4969	Santa Maria do Herval	RS	4316956
4970	Santa Rosa	RS	4317202
4971	Santa Tereza	RS	4317251
4972	Santa Vitória do Palmar	RS	4317301
4973	Santana da Boa Vista	RS	4317004
4974	Sant'Ana do Livramento	RS	4317103
4975	Santiago	RS	4317400
4976	Santo Ângelo	RS	4317509
4977	Santo Antônio da Patrulha	RS	4317608
4978	Santo Antônio das Missões	RS	4317707
4979	Santo Antônio do Palma	RS	4317558
4980	Santo Antônio do Planalto	RS	4317756
4981	Santo Augusto	RS	4317806
4982	Santo Cristo	RS	4317905
4983	Santo Expedito do Sul	RS	4317954
4984	São Borja	RS	4318002
4985	São Domingos do Sul	RS	4318051
4986	São Francisco de Assis	RS	4318101
4987	São Francisco de Paula	RS	4318200
4988	São Gabriel	RS	4318309
4989	São Jerônimo	RS	4318408
4990	São João da Urtiga	RS	4318424
4991	São João do Polêsine	RS	4318432
4992	São Jorge	RS	4318440
4993	São José das Missões	RS	4318457
4994	São José do Herval	RS	4318465
4995	São José do Hortêncio	RS	4318481
4996	São José do Inhacorá	RS	4318499
4997	São José do Norte	RS	4318507
4998	São José do Ouro	RS	4318606
4999	São José do Sul	RS	4318614
5000	São José dos Ausentes	RS	4318622
5001	São Leopoldo	RS	4318705
5002	São Lourenço do Sul	RS	4318804
5003	São Luiz Gonzaga	RS	4318903
5004	São Marcos	RS	4319000
5005	São Martinho	RS	4319109
5006	São Martinho da Serra	RS	4319125
5007	São Miguel das Missões	RS	4319158
5008	São Nicolau	RS	4319208
5009	São Paulo das Missões	RS	4319307
5010	São Pedro da Serra	RS	4319356
5011	São Pedro das Missões	RS	4319364
5012	São Pedro do Butiá	RS	4319372
5013	São Pedro do Sul	RS	4319406
5014	São Sebastião do Caí	RS	4319505
5015	São Sepé	RS	4319604
5016	São Valentim	RS	4319703
5017	São Valentim do Sul	RS	4319711
5018	São Valério do Sul	RS	4319737
5019	São Vendelino	RS	4319752
5020	São Vicente do Sul	RS	4319802
5021	Sapiranga	RS	4319901
5022	Sapucaia do Sul	RS	4320008
5023	Sarandi	RS	4320107
5024	Seberi	RS	4320206
5025	Sede Nova	RS	4320230
5026	Segredo	RS	4320263
5027	Selbach	RS	4320305
5028	Senador Salgado Filho	RS	4320321
5029	Sentinela do Sul	RS	4320354
5030	Serafina Corrêa	RS	4320404
5031	Sério	RS	4320453
5032	Sertão	RS	4320503
5033	Sertão Santana	RS	4320552
5034	Sete de Setembro	RS	4320578
5035	Severiano de Almeida	RS	4320602
5036	Silveira Martins	RS	4320651
5037	Sinimbu	RS	4320677
5038	Sobradinho	RS	4320701
5039	Soledade	RS	4320800
5040	Tabaí	RS	4320859
5041	Tapejara	RS	4320909
5042	Tapera	RS	4321006
5043	Tapes	RS	4321105
5044	Taquara	RS	4321204
5045	Taquari	RS	4321303
5046	Taquaruçu do Sul	RS	4321329
5047	Tavares	RS	4321352
5048	Tenente Portela	RS	4321402
5049	Terra de Areia	RS	4321436
5050	Teutônia	RS	4321451
5051	Tio Hugo	RS	4321469
5052	Tiradentes do Sul	RS	4321477
5053	Toropi	RS	4321493
5054	Torres	RS	4321501
5055	Tramandaí	RS	4321600
5056	Travesseiro	RS	4321626
5057	Três Arroios	RS	4321634
5058	Três Cachoeiras	RS	4321667
5059	Três Coroas	RS	4321709
5060	Três de Maio	RS	4321808
5061	Três Forquilhas	RS	4321832
5062	Três Palmeiras	RS	4321857
5063	Três Passos	RS	4321907
5064	Trindade do Sul	RS	4321956
5065	Triunfo	RS	4322004
5066	Tucunduva	RS	4322103
5067	Tunas	RS	4322152
5068	Tupanci do Sul	RS	4322186
5069	Tupanciretã	RS	4322202
5070	Tupandi	RS	4322251
5071	Tuparendi	RS	4322301
5072	Turuçu	RS	4322327
5073	Ubiretama	RS	4322343
5074	União da Serra	RS	4322350
5075	Unistalda	RS	4322376
5076	Uruguaiana	RS	4322400
5077	Vacaria	RS	4322509
5078	Vale do Sol	RS	4322533
5079	Vale Real	RS	4322541
5080	Vale Verde	RS	4322525
5081	Vanini	RS	4322558
5082	Venâncio Aires	RS	4322608
5083	Vera Cruz	RS	4322707
5084	Veranópolis	RS	4322806
5085	Vespasiano Correa	RS	4322855
5086	Viadutos	RS	4322905
5087	Viamão	RS	4323002
5088	Vicente Dutra	RS	4323101
5089	Victor Graeff	RS	4323200
5090	Vila Flores	RS	4323309
5091	Vila Lângaro	RS	4323358
5092	Vila Maria	RS	4323408
5093	Vila Nova do Sul	RS	4323457
5094	Vista Alegre	RS	4323507
5095	Vista Alegre do Prata	RS	4323606
5096	Vista Gaúcha	RS	4323705
5097	Vitória das Missões	RS	4323754
5098	Westfalia	RS	4323770
5099	Xangri-lá	RS	4323804
5100	Água Clara	MS	5000203
5101	Alcinópolis	MS	5000252
5102	Amambai	MS	5000609
5103	Anastácio	MS	5000708
5104	Anaurilândia	MS	5000807
5105	Angélica	MS	5000856
5106	Antônio João	MS	5000906
5107	Aparecida do Taboado	MS	5001003
5108	Aquidauana	MS	5001102
5109	Aral Moreira	MS	5001243
5110	Bandeirantes	MS	5001508
5111	Bataguassu	MS	5001904
5112	Batayporã	MS	5002001
5113	Bela Vista	MS	5002100
5114	Bodoquena	MS	5002159
5115	Bonito	MS	5002209
5116	Brasilândia	MS	5002308
5117	Caarapó	MS	5002407
5118	Camapuã	MS	5002605
5119	Campo Grande	MS	5002704
5120	Caracol	MS	5002803
5121	Cassilândia	MS	5002902
5122	Chapadão do Sul	MS	5002951
5123	Corguinho	MS	5003108
5124	Coronel Sapucaia	MS	5003157
5125	Corumbá	MS	5003207
5126	Costa Rica	MS	5003256
5127	Coxim	MS	5003306
5128	Deodápolis	MS	5003454
5129	Dois Irmãos do Buriti	MS	5003488
5130	Douradina	MS	5003504
5131	Dourados	MS	5003702
5132	Eldorado	MS	5003751
5133	Fátima do Sul	MS	5003801
5134	Figueirão	MS	5003900
5135	Glória de Dourados	MS	5004007
5136	Guia Lopes da Laguna	MS	5004106
5137	Iguatemi	MS	5004304
5138	Inocência	MS	5004403
5139	Itaporã	MS	5004502
5140	Itaquiraí	MS	5004601
5141	Ivinhema	MS	5004700
5142	Japorã	MS	5004809
5143	Jaraguari	MS	5004908
5144	Jardim	MS	5005004
5145	Jateí	MS	5005103
5146	Juti	MS	5005152
5147	Ladário	MS	5005202
5148	Laguna Carapã	MS	5005251
5149	Maracaju	MS	5005400
5150	Miranda	MS	5005608
5151	Mundo Novo	MS	5005681
5152	Naviraí	MS	5005707
5153	Nioaque	MS	5005806
5154	Nova Alvorada do Sul	MS	5006002
5155	Nova Andradina	MS	5006200
5156	Novo Horizonte do Sul	MS	5006259
5157	Paranaíba	MS	5006309
5158	Paranhos	MS	5006358
5159	Pedro Gomes	MS	5006408
5160	Ponta Porã	MS	5006606
5161	Porto Murtinho	MS	5006903
5162	Ribas do Rio Pardo	MS	5007109
5163	Rio Brilhante	MS	5007208
5164	Rio Negro	MS	5007307
5165	Rio Verde de Mato Grosso	MS	5007406
5166	Rochedo	MS	5007505
5167	Santa Rita do Pardo	MS	5007554
5168	São Gabriel do Oeste	MS	5007695
5169	Selvíria	MS	5007802
5170	Sete Quedas	MS	5007703
5171	Sidrolândia	MS	5007901
5172	Sonora	MS	5007935
5173	Tacuru	MS	5007950
5174	Taquarussu	MS	5007976
5175	Terenos	MS	5008008
5176	Três Lagoas	MS	5008305
5177	Vicentina	MS	5008404
5178	Acorizal	MT	5100102
5179	Água Boa	MT	5100201
5180	Alta Floresta	MT	5100250
5181	Alto Araguaia	MT	5100300
5182	Alto Boa Vista	MT	5100359
5183	Alto Garças	MT	5100409
5184	Alto Paraguai	MT	5100508
5185	Alto Taquari	MT	5100607
5186	Apiacás	MT	5100805
5187	Araguaiana	MT	5101001
5188	Araguainha	MT	5101209
5189	Araputanga	MT	5101258
5190	Arenápolis	MT	5101308
5191	Aripuanã	MT	5101407
5192	Barão de Melgaço	MT	5101605
5193	Barra do Bugres	MT	5101704
5194	Barra do Garças	MT	5101803
5195	Bom Jesus do Araguaia	MT	5101852
5196	Brasnorte	MT	5101902
5197	Cáceres	MT	5102504
5198	Campinápolis	MT	5102603
5199	Campo Novo do Parecis	MT	5102637
5200	Campo Verde	MT	5102678
5201	Campos de Júlio	MT	5102686
5202	Canabrava do Norte	MT	5102694
5203	Canarana	MT	5102702
5204	Carlinda	MT	5102793
5205	Castanheira	MT	5102850
5206	Chapada dos Guimarães	MT	5103007
5207	Cláudia	MT	5103056
5208	Cocalinho	MT	5103106
5209	Colíder	MT	5103205
5210	Colniza	MT	5103254
5211	Comodoro	MT	5103304
5212	Confresa	MT	5103353
5213	Conquista D'Oeste	MT	5103361
5214	Cotriguaçu	MT	5103379
5215	Cuiabá	MT	5103403
5216	Curvelândia	MT	5103437
5217	Denise	MT	5103452
5218	Diamantino	MT	5103502
5219	Dom Aquino	MT	5103601
5220	Feliz Natal	MT	5103700
5221	Figueirópolis D'Oeste	MT	5103809
5222	Gaúcha do Norte	MT	5103858
5223	General Carneiro	MT	5103908
5224	Glória D'Oeste	MT	5103957
5225	Guarantã do Norte	MT	5104104
5226	Guiratinga	MT	5104203
5227	Indiavaí	MT	5104500
5228	Ipiranga do Norte	MT	5104526
5229	Itanhangá	MT	5104542
5230	Itaúba	MT	5104559
5231	Itiquira	MT	5104609
5232	Jaciara	MT	5104807
5233	Jangada	MT	5104906
5234	Jauru	MT	5105002
5235	Juara	MT	5105101
5236	Juína	MT	5105150
5237	Juruena	MT	5105176
5238	Juscimeira	MT	5105200
5239	Lambari D'Oeste	MT	5105234
5240	Lucas do Rio Verde	MT	5105259
5241	Luciara	MT	5105309
5242	Marcelândia	MT	5105580
5243	Matupá	MT	5105606
5244	Mirassol d'Oeste	MT	5105622
5245	Nobres	MT	5105903
5246	Nortelândia	MT	5106000
5247	Nossa Senhora do Livramento	MT	5106109
5248	Nova Bandeirantes	MT	5106158
5249	Nova Brasilândia	MT	5106208
5250	Nova Canaã do Norte	MT	5106216
5251	Nova Guarita	MT	5108808
5252	Nova Lacerda	MT	5106182
5253	Nova Marilândia	MT	5108857
5254	Nova Maringá	MT	5108907
5255	Nova Monte Verde	MT	5108956
5256	Nova Mutum	MT	5106224
5257	Nova Nazaré	MT	5106174
5258	Nova Olímpia	MT	5106232
5259	Nova Santa Helena	MT	5106190
5260	Nova Ubiratã	MT	5106240
5261	Nova Xavantina	MT	5106257
5262	Novo Horizonte do Norte	MT	5106273
5263	Novo Mundo	MT	5106265
5264	Novo Santo Antônio	MT	5106315
5265	Novo São Joaquim	MT	5106281
5266	Paranaíta	MT	5106299
5267	Paranatinga	MT	5106307
5268	Pedra Preta	MT	5106372
5269	Peixoto de Azevedo	MT	5106422
5270	Planalto da Serra	MT	5106455
5271	Poconé	MT	5106505
5272	Pontal do Araguaia	MT	5106653
5273	Ponte Branca	MT	5106703
5274	Pontes e Lacerda	MT	5106752
5275	Porto Alegre do Norte	MT	5106778
5276	Porto dos Gaúchos	MT	5106802
5277	Porto Esperidião	MT	5106828
5278	Porto Estrela	MT	5106851
5279	Poxoréo	MT	5107008
5280	Primavera do Leste	MT	5107040
5281	Querência	MT	5107065
5282	Reserva do Cabaçal	MT	5107156
5283	Ribeirão Cascalheira	MT	5107180
5284	Ribeirãozinho	MT	5107198
5285	Rio Branco	MT	5107206
5286	Rondolândia	MT	5107578
5287	Rondonópolis	MT	5107602
5288	Rosário Oeste	MT	5107701
5289	Salto do Céu	MT	5107750
5290	Santa Carmem	MT	5107248
5291	Santa Cruz do Xingu	MT	5107743
5292	Santa Rita do Trivelato	MT	5107768
5293	Santa Terezinha	MT	5107776
5294	Santo Afonso	MT	5107263
5295	Santo Antônio do Leste	MT	5107792
5296	Santo Antônio do Leverger	MT	5107800
5297	São Félix do Araguaia	MT	5107859
5298	São José do Povo	MT	5107297
5299	São José do Rio Claro	MT	5107305
5300	São José do Xingu	MT	5107354
5301	São José dos Quatro Marcos	MT	5107107
5302	São Pedro da Cipa	MT	5107404
5303	Sapezal	MT	5107875
5304	Serra Nova Dourada	MT	5107883
5305	Sinop	MT	5107909
5306	Sorriso	MT	5107925
5307	Tabaporã	MT	5107941
5308	Tangará da Serra	MT	5107958
5309	Tapurah	MT	5108006
5310	Terra Nova do Norte	MT	5108055
5311	Tesouro	MT	5108105
5312	Torixoréu	MT	5108204
5313	União do Sul	MT	5108303
5314	Vale de São Domingos	MT	5108352
5315	Várzea Grande	MT	5108402
5316	Vera	MT	5108501
5317	Vila Bela da Santíssima Trindade	MT	5105507
5318	Vila Rica	MT	5108600
5319	Abadia de Goiás	GO	5200050
5320	Abadiânia	GO	5200100
5321	Acreúna	GO	5200134
5322	Adelândia	GO	5200159
5323	Água Fria de Goiás	GO	5200175
5324	Água Limpa	GO	5200209
5325	Águas Lindas de Goiás	GO	5200258
5326	Alexânia	GO	5200308
5327	Aloândia	GO	5200506
5328	Alto Horizonte	GO	5200555
5329	Alto Paraíso de Goiás	GO	5200605
5330	Alvorada do Norte	GO	5200803
5331	Amaralina	GO	5200829
5332	Americano do Brasil	GO	5200852
5333	Amorinópolis	GO	5200902
5334	Anápolis	GO	5201108
5335	Anhanguera	GO	5201207
5336	Anicuns	GO	5201306
5337	Aparecida de Goiânia	GO	5201405
5338	Aparecida do Rio Doce	GO	5201454
5339	Aporé	GO	5201504
5340	Araçu	GO	5201603
5341	Aragarças	GO	5201702
5342	Aragoiânia	GO	5201801
5343	Araguapaz	GO	5202155
5344	Arenópolis	GO	5202353
5345	Aruanã	GO	5202502
5346	Aurilândia	GO	5202601
5347	Avelinópolis	GO	5202809
5348	Baliza	GO	5203104
5349	Barro Alto	GO	5203203
5350	Bela Vista de Goiás	GO	5203302
5351	Bom Jardim de Goiás	GO	5203401
5352	Bom Jesus de Goiás	GO	5203500
5353	Bonfinópolis	GO	5203559
5354	Bonópolis	GO	5203575
5355	Brazabrantes	GO	5203609
5356	Britânia	GO	5203807
5357	Buriti Alegre	GO	5203906
5358	Buriti de Goiás	GO	5203939
5359	Buritinópolis	GO	5203962
5360	Cabeceiras	GO	5204003
5361	Cachoeira Alta	GO	5204102
5362	Cachoeira de Goiás	GO	5204201
5363	Cachoeira Dourada	GO	5204250
5364	Caçu	GO	5204300
5365	Caiapônia	GO	5204409
5366	Caldas Novas	GO	5204508
5367	Caldazinha	GO	5204557
5368	Campestre de Goiás	GO	5204607
5369	Campinaçu	GO	5204656
5370	Campinorte	GO	5204706
5371	Campo Alegre de Goiás	GO	5204805
5372	Campo Limpo de Goiás	GO	5204854
5373	Campos Belos	GO	5204904
5374	Campos Verdes	GO	5204953
5375	Carmo do Rio Verde	GO	5205000
5376	Castelândia	GO	5205059
5377	Catalão	GO	5205109
5378	Caturaí	GO	5205208
5379	Cavalcante	GO	5205307
5380	Ceres	GO	5205406
5381	Cezarina	GO	5205455
5382	Chapadão do Céu	GO	5205471
5383	Cidade Ocidental	GO	5205497
5384	Cocalzinho de Goiás	GO	5205513
5385	Colinas do Sul	GO	5205521
5386	Córrego do Ouro	GO	5205703
5387	Corumbá de Goiás	GO	5205802
5388	Corumbaíba	GO	5205901
5389	Cristalina	GO	5206206
5390	Cristianópolis	GO	5206305
5391	Crixás	GO	5206404
5392	Cromínia	GO	5206503
5393	Cumari	GO	5206602
5394	Damianópolis	GO	5206701
5395	Damolândia	GO	5206800
5396	Davinópolis	GO	5206909
5397	Diorama	GO	5207105
5398	Divinópolis de Goiás	GO	5208301
5399	Doverlândia	GO	5207253
5400	Edealina	GO	5207352
5401	Edéia	GO	5207402
5402	Estrela do Norte	GO	5207501
5403	Faina	GO	5207535
5404	Fazenda Nova	GO	5207600
5405	Firminópolis	GO	5207808
5406	Flores de Goiás	GO	5207907
5407	Formosa	GO	5208004
5408	Formoso	GO	5208103
5409	Gameleira de Goiás	GO	5208152
5410	Goianápolis	GO	5208400
5411	Goiandira	GO	5208509
5412	Goianésia	GO	5208608
5413	Goiânia	GO	5208707
5414	Goianira	GO	5208806
5415	Goiás	GO	5208905
5416	Goiatuba	GO	5209101
5417	Gouvelândia	GO	5209150
5418	Guapó	GO	5209200
5419	Guaraíta	GO	5209291
5420	Guarani de Goiás	GO	5209408
5421	Guarinos	GO	5209457
5422	Heitoraí	GO	5209606
5423	Hidrolândia	GO	5209705
5424	Hidrolina	GO	5209804
5425	Iaciara	GO	5209903
5426	Inaciolândia	GO	5209937
5427	Indiara	GO	5209952
5428	Inhumas	GO	5210000
5429	Ipameri	GO	5210109
5430	Ipiranga de Goiás	GO	5210158
5431	Iporá	GO	5210208
5432	Israelândia	GO	5210307
5433	Itaberaí	GO	5210406
5434	Itaguari	GO	5210562
5435	Itaguaru	GO	5210604
5436	Itajá	GO	5210802
5437	Itapaci	GO	5210901
5438	Itapirapuã	GO	5211008
5439	Itapuranga	GO	5211206
5440	Itarumã	GO	5211305
5441	Itauçu	GO	5211404
5442	Itumbiara	GO	5211503
5443	Ivolândia	GO	5211602
5444	Jandaia	GO	5211701
5445	Jaraguá	GO	5211800
5446	Jataí	GO	5211909
5447	Jaupaci	GO	5212006
5448	Jesúpolis	GO	5212055
5449	Joviânia	GO	5212105
5450	Jussara	GO	5212204
5451	Lagoa Santa	GO	5212253
5452	Leopoldo de Bulhões	GO	5212303
5453	Luziânia	GO	5212501
5454	Mairipotaba	GO	5212600
5455	Mambaí	GO	5212709
5456	Mara Rosa	GO	5212808
5457	Marzagão	GO	5212907
5458	Matrinchã	GO	5212956
5459	Maurilândia	GO	5213004
5460	Mimoso de Goiás	GO	5213053
5461	Minaçu	GO	5213087
5462	Mineiros	GO	5213103
5463	Moiporá	GO	5213400
5464	Monte Alegre de Goiás	GO	5213509
5465	Montes Claros de Goiás	GO	5213707
5466	Montividiu	GO	5213756
5467	Montividiu do Norte	GO	5213772
5468	Morrinhos	GO	5213806
5469	Morro Agudo de Goiás	GO	5213855
5470	Mossâmedes	GO	5213905
5471	Mozarlândia	GO	5214002
5472	Mundo Novo	GO	5214051
5473	Mutunópolis	GO	5214101
5474	Nazário	GO	5214408
5475	Nerópolis	GO	5214507
5476	Niquelândia	GO	5214606
5477	Nova América	GO	5214705
5478	Nova Aurora	GO	5214804
5479	Nova Crixás	GO	5214838
5480	Nova Glória	GO	5214861
5481	Nova Iguaçu de Goiás	GO	5214879
5482	Nova Roma	GO	5214903
5483	Nova Veneza	GO	5215009
5484	Novo Brasil	GO	5215207
5485	Novo Gama	GO	5215231
5486	Novo Planalto	GO	5215256
5487	Orizona	GO	5215306
5488	Ouro Verde de Goiás	GO	5215405
5489	Ouvidor	GO	5215504
5490	Padre Bernardo	GO	5215603
5491	Palestina de Goiás	GO	5215652
5492	Palmeiras de Goiás	GO	5215702
5493	Palmelo	GO	5215801
5494	Palminópolis	GO	5215900
5495	Panamá	GO	5216007
5496	Paranaiguara	GO	5216304
5497	Paraúna	GO	5216403
5498	Perolândia	GO	5216452
5499	Petrolina de Goiás	GO	5216809
5500	Pilar de Goiás	GO	5216908
5501	Piracanjuba	GO	5217104
5502	Piranhas	GO	5217203
5503	Pirenópolis	GO	5217302
5504	Pires do Rio	GO	5217401
5505	Planaltina	GO	5217609
5506	Pontalina	GO	5217708
5507	Porangatu	GO	5218003
5508	Porteirão	GO	5218052
5509	Portelândia	GO	5218102
5510	Posse	GO	5218300
5511	Professor Jamil	GO	5218391
5512	Quirinópolis	GO	5218508
5513	Rialma	GO	5218607
5514	Rianápolis	GO	5218706
5515	Rio Quente	GO	5218789
5516	Rio Verde	GO	5218805
5517	Rubiataba	GO	5218904
5518	Sanclerlândia	GO	5219001
5519	Santa Bárbara de Goiás	GO	5219100
5520	Santa Cruz de Goiás	GO	5219209
5521	Santa Fé de Goiás	GO	5219258
5522	Santa Helena de Goiás	GO	5219308
5523	Santa Isabel	GO	5219357
5524	Santa Rita do Araguaia	GO	5219407
5525	Santa Rita do Novo Destino	GO	5219456
5526	Santa Rosa de Goiás	GO	5219506
5527	Santa Tereza de Goiás	GO	5219605
5528	Santa Terezinha de Goiás	GO	5219704
5529	Santo Antônio da Barra	GO	5219712
5530	Santo Antônio de Goiás	GO	5219738
5531	Santo Antônio do Descoberto	GO	5219753
5532	São Domingos	GO	5219803
5533	São Francisco de Goiás	GO	5219902
5534	São João da Paraúna	GO	5220058
5535	São João d'Aliança	GO	5220009
5536	São Luís de Montes Belos	GO	5220108
5537	São Luíz do Norte	GO	5220157
5538	São Miguel do Araguaia	GO	5220207
5539	São Miguel do Passa Quatro	GO	5220264
5540	São Patrício	GO	5220280
5541	São Simão	GO	5220405
5542	Senador Canedo	GO	5220454
5543	Serranópolis	GO	5220504
5544	Silvânia	GO	5220603
5545	Simolândia	GO	5220686
5546	Sítio d'Abadia	GO	5220702
5547	Taquaral de Goiás	GO	5221007
5548	Teresina de Goiás	GO	5221080
5549	Terezópolis de Goiás	GO	5221197
5550	Três Ranchos	GO	5221304
5551	Trindade	GO	5221403
5552	Trombas	GO	5221452
5553	Turvânia	GO	5221502
5554	Turvelândia	GO	5221551
5555	Uirapuru	GO	5221577
5556	Uruaçu	GO	5221601
5557	Uruana	GO	5221700
5558	Urutaí	GO	5221809
5559	Valparaíso de Goiás	GO	5221858
5560	Varjão	GO	5221908
5561	Vianópolis	GO	5222005
5562	Vicentinópolis	GO	5222054
5563	Vila Boa	GO	5222203
5564	Vila Propício	GO	5222302
5565	Brasília	DF	5300108
\.


--
-- Name: cidade_cid_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.cidade_cid_cod_seq', 5565, true);


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.empresa (emp_cod, emp_nome, emp_cnpj, emp_end_logradouro, emp_end_nome, emp_end_complemento, emp_end_numero, emp_end_bairro, emp_end_cep, emp_cidade_cod, emp_telefone, emp_celular, emp_email, emp_site, emp_criadoem, emp_criadopor_cod, emp_origem_cod, emp_atendente_cod, emp_servico_cod, emp_categoria_cod, emp_nivel_cod, emp_apelido_cod, emp_razao_cod, emp_ult_negocio_cod) FROM stdin;
238	Marcos Perez 	07278596000135	Rua					        	\N			marcosperez.sp@gmail.com		2018-01-12 13:41:14.552	3	7	3	4	2	1		Marcos Perez - ME	636
237	INOVATEC PROCESSAMENTO DE DADOS LTDA - ME  	24493497000195	Rua					        	\N		11 - 998990183	rita.c.fonteles@gmail.com		2018-01-03 17:06:04.206	3	2	3	4	2	1		INOVATEC PROCESSAMENTO DE DADOS LTDA - ME  	635
241	Sergio Narimatsu	26344511000114	Rua					        	\N			sergio.narimatsu@4hcm.com.br		2018-01-24 16:42:06.793	2	15	3	4	2	\N		Human Capital Management Serviços e Consultoria em Software Ltda	640
242	Jaime	              	Rua					        	3656		95966-3983			2018-02-08 09:12:08.784	2	15	2	4	2	\N			\N
258	Dr. Pasquale	08277467000186	Avenida					        	3831		97375-3171 	p.savarese@terra.com.br		2018-03-23 15:43:15.665	2	2	8	4	7	10		P.R. SAVARESE SERVIÇOS MÉDICOS	662
255	Célia	              	Avenida					        	\N	3215-8555		financeiro@condutron.com.br	www.condutron.com.br	2018-03-14 10:38:36.208	2	4	2	3	2	\N		Condutron Cabos Elétricos Ltda-EPP	657
247	Diego Marinello	              	Avenida					        	\N	3791-0604	98107-3386	contato@thegrowlermarket.com.br	http://thegrowlermarket.com.br/	2018-02-19 17:31:32.844	2	12	2	\N	2	\N		Growler Market	647
245	Rêne Mena Lopes	12759061000116	Rua	Mazagao		112	PATRIARCA	03555000	3831	11 31360849	11 951944338	rene.lopes@binary-it.com.br		2018-02-16 08:55:17.376	3	7	3	4	2	8		Binary Comercio e Serviços de Informatica LTDA - ME	645
251	Adejailson	05947273000161	Avenida					        	3831		98118-3637	adejailson.luna@gmail.com		2018-02-28 12:14:49.349	2	\N	3	4	2	7		LUNA DESENV. DE SISTEMAS EM INFORMATICA LTDA	650
259	Igreja Batista da Liberdade	43198514000106	Rua	Santo Amaro		412	Bela Vista	        	3831	3293-2406	99631-6406	administracao.rissato@libernet.org.br	www.libernet.org.br	2018-04-04 11:03:47.481	2	5	8	4	2	\N	Francisco Rissato	IGREJA BATISTA DA LIBERDADE	667
244	Sergio Zimmermann	29233701000152	Rua					        	3831		99535-9348	loft.tieteplaza@gmail.com		2018-02-15 09:27:13.997	2	11	2	4	2	4		Loft tiete plaza	643
263	Ateliê Sorriso	              	Rua					        	\N	3284-8396	99189-4028	ateliesorriso.adm@hotmail.com		2018-04-11 09:49:24.829	2	15	2	4	2	1	Dra. Gabriela/Raquel		671
267	Compuwise Informática	              	Rua					        	\N	97231-6770		erich@compuwise.com.br		2018-05-16 13:52:55.51	9	7	9	4	2	3	Compuwisec	Reunião Prolink Contábil!	680
269	May Clothing Modas	              	Rua					        	\N	94576-3845	945763845	luriro@hotmail.com		2018-06-06 11:42:44.093	9	7	9	3	1	1		May Clothing Modas	683
270	Elpidio	03282201000117	Rua					        	3831	3042-4910	97558-4064	elpidio@aeoninformatica.com.br		2018-06-18 16:40:42.029	2	2	2	4	7	10		ELPIDIO CERQUEIRA DA SILVA JUNIOR MAQUINAS	686
8	Rainer	\N	\N	\N	\N	\N	\N	\N	\N			arteedoces28@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	55
260	QUALITY	              	Rua					        	\N			moya@runinvestimentos.com.br		2018-04-05 16:15:01.535	2	15	8	4	2	10	Marcelo Oya 	QUALITY SERVICOS ADMINISTRATIVOS LTDA.	668
239	Gilberto Ramos	18929561000135	Rua					        	\N	11 95617-6491 		gilberto.ramos@smartfix.com.br		2018-01-15 10:41:01.341	3	7	3	4	3	7		SMART FIX ESPECIALISTA EM DESENVOLVER NEGOCIOS E SOLUÇÕES LTDA – EPP	637
243	Raquel	03358129000164	Rua					        	3831		11 991039593	raquelgaliel@gmail.com		2018-02-09 13:56:43.952	2	\N	3	\N	2	1		Buffet Damira LTDA - ME	641
256	Carmem Costa	21119223000142	Avenida					        	3831	3759-2261		carmemcosta@tabghaturismo.com.br	www.tabghaturismo.com.br	2018-03-15 13:43:58.981	2	\N	2	4	2	\N		TABGHA VIAGENS E TURISMO LTDA 	659
246	Aeon informática	07032643000166	Avenida	Zumkeller	21º andar, sala 212, torre 1	933		        	3831	3459-9985	97558-4064	helio@aeoninformatica.com.br		2018-02-16 08:58:57.594	2	4	3	4	2	9		AEON CONSULTORIA EM INFORMATICA LTDA	644
252	Fernando Cesar Rodrigues	              	Avenida					        	\N	3664-2040		fernando.rodrigues@sistemas-seguros.com.br		2018-03-06 11:18:45.058	8	2	8	\N	7	\N		Sistemas Segurs	653
248	Miguel di Ciurcio	13553461000133	Avenida					        	\N		19 996022781	miguel@instruct.com.br	http://thegrowlermarket.com.br/	2018-02-19 17:47:35.502	3	7	3	4	2	5		Instruct treinamento e Desenvolvimento de Software LTDA	646
264	Dra. Claryssa	11385169000123	Rua					        	3831		98188-3816	k_cla@yahoo.com		2018-05-03 16:43:55.71	2	5	2	4	2	\N		Suclajum Servicos Medicos Ltda	674
268	Viviane Lunelli	              	Rua					        	\N	11 99971 3497				2018-05-23 14:16:27.874	9	7	9	4	2	7		Lunelli Consultoria De Informática Ltda	681
271	Renata Arassiro 	              	Rua					        	\N	5092-4977		renata.arassiro@gmail.com		2018-06-25 11:15:11.708	9	7	9	4	2	7		Renata Arassiro Chocolates	688
6	Shirley Akemi	\N	\N	\N	\N	\N	\N	\N	\N	26399107	966017946	shirley.tomita@wizardliberdade.com.br		2015-03-26 00:00:00	2	3	2	\N	2	\N	\N	\N	16
183	Bruno - VFUNG	\N	\N	\N	\N	\N	\N	\N	\N		993909920	brunosantimv@gmail.com		2016-07-05 00:00:00	4	2	4	\N	2	\N	\N	\N	439
21	Adriano Heleno	\N	\N	\N	\N	\N	\N	\N	\N	55211196		adrieli@uol.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	42
257	Hugo Pessoa	08277467000186	Avenida					        	\N		99786-1207	hugopessoa@hotmail.com		2018-03-16 15:52:13.322	2	5	8	4	2	1			660
249	Tercio Vasconcelos	              	Avenida					        	\N	3842-3822 	99315-3300	tercio.vasconcelos@innovates.com.br		2018-02-26 09:50:28.482	2	2	3	3	7	7			648
250	Maria Luiza Chakkour	03570392000112	Avenida				Paraíso	        	3831	3284-5734	99742-1626	dramarialuiza@uol.com.br		2018-02-26 10:22:48.774	2	15	3	4	2	1		CLINICA MEDICA E ORTOPEDICA CHAKKOUR S/S LTDA 	649
265	Hélio Cerqueira	              	Rua					        	\N	3042-4910 		helio@aeoninformatica.com.br		2018-05-07 09:23:57.533	2	2	2	3	7	3		AEON CONSULTORIA EM INFORMATICA LTDA	675
253	ALINE	21119223000142	Avenida					        	\N	97563-8158		contabilidade@cpfcursos.com.br		2018-03-12 17:32:18.018	8	5	8	\N	2	\N		CPF CURSOS	655
240	Alexandre Yahaguita	02373566000194	Rua	TASSELLI UGO 		171	VILA DALVA	05387000	3831		11-99953-5034	alexandre@easyhelp.com.br		2018-01-18 13:50:13.277	3	4	3	4	2	1		ALEXANDRE YANAGUITA & CIA LTDA - ME 	639
149	Willian José Dias	              	Avenida					        	\N	50967051		financeiro@w3video.com.br		2016-03-01 00:00:00	2	19	2	\N	2	\N			357
254	Pizzaria Art & Sabor	              	Avenida				Santo Amaro	        	3831		99953-1067	dinis.ar@hotmail.com		2018-03-13 14:04:32.925	2	\N	2	4	2	4	Dinis		656
262	Rodrigo	              	Rua					        	\N		98158-6443	rckosai@gmail.com		2018-04-10 12:12:01.657	2	15	4	4	2	7			678
266	SERGIO NARIMATSU	              	Rua					        	3713	5504-0196	98196-4198 	sergio.narimatsu@gmail.com 		2018-05-08 15:46:14.708	2	2	8	3	7	7			677
7	Edson da Silva Brasil	\N	\N	\N	\N	\N	\N	\N	\N	36642040		administrativo@sistemas-seguros.com.br		2015-05-08 00:00:00	6	5	6	\N	2	\N	\N	\N	135
9	Manoel Belo da Silva Junior	\N	\N	\N	\N	\N	\N	\N	\N		971483885	manoel_belojr@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	33
10	Regina Santos	\N	\N	\N	\N	\N	\N	\N	\N	1932764046		acquaflor@hotmail.com		2015-11-18 00:00:00	4	3	4	\N	2	\N	\N	\N	35
11	Rafael Padovani	\N	\N	\N	\N	\N	\N	\N	\N	42293544		rafael@rochalima.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	36
12	Sidney	\N	\N	\N	\N	\N	\N	\N	\N	1144925059		cdmr_adm@hotmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	37
13	Roberta Wane de Lima Moreira	\N	\N	\N	\N	\N	\N	\N	\N		981814355	robertawane@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	38
74	Marcos	\N	\N	\N	\N	\N	\N	\N	\N		11977585098	ma64@ig.com.br		2015-04-09 00:00:00	4	6	4	\N	2	\N	\N	\N	140
14	Willian	\N	\N	\N	\N	\N	\N	\N	\N	1124848941		contato@tecorplas.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	39
15	Otaide Cardoso	\N	\N	\N	\N	\N	\N	\N	\N	34483311	78326278	otaide_cardoso@ig.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	40
16	Cristina	\N	\N	\N	\N	\N	\N	\N	\N		992562050	cristina@gruposetec.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	61
17	Walter Cardoso	\N	\N	\N	\N	\N	\N	\N	\N		992447421	innovaerografia@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	66
18	Ariani Cabral Mol	\N	\N	\N	\N	\N	\N	\N	\N			arianimol@gestaohumana.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	62
19	Eron	\N	\N	\N	\N	\N	\N	\N	\N		989774721	eron_ex@hotmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	41
20	Antonio Pedro	\N	\N	\N	\N	\N	\N	\N	\N		987529908	pedro@bemvender.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	63
22	Sydnei Leme	\N	\N	\N	\N	\N	\N	\N	\N	36013353		leneplas@terra.com.br / adm_leneplas@ter		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	43
23	Dra. Claudia Martins Cosentino	\N	\N	\N	\N	\N	\N	\N	\N		11999224006	claudia.mcosentino@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	106
24	Ari Pereira	\N	\N	\N	\N	\N	\N	\N	\N		11985969916	ari@englishcommunication.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	64
25	Roseni Araujo	\N	\N	\N	\N	\N	\N	\N	\N	59344363	958663958	jacileideduarte@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	44
26	José Espalaor	\N	\N	\N	\N	\N	\N	\N	\N		9956132579	ligligmoema@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	65
27	José Salvino	\N	\N	\N	\N	\N	\N	\N	\N		942036658	oqueacrescenta@live.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	67
28	José Carlos	\N	\N	\N	\N	\N	\N	\N	\N	22180048		piu_jose@ig.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	45
29	Luiz Cesa	\N	\N	\N	\N	\N	\N	\N	\N	58346361		jack.salgados@hotmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	68
30	Karine Moriya	\N	\N	\N	\N	\N	\N	\N	\N			karine@jgmoriya.com.br		2015-03-26 00:00:00	5	2	5	\N	2	\N	\N	\N	96
31	Luis LH	\N	\N	\N	\N	\N	\N	\N	\N	21340650	912627480	vanrooy@vanrooy.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	46
32	Luis Vanrooy	\N	\N	\N	\N	\N	\N	\N	\N	21340650	91627480	vanrooy@vanrooy.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	47
33	Lion	\N	\N	\N	\N	\N	\N	\N	\N		988305362	omegha.lionflacker@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	48
34	Sra. Priscila	\N	\N	\N	\N	\N	\N	\N	\N	55462508		makis.mais13@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	98
35	Laercio Seraphim	\N	\N	\N	\N	\N	\N	\N	\N	20543721	28195903	seraphim_d@bol.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	49
36	Marcos	\N	\N	\N	\N	\N	\N	\N	\N		967880653	picture.reformas@bol.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	72
37	Vera	\N	\N	\N	\N	\N	\N	\N	\N		968252929	vera.rezio@hotmail.com		2015-02-24 00:00:00	6	\N	6	\N	2	\N	\N	\N	73
38	Cicero Costa	\N	\N	\N	\N	\N	\N	\N	\N		983608437	c-costa-nascimento2014@bol.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	50
39	João e Gabriel	\N	\N	\N	\N	\N	\N	\N	\N			jpcosta@mauaecosta.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	99
40	IGOR	\N	\N	\N	\N	\N	\N	\N	\N		77188618	igor@hooperbay.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	101
41	Reinaldo	\N	\N	\N	\N	\N	\N	\N	\N		982042541	rei.augus@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	74
42	Helder Oliveira	\N	\N	\N	\N	\N	\N	\N	\N	27653965		shopex.net@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	51
43	Luiz de Nascimento	\N	\N	\N	\N	\N	\N	\N	\N	43786713	991399373	adm@securityfoco.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	75
44	Michele Oliveira	\N	\N	\N	\N	\N	\N	\N	\N	1533145833		michele@oliveiralemos.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	52
45	Andres Alvarez	\N	\N	\N	\N	\N	\N	\N	\N	1138484444		andres.alvarez@talentfour.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	105
46	Cesar Augusto Avila ME	\N	\N	\N	\N	\N	\N	\N	\N			cesaravila.consultor@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	76
47	Hernandes	\N	\N	\N	\N	\N	\N	\N	\N		941023644	hernandes.sena@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	53
48	Dra. Francini Mattos	\N	\N	\N	\N	\N	\N	\N	\N		11999045682	francinimattos@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	108
49	Raphael	\N	\N	\N	\N	\N	\N	\N	\N	26287498		raphael@agenciacrossmidia.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	77
50	Demetrius	\N	\N	\N	\N	\N	\N	\N	\N		983124218	criativo_sucesso@hotmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	54
51	Anderson Pereira	\N	\N	\N	\N	\N	\N	\N	\N	39431111		gordinhosassessorios@uol.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	78
52	André	\N	\N	\N	\N	\N	\N	\N	\N		982152727	andremaybach@hotmail.com		2015-03-26 00:00:00	6	9	6	\N	2	\N	\N	\N	111
53	Rosangela	\N	\N	\N	\N	\N	\N	\N	\N	35789791		rosangelacassenote@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	79
54	Dra. Lilian	\N	\N	\N	\N	\N	\N	\N	\N		11994636838	limed_balta@yahoo.com.br		2015-09-30 00:00:00	4	9	4	\N	2	\N	\N	\N	114
55	Rodrigo Galati	\N	\N	\N	\N	\N	\N	\N	\N	997497440	997497449	rodrigo.galati@gmail.com		2015-11-18 00:00:00	5	3	5	\N	2	\N	\N	\N	80
56	Fabricio Miranda	\N	\N	\N	\N	\N	\N	\N	\N	30297513		fabricio.miranda@sitilog.com.br		2015-11-18 00:00:00	5	3	5	\N	2	\N	\N	\N	81
57	Karine	\N	\N	\N	\N	\N	\N	\N	\N	32930015		gerencia@rayesaadv.com.br		2015-03-26 00:00:00	5	2	5	\N	2	\N	\N	\N	116
58	Bruno de Azevedo Teixeira	\N	\N	\N	\N	\N	\N	\N	\N		1198955350	brunojankowisk@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	117
59	Carolina Rocha	\N	\N	\N	\N	\N	\N	\N	\N	32622782		rocha@ibs-br.com.br		2015-03-26 00:00:00	5	5	5	\N	2	\N	\N	\N	82
60	Glaucia Maria Maciel	\N	\N	\N	\N	\N	\N	\N	\N		961010101	g.guira@terra.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	119
61	Carolina Rocha - IBS	\N	\N	\N	\N	\N	\N	\N	\N	32622782		rocha@ibs-br.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	83
62	Glaucia Maria Maciel	\N	\N	\N	\N	\N	\N	\N	\N		961610101	g.guira@terra.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	120
63	Carolina Rocha Praxian	\N	\N	\N	\N	\N	\N	\N	\N			rocha@ibs-br.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	84
64	Sr. Christiano (Lyncra)	\N	\N	\N	\N	\N	\N	\N	\N	38733732	941897770	christiano@lyncra.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	124
65	Bruna	\N	\N	\N	\N	\N	\N	\N	\N		999726089	bru_fugice@hotmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	126
66	Tassia Santana	\N	\N	\N	\N	\N	\N	\N	\N		982783635	tassia-santos@hotmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	85
68	Dr. Rene	\N	\N	\N	\N	\N	\N	\N	\N	31018015		renesantos@adv.oabsp.org.br		2015-05-06 00:00:00	6	5	6	\N	2	\N	\N	\N	156
69	Rodrigo Eilliar	\N	\N	\N	\N	\N	\N	\N	\N		963823465	reilliar@gmail.com		2015-05-07 00:00:00	6	5	6	\N	2	\N	\N	\N	157
67	Eduardo Marcel	\N	\N	\N	\N	\N	\N	\N	\N			edu.bursi@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	86
86	Takamori	\N	\N	\N	\N	\N	\N	\N	\N					2015-10-29 00:00:00	2	\N	2	\N	2	\N	\N	\N	240
70	MAURO MANCIO DA SILVA	\N	\N	\N	\N	\N	\N	\N	\N	1134816129		m.mancio@gmail.com		2015-05-11 00:00:00	6	2	6	\N	2	\N	\N	\N	159
71	Mary Pacheco	\N	\N	\N	\N	\N	\N	\N	\N	1135863200	11994731801	mary@weblinemobile.com.br		2015-05-07 00:00:00	6	2	6	\N	2	\N	\N	\N	158
73	Nilson Pereira Megatronik	\N	\N	\N	\N	\N	\N	\N	\N	30215561		nilson@megatronik.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	88
75	Marina	\N	\N	\N	\N	\N	\N	\N	\N		1131671949	financeiro@maluferodrigues.adv.br		2015-08-25 00:00:00	6	5	6	\N	2	\N	\N	\N	131
76	Thiago luis	\N	\N	\N	\N	\N	\N	\N	\N			tlpereira1000@gmail.com		2015-04-10 00:00:00	6	2	6	\N	2	\N	\N	\N	144
77	Marcio Aurelio Storer	\N	\N	\N	\N	\N	\N	\N	\N	50318093		marcio@storerfaria.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	93
78	Karine Moriya	\N	\N	\N	\N	\N	\N	\N	\N			karine@jgmoriya.com.br		2015-03-26 00:00:00	5	2	5	\N	2	\N	\N	\N	95
79	Dr. Afrânio	\N	\N	\N	\N	\N	\N	\N	\N	3121053003	03184045866	afranio@transformarh.com		2015-05-21 00:00:00	5	2	5	\N	2	\N	\N	\N	164
80	Dr. Afranio	\N	\N	\N	\N	\N	\N	\N	\N	03121053003	03184045866	afranio@transformarh.com		2016-03-23 00:00:00	5	2	5	\N	2	\N	\N	\N	165
81	Dr. Afranio	\N	\N	\N	\N	\N	\N	\N	\N	03121053003	03184045866	afranio@transformarh.com		2015-05-21 00:00:00	5	2	5	\N	2	\N	\N	\N	166
82	Dr. Alisson	\N	\N	\N	\N	\N	\N	\N	\N			alissonrc@hotmail.com		2015-05-21 00:00:00	4	2	4	\N	2	\N	\N	\N	167
83	Maria Silvia Hermeto Pedrosa	\N	\N	\N	\N	\N	\N	\N	\N		982821011	mariasilvia@nrh.com.br		2015-05-25 00:00:00	4	5	4	\N	2	\N	\N	\N	170
84	Henrique Cesar Gouveia Pereira'	\N	\N	\N	\N	\N	\N	\N	\N	35653601	995796320	henrique@rededaconstrucaocivil.com.br		2015-05-26 00:00:00	4	2	4	\N	2	\N	\N	\N	172
85	Miguel	\N	\N	\N	\N	\N	\N	\N	\N		992829090	miguelamoura55@gmail.com		2015-06-05 00:00:00	5	5	5	\N	2	\N	\N	\N	174
87	Dra. Alice	\N	\N	\N	\N	\N	\N	\N	\N		11957700104	alicepaixaolisboa@yahoo.com		2015-06-09 00:00:00	5	2	5	\N	2	\N	\N	\N	177
88	Josiane Cristina Henrique	\N	\N	\N	\N	\N	\N	\N	\N		994334343	josiane.henrique@gmail.com		2015-06-17 00:00:00	6	\N	6	\N	2	\N	\N	\N	180
89	Rafael Pauperio	\N	\N	\N	\N	\N	\N	\N	\N	1124959985	11965764952	rafael@move.art.br		2015-09-30 00:00:00	5	5	5	\N	2	\N	\N	\N	181
90	Rafael Pauperio	\N	\N	\N	\N	\N	\N	\N	\N	1124959985	11965764952	rafael@move.art.br		2015-06-17 00:00:00	5	5	5	\N	2	\N	\N	\N	182
91	Clovis Lucio da Silva	\N	\N	\N	\N	\N	\N	\N	\N	976310909	963984543	chemical_trends@hotmail.com		2015-06-18 00:00:00	6	5	6	\N	2	\N	\N	\N	184
92	Emerson Colin	\N	\N	\N	\N	\N	\N	\N	\N	1131712466		emerson.colin@veraxc.com		2015-06-26 00:00:00	5	5	5	\N	2	\N	\N	\N	189
94	Dr. Marcelo Erich Reicher	\N	\N	\N	\N	\N	\N	\N	\N	22832654	953838864	eduardo@hqiconsultoria.com.br		2015-06-30 00:00:00	5	2	5	\N	2	\N	\N	\N	191
95	Sr. Moriya (J.G. MORIYA - 2222)	\N	\N	\N	\N	\N	\N	\N	\N					2015-07-21 00:00:00	5	2	5	\N	2	\N	\N	\N	203
96	Rede Protege - Quality - Sr. Pedro Lacerda	\N	\N	\N	\N	\N	\N	\N	\N	31014950	03184969836	lacerda@redeprotege.com		2015-07-14 00:00:00	5	5	5	\N	2	\N	\N	\N	197
97	Rede Protege - Quality - Sr. Pedro Lacerda	\N	\N	\N	\N	\N	\N	\N	\N	31014950	03184969836	lacerda@redeprotege.com		2015-07-14 00:00:00	5	5	5	\N	2	\N	\N	\N	198
98	Bianca Oliveira Miranda	\N	\N	\N	\N	\N	\N	\N	\N	31295589		salesalvia@live.com		2015-07-14 00:00:00	6	5	6	\N	2	\N	\N	\N	199
99	Odirley Silva	\N	\N	\N	\N	\N	\N	\N	\N		961731261	odirleyfs@hotmail.com		2015-09-30 00:00:00	6	5	6	\N	2	\N	\N	\N	202
100	Marcelo Noronha	\N	\N	\N	\N	\N	\N	\N	\N					2015-07-27 00:00:00	6	2	6	\N	2	\N	\N	\N	206
101	Tarsila	\N	\N	\N	\N	\N	\N	\N	\N	40638780		aiveo.tarsila@gmail.com		2015-08-11 00:00:00	6	5	6	\N	2	\N	\N	\N	209
102	Karime/ Lourdes	\N	\N	\N	\N	\N	\N	\N	\N		999663477	lurdessanchesl.2755@gmail.com		2015-08-19 00:00:00	6	5	6	\N	2	\N	\N	\N	215
103	CHRISTOPHER SILVEIRA	\N	\N	\N	\N	\N	\N	\N	\N	1135544997	11952857515	chrys_silveira@hotmail.com		2015-08-31 00:00:00	5	5	5	\N	2	\N	\N	\N	221
104	Gustavo	\N	\N	\N	\N	\N	\N	\N	\N	31813333		gcarvalho@sambainvestimentos.com.br		2015-09-30 00:00:00	6	4	6	\N	2	\N	\N	\N	223
105	Christopher e Virginia	\N	\N	\N	\N	\N	\N	\N	\N	11963408467		vir.martins@hotmail.com		2015-09-28 00:00:00	6	2	6	\N	2	\N	\N	\N	225
106	Rodrigo Cestari	\N	\N	\N	\N	\N	\N	\N	\N	950842898		rcestari@leroymerlin.com.br		2015-10-07 00:00:00	2	2	2	\N	2	\N	\N	\N	231
107	Tatiana	\N	\N	\N	\N	\N	\N	\N	\N		991463596	tatiana.meirinhos@yahoo.com.br		2015-10-07 00:00:00	3	5	3	\N	2	\N	\N	\N	232
108	Michelle Letran dos Santos	\N	\N	\N	\N	\N	\N	\N	\N		11994664388	michelleletran.s@gmail.com		2015-11-04 00:00:00	2	2	2	\N	2	\N	\N	\N	245
109	Renato Szyflinger (Sinalizadora Paulista)	\N	\N	\N	\N	\N	\N	\N	\N	1122587000	11986730333	renato@sinalizadorapaulista.com.br		2015-11-10 00:00:00	5	5	5	\N	2	\N	\N	\N	247
110	Maria Helena  Dos Santos	\N	\N	\N	\N	\N	\N	\N	\N	30656464/6462		finan@madiamm.com.br		2015-11-12 00:00:00	2	7	2	\N	2	\N	\N	\N	249
111	Maria Helena dos Santos	\N	\N	\N	\N	\N	\N	\N	\N	30656464/6462		finan@madiamm.com.br		2015-11-12 00:00:00	2	7	2	\N	2	\N	\N	\N	250
112	Fábio - AOJESP	\N	\N	\N	\N	\N	\N	\N	\N	35857823		financeiro@aojesp.org.br		2015-11-25 00:00:00	2	5	2	\N	2	\N	\N	\N	252
113	Carlos Eduardo Joos	\N	\N	\N	\N	\N	\N	\N	\N		11994242244	carlosjoos@gmail.com		2015-11-30 00:00:00	3	2	3	\N	2	\N	\N	\N	257
114	Luiz Carlos Perandi	\N	\N	\N	\N	\N	\N	\N	\N		11976397157			2015-12-07 00:00:00	3	5	3	\N	2	\N	\N	\N	261
115	Marcelo Gonçalves Araujo	\N	\N	\N	\N	\N	\N	\N	\N		11999989301	maraujo1203@terra.com.br		2015-12-22 00:00:00	5	2	5	\N	2	\N	\N	\N	266
116	Fernando Lauria (Sequenza Tecnologia	\N	\N	\N	\N	\N	\N	\N	\N	35675050	992706627	fernando.lauria@sequenza.com.br		2015-12-23 00:00:00	5	2	5	\N	2	\N	\N	\N	267
117	Roberto Carlos do Nascimento	\N	\N	\N	\N	\N	\N	\N	\N		999357792			2015-12-30 00:00:00	2	5	2	\N	2	\N	\N	\N	271
118	Paulo Miorini	\N	\N	\N	\N	\N	\N	\N	\N		992817373	paulo@4fun.art.br		2016-01-28 00:00:00	3	5	3	\N	2	\N	\N	\N	282
119	Ferdinando (Fergus)	\N	\N	\N	\N	\N	\N	\N	\N					2016-02-02 00:00:00	4	2	4	\N	2	\N	\N	\N	284
120	Thiago Toth	\N	\N	\N	\N	\N	\N	\N	\N		11994241944	thiago.thot@gmail.com		2016-06-07 00:00:00	3	5	3	\N	2	\N	\N	\N	291
121	Marco Aurrelio Damiani (Broker Serviços)	\N	\N	\N	\N	\N	\N	\N	\N		11996485710	aurelio.damiani@brokeronline.com.br		2016-03-28 00:00:00	5	2	5	\N	2	\N	\N	\N	292
122	Erik	\N	\N	\N	\N	\N	\N	\N	\N	38257379		adm@tecnogate.com.br		2016-03-28 00:00:00	3	5	3	\N	2	\N	\N	\N	295
123	Simone	\N	\N	\N	\N	\N	\N	\N	\N	38257379		adm@tecnogate.com.br		2016-02-17 00:00:00	3	5	3	\N	2	\N	\N	\N	296
124	Aguinaldo Cavalcante - Delta Software	\N	\N	\N	\N	\N	\N	\N	\N	55755737		agn@seacam.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	300
125	Aguinaldo Cavalcante - Seacam	\N	\N	\N	\N	\N	\N	\N	\N	55755737		agn@seacam.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	301
126	Aguinaldo Cavalcante -  Seametrologia	\N	\N	\N	\N	\N	\N	\N	\N	55755737		agn@seacam.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	302
127	Edilson Fernandes	\N	\N	\N	\N	\N	\N	\N	\N	35016495	981923972	grupobrasil3@yahoo.com.br		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	339
128	Rafael Navarro	\N	\N	\N	\N	\N	\N	\N	\N	29643246	97412538	manutecmemanutencao@hotmail.com		2016-11-09 00:00:00	2	3	2	\N	2	\N	\N	\N	340
129	Vinicius Risso Baradel	\N	\N	\N	\N	\N	\N	\N	\N		947362006	vinicius_r_baradel@outlook.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	319
130	Marcos Brandão	\N	\N	\N	\N	\N	\N	\N	\N	35896543	996437474	megaimpressaodigital@hotmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	325
131	Aloisio Junqueira	\N	\N	\N	\N	\N	\N	\N	\N		999360493	npp@sciesp.org.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	326
132	Izandro Pereira	\N	\N	\N	\N	\N	\N	\N	\N	23665521	992160718	izandro@ns4b.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	328
133	Luiz Felipe Grell	\N	\N	\N	\N	\N	\N	\N	\N		971881505	lazgrell@hotmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	330
134	Leandro Conde	\N	\N	\N	\N	\N	\N	\N	\N		941188573	leandro.farvoli@hotmail.com		2016-02-26 00:00:00	3	3	3	\N	2	\N	\N	\N	331
135	Gerson Gomez	\N	\N	\N	\N	\N	\N	\N	\N	20635540	20635564	gerson.gomez@aaabrasil.com.br		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	341
136	Rita Martins Muniz	\N	\N	\N	\N	\N	\N	\N	\N		997199033	rmuniz@leedscorretora.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	332
137	Alexandra	\N	\N	\N	\N	\N	\N	\N	\N		991676749	brilhopark@yahoo.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	333
138	Ademar Lopes	\N	\N	\N	\N	\N	\N	\N	\N		997065378	ademar@mazag.com.br		2016-02-26 00:00:00	3	3	3	\N	2	\N	\N	\N	335
139	Marcio Tavares	\N	\N	\N	\N	\N	\N	\N	\N		994918332	marcio.tppo@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	336
140	Alice Alves	\N	\N	\N	\N	\N	\N	\N	\N		996550229	contato@figurinoshop.com.br		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	342
141	Alice Alves	\N	\N	\N	\N	\N	\N	\N	\N		996550229	contato@figurinoshop.com.br		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	343
142	Elvira Maria Chagas de Carvalho	\N	\N	\N	\N	\N	\N	\N	\N		988989410	elvira.chagas@terra.com.br		2016-11-23 00:00:00	2	3	2	\N	2	\N	\N	\N	344
143	Geórgia Reis	\N	\N	\N	\N	\N	\N	\N	\N	39237740	983190149	arteirar@gmail.com		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	345
144	João Gilberto da Silva	\N	\N	\N	\N	\N	\N	\N	\N	37437156	959819253	diretoria@gprotic.com		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	346
145	Katherine Pavloski	\N	\N	\N	\N	\N	\N	\N	\N		967314681	contato@manamanutencao.com.br		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	347
146	Dirceu Masson	\N	\N	\N	\N	\N	\N	\N	\N		999715122	dirceumasson@quarter.inf.br		2016-02-29 00:00:00	2	3	2	\N	2	\N	\N	\N	348
147	Gilbeti Lobo de Almeida	\N	\N	\N	\N	\N	\N	\N	\N		16997614516	gilbeti-lobo@hotmail.com		2016-03-01 00:00:00	2	3	2	\N	2	\N	\N	\N	353
148	Willian José Dias	\N	\N	\N	\N	\N	\N	\N	\N	50967051		financeiro@w3video.com.br		2016-03-01 00:00:00	2	3	2	\N	2	\N	\N	\N	356
150	Fábio Francolino de Oliveira	\N	\N	\N	\N	\N	\N	\N	\N			comercialfrancolino@hotmail.com		2016-03-01 00:00:00	2	3	2	\N	2	\N	\N	\N	358
151	Edson da Silva	\N	\N	\N	\N	\N	\N	\N	\N		992565167	tigercorretora@terra.com.br		2016-03-01 00:00:00	2	3	2	\N	2	\N	\N	\N	359
152	Osvaldo Tadashi Higa	\N	\N	\N	\N	\N	\N	\N	\N		976634551	osvaldo@gerente-telecom.com.br		2016-11-24 00:00:00	5	3	5	\N	2	\N	\N	\N	360
153	Marcel Tanaka	\N	\N	\N	\N	\N	\N	\N	\N		11998427014	tanaka.m@gmail.com		2016-03-02 00:00:00	3	5	3	\N	2	\N	\N	\N	361
154	Ricardo Fiacador	\N	\N	\N	\N	\N	\N	\N	\N		952091898	contato@arretadofood.com.br		2016-03-11 00:00:00	3	3	3	\N	2	\N	\N	\N	375
155	Fernanda Dourado	\N	\N	\N	\N	\N	\N	\N	\N					2016-03-11 00:00:00	5	5	5	\N	2	\N	\N	\N	377
156	Fernanda Dourado	\N	\N	\N	\N	\N	\N	\N	\N					2016-03-11 00:00:00	5	5	5	\N	2	\N	\N	\N	378
157	Dr. Afranio	\N	\N	\N	\N	\N	\N	\N	\N					2016-03-11 00:00:00	2	5	2	\N	2	\N	\N	\N	379
158	Érica e Marina	\N	\N	\N	\N	\N	\N	\N	\N	949992393	975414143	comunica.asdpesp@gmail.com		2016-04-01 00:00:00	3	5	3	\N	2	\N	\N	\N	392
159	Rodrigo César	\N	\N	\N	\N	\N	\N	\N	\N		11966557374	rcesar81@yahoo.com.br		2016-08-17 00:00:00	2	5	2	\N	2	\N	\N	\N	383
160	Pedro Barutti	\N	\N	\N	\N	\N	\N	\N	\N		95478467	barutti.it@gmail.com		2016-03-17 00:00:00	3	5	3	\N	2	\N	\N	\N	384
161	André Morillo	\N	\N	\N	\N	\N	\N	\N	\N	40175599	40175231	andre.morillo@iita.com.br		2016-03-21 00:00:00	2	3	2	\N	2	\N	\N	\N	386
162	Thatiana Babar	\N	\N	\N	\N	\N	\N	\N	\N	27699642	999676477	tathibarbar@hotmail.com		2016-03-31 00:00:00	3	5	3	\N	2	\N	\N	\N	389
163	Sr. Julio Trabuco (IP-Experience)	\N	\N	\N	\N	\N	\N	\N	\N	40639275	992718631	jrtrabuco@ip-experience.com.br		2016-03-31 00:00:00	5	3	5	\N	2	\N	\N	\N	390
164	Danilo Carvalho	\N	\N	\N	\N	\N	\N	\N	\N			contato@carvalhoprint.com.br		2016-04-11 00:00:00	3	2	3	\N	2	\N	\N	\N	396
165	João Carvalho	\N	\N	\N	\N	\N	\N	\N	\N		952571959	jobcarv@ativoenergia.com		2016-06-03 00:00:00	2	5	2	\N	2	\N	\N	\N	402
166	ROGÉRIO SHIGUEMATSU MOTITSUKI	\N	\N	\N	\N	\N	\N	\N	\N		989740976	qtroger@gmail.com		2016-04-20 00:00:00	3	7	3	\N	2	\N	\N	\N	403
167	Flávio Soares	\N	\N	\N	\N	\N	\N	\N	\N		953329552	filippini.ff@gmail.com		2016-05-05 00:00:00	2	7	2	\N	2	\N	\N	\N	407
168	Marcelo Eira	\N	\N	\N	\N	\N	\N	\N	\N	35648900		marcelo.eira@expansao.com.br		2016-05-17 00:00:00	3	7	3	\N	2	\N	\N	\N	412
169	Suzana Moraes	\N	\N	\N	\N	\N	\N	\N	\N	36080691		condominionovohorizonteterra@gmail.com		2016-06-07 00:00:00	2	5	2	\N	2	\N	\N	\N	415
170	Kelen Flores - Kid Imports	\N	\N	\N	\N	\N	\N	\N	\N		976857912	kpflores1@gmail.com		2016-06-01 00:00:00	6	2	6	\N	2	\N	\N	\N	417
171	Mauro Mancio	\N	\N	\N	\N	\N	\N	\N	\N	1134816129		m.mancio@gmail.com		2016-09-16 00:00:00	2	5	2	\N	2	\N	\N	\N	419
172	Fernanda Santana	\N	\N	\N	\N	\N	\N	\N	\N	35648900		administrativo@expansao.com.br		2016-08-25 00:00:00	3	2	3	\N	2	\N	\N	\N	421
173	Magda (STERN)	\N	\N	\N	\N	\N	\N	\N	\N	30788822		magda@stern.com.br		2016-08-25 00:00:00	3	5	3	\N	2	\N	\N	\N	423
174	Magda (ADAMOS)	\N	\N	\N	\N	\N	\N	\N	\N	30788822		magda@stern.com.br		2016-06-14 00:00:00	3	5	3	\N	2	\N	\N	\N	424
175	Yuri	\N	\N	\N	\N	\N	\N	\N	\N		1131515887	apolonioyuri@gmail.com		2016-09-16 00:00:00	2	5	2	\N	2	\N	\N	\N	429
176	Sergio Yamaoka	\N	\N	\N	\N	\N	\N	\N	\N		11996215428	sergioyamaoka@lavservice.com.br		2016-06-23 00:00:00	3	7	3	\N	2	\N	\N	\N	430
177	Roberto	\N	\N	\N	\N	\N	\N	\N	\N		11995942529	roberto_rodrigues18@hotmail.com		2016-12-08 00:00:00	2	7	2	\N	2	\N	\N	\N	501
178	LUCIANA DEOLINDA - SOCIEDADE INDIVIDUAL DE ADVOCACIA	\N	\N	\N	\N	\N	\N	\N	\N			luciana.sul@gmail.com		2016-06-27 00:00:00	2	7	2	\N	2	\N	\N	\N	432
184	CIS - São Paulo	\N	\N	\N	\N	\N	\N	\N	\N			luizt@cis.com.br		2016-07-05 00:00:00	2	2	2	\N	2	\N	\N	\N	440
185	Dr. Bruno	\N	\N	\N	\N	\N	\N	\N	\N			baarossini@gmail.com		2016-07-20 00:00:00	2	5	2	\N	2	\N	\N	\N	444
186	Dra. Renata Souza	\N	\N	\N	\N	\N	\N	\N	\N			souzacuri@yahoo.com.br		2016-07-20 00:00:00	2	5	2	\N	2	\N	\N	\N	445
187	Célio Levorim	\N	\N	\N	\N	\N	\N	\N	\N	1132540211		celiolevorin@gmail.com		2016-09-16 00:00:00	2	2	2	\N	2	\N	\N	\N	446
189	Edgar Junior	\N	\N	\N	\N	\N	\N	\N	\N		976998700	edgar.net.9@gmail.com		2016-07-28 00:00:00	5	5	5	\N	2	\N	\N	\N	449
190	Maria Luiza	\N	\N	\N	\N	\N	\N	\N	\N			dramarialuiza@uol.com.br		2016-09-16 00:00:00	3	2	3	\N	2	\N	\N	\N	458
191	Fabiana Flores	\N	\N	\N	\N	\N	\N	\N	\N		11991055494	ascretas@osite.com.br;fabianaflores@hotm		2016-08-25 00:00:00	2	2	2	\N	2	\N	\N	\N	457
192	Cristina Bonadio	\N	\N	\N	\N	\N	\N	\N	\N	11996797259		contato@crismel.com.br		2016-10-05 00:00:00	5	\N	5	\N	2	\N	\N	\N	466
193	Flaina	\N	\N	\N	\N	\N	\N	\N	\N	1131043965		flaina@fabiogouvea.adv.br		2016-10-20 00:00:00	4	7	4	\N	2	\N	\N	\N	470
194	Lilian Baldi Tavares	\N	\N	\N	\N	\N	\N	\N	\N	994636838	99463683	limed_balta@yahoo.com.br		2016-10-21 00:00:00	2	9	2	\N	2	\N	\N	\N	472
72	Marcos	\N	\N	\N	\N	\N	\N	\N	\N	22979303		ambrosio@geomidi.com.br		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	87
1	Eduardo Motti	\N	\N	\N	\N	\N	\N	\N	\N		981031010	edumotti@gmail.com		2015-05-21 00:00:00	6	2	6	\N	2	\N	\N	\N	10
2	Victor	\N	\N	\N	\N	\N	\N	\N	\N		974772217	victor.canteruccio@tggviagens.com.br		2015-07-02 00:00:00	6	2	6	\N	2	\N	\N	\N	133
3	Verucio	\N	\N	\N	\N	\N	\N	\N	\N		983695080	verucio@gmail.com		2015-07-02 00:00:00	6	5	6	\N	2	\N	\N	\N	134
4	Evanildes Vieira (VICTUS)	\N	\N	\N	\N	\N	\N	\N	\N	55052424	997873534	evanildes.vieira@victus.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	12
5	Milton Roberto	\N	\N	\N	\N	\N	\N	\N	\N	23055991	963206761	advocaciatamborelli@hotmail.com		2015-03-27 00:00:00	6	4	6	\N	2	\N	\N	\N	13
195	Maria José	\N	\N	\N	\N	\N	\N	\N	\N	996592631		mariajliberato@hotmail.com		2016-10-24 00:00:00	2	2	2	\N	2	\N	\N	\N	474
198	Sandra	\N	\N	\N	\N	\N	\N	\N	\N	995374170		sjanostiac@hotmail.com		2016-11-03 00:00:00	2	3	2	\N	2	\N	\N	\N	487
181	Bruno - VFUNG	\N	\N	\N	\N	\N	\N	\N	\N		993909920	brunosantimv@gmail.com		2016-08-25 00:00:00	4	2	4	\N	2	\N	\N	\N	528
188	Wesley Kevin	\N	\N	\N	\N	\N	\N	\N	\N	25111332	989337440	wesley.kevin@outlook.com		2016-09-29 00:00:00	2	5	2	\N	2	\N	\N	\N	448
182	Willian José Dias	              	Avenida					        	\N	50417640		financeiro@w3video.com.br		2016-11-09 00:00:00	2	19	2	\N	2	\N			437
180	Willian José Dias	              	Avenida					        	\N	50417640		financeiro@w3video.com.br		2016-11-09 00:00:00	2	19	2	\N	2	\N			436
179	Willian José Dias	              	Avenida					        	\N	50417640		financeiro@w3video.com.br		2016-11-09 00:00:00	2	19	2	\N	2	\N			435
202	Rosehelp Servs e Reparos	0734666200016	Rua					        	\N	3159-2130	98681-9118	sosflavia@gmail.com		2017-02-09 17:43:14.446	2	5	5	4	2	\N		Rosehelp Servs e Reparos de Eletrodomésticos	524
204	Dra. Josiane	             	Rua					        	\N		11981757608	jm.negrao@uol.com.br,obasitala42@gmail.com		2017-03-15 16:25:41.592	4	9	4	4	2	3			544
206	Auto Posto Nacional de Santos	             	Rua					        	\N	11 930140044		nacionaldesantos50@outlook.com		2017-03-16 12:25:40.18	3	5	3	\N	2	\N			\N
205	Ediones	             	Rua					        	3831		968667131 			2017-03-16 11:33:40.911	4	11	4	\N	2	7			\N
207	Andrea Tonus 	             	Rua					        	\N	11 3116-0000		andrea@emartinsfontes.com.br		2017-03-28 12:00:00.75	4	5	4	4	2	6		Editora Martins Fontes	549
208	Andrea Tonus	             	Rua					        	\N	11 3116-0000		andrea@emartinsfontes.com.br		2017-03-28 12:03:49.056	4	5	4	4	2	5		Positive Music 	550
209	ADALTECH INFORMATICA	04312243000116	Rua					        	\N	4384-8724		michel@adaltech.com.br		2017-04-11 14:07:07.112	3	7	3	4	2	3			554
211	BROKER TECNOLOGIA	              	Rua					        	\N	11 3664-2040 		administrativo@sistemas-seguros.com.br		2017-04-18 08:28:41.157	3	2	3	4	2	\N		BROKER TECNOLOGIA	556
93	Raquel Nascimento	\N	\N	\N	\N	\N	\N	\N	\N		982084061	 raquelsn88@hotmail.com		2015-07-16 00:00:00	6	5	6	\N	2	\N	\N	\N	190
212	Paulo Tridente	              	Rua					        	\N			tridente.paulo@gmail.com		2017-05-23 11:44:01.011	3	2	3	4	2	3			569
214	Fechine Dermatologia	              	Rua					        	\N	94970-1434 		roneyfechine@gmail.com		2017-06-08 16:29:42.185	3	2	3	4	2	7			576
218	Sra. Nair	              	Rua					        	3831		99799-9036	ndmsimoes@icloud.com		2017-07-27 17:52:39.184	2	11	2	4	2	\N			596
219	Luís Matos	              	Rua					        	\N			lfsmatos@gmail.com		2017-08-03 11:06:48.403	2	15	4	4	2	\N			611
220	Felipe C. T. Guimarães	18546797000192	Rua					        	\N	11 3869-8868		felipe.guimaraes@rhhandson.com.br	http://rhhandson.com.br/	2017-08-07 16:51:14.113	2	4	2	4	2	\N		Hands On Recursos Humanos	599
221	Andressa - Colégio Aclimação	              	Rua				Aclimação	        	3831	3341-1329		financeiro@colegioaclimacao.com.br		2017-08-11 10:32:46.896	2	5	2	4	2	\N			\N
222	Cecilia - Swagelok	              	Rua					        	\N	5080-8895	99685-5367	financeiro@tecflux.com.br		2017-08-15 16:38:58.79	3	15	3	\N	2	\N		SWAGELOK	600
223	Kelly Coscia	              	Rua					        	3831		96173-3738	kelly.coscia@transformarh.com	www.transformarh.com	2017-08-22 10:39:36.509	2	2	5	4	7	3		BIPP PARTICIPACOES LTDA.	602
225	Ivan Pagnossin	07750162000196	Rua					        	\N		11 - 96434-4513	ivan.pagnossin@gmail.com		2017-09-26 17:55:05.89	3	2	3	4	2	1		CAGNOTTO E PAGNOSSIN LTDA.	612
227		              	Rua					        	3831	119 8225-6084	119 6171-3711	elizethmessias@transformarh.com		2017-10-18 11:06:46.788	4	2	4	\N	3	3		MATTEO MARCHIORI EIRELI	618
228	Elizeth	              	Rua					        	\N		119 6171-3711	elizethmessias@transformarh.com		2017-10-18 12:02:08.221	4	2	4	\N	3	\N		MATTEO MARCHIORI EIRELI	619
229	Lincoln - Blu Sport	              	Rua					        	3831	3104-0004		lojadase@gmail.com		2017-10-19 12:04:38.714	2	4	4	4	2	\N			\N
199	Paulo - Restaurante La Friulana	\N	\N	\N	\N	\N	\N	\N	\N	31011646		paulo.stl@superig.com.br		2016-11-16 00:00:00	2	7	2	\N	2	\N	\N	\N	492
200	Adriana	\N	\N	\N	\N	\N	\N	\N	\N	96334415		drikahc@hotmail.com		2016-11-21 00:00:00	3	7	3	\N	2	\N	\N	\N	495
201	Guimarães	\N	\N	\N	\N	\N	\N	\N	\N	25016049	13996510936	lwb.guimaraes@gmail.com		2016-11-22 00:00:00	2	3	2	\N	2	\N	\N	\N	497
203	OV - Felippe	             	Rua					        	\N	3197-6533	99271-6693	felippe@opinioes-verificadas.com.br		2017-02-13 15:44:00.525	2	5	2	3	2	\N			\N
231	FABIANA	23380107000108	Rua					        	\N	95898-4530		professorafabiana.fieb@bol.com.br		2017-11-13 09:32:58.337	3	2	3	4	2	4		FABIANA NUNES DE VIVEIROS FREITAS ME	623
224	Daniel Dourado 	28332863000185	Rua	HARMONIA	AP 132	756		        	\N		(11) 98962-1100 	dadourado@gmail.com		2017-09-15 14:40:11.946	3	2	3	\N	7	7		DOURADO, FERREIRA E LEMOS SOCIEDADE DE ADVOGADOS 	606
213	INSIDE	              	Rua					        	\N	5060-2107		financeiro@insideengenharia.com.br		2017-06-08 16:28:17.744	3	7	3	4	2	6		INSIDE COM. E SERV. CONSTRUÇÃO CIVIL LTDA.	575
215	Editora Nova Onda	21112122000140	Rua					        	\N	3251-4870	97203-9888	telmabsc@yahoo.com		2017-06-30 12:21:03.755	3	5	3	4	2	1		EDITORA NOVA ONDA EIRELI	586
216	Mafalda Botelho - TOMI WORLD	              	Rua	Rua Tabapuã	6º andar nº 165	594	Itaim Bibi	04533002	3831		11 97310-7912	mafalda.botelho@tomiworld.com	http://tomiworld.com/	2017-07-10 15:47:01.904	2	\N	5	4	2	\N		TOMI World Brasil, Tecnologias de Informação Ltda	587
197	Leandro	\N	\N	\N	\N	\N	\N	\N	\N	40855655	984690625	leandrocoral@hotmail.com		2016-11-01 00:00:00	2	3	2	\N	2	\N	\N	\N	486
230	VCL Ferramentas	05279704000169	Rua					        	3831	3228-3580	97103-6999	vclferramentas@terra.com.br	http://www.vclferramentas.com.br/	2017-11-07 17:43:40.681	2	11	2	4	2	5	Cleia	CLAUDIA LIMA OLIVARES - ME	622
226	Dr. Davi	              	Rua					        	\N	1137499221	11999791360	dstephan@uol.com.br		2017-10-17 11:18:57.824	4	15	4	4	2	1		Centro de Medicina e Saúde Global S/S Ltda	617
210	ADT MOBILE	10594675000160	Rua					        	\N	4384-8724		michel@adaltech.com.br		2017-04-11 14:10:33.998	3	7	3	4	2	3		ADT MOBILE	555
217	Gustavo Carvalho	              	Rua					        	\N			gcarvalho@runinvestimentos.com.br		2017-07-26 15:21:06.455	2	7	3	4	2	1		RUN INVESTIMENTOS	673
236	CATAVENTO CULTURAL E EDUCACIONAL	08698186000106	Rua					        	\N	(11) 3246-4065	(11) 95178-8874	tatiana.azevedo@cataventocultural.org.br		2017-12-14 14:41:41.795	3	5	3	4	6	\N		CATAVENTO CULTURAL E EDUCACIONAL	632
234	SÃO ROQUE KIDS MODA INFANTIL LTDA ME	28743832000117	Rua					        	\N	95898-4530		professorafabiana.fieb@bol.com.br		2017-11-13 09:35:59.676	3	2	3	4	2	4		SÃO ROQUE KIDS MODA INFANTIL LTDA ME	626
233	J M KIDS MODA INFANTIL LTDA ME	26037938000170	Rua					        	\N	95898-4530		professorafabiana.fieb@bol.com.br		2017-11-13 09:35:02.469	3	2	3	4	2	4		J M KIDS MODA INFANTIL LTDA ME	625
232	JANDIRA KIDS MODA INFANTIL LTDA ME	25067624000157	Rua					        	\N	95898-4530		professorafabiana.fieb@bol.com.br		2017-11-13 09:34:08.091	3	2	3	4	2	4		JANDIRA KIDS MODA INFANTIL LTDA ME	624
235	Ari - Danada Produções	              	Rua					        	\N	25748799	998867882	danadaproducoes@gmail.com		2017-11-13 10:42:53.96	4	5	4	\N	2	\N		THAIS CRISTINA MOREIRA VILELA	627
196	Marcos	\N	\N	\N	\N	\N	\N	\N	\N	11999882441	1199	marcosmaiap2012@gmail.com		2016-11-11 00:00:00	2	6	2	\N	2	\N	\N	\N	491
\.


--
-- Name: empresa_emp_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.empresa_emp_cod_seq', 271, true);


--
-- Data for Name: funcao; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.funcao (fun_cod, fun_nome) FROM stdin;
1	Analista
2	Assistente
3	Gerente
4	Auxiliar
\.


--
-- Name: funcao_fun_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.funcao_fun_cod_seq', 3, true);


--
-- Data for Name: lista; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.lista (lis_cod, lis_nome, lis_detalhes, lis_criadoem, lis_criadopor_cod) FROM stdin;
2	Prospecção		2017-06-26 15:17:31.339	2
1	Feira ABF 2017		2017-06-26 11:25:28.738	2
3	Fórum Empreendedoras 2017		2017-10-05 10:22:03.019	2
\.


--
-- Name: lista_lis_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.lista_lis_cod_seq', 3, true);


--
-- Data for Name: negocio; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.negocio (neg_cod, neg_nome, neg_datainicio, neg_datafim, neg_classe, neg_criadoem, neg_criadopor_cod, neg_sta_cod, neg_eta_cod, neg_atendente_cod, neg_andcontato, neg_andenvioproposta, neg_andfollowup, neg_andfechamento, neg_andindefinida, neg_empresa_cod, neg_pessoa_cod, neg_honorario, neg_origem_cod, neg_servico_cod, neg_categoria_cod, neg_nivel_cod, neg_descricao, neg_motivoperda, neg_detalhesperda, neg_dataperda, neg_datafinalizacao, neg_prospeccao_cod) FROM stdin;
511	Jorge Rocha Coutinho	2017-01-12	2017-01-30	Pessoa	2017-01-23 15:04:17.656	2	3	4	2	2017-01-23 15:04:17.662	2017-01-30 11:33:04.844	\N	2017-01-30 13:57:51.678	\N	\N	308	550.00	4	3	2	8	Prestação de serviços de preparação de documentos e de apoio administrativos para terceiros. Indicação Aristeu.		DECLINADO, Aristeu disse que Jorge fechou com outra contabilidade que não cobrou abertura de empresa e fez um preço menor.	2017-01-30	\N	\N
490	Fabio	2016-11-10	2017-03-10	Pessoa	2016-11-10 00:00:00	2	3	4	2	\N	\N	2017-01-31 11:43:35.376	2017-01-31 11:45:39.669	\N	\N	180	350.00	5	3	2	\N			Fabio já possui outra empresa e acabou fechando com o próprio contador.	2017-01-31	\N	\N
269	Airton Yokoyama	2015-12-30	2015-12-30	Pessoa	2015-12-30 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	153	238.00	\N	\N	2	\N				\N	\N	\N
212	Bruno	2015-09-03	2015-09-03	Pessoa	2015-09-03 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	113	506.00	3	\N	2	\N				\N	\N	\N
516	Marisa Joenck	2017-01-26	2017-02-02	Pessoa	2017-01-26 17:03:29.746	2	3	4	2	\N	2017-01-26 17:03:29.746	\N	2017-01-30 16:18:31.45	\N	\N	319	380.00	5	3	2	1	Personal Trainer de corrida.		Marisa afirma que terá um baixo faturamento. Vai tentar ser MEI.	2017-01-30	\N	\N
513	Dra. Anete	2017-01-16	2017-02-08	Pessoa	2017-01-23 15:28:56.598	2	2	4	2	2017-01-23 15:28:56.598	2017-02-01 11:08:13.106	\N	2017-02-01 16:48:09.097	\N	\N	314	350.00	5	6	2	\N	Escrituração de livro caixa.			\N	\N	\N
317	Marcelo Monteiro	2016-11-09	2016-11-09	Pessoa	2016-11-09 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	194	0.00	3	\N	2	\N	Ficha Nº 37.			\N	\N	\N
318	Priscila Ueno	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	195	0.00	3	\N	2	\N	Ficha Nº 65.			\N	\N	\N
319	Vinicius Risso Baradel	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	129	\N	0.00	3	\N	2	\N	Ficha Nº 47.			\N	\N	\N
16	Shirley Akemi	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	6	\N	1208.00	3	\N	2	\N	Escola de Ingles na Wizard Liberdade. Paga atualmente R$500,00 de contador. Fat 70k e 15 CLT. 120 NF-e mes e 2 conta bancária.			\N	\N	\N
17	David Pastro	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	13	421.73	5	\N	2	\N	Empresa de transporte. realiza-se sob fretamento contínuo em área metropolitana para o transporte de estudantes ou trabalhadores, será possível o enquadramento no regime tributário do SIMPLES NACIONAL com uma alíquota de imposto de 6% até o			\N	\N	\N
135	Edson da Silva Brasil	2015-05-08	2015-05-08	Empresa	2015-05-08 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	7	\N	5300.00	5	\N	2	\N				\N	\N	\N
19	Cassia e André	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	15	591.00	3	\N	2	\N	Contato feito na Feira do empreendedor 2015.			\N	\N	\N
20	Anderson e Paulo	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	16	788.00	3	\N	2	\N	Contato feria do empreendedor, terá 01 funcionário, Simples Nacional, OURO 01			\N	\N	\N
21	Professor Mark	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	17	315.00	3	\N	2	\N	Minitrar aula e ingles, SN 6%			\N	\N	\N
22	Claudio Antonio	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	18	429.00	3	\N	2	\N	PRATA 01			\N	\N	\N
23	Alex Eizu	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	19	315.00	3	\N	2	\N	Bronze			\N	\N	\N
24	Claudio	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	20	591.00	3	\N	2	\N	PRATA 3			\N	\N	\N
25	Maressa Andrioli	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	21	350.00	3	\N	2	\N	R$ 429,00 mesalidade, porem nos 6 primeiros meses cobraremos o valor de R$ 350,00.			\N	\N	\N
150	WILLIANS DA ROCHA	2015-04-28	2015-04-28	Pessoa	2015-04-28 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	22	464.92	2	\N	2	\N	Ja tem empresa ID 2136 - Porposta enviada pelo Telmon.			\N	\N	\N
26	Gabriel e Guilherme	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	23	350.00	3	\N	2	\N	Simples Nacional - proposta com mensalidade de Inativa			\N	\N	\N
27	Davi	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	24	315.00	3	\N	2	\N	Simples Nacional			\N	\N	\N
28	Thalita Marques	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	25	591.00	3	\N	2	\N	Valor: R$ 429,00 por mês, sem funcionários.\nValor: R$ 591,00 por mês, com até 03 funcionários.			\N	\N	\N
29	Rafael	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	26	590.00	3	\N	2	\N	Faturamento mensal 15.000,00			\N	\N	\N
30	Fernando Tadeu Santos Lima	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	27	350.00	3	\N	2	\N	Simples nacional 6%			\N	\N	\N
31	Janine	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	28	315.00	3	\N	2	\N	Tirou muitas duvidas sobre INSS			\N	\N	\N
55	Rainer	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	8	\N	543.00	3	\N	2	\N	Para a Prestação de Serviços Fiscais, Contábeis e de Folha de Pagamento, considerando as atividades descritas no item 1 (manutenção fiscal, contábil e de folha de pagamento) será cobrado um valor mensal equivalente a R$ 429,00 (Quatrocentos			\N	\N	\N
32	Gabriela	2015-03-27	2015-03-27	Pessoa	2015-03-27 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	29	850.00	7	\N	2	\N	SIMPLES NACIONAL 4%			\N	\N	\N
33	Manoel Belo da Silva Junior	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	9	\N	464.92	3	\N	2	\N	O cliente deseja alterar a empresa para o SIMPLES NACIONAL, atualmente a empresa é MEI, o valor cobrado de alteração foi R$ 750,00 de honorarios + R$ 125,00 de taxas, e posteriomente efetuar uma regularização.			\N	\N	\N
57	Jaqueline da Silva Reis	2015-05-19	2015-05-19	Pessoa	2015-05-19 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	30	429.00	3	\N	2	\N	Nos 6 primeiros meses cobraremos 429,00, posteriormente cobraremos 590,00			\N	\N	\N
34	Daniel e Jesus	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	31	788.00	3	\N	2	\N	Atividade de Lanchonete  - SP- 2 a 3 Empregados - SOCIEDADE - SN - EPP			\N	\N	\N
35	Regina Santos	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	10	\N	1500.00	3	\N	2	\N	Prestaçao de serviços zeladoria portaria e recepção - Tem renda de produtos  comercio e serviço- sem filial.			\N	\N	\N
58	Izac	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	32	788.00	3	\N	2	\N	Obs: O Isac é muito sistematico.			\N	\N	\N
518	Rodrigo Frederico	2017-01-31	\N	Pessoa	2017-01-31 16:28:39.638	2	3	4	2	2017-01-31 16:28:39.638	2017-02-06 09:16:30.777	\N	2017-02-08 11:39:53.16	\N	\N	327	450.00	5	3	2	1	CNAE 9001-9/99		Rodrigo disse que no mesmo dia conseguiu alguém para abrir a empresa.	2017-02-08	\N	\N
36	Rafael Padovani	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	11	\N	3500.00	3	\N	2	\N	Prestaçao de serviços de analise clinica - não informou o valor da mensalidade paga ao atual contador.			\N	\N	\N
108	Dra. Francini Mattos	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	48	\N	464.92	2	\N	2	\N	Indicação da empresa 2173			\N	\N	\N
515	Pedro Wilson	2017-01-26	2017-02-22	Pessoa	2017-01-26 17:00:35.625	2	3	1	4	2017-04-06 18:00:44.34	2017-01-26 17:00:35.641	2017-02-08 11:47:05.827	\N	\N	\N	320	380.00	5	4	2	1				2017-04-06	\N	\N
514	Tatiana Hannud Abdo	2017-01-18	2017-02-08	Pessoa	2017-01-23 15:34:48.779	2	3	1	4	2017-03-10 16:24:46.973	2017-02-01 11:08:21.902	\N	\N	\N	\N	318	430.00	5	3	2	7	Filha da Dra. Anete.\nPsicologia.			2017-03-10	\N	\N
481	João Manuel O. B. Antunes	2016-11-03	2017-02-09	Pessoa	2016-11-03 00:00:00	2	3	4	2	2017-03-29 17:41:36.828	\N	2017-02-02 11:49:57.308	2017-03-29 17:42:18.143	\N	\N	288	500.00	5	\N	2	\N			Não vai abrir empresa.	2017-03-29	\N	\N
37	Sidney	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	12	\N	850.00	3	\N	2	\N	Atividade de restaurante em Jundiaí - atualmente paga R$ 724,00 para o contador - EPP			\N	\N	\N
59	Elisete e Sandra	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	33	590.00	3	\N	2	\N	Proposta enviada, padrão mundo verde			\N	\N	\N
38	Roberta Wane de Lima Moreira	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	13	\N	850.00	3	\N	2	\N	S.L Honorario (seta para baixo) - atendimento realizado pela Silvia			\N	\N	\N
60	Pedro Ricardo	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	34	788.00	3	\N	2	\N	São em 4 socios, um ja tem empresa aberta.			\N	\N	\N
40	Otaide Cardoso	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	15	\N	464.00	3	\N	2	\N	Ligar e pedir para fazer pesquisa para saber se esta Ok - Atendido pela Silvia - paga atualmente para o contador R$ 484,00.			\N	\N	\N
61	Cristina	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	16	\N	591.00	3	\N	2	\N				\N	\N	\N
66	Walter Cardoso	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	17	\N	788.00	3	\N	2	\N	Tem a intenção de fazer a mudança para MEI. atualmente paga 275 para o contador			\N	\N	\N
62	Ariani Cabral Mol	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	18	\N	315.00	3	\N	2	\N				\N	\N	\N
41	Eron	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	19	\N	429.00	3	\N	2	\N	Empresa na area comercio - e-comerce - esta inativo - SN- Atendido pelo Telmon.			\N	\N	\N
63	Antonio Pedro	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	20	\N	429.00	3	\N	2	\N	Foi enviado o processo de alteração contratual, honorarios 750,00 + taxa 125,00.			\N	\N	\N
113	André	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	35	788.00	5	\N	2	\N				\N	\N	\N
43	Sydnei Leme	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	22	\N	2500.00	3	\N	2	\N	Atendido pelo Maikell.			\N	\N	\N
106	Dra. Claudia Martins Cosentino	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	23	\N	590.00	2	\N	2	\N	Indicação do Dr. Samuel Gallafrio  empresa 2006.			\N	\N	\N
64	Ari Pereira	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	24	\N	315.00	3	\N	2	\N				\N	\N	\N
44	Roseni Araujo	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	25	\N	590.00	3	\N	2	\N	Empresa MEI, confecção de roupas- faturamento 9.000,00 mensalidade cobrada R$ 590,00. Valor para alteração R$750,00 + taxa 125,00.			\N	\N	\N
65	José Espalaor	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	26	\N	1152.00	3	\N	2	\N				\N	\N	\N
67	José Salvino	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	27	\N	315.00	3	\N	2	\N	Transformar MEI para o SN alteração 750,00 + taxa 125,00.			\N	\N	\N
45	José Carlos	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	28	\N	350.00	3	\N	2	\N	Se a empresa estiver inativa será cobrado R$ 149,00 de mensalidade -  Pois possui uma empresa, nao emite nota fiscal, esta parada. Oficina mecanica na Vila Maria.			\N	\N	\N
68	Luiz Cesa	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	29	\N	788.00	3	\N	2	\N	Atualmente eles pagam 300,00 para o contador.			\N	\N	\N
96	Karine Moriya	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	30	\N	788.00	2	\N	2	\N	Grupo Moriya. K&K INSTALAÇÕES.			\N	\N	\N
97	Dra. Carolina	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	36	326.98	1	\N	2	\N	Não gera credito. Foi indicada pela diretoria da Bioqualynet.			\N	\N	\N
46	Luis LH	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	31	\N	1100.00	3	\N	2	\N	Atendido pelo Telmon			\N	\N	\N
69	Gustavo e Marisa	2015-11-18	2015-11-18	Pessoa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	37	543.00	3	\N	2	\N	Nos 6 primeiros meses pagará 429,00, depois será 543			\N	\N	\N
47	Luis Vanrooy	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	32	\N	464.00	3	\N	2	\N	Gostaria de tercerizar a parte administrativa de emissão de NF			\N	\N	\N
56	Vanessa	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	38	429.00	3	\N	2	\N	Nos 6 primeiros meses pagara 350,00 e a partir do 7 mes pagara 429.			\N	\N	\N
48	Lion	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	33	\N	591.00	3	\N	2	\N	Se a empresa estiver inativa o valor da mensalidade séra de R$ 149,00.			\N	\N	\N
70	Daniela	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	39	315.00	3	\N	2	\N				\N	\N	\N
98	Sra. Priscila	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	34	\N	788.00	2	\N	2	\N	Indicação do Victor  da empresa VFUNG. Gera credito no fechamento da Proposta. Proposta enviada em reunião presencial.			\N	\N	\N
71	Alexandre	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	40	429.00	3	\N	2	\N				\N	\N	\N
49	Laercio Seraphim	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	35	\N	788.00	3	\N	2	\N	Projeto RH			\N	\N	\N
91	RODRIGO DOMINGOS FERREIRA	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	41	464.92	2	\N	2	\N	Proposta n° 91 - Não gerar credito ao cliente.			\N	\N	\N
72	Marcos	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	36	\N	429.00	3	\N	2	\N				\N	\N	\N
73	Vera	2015-02-24	2015-02-24	Empresa	2015-02-24 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	37	\N	429.00	\N	\N	2	\N				\N	\N	\N
50	Cicero Costa	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	38	\N	590.00	3	\N	2	\N	Atendido pelo Telmon.			\N	\N	\N
99	João e Gabriel	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	39	\N	850.00	3	\N	2	\N				\N	\N	\N
100	Renata	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	42	788.00	2	\N	2	\N	Empresa EIRELI - empra 2195			\N	\N	\N
101	IGOR	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	40	\N	429.00	5	\N	2	\N				\N	\N	\N
74	Reinaldo	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	41	\N	315.00	3	\N	2	\N				\N	\N	\N
51	Helder Oliveira	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	42	\N	788.00	3	\N	2	\N	Paga R$ 170 para o atual contador, isso mesmo, que absurdo			\N	\N	\N
103	Alessandra	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	43	464.00	5	\N	2	\N				\N	\N	\N
102	Elenilson	2015-03-27	2015-03-27	Pessoa	2015-03-27 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	44	590.00	7	\N	2	\N	Proposta enviada. N°102			\N	\N	\N
75	Luiz de Nascimento	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	43	\N	1200.00	3	\N	2	\N				\N	\N	\N
52	Michele Oliveira	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	44	\N	591.00	3	\N	2	\N				\N	\N	\N
104	Fernando	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	45	464.92	8	\N	2	\N				\N	\N	\N
105	Andres Alvarez	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	45	\N	429.00	2	\N	2	\N	Indicação da Talent. PJ com faturamento de R$9.000,00 mês e sem funcionários. Empresa será em Guarulhos ou São Paulo.			\N	\N	\N
76	Cesar Augusto Avila ME	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	46	\N	1576.00	3	\N	2	\N				\N	\N	\N
53	Hernandes	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	47	\N	1576.00	3	\N	2	\N	Ouro 3			\N	\N	\N
107	Dra. Lucia	2015-06-30	2015-06-30	Pessoa	2015-06-30 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	46	326.98	9	\N	2	\N	Proposta enviada.			\N	\N	\N
147	LAERTO PAULINO DE CARVALHO	2015-07-02	2015-07-02	Pessoa	2015-07-02 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	74	2500.00	5	\N	2	\N				\N	\N	\N
54	Demetrius	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	50	\N	429.00	3	\N	2	\N	Empresa MEI, o cliente deseja alterar para o Simples Nacional, custos cobrados R$ 750,00 + taxa 125,00 de alteração e implantação R$ 429,00. para empresa Inativa R$ 149,00.			\N	\N	\N
152	Alecsandra	2015-04-30	2015-04-30	Pessoa	2015-04-30 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	47	464.92	2	\N	2	\N	Posposta enviada pela Monary			\N	\N	\N
92	Priscila Bertoni	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	48	350.00	2	\N	2	\N				\N	\N	\N
78	Anderson Pereira	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	51	\N	788.00	3	\N	2	\N				\N	\N	\N
109	Wagner	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	49	590.00	5	\N	2	\N	SN			\N	\N	\N
110	Dra. Daniele	2015-04-08	2015-04-08	Pessoa	2015-04-08 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	50	429.00	2	\N	2	\N	gerar credito por indicação- 2276			\N	\N	\N
111	André	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	52	\N	464.92	9	\N	2	\N				\N	\N	\N
79	Rosangela	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	53	\N	315.00	3	\N	2	\N				\N	\N	\N
112	Giano Artur Agostini	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	51	329.00	2	\N	2	\N				\N	\N	\N
115	Dr. Sérgio	2015-06-30	2015-06-30	Pessoa	2015-06-30 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	52	326.98	9	\N	2	\N				\N	\N	\N
114	Dra. Lilian	2015-09-30	2015-09-30	Empresa	2015-09-30 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	54	\N	326.98	9	\N	2	\N	Prosposta enviada.			\N	\N	\N
80	Rodrigo Galati	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	55	\N	788.00	3	\N	2	\N				\N	\N	\N
81	Fabricio Miranda	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	56	\N	520.00	3	\N	2	\N				\N	\N	\N
116	Karine	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	57	\N	3152.00	2	\N	2	\N	Indicação da Sra. Priscila da Makis - gera credito -			\N	\N	\N
117	Bruno de Azevedo Teixeira	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	58	\N	350.00	3	\N	2	\N	Orçamento para implantação e alteraçao contratual da empresa.			\N	\N	\N
121	Luis	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	53	464.92	2	\N	2	\N	Ele disse que  varias pessoas indicou.  Propostaa enviada			\N	\N	\N
82	Carolina Rocha	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	59	\N	590.00	5	\N	2	\N				\N	\N	\N
118	Rodolpho Sierra	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	54	465.00	2	\N	2	\N	Indicação da Netstor - Não gera Credito. Empresa no mesmo Perfil do Tucci. Prata 1.			\N	\N	\N
77	Raphael	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	49	\N	315.00	3	\N	2	\N				\N	\N	\N
119	Glaucia Maria Maciel	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	60	\N	724.00	2	\N	2	\N	Indicação da Priscila da Makis. Gera credito.			\N	\N	\N
122	GLEI DE FATIMA BONFIM	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	55	590.00	3	\N	2	\N				\N	\N	\N
83	Carolina Rocha - IBS	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	61	\N	788.00	5	\N	2	\N				\N	\N	\N
120	Glaucia Maria Maciel	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	62	\N	724.00	2	\N	2	\N	Indicação da Priscila da MAKIS (NÃO GERA CREDIDO).			\N	\N	\N
123	Shirley	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	56	215.00	2	\N	2	\N	EX CLIENTE			\N	\N	\N
84	Carolina Rocha Praxian	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	63	\N	724.00	5	\N	2	\N				\N	\N	\N
124	Sr. Christiano (Lyncra)	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	64	\N	9820.00	5	\N	2	\N	Empresa Platina. Contato da Internet.			\N	\N	\N
125	Dra. Thais	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	57	326.98	9	\N	2	\N				\N	\N	\N
126	Bruna	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	65	\N	1180.00	5	\N	2	\N				\N	\N	\N
85	Tassia Santana	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	66	\N	429.00	3	\N	2	\N	Nos 6 primeiros meses 350,00 posteriormente 429.			\N	\N	\N
127	Dra. Camila	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	58	421.73	2	\N	2	\N	2276.			\N	\N	\N
129	Simone	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	59	469.00	5	\N	2	\N				\N	\N	\N
128	Afonso	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	60	788.00	5	\N	2	\N				\N	\N	\N
86	Eduardo Marcel	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	67	\N	429.00	3	\N	2	\N	Tem uma empresa mas nunca movimentou.			\N	\N	\N
156	Dr. Rene	2015-05-06	2015-05-06	Empresa	2015-05-06 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	68	\N	464.00	5	\N	2	\N	Mensalidade de empresa ativa: R$464,00\nMensalidade de empresa inativa: R$232,00			\N	\N	\N
157	Rodrigo Eilliar	2015-05-07	2015-05-07	Empresa	2015-05-07 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	69	\N	315.20	5	\N	2	\N				\N	\N	\N
159	MAURO MANCIO DA SILVA	2015-05-11	2015-05-11	Empresa	2015-05-11 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	70	\N	350.00	2	\N	2	\N	EX CLIENTE			\N	\N	\N
158	Mary Pacheco	2015-05-07	2015-05-07	Empresa	2015-05-07 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	71	\N	1193.00	2	\N	2	\N	Empresa indicada pelo nosso cliente VPA (2204).			\N	\N	\N
87	Marcos	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	72	\N	464.00	3	\N	2	\N	Atualmente ele paga 590,00  de contador.			\N	\N	\N
130	Dr. Everton	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	61	326.98	9	\N	2	\N	Proposta enviada			\N	\N	\N
136	Dr. Shajadi	2015-03-31	2015-03-31	Pessoa	2015-03-31 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	62	788.00	9	\N	2	\N	Empresa de atividade médica, prestação de serviço para a Porto Seguro e também outros convenios e particulares. Será uma clinica médica e registrará um empregado em regime CLT.			\N	\N	\N
137	Rodrigo	2015-04-06	2015-04-06	Pessoa	2015-04-06 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	63	315.00	5	\N	2	\N				\N	\N	\N
88	Nilson Pereira Megatronik	2015-11-18	2015-11-18	Empresa	2015-11-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	73	\N	1182.00	3	\N	2	\N				\N	\N	\N
138	Dr. Dario	2015-08-25	2015-08-25	Pessoa	2015-08-25 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	64	326.98	9	\N	2	\N				\N	\N	\N
139	Dr. Enrique	2015-04-07	2015-04-07	Pessoa	2015-04-07 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	65	326.98	9	\N	2	\N				\N	\N	\N
140	Marcos	2015-04-09	2015-04-09	Empresa	2015-04-09 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	74	\N	788.00	6	\N	2	\N	Implantação - Proposta enviada pela Monary.			\N	\N	\N
141	Bayard	2015-04-09	2015-04-09	Pessoa	2015-04-09 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	66	429.00	2	\N	2	\N				\N	\N	\N
89	Ricardo Garcia	2015-06-30	2015-06-30	Pessoa	2015-06-30 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	67	788.00	2	\N	2	\N	NÃO GERAR CREDITO.			\N	\N	\N
131	Marina	2015-08-25	2015-08-25	Empresa	2015-08-25 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	75	\N	788.00	5	\N	2	\N				\N	\N	\N
144	Thiago luis	2015-04-10	2015-04-10	Empresa	2015-04-10 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	76	\N	149.00	2	\N	2	\N				\N	\N	\N
132	Luis Gustavo	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	68	469.63	2	\N	2	\N	Nosso cliente, ID 482.			\N	\N	\N
142	Alexandra (5A CONSULTORIA)	2015-04-09	2015-04-09	Pessoa	2015-04-09 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	69	1200.00	2	\N	2	\N	Nova empresa do grupo 5A. Não gera credito.			\N	\N	\N
145	Everton	2015-04-14	2015-04-14	Pessoa	2015-04-14 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	70	421.73	9	\N	2	\N	não é cliente porto			\N	\N	\N
143	Andréia	2015-04-09	2015-04-09	Pessoa	2015-04-09 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	71	590.00	5	\N	2	\N				\N	\N	\N
90	Cristian Alkimin	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	72	590.00	3	\N	2	\N				\N	\N	\N
146	Daniel Frigo	2015-04-16	2015-04-16	Pessoa	2015-04-16 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	73	429.00	2	\N	2	\N	Cliente da 1704- não irá gerar credito mensalidade			\N	\N	\N
148	Prisicila e Diego - Makis	2015-04-22	2015-04-22	Pessoa	2015-04-22 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	75	724.00	2	\N	2	\N	Já é cliente (empresa 2307). Não gera credito. Irão abrir uma nova empresa, pois a 2307 não foi enquadrada no SIMPLES NACIONAL.			\N	\N	\N
93	Marcio Aurelio Storer	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	77	\N	850.00	5	\N	2	\N				\N	\N	\N
149	Danilo	2015-04-23	2015-04-23	Pessoa	2015-04-23 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	76	469.00	2	\N	2	\N	EX-CLIENTE			\N	\N	\N
151	FERNANDA DE OLIVEIRA CRUZ FREIRE DE SOUZA	2015-04-28	2015-04-28	Pessoa	2015-04-28 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	77	421.73	2	\N	2	\N	Já é cliente ID 2191  - Propsosta enviada pela monary			\N	\N	\N
153	Ademir	2015-04-30	2015-04-30	Pessoa	2015-04-30 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	78	464.92	2	\N	2	\N	Posposta enviada pela Monary			\N	\N	\N
94	Vania Sanches	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	79	326.98	5	\N	2	\N				\N	\N	\N
154	Dr. Tiago Paiva	2015-04-30	2015-04-30	Pessoa	2015-04-30 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	80	464.92	2	\N	2	\N	Proposta enviada  pela Monary			\N	\N	\N
162	Herbert	2015-05-18	2015-05-18	Pessoa	2015-05-18 00:00:00	4	2	1	4	\N	\N	\N	\N	\N	\N	82	464.00	2	\N	2	\N	Prospostaa enviada  pela Monary			\N	\N	\N
95	Karine Moriya	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	78	\N	590.00	2	\N	2	\N	Grupo J.G. Moriya - JKK LOCAÇÕES DE MÁQUINAS E EQUIPAMENTOS LTDA - ME			\N	\N	\N
160	Luis	2015-05-12	2015-05-12	Pessoa	2015-05-12 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	83	458.97	2	\N	2	\N	Já é cliente da empresa 1461			\N	\N	\N
163	Thais	2015-05-20	2015-05-20	Pessoa	2015-05-20 00:00:00	4	2	1	4	\N	\N	\N	\N	\N	\N	84	788.00	2	\N	2	\N	Proposta enviada  pela Monary			\N	\N	\N
161	RENAN ANDRÉ ALVES SILVA	2015-05-12	2015-05-12	Pessoa	2015-05-12 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	85	788.00	5	\N	2	\N				\N	\N	\N
164	Dr. Afrânio	2015-05-21	2015-05-21	Empresa	2015-05-21 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	79	\N	2500.00	2	\N	2	\N	Proposta enviada pelo Telmon -  Transformar Operações e Assessoria especializada LTDA.			\N	\N	\N
165	Dr. Afranio	2016-03-23	2016-03-23	Empresa	2016-03-23 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	80	\N	1180.00	2	\N	2	\N	Proposta enviada pelo Telmon -  DEOLINDA SOCIEDADE DE ADVOGADOS			\N	\N	\N
167	Dr. Alisson	2015-05-21	2015-05-21	Empresa	2015-05-21 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	82	\N	591.00	2	\N	2	\N	Proposta enviada pela Monary - Indicação do Cliente  n° 2262.			\N	\N	\N
168	Heraldo e Denise	2015-05-22	2015-05-22	Pessoa	2015-05-22 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	86	464.00	2	\N	2	\N	Empresa indicada pelo Dr. Carlos Reich. Gera credito.			\N	\N	\N
169	Fabio	2015-05-25	2015-05-25	Pessoa	2015-05-25 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	87	350.00	2	\N	2	\N	EX-CLIENTE			\N	\N	\N
170	Maria Silvia Hermeto Pedrosa	2015-05-25	2015-05-25	Empresa	2015-05-25 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	83	\N	650.00	5	\N	2	\N				\N	\N	\N
171	Dr. Eric	2015-05-26	2015-05-26	Pessoa	2015-05-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	88	464.00	2	\N	2	\N	Porposta enviada pela Monary /  Indicação da empresa ID 2262			\N	\N	\N
172	Henrique Cesar Gouveia Pereira'	2015-05-26	2015-05-26	Empresa	2015-05-26 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	84	\N	788.00	2	\N	2	\N	Porposta enviada pela Monary			\N	\N	\N
173	Luis	2015-10-26	2015-10-26	Pessoa	2015-10-26 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	89	169.00	\N	\N	2	\N				\N	\N	\N
174	Miguel	2015-06-05	2015-06-05	Empresa	2015-06-05 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	85	\N	1174.00	5	\N	2	\N				\N	\N	\N
175	Lucy	2015-07-16	2015-07-16	Pessoa	2015-07-16 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	90	315.00	3	\N	2	\N				\N	\N	\N
176	Sr. Vicente Berna	2015-06-08	2015-06-08	Pessoa	2015-06-08 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	91	465.00	5	\N	2	\N	Contato solicitou proposta para abertura de empresa no ramo de atividade de cursos e treinamento livres. As taxas para registro serão de R$138,00 e R$100,00 da taxa de registro expresso, se eles aceitarem.			\N	\N	\N
177	Dra. Alice	2015-06-09	2015-06-09	Empresa	2015-06-09 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	87	\N	427.00	2	\N	2	\N	Proposta enviada em solcitação do Telmon			\N	\N	\N
178	Rafael (irmão da Grabrielle da W.SOLUNTION - 2319)	2015-06-12	2015-06-12	Pessoa	2015-06-12 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	92	350.00	2	\N	2	\N	O telefone acima é do Rafael. O e-mail é da irmã dele, para facilitar o contato.			\N	\N	\N
179	Lucas Reis Gomes Solar	2015-06-12	2015-06-12	Pessoa	2015-06-12 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	93	551.00	2	\N	2	\N	Indicação do Dr. Afranio da empresa Tranfomarh. Não gerará credito.			\N	\N	\N
180	Josiane Cristina Henrique	2015-06-17	2015-06-17	Empresa	2015-06-17 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	88	\N	421.00	\N	\N	2	\N				\N	\N	\N
183	Renato Andrade	2015-06-25	2015-06-25	Pessoa	2015-06-25 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	94	464.00	2	\N	2	\N	Prata 1. Indicação da Lucia Reiko. Não gera credito.			\N	\N	\N
181	Rafael Pauperio	2015-09-30	2015-09-30	Empresa	2015-09-30 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	89	\N	2800.00	5	\N	2	\N	Empresa: MOVE PRODUTORA DE ARTE (CNPJ 13.499.161/0001-13)			\N	\N	\N
182	Rafael Pauperio	2015-06-17	2015-06-17	Empresa	2015-06-17 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	90	\N	1200.00	5	\N	2	\N	Proposta para empresa: MOVE ESCRITORIO DE ARTE (CNPJ 07.370.665/0001-36).			\N	\N	\N
184	Clovis Lucio da Silva	2015-06-18	2015-06-18	Empresa	2015-06-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	91	\N	350.00	5	\N	2	\N				\N	\N	\N
187	Kim	2015-06-24	2015-06-24	Pessoa	2015-06-24 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	97	458.97	5	\N	2	\N				\N	\N	\N
188	Alexandre Aidas	2015-06-25	2015-06-25	Pessoa	2015-06-25 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	98	398.00	2	\N	2	\N	Indicação do Dr. Afranio da Transformarh			\N	\N	\N
189	Emerson Colin	2015-06-26	2015-06-26	Empresa	2015-06-26 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	92	\N	2364.00	5	\N	2	\N	Prosposta enviada pelo Telmon.			\N	\N	\N
191	Dr. Marcelo Erich Reicher	2015-06-30	2015-06-30	Empresa	2015-06-30 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	94	\N	2420.00	2	\N	2	\N	Proposta referente a empresa HQI SAUDE. Não gera credito.			\N	\N	\N
192	Cledson Jesus do Carmo	2015-07-02	2015-07-02	Pessoa	2015-07-02 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	99	350.00	5	\N	2	\N				\N	\N	\N
203	Sr. Moriya (J.G. MORIYA - 2222)	2015-07-21	2015-07-21	Empresa	2015-07-21 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	95	\N	900.00	2	\N	2	\N	Referente a serviços de recursos humanos			\N	\N	\N
193	José Ricardo Schwaitzer	2015-07-03	2015-07-03	Pessoa	2015-07-03 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	100	850.00	2	\N	2	\N	Proposta enviada pela Monary, indicação  empresa 1052 não gera credito			\N	\N	\N
194	Thiago Oliveira Lopes	2015-07-08	2015-07-08	Pessoa	2015-07-08 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	101	350.00	5	\N	2	\N				\N	\N	\N
195	Jorge  Luis Teixeira	2015-07-08	2015-07-08	Pessoa	2015-07-08 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	102	315.00	2	\N	2	\N	Proposta Enviada pelo Telmon			\N	\N	\N
196	Dra. Gisele Nunes	2015-07-16	2015-07-16	Pessoa	2015-07-16 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	103	421.73	2	\N	2	\N	Indicada pela Dra. Camila ID. 2310			\N	\N	\N
199	Bianca Oliveira Miranda	2015-07-14	2015-07-14	Empresa	2015-07-14 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	98	\N	2364.00	5	\N	2	\N				\N	\N	\N
202	Odirley Silva	2015-09-30	2015-09-30	Empresa	2015-09-30 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	99	\N	429.00	5	\N	2	\N				\N	\N	\N
204	Julino	2015-07-21	2015-07-21	Pessoa	2015-07-21 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	106	429.00	5	\N	2	\N				\N	\N	\N
205	Claudio	2015-07-24	2015-07-24	Pessoa	2015-07-24 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	107	315.20	5	\N	2	\N				\N	\N	\N
240	Takamori	2015-10-29	2015-10-29	Empresa	2015-10-29 00:00:00	2	3	4	2	\N	\N	\N	2017-04-11 08:40:21.994	\N	86	\N	0.00	\N	\N	2	\N				2015-04-11	\N	\N
155	Marina	2015-05-12	2015-05-12	Pessoa	2015-05-12 00:00:00	4	2	1	4	\N	\N	\N	\N	\N	\N	81	355.85	9	\N	2	\N	Proposta enviada pela Monary			\N	\N	\N
190	Raquel Nascimento	2015-07-16	2015-07-16	Empresa	2015-07-16 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	93	\N	464.00	5	\N	2	\N				\N	\N	\N
206	Marcelo Noronha	2015-07-27	2015-07-27	Empresa	2015-07-27 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	100	\N	355.00	2	\N	2	\N	Prata 1 especial. Empresa do grupo HQI. Não gera credito.			\N	\N	\N
207	Julio Cesar Saraiva	2015-08-05	2015-08-05	Pessoa	2015-08-05 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	108	380.00	2	\N	2	\N	Indicado por um cliente chamado Vanderlei Monteiro. Não localizei. Não gera credito. Bronze. Duas NF e 9.000,00 faturamento.			\N	\N	\N
208	Thiago Bezerra	2015-09-03	2015-09-03	Pessoa	2015-09-03 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	109	788.00	4	\N	2	\N	indicado pelo Marcos Thomas.			\N	\N	\N
209	Tarsila	2015-08-11	2015-08-11	Empresa	2015-08-11 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	101	\N	788.00	5	\N	2	\N				\N	\N	\N
210	Tarsila	2015-08-11	2015-08-11	Pessoa	2015-08-11 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	110	788.00	5	\N	2	\N				\N	\N	\N
211	Claudia Cabello	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	111	464.00	2	\N	2	\N	Indicado pelo Lucas Solar, Gera credito para ele. Empresa no simples de serviços administrativos.			\N	\N	\N
213	NILTON OHTA	2015-08-18	2015-08-18	Pessoa	2015-08-18 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	112	551.00	5	\N	2	\N	EX CLIENTE , EMPRESA EXTINTA  1089			\N	\N	\N
215	Karime/ Lourdes	2015-08-19	2015-08-19	Empresa	2015-08-19 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	102	\N	169.00	5	\N	2	\N	Empresa ficará inativa			\N	\N	\N
216	Lourdes / Karime	2015-08-19	2015-08-19	Pessoa	2015-08-19 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	115	551.00	5	\N	2	\N				\N	\N	\N
217	Rodrigo	2015-08-21	2015-08-21	Pessoa	2015-08-21 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	116	0.00	2	\N	2	\N	Proposta enviada pela Monary a pedido do Telmon			\N	\N	\N
218	Ian Vilenog	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	117	464.00	5	\N	2	\N	Proposta enviada pela Monary			\N	\N	\N
219	Daniela	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	118	788.00	8	\N	2	\N	Empresa Eirele			\N	\N	\N
221	CHRISTOPHER SILVEIRA	2015-08-31	2015-08-31	Empresa	2015-08-31 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	103	\N	850.00	5	\N	2	\N	Proposta enviada  pelo Telmon			\N	\N	\N
222	Alline (Ricardo PAI)	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	120	598.00	5	\N	2	\N				\N	\N	\N
224	Anna Luyza	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	121	551.00	7	\N	2	\N	Abertura de empresa - Porçosta solicitada pelo Telmon.			\N	\N	\N
226	Antonio Alexandre	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	122	315.00	5	\N	2	\N				\N	\N	\N
225	Christopher e Virginia	2015-09-28	2015-09-28	Empresa	2015-09-28 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	105	\N	506.00	2	\N	2	\N	Não Gera Credito. E-mail: chrys_silveira@hotmil.com (Chistopher). Implantação.			\N	\N	\N
227	Ana	2015-09-30	2015-09-30	Pessoa	2015-09-30 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	123	1576.00	7	\N	2	\N	Proposta enviada pela Monary			\N	\N	\N
228	Charles	2015-10-05	2015-10-05	Pessoa	2015-10-05 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	124	591.00	2	\N	2	\N	Não gerar crédito de mensalidade			\N	\N	\N
241	Clay Rulliam	2015-10-29	2015-10-29	Pessoa	2015-10-29 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	134	315.20	5	\N	2	\N				\N	\N	\N
247	Renato Szyflinger (Sinalizadora Paulista)	2015-11-10	2015-11-10	Empresa	2015-11-10 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	109	\N	6000.00	5	\N	2	\N	vindo do google			\N	\N	\N
198	Rede Protege - Quality - Sr. Pedro Lacerda	2015-07-14	2015-07-14	Empresa	2015-07-14 00:00:00	5	3	4	2	\N	\N	\N	2017-02-24 10:14:37.459	\N	97	\N	9150.00	5	\N	2	\N			Contrato com o metrô foi cancelado.	2017-02-24	\N	\N
251	Camila	2015-11-16	2015-11-16	Pessoa	2015-11-16 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	140	238.00	7	\N	2	\N	Honorarios R$ 750,00  Taxas 238,00 + Taxa CRO - A confirmar			\N	\N	\N
186	Arnaldo	2015-06-23	2015-06-23	Pessoa	2015-06-23 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	96	458.97	\N	\N	2	\N				\N	\N	\N
272	João dos Reis	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	155	238.00	5	\N	2	\N				\N	\N	\N
273	Marcos	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	156	250.36	2	\N	2	\N				\N	\N	\N
274	Rita	2016-01-12	2016-01-12	Pessoa	2016-01-12 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	157	150.36	5	\N	2	\N	Abertura (Monary)			\N	\N	\N
275	Rogério	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	158	250.36	5	\N	2	\N				\N	\N	\N
276	Veronica	2016-02-16	2016-02-16	Pessoa	2016-02-16 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	159	250.36	5	\N	2	\N	Restaurantre de comidad tipicas.			\N	\N	\N
278	Renato Duarte	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	160	261.36	5	\N	2	\N	Abertura - Granja e Rotisserie			\N	\N	\N
277	Eric	2016-02-16	2016-02-16	Pessoa	2016-02-16 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	161	250.36	5	\N	2	\N	Prestadora de Serviços de Comércio Eletrico.			\N	\N	\N
279	André Tadeu	2016-08-17	2016-08-17	Pessoa	2016-08-17 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	163	261.36	5	\N	2	\N				\N	\N	\N
280	Danielle Barcellos	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	164	261.36	5	\N	2	\N	Treinamentos			\N	\N	\N
282	Paulo Miorini	2016-01-28	2016-01-28	Empresa	2016-01-28 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	118	\N	0.00	5	\N	2	\N	Implantação			\N	\N	\N
281	Gilberto Gonçalves	2016-03-24	2016-03-24	Pessoa	2016-03-24 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	165	266.36	5	\N	2	\N				\N	\N	\N
283	Wellington	2016-03-24	2016-03-24	Pessoa	2016-03-24 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	166	551.00	5	\N	2	\N	ABERTURA DE EMPRESA, PROPOSTA ENVIADA PELA MONARY			\N	\N	\N
285	Guilherme Ramos	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	167	0.00	5	\N	2	\N				\N	\N	\N
287	Carina Teixeira	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	168	0.00	5	\N	2	\N				\N	\N	\N
286	Edgard Serafim	2016-05-10	2016-05-10	Pessoa	2016-05-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	169	266.36	5	\N	2	\N	Abertura			\N	\N	\N
288	Luis Silva (DOISLU)	2016-02-10	2016-02-10	Pessoa	2016-02-10 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	170	266.36	7	\N	2	\N	Será uma empresa bronze, pois ja possui a DOISLU como inativa			\N	\N	\N
289	Dr. Marcelo	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	171	880.00	2	\N	2	\N	Indicação do Dr. Pinhata - Não gera credito.			\N	\N	\N
291	Thiago Toth	2016-06-07	2016-06-07	Empresa	2016-06-07 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	120	\N	0.00	5	\N	2	\N	Mensalidade R$ 750,00			\N	\N	\N
292	Marco Aurrelio Damiani (Broker Serviços)	2016-03-28	2016-03-28	Empresa	2016-03-28 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	121	\N	950.00	2	\N	2	\N	Indicado pela nossa cliente Sistema Seguros. Não gera credito.			\N	\N	\N
290	Dr. Andrei Hilario Catarino	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	172	591.00	5	\N	2	\N	Empresa de prestação de serviços médicos.			\N	\N	\N
293	Danilo Capelli	2016-08-17	2016-08-17	Pessoa	2016-08-17 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	173	350.00	2	\N	2	\N	Proposta enviada pela Monary			\N	\N	\N
297	Adailton Rodrigues	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	174	266.36	5	\N	2	\N				\N	\N	\N
294	Raul Ramas	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	175	266.36	5	\N	2	\N				\N	\N	\N
295	Erik	2016-03-28	2016-03-28	Empresa	2016-03-28 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	122	\N	0.00	5	\N	2	\N				\N	\N	\N
296	Simone	2016-02-17	2016-02-17	Empresa	2016-02-17 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	123	\N	0.00	5	\N	2	\N				\N	\N	\N
300	Aguinaldo Cavalcante - Delta Software	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	124	\N	0.00	3	\N	2	\N	Implantação. Prosposta 1/3			\N	\N	\N
299	Robson Souza	2016-06-17	2016-06-17	Pessoa	2016-06-17 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	177	355.00	3	\N	2	\N	LAVANDERIA - FEIRA SEBRAE			\N	\N	\N
372	Gabrila MedSeg	2016-03-07	2016-03-07	Pessoa	2016-03-07 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	178	266.36	5	\N	2	\N				\N	\N	\N
301	Aguinaldo Cavalcante - Seacam	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	125	\N	0.00	3	\N	2	\N	Implantação, Proposta 2/3			\N	\N	\N
302	Aguinaldo Cavalcante -  Seametrologia	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	126	\N	0.00	3	\N	2	\N	Implantação			\N	\N	\N
303	Luiz Carlos Junior	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	179	355.00	3	\N	2	\N	Serviço de apoio administrativo. Pacote 1. Ficha Nº 73.			\N	\N	\N
305	Cosmo Santos Brito	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	182	355.00	3	\N	2	\N	Empresa de eventos esportivos. Ficha Nº 62.			\N	\N	\N
306	Carolina Lujan | Eliana Gomez	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	183	355.00	3	\N	2	\N	Ficha Nº 60.			\N	\N	\N
308	Jeronimo Rodrigo da Costa	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	185	0.00	3	\N	2	\N				\N	\N	\N
309	Ivan Francisco da Silva Jr.	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	186	0.00	3	\N	2	\N	Ficha Nº 34			\N	\N	\N
270	Richard Lopes	2015-12-30	2015-12-30	Pessoa	2015-12-30 00:00:00	2	3	4	2	\N	\N	\N	2017-04-11 14:24:35.315	\N	\N	154	238.00	5	\N	2	\N				2017-04-11	\N	\N
271	Roberto Carlos do Nascimento	2015-12-30	2015-12-30	Empresa	2015-12-30 00:00:00	2	3	4	2	\N	\N	\N	2017-04-11 14:24:48.984	\N	117	\N	0.00	5	\N	2	\N				2017-04-11	\N	\N
298	Dr. Gerson	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	176	380.00	5	\N	2	\N	Este cara é um consultor, fez uma pesquisa de preço para a cliente dele.			\N	\N	\N
304	Raphael de Oliveira Gomes	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	2017-08-24 12:09:00.225	\N	\N	\N	\N	\N	181	355.00	3	\N	2	\N	Serviços de cursos. Ficha Nº 72.			\N	\N	\N
312	Ezequiel Rafael Souza de Lima	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	189	0.00	3	\N	2	\N	Ficha Nº 61.			\N	\N	\N
313	Marcelo Lemos	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	190	0.00	3	\N	2	\N	Ficha Nº 39.			\N	\N	\N
314	Marcelo Lemos	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	191	0.00	3	\N	2	\N	Ficha Nº 40.			\N	\N	\N
316	Grazieli Barreto Cunha	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	4	2	1	4	\N	\N	\N	\N	\N	\N	193	0.00	3	\N	2	\N	Ficha Nº 74.			\N	\N	\N
323	Hellen Sacco	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	199	355.00	3	\N	2	\N	Ficha Nº 68.			\N	\N	\N
324	Jorge Popak	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	200	0.00	3	\N	2	\N	Ficha Nº 43.			\N	\N	\N
325	Marcos Brandão	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	130	\N	355.00	3	\N	2	\N	Ficha Nº 64.			\N	\N	\N
326	Aloisio Junqueira	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	131	\N	450.00	3	\N	2	\N	Ficha Nº 87.			\N	\N	\N
327	Allan | Caio	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	201	355.00	3	\N	2	\N	Ficha Nº 46.			\N	\N	\N
328	Izandro Pereira	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	132	\N	650.00	3	\N	2	\N	Ficha Nº 86.   NS4B - Net Solution for Business			\N	\N	\N
329	Xristos Tsouras	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	202	355.00	3	\N	2	\N	Ficha Nº 27.			\N	\N	\N
330	Luiz Felipe Grell	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	133	\N	355.00	3	\N	2	\N	Ficha Nº 84.   LR Grell			\N	\N	\N
331	Leandro Conde	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	134	\N	355.00	3	\N	2	\N	Ficha Nº 28.   Under Parts.			\N	\N	\N
332	Rita Martins Muniz	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	136	\N	355.00	3	\N	2	\N	Ficha Nº 51.   Leeds Corretora de Seguros.			\N	\N	\N
333	Alexandra	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	137	\N	0.00	3	\N	2	\N	Ficha Nº 85.   Brilho Park 2 filiais ativas e 1 inativa.			\N	\N	\N
334	Magali	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	203	355.00	2	\N	2	\N	Indicação de cliente.			\N	\N	\N
335	Ademar Lopes	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	138	\N	950.00	3	\N	2	\N	Ficha Nº 90.   Paga R$ 200,00 atualmente.			\N	\N	\N
336	Marcio Tavares	2016-02-26	2016-02-26	Empresa	2016-02-26 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	139	\N	355.00	3	\N	2	\N	Ficha Nº 81. Paga R$ 180,00 atualmente.			\N	\N	\N
337	Nazza Florentino	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	204	750.00	3	\N	2	\N	Ficha Nº 30. Cliente vai morar nos EUA.			\N	\N	\N
338	Americo Brilhante	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	205	380.00	2	\N	2	\N	Indicação de cliente.			\N	\N	\N
342	Alice Alves	2016-02-29	2016-02-29	Empresa	2016-02-29 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	140	\N	355.00	3	\N	2	\N	Ficha Nº 82.    Figurino Shop.			\N	\N	\N
343	Alice Alves	2016-02-29	2016-02-29	Empresa	2016-02-29 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	141	\N	0.00	3	\N	2	\N	Ficha Nº 83.   Saia Rodada Produções Artisticas.			\N	\N	\N
345	Geórgia Reis	2016-02-29	2016-02-29	Empresa	2016-02-29 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	143	\N	0.00	3	\N	2	\N	Ficha Nº 66. Empresa Arteirar.			\N	\N	\N
346	João Gilberto da Silva	2016-02-29	2016-02-29	Empresa	2016-02-29 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	144	\N	0.00	3	\N	2	\N	Ficha Nº 58.			\N	\N	\N
347	Katherine Pavloski	2016-02-29	2016-02-29	Empresa	2016-02-29 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	145	\N	0.00	3	\N	2	\N	Ficha Nº 76.   MANA Manutenção residencial e comercial.			\N	\N	\N
349	Fábio Garbini	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	206	266.30	5	\N	2	\N				\N	\N	\N
350	Marcelo Reich	2016-06-17	2016-06-17	Pessoa	2016-06-17 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	207	880.00	2	\N	2	\N	não gera credito			\N	\N	\N
351	Camila Tobias	2016-03-01	2016-03-01	Pessoa	2016-03-01 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	208	266.00	5	\N	2	\N	Abertura empresa médica.			\N	\N	\N
353	Gilbeti Lobo de Almeida	2016-03-01	2016-03-01	Empresa	2016-03-01 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	147	\N	0.00	3	\N	2	\N	Ficha Nº 44.			\N	\N	\N
354	Welington Cardoso	2016-03-01	2016-03-01	Pessoa	2016-03-01 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	210	355.00	3	\N	2	\N	Ou welingtoncardoso@hotmail.com. Ficha Nº 31.			\N	\N	\N
356	Willian José Dias	2016-03-01	2016-03-01	Empresa	2016-03-01 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	148	\N	880.00	3	\N	2	\N	Ficha Nº 92.   Chromafix Video.			\N	\N	\N
357	Willian José Dias	2016-03-01	2016-03-01	Empresa	2016-03-01 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	149	\N	355.00	3	\N	2	\N	Ficha Nº 48.   Emporium Systems.			\N	\N	\N
358	Fábio Francolino de Oliveira	2016-03-01	2016-03-01	Empresa	2016-03-01 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	150	\N	550.00	3	\N	2	\N	Ficha Nº 50.			\N	\N	\N
359	Edson da Silva	2016-03-01	2016-03-01	Empresa	2016-03-01 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	151	\N	355.00	3	\N	2	\N	Ficha Nº 52.   Tiger Corretora.			\N	\N	\N
361	Marcel Tanaka	2016-03-02	2016-03-02	Empresa	2016-03-02 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	153	\N	0.00	5	\N	2	\N	Implantação			\N	\N	\N
365	Valeria	2016-03-03	2016-03-03	Pessoa	2016-03-03 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	212	464.00	2	\N	2	\N	INDICAÇÃO DO CLIENTE  2262			\N	\N	\N
362	Silvia Balluminut	2016-03-02	2016-03-02	Pessoa	2016-03-02 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	213	450.00	5	\N	2	\N	Abertura, empresa de fabricação de paredes de escalada			\N	\N	\N
363	Felipe Alves Costa	2016-03-02	2016-03-02	Pessoa	2016-03-02 00:00:00	4	2	1	4	\N	\N	\N	\N	\N	\N	214	190.00	3	\N	2	\N	Ficha Nº 93.    AF Automação e Engenharia.			\N	\N	\N
364	Shirley Elina	2016-08-17	2016-08-17	Pessoa	2016-08-17 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	215	0.00	5	\N	2	\N	Abertura			\N	\N	\N
366	Talita	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	216	350.00	2	\N	2	\N	Indicação do Renato da Lucia Reiko			\N	\N	\N
367	Rodrigo	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	217	350.00	2	\N	2	\N				\N	\N	\N
381	Fernando Edson	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	219	266.36	5	\N	2	\N	Transportadora			\N	\N	\N
373	Antunes Santos	2016-03-08	2016-03-08	Pessoa	2016-03-08 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	221	355.00	5	\N	2	\N	Empresa de Construção e Reformas em geral.			\N	\N	\N
370	Lucia	2016-03-04	2016-03-04	Pessoa	2016-03-04 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	222	380.00	4	\N	2	\N	Ex- funcionária.			\N	\N	\N
352	Nilson Aguiar	2016-03-01	2016-03-01	Pessoa	2016-03-01 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 15:29:23.245	\N	\N	209	355.00	3	\N	2	\N	Ficha Nº 35.		DECLINADO. Por falta de retorno.	2017-03-20	\N	\N
355	Cleber Ely Moller	2016-03-01	2017-03-31	Pessoa	2016-03-01 00:00:00	2	3	4	2	2017-04-24 14:32:54.754	\N	2017-03-20 15:31:29.578	2017-06-05 11:57:58.214	\N	\N	211	450.00	3	3	2	\N	Ficha Nº 41.    Nunes Moller Arquitetura e Engenharia ltda.		Por falta de retorno.	2017-06-05	2017-06-05	\N
348	Dirceu Masson	2016-02-29	2017-06-30	Empresa	2016-02-29 00:00:00	2	3	4	2	2017-07-26 15:09:07.3	\N	2017-03-20 15:15:15.94	2017-07-26 15:09:17.197	\N	146	\N	0.00	3	4	2	\N	Ficha Nº 71.		DECLINADO. Decidiram fazer a contabilidade internamente.	2017-07-26	2017-07-26	\N
371	Vagner Zanzin	2016-03-04	2016-03-04	Pessoa	2016-03-04 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	223	551.00	3	\N	2	\N	Ficha Nº 70.			\N	\N	\N
374	Luiz Coelho	2016-03-08	2016-03-08	Pessoa	2016-03-08 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	224	355.00	5	\N	2	\N	Empresa de Treinamentos e Cursos			\N	\N	\N
507	Lucas Firmino Costa Sousa	2016-12-20	2016-12-20	Pessoa	2016-12-20 00:00:00	3	2	4	2	\N	\N	\N	2017-01-27 11:22:52.984	\N	\N	306	412.00	5	\N	2	\N				\N	\N	\N
375	Ricardo Fiacador	2016-03-11	2016-03-11	Empresa	2016-03-11 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	154	\N	0.00	3	\N	2	\N	Terá também uma alteração contratual para transformar de MEI para ME - 650,00 + taxas. Arretado food.			\N	\N	\N
376	Elisangela Franceschi	2016-03-11	2016-03-11	Pessoa	2016-03-11 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	225	150.36	5	\N	2	\N				\N	\N	\N
377	Fernanda Dourado	2016-03-11	2016-03-11	Empresa	2016-03-11 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	155	\N	4850.00	5	\N	2	\N				\N	\N	\N
378	Fernanda Dourado	2016-03-11	2016-03-11	Empresa	2016-03-11 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	156	\N	464.00	5	\N	2	\N	ALEXANDRE FEIPE CAPITANI			\N	\N	\N
380	Magali	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	226	0.00	2	\N	2	\N	Gerar crédito para o cliente  Dr. Marcelo Reich			\N	\N	\N
382	Dr. Eric	2016-03-15	2016-03-15	Pessoa	2016-03-15 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	227	950.00	2	\N	2	\N	proposta para uma sociedade de 5 médicos.			\N	\N	\N
392	Érica e Marina	2016-04-01	2016-04-01	Empresa	2016-04-01 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	158	\N	880.00	5	\N	2	\N				\N	\N	\N
383	Rodrigo César	2016-08-17	2016-08-17	Empresa	2016-08-17 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	159	\N	1500.00	5	\N	2	\N	Proposta enviada, quer abrir empresa S/A.			\N	\N	\N
384	Pedro Barutti	2016-03-17	2016-03-17	Empresa	2016-03-17 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	160	\N	0.00	5	\N	2	\N				\N	\N	\N
386	André Morillo	2016-03-21	2016-03-21	Empresa	2016-03-21 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	161	\N	880.00	3	\N	2	\N	Ficha Nº 8. Empresa COMERCIO DE INSUMOS E IMPRESSORAS IITA - EIRELI - ME.			\N	\N	\N
385	Raphael	2016-03-17	2016-03-17	Pessoa	2016-03-17 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	228	429.00	2	\N	2	\N	Indicação da Dra. Moriane			\N	\N	\N
387	Andréa Faro	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	229	266.36	5	\N	2	\N	Abertura de um Sex Shop			\N	\N	\N
389	Thatiana Babar	2016-03-31	2016-03-31	Empresa	2016-03-31 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	162	\N	350.00	5	\N	2	\N				\N	\N	\N
390	Sr. Julio Trabuco (IP-Experience)	2016-03-31	2016-03-31	Empresa	2016-03-31 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	163	\N	880.00	3	\N	2	\N	Contato da Feira do Empreendedor 2016			\N	\N	\N
391	Viviane Minozzo	2016-03-31	2016-03-31	Pessoa	2016-03-31 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	230	429.00	5	\N	2	\N				\N	\N	\N
393	André	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	231	880.00	5	\N	2	\N	ONG			\N	\N	\N
395	Marcio dal Pozzo	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	232	429.00	5	\N	2	\N				\N	\N	\N
388	Dra. Milena	2016-03-28	2016-03-28	Pessoa	2016-03-28 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	233	429.00	2	\N	2	\N	Indicação da empresa 2300			\N	\N	\N
394	Jorge	2016-04-15	2016-04-15	Pessoa	2016-04-15 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	234	450.00	3	\N	2	\N	Feira Sebrae, ligou após a feira.			\N	\N	\N
396	Danilo Carvalho	2016-04-11	2016-04-11	Empresa	2016-04-11 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	164	\N	1000.00	2	\N	2	\N	Indicação da 4Partners - Não Gera Crédito.			\N	\N	\N
397	Elton Rodrigues	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	235	650.00	5	\N	2	\N	Abertura, empresa de vigilancia			\N	\N	\N
398	João Paulo D'Elboux	2016-04-15	2016-04-15	Pessoa	2016-04-15 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	236	450.00	3	\N	2	\N	Ficha nº 12. Empresa: Ibicoara Projetos Saborosos			\N	\N	\N
399	Melina Souza	2016-08-17	2016-08-17	Pessoa	2016-08-17 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	237	464.00	5	\N	2	\N				\N	\N	\N
400	André Toledo	2016-04-18	2016-04-18	Pessoa	2016-04-18 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	238	950.00	5	\N	2	\N				\N	\N	\N
402	João Carvalho	2016-06-03	2016-06-03	Empresa	2016-06-03 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	165	\N	421.00	5	\N	2	\N				\N	\N	\N
403	ROGÉRIO SHIGUEMATSU MOTITSUKI	2016-04-20	2016-04-20	Empresa	2016-04-20 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	166	\N	162.16	7	\N	2	\N	Ex cliente			\N	\N	\N
404	Adonai Rossato	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	240	650.00	7	\N	2	\N				\N	\N	\N
405	Alessandra	2016-04-28	2016-04-28	Pessoa	2016-04-28 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	241	355.00	5	\N	2	\N				\N	\N	\N
406	Flavio Soares	2016-06-03	2016-06-03	Pessoa	2016-06-03 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	242	464.00	7	\N	2	\N				\N	\N	\N
407	Flávio Soares	2016-05-05	2016-05-05	Empresa	2016-05-05 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	167	\N	169.00	7	\N	2	\N	Inativa			\N	\N	\N
408	Felipe	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	243	355.00	2	\N	2	\N	Indicação da Conexão, Não gera crédito.			\N	\N	\N
409	Dr. Sergio Façanha	2016-05-05	2016-05-05	Pessoa	2016-05-05 00:00:00	4	2	1	4	\N	\N	\N	\N	\N	\N	244	880.00	2	\N	2	\N	E-mail a confirmar			\N	\N	\N
410	Priscila	2016-08-17	2016-08-17	Pessoa	2016-08-17 00:00:00	3	3	1	3	\N	\N	\N	\N	\N	\N	245	355.00	7	\N	2	\N	355 - Individual, 464 - 2 socios, 560 - 3 socios			\N	\N	\N
411	Dr. Leandro	2016-06-17	2016-06-17	Pessoa	2016-06-17 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	246	355.00	2	\N	2	\N	Indicação da HQI			\N	\N	\N
369	Luiz Carlos	2016-03-04	2016-03-04	Pessoa	2016-03-04 00:00:00	2	3	4	2	\N	\N	\N	2017-02-14 15:51:25.805	\N	\N	220	355.00	3	\N	2	\N	Ficha Nº 15.		DECLINADO, por falta de retorno.	2017-02-14	\N	\N
412	Marcelo Eira	2016-05-17	2016-05-17	Empresa	2016-05-17 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	168	\N	950.00	7	\N	2	\N				\N	\N	\N
413	Carlos	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	247	464.00	5	\N	2	\N				\N	\N	\N
414	Danilo Devecchi	2016-06-07	2016-06-07	Pessoa	2016-06-07 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	248	500.00	3	\N	2	\N				\N	\N	\N
415	Suzana Moraes	2016-06-07	2016-06-07	Empresa	2016-06-07 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	169	\N	500.00	5	\N	2	\N	Somente folha de pagamento.			\N	\N	\N
417	Kelen Flores - Kid Imports	2016-06-01	2016-06-01	Empresa	2016-06-01 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	170	\N	380.00	2	\N	2	\N	Indicação da empresa 2373 - Donna Lavadeira. Gera crédito			\N	\N	\N
418	Welington Cardoso	2016-06-02	2016-06-02	Pessoa	2016-06-02 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	250	350.00	3	\N	2	\N	Proposta ajustada aos esclarecimentos feira em reunião por skype. 1º proposta: nº354			\N	\N	\N
421	Fernanda Santana	2016-08-25	2016-08-25	Empresa	2016-08-25 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	172	\N	181.10	2	\N	2	\N	Empresa DEXXO MULTIMIDIA.			\N	\N	\N
422	Fabio	2016-06-09	2016-06-09	Pessoa	2016-06-09 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	251	850.00	2	\N	2	\N	não gerar credito			\N	\N	\N
425	Claudinei	2016-06-15	2016-06-15	Pessoa	2016-06-15 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	252	380.00	5	\N	2	\N				\N	\N	\N
420	Maicon	2016-06-07	2016-06-07	Pessoa	2016-06-07 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	253	429.00	5	\N	2	\N				\N	\N	\N
426	Silmara Cardoso	2016-06-15	2016-06-15	Pessoa	2016-06-15 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	254	380.00	5	\N	2	\N				\N	\N	\N
427	Adenilson	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	255	450.00	5	\N	2	\N	Abertura de empresa			\N	\N	\N
430	Sergio Yamaoka	2016-06-23	2016-06-23	Empresa	2016-06-23 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	176	\N	600.00	7	\N	2	\N	Empresa é cliente do Dr. Ricardo.			\N	\N	\N
431	Alexandre	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	256	400.00	2	\N	2	\N	Indicação da CUBO			\N	\N	\N
379	Dr. Afranio	2016-03-11	2016-03-11	Empresa	2016-03-11 00:00:00	2	3	4	2	\N	\N	\N	2017-04-11 08:40:44.345	\N	157	\N	4800.00	5	\N	2	\N	TransformaRH			2017-04-11	\N	\N
416	Marina (Sequenza)	2016-06-07	2016-06-07	Pessoa	2016-06-07 00:00:00	5	3	1	2	2018-01-12 13:54:38.923	\N	\N	\N	\N	\N	249	380.00	2	\N	7	\N				\N	2018-01-12	\N
432	LUCIANA DEOLINDA - SOCIEDADE INDIVIDUAL DE ADVOCACIA	2016-06-27	2016-06-27	Empresa	2016-06-27 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	178	\N	650.00	7	\N	2	\N	IMPLANTAÇÃO.			\N	\N	\N
434	Marilene do Prado	2016-08-25	2016-08-25	Pessoa	2016-08-25 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	257	700.00	5	\N	2	\N				\N	\N	\N
433	Marcus Vinicius	2016-06-27	2016-06-27	Pessoa	2016-06-27 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	258	400.00	2	\N	2	\N	Ex-cliente. A esposa vai abrir uma empresa.			\N	\N	\N
436	Willian José Dias	2016-11-09	2016-11-09	Empresa	2016-11-09 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	180	\N	400.00	3	\N	2	\N	Empresa WM BARBEZAN - ME			\N	\N	\N
437	Willian José Dias	2016-11-09	2016-11-09	Empresa	2016-11-09 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	182	\N	400.00	3	\N	2	\N	Empresa CHROMAFIX VIDEO ENGENHARIA E TELECOMUNICAÇÕES LTDA			\N	\N	\N
440	CIS - São Paulo	2016-07-05	2016-07-05	Empresa	2016-07-05 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	184	\N	13500.00	2	\N	2	\N	Empresa do Sr. Sadau, amigo do Takamori e Dr. Ricardo. Contato somente por e-mail com o Sr. Luiz Tomizawa			\N	\N	\N
441	Francini Queiroz de Freitas	2016-09-16	2016-09-16	Pessoa	2016-09-16 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	259	508.00	5	\N	2	\N				\N	\N	\N
442	Dr. Bruno	2016-09-29	2016-09-29	Pessoa	2016-09-29 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	260	433.33	5	\N	2	\N				\N	\N	\N
445	Dra. Renata Souza	2016-07-20	2016-07-20	Empresa	2016-07-20 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	186	\N	330.00	5	\N	2	\N	prestação de serviços de assessoria contábil na escrituração mensal de livro caixa para fins de Imposto de Renda de Pessoa Física e Folha de Pagamento			\N	\N	\N
449	Edgar Junior	2016-07-28	2016-07-28	Empresa	2016-07-28 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	189	\N	429.00	5	\N	2	\N	Indicação Sequenza			\N	\N	\N
450	Ana dos Santos	2016-09-29	2016-09-29	Pessoa	2016-09-29 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	263	450.00	5	\N	2	\N	Abertura			\N	\N	\N
451	João Felipe	2016-08-09	2016-08-09	Pessoa	2016-08-09 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	264	502.67	5	\N	2	\N				\N	\N	\N
454	Rodolfo Cantarim	2016-09-16	2016-09-16	Pessoa	2016-09-16 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	266	352.00	7	\N	2	\N	Bronze			\N	\N	\N
455	Erisson Tsubaki	2016-09-16	2016-09-16	Pessoa	2016-09-16 00:00:00	3	2	1	3	\N	\N	\N	\N	\N	\N	267	700.00	7	\N	2	\N				\N	\N	\N
453	Valdete dos Santos Ribeiro	2016-08-17	2016-08-17	Pessoa	2016-08-17 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	268	950.00	5	\N	2	\N				\N	\N	\N
459	Márcio Manoel	2016-09-16	2016-09-16	Pessoa	2016-09-16 00:00:00	2	3	1	2	\N	\N	\N	\N	\N	\N	270	480.00	5	\N	2	\N				\N	\N	\N
461	Dr. Joaquim	2016-09-20	2016-09-20	Pessoa	2016-09-20 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	271	469.00	2	\N	2	\N	Indicação Dra. Carolina Portomed			\N	\N	\N
462	Fabio	2016-09-20	2016-09-20	Pessoa	2016-09-20 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	273	469.00	8	\N	2	\N	Proposta vinda CRA-SP			\N	\N	\N
460	Carlos Jose Leal Junior	2016-09-19	2016-09-19	Pessoa	2016-09-19 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	\N	274	350.00	5	\N	2	\N				\N	\N	\N
465	Sandra Marostica	2016-10-06	2016-10-06	Pessoa	2016-10-06 00:00:00	5	3	1	5	\N	\N	\N	\N	\N	\N	276	350.00	7	\N	2	\N	Contato 5° Forum empreendedoras			\N	\N	\N
466	Cristina Bonadio	2016-10-05	2016-10-05	Empresa	2016-10-05 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	192	\N	750.00	\N	\N	2	\N	FEIRA DA MULHER EMPREENDEDORA			\N	\N	\N
463	Camila itlean.com.br	2016-09-23	2017-02-16	Pessoa	2016-09-23 00:00:00	4	3	4	2	2017-02-09 11:32:12.04	\N	2017-02-09 11:31:57.321	2017-02-09 11:44:33.732	\N	\N	272	500.00	8	3	2	\N	@itlean.com.br		Bira respondeu por e-mail: "Olá Isabelle, bom dia tudo bem? Por enquanto não. Obrigado"	2017-02-09	\N	\N
456	Aliny Moreira Bernardino	2016-09-29	2017-02-16	Pessoa	2016-09-29 00:00:00	4	3	1	4	2017-02-23 15:44:36.948	\N	2017-02-09 11:47:53.767	\N	\N	\N	269	0.00	5	3	2	\N			Optou por abrir MEI.	2017-02-23	\N	\N
446	Célio Levorim	2016-09-16	2017-02-14	Empresa	2016-09-16 00:00:00	2	3	3	2	\N	\N	2017-02-13 10:54:46.566	\N	\N	187	\N	1300.00	2	4	2	\N	Não gera credito			2017-02-13	\N	\N
470	Flaina	2016-10-20	2016-10-20	Empresa	2016-10-20 00:00:00	4	3	1	4	\N	\N	\N	\N	\N	193	\N	1800.00	7	\N	2	\N				\N	\N	\N
473	Robson Souza Leite	2016-10-24	2016-10-24	Pessoa	2016-10-24 00:00:00	5	2	1	5	\N	\N	\N	\N	\N	\N	281	480.00	3	\N	2	\N				\N	\N	\N
1	Adriana	2015-05-20	2015-05-20	Pessoa	2015-05-20 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	1	421.00	2	\N	2	\N	Abertura R$650,00 e Taxa R$125,00. Prata 1			\N	\N	\N
2	Dr. José	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	2	523.00	9	\N	2	\N	Abertura R$650,00 e Taxas R$125,00. Prata 3			\N	\N	\N
3	Maicol	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	3	543.00	2	\N	2	\N	Abertura R$650,00 e taxas de R$125,00. Prata 3. Não deixou telefone. Já é cliente e não consta telefone no cadastro.			\N	\N	\N
4	Dr. Leonardo	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	4	421.00	2	\N	2	\N	Abertura R$650,00 e R$125,00 de Taxas. Gera credito - Indicado pelo cliente 2276. Prata 1. Não deixou telefone.			\N	\N	\N
6	Patrick	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	5	421.73	8	\N	2	\N	O cliente irá fazer Corretagem de imóveis, irá inicilamente abrir a empresa como INATIVA, até obter faturamento.			\N	\N	\N
5	Alessandro Buonopane	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	6	421.73	2	\N	2	\N	Abertura R$650,00 e Taxas de R$125,00. Ex-cliente. Não gera credito. Prata 1			\N	\N	\N
7	Arnaldo Furtado	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	7	429.00	2	\N	2	\N	Abertura R$750,00 e taxas no Valor de R$125,00. Ex-cliente. Encerrou uma empresa conosco.			\N	\N	\N
8	Dra. Aline Ueda	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	2	1	6	\N	\N	\N	\N	\N	\N	8	421.73	2	\N	2	\N	Prestação de serviços médicos. ( Indicação da Dra. Lidiana ID 2228).			\N	\N	\N
9	Neide	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	9	350.00	2	\N	2	\N	ESTA CLIENTE JA OBTEM UMA EMPRESA CONOSCO - ID 017 HONDA CONSULTING - CONSULTORIA EMPRESARIAL, ELABORAÇÃO E DISTRIBUIÇÃO DE SOFTWARE LTDA.   - NÃO IRÁ GERAR CREDITO POR INDICAÇÃO.			\N	\N	\N
423	Magda (STERN)	2016-08-25	2017-02-20	Empresa	2016-08-25 00:00:00	3	3	4	2	\N	\N	2017-02-13 11:42:38.811	2017-03-20 15:50:46.08	\N	173	\N	1800.00	5	\N	2	\N	STERN SOFTWARE		Não vai mais mudar de contador. Não foi receptiva ao telefone.	2017-03-20	\N	\N
435	Willian José Dias	2016-11-09	2016-11-09	Empresa	2016-11-09 00:00:00	2	2	1	2	2018-03-19 09:46:24.781	\N	\N	\N	\N	179	\N	200.00	14	\N	2	\N	Empresa EMPORIUM SYSTEMS VIDEO E AUDIO - LTDA EPP			\N	2018-03-19	\N
491	Marcos	2016-11-11	2018-01-31	Empresa	2016-11-11 00:00:00	2	3	3	2	2017-07-25 11:04:26.51	\N	2018-03-26 11:48:35.61	2018-01-23 11:55:36.078	\N	196	\N	0.00	6	4	2	\N			DECLINADO. Não retorna whatsapp, e-mail ou ligações. Enviei e-mail de declínio.	2018-01-23	2018-03-26	\N
10	Eduardo Motti	2015-05-21	2015-05-21	Empresa	2015-05-21 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	1	\N	850.00	2	\N	2	\N	O cliente coordena uma Associação chamada Aliança Pesquisa Clínica Brasil.Empresa não obtem empregados, e o faturamento varia de 30 a 50 mil mês.VAI GERAR CREDITO POR INDICAÇÃO.			\N	\N	\N
133	Victor	2015-07-02	2015-07-02	Empresa	2015-07-02 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	2	\N	788.00	2	\N	2	\N	Já é cliente, tem a empresa 2058			\N	\N	\N
11	Humberto	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	10	421.73	2	\N	2	\N	GERAR CREDITO POR INDICAÇÃO PARA EMPRESA 2121			\N	\N	\N
134	Verucio	2015-07-02	2015-07-02	Empresa	2015-07-02 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	3	\N	464.00	5	\N	2	\N				\N	\N	\N
12	Evanildes Vieira (VICTUS)	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	4	\N	8430.00	5	\N	2	\N	Empresa na área da tecnologia da informação, Lucro Real, com faturamento de R$2.300.000,00 e com 80 empregados e 100 prestadores de serviços PJ. A Evanildes trabalhou na empresa Cincotech e Procwork. Conhece o Carlos Cuevas, Flavio Borges.			\N	\N	\N
13	Milton Roberto	2015-03-27	2015-03-27	Empresa	2015-03-27 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	5	\N	1182.00	4	\N	2	\N	Reunião realizada pelo Telmon no dia 06/02.			\N	\N	\N
14	Marcelo	2015-05-21	2015-05-21	Pessoa	2015-05-21 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	11	788.00	5	\N	2	\N	Empresa salão de cabelereiro SN, proposta nº 14			\N	\N	\N
15	Marcelo	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	12	950.00	5	\N	2	\N	Proposta nº 15 - restauramente simples nacional.			\N	\N	\N
18	Anderson	2015-03-26	2015-03-26	Pessoa	2015-03-26 00:00:00	6	3	1	6	\N	\N	\N	\N	\N	\N	14	788.00	3	\N	2	\N	Contato visituou nosso stand na feira do empreendedorismo.07/02			\N	\N	\N
502	Dr. Henrique	2016-12-08	2016-12-08	Pessoa	2016-12-08 00:00:00	2	2	1	2	\N	\N	\N	\N	\N	\N	301	460.00	2	\N	2	\N	Indicação empresa SALIM 2297			\N	\N	\N
505	Alberto Araújo	2016-12-21	2016-12-21	Pessoa	2016-12-21 00:00:00	3	3	4	2	2017-01-30 15:46:12.25	\N	\N	2017-01-30 17:16:16.828	\N	\N	303	380.00	5	3	2	\N			DECLINADO, desistiu de abrir empresa.	2017-01-30	\N	\N
495	Adriana	2016-11-21	2016-11-21	Empresa	2016-11-21 00:00:00	3	3	4	2	\N	\N	\N	2017-01-31 11:12:56.837	\N	200	\N	950.00	7	\N	2	\N			Receberam uma contra-proposta e fecharam com outra contabilidade.	2017-01-31	\N	\N
477	Leonardo	2016-10-25	2016-10-25	Pessoa	2016-10-25 00:00:00	2	3	4	2	\N	\N	\N	2017-02-06 10:38:10.076	\N	\N	285	395.00	2	\N	2	\N	(Maria José)		Desistiu de abrir empresa.	2017-02-06	\N	\N
468	Tainah Freitas Netto	2016-10-17	2017-02-16	Pessoa	2016-10-17 00:00:00	4	3	4	2	2017-02-09 11:07:51.112	\N	2017-02-09 10:58:35.51	2017-02-22 11:10:28.439	\N	\N	278	469.00	2	\N	2	\N	Indicação Dr. Joaquim		E-mail da Tainah: "Estou agora em um trabalho fixo 1 dia na semana e com possibilidade de entrar em mais um. Tenho interesse em abrir mas ainda vou aguardar para estabilizar minha vida e ver se continuarei com os trabalhos eventuais que necessitam de PJ."	2017-02-22	\N	\N
474	Maria José	2016-10-24	2017-02-06	Empresa	2016-10-24 00:00:00	2	3	4	2	\N	\N	\N	2017-02-06 12:12:15.637	\N	195	\N	380.00	2	\N	2	\N	SERVIÇOS DE ALTERAÇÃO CONTRATUAL:  R$ 1.500,00 + taxas para não cliente ou R$ 750,00 + taxas caso aceita a proposta de implantação.		Mesmo contato da proposta 477. Desistiu de abrir empresa.	2017-02-06	\N	\N
467	Helcio	2016-10-17	2016-10-17	Pessoa	2016-10-17 00:00:00	5	2	4	2	\N	\N	\N	2017-02-09 11:12:38.107	\N	\N	277	469.00	2	\N	2	\N				\N	\N	\N
494	Eduardo Jonatas Landi	2016-11-17	2017-11-07	Pessoa	2016-11-17 00:00:00	2	3	4	2	\N	\N	2017-01-31 11:19:37.701	2017-01-31 12:02:21.096	\N	\N	296	490.00	5	3	2	\N			Não vai mais abrir empresa.	2017-01-31	\N	\N
488	Richard dos Santos de Castro	2016-11-08	2016-11-08	Pessoa	2016-11-08 00:00:00	2	3	4	2	\N	\N	\N	2017-01-31 11:45:30.842	\N	\N	293	434.00	5	\N	2	\N			DECLINADO por falta de retorno.	2017-01-31	\N	\N
489	Maria Sandra de Araújo	2016-11-08	2016-11-08	Pessoa	2016-11-08 00:00:00	2	3	4	2	\N	\N	\N	2017-01-31 11:45:35.56	\N	\N	294	450.00	5	\N	2	\N				\N	\N	\N
482	Melquisedec Paulo Santana	2016-10-28	2016-10-28	Pessoa	2016-10-28 00:00:00	2	3	4	2	\N	\N	\N	2017-02-02 11:37:35.295	\N	\N	290	568.00	5	\N	2	\N			Estava com pressa e acabou abrindo com outra contabilidade.	2017-02-02	\N	\N
166	Dr. Afranio	2015-05-21	2015-05-21	Empresa	2015-05-21 00:00:00	5	2	4	2	\N	\N	\N	2017-02-13 14:24:43.919	\N	81	\N	850.00	2	\N	2	\N	Proposta enviada pelo Telmon -  MATTEO MARCHIORI EIRELI			\N	\N	\N
185	Amauri Juqueira	2015-06-19	2015-06-19	Pessoa	2015-06-19 00:00:00	5	3	4	2	\N	\N	\N	2017-02-13 14:26:31.401	\N	\N	95	315.00	2	\N	2	\N	Este contato refere-se a uma indicação do Sr. Labera da 4 Parteners. Trata-se de uma corretora de beneficios que possui diversos corretores que são contratados como PJ. A proposta é abertura de empresa e manutenção mensal.		Falta de retorno.	2017-02-13	\N	\N
368	Fábio Alves	2016-03-04	2016-03-04	Pessoa	2016-03-04 00:00:00	2	3	4	2	\N	\N	\N	2017-02-14 15:54:41.981	\N	\N	218	266.36	3	\N	2	\N	Abertura		DECLINADO, por falta de retorno.	2017-02-14	\N	\N
476	Marcelo F. Marchese	2016-10-25	2017-02-13	Pessoa	2016-10-25 00:00:00	2	3	4	2	\N	\N	2017-02-06 10:55:24.834	2017-02-09 08:30:44.58	\N	\N	283	440.00	2	3	2	\N			E-mail do cliente "Por enquanto não estarei dando andamento no processo de abertura da empresa. Caso venha a precisar, entrarei em contato novamente."	2017-02-09	\N	\N
484	Gilberto	2016-11-01	2017-02-09	Pessoa	2016-11-01 00:00:00	2	3	4	2	2017-02-02 11:25:54.758	\N	2017-02-02 11:41:38.151	2017-04-05 14:18:59.282	\N	\N	291	350.00	7	3	2	\N			Não tem previsão para abertura. Disse que entra em contato conosco.	2017-04-05	\N	\N
508	Roberio José Silva dos Santos	2016-12-22	2017-09-29	Pessoa	2016-12-22 00:00:00	2	3	4	2	2017-07-25 10:41:40.225	2017-08-30 16:22:06.895	2017-07-25 10:41:20.857	2018-01-23 12:03:41.059	\N	\N	307	480.00	5	3	2	\N	Reparação e manutenção de ar condicionado de uso doméstico ou industrial.		DECLINADO. Não retorna e-mails e telefonemas.	2018-01-23	2018-01-23	\N
472	Lilian Baldi Tavares	2016-10-21	2017-06-30	Empresa	2016-10-21 00:00:00	2	3	4	2	2017-07-26 14:55:13.515	\N	2017-07-26 14:54:32.81	2017-07-26 14:55:16.173	\N	194	\N	400.00	9	4	2	\N				\N	2017-07-26	\N
512	Rodrigo Ike	2017-01-17	2017-05-17	Pessoa	2017-01-23 15:16:00.917	2	2	4	2	2017-05-15 15:41:21.017	2017-01-23 15:34:58.294	2017-05-15 15:42:21.018	2017-07-18 10:25:10.94	\N	\N	317	555.00	2	3	2	8				\N	2017-07-18	\N
497	Guimarães	2016-11-22	2016-11-22	Empresa	2016-11-22 00:00:00	2	3	4	2	2017-04-10 16:51:33.179	\N	2017-01-31 10:49:07.745	2017-04-27 14:56:31.325	\N	201	\N	350.00	3	4	2	\N	Alteração Contratual R$ 650 + R$ 67,48 taxas		Por falta de retorno.	2017-04-27	2017-04-27	\N
483	Daiciana Adame Lopes	2016-11-01	2017-04-03	Pessoa	2016-11-01 00:00:00	2	3	4	2	2017-02-02 11:29:15.083	\N	2017-02-02 11:41:34.51	2017-04-03 16:28:44.307	\N	\N	289	382.00	5	\N	2	\N			Por falta de retorno.	2017-04-03	\N	\N
492	Paulo - Restaurante La Friulana	2016-11-16	2017-03-07	Empresa	2016-11-16 00:00:00	2	3	4	2	\N	\N	2017-01-31 11:31:55.469	2017-04-05 15:28:19.716	\N	199	\N	1500.00	7	4	2	\N	Rua Maria Paula, 98		Paulo (Restaurante La Friulana) explicou que gostam muito da ProLink e dos serviços, porém estão com o contados há mais de 20 anos. Quando informou que iria sair o contador abaixou o preço e ele desistiu da mudança.	2017-04-05	\N	\N
493	Andreia Lucia Rodrigues	2016-11-16	2017-03-07	Pessoa	2016-11-16 00:00:00	2	3	4	2	\N	\N	2017-01-31 11:23:33.492	2017-04-05 15:36:54.843	\N	\N	295	400.00	5	3	2	\N			Falta de retorno.	2017-04-05	\N	\N
485	Andreia	2016-11-01	2017-05-16	Pessoa	2016-11-01 00:00:00	2	3	4	2	2017-04-05 15:03:48.81	\N	2017-04-05 15:00:54.66	2017-04-27 14:34:37.811	\N	\N	292	350.00	2	3	2	\N			Nunca retorna os e-mails.	2017-04-27	2017-04-27	\N
458	Maria Luiza	2016-09-16	2017-02-16	Empresa	2016-09-16 00:00:00	3	3	3	4	\N	\N	2017-02-23 15:34:51.313	\N	\N	190	\N	487.50	2	4	2	\N	Indicação do Dr. Gerson da Coibim. GERA CRÉDITO.		DECLINADO - Por falta de retorno.	2017-02-23	\N	\N
520	Fernando (Sequenza)	2017-02-03	2017-02-10	Pessoa	2017-02-03 15:56:01.151	2	2	4	2	2017-02-03 15:56:01.167	2017-02-06 09:15:15.705	\N	2017-02-08 10:39:12.654	\N	\N	329	656.00	2	3	\N	\N	Elaboração e licenciamento de programas de computadores (Software)\nSuporte Técnico em Programas de Computadores\nDesenvolvimento de Programas de Computadores Customizáveis e Não Customizáveis\nConsultoria e Assessoria em Programas de Computadores			\N	\N	\N
501	Roberto	2016-12-08	2016-12-08	Empresa	2016-12-08 00:00:00	2	3	4	2	\N	\N	\N	2017-02-09 16:36:45.56	\N	177	\N	0.00	7	\N	2	\N			Roberto irá fazer sua contabilidade com a esposa pois por enquanto não pode pagar uma contabilidade mensal.	2017-01-30	\N	\N
428	Eduardo Pérez	2016-09-16	2017-02-20	Pessoa	2016-09-16 00:00:00	2	3	4	2	\N	\N	\N	2017-02-13 11:33:26.104	\N	\N	162	0.00	5	\N	2	\N			DECLINADO, por falta de retorno.	2017-02-13	\N	\N
39	Willian	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	4	2	\N	\N	\N	2017-02-13 14:15:12.146	\N	14	\N	1576.00	3	\N	2	\N	Atualemnte paga acima de R$ 724,00 para o contador - Propomos uma mensalidade Ouro 3 - Silvia quem atendeu.		DECLINADO, por falta de retorno.	2017-02-13	\N	\N
475	Alan Gesse Maciel	2016-10-25	2017-02-13	Pessoa	2016-10-25 00:00:00	2	3	4	3	2017-02-22 09:15:54.888	\N	2017-02-06 11:35:05.865	2017-02-22 10:00:18.02	\N	\N	282	440.00	7	3	2	\N	Alan trabalha no 8º andar deste prédio.		Cliente desistiu de abrir empresa	2017-02-22	\N	\N
471	Rodrigo Bortolini	2016-10-20	2017-02-16	Pessoa	2016-10-20 00:00:00	2	3	4	3	2017-02-09 10:33:50.737	\N	2017-02-09 10:32:08.668	2017-02-22 10:12:35.282	\N	\N	280	385.00	5	3	2	\N			DECLINADO, CLIENTE DESISTIU.	2017-02-22	\N	\N
469	Silvane	2016-10-17	2016-10-17	Pessoa	2016-10-17 00:00:00	3	3	1	4	2017-02-23 15:00:27.589	\N	\N	\N	\N	\N	279	350.00	5	\N	2	\N			DECLINADO - Não tem mais interesse em abrir a e empresa.	2017-02-23	\N	\N
457	Fabiana Flores	2016-08-25	2017-02-16	Empresa	2016-08-25 00:00:00	2	3	3	4	\N	\N	2017-02-23 15:36:20.704	\N	\N	191	\N	469.00	2	4	2	\N	Ex cliente. ID 506		No momento não tem interesse em muidar de contador.	2017-02-09	\N	\N
197	Rede Protege - Quality - Sr. Pedro Lacerda	2015-07-14	2015-07-14	Empresa	2015-07-14 00:00:00	5	3	4	2	\N	\N	\N	2017-02-24 10:14:26.349	\N	96	\N	9850.00	5	\N	2	\N			Contrato com o metrô foi cancelado.	2017-02-24	\N	\N
200	Jeová Sergio dos Santos	2015-07-14	2015-07-14	Pessoa	2015-07-14 00:00:00	4	3	4	2	\N	\N	\N	2017-02-24 10:15:02.956	\N	\N	104	469.00	5	\N	2	\N	Proposta enviada pela Monary		Não atende!	2017-02-24	\N	\N
464	Maria do Socorro	2016-09-27	2017-02-16	Pessoa	2016-09-27 00:00:00	2	3	1	4	2017-03-02 12:24:20.119	\N	2017-02-23 15:33:09.243	\N	\N	\N	275	650.00	7	3	2	\N	5° Forum empreendedoras.		DECLINADO - Por falta de retorno.	2017-02-23	\N	\N
535	Marcos Carvalho	2017-02-24	2017-03-01	Pessoa	2017-02-24 17:04:07.417	3	3	4	3	2017-02-24 17:04:07.432	\N	\N	2017-03-07 10:18:27.338	\N	\N	344	500.00	11	3	2	\N	Abertura de empresa de transportes.		CLIENTE NÃO TEM MAIS INTERESSE NA ABERTURA DA EMPRESA	2017-03-07	\N	\N
524	Rose	2017-02-08	2017-02-16	Empresa	2017-02-08 11:54:57.372	2	3	2	4	2017-02-08 11:54:57.375	2017-03-02 15:25:40.576	2017-02-09 17:44:22.853	2017-02-08 11:55:43.878	\N	202	\N	937.00	5	4	2	\N				2017-03-02	\N	\N
541	Fabiana	2017-02-24	\N	Pessoa	2017-03-07 10:51:50	3	3	1	4	2017-03-28 14:52:44.781	2017-03-09 14:16:07.127	2017-03-07 10:33:47.233	\N	\N	\N	343	250.00	11	3	2	1	Empresa MEI, enviamos proposta de adminstração mensal de folha.		Abrira MEI	2017-03-28	\N	\N
401	Erica  Vilalba	2016-08-17	2018-04-27	Pessoa	2016-08-17 00:00:00	4	1	3	2	2017-06-05 12:28:38.691	2018-01-23 11:19:55.271	2018-03-26 11:35:52.753	\N	2017-07-26 15:06:31.742	\N	239	469.00	15	3	2	\N	Indicação da empresa 2165			\N	\N	\N
487	Sandra	2016-11-03	2017-08-09	Empresa	2016-11-03 00:00:00	2	4	5	2	2017-07-25 11:04:36.535	\N	2017-02-09 12:06:18.723	\N	2017-11-29 09:34:52.613	198	\N	350.00	3	4	2	\N				\N	2017-11-29	\N
537	Ana (Egus Fotografia)	2017-03-02	2017-03-20	Pessoa	2017-03-02 14:42:37.516	3	3	1	4	2017-04-04 17:15:37.113	2017-03-09 16:42:38.294	\N	\N	\N	\N	349	500.00	11	3	2	8	Sem 13ª Mensalidade		Proposta DECLINADA, cliente fechou com o contador amigo.	2017-04-04	\N	\N
529	NUTRI&RUN ALIMENTOS E BEM ESTAR EIRELI	2017-02-17	2017-09-29	Empresa	2017-02-17 16:07:49.526	3	4	5	2	2017-08-30 16:02:14.315	\N	2017-08-30 16:00:10.603	\N	2018-01-17 12:24:43.291	181	\N	750.00	2	\N	2	\N	NUTRI&RUN ALIMENTOS E BEM ESTAR EIRELI			\N	2018-01-17	\N
531	Cecilia	2017-02-20	2017-03-06	Pessoa	2017-02-20 15:04:32.685	2	2	4	3	\N	2017-02-20 15:04:32.69	\N	2017-03-20 15:04:18.951	\N	\N	339	464.00	7	3	2	7	Prestação de Serviços de Fisioterapia.			\N	\N	\N
525	David Souza da Silva	2017-02-15	2017-08-11	Pessoa	2017-02-15 08:27:55.158	2	3	4	2	2017-07-25 10:23:10.806	\N	\N	2017-07-25 10:23:13.921	\N	\N	334	788.00	5	3	2	\N				\N	2017-07-25	\N
523	Marssella	2017-02-08	2017-02-15	Pessoa	2017-02-08 10:17:32.983	2	2	4	3	\N	2017-02-08 10:18:56.716	\N	2017-03-20 15:11:23.502	\N	\N	332	380.00	\N	3	2	1				\N	\N	\N
526	Mario Quadros	2017-02-15	2018-01-31	Pessoa	2017-02-15 10:13:34.642	3	4	5	2	2017-08-30 16:02:36.663	2017-02-16 16:11:33.667	2018-01-23 12:19:59.145	\N	2018-01-23 13:38:10.575	\N	335	500.00	5	3	2	\N				\N	2018-01-23	\N
534	Fabiana	2017-02-24	\N	Pessoa	2017-02-24 15:15:38.994	4	3	4	4	2017-03-07 10:33:32.961	2017-02-24 15:15:54.116	2017-03-07 10:34:11.801	2017-04-25 17:51:32.383	2017-03-07 10:35:44.026	\N	343	250.00	11	3	2	1	Empresa MEI, enviamos proposta de adminstração mensal de folha.		Abriu MEI	2017-04-25	2017-04-25	\N
480	Carlos	2016-10-27	2017-02-09	Pessoa	2016-10-27 00:00:00	2	3	1	4	2017-03-20 17:20:35.806	\N	2017-02-02 12:14:32.246	\N	\N	\N	287	460.00	2	\N	3	\N	ex - cliente			2017-03-20	\N	\N
521	Dra. Luciana	2017-02-06	2017-02-13	Pessoa	2017-02-06 17:03:42.297	2	3	3	4	2017-02-08 10:38:57.654	2017-02-06 17:10:00.381	2017-03-09 17:11:18.486	\N	\N	\N	331	380.00	4	3	2	1	Serviços médicos.		Desistiu de abriri a empresa.	2017-03-09	\N	\N
447	Delmara Pereira da Silva	2016-09-29	2017-02-20	Pessoa	2016-09-29 00:00:00	2	3	4	2	2017-02-23 16:43:10.159	\N	2017-02-13 10:40:49.007	2017-03-27 16:23:15.665	\N	\N	262	520.00	5	3	2	\N	Consultório odontológico		Por falta de retorno.	2017-03-27	\N	\N
539	Diego	2017-03-06	2017-03-20	Pessoa	2017-03-06 10:33:32.474	3	3	1	4	2017-03-09 18:03:50.212	\N	\N	\N	\N	\N	350	380.00	11	3	2	7				2017-03-09	\N	\N
519	José Roberto Pini	2017-02-03	2017-02-10	Pessoa	2017-02-03 10:55:05.599	2	3	1	4	2017-03-09 18:01:00.325	2017-02-06 09:15:25.863	2017-02-08 11:25:05.717	\N	\N	\N	328	937.00	5	3	2	\N	A sociedade tem por objeto social a fabricação e comércio de vestuário.		Desculpe, mudei planos.\nObrigado por sua atenção, por enquanto.\n	2017-03-09	\N	\N
536	Nilton	2017-03-01	2017-09-29	Pessoa	2017-03-01 11:17:40.201	3	3	4	2	2017-08-30 15:46:06.684	\N	2017-08-30 15:45:55.601	2018-01-23 12:21:22.442	\N	\N	342	550.00	11	3	2	\N	COMÉRCIO VAREJISTA DE MERCADORIAS EM GERAL, COM PREDOMINÂNCIA DE PRODUTOS ALIMENTÍCIOS - MINIMERCADOS, MERCEARIAS E ARMAZÉNS.			\N	2018-01-23	\N
538	Edilene Gonçalves	2017-03-06	2017-03-20	Pessoa	2017-03-06 10:31:42.768	3	3	2	4	2017-03-06 10:31:42.768	2017-04-04 15:49:51.44	\N	\N	\N	\N	352	250.00	11	3	2	\N	Folha de Pagamento		 DECLINADO por falta de retorno.	2017-04-04	\N	\N
344	Elvira Maria Chagas de Carvalho	2016-11-23	2017-04-28	Empresa	2016-11-23 00:00:00	2	3	4	2	2017-07-26 15:09:32.723	\N	2017-04-24 11:50:29.562	2017-07-26 15:09:34.275	\N	142	\N	0.00	3	4	2	\N	Ficha Nº 80.   Core Fast.			\N	2017-07-26	\N
540	Willyman	2017-03-06	2017-03-20	Pessoa	2017-03-06 10:36:16.825	3	3	4	2	2017-07-25 09:12:25.18	2017-03-09 15:02:04.326	\N	2017-07-25 09:12:28.587	\N	\N	351	704.00	11	3	2	9				\N	2017-07-25	\N
527	Felippe Pereira	2017-02-15	2017-08-11	Pessoa	2017-02-15 16:03:30.708	3	3	4	2	2017-07-25 09:57:19.895	2017-07-25 09:46:02.178	2017-07-25 09:56:43.437	2017-07-25 10:19:46.721	\N	\N	336	450.00	5	3	2	\N			Não existe mais interesse.\nCaso mude de planos novamente, entre em contato.	2017-02-17	2017-07-25	\N
532	Ligia	2017-02-20	2017-03-06	Pessoa	2017-02-20 15:05:33.302	2	3	4	3	2017-03-07 10:44:27.763	2017-02-20 15:11:26.666	\N	2017-03-07 10:45:04.227	\N	\N	340	520.00	11	3	2	7	Faturamento R$ 9.000,00/mês\nConsultoria e programação em TI.		Cliente contratado como CLT, desistiu de abrir empresa.	2017-03-07	\N	\N
517	Mayara Gonçalvez	2017-01-31	2017-02-15	Pessoa	2017-01-31 15:42:51.146	2	3	1	4	2017-03-09 17:30:17.068	2017-02-08 11:32:55.858	2017-02-08 11:32:59.24	\N	\N	\N	326	460.00	5	3	2	1	Buffet e organização de eventos.		Vai adiar abriri agora	2017-03-09	\N	\N
510	Claudio Maia Sinibaldi	2016-12-04	2017-01-30	Pessoa	2017-01-23 14:59:35.843	2	3	2	4	2017-01-23 14:59:35.859	2017-03-09 17:47:13.844	\N	\N	\N	\N	316	550.00	5	3	2	7	Prestação de serviços em suporte técnico, manutenção e outros serviços em tecnologia da informação.		A empresa que ele vai trabalhar contratou como CLT	2017-03-09	\N	\N
499	James Magliaro	2016-11-24	2017-02-10	Pessoa	2016-11-24 00:00:00	2	3	1	4	2017-03-20 16:57:55.55	\N	2017-01-31 10:28:21.94	\N	\N	\N	300	380.00	5	\N	2	\N			Fcehou com outra contabilidade.	2017-03-20	\N	\N
242	José Luiz Senoi	2015-10-29	2015-10-29	Pessoa	2015-10-29 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:02:00.932	\N	\N	136	788.00	5	\N	2	\N	Cliente Já Possui empresa conosco Id 371			2017-03-20	\N	\N
243	Dra. Marinês	2015-11-04	2015-11-04	Pessoa	2015-11-04 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:02:10.149	\N	\N	135	469.00	7	\N	2	\N	Honorários - R$ 469,00			2017-03-20	\N	\N
244	Marcos Fernandes e Junior	2015-11-04	2015-11-04	Pessoa	2015-11-04 00:00:00	5	3	4	2	\N	\N	\N	2017-03-20 14:02:21.589	\N	\N	137	900.00	2	\N	2	\N	Indicação do Dr. Christiano. Gera credito. Temos que descobrir quem é este cliente.			2017-03-20	\N	\N
503	Andre Schaumburg	2016-12-14	2017-02-10	Pessoa	2016-12-14 00:00:00	2	3	4	2	2017-04-27 15:56:08.789	\N	\N	2017-06-07 10:47:35.48	\N	\N	305	700.00	5	3	2	\N			Abriu empresa com contador indicado por seus sócios.	2017-06-07	2017-06-07	\N
543	Ana Julia	2017-03-15	\N	Pessoa	2017-03-15 16:18:58.116	3	3	1	4	2017-04-04 15:47:53.317	2017-03-28 15:05:55.405	\N	\N	\N	\N	356	937.00	11	3	2	\N			 DECLINADO por falta de retorno.	2017-04-04	\N	\N
245	Michelle Letran dos Santos	2015-11-04	2015-11-04	Empresa	2015-11-04 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:02:42.031	\N	108	\N	380.00	2	\N	2	\N				2017-03-20	\N	\N
542	Gabriela	2017-03-10	2017-05-10	Pessoa	2017-03-10 17:34:38.816	4	3	1	4	2017-04-04 15:48:42.245	2017-03-17 16:54:19.442	\N	\N	\N	\N	355	704.00	11	3	2	7	Restaurante		 DECLINADO por falta de retorno.	2017-04-04	\N	\N
496	Ana Paula	2016-11-21	2017-02-07	Pessoa	2016-11-21 00:00:00	2	3	4	2	2017-03-17 18:18:45.241	\N	2017-02-06 09:28:33.394	2017-04-11 14:45:17.242	\N	\N	297	395.31	5	3	2	\N			Nunca retorna o e-mail. 	2017-04-11	\N	\N
201	SERGIO NARIMATSU	2015-07-15	2015-07-15	Pessoa	2015-07-15 00:00:00	6	3	4	2	\N	\N	\N	2017-03-20 13:57:11.928	\N	\N	105	458.97	2	\N	2	\N				2017-03-20	\N	\N
214	Fabio Vieira	2015-08-19	2015-08-19	Pessoa	2015-08-19 00:00:00	6	3	4	2	\N	\N	\N	2017-03-20 13:57:49.165	\N	\N	114	788.00	2	\N	2	\N	Cliente ja obtem 3 empresas conosco - KM KIDS / FC VIEIRA / FC KIDS.			2017-03-20	\N	\N
220	SERGIO NARIMATSU	2015-08-27	2015-08-27	Pessoa	2015-08-27 00:00:00	6	3	4	2	\N	\N	\N	2017-03-20 13:57:59.886	\N	\N	119	464.00	2	\N	2	\N	Ja tem uma empresa conosco 95			2017-03-20	\N	\N
223	Gustavo	2015-09-30	2015-09-30	Empresa	2015-09-30 00:00:00	6	3	4	2	\N	\N	\N	2017-03-20 13:58:16.543	\N	104	\N	464.00	4	\N	2	\N	Amigo do Dr. Ricardo. (visinho);			2017-03-20	\N	\N
229	RICARDO	2015-10-06	2015-10-06	Pessoa	2015-10-06 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 13:59:12.863	\N	\N	125	350.00	5	\N	2	\N				2017-03-20	\N	\N
230	OTAVIO SIMÕES	2015-10-06	2015-10-06	Pessoa	2015-10-06 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 13:59:22.264	\N	\N	126	320.00	2	\N	2	\N	Indicação da empressa: 229 (Paulo) gerar credito por indicação.			2017-03-20	\N	\N
231	Rodrigo Cestari	2015-10-07	2015-10-07	Empresa	2015-10-07 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 13:59:35.808	\N	106	\N	1576.00	2	\N	2	\N	Indicação de Cliente. Nao soube informar o nome.			2017-03-20	\N	\N
232	Tatiana	2015-10-07	2015-10-07	Empresa	2015-10-07 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 13:59:47.409	\N	107	\N	469.00	5	\N	2	\N				2017-03-20	\N	\N
233	Maria Victória	2015-10-09	2015-10-09	Pessoa	2015-10-09 00:00:00	4	3	4	2	\N	\N	\N	2017-03-20 14:00:26.683	\N	\N	127	551.00	2	\N	2	\N	Prosposta enviada pela Monary			2017-03-20	\N	\N
234	ANDRE CRUZ	2015-10-14	2015-10-14	Pessoa	2015-10-14 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:00:34.618	\N	\N	128	464.00	5	\N	2	\N				2017-03-20	\N	\N
235	Sr. Marcelo	2015-10-19	2015-10-19	Pessoa	2015-10-19 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:00:44.31	\N	\N	129	850.00	2	\N	2	\N	Indicação da Quinto Fator. Gera Credito.			2017-03-20	\N	\N
236	IVO	2015-10-20	2015-10-20	Pessoa	2015-10-20 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:00:51.573	\N	\N	130	0.00	7	\N	2	\N	A Prolink ira só abrir a empresa, o cliente ia realizaar a contabilidade			2017-03-20	\N	\N
237	Margarete	2015-10-20	2015-10-20	Pessoa	2015-10-20 00:00:00	4	3	4	2	\N	\N	\N	2017-03-20 14:01:17.492	\N	\N	131	591.00	5	\N	2	\N	Proposta enviada pela Monary			2017-03-20	\N	\N
238	Tatiana	2015-10-20	2015-10-20	Pessoa	2015-10-20 00:00:00	4	3	4	2	\N	\N	\N	2017-03-20 14:01:25.972	\N	\N	132	591.00	5	\N	2	\N	Proposta enviada pela Monary			2017-03-20	\N	\N
239	BELMIRO LUIZ MOREIRA	2015-10-23	2015-10-23	Pessoa	2015-10-23 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:01:33.276	\N	\N	133	315.00	2	\N	2	\N	CLIENTE INDICADO PELA EMPRESA MÓRIA			2017-03-20	\N	\N
246	Jonathan  Joao	2015-11-04	2015-11-04	Pessoa	2015-11-04 00:00:00	4	3	4	2	\N	\N	\N	2017-03-20 14:02:51.04	\N	\N	138	650.00	2	\N	2	\N	Proposta enviada pela Monary a pedido do Telmon.			2017-03-20	\N	\N
248	Marco Antonio T. Pedro	2015-11-12	2015-11-12	Pessoa	2015-11-12 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:03:14.336	\N	\N	139	238.00	5	\N	2	\N	Proposta Enviada Pelo Victor			2017-03-20	\N	\N
249	Maria Helena  Dos Santos	2015-11-12	2015-11-12	Empresa	2015-11-12 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:03:20.648	\N	110	\N	788.00	7	\N	2	\N	Contato vindo  do seminário Prolink 2015. MADIA E ASSOCIADOS LTDA.			2017-03-20	\N	\N
250	Maria Helena dos Santos	2015-11-12	2015-11-12	Empresa	2015-11-12 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:03:27.231	\N	111	\N	421.00	7	\N	2	\N	Contato do Seminário 2015 - MADIA  MARKETING SCHOOL TREINAMENTO EM MARKETING LTDA.			2017-03-20	\N	\N
252	Fábio - AOJESP	2015-11-25	2015-11-25	Empresa	2015-11-25 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:03:33.935	\N	112	\N	0.00	5	\N	2	\N				2017-03-20	\N	\N
253	Bianca Anjos	2015-11-25	2015-11-25	Pessoa	2015-11-25 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:04:29.426	\N	\N	141	238.00	5	\N	2	\N	Proposta de empresa na area de acessoria de segurança do trabalho			2017-03-20	\N	\N
254	Micele Durci	2015-11-25	2015-11-25	Pessoa	2015-11-25 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:04:36.947	\N	\N	142	238.00	5	\N	2	\N	Abertura de clinica veterinaria.			2017-03-20	\N	\N
498	Leandro Santana	2016-11-24	2017-02-03	Pessoa	2016-11-24 00:00:00	2	3	4	2	2017-04-06 18:32:05.572	\N	2017-01-31 10:44:21.5	2017-04-10 14:55:13.495	\N	\N	298	488.00	5	\N	2	\N			Abriu empresa com um contador amigo.	2017-04-10	\N	\N
544	Dra. Josiane	2017-03-15	\N	Empresa	2017-03-15 16:27:15.848	4	2	1	4	2017-04-04 15:44:25.492	2017-03-16 11:19:20.916	\N	\N	\N	204	\N	937.00	9	4	2	3	Empresa Medica			\N	\N	\N
545	Ediones	2017-03-16	2017-08-11	Pessoa	2017-03-16 11:47:55.249	4	3	4	2	2017-07-25 09:11:23.991	2017-03-16 12:26:45.133	2017-07-25 09:11:27.088	2017-08-30 15:41:35.742	\N	\N	358	750.00	11	3	2	7	Comércio de bebidas		Nunca dá retorno e celular sempre cai na caixa postal.	2017-08-30	2017-08-30	\N
255	Diogo Apacerido	2015-11-25	2015-11-25	Pessoa	2015-11-25 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:04:42.643	\N	\N	143	238.00	5	\N	2	\N	Abertura de empresa no ramo de lanchonete			2017-03-20	\N	\N
257	Carlos Eduardo Joos	2015-11-30	2015-11-30	Empresa	2015-11-30 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:05:15.804	\N	113	\N	0.00	2	\N	2	\N	Indicado pela Bianchi			2017-03-20	\N	\N
259	Fernando Pacheco	2015-12-02	2015-12-02	Pessoa	2015-12-02 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:05:35.644	\N	\N	146	238.00	5	\N	2	\N				2017-03-20	\N	\N
261	Luiz Carlos Perandi	2015-12-07	2015-12-07	Empresa	2015-12-07 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:06:24.381	\N	114	\N	0.00	5	\N	2	\N	Implantação de Matriz e Filial			2017-03-20	\N	\N
263	Renato Oliveira	2015-12-10	2015-12-10	Pessoa	2015-12-10 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:06:41.966	\N	\N	149	238.00	5	\N	2	\N	Contato do Site. (Victor)			2017-03-20	\N	\N
265	Alessandra Spigariol	2015-12-16	2015-12-16	Pessoa	2015-12-16 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:06:57.479	\N	\N	151	551.00	5	\N	2	\N	Empresa estava declinada e solicitou um nova proposta.			2017-03-20	\N	\N
267	Fernando Lauria (Sequenza Tecnologia	2015-12-23	2015-12-23	Empresa	2015-12-23 00:00:00	5	3	4	2	\N	\N	\N	2017-03-20 14:07:16.615	\N	116	\N	1970.00	2	\N	2	\N	Empresa indicada pelo Dr. Ricardo. Atividade de informática, 20 Nf por mês, sem funcionários e 370k de faturamento mensal. Lucro Presumido			2017-03-20	\N	\N
284	Ferdinando (Fergus)	2016-02-02	2016-02-02	Empresa	2016-02-02 00:00:00	4	3	4	2	\N	\N	\N	2017-03-20 14:12:04.176	\N	119	\N	0.00	2	\N	2	\N	Implantação.		Falta de retorno.	2017-03-20	\N	\N
315	Luiz Cláudio	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:31:11.763	\N	\N	192	0.00	3	\N	2	\N	Ficha Nº 75.		Seu projeto está em stand by.	2017-03-20	\N	\N
321	Marcelo Erivelton	2016-02-26	2017-03-24	Pessoa	2016-02-26 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:42:50.426	\N	\N	197	0.00	3	3	2	\N	Ficha Nº 59.		Telefone não existe e nunca retorna os e-mails.	2017-03-20	\N	\N
340	Rafael Navarro	2016-11-09	2016-11-09	Empresa	2016-11-09 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:57:39.779	\N	128	\N	0.00	3	\N	2	\N	Ficha Nº 79.   Manutec - Montagem e manutenção de equipamentos industriais.		Telefones não existem mais e Rafael não responde os e-mails.	2017-03-20	\N	\N
310	Itamar Nascimento	2016-02-26	2017-04-21	Pessoa	2016-02-26 00:00:00	3	3	4	2	\N	\N	2017-04-11 14:58:57.16	2017-05-31 10:39:54.328	\N	\N	187	0.00	3	3	2	\N	Ficha Nº 36		Sr. Itamar não irá mais abrir empresa.	2017-05-31	2017-05-31	\N
256	Sergio Stefano	2015-11-26	2015-11-26	Pessoa	2015-11-26 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:04:49.314	\N	\N	144	238.00	5	\N	2	\N	Empresa Individual de Design Grafico			2017-03-20	\N	\N
258	Maria das Graças (Mel e Hortelã)	2015-12-02	2015-12-02	Pessoa	2015-12-02 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:05:26.82	\N	\N	145	238.00	2	\N	2	\N	Indicação			2017-03-20	\N	\N
260	Joel Roberto	2015-12-03	2015-12-03	Pessoa	2015-12-03 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:05:41.756	\N	\N	148	238.00	5	\N	2	\N				2017-03-20	\N	\N
262	Jonatan	2015-12-10	2015-12-10	Pessoa	2015-12-10 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:06:33.56	\N	\N	147	238.00	5	\N	2	\N	Contato Do Site			2017-03-20	\N	\N
264	Fernando Machado (Baby Bello)	2015-12-14	2015-12-14	Pessoa	2015-12-14 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:06:47.784	\N	\N	150	238.00	5	\N	2	\N				2017-03-20	\N	\N
266	Marcelo Gonçalves Araujo	2015-12-22	2015-12-22	Empresa	2015-12-22 00:00:00	5	3	4	2	\N	\N	\N	2017-03-20 14:07:09.694	\N	115	\N	466.00	2	\N	2	\N	Abertura de Empresa. Indicado pelo Eloy (Parxtech). Não gera credito.			2017-03-20	\N	\N
268	Luis (Indicação Cubo)	2015-12-28	2015-12-28	Pessoa	2015-12-28 00:00:00	3	3	4	2	\N	\N	\N	2017-03-20 14:07:25.992	\N	\N	152	138.00	2	\N	2	\N				2017-03-20	\N	\N
307	Luis Augusto	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:15:38.647	\N	\N	184	0.00	3	\N	2	\N			Ainda não irá abrir empresa. Disse que entra em contato quando precisar.	2017-03-20	\N	\N
569	Paulo Tridente (Triale)	2017-05-23	\N	Empresa	2017-05-23 11:46:16.051	3	2	4	3	2017-05-23 11:46:16.053	2017-05-23 11:46:29.759	\N	2017-07-21 16:10:37.111	\N	212	\N	750.00	2	4	2	3				\N	2017-07-21	\N
320	Lucas Denifry da Silva	2016-02-26	2016-02-26	Pessoa	2016-02-26 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 14:34:17.312	\N	\N	196	0.00	3	\N	2	\N	Ficha Nº 42.		DECLINADO. Devido a crise, desistiu de abrir empresa.	2017-03-20	\N	\N
557	Julio Cesar	2017-04-18	2017-05-03	Pessoa	2017-04-18 10:41:38.269	2	3	2	4	2017-04-18 10:41:38.273	2017-04-25 15:43:42.256	\N	\N	\N	\N	374	380.00	11	3	2	1			Fcehou com outra contabilidade.	2017-04-25	2017-04-25	\N
341	Gerson Gomez	2016-02-29	2016-02-29	Empresa	2016-02-29 00:00:00	2	3	4	2	\N	\N	\N	2017-03-20 15:00:05.976	\N	135	\N	591.00	3	\N	2	\N	Ficha Nº 88.    AAA Brasil Consultoria Patrimonial.		Regina (esposa) disse que talvez mais pra frente irá repensar a mudança de contador.	2017-03-20	\N	\N
419	Mauro Mancio	2016-09-16	2016-09-16	Empresa	2016-09-16 00:00:00	2	3	4	2	2017-02-23 17:02:01.415	\N	\N	2017-03-20 15:47:39.568	\N	171	\N	469.00	5	\N	2	\N	Implantação.		Já mudaram de contador.	2017-03-20	\N	\N
424	Magda (ADAMOS)	2016-06-14	2017-02-20	Empresa	2016-06-14 00:00:00	3	3	4	2	2017-02-23 16:55:34.238	\N	2017-02-13 11:42:16.668	2017-03-20 15:50:32.104	\N	174	\N	880.00	5	\N	2	\N			Não vai mais mudar de contador. 	2017-03-20	\N	\N
360	Osvaldo Tadashi Higa	2016-11-24	2016-11-24	Empresa	2016-11-24 00:00:00	5	3	4	2	\N	\N	\N	2017-02-14 17:44:16.362	\N	152	\N	380.00	3	\N	2	\N	Ficha Nº 54.   CNPJ: 05.243.955/0001-93		DECLINADO, por falta de retorno.	2017-02-14	\N	\N
567	Cleiton	2017-05-16	2018-01-31	Pessoa	2017-05-16 14:14:47.927	2	4	5	2	2017-08-28 11:14:10.696	2017-05-16 14:19:56.449	2018-01-19 13:52:52.608	\N	2018-02-27 10:56:10.219	\N	383	2025.00	11	3	2	\N	Prestação de serviços de portaria.			\N	2018-02-27	\N
559	Omar Toral	2017-05-03	2017-06-30	Pessoa	2017-05-03 17:41:29.99	3	4	5	2	2017-05-03 17:41:29.992	2017-05-03 17:42:02.731	2017-06-05 17:41:57.401	\N	2017-06-06 09:46:35.042	\N	376	500.00	11	3	2	7	Atividade de Salão de Beleza e Estetica			\N	2017-06-06	\N
547	Rodrigo Zanelato	2017-03-28	2017-08-18	Pessoa	2017-03-28 11:41:18.731	4	3	4	2	2017-07-24 15:58:43.491	\N	2017-07-24 15:58:46.775	2017-08-30 15:38:45.714	\N	\N	365	812.50	11	3	2	3			Nunca retorna.	2017-08-30	2017-08-30	\N
553	José Weliton	2017-04-11	\N	Pessoa	2017-04-11 09:44:12.268	2	3	4	2	2017-07-24 10:46:58.887	2017-04-11 09:44:38.305	\N	2017-07-24 10:46:59.853	\N	\N	371	570.00	11	3	2	8				\N	2017-07-24	\N
479	Oscar Kawati	2016-10-27	2017-02-09	Pessoa	2016-10-27 00:00:00	4	3	4	2	2017-02-02 12:15:34.323	\N	2017-02-02 12:14:27.636	2017-03-29 17:43:50.281	\N	\N	284	850.00	5	3	2	\N	Clinica médica		Não vai mais abrir empresa.	2017-03-29	\N	\N
548	Leila	2017-03-28	\N	Pessoa	2017-03-28 11:55:33.78	4	3	4	2	2017-07-24 15:54:41.092	\N	\N	2017-07-24 15:54:42.791	\N	\N	366	1015.10	11	3	2	4				\N	2017-07-24	\N
565	Arnaldo Amaral	2017-05-16	2017-08-11	Pessoa	2017-05-16 11:24:06.018	3	3	4	2	2017-07-24 10:12:11.71	2017-05-16 14:11:26.58	2017-07-24 10:00:03.079	2017-08-28 11:15:02.143	\N	\N	322	412.00	5	3	2	1			Já abriu empresa.	2017-07-24	2017-08-28	\N
551	CARLOS HENRIQUE COIMBRA JACON	2017-04-10	2017-08-30	Pessoa	2017-04-10 14:49:06.069	4	3	4	2	2017-07-24 15:08:42.728	2017-04-10 14:57:37.616	2017-07-24 15:08:28.495	2017-08-30 15:37:30.362	\N	\N	370	479.85	2	3	7	7			Não respondeu nem o e-mail com ultimato. Telefone incorreto.	2017-08-30	2017-08-30	\N
311	Valdir Henrique da Cunha	2016-02-26	2017-10-31	Pessoa	2016-02-26 00:00:00	2	3	4	2	2017-11-28 13:48:16.136	2017-10-23 10:26:08.969	2017-03-20 14:29:34.536	2017-11-28 14:02:55.75	\N	\N	188	892.00	3	3	2	8	Ficha Nº 56. Restaurante.		Não sabe se vai abrir. Enviei e-mail oom nosso contato.	2017-04-11	2017-11-28	\N
568	Paulo Triale (Nomina)	2017-05-23	\N	Empresa	2017-05-23 11:45:39.795	3	2	4	3	\N	2017-05-23 11:45:39.798	\N	2017-07-21 16:12:05.215	\N	212	\N	750.00	2	4	2	3				\N	2017-07-21	\N
550	Andrea Tonus	2017-03-28	2017-05-28	Empresa	2017-03-28 12:04:32.054	4	3	1	4	2017-06-27 15:20:50.165	2017-03-28 12:16:20.744	\N	\N	\N	208	\N	937.00	5	4	2	5			O Telmon foi até eles apresentou a proposta, eles gostaram muito, porem fechou com outra empresa devido o valor ofertado.	2017-06-27	2017-06-27	\N
552	Humberto	2017-04-10	2018-02-28	Pessoa	2017-04-10 14:57:04.191	4	1	3	2	2017-08-30 15:12:15.995	2017-04-10 14:57:31.183	2018-01-23 12:23:17.676	\N	\N	\N	372	567.00	10	3	2	7	Serviços de Treinamento e cursos livres.			\N	\N	\N
339	Edilson Fernandes	2016-02-29	2017-05-08	Empresa	2016-02-29 00:00:00	2	3	4	2	2017-07-26 15:11:22.354	\N	2017-04-24 11:13:04.728	2017-07-26 15:11:23.842	\N	127	\N	880.00	3	4	2	\N	Ficha Nº 78.			\N	2017-07-26	\N
560	Dr. Marcelo Nishiyama	2017-05-05	2017-05-19	Pessoa	2017-05-05 08:43:03.897	3	2	4	3	\N	2017-05-05 08:43:03.9	\N	2017-05-09 10:02:29.451	\N	\N	377	700.00	2	3	2	3	Abertura de Empresa (Indicado pela Dra. Elisa Haas (2236)			\N	2017-05-09	\N
452	Emerson de Souza Pereira Medina	2016-09-16	2017-06-30	Pessoa	2016-09-16 00:00:00	2	3	4	2	2017-07-26 14:58:15.799	\N	2017-06-06 12:03:21.131	2017-07-26 14:58:17.031	\N	\N	265	541.66	3	3	2	\N				\N	2017-07-26	\N
561	Danielle	2017-05-09	\N	Pessoa	2017-05-09 11:21:29.528	4	3	1	4	2017-05-09 11:22:38.413	\N	\N	\N	\N	\N	379	850.00	2	3	2	1			Vai abrir um MEI	2017-05-09	2017-05-09	\N
546	Ana Cristina	2017-03-28	2017-05-28	Pessoa	2017-03-28 11:27:40.832	4	3	1	4	2017-04-25 17:17:17.501	2017-03-28 11:31:34.982	\N	\N	\N	\N	364	650.00	2	3	2	9	Indicação do Cliente 2117		 DECLINADO por falta de retorno.	2017-04-04	2017-04-25	\N
566	Fábio Takeshi	2017-05-16	\N	Pessoa	2017-05-16 12:07:32.651	3	2	4	2	\N	2017-05-16 12:07:32.652	\N	2017-07-24 09:53:01.426	\N	\N	382	600.00	2	3	2	9	Indicação da  ID - 0510			\N	2017-07-24	\N
558	Liliane	2017-04-18	2017-05-03	Pessoa	2017-04-18 11:46:44.433	2	3	1	4	2017-05-17 12:10:52.325	2017-04-20 16:36:50.776	\N	\N	\N	\N	375	750.00	11	3	2	3				2017-05-17	2017-05-17	\N
322	Eduardo Levado	2016-02-26	2017-04-18	Pessoa	2016-02-26 00:00:00	2	3	4	2	2017-03-20 16:13:37.082	\N	2017-04-11 15:23:40.286	2017-05-31 10:50:12.929	\N	\N	198	0.00	3	3	2	\N	Ficha Nº 45.		Nunca retorna os contatos.	2017-05-31	2017-05-31	\N
549	Andrea Tonus 	2017-03-28	2017-04-28	Empresa	2017-03-28 12:02:08.024	4	3	4	2	2017-07-24 15:10:18.132	2017-03-28 12:16:27.819	\N	2017-07-24 15:10:37.815	\N	207	\N	6200.00	5	4	2	6	1 Matriz e 3 filiais		O Telmon foi até eles apresentou a proposta, eles gostaram muito, porem fechou com outra empresa devido o valor ofertado.	2017-07-24	2017-07-24	\N
554	Michel Moura	2017-04-11	2017-08-18	Empresa	2017-04-11 14:49:46.013	3	1	3	2	2017-07-24 10:39:02.848	\N	2017-07-24 10:39:09.972	\N	\N	209	\N	1300.00	7	4	2	3	Implantação			\N	\N	\N
564	Danilo Capelli	2017-05-12	2017-05-31	Pessoa	2017-05-12 10:41:26.21	2	2	4	2	\N	2017-05-16 08:45:40.397	2017-05-16 10:30:12.56	2017-05-26 10:44:39.148	\N	\N	173	400.00	2	3	2	1	Gerente Contas, Gerente de Produto de segurança eletrônica. | 1 NFS'e/mês no valor de R$ 6.500,00 | Sem func. | Indicação cliente MEXA SEGURANÇA ELETRONICA ?			\N	2017-05-26	\N
592	Letícia	2017-07-14	2017-10-31	Pessoa	2017-07-14 13:58:21.95	2	3	4	2	2017-08-11 11:02:13.386	2017-07-14 13:58:56.377	2017-10-23 16:04:03.818	2018-01-17 15:01:26.596	\N	\N	400	998.00	11	3	2	3	Desmanche de motos.		DECLINADO. Por falta de retorno.	2018-01-17	2018-01-17	\N
429	Yuri	2016-09-16	2017-06-30	Empresa	2016-09-16 00:00:00	2	3	4	2	2017-02-23 16:51:00.181	\N	2017-06-06 10:32:03.633	2017-06-06 11:07:40.681	\N	175	\N	953.00	5	4	2	\N			DECLINADO. Nunca retorna telefonemas nem e-mail.	2017-06-06	2017-06-06	\N
587	Mafalda Botelho - TOMI WORLD	2017-07-10	2018-02-28	Empresa	2017-07-10 15:48:31.562	2	3	4	2	2017-08-24 10:22:37.461	\N	2017-10-23 16:47:33.583	2018-01-17 15:15:20.788	2018-01-17 15:14:25.086	216	\N	2500.00	\N	4	2	\N				\N	2018-01-17	\N
590	Regiane Silva	2017-07-12	2017-07-28	Pessoa	2017-07-12 11:32:26.871	2	3	4	2	2017-08-11 11:12:39.393	2017-07-12 11:33:08.335	\N	2017-08-11 11:12:40.65	\N	\N	398	390.00	11	3	2	1				\N	2017-08-11	\N
589	Ricardo	2017-07-11	2017-08-31	Prospeccao	2017-07-11 15:08:55.956	2	2	4	2	2017-08-11 11:22:17.318	2017-08-11 11:26:02.221	2017-08-11 11:26:04.611	2017-08-17 10:44:19.646	\N	\N	\N	998.00	12	3	2	3	Franquia Ecoville			\N	2017-08-17	39
509	Alexsandro Soares da Silva	2016-12-28	2018-01-31	Pessoa	2017-01-12 09:20:15.82	4	1	3	2	2017-08-30 16:18:35.247	2017-01-23 14:52:22.258	2018-01-23 12:12:39.291	\N	\N	\N	315	380.00	5	3	2	1	Comércio de produtos em MDF.			\N	\N	\N
571	Pedro Miranda	2017-05-26	2018-01-31	Pessoa	2017-05-26 12:04:52.218	4	3	4	2	2017-08-24 11:14:06.233	\N	2018-01-19 11:18:24.001	2018-02-27 10:03:02.599	\N	\N	387	0.00	5	3	7	\N	Abertura de empresa		DECLINADO. Não retorna os contatos.	2018-02-27	2018-02-27	\N
576	Roney	2017-06-08	\N	Empresa	2017-06-08 16:31:46.016	3	3	4	2	2017-07-21 11:58:38.685	2017-06-08 16:31:46.016	\N	2017-07-21 11:58:40.472	\N	214	\N	500.00	2	4	2	7				\N	2017-07-21	\N
578	Mauricio	2017-06-19	\N	Pessoa	2017-06-19 14:20:19.86	3	3	4	2	2017-07-21 14:53:24.315	2017-07-21 14:52:48.241	\N	2017-07-21 14:53:28.559	\N	\N	392	1350.00	11	3	2	\N				\N	2017-07-21	\N
570	Decio Bebiano	2017-05-23	2017-08-11	Pessoa	2017-05-23 17:07:36.515	2	3	4	2	2017-08-24 14:18:47.252	2017-05-23 17:07:56.519	2017-07-21 15:43:31.942	2018-01-19 13:50:34.022	\N	\N	384	1015.00	11	3	2	\N	Consultoria em informática, EIRELI, Faturamento R$ 40.000,00/mês, sem funcionários CLT, 30 NF fixas + 10a15 variáveis, quando houver.		DECLIANDO. Por falta de retorno.	2018-01-19	2018-01-19	\N
572	PRISCILA NAGOSHI UENO	2017-06-02	\N	Pessoa	2017-06-02 10:00:05.249	4	2	4	3	2017-06-02 10:00:58.663	\N	\N	2017-06-20 13:56:23.923	\N	\N	389	750.00	2	\N	7	\N				\N	2017-06-20	\N
579	Marilia Mendes	2017-06-22	2017-10-31	Pessoa	2017-06-22 10:57:17.102	3	3	4	2	2017-08-24 10:57:48.011	2017-06-22 10:57:57.349	2017-10-24 11:36:24.979	2018-01-19 15:50:04.372	\N	\N	393	750.00	7	3	2	9	Abertura de empresa serviços médicos.			\N	2018-01-19	\N
588	Felipe Ferreira	2017-07-10	2017-08-31	Prospeccao	2017-07-10 16:54:07.499	2	3	4	2	2017-08-24 10:22:04.638	2017-07-10 16:55:17.515	2017-08-11 11:31:24.473	2017-10-23 16:40:33.584	\N	\N	\N	350.00	12	4	2	\N	- Design\n- Está na Contabilizei		Nunca responde aos e-mails.	2017-10-23	2017-10-23	11
585	Kiki Faria	2017-06-28	2017-08-31	Pessoa	2017-06-28 16:33:11.688	3	3	4	2	2017-07-26 15:14:40.453	2017-06-28 16:33:11.694	2017-07-26 15:15:08.235	2017-08-17 11:11:50.454	\N	\N	396	380.00	7	3	2	1			No momento não vai mais abrir empresa pois o projeto desandou.	2017-08-17	2017-08-17	\N
580	Valdecir	2017-06-22	\N	Pessoa	2017-06-22 10:58:44.772	3	3	2	4	\N	2017-06-28 17:10:34.974	\N	\N	\N	\N	394	937.00	5	3	2	3			Fechou com outra contabilidade	2017-06-28	2017-06-28	\N
439	Bruno - VFUNG	2016-07-05	2017-09-29	Empresa	2016-07-05 00:00:00	4	4	5	2	2017-08-30 15:58:39.257	\N	2017-08-30 15:58:44.435	\N	2018-01-17 12:24:27.684	183	\N	0.00	2	\N	2	\N	Empresa: GRONA COMERCIO DE PRODUTOS			\N	2018-01-17	\N
500	Lucas Fernando Frazão	2016-11-29	2017-07-03	Pessoa	2016-11-29 00:00:00	2	3	4	2	2017-07-04 14:09:59.518	\N	2017-04-27 15:58:16.563	2017-07-04 14:10:21.71	2017-06-07 10:41:52.447	\N	299	550.00	5	\N	2	\N			Não vai mais abrir empresa.	2017-04-27	2017-07-04	\N
584	Igor Fernando Silva	2017-06-27	2018-03-30	Prospeccao	2017-06-27 14:29:56.263	4	1	3	2	2017-10-30 14:36:11.862	\N	2018-02-27 09:54:05.502	\N	\N	\N	\N	450.00	12	3	2	7	“ Comércio varejista de pescados”			\N	\N	4
438	Bruno - VFUNG	2016-08-25	2017-09-29	Empresa	2016-08-25 00:00:00	4	4	5	2	2017-08-30 15:58:33.063	\N	2017-08-30 15:58:53.139	\N	2018-01-17 12:24:34.395	181	\N	800.00	2	4	2	\N	Cliente; Empresa VFUNG			\N	2018-01-17	\N
562	Daniella Aduan	2017-05-09	2018-01-31	Pessoa	2017-05-09 16:21:05.897	3	3	4	2	2017-08-29 14:38:53.054	2017-05-10 08:15:44.019	2018-01-17 12:24:01.763	2018-01-19 08:06:44.268	\N	\N	378	380.00	4	4	2	7	Casting para evento. Indicação Isabelle.			2017-10-20	2018-01-19	\N
581	Rafael (Poncio)	2017-06-26	2017-08-31	Pessoa	2017-06-26 10:37:36.393	3	2	4	4	2017-08-17 11:42:01.684	2017-06-26 10:37:36.396	2017-08-21 10:47:43.887	2017-08-24 10:42:34.049	\N	\N	395	750.00	5	3	2	3				\N	2017-08-24	\N
591	Andrea Briotto	2017-07-12	2018-01-31	Pessoa	2017-07-12 11:38:25.5	2	3	4	2	2017-08-11 11:10:08.741	2017-07-12 11:39:51.913	2018-01-17 15:09:37.789	2018-02-27 10:39:56.264	\N	\N	399	450.00	11	3	2	1	Produtora de eventos.		DECLINADO: Andrea respondeu e-mail ultimato informando que já abriu a empresa.	2018-02-27	2018-02-27	\N
528	AN2 PRODUTOS NATURAIS LTDA	2017-02-17	2017-09-29	Empresa	2017-02-17 16:05:38.052	3	4	5	2	2017-08-30 15:58:59.728	\N	2017-08-30 15:59:05.331	\N	2018-01-17 12:24:50.867	181	\N	937.00	2	4	2	\N	AN2 PRODUTOS NATURAIS LTDA\nTELEFONE 2: 99390-9920			\N	2018-01-17	\N
575	Marcio	2017-06-08	2018-01-31	Empresa	2017-06-08 16:30:55.837	3	1	3	2	2017-08-24 11:08:51.3	2017-07-26 14:51:38.897	2018-01-19 11:00:49.147	\N	\N	213	\N	5740.00	7	4	2	6				\N	\N	\N
577	Celso	2017-06-13	2017-08-31	Pessoa	2017-06-13 18:00:09.991	2	3	4	2	2017-08-24 10:59:17.866	2017-06-13 18:00:25.309	2017-08-24 10:59:22.052	2017-10-24 14:30:03.114	\N	\N	390	1029.00	11	3	2	\N	Possui 4 caminhões.			\N	2017-10-24	\N
574	Alan Duarte	2017-06-02	2017-08-11	Pessoa	2017-06-02 14:21:19.846	3	2	4	2	2017-07-21 14:22:06.339	2017-06-02 14:21:19.85	2017-07-21 14:22:21.019	2017-08-01 14:52:06.81	\N	\N	386	937.00	11	3	2	3				\N	2017-08-01	\N
556	EDSON (BROKER TECNOLOGIA)	2017-04-18	2017-08-11	Empresa	2017-04-18 08:30:34.284	3	2	4	3	2017-07-24 10:44:14.324	2017-12-04 09:09:09.927	2017-07-24 10:22:33.796	2017-12-12 14:29:53.111	\N	211	\N	500.00	2	4	2	8				\N	2017-12-12	\N
530	Marcello Caldeira	2017-02-17	2017-08-18	Pessoa	2017-02-17 16:15:25.511	2	3	4	2	2017-07-25 09:32:30.458	2017-02-17 16:16:12.718	2017-03-07 11:07:37.312	2017-07-25 09:36:50.122	\N	\N	310	380.00	5	3	2	1				\N	2017-07-25	\N
448	Wesley Kevin	2016-09-29	2017-08-25	Empresa	2016-09-29 00:00:00	2	3	4	2	2017-07-26 15:03:02.491	\N	2017-07-26 15:03:23.437	2018-01-23 11:49:19.298	\N	188	\N	355.00	5	4	2	\N	CNPJ: 23.298.377/0001-74\n(Coloquei na lista prospecs Locaweb)		DECLINADO. Nunca responde e-mails e mensagens. Telefones estão indisponíveis. Enviei e-mail de declínio.	2018-01-23	2018-01-23	\N
573	Liliane 	2017-06-02	2017-06-22	Pessoa	2017-06-02 14:20:17.16	3	2	4	2	2017-07-21 14:40:49.787	2017-06-02 14:20:17.162	\N	2017-07-21 14:43:14.523	\N	\N	388	200.00	5	3	2	1				\N	2017-07-21	\N
555	Michel Moura	2017-04-11	2018-03-30	Empresa	2017-04-11 14:51:35.916	3	1	3	2	2017-08-30 15:02:48.791	\N	2018-02-27 11:15:15.209	\N	\N	210	\N	1600.00	7	4	2	3	Implantação			\N	\N	\N
583	Tiago Périco	2017-06-27	2017-08-31	Prospeccao	2017-06-27 11:00:01.598	4	3	4	2	2017-08-24 10:45:27.015	2017-06-28 16:48:23.01	2017-08-17 11:28:14.959	2017-10-24 10:02:36.746	\N	\N	\N	380.00	12	3	2	1	A sociedade tem por objeto social a prestação de serviços de Treinamento, promoção de vendas.\n- Comércio Varejista		Não retorna os e-mails e telefonemas.	2017-10-24	2017-10-24	7
582	Fabiano Bueno	2017-06-26	\N	Prospeccao	2017-06-26 17:26:47.194	4	4	1	1	2017-08-07 15:55:52.18	2017-06-26 17:28:27.814	\N	\N	2017-07-20 10:33:31.078	\N	\N	380.00	12	\N	\N	\N				\N	2017-08-07	31
443	Dra. Renata Souza	2016-09-16	2017-06-30	Pessoa	2016-09-16 00:00:00	2	3	4	2	2017-07-26 15:05:17.853	\N	2017-06-06 11:46:25.14	2017-07-26 15:05:18.775	\N	\N	261	433.33	5	\N	2	\N				\N	2017-07-26	\N
506	Alex Raider	2016-12-21	2017-04-25	Pessoa	2016-12-21 00:00:00	2	3	4	2	2017-07-25 10:47:53.539	\N	2017-04-11 14:48:41.423	2017-07-25 10:47:55.507	\N	\N	304	487.50	5	3	2	\N				\N	2017-07-25	\N
486	Leandro	2016-11-01	2017-08-18	Empresa	2016-11-01 00:00:00	2	3	4	2	2017-07-25 11:21:53.905	2017-07-25 11:21:42.713	2017-07-25 11:22:04.176	2018-01-23 11:52:28.9	\N	197	\N	1580.00	3	4	2	\N	SFCTOUR Serviços de viajem		DECLINADO. Não retorna e-mails nem telefonemas. Enviei e-mail de declínio.	2018-01-23	2018-01-23	\N
533	Iara Scheiner	2017-02-21	2017-08-11	Pessoa	2017-02-21 15:29:11.383	4	3	4	2	2017-07-25 10:55:51.758	2017-02-21 15:30:21.398	2017-07-25 09:27:55.979	2017-07-25 10:55:53.178	\N	\N	341	937.00	11	4	2	4				\N	2017-07-25	\N
594	Janiele da Silva	2017-07-26	2017-08-31	Pessoa	2017-07-26 15:23:26.361	2	4	4	2	2017-08-11 10:52:12.032	2017-07-26 15:23:53.459	\N	\N	2017-08-11 10:52:29.162	\N	401	568.00	11	3	2	7	Loja de langerie.			\N	2017-08-11	\N
595	Clemente Faga	2017-07-27	2017-08-18	Pessoa	2017-07-27 14:03:16.518	3	3	4	2	\N	2017-07-27 14:03:30.535	\N	2017-10-23 15:57:33.136	2017-08-11 11:21:15.741	\N	402	411.10	7	3	2	1	Abertura de Empresa		Será contratado como CLT.	2017-10-23	2017-10-23	\N
623	Fabiana (ME)	2017-11-13	2017-11-20	Empresa	2017-11-13 09:56:07.879	3	3	4	2	2017-11-14 08:44:53.422	2017-11-13 09:56:07.894	\N	2018-01-17 11:20:08.855	\N	231	\N	800.00	2	4	2	4	Cliente tambem possui as propostas: 621,624, 625 e 626			\N	2018-01-17	\N
444	Dr. Bruno	2016-07-20	2017-06-30	Empresa	2016-07-20 00:00:00	2	3	4	2	2017-02-23 16:43:49.453	\N	2017-06-06 11:46:18.975	2017-07-26 15:05:28.822	\N	185	\N	380.00	5	4	2	\N	Prestação de serviços de assessoria contábil na escrituração mensal de livro caixa para fins de Imposto de Renda de Pessoa Física e Folha de Pagamento.		DECLINADO. Por falta de retorno.	2017-07-26	2017-07-26	\N
593	Run Investimentos	2017-07-26	2017-07-26	Empresa	2017-07-26 15:22:01.271	2	2	4	2	\N	\N	\N	2017-07-26 15:22:01.276	\N	217	\N	0.00	7	4	2	1				\N	2017-07-26	\N
604	Ieda Paixão	2017-09-05	2017-10-25	Pessoa	2017-09-05 14:40:48.028	3	3	4	3	2017-09-11 09:11:23.162	2017-09-05 15:35:34.011	\N	2017-09-11 09:14:00.919	\N	\N	406	464.00	11	3	2	7	Abertura de empresa de consultoria ambiental.		Cliente Optou por abrir uma MEI	2017-09-11	2017-09-11	\N
563	Daniel 	2017-05-09	2017-05-15	Pessoa	2017-05-09 16:43:08.889	3	3	5	3	2017-05-09 16:43:08.892	2017-05-18 14:18:38.581	\N	\N	2017-05-18 11:30:18.995	\N	380	411.66	2	3	2	7			Cliente optou por abrir uma MEI	2017-05-18	2017-05-18	\N
504	Vanessa	2016-12-20	2017-02-10	Pessoa	2016-12-20 00:00:00	2	3	5	2	2017-04-06 18:12:28.976	\N	2017-03-14 12:21:04.584	\N	2017-04-27 16:01:31.112	\N	302	380.00	2	3	2	\N	Proposta enviada		Nunca retorna.	2017-04-27	2017-04-27	\N
600	Cecilia -Swagelok	2017-08-15	2017-08-31	Empresa	2017-08-15 16:40:48.404	3	2	4	3	2017-09-11 09:16:00.886	2017-08-15 16:41:13.671	\N	2017-09-11 09:16:05.121	\N	222	\N	3015.00	15	4	2	\N				\N	2017-09-11	\N
522	Beatriz	2017-02-06	2017-12-22	Pessoa	2017-02-06 17:11:53.286	2	3	4	2	2017-07-25 10:30:12.682	2017-08-07 15:57:33.216	2017-07-25 10:29:29.542	2018-01-23 12:13:30.948	2017-07-25 10:30:58.473	\N	330	412.00	5	3	2	1	Prestação de serviços de manutenção elétrica.		No momento não irá abrir a empresa.	2017-07-25	2018-01-23	\N
601	Giuliano Braz	2017-08-18	2017-08-31	Pessoa	2017-08-18 11:48:20.639	3	2	2	4	\N	2017-09-11 15:32:57.197	\N	\N	\N	\N	404	400.00	2	3	7	7				\N	2017-09-11	\N
602	BIPP PARTICIPACOES LTDA	2017-08-22	2017-08-22	Empresa	2017-08-22 10:43:32.371	2	2	4	1	\N	\N	\N	2017-08-24 11:58:29.697	\N	223	\N	650.00	2	4	7	3				\N	\N	\N
599	Hands On - Felipe	2017-08-07	2017-08-31	Empresa	2017-08-07 16:52:04.828	2	2	1	4	2017-08-28 14:39:23.967	2017-08-07 17:19:03.903	2017-08-11 10:40:11.505	\N	\N	220	\N	650.00	4	4	2	\N	Indicação Clemente			\N	2017-08-28	\N
622	Cleia	2017-11-10	2018-01-31	Empresa	2017-11-10 11:08:12.655	2	1	1	2	2018-01-17 12:18:49.479	2017-11-10 11:08:12.659	\N	\N	\N	230	\N	1100.00	11	4	2	5	Comércio de ferramentas			\N	\N	\N
598	Kaique Lopes Targino	2017-08-03	2017-10-31	Pessoa	2017-08-03 11:08:59.718	2	3	4	2	2017-09-11 15:49:13.352	2017-08-03 11:09:14.318	2017-10-23 15:49:47.176	2018-01-17 14:59:55.514	\N	\N	403	520.00	11	3	2	8	Tabacaria.		DECLINADO. Não vai mais abrir empresa.	2018-01-17	2018-01-17	\N
624	(FABIANA) JANDIRA KIDS	2017-11-13	2017-11-20	Empresa	2017-11-13 10:00:48.942	3	3	4	2	2017-11-14 08:45:00.887	2017-11-13 10:00:48.957	\N	2018-01-17 11:20:55.936	\N	232	\N	800.00	2	4	2	4				\N	2018-01-17	\N
618	Elizeth	2017-10-18	\N	Empresa	2017-10-18 11:59:23.942	4	2	2	4	2017-10-18 11:59:23.949	2017-10-18 12:00:32.624	\N	\N	\N	227	\N	550.00	2	\N	3	3	Voltou a ser Cliente			\N	2017-10-18	\N
606	Daniel Dourado	2017-09-15	2018-01-31	Empresa	2017-09-15 14:45:29.744	3	1	1	2	2018-01-17 14:49:26.269	2017-09-15 14:45:47.225	2017-10-23 15:02:05.156	\N	\N	224	\N	400.00	2	4	7	7				\N	\N	\N
614	Ronaldo	2017-10-02	\N	Pessoa	2017-10-02 15:34:30.269	4	2	4	2	2017-10-02 15:34:30.27	\N	2017-10-02 15:35:11.173	2018-03-23 12:16:22.726	\N	\N	410	380.00	7	3	2	1	Indicação da empresa onde o Aristeu trabalhava.			\N	2018-03-23	\N
586	Telma (Editora Nova Onda)	2017-06-30	2018-03-30	Empresa	2017-06-30 12:22:31.915	3	1	3	2	2017-08-24 10:40:02.958	\N	2018-02-27 09:47:18.207	2017-07-19 11:21:01.122	\N	215	\N	209.00	11	4	2	1	Origem: Fórum Mulheres Empreendedoras.			\N	\N	\N
619	Elizeth	2017-10-18	\N	Empresa	2017-10-18 12:03:52.23	4	2	2	4	2017-10-18 12:03:52.233	2017-10-18 12:04:11.812	\N	\N	\N	228	\N	650.00	2	4	3	3	Voltou a ser Cliente, Fechou			\N	2017-10-18	\N
615	Dra. Vanessa	2017-10-02	2017-10-16	Pessoa	2017-10-02 16:19:13.495	4	2	4	2	2017-10-02 16:19:13.497	2017-10-17 10:49:17.164	\N	2017-10-17 10:57:29.331	\N	\N	411	380.00	15	3	2	\N				\N	2017-10-17	\N
597	Luís Matos	2017-08-03	2017-08-31	Empresa	2017-08-03 10:57:36.318	2	3	4	2	2017-09-13 08:47:48.14	2017-08-03 11:08:08.705	2017-08-11 10:43:39.463	2017-10-17 11:02:00.102	\N	219	\N	700.00	15	4	2	\N	Indicação Takamori.		Fechou com outro contador, conforme e-mail do Dr. Ricardo.	2017-10-17	2017-10-17	\N
613	Daniele Gieseke	2017-09-28	2017-10-31	Pessoa	2017-09-28 14:21:27.274	3	3	4	2	2017-10-17 11:48:07.717	2017-09-28 14:21:39.524	2017-10-17 11:48:14.513	2017-10-20 15:16:29.459	\N	\N	409	600.00	2	3	2	8				\N	2017-10-20	\N
603	Peter	2017-08-29	2017-11-24	Pessoa	2017-08-29 15:10:52.02	2	4	5	2	2017-09-11 15:30:04.119	2017-08-29 15:13:01.819	\N	\N	2017-10-23 15:26:18.347	\N	405	519.50	11	3	2	7	Comércio varejista de chocolates.			\N	2017-10-23	\N
605	Gabriel Varjão	2017-09-13	2017-11-10	Pessoa	2017-09-13 16:28:26.702	3	3	4	2	2017-10-23 15:20:19.719	2017-09-13 16:29:00.405	2017-10-23 15:20:01.438	2018-02-27 09:27:04.959	\N	\N	407	450.00	2	3	2	7				\N	2018-02-27	\N
612	CANHOTO & PAGNOSSIN	2017-09-26	2017-10-09	Empresa	2017-09-26 17:56:24.393	3	1	1	3	2017-10-17 12:06:03.627	2017-09-26 17:56:24.396	\N	\N	\N	225	\N	380.00	2	4	2	1				\N	\N	\N
608	Julia Rufino	2017-09-25	2017-10-22	Prospeccao	2017-09-25 17:29:02.481	4	2	4	2	2017-09-26 11:24:29.625	\N	\N	2017-10-23 14:17:56.254	\N	\N	\N	380.00	16	3	\N	\N	tem Mei e quer trandormar em ME			\N	2017-10-23	51
617	Dr. Davi	2017-10-17	2018-06-29	Empresa	2017-10-17 11:20:31.807	4	4	5	2	2017-10-17 11:20:31.842	2017-10-17 11:51:49.515	\N	\N	2018-02-21 16:20:21.154	226	\N	200.00	15	4	2	1	Indicação da empresa ID 2413			\N	2018-02-21	\N
611	MascoPet Comercio de Produtos Veterinarios	2017-09-26	2017-10-09	Empresa	2017-09-26 12:24:53.294	3	3	4	2	2017-10-17 12:07:33.156	2017-09-26 12:24:53.297	\N	2017-10-17 12:07:36.371	\N	219	\N	937.00	7	4	2	3				\N	\N	\N
610	Maskovet Clinica Veterinaria	2017-09-26	2017-10-09	Empresa	2017-09-26 12:23:22.319	3	3	4	2	\N	2017-09-26 12:23:22.323	\N	2017-10-17 12:07:51.418	\N	219	\N	380.00	15	4	2	1			DECLINADO. Conforme e-mail do Dr. Ricardo.	2017-10-17	2017-10-17	\N
607	Manuela Brandão Borges	2017-09-20	2017-10-31	Pessoa	2017-09-20 17:23:06.321	4	3	4	2	2017-09-20 17:23:22.883	2017-09-22 17:44:24.082	\N	2018-01-17 15:03:41.071	\N	\N	408	0.00	16	3	2	7	Abertura de empresa -Contato do 6° Forum Mulheres empreendedoras.		DECLINADO. Abriu com o contador do marido.	2018-01-17	2018-01-17	\N
596	Nair	2017-07-27	2017-08-25	Empresa	2017-07-27 17:53:28.377	2	3	4	2	2017-09-13 11:50:28.501	2017-07-27 17:53:56.937	2017-08-01 14:32:31.271	2017-10-23 15:56:17.206	\N	218	\N	1874.00	11	4	2	\N	Posto de gasolina			\N	2017-10-23	\N
627	Ari - Danada Produções	2017-11-13	2018-02-06	Empresa	2017-11-13 10:44:17.296	4	3	4	2	2017-11-13 10:44:17.298	\N	2017-11-13 11:16:49.908	2018-02-06 12:31:21.158	\N	235	\N	500.00	5	4	2	1	Proposta era 621 - passa a ser 627.		Fechou com outro contador por falta de contato da ProLink.	2018-02-06	\N	\N
620	Anhembi Hostel Tour&Business	2017-10-30	\N	Prospeccao	2017-10-30 16:21:47.452	4	3	4	2	2017-10-30 16:21:47.452	2017-10-30 16:22:34.091	\N	2018-01-17 11:28:03.458	\N	\N	\N	1300.00	16	4	\N	\N	Pediu uma verificação tributária.		DECLINADO: Marina informou não ter mais interesse em mudar de contador nem na verificação tributária. Nenhum motivo específico.	2018-01-17	2018-01-17	42
621	Fabiana	2017-11-09	2017-11-24	Pessoa	2017-11-09 14:01:00.442	3	2	1	2	2017-11-14 08:44:22.499	2017-11-09 17:09:56.012	\N	\N	\N	\N	415	937.00	15	3	2	4				\N	2017-11-14	\N
478	Regiane Rodrigues Carvalho	2016-11-03	2017-08-04	Pessoa	2016-11-03 00:00:00	2	3	4	2	2017-07-26 14:54:24.026	\N	2017-07-26 14:51:07.069	2017-11-28 14:50:13.279	\N	\N	286	400.00	5	\N	2	\N				\N	2017-11-28	\N
616	Paloma	2017-10-04	2017-10-31	Pessoa	2017-10-04 12:24:23.291	2	3	4	2	2017-10-04 12:24:23.299	2017-10-17 10:47:11.391	\N	2018-01-17 14:42:06.383	\N	\N	412	412.00	11	3	2	1	Agência de viagens.		Fecharam com outra empresa.	2018-01-17	2018-01-17	\N
655	ALINE	2018-03-12	2018-03-30	Empresa	2018-03-12 17:37:59.383	8	3	4	2	2018-03-12 17:37:59.399	2018-03-12 17:39:18.169	2018-03-16 11:17:46.842	2018-05-08 11:33:49.636	\N	253	\N	290.00	5	4	2	1			Não estava de acordo com nosso contrato.	2018-05-08	2018-05-08	\N
639	Alexandre	2018-01-18	2018-01-31	Empresa	2018-01-18 13:51:59.658	3	2	4	3	2018-01-22 11:19:49.228	2018-01-18 13:51:59.658	\N	2018-01-22 11:19:54.54	\N	240	\N	350.00	4	4	2	1	Indicação Robison			\N	\N	\N
637	Gilberto Ramos	2018-01-15	\N	Empresa	2018-01-15 10:50:05.974	3	2	4	2	2018-01-15 14:24:15.768	2018-01-15 10:50:05.977	\N	2018-01-23 10:17:21.073	\N	239	\N	350.00	7	4	3	7	Implantação\nEx-cliente			\N	2018-01-23	\N
640	Human Capital - Sergio	2018-01-24	2018-02-28	Empresa	2018-01-24 16:44:52.397	2	2	4	3	\N	2018-01-24 16:44:52.401	\N	2018-01-29 17:13:55.757	\N	241	\N	420.00	15	4	2	\N	Indicação do próprio Sergio. ID 95 - SN CONSULTORIA EM INFORMÁTICA.			\N	2018-01-29	\N
643	Loft Tietê Plaza	2018-02-15	2018-03-31	Empresa	2018-02-15 11:15:39.156	2	2	4	2	2018-02-16 14:27:38.864	2018-02-15 11:15:39.161	2018-02-19 13:51:47.308	2018-02-28 15:27:24.766	\N	244	\N	1300.00	11	4	2	4	Comércio varejista especializado de equipamentos de telefonia e comunicação			\N	2018-02-28	\N
628	Adriano Silva	2017-11-16	2017-11-30	Pessoa	2017-11-16 13:45:48.6	3	2	4	3	2018-01-17 11:13:27.799	2017-11-16 13:45:48.6	\N	2018-02-01 14:16:15.344	\N	\N	416	650.00	7	3	3	7	Ex-Cliente			\N	2018-02-01	\N
632	Tatiana	2017-12-14	2018-01-10	Empresa	2017-12-14 17:08:00.674	3	4	4	2	2018-01-12 09:54:46.816	2017-12-14 17:08:00.674	\N	2018-01-12 09:55:19.068	\N	236	\N	13000.00	5	4	6	\N	Proposta para folha de pagamento			\N	2018-01-12	\N
636	Marcos Perez	2018-01-12	2018-01-12	Empresa	2018-01-12 13:44:32.332	3	2	4	3	\N	\N	\N	2018-01-12 13:45:21.766	\N	238	\N	350.00	7	4	2	1				\N	2018-01-12	\N
635	Rita	2018-01-03	2018-01-15	Empresa	2018-01-03 17:20:20.288	3	3	4	2	\N	2018-01-03 17:20:20.288	\N	2018-01-12 13:57:09.274	\N	237	\N	380.00	15	4	2	1	Indicação da Cubo		A cliente fechou com uma contabilidade que fará R$ 200,00 mes.	2018-01-05	2018-01-12	\N
641	Raquel (Buffet Damira)	2018-02-09	2018-02-09	Empresa	2018-02-09 13:59:29.072	2	2	4	2	\N	\N	\N	2018-02-09 13:59:47.09	\N	243	\N	350.00	7	4	2	1				\N	\N	\N
42	Adriano Heleno	2015-03-26	2015-03-26	Empresa	2015-03-26 00:00:00	6	3	1	2	2018-02-14 11:02:36.688	\N	\N	\N	\N	21	\N	788.00	3	4	2	\N	Atendido pela Silvia 07/02 - Atualmente paga 724,00 na contabilidade .			\N	2018-02-14	\N
631	Vivian	2017-12-12	2018-01-05	Pessoa	2017-12-12 09:51:10.877	3	3	4	2	2018-01-12 10:05:12.331	2017-12-12 09:51:10.877	2018-01-12 10:05:20.487	2018-04-16 14:20:49.891	\N	\N	419	937.00	5	3	2	3	Deseja abrir uma empresa, pela franquia Mr. Pretzels			\N	2018-04-16	\N
634	Thais	2017-12-29	2018-01-19	Pessoa	2017-12-29 13:58:50.263	3	2	4	2	2018-01-12 09:37:44.946	2017-12-29 13:58:50.263	2018-01-12 10:00:24.408	2018-01-16 15:25:12.279	\N	\N	421	421.00	15	3	2	7	Abertura de empresa médica.\nIndicação (2297) Dr. Rafael Salim.			\N	2018-01-16	\N
650	Adejailson - Luna desen.	2018-02-28	2018-03-30	Empresa	2018-02-28 12:16:27.799	2	2	4	2	2018-03-20 14:24:06.6	2018-03-16 14:20:47.34	\N	2018-03-21 16:39:37.276	\N	251	\N	530.00	\N	4	2	7	Desenvolvimento de programas de computador sob encomenda.			\N	2018-03-21	\N
638	Beatriz	2018-01-16	2018-02-16	Pessoa	2018-01-16 15:36:39.383	2	3	4	2	2018-02-06 11:01:01.821	2018-01-16 17:06:33.746	2018-02-06 11:00:43.776	2018-02-21 15:47:21.14	\N	\N	423	750.00	11	3	2	1	Decoração de casamentos.			\N	2018-02-21	\N
626	(FABIANA) SÃO ROQUE KIDS	2017-11-13	2017-11-20	Empresa	2017-11-13 10:11:18.022	3	3	4	2	2017-11-14 08:45:12.415	2017-11-13 10:11:18.022	\N	2018-01-17 11:20:28.153	\N	234	\N	800.00	2	4	2	4				\N	2018-01-17	\N
625	(FABIANA) J M KIDS	2017-11-13	2017-11-20	Empresa	2017-11-13 10:04:28.751	3	3	4	2	2017-11-14 08:45:06.975	2017-11-13 10:04:28.751	\N	2018-01-17 11:20:42.152	\N	233	\N	800.00	2	4	2	4				\N	2018-01-17	\N
629	Gabriela Secco	2017-12-04	2017-12-15	Pessoa	2017-12-04 11:16:52.326	3	2	4	3	2018-01-15 08:23:11.168	2017-12-04 11:16:52.342	\N	2018-01-17 11:46:09.58	\N	\N	417	464.00	5	3	2	7	Abertura de Empresa Médica.			\N	2018-01-17	\N
609	Aline Tavares - Beauty Hands	2017-09-26	2017-11-10	Prospeccao	2017-09-26 11:28:05.83	4	3	4	2	2017-09-26 11:28:05.832	2017-10-23 14:28:07.665	\N	2018-01-18 09:13:02.191	\N	\N	\N	1600.00	16	4	2	3	Falamos com ela no 6° Forum de mulheres empreendedoras.\nTem uma esmalteria.\n- Fatura R$ 100 mil mensal e tem 20 funcionárias		DECLINADO - Irá permanecer com o mesmo contador.	2018-01-18	2018-01-18	58
633	Felipe Corominas	2017-12-14	2018-01-20	Pessoa	2017-12-14 17:46:29.048	3	3	4	2	2018-01-12 09:47:27.891	2017-12-14 17:46:29.064	2018-01-12 09:47:09.407	2018-02-21 15:51:25.561	\N	\N	420	487.50	5	3	2	7	Abertura de um Buffet de comida espanhola.			\N	2018-02-21	\N
630	Juliano Tuboni	2017-12-04	2018-01-19	Pessoa	2017-12-04 11:38:28.94	3	3	4	2	2017-12-04 11:38:28.94	2017-12-04 11:38:40.378	2018-01-12 10:26:13.726	2018-02-21 15:54:40.029	\N	\N	418	421.00	5	3	2	\N	Serviços de Medicina Veterinaria		Por enquanto não irá abrir empresa. Volta a falar conosco no futuro.	2018-02-21	2018-02-21	\N
645	Binary IT - Rêne	2018-02-19	2018-03-31	Empresa	2018-02-19 08:51:18.717	2	1	1	2	2018-02-19 08:51:18.721	\N	\N	\N	\N	245	\N	320.00	7	4	2	8				\N	\N	\N
662	Dr. Pasquale	2018-03-23	2018-03-30	Empresa	2018-03-23 15:44:10.019	2	1	1	2	2018-04-13 10:50:51.817	2018-03-23 15:44:10.022	\N	\N	\N	258	\N	192.89	2	4	7	10	Implantar para encerrar.			\N	\N	\N
654	Dra. Bianca	2018-03-09	\N	Pessoa	2018-03-09 18:37:40.729	4	2	2	4	2018-03-09 18:37:40.731	2018-03-14 16:59:25.834	\N	\N	\N	\N	427	300.00	18	4	2	1				\N	2018-03-14	\N
657	Célia Gonçalves	2018-03-14	2018-03-30	Empresa	2018-03-14 10:40:06.835	2	1	1	2	2018-03-16 15:17:40.956	2018-03-14 10:40:46.543	2018-03-14 15:48:49.625	\N	\N	255	\N	2638.00	4	3	2	\N	Indicação Robison.			\N	\N	\N
658	Célia - Condutron	2018-03-14	2018-03-30	Empresa	2018-03-14 11:27:28.607	2	1	3	2	2018-03-14 11:27:28.61	\N	2018-03-14 15:48:27.059	\N	\N	255	\N	0.00	4	4	2	\N	Indicação Robison.			\N	\N	\N
660	Hugo Pessoa	2018-03-16	2018-03-30	Empresa	2018-03-16 15:53:31.388	2	1	1	2	2018-03-20 10:33:52.177	2018-03-16 15:53:31.393	\N	\N	\N	257	\N	480.00	5	4	2	1	Área gráfica: Entretenimento			\N	\N	\N
646	Miguel di Ciurcio	2018-02-19	2018-02-28	Empresa	2018-02-19 17:48:42.548	3	1	2	2	2018-02-19 17:50:03.417	2018-04-16 14:25:52.27	\N	\N	\N	248	\N	2300.00	7	4	2	5	Caso de Campinas.			\N	\N	\N
649	Maria Chakkour	2018-02-26	2018-03-31	Empresa	2018-02-26 10:23:36.729	2	2	4	2	2018-03-16 15:08:53.81	2018-02-26 10:23:36.732	2018-02-26 17:49:38.083	2018-04-18 09:59:41.258	\N	250	\N	380.00	15	4	2	1	Indicação da Coibim			\N	2018-04-18	\N
659	Carmem Costa	2018-03-15	2018-05-18	Empresa	2018-03-15 13:46:06.258	2	1	3	2	2018-03-15 13:46:06.261	2018-04-10 10:11:49.193	2018-04-10 10:12:48.729	\N	\N	256	\N	515.00	19	4	2	1	Operadora de Turismo.			\N	\N	\N
664	Sandra Martins	2018-03-28	2018-04-09	Pessoa	2018-03-28 15:29:15.626	9	3	4	2	2018-03-28 15:29:15.626	\N	\N	2018-04-19 11:14:10.231	\N	\N	430	935.00	20	\N	\N	\N	franquia chef da empada regiao de Sorocaba.		Falei com a Sra Sonia e por motivo de distancia a mesma optou por fechar com um contador da sua região, Sorocaba.\n	2018-03-29	2018-04-19	\N
642	Junior Inácio	2018-02-14	2018-04-27	Pessoa	2018-02-14 17:09:16.229	3	1	1	2	2018-03-20 15:28:09.237	2018-02-14 17:31:37.941	\N	\N	\N	\N	425	1500.00	5	3	2	4	Abertura de uma transportadora			\N	\N	\N
661	Dr. Orlando	2018-03-23	2018-04-27	Pessoa	2018-03-23 10:55:53.179	2	3	4	2	\N	2018-03-23 11:50:00.176	\N	2018-04-13 10:54:35.198	\N	\N	429	412.00	5	3	2	1	Prestação de serviços médicos em psicologia.		Vai deixar para abrir empresa mais pra frente.	2018-04-13	2018-04-13	\N
666	Igreja Batista - Sr. Francisco	2018-04-04	2018-04-30	Empresa	2018-04-04 11:07:54.296	2	3	4	2	\N	2018-04-04 11:07:54.302	\N	2018-04-04 11:34:01.911	\N	259	\N	0.00	5	4	2	\N			Ver andamento em proposta nº 667.	2018-04-04	2018-04-04	\N
672	Dra. Nathalie	2018-04-16	2018-05-31	Pessoa	2018-04-16 15:33:54.567	2	1	1	2	2018-04-27 11:43:04.39	2018-04-16 16:30:27.278	\N	\N	\N	\N	432	420.00	15	3	2	1	Indicação Dra. Vanessa Assis ID 2433 (380,00 + 45,00 emissão de notas)			\N	\N	\N
665	Simone de Fatima Martins	2018-04-03	\N	Prospeccao	2018-04-03 14:23:58.092	9	3	4	9	2018-04-03 14:23:58.092	2018-04-03 14:24:18.302	\N	2018-04-27 13:47:42.26	\N	\N	\N	550.00	20	3	2	1	Abertura de empresa de serviços administrativo , financeiro e comercial		A mesma informa que o dono da clinica ainda não decidiu se vai registrar\nou não.	2018-04-27	2018-04-27	133
673	Run Turismo	2018-04-17	2018-05-11	Empresa	2018-04-17 10:44:41.635	2	2	4	2	2018-04-17 10:44:41.639	2018-04-17 11:42:37.061	\N	2018-05-02 12:11:28.269	\N	217	\N	385.00	2	3	7	1	Empresa da RUN INVESTIMENTOS (ID 2420).			\N	2018-05-02	\N
668	Quality - Marcelo	2018-04-05	2018-04-21	Empresa	2018-04-05 16:16:05.882	2	2	4	2	\N	2018-04-05 16:16:05.886	\N	2018-04-05 17:39:07.95	\N	260	\N	192.82	15	4	2	10	Indicação Gustavo - Run Investimentos.			\N	2018-04-05	\N
675	Hélio - Aeon Informática	2018-05-07	2018-05-31	Empresa	2018-05-07 09:25:31.888	2	2	4	2	\N	\N	\N	2018-05-07 09:25:31.891	\N	265	\N	700.00	2	3	7	3				\N	2018-05-07	\N
674	Suclajum Servicos Medicos	2018-05-04	2018-05-31	Empresa	2018-05-04 12:05:10.96	2	1	1	2	2018-05-07 17:53:40.781	2018-05-07 11:27:11.059	\N	\N	\N	264	\N	0.00	5	4	2	\N				\N	\N	\N
671	Ateliê Sorriso - Dra. Gabriela	2018-04-11	2018-04-30	Empresa	2018-04-11 10:00:38.117	2	1	1	2	2018-04-11 14:30:41.871	2018-04-11 14:30:37.42	\N	\N	\N	263	\N	798.00	15	4	2	1	Indicação Dr. Gerson.\nPrecisa também de recálculo de INSS e FGTS em atraso.\nConsultório dentista com 1 funcionária (Raquel)			\N	\N	\N
644	Hélio - Aeon Informática	2018-02-16	2018-03-31	Empresa	2018-02-16 09:01:33.117	2	2	4	2	\N	2018-02-16 10:31:50.163	\N	2018-04-11 15:27:54.033	\N	246	\N	450.00	4	4	2	9	Indicação da Rosa: Esyworld - ID 2011 (não daremos desconto na mensalidade, daremos um presente diretamente para a Rosa).			\N	\N	\N
670	Rodrigo	2018-04-10	2018-04-30	Empresa	2018-04-10 12:13:01.537	2	1	1	2	2018-04-12 17:25:22.898	2018-04-11 09:35:38.621	\N	\N	\N	262	\N	480.00	15	4	2	7	Indicação Mastery			\N	\N	\N
653	Fernando Cesar Rodrigues	2018-03-06	2018-06-06	Empresa	2018-03-06 11:24:19.239	8	3	4	2	2018-03-06 11:24:19.254	2018-03-06 11:25:02.491	\N	2018-04-13 16:04:32.276	\N	252	\N	3700.00	2	4	7	6	Cliente pretende fundir a Sistemas Seguros numa outra empresa do mesmo seguimento situada no estado do Paraná.		Em reunião com Clemente e Dr. Ricardo, Fernando informou que quer fazer uma incorporação e por isso essa proposta está declinada. Outros serviços e valor foram combinados em reunião.	2018-04-13	2018-04-13	\N
648	Tercio Vasconcelos	2018-02-26	2018-03-30	Empresa	2018-02-26 09:51:49.828	2	2	4	2	2018-03-14 17:00:41.71	2018-02-26 09:51:49.832	\N	2018-04-13 16:30:44.194	\N	249	\N	550.00	2	3	7	7	Editoração e comércio de livros.			\N	2018-04-13	\N
647	Growler Market - Diego	2018-02-20	2018-06-29	Empresa	2018-02-20 11:05:12.811	2	1	3	2	2018-03-20 14:57:51.484	2018-02-20 11:05:12.816	2018-04-13 16:36:52.504	\N	\N	247	\N	738.00	12	4	2	9	Atividade: Revenda de chope.			\N	\N	\N
652	Andreia	2018-02-28	2018-04-27	Pessoa	2018-02-28 17:42:02.877	3	1	3	2	2018-03-16 14:03:59.173	2018-02-28 17:42:02.877	2018-04-13 17:24:25.879	\N	\N	\N	426	280.00	7	3	2	1	Indicação Dr. Ricardo.			\N	\N	\N
651	BRABEX (GUSTAVO CARVALHO)	2018-02-28	2018-03-07	Empresa	2018-02-28 14:25:36.26	3	2	4	2	\N	2018-02-28 14:25:56.306	2018-03-20 11:09:15.886	2018-04-13 17:25:37.367	\N	217	\N	400.00	7	4	2	1	e-mail: andre.giulisese@brabex.com.br / gcarvalho@brabex.com.br			\N	2018-04-13	\N
667	Igreja Batista - Sr. Francisco	2018-04-04	2018-04-30	Empresa	2018-04-04 11:35:03.189	2	3	4	2	2018-04-05 11:55:17.88	2018-04-05 11:54:59.098	\N	2018-04-16 12:16:27.86	\N	259	\N	1500.00	5	4	2	\N	R$ 28,00 por funcionário.			\N	2018-04-16	\N
682	KIDSTOK	2018-06-05	2018-06-30	Pessoa	2018-06-05 11:53:08.866	2	2	4	2	\N	2018-06-05 11:53:08.938	\N	2018-06-05 11:55:18.698	\N	\N	435	750.00	2	3	7	3	Comércio de roupas e acessórios para crianças de 0 - 14 anos.			\N	2018-06-05	\N
656	Dinis - Art & Sabor	2018-03-13	2018-03-31	Empresa	2018-03-13 14:06:41.111	2	3	4	2	2018-03-14 16:44:08.536	2018-03-13 14:06:41.116	\N	2018-04-19 11:14:20.298	\N	254	\N	954.00	5	4	2	4				\N	2018-04-19	\N
687	Jane Oliveira	2018-06-19	2018-06-29	Pessoa	2018-06-19 15:32:04.8	2	2	2	2	\N	2018-06-19 15:32:33.78	\N	\N	\N	\N	438	600.00	2	3	7	8	Indicação 1863 - LUCIA REIKO KONISHI TAKATSU ESTÉTICA - EPP			\N	\N	\N
678	Rodrigo - Mastery	2018-05-09	2018-05-31	Empresa	2018-05-09 16:42:20.63	2	1	2	2	2018-05-09 16:42:33.06	2018-05-09 16:42:43.625	\N	\N	\N	262	\N	480.00	15	3	2	1	Prestador de serviços Mastery.			\N	\N	\N
677	Sergio Narimatsu	2018-05-08	2018-05-25	Empresa	2018-05-08 15:47:03.067	2	1	2	2	\N	2018-05-09 16:42:52.945	\N	\N	\N	266	\N	550.00	2	3	7	7				\N	\N	\N
676	Dra. Márcia Jordão	2018-05-08	2018-05-25	Pessoa	2018-05-08 11:43:46.513	2	1	2	2	\N	2018-05-09 16:43:00.778	\N	\N	\N	\N	433	350.00	7	3	2	1	Irmã do Dr. Ricardo.			\N	\N	\N
679	Mania de passar	2018-05-10	2018-05-31	Prospeccao	2018-05-10 17:34:03.38	9	1	2	9	2018-05-10 17:34:03.38	2018-05-10 17:34:26.248	\N	\N	\N	\N	\N	1100.00	10	4	2	4	franqueadora Mania de passar.			\N	\N	190
683	Luciano	2018-06-07	2018-06-29	Empresa	2018-06-07 15:30:19.492	2	1	2	2	\N	2018-06-07 15:32:30.418	\N	\N	\N	269	\N	400.00	\N	3	2	1				\N	\N	\N
681	Viviane Lunelli	2018-05-23	\N	Empresa	2018-05-23 14:20:53.432	9	1	1	9	2018-05-23 14:21:22.328	\N	\N	\N	\N	268	\N	0.00	7	4	2	7				\N	\N	\N
680	Compuwise Informática	2018-05-16	\N	Empresa	2018-05-16 14:23:52.062	9	2	4	2	2018-05-16 14:23:52.062	\N	2018-05-16 16:57:53.657	2018-06-05 08:55:32.024	\N	267	\N	1150.00	7	4	2	3	Indicação Doutor ricardo			\N	2018-06-05	\N
685	Maria Sandra	2018-06-15	2018-06-29	Pessoa	2018-06-15 13:51:11.494	2	1	2	2	\N	2018-06-15 13:51:11.496	\N	\N	\N	\N	437	410.00	11	3	2	1				\N	\N	\N
684	CHRISTOFOLETTI & MADIA LTDA  	2018-06-07	2018-06-30	Pessoa	2018-06-07 15:35:33.972	2	1	3	2	\N	2018-06-07 15:35:33.979	2018-06-15 14:36:54.232	\N	\N	\N	378	700.00	4	3	2	3	Indicação Isabelle.			\N	\N	\N
688	Renata Arassiro	2018-06-25	\N	Empresa	2018-06-25 11:22:17.236	9	1	1	9	2018-06-25 11:23:41.78	\N	\N	\N	\N	271	\N	600.00	7	4	2	7				\N	\N	\N
686	Elpidio	2018-06-18	2018-06-22	Empresa	2018-06-18 16:42:18.089	2	2	4	2	2018-06-18 16:42:18.095	\N	\N	2018-06-18 16:43:57.095	\N	270	\N	196.31	2	4	7	10	Elpidio já é sócio em duas empresas clientes da ProLink: 2450 e 2461.			\N	2018-06-18	\N
\.


--
-- Data for Name: negocio_documento; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.negocio_documento (neg_doc_cod, neg_doc_nome, neg_doc_usuario, neg_doc_data, neg_doc_url, neg_doc_negocio_cod, neg_doc_descricao) FROM stdin;
1	Proposta	2	2017-04-18 10:42:13.064	sKhObrFbifSVxtTn3ngbI9ZFZAMdoKrcqB8ZHOEQxBR4mv6pRhOzczjcitRc8557.doc	557	\N
2	Prosposa	2	2017-04-18 11:47:34.972	uTApHEphzOkXf70AH0VxhV76UNcAnectet2H3hdcj02CeZLBVXspUSNMqTI6f558.doc	558	\N
4	Proposta	2	2018-06-18 16:44:04.275	H1KZxJVuiVA1LxIEaIJjBBDA1DjULgXVPEjso3gfAF1B56pcLJrCPHzcUZ4Mi686.pdf	686	
5	Proposta	2	2018-06-19 15:32:32.224	LC6PUbXJ5mN4EFKzUnlAGQD9Lp8fDx91z4E0hvfuLOnx3ajiO3CRhzKjEiXHz687.pdf	687	
\.


--
-- Name: negocio_documento_neg_doc_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.negocio_documento_neg_doc_cod_seq', 5, true);


--
-- Data for Name: negocio_etapa; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.negocio_etapa (neg_eta_cod, neg_eta_nome) FROM stdin;
1	Contato
2	Envio de Proposta
3	Follow-up
4	Fechamento
5	Indefinida
\.


--
-- Name: negocio_etapa_neg_eta_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.negocio_etapa_neg_eta_cod_seq', 5, true);


--
-- Name: negocio_neg_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.negocio_neg_cod_seq', 688, true);


--
-- Data for Name: negocio_status; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.negocio_status (neg_sta_cod, neg_sta_nome) FROM stdin;
1	Em Andamento
2	Ganho
3	Perdido
4	Sem Movimento
\.


--
-- Name: negocio_status_neg_sta_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.negocio_status_neg_sta_cod_seq', 4, true);


--
-- Data for Name: nivel; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.nivel (niv_cod, niv_nome) FROM stdin;
1	Bronze
2	Diamante
3	Ouro 1
4	Ouro 2
5	Ouro 3
6	Platina
7	Prata 1
8	Prata 2
9	Prata 3
10	Inativa
11	MEI
\.


--
-- Name: nivel_niv_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.nivel_niv_cod_seq', 11, true);


--
-- Data for Name: origem; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.origem (ori_cod, ori_nome) FROM stdin;
1	Bioqualynet
2	Cliente
4	Funcionários
5	Internet
6	Marketing
7	Outros
8	Parceria
9	Porto Seguro
10	Prospecção
11	Chat Jivo
12	Feira ABF 2017
14	Fórum Empreendedoras 2016
15	Indique 1 amigo
16	Fórum Empreendedoras 2017
17	36º CIOSP
18	Familiares/Amigos  Funcionarios
3	Feira SEBRAE 2015
19	Feira SEBRAE 2016
20	Daniela
\.


--
-- Name: origem_ori_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.origem_ori_cod_seq', 20, true);


--
-- Data for Name: pessoa; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.pessoa (pes_cod, pes_nome, pes_cpf, pes_nasc, pes_logradouro, pes_end_nome, pes_end_complemento, pes_end_numero, pes_end_bairro, pes_end_cep, pes_cidade_cod, pes_telefone, pes_celular, pes_email, pes_site, pes_criadoem, pes_criadopor_cod, pes_origem_cod, pes_atendente_cod, pes_servico_cod, pes_categoria_cod, pes_nivel_cod, pes_apelido_cod, pes_razao_cod, pes_ult_negocio_cod) FROM stdin;
317	Rodrigo Ike	21340801833	06/09	Rua					        	\N		99212-8377	rodrigoike77@hotmail.com		2017-01-23 15:13:34.015	2	2	3	3	3	\N	\N	\N	512
314	Anete Hannub Abdo	21340801833		Rua					        	3831		99980-0657	anetebr@yahoo.com		2017-01-23 14:35:09.419	2	5	2	3	2	\N	\N	\N	513
318	Tatiana Hannud Abdo	           		Rua					        	3831			toco_tati@hotmail.com		2017-01-23 15:32:56.469	2	5	2	3	2	\N	\N	\N	514
325	Caroline Bonati	           		Rua					        	3831		97492-3218	ari.aguillar@yahoo.com.br		2017-01-30 14:07:18.803	2	5	2	3	2	\N		\N	\N
312	Leandro Delgado de Azevedo	           		Rua					        	\N		22 99979-5118	leazevedo87@gmail.com		2017-01-23 11:11:26.5	2	5	2	3	2	\N	\N	\N	\N
304	Alex Raider	           		Rua					        	\N			alex.raider25@hotmail.com		2016-12-21 00:00:00	2	5	2	3	2	\N		\N	506
319	Marisa Joenck	           		Rua					        	3831		94194-1636	mjoenck@gmail.com		2017-01-24 14:09:22.87	2	5	2	3	2	\N	\N	\N	516
326	Mayara Pontes Ferreira Gonçalves	           		Rua					        	3831		93005-9781	mayarapontesferreira94@gmail.com		2017-01-31 15:23:27.021	2	5	2	3	2	\N		\N	517
327	Rodrigo Frederico	           		Rua					        	3831		99235-7588	rodrigo.frederico@hotmail.com		2017-01-31 15:52:44.897	2	5	3	3	2	\N		\N	518
320	Pedro Wilson Viana Leitão	           		Rua					        	3831	2371-7373	98199-6666	pedro.wilson@stacco.com.br		2017-01-24 14:41:42.628	2	5	2	4	2	\N		\N	515
287	Carlos	           		Rua					        	\N	4435-7109	9973-7476	cebisco@gmail.com		2016-10-27 00:00:00	2	2	2	3	2	\N		\N	480
273	Fabio			\N	\N	\N	\N	\N	\N	\N		11953712543	fabiosequeira80@gmail.com		2016-09-20 00:00:00	4	8	4	\N	2	\N	\N	\N	462
308	Jorge Rocha Coutinho			\N	\N	\N	\N	\N	\N	\N					2017-01-12 09:09:47.489	4	\N	4	\N	\N	\N	\N	\N	511
72	Cristian Alkimin			\N	\N	\N	\N	\N	\N	\N			alkicristian@ig.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	90
73	Daniel Frigo			\N	\N	\N	\N	\N	\N	\N		91921297	dsfrigo@gmail.com		2015-04-16 00:00:00	6	2	6	\N	2	\N	\N	\N	146
74	LAERTO PAULINO DE CARVALHO			\N	\N	\N	\N	\N	\N	\N			laerto.logistica@gmail.com		2015-07-02 00:00:00	6	5	6	\N	2	\N	\N	\N	147
75	Prisicila e Diego - Makis			\N	\N	\N	\N	\N	\N	\N			makis.mais13@gmail.com		2015-04-22 00:00:00	5	2	5	\N	2	\N	\N	\N	148
76	Danilo			\N	\N	\N	\N	\N	\N	\N		11983598321	danilolia@hotmail.com		2015-04-23 00:00:00	6	2	6	\N	2	\N	\N	\N	149
77	FERNANDA DE OLIVEIRA CRUZ FREIRE DE SOUZA			\N	\N	\N	\N	\N	\N	\N			fernandafreiresouza@gmail.com		2015-04-28 00:00:00	4	2	4	\N	2	\N	\N	\N	151
78	Ademir			\N	\N	\N	\N	\N	\N	\N			adgoldoni@terra.com.br		2015-04-30 00:00:00	6	2	6	\N	2	\N	\N	\N	153
79	Vania Sanches			\N	\N	\N	\N	\N	\N	\N			niasanches@gmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	94
80	Dr. Tiago Paiva			\N	\N	\N	\N	\N	\N	\N	43061409	987560009	ticopaiva@gmail.com		2015-04-30 00:00:00	4	2	4	\N	2	\N	\N	\N	154
82	Herbert			\N	\N	\N	\N	\N	\N	\N			herbertfc@gmail.com		2015-05-18 00:00:00	4	2	4	\N	2	\N	\N	\N	162
83	Luis			\N	\N	\N	\N	\N	\N	\N		11971431338	doislu.sw@gmail.com		2015-05-12 00:00:00	6	2	6	\N	2	\N	\N	\N	160
84	Thais			\N	\N	\N	\N	\N	\N	\N	1122565785	11976200917	thais_eds@hotmail.com		2015-05-20 00:00:00	4	2	4	\N	2	\N	\N	\N	163
85	RENAN ANDRÉ ALVES SILVA			\N	\N	\N	\N	\N	\N	\N		972249772	renandrones@gmail.com		2015-05-12 00:00:00	6	5	6	\N	2	\N	\N	\N	161
86	Heraldo e Denise			\N	\N	\N	\N	\N	\N	\N		11987591360	heraldopalmeira@alameda.art.br		2015-05-22 00:00:00	6	2	6	\N	2	\N	\N	\N	168
87	Fabio			\N	\N	\N	\N	\N	\N	\N		984082120	f.fernandes@live.com		2015-05-25 00:00:00	6	2	6	\N	2	\N	\N	\N	169
88	Dr. Eric			\N	\N	\N	\N	\N	\N	\N		11944641121	eric.oliveiraepm@yhoo.com.br		2015-05-26 00:00:00	6	2	6	\N	2	\N	\N	\N	171
89	Luis			\N	\N	\N	\N	\N	\N	\N			lcdonatoclaudio@gmail.com		2015-10-26 00:00:00	5	\N	5	\N	2	\N	\N	\N	173
90	Lucy			\N	\N	\N	\N	\N	\N	\N	34675912	992587998	lucybfrt@gmail.com		2015-07-16 00:00:00	6	3	6	\N	2	\N	\N	\N	175
91	Sr. Vicente Berna			\N	\N	\N	\N	\N	\N	\N	011942076103	011942076103	vicente.berna@hotmail.com		2015-06-08 00:00:00	5	5	5	\N	2	\N	\N	\N	176
92	Rafael (irmão da Grabrielle da W.SOLUNTION - 2319)			\N	\N	\N	\N	\N	\N	\N		983801844	gabrielle_pacheco@hotmail.com		2015-06-12 00:00:00	5	2	5	\N	2	\N	\N	\N	178
93	Lucas Reis Gomes Solar			\N	\N	\N	\N	\N	\N	\N		11960681515	lsolar07@gmail.com		2015-06-12 00:00:00	5	2	5	\N	2	\N	\N	\N	179
94	Renato Andrade			\N	\N	\N	\N	\N	\N	\N		11976905432	renatomuch@ig.com.br		2015-06-25 00:00:00	5	2	5	\N	2	\N	\N	\N	183
95	Amauri Juqueira			\N	\N	\N	\N	\N	\N	\N	1130350600	11977005502	amaurijunqueira@itsseg.com		2015-06-19 00:00:00	5	2	5	\N	2	\N	\N	\N	185
96	Arnaldo			\N	\N	\N	\N	\N	\N	\N			arnaldo_martins@hotmail.com		2015-06-23 00:00:00	6	\N	6	\N	2	\N	\N	\N	186
97	Kim			\N	\N	\N	\N	\N	\N	\N		958766228	kimbleal@gmail.com		2015-06-24 00:00:00	6	5	6	\N	2	\N	\N	\N	187
98	Alexandre Aidas			\N	\N	\N	\N	\N	\N	\N		11953311655	alexandrenascimento@transformarh.com		2015-06-25 00:00:00	5	2	5	\N	2	\N	\N	\N	188
99	Cledson Jesus do Carmo			\N	\N	\N	\N	\N	\N	\N		986060961	cledsonsp@yahoo.com.br		2015-07-02 00:00:00	4	5	4	\N	2	\N	\N	\N	192
100	José Ricardo Schwaitzer			\N	\N	\N	\N	\N	\N	\N		11997499898	schwaitz@meucorreio.com		2015-07-03 00:00:00	6	2	6	\N	2	\N	\N	\N	193
8	Dra. Aline Ueda			\N	\N	\N	\N	\N	\N	\N		11993028903	uedaaline@hotmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	8
274	Carlos Jose Leal Junior			\N	\N	\N	\N	\N	\N	\N		11975750295	jucarleal@hotmail.com.br		2016-09-19 00:00:00	4	5	4	\N	2	\N	\N	\N	460
9	Neide			\N	\N	\N	\N	\N	\N	\N			neide.honda@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	9
10	Humberto			\N	\N	\N	\N	\N	\N	\N		999499152	humbertoabrahao@uol.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	11
11	Marcelo			\N	\N	\N	\N	\N	\N	\N			visaomarcelo@terra.com.br		2015-05-21 00:00:00	6	5	6	\N	2	\N	\N	\N	14
12	Marcelo			\N	\N	\N	\N	\N	\N	\N			visaomarcelo@terra.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	15
13	David Pastro			\N	\N	\N	\N	\N	\N	\N		954603859	davidpastro@gmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	17
14	Anderson			\N	\N	\N	\N	\N	\N	\N		963894947	andpaes@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	18
15	Cassia e André			\N	\N	\N	\N	\N	\N	\N	32050479		amartins.barros@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	19
16	Anderson e Paulo			\N	\N	\N	\N	\N	\N	\N		982547966	prp_2009@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	20
17	Professor Mark			\N	\N	\N	\N	\N	\N	\N	27046455	998807060	markyw01@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	21
18	Claudio Antonio			\N	\N	\N	\N	\N	\N	\N		993544343	clpeanho@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	22
19	Alex Eizu			\N	\N	\N	\N	\N	\N	\N		983444027	eizuka.shouji@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	23
20	Claudio			\N	\N	\N	\N	\N	\N	\N	46165827		claudiomagno19@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	24
21	Maressa Andrioli			\N	\N	\N	\N	\N	\N	\N		971084939	maressa.andrioli@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	25
22	WILLIANS DA ROCHA			\N	\N	\N	\N	\N	\N	\N			willians.rocha@hotmail.com		2015-04-28 00:00:00	5	2	5	\N	2	\N	\N	\N	150
23	Gabriel e Guilherme			\N	\N	\N	\N	\N	\N	\N		947478298	gabriel.luca16@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	26
24	Davi			\N	\N	\N	\N	\N	\N	\N			dbgmes22@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	27
25	Thalita Marques			\N	\N	\N	\N	\N	\N	\N		960242192	thalita.organizer@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	28
26	Rafael			\N	\N	\N	\N	\N	\N	\N		961654343	rmaktura@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	29
27	Fernando Tadeu Santos Lima			\N	\N	\N	\N	\N	\N	\N		979962023	technofer@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	30
28	Janine			\N	\N	\N	\N	\N	\N	\N		964565938	janine.mg@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	31
29	Gabriela			\N	\N	\N	\N	\N	\N	\N	45623140		gabriela@segeletronica.com.br		2015-03-27 00:00:00	6	7	6	\N	2	\N	\N	\N	32
30	Jaqueline da Silva Reis			\N	\N	\N	\N	\N	\N	\N		972505015	rs.jaqyelinereis@gmail.com		2015-05-19 00:00:00	6	3	6	\N	2	\N	\N	\N	57
60	Afonso			\N	\N	\N	\N	\N	\N	\N		19995248873	afonsoh306@gmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	128
61	Dr. Everton			\N	\N	\N	\N	\N	\N	\N		11987425287	tomcri@ig.com.br		2015-03-26 00:00:00	4	9	4	\N	2	\N	\N	\N	130
63	Rodrigo			\N	\N	\N	\N	\N	\N	\N		976252727	rodrineto@hotmail.com		2015-04-06 00:00:00	6	5	6	\N	2	\N	\N	\N	137
64	Dr. Dario			\N	\N	\N	\N	\N	\N	\N		976856768	dariotsjj@hotmail.com		2015-08-25 00:00:00	6	9	6	\N	2	\N	\N	\N	138
65	Dr. Enrique			\N	\N	\N	\N	\N	\N	\N		11971725449	enriquepsiquiatria@gmail.com		2015-04-07 00:00:00	6	9	6	\N	2	\N	\N	\N	139
66	Bayard			\N	\N	\N	\N	\N	\N	\N			bayarddarocha@gmail.com		2015-04-09 00:00:00	6	2	6	\N	2	\N	\N	\N	141
67	Ricardo Garcia			\N	\N	\N	\N	\N	\N	\N			ricardo.garcia@exxtrema.com.br		2015-06-30 00:00:00	5	2	5	\N	2	\N	\N	\N	89
68	Luis Gustavo			\N	\N	\N	\N	\N	\N	\N		981619900	glolli@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	132
69	Alexandra (5A CONSULTORIA)			\N	\N	\N	\N	\N	\N	\N	23444595	999528192	alexandra@globalcsc.com.br		2015-04-09 00:00:00	5	2	5	\N	2	\N	\N	\N	142
71	Andréia			\N	\N	\N	\N	\N	\N	\N		991635943	andreia-siqueira@bol.com.br		2015-04-09 00:00:00	6	5	6	\N	2	\N	\N	\N	143
31	Daniel e Jesus			\N	\N	\N	\N	\N	\N	\N		984808715	daniel.sobral@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	34
32	Izac			\N	\N	\N	\N	\N	\N	\N		970936516	izacmat@yahoo.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	58
33	Elisete e Sandra			\N	\N	\N	\N	\N	\N	\N		963634243	elisetesleite@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	59
34	Pedro Ricardo			\N	\N	\N	\N	\N	\N	\N			qualidadepedro@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	60
35	André			\N	\N	\N	\N	\N	\N	\N		11969071192	andre_muzetti@hotmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	113
36	Dra. Carolina			\N	\N	\N	\N	\N	\N	\N		996894404	carolina.galucci@yahoo.com.br		2015-03-26 00:00:00	6	1	6	\N	2	\N	\N	\N	97
37	Gustavo e Marisa			\N	\N	\N	\N	\N	\N	\N		982818377	luisgustavo.bonini@gmail.com		2015-11-18 00:00:00	6	3	6	\N	2	\N	\N	\N	69
38	Vanessa			\N	\N	\N	\N	\N	\N	\N	98958703	84885246	vanetrovoes@yahoo.com.br		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	56
39	Daniela			\N	\N	\N	\N	\N	\N	\N		986362888	danielatuluz@gmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	70
40	Alexandre			\N	\N	\N	\N	\N	\N	\N	27627640	993334532	giovanni.buratto23@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	71
41	RODRIGO DOMINGOS FERREIRA			\N	\N	\N	\N	\N	\N	\N			rd.ferreira@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	91
42	Renata			\N	\N	\N	\N	\N	\N	\N			renata@inwave.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	100
43	Alessandra			\N	\N	\N	\N	\N	\N	\N		11984321355	alespigariol@uol.com.br		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	103
44	Elenilson			\N	\N	\N	\N	\N	\N	\N	11968304599		jngessonovosconceito@hotmail.com		2015-03-27 00:00:00	6	7	6	\N	2	\N	\N	\N	102
45	Fernando			\N	\N	\N	\N	\N	\N	\N			fsergiofontes@gmail.com		2015-03-26 00:00:00	5	8	5	\N	2	\N	\N	\N	104
46	Dra. Lucia			\N	\N	\N	\N	\N	\N	\N		11973269837	lucia.accursio@terra.com.br		2015-06-30 00:00:00	6	9	6	\N	2	\N	\N	\N	107
47	Alecsandra			\N	\N	\N	\N	\N	\N	\N		11996273526	aletx@yahoo.com		2015-04-30 00:00:00	4	2	4	\N	2	\N	\N	\N	152
48	Priscila Bertoni			\N	\N	\N	\N	\N	\N	\N	986265336		priscilabertoni@gmail.com		2015-03-26 00:00:00	5	2	5	\N	2	\N	\N	\N	92
49	Wagner			\N	\N	\N	\N	\N	\N	\N		988127503	wcavalcante52@gmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	109
50	Dra. Daniele			\N	\N	\N	\N	\N	\N	\N		963540956	danicarnevalli@uol.com.br		2015-04-08 00:00:00	6	2	6	\N	2	\N	\N	\N	110
51	Giano Artur Agostini			\N	\N	\N	\N	\N	\N	\N		994257915	giano.agostini@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	112
52	Dr. Sérgio			\N	\N	\N	\N	\N	\N	\N		971892468	sergiogrupotejoelho@gmail.com		2015-06-30 00:00:00	4	9	4	\N	2	\N	\N	\N	115
53	Luis			\N	\N	\N	\N	\N	\N	\N		11987320562	mmello@octante.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	121
54	Rodolpho Sierra			\N	\N	\N	\N	\N	\N	\N	51838905		rodolpho.sierra@uol.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	118
55	GLEI DE FATIMA BONFIM			\N	\N	\N	\N	\N	\N	\N		960823839	gleifatima@hotmail.com		2015-03-26 00:00:00	6	3	6	\N	2	\N	\N	\N	122
56	Shirley			\N	\N	\N	\N	\N	\N	\N			shirleyhiga@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	123
57	Dra. Thais			\N	\N	\N	\N	\N	\N	\N		993050182	thatinha_portes@hotmail.com		2015-03-26 00:00:00	6	9	6	\N	2	\N	\N	\N	125
58	Dra. Camila			\N	\N	\N	\N	\N	\N	\N		985443635	camilagfsouza@yahoo.com.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	127
59	Simone			\N	\N	\N	\N	\N	\N	\N	1126064663		simonegoncalves.br@gmail.com		2015-03-26 00:00:00	6	5	6	\N	2	\N	\N	\N	129
62	Dr. Shajadi			\N	\N	\N	\N	\N	\N	\N		985039589			2015-03-31 00:00:00	5	9	5	\N	2	\N	\N	\N	136
1	Adriana			\N	\N	\N	\N	\N	\N	\N		986443230	acaires@hotmail.com		2015-05-20 00:00:00	6	2	6	\N	2	\N	\N	\N	1
2	Dr. José			\N	\N	\N	\N	\N	\N	\N		999925350	jamancusofilho@gmail.com		2015-03-26 00:00:00	6	9	6	\N	2	\N	\N	\N	2
3	Maicol			\N	\N	\N	\N	\N	\N	\N			maicol.peixe@brisa.org.br		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	3
4	Dr. Leonardo			\N	\N	\N	\N	\N	\N	\N			leomelo@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	4
5	Patrick			\N	\N	\N	\N	\N	\N	\N	1141132244		patrick@creci.org.br		2015-03-26 00:00:00	6	8	6	\N	2	\N	\N	\N	6
6	Alessandro Buonopane			\N	\N	\N	\N	\N	\N	\N			buonopane@terra.com.br		2015-03-26 00:00:00	2	2	2	\N	2	\N	\N	\N	5
7	Arnaldo Furtado			\N	\N	\N	\N	\N	\N	\N		11988338744	furtadoa@gmail.com		2015-03-26 00:00:00	6	2	6	\N	2	\N	\N	\N	7
70	Everton			\N	\N	\N	\N	\N	\N	\N		987425287	tomcri@ig.com.br		2015-04-14 00:00:00	6	9	6	\N	2	\N	\N	\N	145
101	Thiago Oliveira Lopes			\N	\N	\N	\N	\N	\N	\N		973643306	thiago_lopes@zootecnista.com.br		2015-07-08 00:00:00	6	5	6	\N	2	\N	\N	\N	194
102	Jorge  Luis Teixeira			\N	\N	\N	\N	\N	\N	\N		11999338124	teixeira.jorgeluis@gmail.com		2015-07-08 00:00:00	5	2	5	\N	2	\N	\N	\N	195
103	Dra. Gisele Nunes			\N	\N	\N	\N	\N	\N	\N		11982096484	gisanunes@bol.com.br		2015-07-16 00:00:00	6	2	6	\N	2	\N	\N	\N	196
104	Jeová Sergio dos Santos			\N	\N	\N	\N	\N	\N	\N	11965664176		sergio.santos61@bol.com.br		2015-07-14 00:00:00	4	5	4	\N	2	\N	\N	\N	200
105	SERGIO NARIMATSU			\N	\N	\N	\N	\N	\N	\N			sergio.engenheiro@ig.com.br		2015-07-15 00:00:00	6	2	6	\N	2	\N	\N	\N	201
106	Julino			\N	\N	\N	\N	\N	\N	\N		999815925	julino.soares@gmail.com		2015-07-21 00:00:00	6	5	6	\N	2	\N	\N	\N	204
107	Claudio			\N	\N	\N	\N	\N	\N	\N		992876117	cla01@ig.com.br		2015-07-24 00:00:00	6	5	6	\N	2	\N	\N	\N	205
108	Julio Cesar Saraiva			\N	\N	\N	\N	\N	\N	\N		119772857488	alck2002@hotmail.com		2015-08-05 00:00:00	6	2	6	\N	2	\N	\N	\N	207
109	Thiago Bezerra			\N	\N	\N	\N	\N	\N	\N		972014099	thiagobezerra915@yahoo.com.br		2015-09-03 00:00:00	6	4	6	\N	2	\N	\N	\N	208
110	Tarsila			\N	\N	\N	\N	\N	\N	\N	40638780		aiveo.tarsila@gmail.com		2015-08-11 00:00:00	6	5	6	\N	2	\N	\N	\N	210
111	Claudia Cabello			\N	\N	\N	\N	\N	\N	\N		11994504217	claudia.cabellomuros@gmail.com		2015-09-30 00:00:00	5	2	5	\N	2	\N	\N	\N	211
112	NILTON OHTA			\N	\N	\N	\N	\N	\N	\N		11983466093	n.ohta@live.com		2015-08-18 00:00:00	6	5	6	\N	2	\N	\N	\N	213
113	Bruno			\N	\N	\N	\N	\N	\N	\N	35789791		bcassenote@gmail.com		2015-09-03 00:00:00	6	3	6	\N	2	\N	\N	\N	212
114	Fabio Vieira			\N	\N	\N	\N	\N	\N	\N		11947295870	diasy.diasy@gmail.com		2015-08-19 00:00:00	6	2	6	\N	2	\N	\N	\N	214
115	Lourdes / Karime			\N	\N	\N	\N	\N	\N	\N		999663477	lurdessanchesl.2755@gmail.com		2015-08-19 00:00:00	6	5	6	\N	2	\N	\N	\N	216
116	Rodrigo			\N	\N	\N	\N	\N	\N	\N			rodrigo@pinhogomes.com.br		2015-08-21 00:00:00	4	2	4	\N	2	\N	\N	\N	217
117	Ian Vilenog			\N	\N	\N	\N	\N	\N	\N		11953229361	ianvilenog@hotmail.com		2015-09-30 00:00:00	4	5	4	\N	2	\N	\N	\N	218
118	Daniela			\N	\N	\N	\N	\N	\N	\N		11947233898	seguros@modenamotors.com.br		2015-09-30 00:00:00	6	8	6	\N	2	\N	\N	\N	219
119	SERGIO NARIMATSU			\N	\N	\N	\N	\N	\N	\N		981964198	sergio.engenheiro@ig.com.br		2015-08-27 00:00:00	6	2	6	\N	2	\N	\N	\N	220
120	Alline (Ricardo PAI)			\N	\N	\N	\N	\N	\N	\N		972729820	alline.antoquio@gmail.com		2015-09-30 00:00:00	2	5	2	\N	2	\N	\N	\N	222
121	Anna Luyza			\N	\N	\N	\N	\N	\N	\N			luyzaguiar@gmail.com		2015-09-30 00:00:00	2	7	2	\N	2	\N	\N	\N	224
122	Antonio Alexandre			\N	\N	\N	\N	\N	\N	\N		952989388	toni.oliveira81@gmail.com		2015-09-30 00:00:00	6	5	6	\N	2	\N	\N	\N	226
123	Ana			\N	\N	\N	\N	\N	\N	\N	1136631033		financeiro@stiefelmann.com.br		2015-09-30 00:00:00	4	7	4	\N	2	\N	\N	\N	227
124	Charles			\N	\N	\N	\N	\N	\N	\N		963977242	chvarraschim@vaceconsulting.com.br		2015-10-05 00:00:00	3	2	3	\N	2	\N	\N	\N	228
125	RICARDO			\N	\N	\N	\N	\N	\N	\N			ric.programador@gmail.com		2015-10-06 00:00:00	3	5	3	\N	2	\N	\N	\N	229
126	OTAVIO SIMÕES			\N	\N	\N	\N	\N	\N	\N		14998072256	otavioucdb@gmail.com		2015-10-06 00:00:00	3	2	3	\N	2	\N	\N	\N	230
127	Maria Victória			\N	\N	\N	\N	\N	\N	\N	11993858887		mvpqs@yahoo.com.br		2015-10-09 00:00:00	4	2	4	\N	2	\N	\N	\N	233
128	ANDRE CRUZ			\N	\N	\N	\N	\N	\N	\N	11992342031		andre@hdsolution.com.br		2015-10-14 00:00:00	3	5	3	\N	2	\N	\N	\N	234
129	Sr. Marcelo			\N	\N	\N	\N	\N	\N	\N	991422470	991422470	marc_a_e@hotmail.com		2015-10-19 00:00:00	2	2	2	\N	2	\N	\N	\N	235
130	IVO			\N	\N	\N	\N	\N	\N	\N			fiscalcontabiladm@bol.com.br		2015-10-20 00:00:00	3	7	3	\N	2	\N	\N	\N	236
131	Margarete			\N	\N	\N	\N	\N	\N	\N		11995503078	margarete@modeck.com.br		2015-10-20 00:00:00	4	5	4	\N	2	\N	\N	\N	237
132	Tatiana			\N	\N	\N	\N	\N	\N	\N		11987945240	kenavarro13@bol.com.br		2015-10-20 00:00:00	4	5	4	\N	2	\N	\N	\N	238
133	BELMIRO LUIZ MOREIRA			\N	\N	\N	\N	\N	\N	\N	11982233157		belmiro.luiz.moreira@hotmail.com		2015-10-23 00:00:00	3	2	3	\N	2	\N	\N	\N	239
134	Clay Rulliam			\N	\N	\N	\N	\N	\N	\N		11995110173	clay@parxtech.com.br		2015-10-29 00:00:00	3	5	3	\N	2	\N	\N	\N	241
135	Dra. Marinês			\N	\N	\N	\N	\N	\N	\N	38736201	974958188	marinescalori@hotmail.com		2015-11-04 00:00:00	3	7	3	\N	2	\N	\N	\N	243
136	José Luiz Senoi			\N	\N	\N	\N	\N	\N	\N	1132558155		jlsenoi@gmail.com		2015-10-29 00:00:00	3	5	3	\N	2	\N	\N	\N	242
137	Marcos Fernandes e Junior			\N	\N	\N	\N	\N	\N	\N	6296190511		marcosfernandesdacunha@gmail.com;		2015-11-04 00:00:00	5	2	5	\N	2	\N	\N	\N	244
138	Jonathan  Joao			\N	\N	\N	\N	\N	\N	\N		11971345013	jonatasjoao@gmail.com		2015-11-04 00:00:00	4	2	4	\N	2	\N	\N	\N	246
139	Marco Antonio T. Pedro			\N	\N	\N	\N	\N	\N	\N		11997425717			2015-11-12 00:00:00	2	5	2	\N	2	\N	\N	\N	248
140	Camila			\N	\N	\N	\N	\N	\N	\N			camila@camilakiyohara.com		2015-11-16 00:00:00	3	7	3	\N	2	\N	\N	\N	251
141	Bianca Anjos			\N	\N	\N	\N	\N	\N	\N		959840086			2015-11-25 00:00:00	3	5	3	\N	2	\N	\N	\N	253
142	Micele Durci			\N	\N	\N	\N	\N	\N	\N		949602204			2015-11-25 00:00:00	3	5	3	\N	2	\N	\N	\N	254
143	Diogo Apacerido			\N	\N	\N	\N	\N	\N	\N		981495723	 diogoaap@gmail.com		2015-11-25 00:00:00	3	5	3	\N	2	\N	\N	\N	255
144	Sergio Stefano			\N	\N	\N	\N	\N	\N	\N		944995804	sergio.stefano@gmail.com		2015-11-26 00:00:00	3	5	3	\N	2	\N	\N	\N	256
145	Maria das Graças (Mel e Hortelã)			\N	\N	\N	\N	\N	\N	\N			gracaomendes@hotmail.com		2015-12-02 00:00:00	3	2	3	\N	2	\N	\N	\N	258
146	Fernando Pacheco			\N	\N	\N	\N	\N	\N	\N		11948728152	fernando.pacheco2002@gmail.com		2015-12-02 00:00:00	3	5	3	\N	2	\N	\N	\N	259
147	Jonatan			\N	\N	\N	\N	\N	\N	\N		11952392839	jonathan3460@gmail.com		2015-12-10 00:00:00	3	5	3	\N	2	\N	\N	\N	262
148	Joel Roberto			\N	\N	\N	\N	\N	\N	\N		1199294045	joel_roberto@yahoo.com		2015-12-03 00:00:00	3	5	3	\N	2	\N	\N	\N	260
149	Renato Oliveira			\N	\N	\N	\N	\N	\N	\N		11952392839			2015-12-10 00:00:00	3	5	3	\N	2	\N	\N	\N	263
150	Fernando Machado (Baby Bello)			\N	\N	\N	\N	\N	\N	\N		968642860	fernandomachado06@yahoo.com.br		2015-12-14 00:00:00	2	5	2	\N	2	\N	\N	\N	264
151	Alessandra Spigariol			\N	\N	\N	\N	\N	\N	\N			alespigariol@uol.com.br		2015-12-16 00:00:00	2	5	2	\N	2	\N	\N	\N	265
152	Luis (Indicação Cubo)			\N	\N	\N	\N	\N	\N	\N	11967579981		luis_vtds@hotmail.com		2015-12-28 00:00:00	3	2	3	\N	2	\N	\N	\N	268
153	Airton Yokoyama			\N	\N	\N	\N	\N	\N	\N		999897940	airtoshi@yahoo.com.br		2015-12-30 00:00:00	3	\N	3	\N	2	\N	\N	\N	269
154	Richard Lopes			\N	\N	\N	\N	\N	\N	\N		993413821	richard_llopes@hotmail.com		2015-12-30 00:00:00	2	5	2	\N	2	\N	\N	\N	270
155	João dos Reis			\N	\N	\N	\N	\N	\N	\N	1123649884		occaestiloedesigner@hotmail.com		2016-05-10 00:00:00	3	5	3	\N	2	\N	\N	\N	272
156	Marcos			\N	\N	\N	\N	\N	\N	\N			marcosnark2003@hotmail.com		2016-05-10 00:00:00	3	2	3	\N	2	\N	\N	\N	273
158	Rogério			\N	\N	\N	\N	\N	\N	\N	999999666		rogeriofg.ctb@outlook.com		2016-05-10 00:00:00	3	5	3	\N	2	\N	\N	\N	275
159	Veronica			\N	\N	\N	\N	\N	\N	\N		999494008	veronicaalmeidasilva@gmail.com		2016-02-16 00:00:00	3	5	3	\N	2	\N	\N	\N	276
160	Renato Duarte			\N	\N	\N	\N	\N	\N	\N	20528955		re.duarte71@hotmail.com		2016-05-10 00:00:00	3	5	3	\N	2	\N	\N	\N	278
161	Eric			\N	\N	\N	\N	\N	\N	\N			ericfrade2012@gmail.com		2016-02-16 00:00:00	3	5	3	\N	2	\N	\N	\N	277
162	Eduardo Pérez			\N	\N	\N	\N	\N	\N	\N			ehps2000@hotmail.com		2016-09-16 00:00:00	2	5	2	\N	2	\N	\N	\N	428
163	André Tadeu			\N	\N	\N	\N	\N	\N	\N		11994961917	andre.sugawara@gmail.com		2016-08-17 00:00:00	3	5	3	\N	2	\N	\N	\N	279
164	Danielle Barcellos			\N	\N	\N	\N	\N	\N	\N		991779452	danielle_barcellos@hotmail.com		2016-06-03 00:00:00	3	5	3	\N	2	\N	\N	\N	280
165	Gilberto Gonçalves			\N	\N	\N	\N	\N	\N	\N		949998596	gilberto.asya@gmail.com		2016-03-24 00:00:00	3	5	3	\N	2	\N	\N	\N	281
166	Wellington			\N	\N	\N	\N	\N	\N	\N		968036874	wellingtonada01602@gmail.com		2016-03-24 00:00:00	4	5	4	\N	2	\N	\N	\N	283
167	Guilherme Ramos			\N	\N	\N	\N	\N	\N	\N		941364466	guiramello@hotmail.com		2016-05-10 00:00:00	3	5	3	\N	2	\N	\N	\N	285
168	Carina Teixeira			\N	\N	\N	\N	\N	\N	\N			carina.lacerda@hotmail.com		2016-05-10 00:00:00	3	5	3	\N	2	\N	\N	\N	287
169	Edgard Serafim			\N	\N	\N	\N	\N	\N	\N		983888851	edgard_serafim@hotmail.com		2016-05-10 00:00:00	3	5	3	\N	2	\N	\N	\N	286
170	Luis Silva (DOISLU)			\N	\N	\N	\N	\N	\N	\N			doislu.sw@gmail.com		2016-02-10 00:00:00	3	7	3	\N	2	\N	\N	\N	288
171	Dr. Marcelo			\N	\N	\N	\N	\N	\N	\N		11999107980	marcelo.oranges.filho@gmail.com		2016-03-28 00:00:00	5	2	5	\N	2	\N	\N	\N	289
172	Dr. Andrei Hilario Catarino			\N	\N	\N	\N	\N	\N	\N		11999597540	andreicatarino@yahoo.com.br		2016-03-28 00:00:00	5	5	5	\N	2	\N	\N	\N	290
174	Adailton Rodrigues			\N	\N	\N	\N	\N	\N	\N		973596064	adailtonsantos.miami@gmail.com		2016-03-28 00:00:00	3	5	3	\N	2	\N	\N	\N	297
175	Raul Ramas			\N	\N	\N	\N	\N	\N	\N			raulramas@hotmail.com		2016-03-28 00:00:00	3	5	3	\N	2	\N	\N	\N	294
177	Robson Souza			\N	\N	\N	\N	\N	\N	\N	55231861	982860407	familiamoreiraleite@hotmail.com		2016-06-17 00:00:00	3	3	3	\N	2	\N	\N	\N	299
178	Gabrila MedSeg			\N	\N	\N	\N	\N	\N	\N			gabriela@medsegsolucoes.com.br		2016-03-07 00:00:00	3	5	3	\N	2	\N	\N	\N	372
179	Luiz Carlos Junior			\N	\N	\N	\N	\N	\N	\N		930046969	luiz.jr@gmail.com		2016-02-26 00:00:00	4	3	4	\N	2	\N	\N	\N	303
180	Fabio			\N	\N	\N	\N	\N	\N	\N	945245312		fabio.loboo@hotmail.com		2016-11-10 00:00:00	2	5	2	\N	2	\N	\N	\N	490
181	Raphael de Oliveira Gomes			\N	\N	\N	\N	\N	\N	\N	32270835		cursoverus@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	304
182	Cosmo Santos Brito			\N	\N	\N	\N	\N	\N	\N	995614081		tecnico.cosmobrito@gmail.com		2016-02-26 00:00:00	3	3	3	\N	2	\N	\N	\N	305
183	Carolina Lujan | Eliana Gomez			\N	\N	\N	\N	\N	\N	\N		964037424	carolujan22@hotmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	306
184	Luis Augusto			\N	\N	\N	\N	\N	\N	\N		991919277	luis-pinheiro@uol.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	307
185	Jeronimo Rodrigo da Costa			\N	\N	\N	\N	\N	\N	\N		983801762	costa.rodrigo@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	308
186	Ivan Francisco da Silva Jr.			\N	\N	\N	\N	\N	\N	\N	58148733	985931668	pecastotalcontato@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	309
187	Itamar Nascimento			\N	\N	\N	\N	\N	\N	\N	941709572	983750419	itamarnaslu@hotmail.com		2016-02-26 00:00:00	3	3	3	\N	2	\N	\N	\N	310
188	Valdir Henrique da Cunha			\N	\N	\N	\N	\N	\N	\N		983653835	valdir.hc@ig.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	311
189	Ezequiel Rafael Souza de Lima			\N	\N	\N	\N	\N	\N	\N	48235756	941034517	wreautomotivoe@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	312
190	Marcelo Lemos			\N	\N	\N	\N	\N	\N	\N		982674511	mscarillo@oul.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	313
191	Marcelo Lemos			\N	\N	\N	\N	\N	\N	\N		982674511	mscarillo@oul.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	314
192	Luiz Cláudio			\N	\N	\N	\N	\N	\N	\N		963292460	lilabrasill@hotmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	315
194	Marcelo Monteiro			\N	\N	\N	\N	\N	\N	\N	45816370	999645505	mamonte1966@gmail.com		2016-11-09 00:00:00	2	3	2	\N	2	\N	\N	\N	317
196	Lucas Denifry da Silva			\N	\N	\N	\N	\N	\N	\N		997889442	denifry8083@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	320
197	Marcelo Erivelton			\N	\N	\N	\N	\N	\N	\N		981580387	marcelo.minerato@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	321
198	Eduardo Levado			\N	\N	\N	\N	\N	\N	\N		986723953	agelevado@uol.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	322
199	Hellen Sacco			\N	\N	\N	\N	\N	\N	\N		19997471097	hasacco@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	323
200	Jorge Popak			\N	\N	\N	\N	\N	\N	\N	47040313	964712073	jorge.popak@gmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	324
201	Allan | Caio			\N	\N	\N	\N	\N	\N	\N	947744763	940201477	allan.gois@hotmail.com		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	327
202	Xristos Tsouras			\N	\N	\N	\N	\N	\N	\N		981639677	xgt@uol.com.br		2016-02-26 00:00:00	2	3	2	\N	2	\N	\N	\N	329
203	Magali			\N	\N	\N	\N	\N	\N	\N		955525134	magamp@terra.com.br		2016-02-26 00:00:00	3	2	3	\N	2	\N	\N	\N	334
204	Nazza Florentino			\N	\N	\N	\N	\N	\N	\N		944536825	nazzaflorentino@gmail.com		2016-02-26 00:00:00	3	3	3	\N	2	\N	\N	\N	337
205	Americo Brilhante			\N	\N	\N	\N	\N	\N	\N			americobrilhante@gmail.com		2016-02-26 00:00:00	2	2	2	\N	2	\N	\N	\N	338
206	Fábio Garbini			\N	\N	\N	\N	\N	\N	\N		994385132	fabio@garbini.net		2016-03-28 00:00:00	2	5	2	\N	2	\N	\N	\N	349
207	Marcelo Reich			\N	\N	\N	\N	\N	\N	\N			mreicher@uol.com.br;mreicher@hqiconsulto		2016-06-17 00:00:00	5	2	5	\N	2	\N	\N	\N	350
208	Camila Tobias			\N	\N	\N	\N	\N	\N	\N			kayeras@hotmail.com		2016-03-01 00:00:00	3	5	3	\N	2	\N	\N	\N	351
209	Nilson Aguiar			\N	\N	\N	\N	\N	\N	\N		982445500	nasouza1@gmail.com		2016-03-01 00:00:00	3	3	3	\N	2	\N	\N	\N	352
210	Welington Cardoso			\N	\N	\N	\N	\N	\N	\N		985058675	welington@systicon.com.br		2016-03-01 00:00:00	3	3	3	\N	2	\N	\N	\N	354
211	Cleber Ely Moller			\N	\N	\N	\N	\N	\N	\N	29226999		cleber.moller@icloud.com		2016-03-01 00:00:00	2	3	2	\N	2	\N	\N	\N	355
212	Valeria			\N	\N	\N	\N	\N	\N	\N			valejutai@hotmail.com		2016-03-03 00:00:00	2	2	2	\N	2	\N	\N	\N	365
213	Silvia Balluminut			\N	\N	\N	\N	\N	\N	\N		11985847930	s.ballaminut@globo.com		2016-03-02 00:00:00	3	5	3	\N	2	\N	\N	\N	362
215	Shirley Elina			\N	\N	\N	\N	\N	\N	\N			shirleyelina@hotmail.com		2016-08-17 00:00:00	2	5	2	\N	2	\N	\N	\N	364
216	Talita			\N	\N	\N	\N	\N	\N	\N		11996621613	talita_nog@hotmail.com		2016-06-03 00:00:00	4	2	4	\N	2	\N	\N	\N	366
218	Fábio Alves			\N	\N	\N	\N	\N	\N	\N			ffalves@gmail.com		2016-03-04 00:00:00	2	3	2	\N	2	\N	\N	\N	368
219	Fernando Edson			\N	\N	\N	\N	\N	\N	\N			porto.edson@bol.com.br		2016-06-03 00:00:00	3	5	3	\N	2	\N	\N	\N	381
220	Luiz Carlos			\N	\N	\N	\N	\N	\N	\N		971756167	lcarlos976@terra.com.br		2016-03-04 00:00:00	2	3	2	\N	2	\N	\N	\N	369
221	Antunes Santos			\N	\N	\N	\N	\N	\N	\N		991447247	antunes.baiano@hotmail.com		2016-03-08 00:00:00	6	5	6	\N	2	\N	\N	\N	373
222	Lucia			\N	\N	\N	\N	\N	\N	\N	973341169	996212139	sindilucia@uol.com.br		2016-03-04 00:00:00	3	4	3	\N	2	\N	\N	\N	370
223	Vagner Zanzin			\N	\N	\N	\N	\N	\N	\N	22289157	984186331	vagner.zanzin@hotmail.com		2016-03-04 00:00:00	6	3	6	\N	2	\N	\N	\N	371
224	Luiz Coelho			\N	\N	\N	\N	\N	\N	\N		999161873	luiz.a.coelho@gmail.com		2016-03-08 00:00:00	3	5	3	\N	2	\N	\N	\N	374
225	Elisangela Franceschi			\N	\N	\N	\N	\N	\N	\N		954710877	effranceschi@gmail.com		2016-03-11 00:00:00	3	5	3	\N	2	\N	\N	\N	376
226	Magali			\N	\N	\N	\N	\N	\N	\N			magamp@terra.com.br		2016-06-03 00:00:00	2	2	2	\N	2	\N	\N	\N	380
227	Dr. Eric			\N	\N	\N	\N	\N	\N	\N		11944641121	eric.oliveriraepm@yahoo.com.br		2016-03-15 00:00:00	2	2	2	\N	2	\N	\N	\N	382
228	Raphael			\N	\N	\N	\N	\N	\N	\N			raphael.tardioli@terra.com.br		2016-03-17 00:00:00	2	2	2	\N	2	\N	\N	\N	385
229	Andréa Faro			\N	\N	\N	\N	\N	\N	\N	992359089		andreafaro2008@hotmail.com		2016-03-28 00:00:00	3	5	3	\N	2	\N	\N	\N	387
230	Viviane Minozzo			\N	\N	\N	\N	\N	\N	\N			alcantaravivi@yahoo.com.br		2016-03-31 00:00:00	3	5	3	\N	2	\N	\N	\N	391
231	André			\N	\N	\N	\N	\N	\N	\N		11982088830	contato@zazproducoes.com		2016-06-03 00:00:00	3	5	3	\N	2	\N	\N	\N	393
232	Marcio dal Pozzo			\N	\N	\N	\N	\N	\N	\N		15997220064	 marcio.dalpozzo@gmail.com		2016-08-25 00:00:00	3	5	3	\N	2	\N	\N	\N	395
233	Dra. Milena			\N	\N	\N	\N	\N	\N	\N		04196830654	mikozonoe@gmail.com		2016-03-28 00:00:00	3	2	3	\N	2	\N	\N	\N	388
234	Jorge			\N	\N	\N	\N	\N	\N	\N		980595555	arqgeral@gmail.com		2016-04-15 00:00:00	4	3	4	\N	2	\N	\N	\N	394
235	Elton Rodrigues			\N	\N	\N	\N	\N	\N	\N		970579887	eltonrs19@gmail.com		2016-08-25 00:00:00	3	5	3	\N	2	\N	\N	\N	397
236	João Paulo D'Elboux			\N	\N	\N	\N	\N	\N	\N		974406417	joao@ibicoara.com		2016-04-15 00:00:00	2	3	2	\N	2	\N	\N	\N	398
237	Melina Souza			\N	\N	\N	\N	\N	\N	\N		996243134	souzamelina@hotmail.com		2016-08-17 00:00:00	3	5	3	\N	2	\N	\N	\N	399
238	André Toledo			\N	\N	\N	\N	\N	\N	\N		31992772245	luisandre1981@gmail.com		2016-04-18 00:00:00	3	5	3	\N	2	\N	\N	\N	400
240	Adonai Rossato			\N	\N	\N	\N	\N	\N	\N		982268858	adonis.rossato@gmail.com		2016-06-03 00:00:00	2	7	2	\N	2	\N	\N	\N	404
241	Alessandra			\N	\N	\N	\N	\N	\N	\N		11981252544	alekiese@yahoo.com.br		2016-04-28 00:00:00	6	5	6	\N	2	\N	\N	\N	405
242	Flavio Soares			\N	\N	\N	\N	\N	\N	\N		953329552	filippini.ff@gmail.com		2016-06-03 00:00:00	2	7	2	\N	2	\N	\N	\N	406
243	Felipe			\N	\N	\N	\N	\N	\N	\N		19999783900	filippini.ff@gmail.com		2016-08-25 00:00:00	2	2	2	\N	2	\N	\N	\N	408
244	Dr. Sergio Façanha			\N	\N	\N	\N	\N	\N	\N					2016-05-05 00:00:00	4	2	4	\N	2	\N	\N	\N	409
214	Felipe Alves Costa	           		Rua					        	\N		973456757	felipe.costa@afautomacao.com.br		2016-03-02 00:00:00	4	19	4	\N	2	\N		\N	363
245	Priscila			\N	\N	\N	\N	\N	\N	\N		11980544535	priepm74@gmail.com		2016-08-17 00:00:00	3	7	3	\N	2	\N	\N	\N	410
246	Dr. Leandro			\N	\N	\N	\N	\N	\N	\N		11983887443	leandro.coutoaguiar@gmail.com		2016-06-17 00:00:00	4	2	4	\N	2	\N	\N	\N	411
247	Carlos			\N	\N	\N	\N	\N	\N	\N	11979786266		acarlos101@yahoo.com.br		2016-08-25 00:00:00	4	5	4	\N	2	\N	\N	\N	413
248	Danilo Devecchi			\N	\N	\N	\N	\N	\N	\N	981653515		danilo.devecchi@gmail.com		2016-06-07 00:00:00	2	3	2	\N	2	\N	\N	\N	414
250	Welington Cardoso			\N	\N	\N	\N	\N	\N	\N			welington@systicon.com.br		2016-06-02 00:00:00	2	3	2	\N	2	\N	\N	\N	418
251	Fabio			\N	\N	\N	\N	\N	\N	\N			diasy.diasy@gmail.com		2016-06-09 00:00:00	2	2	2	\N	2	\N	\N	\N	422
252	Claudinei			\N	\N	\N	\N	\N	\N	\N	47439409		ovogaspar@yahoo.com.br		2016-06-15 00:00:00	2	5	2	\N	2	\N	\N	\N	425
253	Maicon			\N	\N	\N	\N	\N	\N	\N	987489030		maicon_vencersempre@hotmail.com		2016-06-07 00:00:00	2	5	2	\N	2	\N	\N	\N	420
254	Silmara Cardoso			\N	\N	\N	\N	\N	\N	\N		984217125	silmara.rng@hotmail.com		2016-06-15 00:00:00	2	5	2	\N	2	\N	\N	\N	426
255	Adenilson			\N	\N	\N	\N	\N	\N	\N		11980167775	adenilsonatle@hotmail.com		2016-08-25 00:00:00	2	5	2	\N	2	\N	\N	\N	427
256	Alexandre			\N	\N	\N	\N	\N	\N	\N		11984458295	alefcoutinho111@gmail.com		2016-08-25 00:00:00	4	2	4	\N	2	\N	\N	\N	431
257	Marilene do Prado			\N	\N	\N	\N	\N	\N	\N	11998646324		maripgomes7@yahoo.com.br		2016-08-25 00:00:00	2	5	2	\N	2	\N	\N	\N	434
258	Marcus Vinicius			\N	\N	\N	\N	\N	\N	\N			mviniciusmp@terra.com.br		2016-06-27 00:00:00	2	2	2	\N	2	\N	\N	\N	433
259	Francini Queiroz de Freitas			\N	\N	\N	\N	\N	\N	\N	975903402		fran_rosatribal@hotmail.com		2016-09-16 00:00:00	2	5	2	\N	2	\N	\N	\N	441
260	Dr. Bruno			\N	\N	\N	\N	\N	\N	\N	971095122		baarossini@gmail.com		2016-09-29 00:00:00	6	5	6	\N	2	\N	\N	\N	442
261	Dra. Renata Souza			\N	\N	\N	\N	\N	\N	\N	971095122		souzacuri@yahoo.com.br		2016-09-16 00:00:00	2	5	2	\N	2	\N	\N	\N	443
262	Delmara Pereira da Silva			\N	\N	\N	\N	\N	\N	\N	957565448		demarapereirasilva@hotmail.com		2016-09-29 00:00:00	2	5	2	\N	2	\N	\N	\N	447
263	Ana dos Santos			\N	\N	\N	\N	\N	\N	\N	1126642680	11944649449	anasantossilvasantos@outlook.com		2016-09-29 00:00:00	2	5	2	\N	2	\N	\N	\N	450
264	João Felipe			\N	\N	\N	\N	\N	\N	\N		11988172080	joao.felipe@gruposinal.com		2016-08-09 00:00:00	2	5	2	\N	2	\N	\N	\N	451
265	Emerson de Souza Pereira Medina			\N	\N	\N	\N	\N	\N	\N		11968470013	messitomedina@gmail.com		2016-09-16 00:00:00	2	3	2	\N	2	\N	\N	\N	452
266	Rodolfo Cantarim			\N	\N	\N	\N	\N	\N	\N	11993400889		rocanta@gmail.com		2016-09-16 00:00:00	3	7	3	\N	2	\N	\N	\N	454
267	Erisson Tsubaki			\N	\N	\N	\N	\N	\N	\N		999004556	erissonet@gmail.com		2016-09-16 00:00:00	3	7	3	\N	2	\N	\N	\N	455
268	Valdete dos Santos Ribeiro			\N	\N	\N	\N	\N	\N	\N	1124251844		passoswesley@yahoo.com.br		2016-08-17 00:00:00	2	5	2	\N	2	\N	\N	\N	453
269	Aliny Moreira Bernardino			\N	\N	\N	\N	\N	\N	\N	959454232		alinymoreira2008@hotmail.com		2016-09-29 00:00:00	4	5	4	\N	2	\N	\N	\N	456
270	Márcio Manoel			\N	\N	\N	\N	\N	\N	\N	944696071		marcio_lima_@hotmail.com		2016-09-16 00:00:00	2	5	2	\N	2	\N	\N	\N	459
271	Dr. Joaquim			\N	\N	\N	\N	\N	\N	\N		11989007123	joaquimbastosneto@gmail.com		2016-09-20 00:00:00	2	2	2	\N	2	\N	\N	\N	461
272	Camila itlean.com.br			\N	\N	\N	\N	\N	\N	\N		11983959169	camila.martins@itlean.com.br		2016-09-23 00:00:00	4	8	4	\N	2	\N	\N	\N	463
275	Maria do Socorro			\N	\N	\N	\N	\N	\N	\N	1155830199	11984696877	emporiopapachibe@gmail.com		2016-09-27 00:00:00	2	7	2	\N	2	\N	\N	\N	464
276	Sandra Marostica			\N	\N	\N	\N	\N	\N	\N	11983545480		sandra_marostica@hotmail.com		2016-10-06 00:00:00	5	7	5	\N	2	\N	\N	\N	465
277	Helcio			\N	\N	\N	\N	\N	\N	\N					2016-10-17 00:00:00	5	2	5	\N	2	\N	\N	\N	467
279	Silvane			\N	\N	\N	\N	\N	\N	\N			silvianecristina@yahoo.com.br		2016-10-17 00:00:00	3	5	3	\N	2	\N	\N	\N	469
280	Rodrigo Bortolini			\N	\N	\N	\N	\N	\N	\N	11991993662		cassiobortolini@hotmail.com		2016-10-20 00:00:00	2	5	2	\N	2	\N	\N	\N	471
282	Alan Gesse Maciel			\N	\N	\N	\N	\N	\N	\N	975425707		alan.coordenador.ti@servicepremium.com.b		2016-10-25 00:00:00	2	7	2	\N	2	\N	\N	\N	475
283	Marcelo F. Marchese			\N	\N	\N	\N	\N	\N	\N	975857772	99199728	marco.marchese@terra.com.br		2016-10-25 00:00:00	2	2	2	\N	2	\N	\N	\N	476
284	Oscar Kawati			\N	\N	\N	\N	\N	\N	\N		11986219922	oscar.kawati@gmail.com		2016-10-27 00:00:00	4	5	4	\N	2	\N	\N	\N	479
285	Leonardo			\N	\N	\N	\N	\N	\N	\N	996223021		leobaena@yahoo.com.br		2016-10-25 00:00:00	2	2	2	\N	2	\N	\N	\N	477
286	Regiane Rodrigues Carvalho			\N	\N	\N	\N	\N	\N	\N		940237629	regianee@uol.com.br		2016-11-03 00:00:00	2	5	2	\N	2	\N	\N	\N	478
288	João Manuel O. B. Antunes			\N	\N	\N	\N	\N	\N	\N		968160895	jbserpente@gmail.com		2016-11-03 00:00:00	2	5	2	\N	2	\N	\N	\N	481
289	Daiciana Adame Lopes			\N	\N	\N	\N	\N	\N	\N			daiciana_adame@hotmail.com		2016-11-01 00:00:00	2	5	2	\N	2	\N	\N	\N	483
290	Melquisedec Paulo Santana			\N	\N	\N	\N	\N	\N	\N	965471165		melquesedecpaulo@gmail.com		2016-10-28 00:00:00	2	5	2	\N	2	\N	\N	\N	482
291	Gilberto			\N	\N	\N	\N	\N	\N	\N	984443913		crvigo@terra.com.br		2016-11-01 00:00:00	2	7	2	\N	2	\N	\N	\N	484
292	Andreia			\N	\N	\N	\N	\N	\N	\N			deia_bene@hotmail.com		2016-11-01 00:00:00	2	2	2	\N	2	\N	\N	\N	485
293	Richard dos Santos de Castro			\N	\N	\N	\N	\N	\N	\N		940450869	corp.copoc@gmail.com		2016-11-08 00:00:00	2	5	2	\N	2	\N	\N	\N	488
294	Maria Sandra de Araújo			\N	\N	\N	\N	\N	\N	\N	39855746	976254070	visgraf@uol.com.br		2016-11-08 00:00:00	2	5	2	\N	2	\N	\N	\N	489
295	Andreia Lucia Rodrigues			\N	\N	\N	\N	\N	\N	\N	970562614		alrs.tecsegtrabalho@gmail.com		2016-11-16 00:00:00	2	5	2	\N	2	\N	\N	\N	493
296	Eduardo Jonatas Landi			\N	\N	\N	\N	\N	\N	\N	976991762		eduardolandi2@gmail.com		2016-11-17 00:00:00	2	5	2	\N	2	\N	\N	\N	494
297	Ana Paula			\N	\N	\N	\N	\N	\N	\N			naniraccursio@gmail.com		2016-11-21 00:00:00	2	5	2	\N	2	\N	\N	\N	496
298	Leandro Santana			\N	\N	\N	\N	\N	\N	\N	954122822		leandros.melo@icloud.com		2016-11-24 00:00:00	2	5	2	\N	2	\N	\N	\N	498
299	Lucas Fernando Frazão			\N	\N	\N	\N	\N	\N	\N		994450009	lucas.fpersonal@hotmail.com		2016-11-29 00:00:00	2	5	2	\N	2	\N	\N	\N	500
300	James Magliaro			\N	\N	\N	\N	\N	\N	\N		962521634	jamesmkt1@gmail.com		2016-11-24 00:00:00	2	5	2	\N	2	\N	\N	\N	499
301	Dr. Henrique			\N	\N	\N	\N	\N	\N	\N	11961487550		henriqueproenca@yahoo.com.br		2016-12-08 00:00:00	2	2	2	\N	2	\N	\N	\N	502
302	Vanessa			\N	\N	\N	\N	\N	\N	\N			vanessa7al@hotmail.com		2016-12-20 00:00:00	2	2	2	\N	2	\N	\N	\N	504
303	Alberto Araújo			\N	\N	\N	\N	\N	\N	\N			albertoaraujo60@gmail.com		2016-12-21 00:00:00	3	5	3	\N	2	\N	\N	\N	505
305	Andre Schaumburg			\N	\N	\N	\N	\N	\N	\N	32662136	999063552	alcschaumburg@gmail.com		2016-12-14 00:00:00	2	5	2	\N	2	\N	\N	\N	503
306	Lucas Firmino Costa Sousa			\N	\N	\N	\N	\N	\N	\N		954798765	lucas.firmino1984@gmail.com		2016-12-20 00:00:00	3	5	3	\N	2	\N	\N	\N	507
321	Ana Carolina Pereira Barbosa da Silva	           		Rua					        	3813	4357-2339		aninhalhpgavioes@hotmail.com		2017-01-26 10:39:20.264	2	5	2	3	2	\N	\N	\N	\N
322	Arnaldo de Souza Amaral	           		Rua					        	3831		98880-5999	arnaldoamaral2009@hotmail.com		2017-01-26 10:44:59.054	2	5	2	3	2	\N	\N	\N	565
249	Marina (Sequenza)			\N	\N	\N	\N	\N	\N	\N		11986161019	marina.marcassa@sequenza.com.br		2016-06-07 00:00:00	5	2	5	\N	2	\N	\N	\N	416
307	Roberio José Silva dos Santos			\N	\N	\N	\N	\N	\N	\N		953863567	roberiosantos1980@gmail.com		2016-12-22 00:00:00	2	5	2	\N	2	\N	\N	\N	508
328	Jose Roberto Pini	           		Rua					        	\N	3064-6614	97336-9359	jrtpini@gmail.com		2017-02-03 08:52:54.907	2	5	2	3	2	\N		\N	519
329	Fernando (Sequenza)	           		Rua	Rua José Fernandes Lobo		85	Parque São Domingos	        	3831	3567-5050	99270-6627	fernando.lauria@sequenza.com.br		2017-02-03 15:54:37.262	2	2	5	3	\N	\N		\N	520
331	Dr. Luciana	           		Rua					        	\N	19 981067777		luciana.nito@gmail.com		2017-02-06 15:13:09.05	4	4	4	3	2	\N		\N	521
333	Renata Breda	           		Rua					        	\N			renata@octante.com.br		2017-02-08 11:51:52.463	2	10	2	2	2	\N		\N	\N
278	Tainah Freitas Netto	           		Rua					        	\N		97113-2686	tainahfreitasnetto@gmail.com		2016-10-17 00:00:00	4	2	4	\N	2	\N		\N	468
332	Marssella	           		Rua					        	3831		98107-4407	marssella_12@hotmail.com		2017-02-07 14:56:03.632	2	2	2	3	2	\N		\N	523
334	David Souza da Silva	           		Rua					        	3831		96543-2653	davidrhuan2016@gmail.com		2017-02-14 11:11:19.291	2	5	2	3	2	\N		\N	525
337	Marcio Cruz	           		Rua					        	3831		98212-8388	marciocruz12345@gmail.com		2017-02-15 17:35:15.688	2	11	2	3	2	\N		\N	\N
336	Felippe Pereira 	           		Rua					        	\N	(11) 3197-6533	99271-6693	felippe@opinioes-verificadas.com.br		2017-02-15 15:09:02.853	3	5	3	3	2	\N		\N	527
340	Ligia	           		Rua					        	3831		99939-6037	ligiaisogai@hotmail.com		2017-02-20 11:52:59.275	2	11	3	3	2	\N		\N	532
339	Cecilia	           		Rua					        	\N		11 993431842	cecihara@hotmail.com		2017-02-17 16:09:15.53	3	7	3	3	2	\N		\N	531
343	Fabiana	           		Rua					        	3831		98565-1256	fabiana.nogb@gmail.com 		2017-02-24 15:14:09.538	4	11	4	3	2	\N		\N	541
344	Marcos Carvalho	           		Rua					        	\N	1197576-7064	1197576-7064	marcoscarvalho77@bol.com.br		2017-02-24 17:01:00.506	3	11	3	3	\N	\N		\N	535
345	Thiago Tadeu dos Santos	           		Rua					        	\N	7914-5608	66635-1238	thiagosantos74@hotmail.com		2017-03-01 08:54:06.336	2	5	2	3	2	\N		\N	\N
341	Iara Scheiner	           		Rua					        	3803	4547-1948		iara@vibcorretora.com.br	http://www.vibcorretora.com.br/	2017-02-21 15:24:19.16	4	11	4	4	2	\N		\N	533
346	Guilherme	           		Rua					        	3831		93805-4521	guilherme.k@creci.org.br		2017-03-01 10:31:42.486	2	11	2	\N	2	\N		\N	\N
347	Sandro Jesus do Nascimento	           		Rua					        	3831		8063-1614	sandro01nasc@hotmail.com		2017-03-01 10:33:17.167	2	11	2	3	2	\N		\N	\N
348	Rubens	           		Rua					        	3831	4585-8577		binhohg12@gmail.com		2017-03-01 10:34:47.897	2	11	2	3	2	\N		\N	\N
349	Ana 	           		Rua					        	\N		985517029	egusfotografia@gmail.com		2017-03-01 11:07:39.533	3	11	3	\N	2	\N		\N	537
350	Diego	           		Rua					        	\N	4305-3728		ariosvaldocunha@hotmail.com		2017-03-02 14:02:00.519	3	11	3	3	2	\N		\N	539
351	Willyman	           		Rua					        	3831			willymancastro@hotmail.com		2017-03-06 09:37:12.932	2	11	2	3	2	\N		\N	540
352	Edilene Gonçalves	           		Rua					        	\N	3611-1445		lelesn321@gmail.com		2017-03-06 10:27:49.718	3	11	3	3	2	\N		\N	538
353	Helena Carmo	           		Rua					        	\N		971178340	helena_c_carmo@hotmail.com		2017-03-06 17:56:11.788	3	5	3	3	2	\N		\N	\N
354	Vilton de Jesus Senhorinho 	           		Rua					        	3831		96241-3926	viltonsorriso@gmail.com		2017-03-10 11:35:27.242	2	11	2	3	2	\N		\N	\N
355	Gabriela	           		Rua					        	3612			lu2015.gabriela@gmail.com		2017-03-10 17:21:07.118	2	11	2	3	2	\N		\N	542
356	Ana Julia	           		Rua					        	\N			anajulia.batta@gmail.com 		2017-03-13 16:13:27.043	3	11	3	3	2	\N		\N	543
357	Dr.  Josiane	           		Rua					        	3831		11981757608	jm.negrao@uol.com.br,obasitala42@gmail.com		2017-03-15 15:49:21.562	4	9	4	4	2	\N		\N	\N
358	Ediones	           		Rua					        	3831		968667131 	NÃO TEM		2017-03-16 11:41:10.588	4	11	4	\N	2	\N		\N	545
359	Milena	           		Rua					        	3831		98243-2314	mimi_mi_l@hotmail.com		2017-03-16 16:58:06.277	2	11	2	3	2	\N		\N	\N
360	Rodrigo Zanelato	           		Rua					        	\N			rodrigo.zanelato@hotmail.com		2017-03-20 08:38:03.107	3	11	3	3	2	\N		\N	\N
361	Leila Regina	           		Rua					        	3803		97498-5388	leilareginabia@hotmail.com		2017-03-20 09:55:36.933	2	11	2	3	2	\N		\N	\N
363	Ian Petrie	           		Rua					        	3831		99514-8379 	diretacticalgear@gmail.com		2017-03-20 13:45:46.547	2	11	2	3	2	\N		\N	\N
364	Ana Cristina	           		Rua					        	\N		3799-4700	financeiro@luz-ef.com		2017-03-28 11:24:56.594	4	\N	4	3	\N	\N		\N	546
366	Leila	           		Rua					        	\N	11 97498-5388		leilareginabia@hotmail.com		2017-03-28 11:54:26.181	4	11	4	\N	2	\N		\N	548
367	Mércio Ribella Jr 	           		Rua					        	3728	13 98122-4315		mercioribellajrbilstein@hotmail.com		2017-03-29 14:23:30.087	2	11	2	4	2	\N		\N	\N
368	Fábio da Silva Rodrigues 	           		Rua					        	\N		96787-8584 	fabiopaulrivet1@gmail.com 		2017-04-04 15:37:55.453	2	11	2	3	2	\N		\N	\N
369	Fabiana Monteiro	           		Rua					        	3831		96808-9146 	fbmmonteiro@hotmail.com		2017-04-06 11:04:54.08	2	11	2	3	2	\N		\N	\N
370	CARLOS HENRIQUE COIMBRA JACON	           		Rua					        	\N		94141-8081	'carloshenriquecoimbrajacon@yahoo.com.br'		2017-04-10 14:47:58.769	4	2	4	\N	7	\N		\N	551
371	José Weliton Basílio da Silva	           		Rua					        	3526		98534-9074	welitonbasilio30@gmail.com		2017-04-10 14:50:06.306	2	11	2	3	2	\N		\N	553
373	Francisco das Chagas Silva Santos	           		Rua					        	\N		94920-1080	estampariafrancisco@gmail.com		2017-04-17 08:29:05.413	2	11	2	\N	2	\N		\N	\N
374	Julio Cesar Martins de Souza	           		Rua					        	3831		96480-4839	julio@cesarjulio.com		2017-04-18 10:39:23.28	2	11	2	3	2	\N		\N	557
375	Liliane	           		Rua					        	3803		96151-7100	lilianebabini@terra.com.br		2017-04-18 11:07:27.643	2	11	2	3	2	\N		\N	558
376	Omar Toral	           		Rua					        	\N		11-947085627	otoral@dons.usfca.edu		2017-05-03 17:39:49.108	3	11	3	3	2	\N		\N	559
342	Nilton	           		Rua					        	3831	5927-4717	11 94834-8974	Não tem		2017-02-22 13:42:28.063	2	11	4	3	2	\N		\N	536
335	Mário César da Silva Quadro	           		Rua					        	\N		98389-8284	mario.c.s.quadro@gmail.com		2017-02-14 13:50:36.961	2	11	2	3	2	\N		\N	526
377	Dr. Marcelo Nishiyama	           		Rua					        	\N		11 968747899	marcelobp@cardiol.br		2017-05-05 08:21:21.146	3	2	3	3	2	\N		\N	560
81	Marina			\N	\N	\N	\N	\N	\N	\N		11983264141	mapremaom@gmail.com		2015-05-12 00:00:00	4	9	4	\N	2	\N	\N	\N	155
176	Dr. Gerson			\N	\N	\N	\N	\N	\N	\N		11969951177	consultoriacan@hotmail.com		2016-03-28 00:00:00	4	5	4	\N	2	\N	\N	\N	298
365	Rodrigo Zanelato	           		Rua					        	\N			 rodrigo.zanelato@hotmail.com		2017-03-28 11:39:58.011	4	11	4	\N	2	\N		\N	547
379	Danielle	           		Rua					        	\N		11989897800	daniele.volpe@hqiconsultoria.com.br		2017-05-09 11:19:36.96	4	2	4	3	2	\N		\N	561
380	Daniel 	           		Rua					        	\N		98196-2889	daniel_barban@hotmail.com		2017-05-09 16:17:41.439	3	2	3	3	2	\N		\N	563
381	Graziela	           		Rua					        	3831		95476-3346	gramunhaes@yahoo.com.br		2017-05-11 09:54:14.784	2	11	2	3	2	\N		\N	\N
173	Danilo Capelli	           		Avenida	Eng. Luís Carlos Berrini	Cj. 1004/1006	1748		04571000	3831	5105-7300	97988-6440	danilo@segeletronica.com.br		2016-08-17 00:00:00	4	2	4	\N	2	\N		\N	564
382	Fábio Takeshi Ishimatsu	           		Rua					        	\N	991879125	991879125	fabio.ishimatsu@gmail.com		2017-05-16 12:05:19.091	3	2	3	3	2	\N		\N	566
386	Alan Duarte	           		Rua					        	3831		95472-8784	alanassisduarte23@hotmail.com		2017-05-23 17:28:50.284	2	11	2	3	2	\N		\N	574
388	Liliane	           		Rua					        	\N	41 - 3018-0868		liliane@nmg.adv.br		2017-05-29 14:34:03.308	3	\N	3	3	2	\N		\N	573
389	PRISCILA NAGOSHI UENO	           		Rua					        	\N		9965-4735	priueno@hotmail.com		2017-06-02 09:59:08.36	4	2	4	\N	7	\N		\N	572
390	Celso	           		Rua					        	3481		11 99969-5505	rccelso@uol.com.br		2017-06-13 11:08:27.032	2	11	2	3	2	\N		\N	577
391	Nelson	           		Rua					        	3831		94100-6698	Nelson.sl1@outlook.com		2017-06-13 11:11:45.054	2	11	2	3	2	\N		\N	\N
392	Mauricio	           		Rua					        	\N	2201-1046		basiotti@hotmail.com 		2017-06-19 14:18:39.536	3	11	3	3	2	\N		\N	578
394	Valdecir	           		Rua					        	\N	11 946199726		valfnildoaopupo@gmail.com		2017-06-22 10:52:43.489	3	5	3	3	2	\N		\N	580
395	Rafael	           		Rua					        	\N		11 - 97979-7777	rafael@poncio.adm.br		2017-06-26 10:31:30.477	3	5	3	3	2	\N		\N	581
398	Regiane Silva	           		Rua					        	3803		970971822	regiane.silva.m12@gmail.com		2017-07-11 14:22:19.705	2	11	2	3	2	\N		\N	590
396	Kiki Faria	           		Rua					        	\N		97655-6336			2017-06-28 16:31:58.711	3	7	3	3	2	\N		\N	585
401	Janiele Maria da Silva 	           		Rua					        	3831		98139-8745	janytzara@gmail.com		2017-07-26 10:31:54.065	2	11	2	3	2	\N		\N	594
402	Clemente Faga	           		Rua					        	\N	998400326		clemente.faga@terra.com.br		2017-07-27 13:46:06.014	3	\N	3	3	2	\N		\N	595
404	GIULIANO CHIRI BRAZ 	           		Rua					        	\N		11 - 99866-4390 	gcbgiuliano@gmail.com		2017-08-18 11:47:16.573	3	2	3	3	7	\N		\N	601
405	Peter	           		Rua	Rua Nelson Gebara		117	Parque America	        	3831		949835247	peter.yungo@hotmail.com		2017-08-29 15:10:05.267	2	11	2	3	2	\N		\N	603
406	Ieda Paixão	           		Rua					        	\N		11 99304-0091	ieda.paixaovalle@gmail.com		2017-09-05 14:38:13.322	3	11	3	3	2	\N		\N	604
422	Miriam	           		Rua				Vila Leopoldina	        	3831	3031-7122		miriam.espaco8@gmail.com		2018-01-10 15:30:03.189	2	11	2	3	2	\N		\N	\N
423	Beatriz	           		Rua				Osasco	        	3831		982573251	bdecoracao@hotmail.com		2018-01-16 15:33:38.931	2	11	2	3	2	\N		\N	638
378	Daniella Aduan	           		Rua					        	\N	11 3567-6734	11  97206-0612	adm@dfeventos.com.br; ramon@dfeventos.com.br	www.dfeventos.com.br	2017-05-08 10:25:09.845	3	4	3	4	2	\N		\N	684
384	Decio	           		Rua					        	3831		11 97249-8681	deciopbebiano@gmail.com		2017-05-23 17:04:27.87	2	11	2	3	2	\N		\N	570
421	Thais Serafim	           		Rua					        	\N	(27) 99982-2187	(14) 98138-2267	serafimtr@gmail.com		2017-12-29 11:49:22.666	3	2	3	3	2	\N		\N	634
403	Kaique Lopes Targino	           		Rua					        	3831		94883-0978 	kaiquetargino@gmail.com 		2017-08-03 10:56:26.117	2	11	2	3	2	\N		\N	598
400	Letícia	           		Rua					        	3831		98432-9444	fast.planet@hotmail.com		2017-07-14 13:57:14.222	2	11	2	3	2	\N		\N	592
393	Marilia Mendes	           		Rua					        	\N			mariliarochamendes@gmail.com		2017-06-22 10:32:05.241	3	7	3	3	2	\N		\N	579
407	Gabriel Varjão	           		Rua					        	\N			gabrielvarjaolima@gmail.com		2017-09-13 16:27:13.091	3	2	3	3	2	\N		\N	605
424	Luís Moreira de Jesus	           		Rua					        	\N		976358774	luizmoreira7833@gmail.com		2018-02-14 08:37:45.808	2	11	2	3	2	\N		\N	\N
387	Pedro Miranda	           		Rua					        	3831		11952528638	pedroncmiranda@hotmail.com		2017-05-26 12:03:08.034	4	5	4	3	7	\N		\N	571
399	Andrea Biotto	           		Rua					        	3831		97558-2633	ar.biotto@hotmail.com		2017-07-12 11:19:18.975	2	11	2	3	2	\N		\N	591
383	Cleiton	           		Rua					        	3331		99221-3883	cleiton.silva@bhge.com		2017-05-16 14:13:04.307	2	11	2	3	2	\N		\N	567
217	Rodrigo			\N	\N	\N	\N	\N	\N	\N		11981089993	visualrodrigoramos@gmail.com		2016-06-03 00:00:00	4	2	4	\N	2	\N	\N	\N	367
309	Renata	           		Rua					        	\N	3060-5250		renata@octante.com.br		2017-01-23 09:01:30.132	2	10	2	2	2	\N	\N	\N	\N
323	Vitor de Oliveira Florencio	           		Rua					        	3831		96450-1977	vagals.vitao@hotmail.com		2017-01-26 15:04:08.603	2	5	2	3	2	\N	\N	\N	\N
324	Rose	           		Rua					        	3831		98681-9118	sosflavia@gmail.com		2017-01-30 11:54:19.85	2	5	2	4	2	\N		\N	\N
310	Marcello Caldeira	           		Rua					        	\N		97573-2426	marcello.g.caldeira@gmail.com		2017-01-23 10:46:26.721	2	5	2	3	2	\N	\N	\N	530
311	Adriana	           		Rua					        	\N		99627-7441	adriananicolosi@hotmail.com		2017-01-23 11:02:24.713	2	5	2	3	2	\N	\N	\N	\N
313	Joyce Emanuelle	           		Rua					        	\N	2335-2355 x		Joyce.Emanuelle@hotmail.com		2017-01-23 11:18:09.35	2	5	2	3	2	\N	\N	\N	\N
316	Claudio Maia Sinibaldi	           		Rua					        	3831		95569-6144	claudiosiniba@gmail.com		2017-01-23 14:55:42.161	2	5	2	3	2	\N	\N	\N	510
315	Alexsandro Soares da Silva	           		Rua					        	3831	4721-1363	11950705382	soaresdasilvaalexssandro@gmail.com		2017-01-23 14:44:59.551	2	5	4	3	2	\N		\N	509
281	Robson Souza Leite	           		Rua					        	\N	55231861	982860407	lavanderiagrandeestilo@hotmail.com		2016-10-24 00:00:00	5	19	5	\N	2	\N		\N	473
193	Grazieli Barreto Cunha	           		Rua					        	\N		989843464	grazielibcunha@gmail.com		2016-02-26 00:00:00	4	19	4	\N	2	\N		\N	316
425	Junior Inacio	           		Rua					        	\N	(11) 4385-9078	(11) 99969-5137	larrazabaly@gmail.com		2018-02-14 17:07:34.733	3	\N	3	3	2	\N		\N	642
239	Erica  Vilalba			\N	\N	\N	\N	\N	\N	\N		11977628989	erica_v@hotmail.com		2016-08-17 00:00:00	4	2	4	\N	2	\N	\N	\N	401
429	Orlando	           		Rua					        	\N		98170-1225	landosp10@terra.com.br		2018-03-23 10:55:09.161	2	5	8	3	2	\N		\N	661
426	Andreia	           		Rua					        	\N		98342-7770	deinhat9@hotmail.com		2018-02-28 17:35:31.351	3	7	3	3	2	\N		\N	652
432	Nathalie	           		Rua					        	3831		98229-6735	dra.nathalieprotetti@hotmail.com		2018-04-16 15:23:43.607	2	15	2	3	2	\N		\N	672
434	Willian José Dias	           		Rua					        	\N		97354-4364	willianjosed@gmail.com		2018-05-16 14:58:25.769	2	2	2	3	2	\N		\N	\N
435	Fábio Vieira	           		Rua					        	3656		94729-5870	diasy.diasy@gmail.com		2018-06-05 11:51:08.399	2	2	8	3	7	\N		\N	682
436	Marco Aurélio	           		Rua					        	3831		98560-4897	mapedrazzoli@uol.com.br		2018-06-14 16:06:27.548	2	5	2	10	2	\N		\N	\N
157	Rita			\N	\N	\N	\N	\N	\N	\N					2016-01-12 00:00:00	2	5	2	\N	2	\N	\N	\N	274
330	Beatriz	           		Rua					        	3831		95349-9328	confieletrica@gmail.com		2017-02-06 14:24:49.387	2	5	2	3	2	\N		\N	522
372	Humberto	           		Rua					        	\N		99949 9152	humbertoabrahao@uol.com.br		2017-04-10 14:54:50.049	4	10	4	3	2	\N		\N	552
427	Dra. Bianca	           		Rua					        	\N		11998206500	biancascalfaro@hotmail.com		2018-03-09 18:31:05.013	4	18	4	6	2	\N		\N	654
195	Priscila Ueno	           		Rua					        	\N		996547351	priueno@hotmail.com		2016-02-26 00:00:00	2	19	2	\N	2	\N		\N	318
430	Sandra Martins	           		Rua					        	\N		94947 9921	srp.martins@uol.com.br		2018-03-28 15:21:25.263	9	\N	9	\N	\N	\N		\N	664
433	Dra. Márcia	           		Rua					        	3831	5182-0953	99970-0511	marcia_jordao@uol.com.br		2018-05-08 11:33:04.612	2	7	8	3	2	\N		\N	676
437	Maria Sandra	           		Rua					        	3831		97625-4070	visgraf@uol.com.br		2018-06-15 13:50:32.076	2	11	2	3	2	\N		\N	685
438	Jane Oliveira	           		Rua					        	3831	3085-1291 	99739-2432	janitaj@hotmail.com		2018-06-19 15:31:08.96	2	2	2	3	7	\N		\N	687
362	Rodrigo	           		Rua					        	3831		99661-0432	rfive55@msn.com		2017-03-20 11:49:42.917	2	11	2	3	2	\N		\N	\N
409	Daniele Gieseke	           		Rua					        	\N			danygieseke@gmail.com		2017-09-28 14:20:43.242	3	2	3	3	2	\N		\N	613
411	Dra. Vanessa	           		Rua					        	\N		11981437391	vanessacirurgiavascular@gmail.com		2017-10-02 16:15:40.124	4	15	4	3	2	\N		\N	615
413	Monique	           		Rua					        	\N		983812564 	monique@jornalveterinario.com.br		2017-10-04 14:12:27.561	2	11	3	3	2	\N		\N	\N
414	Francisco Antônio Carvalho Oliveira	           		Rua					        	3831		95883-1485	wa_studioautomotivo@hotmail.com		2017-10-16 10:11:41.024	2	11	2	3	2	\N		\N	\N
415	Fabiana	           		Rua					        	\N		11 - 95898-4530	professorafabiana.fieb@bol.com.br		2017-11-09 13:59:26.17	3	15	3	3	2	\N		\N	621
417	Gabriella Secco	           		Rua					        	\N		21 - 983357980	gabriela_secco87@yahoo.com.br		2017-12-04 11:09:48.823	3	5	3	3	2	\N		\N	629
412	Paloma	           		Rua					        	3831		97555-5768 	paloma_francine_andreu@hotmail.com; casalomaojr@gmail.com		2017-10-04 12:22:25.6	2	11	2	3	2	\N		\N	616
408	Manuela Brandão Borges	           		Rua					        	3831		11984576738	manuela.b.b@hotmail.com	www.beflexy.com.br	2017-09-20 17:21:56.937	4	16	4	3	2	\N		\N	607
416	Adriano Silva	           		Rua					        	\N		11 98156 9866	aacsilva@terra.com.br		2017-11-16 12:21:46.142	3	7	3	3	3	\N		\N	628
420	Felipe	           		Rua					        	\N		(11) 949444585 	felipincorominas@gmail.com		2017-12-14 17:35:31.096	3	5	3	3	2	\N		\N	633
418	Juliano Tuboni	           		Rua					        	\N		11 - 99993-7304	juliano.tuboni@gmail.com		2017-12-04 11:10:44.574	3	5	3	3	2	\N		\N	630
410	Ronaldo	           		Rua					        	\N	11995482655		rjnnunes@gmail.com		2017-10-02 15:33:44.965	4	4	4	\N	2	\N		\N	614
419	Vivian	           		Rua					        	\N	11 4255-4785	11 98808-2783 	viviancontabilista@gmail.com		2017-12-12 09:50:06.726	3	5	3	3	2	\N		\N	631
\.


--
-- Name: pessoa_pes_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.pessoa_pes_cod_seq', 438, true);


--
-- Data for Name: pro_tipo_contato; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.pro_tipo_contato (pro_tipo_contato_cod, pro_tipo_contato_nome) FROM stdin;
1	Nenhum
2	E-Mail
3	Mala Direta
4	E-Mail e Mala Direta
\.


--
-- Name: pro_tipo_contato_pro_tipo_contato_cod_seq; Type: SEQUENCE SET; Schema: public; Owner: developer
--

SELECT pg_catalog.setval('public.pro_tipo_contato_pro_tipo_contato_cod_seq', 4, true);


--
-- Data for Name: prospeccao; Type: TABLE DATA; Schema: public; Owner: developer
--

COPY public.prospeccao (pro_cod, pro_nome, pro_responsavel, pro_departamento, pro_endereco, pro_telefone, pro_celular, pro_email, pro_site, pro_criadoem, pro_criadopor_cod, pro_origem_cod, pro_origem_detalhes, pro_resumo, pro_apresentacao, pro_atendente_cod, pro_servico_cod, pro_convite_eventos, pro_material, pro_newsletter, pro_tipo_contato, pro_ult_negocio_cod) FROM stdin;
97	Oral Unic Franchising				47 3366-8888 		expansao@oralunic.com.br 	http://www.oralunic.com.br/franquia 	2018-02-08 10:55:52.674	2	17	03/02/2018			2	7	1	0	0	2	\N
3	Frutiquello Sorvetes	Rogério Martins	Diretor		11 4819-6858	11 95025-2323	frutiquello@frutiquello.com.br	www..cacautello.com.br	2017-06-26 11:51:30.045	2	12		Enviar apresentação. Agendar reunião.		2	\N	1	1	1	2	\N
100	Condutron Cabos Elétricos Ltda-EPP	Celia		Rua Pedro Sta. Lucia, 468 - Interlagos		3215-8555	celiargon@hotmail.com	http://www.condutron.com.br/	2018-03-07 09:47:25.332	2	4	Robison indicou. \n	Indústria.		2	3	1	1	1	2	\N
101	Caminhos de bem estar					94363-9888	contato@caminhosdebemestar.com.br	www.caminhosdebemestar.com.br	2018-03-23 09:59:49.341	2	16				2	\N	1	1	1	4	\N
103	Sicomunicação	Silvana Inácio				98493-6579	silvana@sicomunicacao.com.br	www.sicomunicacao.com.br	2018-03-23 10:16:02.552	2	16				2	\N	1	1	1	4	\N
105	Singolla Consultoria em Gestão	Andrea e Marco Antônio	Sócios consultores			99225-5610 | 94211-6393	provenzano@singolla.com.br; marco.santo@singolla.com.br	www.singolla.com.br	2018-03-23 10:36:39.771	2	16				2	\N	1	1	1	4	\N
107	Sampa Sling				3735-0838	98383-9075	sac@sampasling.com.br	www.slingada.blogspot.com	2018-03-23 10:40:23.377	2	16				2	\N	1	1	1	4	\N
113	3stecnologia	Fabio			4186 9696		fabio.brandli@3stecnologia.com.br		2018-04-02 11:58:40.8	9	10				9	\N	0	0	0	4	\N
120	Antilhas	Jessica			4152 1111				2018-04-02 16:37:30.861	9	10				9	\N	0	0	0	4	\N
129	Bittencourt Consultoria	Ligia			3660 2201		eventos@bcef.com.br		2018-04-03 11:08:46.424	9	10				9	\N	0	0	0	4	\N
138	Cuor Di Crema	Jéssica			3062 39 82 ou 3068 08 31				2018-04-04 15:24:03.233	9	10				9	\N	0	0	0	4	\N
150	Gelateria Freddissimo	------			5641-3057		marketing@freddissimo.com.br		2018-04-05 16:44:05.762	9	10				9	\N	0	0	0	4	\N
160	Chocolateria Brasileira	Cintia Pitta			4191 9276 ou 98924 7094		franquia@chocolateriabrasileira.com.br		2018-04-11 17:03:55.007	9	10				9	\N	0	0	0	4	\N
168	KingCase	Oscar Martins			17 - 98822 6001 ou 17 - 3304 - 3655		oscarmartins@kingcasebr.com		2018-04-12 15:21:00.737	9	10				9	\N	0	0	0	4	\N
130	BFFC Alimentos / Bob´s	Rafael			3579 1500		rafael.cesar@bffc.com.br ou anita.cid@bffc.com.br		2018-04-03 11:33:24.505	9	10				9	\N	0	0	0	4	\N
174	Padaria Pet	Arquelau			2838-0888		arquelau@padariapet.com.br		2018-04-19 11:23:42.343	9	10				9	\N	0	0	0	4	\N
17		Luis Felipe Ferreira		Santo André		11 96696-7640	felipeluissf@gmail.com		2017-06-26 14:14:01.592	2	12		Quer abrir uma franquia de PET SHOP.		2	3	1	1	1	2	\N
189	Cacau Show  João Mendes	Ricardo			3107-3632		cacaujoaomendes@gmail.com		2018-05-02 08:37:26.597	9	10				9	\N	0	0	0	4	\N
179	Flamy	Alessandro			19- 3865 1818		adm@deliciasflamy.com.br		2018-04-23 11:50:45.031	9	10				9	\N	0	0	0	4	\N
194	Hope Lingerie	Sylvio			2169-2200		sylvio@hopelingerie.com.br		2018-05-07 12:08:15.761	9	10				9	\N	0	0	0	4	\N
198	Jonny Rockets	Augusto			4153-9400		augusto@johnnyrockets.com.br		2018-05-07 15:04:03.12	9	10				9	\N	0	0	0	4	\N
202	Liz Lingerie	Eolo			3818-0360		eolo@cmrcia.com.br		2018-05-07 16:04:08.086	9	10				9	\N	0	0	0	4	\N
206	NYS Brasil	Sérgio			2337-9227		comercial@wbbr.com.br		2018-05-08 17:07:53.463	9	10				9	\N	0	0	0	4	\N
185	Saladenha Alimentação Saudável	Rodrigo			11-4024 1300	11- 96427-0040	rodrigo@saladenha.com.br		2018-04-24 17:29:51.672	9	10				9	\N	0	0	0	4	\N
158	IsoCred	Yoshio			94551-2111 0u (11) 2427 - 5497		yoshio@isocred.com.br , claudio.frizzarini@gmail.com		2018-04-10 15:58:25.868	9	10				9	\N	0	0	0	4	\N
210	Patroni Pizza	Cury			5182-3000		franquia@patronipizza.com.br		2018-05-14 14:47:08.381	9	10				9	\N	0	0	0	4	\N
214	Prima Clean	Fernanda			5535-4110		consultoriagestao@afranquia.com.br		2018-05-14 16:03:39.915	9	10				9	\N	0	0	0	4	\N
219	TAM Viagens						franquias@tam.com.br		2018-06-01 11:22:20.343	9	\N				9	\N	0	0	0	4	\N
223	Yazigi 				2132-9600		expansao@yazigi.com		2018-06-01 15:06:24.897	9	10				9	\N	0	0	0	4	\N
226	Urban Motion	Sabrina			4280-8539		info@urbanmotion.com.br ou franquias@urbanmotion.com.br		2018-06-01 16:05:29.164	9	10				9	\N	0	0	0	4	\N
99	SORRIDENTS 	Nathália Azevedo			2076-5211	97370-1127	nathalia.azevedo@gruposorridents.com.br	www.sorridents.com.br 	2018-02-08 11:18:16.345	2	17				2	7	1	1	1	2	\N
195	Instituto Embelleze	katina			5538-4753		expansao1@institutoembelleze.com		2018-05-07 12:27:43.513	9	10				9	\N	0	0	0	4	\N
98	Essentus Clínicas Odontológicas 	Claudinei Santos	Diretor de expansão		43 3343-0343 		comercial@essentus.com.br; lua@grupojmk.com.br	www.essentus.com.br 	2018-02-08 11:16:44.032	2	17				2	7	1	1	1	2	\N
102	Dezê Design	Patricia			2538-3298	98555-5178	atendimento@deze.com.br	http://www.deze.com.br	2018-03-23 10:13:57.882	2	16				2	\N	1	1	1	4	\N
104	Danielle Maestrelo Projetos e Reformas	Danielle				97358-6936		www.daniellemaestrelo.com	2018-03-23 10:34:32.32	2	16				2	\N	1	1	1	4	\N
106	Raiuga Oportunidades Imobiliárias			Rua Frei Caneca, 1407, cj. 207 - Cerqueira Cesar, São Paulo-SP, 01307-003		97558-2492		www.raiugaoportunidades.com	2018-03-23 10:38:32.102	2	16				2	\N	1	1	1	4	\N
114	aaclassfranquias				4169-6829 ou 2898-1470		contato@aaclassfranquias.com.br		2018-04-02 12:24:57.941	9	10				9	\N	0	0	0	4	\N
121	Área Signs	Marcia			2294 1877				2018-04-02 17:15:26.356	9	10				9	\N	0	0	0	4	\N
131	Burger Mais Alimentação	Francisco			5505 2894		francisco@burgermais.com.br		2018-04-03 12:02:05.137	9	10				9	\N	0	0	0	4	\N
139	Rede Dia %	Janaina			3886 8000		novosnegocios.diabrasil@diagroup.com		2018-04-04 15:42:24.792	9	10				9	\N	0	0	0	4	\N
151	Grupo Orba	Bruno			2976 97 22		atendimento@grupoorba.com.br		2018-04-05 17:06:36.116	9	10				9	\N	0	0	0	4	\N
159	Pilão Professional	Rafael			11 4533 1322		rafael.ferrer@pilaoprofessional.com.br e  franquia@pilaoprofessional.com.br		2018-04-10 17:00:08.141	9	10				9	\N	0	0	0	4	\N
161	Premium Chocolates	Thais ou Marcos			2092 55 51		thais@premiumchocolates.com.br ou marcos@premiumchocolates.com.br		2018-04-11 17:21:38.526	9	10				9	\N	0	0	0	4	\N
175	Pingus English School	Gilson			99017 2814		gilson.benites@moveedu.com.br		2018-04-19 11:31:48.715	9	10				9	\N	0	0	0	4	\N
203	Mr Kids	Antonio Chiarizzi			5058-2111		diretoria@mrkids.com.br		2018-05-07 16:39:43.8	9	10				9	\N	0	0	0	4	\N
207	Óticas Carol	Tina			3528-9300		expansao@oticascarol.com.br		2018-05-08 17:17:07.795	9	10				9	\N	0	0	0	4	\N
180	Oficina de franquias	Patricia ou andré			98289-2047 ou 2321-2118	98289-2047	andre@oficinadefranquias.com.br , comercial@oficinadefranquias.com.br		2018-04-23 15:23:48.967	9	10				9	\N	0	0	0	4	\N
182	Empada Brasil	Gabriela			3225 -9337		centralizadora@empadabrasil.com.br		2018-04-23 16:06:33.791	9	10				9	\N	0	0	0	4	\N
186	Arranjos Express				3842-0211		franquias@arranjosexpress.com.br		2018-04-25 11:35:31.127	9	10				9	\N	0	0	0	4	\N
190	Mania de Passar Serviço de Passar Roupas	Eduardo			3374-3281		eduardo@maniadepassar.com.br		2018-05-02 11:33:50.609	9	10				9	\N	0	0	0	4	679
211	PBF	Fernando			5573-7000		supervisor@fundacaorhf.com.br		2018-05-14 15:04:51.357	9	10				9	\N	0	0	0	4	\N
30	LAB 4	Jorge Antonio		Rua Bom Pastor, 2100 Cj. 708 - Ipiranga, São Paulo/SP, 04203-002	11 2157-3792	11 99443-9831	jorge@lab4.com.br	www.lab4.com.br	2017-06-26 15:16:03.281	2	12				2	\N	1	1	1	2	\N
153	Maxilabor Diagnósticos	Cassio			3057-0747  ou 3889-8960		cassio.campos@saffi.com.br		2018-04-10 09:31:06.886	9	10				9	\N	0	0	0	4	\N
215	PUKET	Liliana			3838-0875		liliana@puket.com.br		2018-05-14 16:38:01.699	9	10				9	\N	0	0	0	4	\N
199	Kumon	Rodrigo Rosa			3059-3700		rodrigo.rosa@kumon.com.br		2018-05-07 15:14:57.348	9	10				9	\N	0	0	0	4	\N
191	Encontre sua franquia	Joelma ou Henrique			31 - 3654-5664		franquia@encontresuafranquia.com.br		2018-05-02 12:11:36.916	9	10				9	\N	0	0	0	4	\N
220	The Body Shop								2018-06-01 11:42:24.952	9	10				9	\N	0	0	0	4	\N
224	UV.LINE	Luis Araujo			3812-4490		luis.araujo@uvline.com.br		2018-06-01 15:31:57.384	9	10				9	\N	0	0	0	4	\N
217	Tip Top	Ricardo			3613 6791		ricardomarcondes@tiptop.com.br ou  expansaolojas@tiptop.com.br		2018-06-01 10:41:59.747	9	10				9	\N	0	0	0	4	\N
122	Ana Capri	Mariana			2132 4300		mariana.zamorano@arezzo.com.br		2018-04-02 18:03:55.347	9	10				4	\N	0	0	0	4	\N
4		Igor Fernando Silva				11 99627-8399	igor.silva2233@gmail.com		2017-06-26 12:01:21.057	2	12		Pré-diagnose:\nComércio varejista de pescados, 3 empregados, faturamento mensal R$ 30.000,00, Abertura gratuita, Honorários R$ 450,00.		2	3	1	1	1	2	584
108	Chef da empada	Celso					celsosaulo@gmail.com		2018-03-28 15:04:09.742	9	10	Contato telefonico efetuado em 28 de março com Celso\no mesmo é gerente de expansao e ira nos atender em \n13-04 sexta feira as 15 horas.\nEncaminhado material em 28-03  enviamos email institucional			9	\N	0	0	0	4	\N
115	Ablsan Shopping center				2451-2054				2018-04-02 12:34:17.155	9	10				9	\N	0	0	0	4	\N
123	Arezzo & Co	Mariana			2388 8220		mariana.zamorano@arezzo.com.br		2018-04-02 18:08:23.634	9	10				9	\N	0	0	0	4	\N
8	Home Sofá Franchising	Jeferson e Wesley Santos 		Santa Catarina	47 99931-4308	47 99933-4376	comercial@homesofa.com.br; homesofa@homesofa.com.br		2017-06-26 12:16:00.456	2	12		Vão começar a franquear. Enviar e-mail para parceria.		2	7	1	1	1	2	\N
10	Doutor Feridas	Dr. Evandro Pereira dos Reis		Rua Chuí, 147 - Paraíso, São Paulo/SP, 04101-000	11 4563-6093	11 98762-3286	contato@doutorferidas.com.br	www.doutorferidas.com.br	2017-06-26 12:21:04.493	2	12		Tem franquia. Parceria.		2	7	1	1	1	2	\N
11		Felipe Ferreira		São Paulo		11 97165-2888	felipe@uchoa.ws		2017-06-26 12:23:10.192	2	12		3 NF's, sem funcionários, não quis informar faturamento.\nEstá na Contabilizei.\nOferecer R$ 350,00 de mensalidade.		2	4	1	1	1	2	588
140	Divino Fogão	Nelson			98768 1212		nelson@gnmconsultoria.com.br		2018-04-04 16:08:31.249	9	10				9	\N	0	0	0	4	\N
152	Dr. Consulta	--------			4090 1510		atendimento@drconsulta.com		2018-04-10 09:25:05.468	9	10				9	\N	0	0	0	4	\N
132	Café Donuts Alimentação	Fabio			3706 1460		contratos@cfcentral.com.br		2018-04-03 12:22:43.63	9	10				9	\N	0	0	0	4	\N
13	Assis Plaza Shopping	Luiz Carlos de Souza		Av. Rui Barbosa, 300 - Centro, Assis/SP, 19814-000	18 3323-3325	18 99789-3252	gerencia@assisplazashopping.com.br	www.assisplazashopping.com.br	2017-06-26 13:59:38.551	2	12		Abrirá um shopping em Franco da Rocha com mais de 90 lojas.\nEntrar em contato para estabelecer parceria.		2	7	1	1	1	2	\N
14	Nalcino Franchising & Varejo	Anderson Nascimento			11 4114-6930	11 97441-0099	anderson@nalcino.com.br	www.nalcino.com.br	2017-06-26 14:03:03.363	2	12		Possui uma empresa, porém quer constituir uma nova.\nPresta consultoria para empresarios que querem implantar o sistema de franquias.\n\n>Proposta para abertura + parceria		2	3	1	1	1	2	\N
15	Nós amamos Pizza	Erik Kenta Arakaki		Mauá		11 99695-5076	nosamamospizza@gmail.com		2017-06-26 14:08:46.562	2	12		Irá começar a franquear e precisará de um parceiro. Enviar proposta de parceria.		2	7	1	1	1	2	\N
16	YKZ Confecções	Roberto M. Yokomizo	Diretor Executivo	Rua Fernandes Sardinha, 35 - Vila Alpina, São Paulo/SP, 03147-020	11 2318-2210	11 97407-2190	roberto.yokomizo@ykz.com.br	www.ykz.com.br	2017-06-26 14:12:27.158	2	12		Uniformes corporativos. Atende mais de 20 franquias.		2	7	1	1	1	2	\N
18		Fabiano Bueno				11 99443-4186	buenofb@gmail.com		2017-06-26 14:15:25.641	2	12		Consultoria e treinamentos.		2	3	1	1	1	2	\N
19		Fernanda Diniz Moraes					fernandadinizmoraes@hotmail.com		2017-06-26 14:17:01.963	2	12		Expositora na feira.\nAtividade: Corretora\nEnviar apresentação.		2	7	0	0	0	2	\N
20	Central do Franqueado	Dario Ruschel	Diretor comercial			51 99985-7934	dario@centraldofranqueado.com.br	www.centraldofranqueado.com.br	2017-06-26 14:19:32.693	2	12		Interesse: parceria para geração de conteúdo.		2	7	1	1	1	2	\N
22	Essencial Care	Rodrigo de Freitas Miranda	Gestor de Rede Franchising	Av. Ipiranga, 7464 Cj. 518 - Porto Alegre/RS	51 33989-3233	51 99640-5511	franquia@essencialcare.com.br	www.essencialcare.com.br	2017-06-26 14:28:48.247	2	12		Parceria.		2	7	1	1	1	2	\N
23	Grupo GS&Member of Ebeltoft Group	Lucia Nunes		Av. Paulista, 854 9º andar - Bela Vista, São Paulo/SP, 01310-100	11 3405-6679	11 3405-6666	lucia@gmail.com.br	www.gsmd.com.br	2017-06-26 14:31:57.283	2	12		Feira para participar		2	\N	1	1	1	2	\N
26	Sobrancelhas Design	Dayse Sobral	Gerente Operacional			85 99188-1061	dayse.sobral@gsd.com.br	www.sobrancelhasdesign.com.br	2017-06-26 14:54:44.075	2	12		Parceria.		2	7	1	1	1	2	\N
9		Beatriz Andrade				11 95073-7015	beatriz@lab4.com.br		2017-06-26 12:18:28.874	2	12		Troca de contador. Enviar pré-diagnose.		2	4	1	1	1	2	\N
25	Mundo Verde	Sarah Duarte	Expanção	Rua Marina Ciufuli Zanfelice, 329 - Lapa, São Paulo/SP, 05040-000	11 4369-6800	24 99248-0034	fabianaguedes@mundoverde.com.br	www.mundoverde.com.br	2017-06-26 14:52:30.24	2	12		Fabiana informou que Maíra faz a implantação da Loja. \nDevemos falar com Sarah.		2	7	1	1	1	2	\N
2	E ai doutor?	Edmax Ferreira Santiago	Executivo de vendas	Rod. Deputado Nagib Chaib, 2069 - Morro Vermelho, Mogi Mirim/SP, 13.807-684	19 3804-2208	19 99524-8766	comercial@workcaresaude.com.br	www.eaidr.com.br	2017-06-26 11:46:31.135	2	12				2	4	1	1	1	2	\N
7	Ponto Arte	Tiago Périco				11 98128-9475	tiago.arte@gmail.com	www.pontoarte.com.br	2017-06-26 12:12:41.396	2	12		Quer abrir uma empresa de marketing multi-nível.\n> Verificar situação fiscal da empresa CNPJ 11.631.987/0001-69.\n		2	3	1	1	1	2	583
21	Business Consultoria & Franchising	José Luiz Pereira Braz	Consultor empresarial	Av. Bento da Cruz, 821 - Centro, Penápolis/SP, 16300-000	18 3652-0845	18 99743-0637	jose.braz@consultoriabusiness.com.br	www.consultoriabusiness.com.br	2017-06-26 14:21:28.375	2	12		Enviar apresentação.		2	7	1	1	1	2	\N
24	Sodiê Doces	Fabiana> Emerson				11 94242-0313	consultoria7@sodiedoces.com.br	www.sodiedoces.com.br	2017-06-26 14:46:09.93	2	12		Fabiana (expansão:   suafranquia@sodiedoces.com.br) teve muito interesse em parceria, porém após contato telefônico informou que devemos falar com Emerson (consultoria7@sodiedoces.com.br).		2	7	1	1	1	2	\N
28	Camisaria Italiana	Regiane Acciari	Diretoria de Novos Negócios			35 99952-9494	diretoria@camisariaitaliana.com.br	www.camisariaitaliana	2017-06-26 15:06:18.352	2	12		Parceria		2	7	1	1	1	2	\N
176	Mr.Mix Milk Shake	Ricardo Almeida			19 - 98231-5656		ricardo@mrmix.com.br		2018-04-19 11:41:32.304	9	10				9	\N	0	0	0	4	\N
163	Quinta Valentina	ANA			17 - 3211 8073		contato@quintavalentina.com.br		2018-04-12 12:17:06.801	9	10				9	\N	0	0	0	4	\N
162	60 minutos lavanderia Self Service	Isaelson			0800 111 6060		isaelson@lavanderia60minutos.com.br		2018-04-12 12:09:13.161	9	10				9	\N	0	0	0	4	\N
181	Baffs Salgaderia	Sandra ou Marcelo			4777-0144	94773-5659 Sandra	mromano@baffsfranquia.com.br		2018-04-23 15:46:07.197	9	10				9	\N	0	0	0	4	\N
58	Beauty Hands	Aline Tavares				98466-8728	beautyhands@terra.com.br		2017-09-25 17:26:59.64	4	16	Enviamos uma proposta para ela.	Esmalteria.		2	4	1	1	1	4	609
109	Rancho da Empada	Sabrina					marketing@ranchodaempada.com.br		2018-03-28 17:50:04.08	9	10	Entrei em contato com Sabrina (mkt) a mesma informou\nque neste momento estão somente com 1 unica loja.\nprojetos a partir do 2º semestre de abrirem novas franquias.\nEncaminhei nosso material por email em 28-03.\nManteremos contato.			9	\N	0	0	0	4	\N
110	Red Ballon	Daniel - Expansão de Franquias.			2372-2300 Ramal 103				2018-03-28 17:54:43.305	9	20	Em 28-03 entrei em contato com a Franqueadora\nRed Balloon , falei com Priscila a mesma informou que o\nresponsavel pela expansão de negócios é o Daniel\ne que devemos ligar dia 29-03 a fim de falarmos com ele.\nRetornarei o contato.			9	\N	0	0	0	4	\N
116	Acqio				4200 7939				2018-04-02 12:47:06.018	9	10				9	\N	0	0	0	4	\N
124	Art Walk	valter			36643800		valter.wing@grupoafeet.com.br		2018-04-03 09:47:32.128	9	10				9	\N	0	0	0	4	\N
125	Authentic feet	Valter			3664 3800		valter.wing@grupoafeet.com.br		2018-04-03 09:52:46.254	9	10				9	\N	0	0	0	4	\N
141	Dr Shape	Roberto			2182 7000		franquias@drshapesuplementos.com.br		2018-04-04 16:32:48.334	9	10				9	\N	0	0	0	4	\N
29	Piticas	Lucas Valões	Consultor de Franquia	Rua Progresso, 210 - Ponte Grande, Guarulhos/SP, 07030-030		11 99744-7634	lucas@piticas.com.br	www.piticas.com.br	2017-06-26 15:10:32.18	2	12		Outro celular: 99114-7870\nOu Mari Gonzaga (Marketing)\nmari@piticas.com.br | 95301-6199		2	7	1	1	1	2	\N
1		Caren Cruz		São José dos Campos		12 99601-2379	ccrocruz@gmail.com		2017-06-26 11:32:27.69	2	12		Já possui empresa e quer alterar.		2	8	1	1	1	2	\N
33	VIP-SYSTEMS	Dra. Regiane Relva Romano		Rua Independência, 135 - Barueri/SP, 06411-050	11 4198-1095	11 99973-2803	regiane@vip-systems.com.br		2017-06-26 16:45:44.27	2	12		Enviar apresentação contábil.		2	\N	1	1	1	2	\N
35	Grupo Sobrancelhas	Gabriela Miné	Expansão	Rua Jurandir Martins Filho, 35 8º andar - Bosque Flamboyant, Taubaté/SP	12 3424-4527	12 98288-0079	expansao2@gruposobrancelhas.com.br	www.sobrancelhas.com.br	2017-06-26 16:50:30.18	2	12				2	7	1	1	1	2	\N
64	Celebrar.co	Camila Florentino				99258-9783	camila.celebrar.co		2017-10-05 14:55:22.514	2	16		Eventos.		2	\N	1	1	1	4	\N
31	Fabiano Bueno	Fabiano Bueno			11994434186		buenofb@gmail.com		2017-06-26 15:23:27.576	4	12	ABERTURA DE EMPRESA			4	\N	0	0	0	2	582
36	Rei do Mate	João Baptista da Silva Jr		Rua João Moura, 406 - Pinheiros, São Paulo/SP, 05412-001	3897-9323		jb@reidomate.com.br	www.reidomate.com.br	2017-07-05 16:49:47.475	2	12		Parceira falar com Angelica Soares.		2	7	1	1	1	2	\N
37	GrandVision by Fototica	Giselli Lima	Gerente de Expansão	Av. das Naçoes Unidas, 10989 - 1º andar, Vila Olímpia, São Paulo/SP, 04578-900	3175-1407	99193-1583	giselli.lima@fototica.com.br		2017-07-05 17:44:23.846	2	12		Parceria.		2	7	1	1	1	2	\N
38	CHIQUINHO SORVETES	Moisés Ortega	Expansão		17 3211-8200		moises.ortega@grupochq.com.br	www.chiquinho.com.br 	2017-07-06 10:26:48.947	2	12		Parceria franqueadora.		2	7	1	1	1	2	\N
39	Ecoville	Ricardo	Proprietário			94587-6161	ricafer2@hotmail.com		2017-07-10 17:01:59.779	2	12		Abrir franquia Ecoville.		2	3	1	1	1	4	589
12	DEKRA Consultoria	Andre Luis Bisvaro			11 4418-7143		franquias@dekra.com	http://dekra.com.br/seja-um-franqueado-dekra	2017-06-26 12:30:05.095	2	12		Franqueador - Parceria.		2	7	1	1	1	1	\N
27	OTRIS Franquias	Caio Katayama	Fundador Presidente	Rua Pereira Tangerino, 128 - Guanabara, Campinas	19 3243-0803	19 99248-4792	caio@otrisfranquias.com.br	www.otrisfranquias.com.br	2017-06-26 14:57:35.622	2	12		Franquia de recuperação de crédito. Parceria.		2	7	1	1	1	2	\N
34	Maria Honos Gastronomia	Rafael Muller	Marketing	Rua Coronel Vicente Peixoto, 95 - Centro, Vitória/ES	27 3331-1144	27 99747-1832	marketing@mariahonos.com.br	www.mariahonos.com.br	2017-06-26 16:48:21.417	2	12				2	7	1	1	1	2	\N
32	Matas Verdes	Cássia da Silva		Rua Cel. Marques Ribeiro, 120 - Vila Guilherme, São Paulo/SP	11 2533-6177	11 7867-7716	comercial2@matasverdes.com	www.matasverdes.com.br	2017-06-26 15:21:49.352	2	12		Paisagismo e locação de móveis.\n\nOutros contatos no cartão de visita: \nIngrid Vaneza, 2533-6177, comercial@matasverdes.com; financeiro@matasverdes.com\nJúlia Santos, 2099-2989, 94791-2622, matasverdes@gmail.com\nTania Miranda, 2099-3726, 94791-3838, tania@matasverdes.com 		2	\N	1	1	1	2	\N
40	Prodetech Group				5031-4485		contato@prodetechgroup.com.br	www.prodetechgroup.com.br	2017-08-10 10:35:19.555	2	7	Sergio	2 empresas  de segurança patrimonial com cerca de 200 funcionarios		2	4	0	0	0	4	\N
41	Mello Centro de Diagnóstico				5014-2199			www.mellodiagnostico.com.br	2017-08-10 10:37:08.245	2	7	Sergio	Mesmo seguimento do DELBONI ARIEMO e LAVOUSIER) eles tem 7 unidades com cerca de 400 funcionarios de folha de pagamento( já me sinalizaram que precisam de um serviço pontual pra resolver um problema pontual de contabilidade pra depois fazer a migração da contabilidade pra Prolink 		2	4	0	0	0	4	\N
45	TGB VIDROS	Débora Domingues				11 - 97553-4730	contato@tgbvidros.com.br		2017-09-22 15:13:21.708	3	16				2	4	1	1	1	4	\N
47	Meca Com	Denise Freitas			11 - 3522-1086	11 97073-5709	denise@mecacom.com.br		2017-09-22 15:25:31.103	3	16				2	4	1	1	1	4	\N
48		Rafaela Rocha				11 98797-6858	raphaela.admlojas@gmail.com		2017-09-22 15:33:38.131	3	16		Tem MEI e quer abrir loja.		2	3	1	1	1	4	\N
49		Tainá Corozza					taina_nc@hotmail.com		2017-09-22 15:34:32.578	3	16		Estudante. No futuro quer abrir uma plataforma online de decoração.		2	3	1	1	1	4	\N
50		Regina Matias			11 2362-0045		reginavic2@gmail.com		2017-09-22 15:38:11.176	3	16				2	4	1	1	1	4	\N
51		Julia Rufino Garcia				99102-9693	julia@juliarufino.com		2017-09-22 15:39:35.832	3	16				2	3	1	1	1	4	608
52	Acasaca Consultoria	Alexandra Manuela Casaca			11 3814-3614	11 996557205	alexandramanuelacasaca@gmail.com		2017-09-22 15:54:51.505	3	16				2	4	1	1	1	4	\N
142	Rede Farmais	----------			2117 5200		atendimento@farmais.com.br		2018-04-04 16:55:50.347	9	10				9	\N	0	0	0	4	\N
57	AGENCIA PALANDI					93802-8008	atendimento@agenciapalandi.com		2017-09-22 16:03:26.869	3	16				2	4	1	1	1	4	\N
56		Viviane Soares de Abreu Vieira				11 99649-6943	vvieira2002@uol.com.br		2017-09-22 16:02:13.829	3	16		*Verificação tributária.		2	4	1	1	1	4	\N
53		Nathalia Krisztan				11 95820-8888	nathalia.krisztan@gmail.com		2017-09-22 15:56:09.361	3	16				2	3	1	1	1	4	\N
133	Simone de Fátima Martins	Simone			3051 8286		gerencia@pellarin.com.br		2018-04-03 14:08:15.751	9	20				9	\N	0	0	0	4	665
54	BE Flexy	Manuela Brandão Borges				11 98457-6738	manuela.b.b@hotmail.com		2017-09-22 15:57:26.176	3	16		Licença de uso de programas de computador.		2	3	1	1	1	4	\N
65	Consultoria SantaISO	Cristina Vignatti	Comercial		2375-1828	99654-8092	cristina.vignatti@consultoriasantaiso.com.br	consultoriasantaiso.com.br	2017-10-05 14:58:20.837	2	16				2	\N	1	1	1	4	\N
59	Apas e Virgulas	Elisa Dinis				11 972287414	falecom@aspasevirgulas.com.br		2017-09-29 16:28:07.317	3	16		Editora.		2	4	1	1	1	4	\N
60		Ligia Bueno				11-998238519	soares.lia@uol.com.br		2017-09-29 16:29:15.564	3	16		Consultora informal. Quer abrir empresa.		2	3	1	1	1	4	\N
61	Irie Perfumaria	Andrea			5011-4089	5012-3654	contato.irieperfumaria@uol.com.br		2017-09-29 16:30:32.923	3	16				2	\N	1	1	1	4	\N
62		Dulcinéia Camilo				973039291	dulcicamilo7@outlook.com		2017-09-29 16:32:00.227	3	16		Personal & Professional Coaching.		2	\N	1	1	1	4	\N
63		Carine Riffo				981611102	carine.riffo@hotmail.com		2017-09-29 16:33:22.226	3	16		Consultora da Qualidade.		2	\N	1	1	1	4	\N
55		Lindalva Mota			11  3745-6000	11 98107-3285	cflindalvamota@cfconsultores.com.br		2017-09-22 16:00:15.982	3	16			Corretora de imóveis.	2	3	1	1	1	4	\N
73	Êxito Editorial	Heloisa Belluzzo	Publicitária		2476-9227	99797-9327	heloisa@exitoeditorial.com.br	www.exitoeditorial.com.br	2017-10-05 15:58:22.056	2	16		Comentário no cartão: "Muito interessante! Enviar apresentação."		2	\N	1	1	1	4	\N
74	ADS Comunicação Corporativa	Ingrid Rauscher	Diretoria	Av. Lavandisca, 777 CJ 132, CEP: 04515-011	5090-3007	99938-9435	ingridr@adsbrasil.com.br	www.adsbrasil.com.br	2017-10-05 16:17:10.112	2	16		Convite para BNI - Fernanda		2	\N	1	1	1	4	\N
66	Núcleo Avançado de Cursos em Estética (NASCE)	Fernanda, Jamili e Julieta					cursosnasce@gmail.com	www.nascecursos.com.br	2017-10-05 15:02:43.699	2	16		Fernanda Cardoso, Jamili Anbar e Julieta Anbar.		2	\N	1	1	1	4	\N
68	Proseftur	Darliana Moraes	comercial	Av. Nove de Julho, 3575 13º andar, Jundiaí, CEP: 13208-056	3090-0550/ 51/ 52/ 53		darliana.justino@proseftur	proseftur.com.br	2017-10-05 15:22:05.195	2	16		Assessoria em comércio exterior.\nOutro cartão recebido na feira:\nReginaldo Alves Costa [comercial]\nreginaldo.costa@proseftur.com.br		2	\N	1	1	1	4	\N
69	Crepe no Cone	Carolina			5666-3960	98495-5450	gourmetcrepenocone@hotmail.com		2017-10-05 15:35:10.86	2	16				2	3	1	1	1	4	\N
75	EFFYCENTER	Inacio Junior	Diretoria		4210-0241	97121-4131	inacio@effycenter.com.br	www.effycenter.com.br	2017-10-05 16:24:14.321	2	16				2	\N	1	1	1	4	\N
76	LigVet	Liege Ishida		Rua Clodomiro Amazonas, 1158 Lj. 2	3045-0054	97079-7337	liege@ligvet.com.br	www.ligvet.com.br	2017-10-05 16:45:07.579	2	16				2	\N	1	1	1	4	\N
77	Rosa Bebê, da Ju	Juliana Luz				98472-7278	contato@rosabebeju.com.br	www.rosabebeju.com.br	2017-10-05 17:05:26.208	2	16	Loja virtual.			2	\N	1	1	1	4	\N
78	Ma. Love intimates	Magda Ribeiro				97752-5084	maloveintimates@gmail.com		2017-10-05 17:29:21.315	2	16				2	\N	1	1	1	4	\N
79	Saúde VIP	Maria Stoze de Almeida		Av. Eng. Armando de Arruda Pereira, 2937 Bl. A, Cj. 410 - Jabaquara, CEP: 04309-011	5595-8756 / 2893-6117	98990-7124	maria@saudevipsp.com.br	www.saudevipsp.com.br	2017-10-06 08:58:27.785	2	16				2	\N	1	1	1	4	\N
80	Pra Saúde					99269-1806	contato@prasaudedistribuidora.com.br	www.prasaudedistribuidora.com.br	2017-10-06 09:14:45.03	2	16				2	\N	1	1	1	4	\N
5	Henrique Rocha Advogados	Henrique Rocha		Av. Prof. João Fiusa, 1901 Sala 411 - Ed. Fiusa Center, Ribeirão Preto/SP, 14.024-250	16 3446-0000	16 98191-0000	contato@henriquerocha.com.br	www.henriquerocha.com.br	2017-06-26 12:04:47.516	2	12		Este contato é agente do Neymar, Fagazza, etc. Ele é especialista em direitos de imagem. Enviar apresentação.		2	\N	1	1	1	2	\N
\.


