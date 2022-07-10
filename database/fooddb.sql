--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)

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
-- Name: additional; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.additional (
    id_additional bigint NOT NULL,
    image_url character varying(255),
    name character varying(30) NOT NULL,
    price integer NOT NULL,
    status integer
);


ALTER TABLE public.additional OWNER TO root;

--
-- Name: additional_category; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.additional_category (
    id_additional bigint NOT NULL,
    id_category bigint NOT NULL
);


ALTER TABLE public.additional_category OWNER TO root;

--
-- Name: bill; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.bill (
    id_bill bigint NOT NULL,
    date timestamp without time zone,
    id_transaction character varying(255),
    no_table integer NOT NULL,
    status_bill integer,
    total_price integer NOT NULL,
    id_pay_mode bigint NOT NULL,
    id_user bigint
);


ALTER TABLE public.bill OWNER TO root;

--
-- Name: public_category_id_category_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.public_category_id_category_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_category_id_category_seq OWNER TO root;

--
-- Name: category; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.category (
    id_category bigint DEFAULT nextval('public.public_category_id_category_seq'::regclass) NOT NULL,
    image_url character varying(255),
    name character varying(30) NOT NULL,
    status integer
);


ALTER TABLE public.category OWNER TO root;

--
-- Name: company; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.company (
    id_company bigint NOT NULL,
    address character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    manager_name character varying(255),
    name character varying(255) NOT NULL,
    nit_code character varying(255) NOT NULL,
    phone bigint,
    region character varying(255) NOT NULL,
    status integer,
    url_image character varying(255)
);


ALTER TABLE public.company OWNER TO root;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO root;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.orders (
    id_order bigint NOT NULL,
    amount integer NOT NULL,
    status_order integer,
    total integer NOT NULL,
    id_bill bigint NOT NULL,
    id_product bigint NOT NULL
);


ALTER TABLE public.orders OWNER TO root;

--
-- Name: orders_additional; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.orders_additional (
    id_order bigint NOT NULL,
    id_additional bigint NOT NULL
);


ALTER TABLE public.orders_additional OWNER TO root;

--
-- Name: pay_mode; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.pay_mode (
    id_pay_mode bigint NOT NULL,
    name character varying(30) NOT NULL,
    status integer
);


ALTER TABLE public.pay_mode OWNER TO root;

--
-- Name: public_products_id_product_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.public_products_id_product_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_products_id_product_seq OWNER TO root;

--
-- Name: product; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.product (
    id_product bigint DEFAULT nextval('public.public_products_id_product_seq'::regclass) NOT NULL,
    image_url character varying(255),
    calories integer NOT NULL,
    description character varying(500) NOT NULL,
    discount_point integer NOT NULL,
    duration character varying(255),
    highlight integer NOT NULL,
    name character varying(50) NOT NULL,
    price integer NOT NULL,
    status integer,
    id_category bigint NOT NULL
);


ALTER TABLE public.product OWNER TO root;

--
-- Name: public_subscriber_id_subscriber_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.public_subscriber_id_subscriber_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_subscriber_id_subscriber_seq OWNER TO root;

--
-- Name: user_app_id_user_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.user_app_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_app_id_user_seq OWNER TO root;

--
-- Name: user_app; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_app (
    id_user bigint DEFAULT nextval('public.user_app_id_user_seq'::regclass) NOT NULL,
    discount_point integer NOT NULL,
    email character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    phone bigint,
    status integer,
    url_image character varying(255),
    user_roles integer,
    username character varying(50) NOT NULL
);


ALTER TABLE public.user_app OWNER TO root;

--
-- Name: public_user_app_id_user_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.public_user_app_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_user_app_id_user_seq OWNER TO root;

--
-- Name: public_user_app_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.public_user_app_id_user_seq OWNED BY public.user_app.id_user;


--
-- Name: subscriber; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.subscriber (
    id_subscriber bigint DEFAULT nextval('public.public_subscriber_id_subscriber_seq'::regclass) NOT NULL,
    email character varying(255) NOT NULL,
    status integer
);


