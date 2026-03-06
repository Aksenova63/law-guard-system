-- Скрипт инициализации базы данных Law Guard

-- Table: public.clients

-- DROP TABLE IF EXISTS public.clients;

CREATE TABLE IF NOT EXISTS public.clients
(
    client_id integer NOT NULL DEFAULT nextval('clients_client_id_seq'::regclass),
    business_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    inn character varying(12) COLLATE pg_catalog."default" NOT NULL,
    contact_phone character varying(20) COLLATE pg_catalog."default",
    email character varying(100) COLLATE pg_catalog."default",
    status character varying(20) COLLATE pg_catalog."default" DEFAULT 'trial'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT clients_pkey PRIMARY KEY (client_id),
    CONSTRAINT clients_email_key UNIQUE (email),
    CONSTRAINT clients_inn_key UNIQUE (inn)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.clients
    OWNER to postgres;



-- Table: public.lawyers

-- DROP TABLE IF EXISTS public.lawyers;

CREATE TABLE IF NOT EXISTS public.lawyers
(
    lawyer_id integer NOT NULL DEFAULT nextval('lawyers_lawyer_id_seq'::regclass),
    full_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    license_number character varying(50) COLLATE pg_catalog."default",
    experience_years integer,
    spesialization character varying(100) COLLATE pg_catalog."default",
    rating numeric(3,2) DEFAULT 5.00,
    is_available boolean DEFAULT true,
    hourly_rate numeric(10,2),
    CONSTRAINT lawyers_pkey PRIMARY KEY (lawyer_id),
    CONSTRAINT lawyers_lisence_number_key UNIQUE (license_number)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.lawyers
    OWNER to postgres;



-- Table: public.orders

-- DROP TABLE IF EXISTS public.orders;

CREATE TABLE IF NOT EXISTS public.orders
(
    order_id integer NOT NULL DEFAULT nextval('orders_order_id_seq'::regclass),
    client_id integer,
    lawyer_id integer,
    order_date timestamp without time zone DEFAULT now(),
    price numeric(10,2) NOT NULL,
    status character varying(50) COLLATE pg_catalog."default" DEFAULT 'open'::character varying,
    CONSTRAINT orders_pkey PRIMARY KEY (order_id),
    CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id)
        REFERENCES public.clients (client_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT orders_lawyer_id_fkey FOREIGN KEY (lawyer_id)
        REFERENCES public.lawyers (lawyer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orders
    OWNER to postgres;
