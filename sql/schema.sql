--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: episode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.episode (
    season_id bigint NOT NULL,
    number integer NOT NULL,
    air_date timestamp with time zone,
    description character varying
);


ALTER TABLE public.episode OWNER TO postgres;

--
-- Name: episode_number_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.episode ALTER COLUMN number ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.episode_number_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);


--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    name character varying NOT NULL
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- Name: seasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seasons (
    serie_id bigint NOT NULL,
    name character varying NOT NULL,
    air_date timestamp with time zone,
    description character varying,
    poster character varying NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.seasons OWNER TO postgres;

--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.seasons ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.series (
    air_date timestamp with time zone,
    description character varying,
    image character varying NOT NULL,
    in_production boolean,
    language character varying(2),
    name character varying NOT NULL,
    network character varying,
    tagline character varying,
    url character varying,
    id integer NOT NULL
);


ALTER TABLE public.series OWNER TO postgres;

--
-- Name: series_genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.series_genres (
    series_id bigint NOT NULL,
    genres_name character varying NOT NULL
);


ALTER TABLE public.series_genres OWNER TO postgres;

--
-- Name: series_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.series_id_seq OWNER TO postgres;

--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.series_id_seq OWNED BY public.series.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    password character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    CONSTRAINT minlength CHECK ((length((password)::text) >= 10))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_series (
    series_id bigint NOT NULL,
    user_id bigint NOT NULL,
    status character varying,
    rating integer NOT NULL
);


ALTER TABLE public.users_series OWNER TO postgres;

--
-- Name: users_series_rating_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users_series ALTER COLUMN rating ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_series_rating_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 5
    CACHE 1
);


--
-- Name: series id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series ALTER COLUMN id SET DEFAULT nextval('public.series_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: episode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.episode (season_id, number, air_date, description) FROM stdin;
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (name) FROM stdin;
\.


--
-- Data for Name: seasons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seasons (serie_id, name, air_date, description, poster, id) FROM stdin;
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.series (air_date, description, image, in_production, language, name, network, tagline, url, id) FROM stdin;
\.


--
-- Data for Name: series_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.series_genres (series_id, genres_name) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, password, admin, username, email) FROM stdin;
\.


--
-- Data for Name: users_series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_series (series_id, user_id, status, rating) FROM stdin;
\.


--
-- Name: episode_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.episode_number_seq', 0, false);


--
-- Name: seasons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seasons_id_seq', 1, false);


--
-- Name: series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.series_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: users_series_rating_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_series_rating_seq', 0, false);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (name);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: series_genres series_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series_genres
    ADD CONSTRAINT series_genres_pkey PRIMARY KEY (series_id, genres_name);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: users uniques; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uniques UNIQUE (username, email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: series_genres genres_name; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series_genres
    ADD CONSTRAINT genres_name FOREIGN KEY (genres_name) REFERENCES public.genres(name) NOT VALID;


--
-- Name: episode seasons_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episode
    ADD CONSTRAINT seasons_id FOREIGN KEY (season_id) REFERENCES public.seasons(id) NOT VALID;


--
-- Name: seasons serie_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT serie_id FOREIGN KEY (serie_id) REFERENCES public.series(id);


--
-- Name: series_genres series_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.series_genres
    ADD CONSTRAINT series_id FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: users_series series_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_series
    ADD CONSTRAINT series_id FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: users_series users_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_series
    ADD CONSTRAINT users_id FOREIGN KEY (series_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