ALTER TABLE public.subscriber OWNER TO root;

--
-- Name: tax; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.tax (
    id_tax bigint NOT NULL,
    value double precision NOT NULL
);


ALTER TABLE public.tax OWNER TO root;

--
-- Data for Name: additional; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.additional (id_additional, image_url, name, price, status) FROM stdin;
11	\N	Jalapeño	1500	1
1	\N	Jamón	800	1
2	\N	Salami	500	1
9	\N	Carne	1500	1
10	\N	Cebolla	300	1
3	\N	Champiñones	500	1
6	\N	Pollo	700	1
8	\N	Tocino	600	1
140	\N	Piña	300	1
7	\N	Queso	500	1
\.


--
-- Data for Name: additional_category; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.additional_category (id_additional, id_category) FROM stdin;
1	1
1	2
1	75
2	1
2	2
2	75
9	1
9	2
9	52
9	75
10	1
10	2
10	52
10	75
3	1
3	2
3	75
6	1
6	2
6	52
6	75
8	1
8	2
8	75
140	1
140	2
7	1
7	2
7	52
7	75
11	2
11	52
11	3
\.


--
-- Data for Name: bill; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.bill (id_bill, date, id_transaction, no_table, status_bill, total_price, id_pay_mode, id_user) FROM stdin;
102	2022-06-16 17:42:52.526	36302bvdxysguaf	6	1	49200	2	3
132	2022-06-16 18:15:37.545	\N	6	0	30600	2	\N
185	2022-06-17 11:12:19.467	10tzp77779n0gnsy20g1v35	0	1	9000	3	\N
170	2022-06-17 20:43:01.529	\N	0	0	15000	2	\N
130	2022-06-17 20:53:13.788	\N	6	0	8000	2	4
113	2022-06-06 18:04:47.856	2xglllllksf0fhzkrlfrxpa	0	3	72200	3	3
121	2022-06-06 21:25:31.586	\N	0	0	38300	2	\N
137	2022-06-09 22:29:22.914	6dc777775kt0j8p4gy71vfb	0	0	33200	3	3
111	2022-06-06 17:58:38.548	\N	0	0	12000	2	\N
135	2022-06-09 15:27:52.869	\N	0	1	8000	1	\N
141	2022-06-13 19:26:55	\N	3	1	33600	2	\N
109	2022-06-14 00:00:00	1uo777779ms03kmffesw6ef	0	3	3000	3	\N
128	2022-06-11 00:00:00	1dhm7777773k0q2jl16ev3fl	0	3	12000	3	\N
144	2022-06-14 15:01:16.077	\N	0	1	45000	2	\N
173	2022-06-16 19:17:59.397	\N	0	0	7500	1	\N
179	2022-06-16 17:46:43.319	b0p7772vi5p0zn8ycfsco3	0	1	12000	3	178
181	2022-06-16 17:46:45.825	\N	0	1	0	2	178
182	2022-06-16 17:47:11.48	bemssssx4hu0a5zpws494r6	0	1	3000	3	178
210	2022-06-27 05:02:39.815	\N	0	1	18000	2	\N
211	2022-06-27 05:02:40.933	\N	0	1	18000	2	\N
214	2022-06-27 05:03:40.678	\N	0	1	12000	2	\N
216	2022-06-27 05:04:34.888	\N	0	1	12000	2	\N
218	2022-06-27 05:06:27.943	\N	0	1	9000	2	\N
220	2022-05-30 17:26:55.515	\N	0	1	0	2	\N
221	2022-05-30 17:26:55.515	\N	0	1	0	2	\N
222	2022-05-30 17:26:55.515	\N	0	1	0	2	\N
223	2022-05-30 17:26:55.515	\N	0	1	0	2	\N
224	2022-06-27 08:50:56.723	\N	0	1	12000	2	209
227	2022-05-30 17:26:55.515	\N	0	1	0	2	\N
228	2022-06-27 08:55:23.536	\N	0	1	9000	2	209
230	2022-06-27 08:58:24.583	\N	0	1	9000	2	209
234	2022-06-27 08:59:01.427	\N	0	1	12000	2	209
236	2022-06-27 09:06:07.968	\N	0	1	24000	2	209
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.category (id_category, image_url, name, status) FROM stdin;
1	https://pngimg.com/uploads/pizza/pizza_PNG7151.png	Pizza	1
2	https://burgerkingec.com/wp-content/uploads/2020/05/BK-Stacker-Doble-con-Queso-768x768.png	Burger	1
52	https://pngimg.com/uploads/sandwich/sandwich_PNG64.png	Sandwich	1
4	https://cdn.huntoffice.ie/images/D.cache.large/can-of-coke.jpg	Beverages	1
75	https://png.pngtree.com/png-clipart/20200224/original/pngtree-empanadas-meat-pie-icon-cartoon-style-png-image_5230163.jpg	Empanadas	1
3	https://www.subway.com/ns/images/menu/IND/ENG/new%20RPLC-ChickenTeriyaki_594%20x%20334.jpg	HotDog	1
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.company (id_company, address, city, manager_name, name, nit_code, phone, region, status, url_image) FROM stdin;
120	Calle 13 # 12-3	Buga	Juan Esteban Castaño	Burger Company	90033213-3	12333213	Valle del Cauca	1	\N
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.orders (id_order, amount, status_order, total, id_bill, id_product) FROM stdin;
110	1	1	3000	109	54
104	3	2	4500	102	24
105	1	2	7500	102	3
107	2	2	4000	102	59
106	1	2	16000	102	21
103	2	2	5200	102	17
108	3	2	12000	102	54
112	1	2	12000	111	1
131	1	0	8000	130	2
134	3	0	4500	132	24
133	3	0	26100	132	3
115	2	1	16000	113	2
114	3	1	39600	113	1
116	2	1	3000	113	24
117	2	1	9600	113	54
118	2	1	4000	113	59
138	2	2	4000	137	59
139	2	2	29200	137	15
145	1	0	8000	144	17
146	1	0	3000	144	54
147	2	0	4000	144	59
148	3	0	4500	144	24
149	2	0	30000	144	21
172	1	0	3000	170	54
171	1	0	12000	170	1
174	2	0	26000	173	15
175	1	0	7500	173	3
129	1	1	12000	128	1
122	1	1	6000	121	54
123	1	1	6200	121	17
124	1	1	17100	121	1
125	1	1	1500	121	24
126	1	1	2000	121	59
127	1	1	5500	121	54
142	2	1	17600	141	3
143	2	1	16000	141	2
136	1	1	8000	135	2
180	1	0	12000	179	1
183	1	0	3000	182	54
186	1	0	9000	185	17
213	2	0	18000	211	17
212	2	0	18000	210	17
215	1	0	12000	214	1
217	1	0	12000	216	1
219	1	0	9000	218	17
225	1	0	9000	224	17
226	1	0	12000	224	1
229	1	0	9000	228	17
231	1	0	3000	230	54
232	1	0	12000	230	1
233	1	0	9000	230	17
235	1	0	12000	234	1
237	2	0	24000	236	1
\.


--
-- Data for Name: orders_additional; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.orders_additional (id_order, id_additional) FROM stdin;
106	7
103	3
106	2
103	1
103	2
108	10
108	6
114	6
114	7
117	9
117	10
122	9
122	10
122	6
122	7
123	9
123	10
123	3
124	9
123	1
124	3
123	6
124	1
123	7
124	6
123	2
124	7
123	8
127	9
124	2
127	10
124	8
127	6
133	6
133	7
139	9
139	1
139	6
139	7
139	8
142	1
142	2
\.


--
-- Data for Name: pay_mode; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.pay_mode (id_pay_mode, name, status) FROM stdin;
1	CreditCard	1
2	Cash	1
3	Wompi	1
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.product (id_product, image_url, calories, description, discount_point, duration, highlight, name, price, status, id_category) FROM stdin;
63	https://www.dominos.co.in/files/items/Mexican_Green_Wave.jpg	700	A pizza loaded with crunchy onions, crisp capsicum, juicy tomatoes and jalapeno with a liberal sprinkling of exotic Mexican herbs.	15	20	0	Mexican Pizza 	15	1	1
3	https://www.dominos.co.in/files/items/Corn_&_Cheese.jpg	560	Classic Flavour	15	20	0	Cheeze and corn Pizza	16	1	1
2	https://www.subway.com/ns/images/menu/IND/ENG/new%20RPLC-ChickenTeriyaki_594%20x%20334.jpg	600	Spicy and cheezy	25	45	4	Classic Hotdog	12	1	3
59	https://www.coca-cola.ie/content/dam/one/ie/en/article-body/sleek-diet-coke-can.jpg	500	100ml	0	2	5	Coke	4	1	4
54	https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F44%2F2022%2F03%2F01%2Fcucumber-sandwich.jpg	300	A crispy vegetarian sandwich	0	10	3	Veggie Sandwich	8	1	52
23	https://burgerking-image.s3.amazonaws.com/products/PLP/web/2x_web_20220314064417809150_482x264jpg	800	A Signature Burger	321	15	0	Signature Burger	12	0	2
24	https://www.dominos.co.in/files/items/pepsi_black.png	1200	100ml	10	3	0	Pepsi	3	1	4
15	https://www.dominos.co.in/files/items/Deluxe_Veggie.jpg	300	Pizza for 4	12	15	0	Family Pizza	12	1	1
17	https://www.dominos.co.in/files/items/Veg_Extravaganz.jpg	100	Bang on Pizza	120	35	2	Mixed Pizza	15	1	1
1	https://burgerking-image.s3.amazonaws.com/products/PLP/web/2x_web_20220314070747025396_482x264jpg	800	Stuffed with greatness	15	30	2	Big MAC	9	1	2
21	https://burgerking-image.s3.amazonaws.com/products/PLP/web/2x_web_20210820040218595885_482x264jpg	200	Limited Edition	123	19	0	Peri Peri Burger	9	1	2
\.


--
-- Data for Name: subscriber; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.subscriber (id_subscriber, email, status) FROM stdin;
1	pi	1
2	jbfdbj@jbfdef.com	1
3	null	1
\.


--
-- Data for Name: tax; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.tax (id_tax, value) FROM stdin;
101	0.19
119	0.13
\.


--
-- Data for Name: user_app; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_app (id_user, discount_point, email, name, password, phone, status, url_image, user_roles, username) FROM stdin;
1	30	pedro@gmail.com	Pedrito	$2a$10$tvF0n4DEnuJaxlPb7lfIUeQQZ6pOl7.kRPPsZ7p4Nn2ZSM6oOrUfO	123123123	0	\N	2	Pedro Andrade Castaño
4	123	asd4@asd.com	Don Velez	$2a$10$F8J0y/utp9z.VjHkk97HhuVzMLl8ymO6K1G4Xg3jMknszumYT4pT2	30132132	1	https://res.cloudinary.com/di4wu7js0/image/upload/v1653609957/user/81024334_10212366553997358_1862806124630114304_n_eb7vhq.jpg	0	Velez123
3	0	asd3@asd.com	Juan Esteban	$2a$10$0oN85DQL6fdjzst2Yj6oPOzVPi5T11laZ3CP9RGQJizT71CHVC3rG	30132132	1	https://res.cloudinary.com/di4wu7js0/image/upload/v1653610733/user/yo_m8jww2.jpg	2	Juan123
2	0	asd2@asd.com	Carlos	$2a$10$tBdplkAQhrkRd.zokrkZseTCs/0oOSddXgN7eNiW4HWYZUjQKS9g6	30132132	1	\N	1	Carlos123
91	0	asdas12@asd.com	Juan123123es	$2a$10$pUxPTqeu2nRw9rQUqztKFuClljjlsR2jyEveA8LXvXogYQhol/9J6	1234567890	1	\N	2	cArliso
178	0	asdas@asd.com	asd	$2a$10$vqaB60JyF6fUp83K6AX/d.aZ6zVFKiEqAQTKidTaAW8e1MvoPDK.S	1234567893	1	\N	2	asd
184	0	asdas3123@asd.com	Juanes	$2a$10$VZZ02v78J3BqRlCW9SNge.Il5dPCM4kwBaJDf3BHyvgQ3eMmJ0T7O	1234567890	1	\N	2	Juanes
189	0	asdas@asd.coms	Juanes	$2a$10$SIxzTqxMOHqAJFllZ5HNS.9WETyEtQLGImv5.CwCFtqkxO6wc9PXG	1234567890	1	\N	2	Juanes11
195	0	asdasds@asd.com	pinak	$MIbynMc3T8PX3n5l$3800c7a05316d684256ba843d3f01e82e60d05b6c0826649283adbc198170ae7	474414744	1	\N	2	pinaka
197	0	newdd@asd.com	newusr	$2a$10$negAuQOeKSvQesrM3p2Wd.H9eWQyxMP9kbFMCOgspPXDDROU/o4uK	1234567902	1	\N	2	newusr
198	0	asdssss4@asd.com	lkjhg	$2a$10$F1ZCndxvB3T7CV33yubiIedq1Id2GdfJGzmMO8fdJBVWh/p7UcbDu	30132132	1	imagen/asda	2	lkjhg
199	131	asdfdssss4@asd.com	xyz	pbkdf2:sha256:260000$fBXPP3UO0IMvpXJM$d5afbd870365ab3108d05032c9decedbe14104ced113200d9f3f7d9ddadc3919	45475858	1	\N	0	xyz
204	0	cvb@asd.com	cvb	$2a$10$HPLACPwI9yMnxrrmEXiUD.6PIgaNxg2ki/g198DF6HTS8Hn3fQyH2	9898898	1	\N	2	cvb
206	0	werasdas@asd.com	wer	$2a$10$XppSkitlR5xmQ5dcsRnHp.3mkuQQjzruTPVG21ZYOqhf9rUnnY5xC	989555555	1	\N	2	wer
207	0	asdas@asd.ccom	ner	pbkdf2:sha256:260000$4t1CI0YaKFi7rPWE$26c77c45cbab3f7a9821de989e1658577584e9fbd607558221b397513d828836	544455454	1	\N	2	ner
209	0	dahahasdas@asd.com	dahajava	$2a$10$mIJC0TY.UO8sP/.Cbg2Mfu3hIGUMDaJHnc4TiE1L1pKII4jyc8Z3O	1234567895	1	\N	1	dahajava
208	0	daha@asd.com	daha	pbkdf2:sha256:260000$o6lPGPd9Ip2N77VU$6eb9c42dc5ef7a6dd4366bb9bdd92270c276ba7f4140f3691bd0fa57258dc16a	22122111	1	\N	0	daha
211	0	lpu@hvsd.cdf	lpu	pbkdf2:sha256:260000$IalRwMX3B0PNYWlq$95dfd62cc36dace59ae3231d2874a1a4a0df8cb50545b210d46b735e4ca705b1	1234567900	1	\N	2	lpu
210	0	fdgrfasdas@asd.com	dahauser	pbkdf2:sha256:260000$v0D3Ot4TzTSsHHEp$e2ee51052bfb01c9948f357ff8f15bcec4e44b52e45cffcd4573064e37bfa776	1234567900	1	\N	2	daha2
213	0	asdsas@asd.com	Pool	pbkdf2:sha256:260000$rhqeUbD1Lp2C4XxT$e0bab425b10b24358ac60138805e11cb7db1c2cd29f21b16bd7a4505b7852028	1234567890	1	\N	2	Pool
196	0	palakasdas@asd.com	palak1	$2a$10$IiW8S1NWN3lbch3Kofp4dupnjH9/UkO/9vwffIJNqNvadie31ePRe	1234567902	0	palak	2	palak
\.


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.hibernate_sequence', 237, true);


--
-- Name: public_category_id_category_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.public_category_id_category_seq', 76, true);


--
-- Name: public_products_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.public_products_id_product_seq', 66, true);


--
-- Name: public_subscriber_id_subscriber_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.public_subscriber_id_subscriber_seq', 3, true);


--
-- Name: public_user_app_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.public_user_app_id_user_seq', 1, false);


--
-- Name: user_app_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.user_app_id_user_seq', 214, true);


--
-- Name: additional additional_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.additional
    ADD CONSTRAINT additional_pkey PRIMARY KEY (id_additional);


--
-- Name: bill bill_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT bill_pkey PRIMARY KEY (id_bill);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id_category);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id_company);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id_order);


--
-- Name: pay_mode pay_mode_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.pay_mode
    ADD CONSTRAINT pay_mode_pkey PRIMARY KEY (id_pay_mode);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id_product);


--
-- Name: subscriber subscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (id_subscriber);


--
-- Name: tax tax_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.tax
    ADD CONSTRAINT tax_pkey PRIMARY KEY (id_tax);


--
-- Name: user_app uk_65kue06vu2g78mxpdfke453e5; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_app
    ADD CONSTRAINT uk_65kue06vu2g78mxpdfke453e5 UNIQUE (username);


--
-- Name: user_app user_app_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_app
    ADD CONSTRAINT user_app_pkey PRIMARY KEY (id_user);


--
-- Name: additional_category fk2m07sklkxgd7vyjxbs5bctx5j; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.additional_category
    ADD CONSTRAINT fk2m07sklkxgd7vyjxbs5bctx5j FOREIGN KEY (id_category) REFERENCES public.category(id_category);


--
-- Name: product fk5cxv31vuhc7v32omftlxa8k3c; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk5cxv31vuhc7v32omftlxa8k3c FOREIGN KEY (id_category) REFERENCES public.category(id_category);


--
-- Name: orders fk7mcrg6obolb5gmqmau68syq5w; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk7mcrg6obolb5gmqmau68syq5w FOREIGN KEY (id_bill) REFERENCES public.bill(id_bill);


--
-- Name: additional_category fkb8lcna7ci2rvlaheifdhaylk0; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.additional_category
    ADD CONSTRAINT fkb8lcna7ci2rvlaheifdhaylk0 FOREIGN KEY (id_additional) REFERENCES public.additional(id_additional);


--
-- Name: orders_additional fked3clfxhdf6hptyw8iavn0iq5; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders_additional
    ADD CONSTRAINT fked3clfxhdf6hptyw8iavn0iq5 FOREIGN KEY (id_order) REFERENCES public.orders(id_order);


--
-- Name: orders fkj790wqd8cmpk0dvlj8jq5hutj; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fkj790wqd8cmpk0dvlj8jq5hutj FOREIGN KEY (id_product) REFERENCES public.product(id_product);


--
-- Name: bill fkjpkei6owp31h9i5h3jrfjblh7; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fkjpkei6owp31h9i5h3jrfjblh7 FOREIGN KEY (id_user) REFERENCES public.user_app(id_user);


--
-- Name: orders_additional fkl8kyou4yotb4kk0r1f0mwu042; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.orders_additional
    ADD CONSTRAINT fkl8kyou4yotb4kk0r1f0mwu042 FOREIGN KEY (id_additional) REFERENCES public.additional(id_additional);


--
-- Name: bill fklh1ospom0x8e13d6a76ckp3do; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fklh1ospom0x8e13d6a76ckp3do FOREIGN KEY (id_pay_mode) REFERENCES public.pay_mode(id_pay_mode);


--
-- PostgreSQL database dump complete
--

