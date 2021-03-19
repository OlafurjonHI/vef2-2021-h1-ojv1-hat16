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
    overview character varying,
    serie character varying,
    serie_id bigint NOT NULL,
    name character varying
);


ALTER TABLE public.episode OWNER TO postgres;

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
    overview character varying,
    poster character varying NOT NULL,
    id bigint NOT NULL,
    number integer NOT NULL,
    serie character varying NOT NULL
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
    description character varying,
    image character varying NOT NULL,
    language character varying(2),
    name character varying NOT NULL,
    network character varying,
    tagline character varying,
    url character varying,
    id integer NOT NULL,
    air_date timestamp with time zone,
    in_production boolean
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

COPY public.episode (season_id, number, air_date, overview, serie, serie_id, name) FROM stdin;
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (name) FROM stdin;
Comedy
Action & Adventure
Documentary
Drama
Sci-Fi & Fantasy
Crime
Animation
Mystery
Family
\.


--
-- Data for Name: seasons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seasons (serie_id, name, air_date, overview, poster, id, number, serie) FROM stdin;
16	Season 3	2011-09-15 00:00:00+00	Season three opens the door to learn more about Klaus and the Original Family as his motives for wanting Stefan on his side are finally revealed. As Stefan sinks deeper into the dark side, Damon and Elena struggle with the guilt of their growing bond, even as they work together to bring Stefan back from the edge.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/h8ykwifcmpc4utsmolro.jpg	16	3	The Vampire Diaries
16	Season 2	2010-09-09 00:00:00+00	This season, Katherine's appearance in Mystic Falls will throw a wrench into the love triangle between Stefan, Elena and Damon, and the other residents of Mystic Falls must choose sides as they fall victim to a new breed of danger. New and unexpected friendships will be forged, allies will become enemies and hearts will be broken. Plus, Stefan and Damon will be forced to face a villain more evil and diabolical than they thought possible.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/ftgtgya6shje4zu5ustw.jpg	17	2	The Vampire Diaries
16	Season 1	2009-09-10 00:00:00+00	Life hasn't been the same for Elena since the tragic death of her parents, but she tries to pick up the pieces and provide support for her troubled younger brother, Jeremy. On her first day back at Mystic Falls High School, Elena meets the mysterious new guy, Stefan, and the two seeming lost souls form an instant connection. What Elena doesn't know, however, is that Stefan is a vampire, constantly resisting the urge to taste her blood. But Stefan, it seems, has a greater evil to deal with when his dangerous older brother, Damon, shows up to wreak havoc on the town of Mystic Falls — and claim Elena for himself.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/rzcrkkca4mwr6u5zvhif.jpg	18	1	The Vampire Diaries
18	Season 25	2013-09-29 01:00:00+01	The Simpsons' twenty-fifth season began airing on Fox on September 29, 2013.\\n\\nIn this season, Homer sells his Mapple stock to buy a bowling ball, Marge blames herself and KISS for Bart's rebellious streak, Lisa becomes a cheerleader for Springfield's football team, and Homer delivers a baby. Guest stars for this season will include Christiane Amanpour, Will Arnett, Stan Lee, Rachel Maddow, Elisabeth Moss, Joe Namath, Gordon Ramsay, Aaron Sorkin, Eva Longoria, Daniel Radcliffe, Kristen Wiig, Billy West, Katey Sagal, John DiMaggio, Phil LaMarr, Zach Galifianakis, Harlan Ellison, Anderson Cooper, Maurice LaMarche, and Judd Apatow. This is Al Jean's 13th consecutive season as showrunner and 15th overall. Matt Groening, James L. Brooks, Matt Selman, and John Frink serve as executive producers.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/qzlnvfwwhbnsz9az2qfn.jpg	19	25	The Simpsons
16	Season 6	2014-10-02 01:00:00+01	Season six follows the characters’ journey back to each other as they explore the duality of good versus evil inside themselves. Michael Malarkey joins the cast as Enzo, an old vampire friend from Damon’s past, and Matt Davis reprises his role as Alaric Saltzman, recently returned from The Other Side.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/qkzhmhtwqi3mr9ycyvwm.jpg	20	6	The Vampire Diaries
5	Season 4	2007-09-27 00:00:00+00	The fourth season of the American television medical drama Grey's Anatomy, commenced airing in the United States on September 27, 2007 and concluded on May 22, 2008. The season continues the story of a group of surgeons and their mentors in the fictional Seattle Grace Hospital, describing their professional lives and the way they affect the personal background of each character. Season four had twelve series regulars with ten of them returning from the previous season, out of which eight are part of the original cast from the first season. The season aired in the Thursday night timeslot at 9:00 EST. In addition to the regular seventeen episodes, a clip-show narrated by the editors of People recapped previous events of the show and made the transition from Grey's Anatomy to Private Practice, a spin-off focusing of Dr. Addison Montgomery and aired on September 19, 2007, before the season premiere. The season was officially released on DVD as a five-disc boxset under the title of Grey's Anatomy: Season Four – Expanded on September 9, 2008 by Buena Vista Home Entertainment.\\n\\nFor the first time in the show's history, many cast changes occur, seeing the first departure of two main cast members. The season received mixed response from critics and fans, resulting in several awards and nominations for the cast members and the production team. Show creator Shonda Rhimes heavily contributed to the production of the season, writing five out of the seventeen episodes. The highest-rated episode was the season premiere, which was watched by 20.93 million viewers. The season was interrupted by the 2007–2008 Writers Guild of America strike, which resulted in the production of only seventeen episodes, instead of twenty-three originally planned.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/iq1xavryp0cigeyiut3z.jpg	21	4	Grey's Anatomy
15	Season 1	2011-04-17 01:00:00+01	Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/jwytmbivqykhlagyfzwm.jpg	22	1	Game of Thrones
16	Season 5	2013-10-03 01:00:00+01	The hit series enters its fifth season with some characters headed off to college, Katherine trying to survive as a human and a shocking Salvatore secret.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/skomwnkohkyjkyew5cnp.jpg	23	5	The Vampire Diaries
15	Season 7	2017-07-16 01:00:00+01	The long winter is here. And with it comes a convergence of armies and attitudes that have been brewing for years.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/rmo7bodjj4cwluggdnrp.jpg	24	7	Game of Thrones
17	Season 3	2016-10-04 01:00:00+01	Forensic scientist Barry Allen, aka The Flash, is living his dream life. His parents are alive. He's dating beautiful, smart Iris West. And he's able to stand back and let the new speedster in town, Kid Flash, step in to protect Central City. But the better Barry's life gets, the more dangerous it becomes. His nemesis, Reverse Flash, warns Barry of serious repercussions if he remains in the alternate Flashpoint universe: In addition to memory loss, his powers will fade. When disaster strikes, Barry must decide whether to continue life as Barry Allen or return to his universe as The Flash. As Barry deals with his identity crisis, he and the S.T.A.R. Labs team fight off lethal threats from the God of Speed, Savitar.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/fgfiocenw1nqbyrqgbc0.jpg	25	3	The Flash
15	Season 4	2014-04-06 01:00:00+01	The War of the Five Kings is drawing to a close, but new intrigues and plots are in motion, and the surviving factions must contend with enemies not only outside their ranks, but within.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/vrxe0stedwse3rgwcicp.jpg	27	4	Game of Thrones
15	Season 6	2016-04-24 01:00:00+01	Following the shocking developments at the conclusion of season five, survivors from all parts of Westeros and Essos regroup to press forward, inexorably, towards their uncertain individual fates. Familiar faces will forge new alliances to bolster their strategic chances at survival, while new characters will emerge to challenge the balance of power in the east, west, north and south.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/kms8s0xfrv8dlhlhemz7.jpg	26	6	Game of Thrones
16	Season 7	2015-10-08 01:00:00+01	In the wake of Elena Gilbert's goodbye, in season seven, some characters will recover while others falter. As Lily tries to drive a wedge between the Salvatore brothers, we'll still hold onto hope that Stefan and Caroline's love story is strong enough to survive.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/jq3scktb9iq4j1um3xz7.jpg	28	7	The Vampire Diaries
18	Season 29	2017-10-01 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/nmvl3ei6kb7s6f77kibs.jpg	32	29	The Simpsons
16	Season 4	2012-10-11 00:00:00+00	The fourth season starts off with everything in transition. Elena faces her worst nightmare as she awakens from her deadly accident to find she must now endure the terrifying change of becoming a vampire — or face certain death. Stefan and Damon are torn even further apart over how to help Elena adjust to a life she never wanted, and everyone must cope with the chaos created after the vampires and their supporters were outed to the town council and local leaders. Despite everything, as Elena and her friends enter into the final stretch of high school before graduation sends them on different paths, they feel the bond to their home town of Mystic Falls take on a deeper meaning when a new mysterious villain is introduced who seems intent on destroying it.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/kl3etf79sbvklvhamt5t.jpg	33	4	The Vampire Diaries
5	Season 2	2005-09-25 00:00:00+00	The second season of the American television medical drama Grey's Anatomy commenced airing on the American Broadcasting Company on September 25, 2005, and concluded on May 15, 2006. The season was produced by Touchstone Television, in association with Shondaland production company and The Mark Gordon Company, the showrunner being Shonda Rhimes. Actors Ellen Pompeo, Sandra Oh, Katherine Heigl, Justin Chambers, and T.R. Knight reprised their roles as surgical interns Meredith Grey, Cristina Yang, Izzie Stevens, Alex Karev, and George O'Malley, respectively. Previous main cast members Chandra Wilson, James Pickens, Jr., Isaiah Washington, and Patrick Dempsey also returned, while Kate Walsh, who began the season in a recurring capacity, was promoted to series regular status, after appearing in seven episodes as a guest star.\\n\\nThe season continued to focus on the surgical residency of five young interns as they try to balance to the challenges of their competitive careers, with the difficulties that determine their personal lives. It was set in the fictional Seattle Grace Hospital, located in the city of Seattle, Washington. Whereas the first season put the emphasis mainly on the unexpected impact the surgical field has on the main characters, the second one provides a detailed perspective on the personal background of each character, focusing on the consequences that their decisions have on their careers. Throughout the season, new story lines were introduced, including the love triangle between Meredith Grey, Derek Shepherd, and Addison Montgomery, the main arc of the season. Also heavily developed was the story line involving Izzie Stevens' relationship with patient Denny Duquette, which resulted in critical acclaim and positive fan response.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/urefenegecw21q3gq6ex.jpg	36	2	Grey's Anatomy
16	Season 8	2016-10-21 01:00:00+01	The final season of "The Vampire Diaries" begins a few months after it left off, with Damon and Enzo on an epic killing spree after being kidnapped and enslaved by the Siren Sybil. During the search to find them, Stefan, Bonnie, Caroline, and Alaric discover that the mysterious force they are up against may be more powerful than they thought and they must go to great lengths to keep the people they love safe. When they discover Sybil's motive, they must do everything in their power to prevent her from accomplishing her goal. Caroline and Stefan take a big step in their relationship, but when Stefan is forced to turn off his humanity to protect the people he loves their plans are put on hold.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ezx63lh5fvjsi7logknr.jpg	39	8	The Vampire Diaries
18	Season 30	2018-09-30 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/e0zpqrdvtqsqynoawy6q.jpg	40	30	The Simpsons
5	Season 6	2009-09-24 00:00:00+00	The sixth season of the American television medical drama Grey's Anatomy, commenced airing on the American Broadcasting Company in the United States on September 24, 2009, and concluded on May 20, 2010. The season was produced by ABC Studios, in association with Shondaland Production Company and The Mark Gordon Company; the showrunner being Shonda Rhimes. Actors Ellen Pompeo, Sandra Oh, Katherine Heigl, and Justin Chambers reprised their roles as surgical residents Meredith Grey, Cristina Yang, Izzie Stevens, and Alex Karev, respectively. Heigl was released from her contract in the middle of the season, while T.R. Knight did not appear as George O'Malley, because Knight was released from his contract at the conclusion of season five. Main cast members Patrick Dempsey, Chandra Wilson, James Pickens, Jr., Sara Ramirez, Eric Dane, Chyler Leigh, and Kevin McKidd also returned, while previous recurring star Jessica Capshaw was promoted to a series regular, and Kim Raver was given star billing after the commencement of the season.\\n\\nThe season follows the story of surgical interns, residents and their competent mentors, as they experience the difficulties of the competitive careers they have chosen. It is set in the surgical wing of the fictional Seattle Grace Hospital, located in Seattle, Washington. A major storyline of the season is the characters adapting to change, as their beloved co-worker Stevens departed following the breakdown of her marriage, O'Malley died in the season premiere—following his being dragged by a bus, and new cardiothoracic surgeon Teddy Altman is given employment at the hospital. Further storylines include Shepherd being promoted to chief of surgery, Seattle Grace Hospital merging with the neighboring Mercy West —introducing several new doctors, and several physicians lives being placed into danger—when a grieving deceased patient's husband embarks on a shooting spree at the hospital, seeking revenge for his wife's death.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/atfhgq3fyslknfefy1bu.jpg	41	6	Grey's Anatomy
18	Season 6	1994-09-04 00:00:00+00	The Simpsons' sixth season originally aired on the Fox network between September 4, 1994, and May 21, 1995, and consists of 25 episodes. The Simpsons is an animated series about a working class family, which consists of Homer, Marge, Bart, Lisa, and Maggie. The show is set in the fictional city of Springfield, and lampoons American culture, society, television and many aspects of the human condition.\\n\\nThe showrunner for the sixth production season was David Mirkin who executive-produced 23 episodes. Former showrunners Al Jean and Mike Reiss produced the remaining two; they produced the two episodes with the staff of The Critic, the show they left The Simpsons to create. This was done in order to relieve some of the stress The Simpsons' writing staff endured, as they felt that producing 25 in one season was too much. The episode "A Star Is Burns" caused some controversy among the staff with Matt Groening removing his name from the episode's credits as he saw it as blatant advertising for The Critic, which was airing at the time. Fox moved The Simpsons back to its original Sunday night time, having aired on Thursdays for the previous four seasons. It has remained in this slot ever since. The sixth season won one Primetime Emmy Award, and received three additional nominations. It also won the Annie Award for Best Animated Television Production.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/frxj513bkgacxdvayaxf.jpg	48	6	The Simpsons
18	Season 2	1990-10-10 00:00:00+00	The Simpsons' second season originally aired between October 11, 1990 and May 9, 1991, and contained 22 episodes, beginning with "Bart Gets an F". Another episode, "Blood Feud" aired during the summer after the official season finale. The executive producers for the second production season were Matt Groening, James L. Brooks, and Sam Simon, who had also been EPs for the previous season. The DVD box set was released on August 6, 2002 in Region 1, July 8, 2002 in Region 2 and in September, 2002 in Region 4. The episode "Homer vs. Lisa and the 8th Commandment" won the Primetime Emmy Award for Outstanding Animated Program, and was also nominated in the "Outstanding Sound Mixing for a Comedy Series or a Special" category.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ufmustqipz8hbunjkvpy.jpg	50	2	The Simpsons
8	Season 1	2013-03-03 00:00:00+00		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/twrlfk7m4cn7t5t7sa9f.jpg	97	1	Vikings
14	Season 1	2021-02-10 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/rcoy51ry5xkeusiais55.jpg	29	1	Crime Scene: The Vanishing at the Cecil Hotel
18	Season 26	2014-09-28 01:00:00+01	In this season, Homer and Bart attempt to solve some father/son conflicts, Marge opens a sandwich franchise, the Simpsons meet their former selves, Bart schemes to bring down his new fourth grade teacher, Homer has a mid-life crisis, and the cast of Futurama make an appearance in Springfield.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/kidf8xbfkomclq7bas76.jpg	30	26	The Simpsons
15	Season 5	2015-04-12 01:00:00+01	The War of the Five Kings, once thought to be drawing to a close, is instead entering a new and more chaotic phase. Westeros is on the brink of collapse, and many are seizing what they can while the realm implodes, like a corpse making a feast for crows.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/xe5ovnvedtcjeggchiee.jpg	34	5	Game of Thrones
20	Season 1	2002-10-03 00:00:00+00	Deep within the Hidden Leaf Village, young ninja Naruto Uzumaki carries sealed inside him the Nine-Tailed Fox Spirit, which once almost destroyed the village. Always an outcast because of his secret, now Naruto battles alongside his teammates Sasuke and Sakura to prove to himself and everyone else that he's the greatest ninja ever. But he's got a long list of challenges to face before he gets there!	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/hxbvyqrjtj4ika5xqzjf.jpg	35	1	Naruto
18	Season 21	2009-09-27 00:00:00+00	The Simpsons' twenty-first season aired on Fox from September 27, 2009 to May 23, 2010. It was the first of two seasons that the show was renewed for by Fox, and also the first season of the show to air entirely in high definition.\\n\\nWith this season, The Simpsons established itself as the longest-running American primetime television series surpassing Gunsmoke.\\n\\nThe season received mainly positive reviews from critics, with many praising "The Squirt and the Whale", "To Surveil with Love" and "The Bob Next Door". The show moved up 16 positions in the Nielsen ratings from the previous season and received numerous award nominations, winning two - an Emmy Award for Anne Hathaway for her voicing in "Once Upon a Time in Springfield", and an Annie Award for "Treehouse of Horror XX".	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/cawj7ivgog0ccydttlgt.jpg	43	21	The Simpsons
18	Season 18	2006-09-10 00:00:00+00	The Simpsons' 18th season aired from September 10, 2006 to May 20, 2007. The season contained seven hold-over episodes from the season 17 production line. Al Jean served as the Showrunner, a position he has held since the thirteenth season.\\n\\nThe season finale, "You Kent Always Say What You Want", was the series' 400th episode. Additionally, the Simpsons franchise celebrated its 20th anniversary, as it has been on the air since April 1987, beginning with shorts on The Tracey Ullman Show.\\n\\nSeason 18 included guest appearances by Metallica, Tom Wolfe, Gore Vidal, Michael Chabon, Jonathan Franzen, Fran Drescher, The White Stripes, Kiefer Sutherland, Mary Lynn Rajskub, Richard Lewis, Phil McGraw, Elvis Stojko, Natalie Portman, Jon Lovitz, Betty White, Eric Idle, Sir Mix-a-Lot, Stephen Sondheim, Cristiano Ronaldo, Meg Ryan, Andy Dick, Peter Bogdanovich, James Patterson and others.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/myjepmi9cp9bra70btpi.jpg	44	18	The Simpsons
18	Season 14	2002-11-03 00:00:00+00	The fourteenth season of the animated television series The Simpsons was originally broadcast on the Fox network in the United States between November 3, 2002 and May 18, 2003. The show runner for the fourteenth production season was Al Jean, who executive produced 21 of 22 episodes. The other episode, "How I Spent My Strummer Vacation", was run by Mike Scully. The season contains five hold-overs from the previous season's production run. The fourteenth season won two Primetime Emmy Awards, including Outstanding Animated Program, four Annie Awards and a Writers Guild of America Award. On December 6, 2011, it was released on DVD and Blu-ray in North America.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/s9ssosibimxyfurucuew.jpg	52	14	The Simpsons
18	Season 28	2016-09-25 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/bivmyv0s09osvz80cm1l.jpg	53	28	The Simpsons
9	Season 1	2016-01-25 00:00:00+00	Bored with being the Lord of Hell, the devil relocates to Los Angeles, where he opens a nightclub and forms a connection with a homicide detective.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/dbc10j5ev56w6khvut3p.jpg	61	1	Lucifer
18	Season 11	1999-09-26 00:00:00+00	The Simpsons' 11th season originally aired between September 1999 and May 2000, beginning on Sunday, September 26, 1999, with "Beyond Blunderdome". The showrunner for the 11th production season was Mike Scully. The season contained four hold-over episodes from the season 10 production line.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/wyqhuy3mrqwq1s7h4rpm.jpg	62	11	The Simpsons
18	Season 16	2004-11-07 00:00:00+00	The Simpsons' 16th season began on Sunday, November 7, 2004 and contained 21 episodes, beginning with Treehouse of Horror XV. The season contains six hold-over episodes from the season 15 production line.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/w9imjf2kdqvf57xeywm3.jpg	63	16	The Simpsons
18	Season 9	1997-09-21 00:00:00+00	The Simpsons' ninth season originally aired between September 1997 and May 1998, beginning on Sunday, September 21, 1997 with "The City of New York vs. Homer Simpson". The showrunner for the ninth production season was Mike Scully. The aired season contained three episodes which were hold-over episodes from season eight, which Bill Oakley and Josh Weinstein ran. It also contained two episodes which were run by David Mirkin, and another two hold-over episodes from season seven which were run by Al Jean and Mike Reiss.\\n\\nSeason nine won three Emmy Awards: "Trash of the Titans" for Primetime Emmy Award for Outstanding Animated Program in 1998, Hank Azaria picked up "Outstanding Voice-Over Performance" for the voice of Apu Nahasapeemapetilon, and Alf Clausen and Ken Keeler picking up the "Outstanding Music and Lyrics" award. Clausen was also nominated for "Outstanding Music Direction" and "Outstanding Music Composition for a Series" for "Treehouse of Horror VIII". Season nine was also nominated for a "Best Network Television Series" award by the Saturn Awards and "Best Sound Editing" for a Golden Reel Award.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/vp6gryww9mhcc8oskpyv.jpg	71	9	The Simpsons
18	Season 24	2012-09-30 01:00:00+01	The Simpsons' twenty-fourth season began airing on Fox on September 30, 2012 and concluded on May 19, 2013.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/l3jcvaud8sihdrcjdduc.jpg	75	24	The Simpsons
5	Season 15	2018-09-27 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/mkccork6wboujwedwocj.jpg	101	15	Grey's Anatomy
2	Season 3	2018-10-10 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/zpuwkefnpzi70re1o2bv.jpg	102	3	Riverdale
2	Season 4	2019-10-09 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/chyijwuqwgrvtwheqm0m.jpg	110	4	Riverdale
18	Season 27	2015-09-27 01:00:00+01	The twenty-seventh season of The Simpsons began airing on September 27 2015 with the episode "Every Man's Dreams" it ended on May 22 2016 with the episode "Orange is the New Yellow ( A parody of Netflix show, Orange is the New Black)"	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/sguxbewr0cr9d9yy8bn0.jpg	31	27	The Simpsons
18	Season 31	2019-09-29 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/igrkmvznmtdmb1whjmpr.jpg	37	31	The Simpsons
9	Season 2	2016-09-19 01:00:00+01	Lucifer returns for another season, but his devil-may-care attitude may soon need an adjustment: His mother is coming to town.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/uinv33njnljbouab9yv4.jpg	38	2	Lucifer
15	Season 3	2013-03-31 00:00:00+00	Duplicity and treachery...nobility and honor...conquest and triumph...and, of course, dragons. In Season 3, family and loyalty are the overarching themes as many critical storylines from the first two seasons come to a brutal head. Meanwhile, the Lannisters maintain their hold on King's Landing, though stirrings in the North threaten to alter the balance of power; Robb Stark, King of the North, faces a major calamity as he tries to build on his victories; a massive army of wildlings led by Mance Rayder march for the Wall; and Daenerys Targaryen--reunited with her dragons--attempts to raise an army in her quest for the Iron Throne.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/xoq2lni62fbjmydzdvua.jpg	42	3	Game of Thrones
18	Season 17	2005-09-11 00:00:00+00	The Simpsons' seventeenth season originally aired between September 2005 and May 2006, beginning on Sunday, September 11, 2005. It broke Fox's tradition of pushing its shows' season premieres back to November to accommodate the Major League Baseball games airing on the network during September and October of each year.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/uc7bpwqlfwc1suuovghq.jpg	45	17	The Simpsons
18	Season 8	1996-10-27 00:00:00+00	The Simpsons' eighth season originally aired between October 27, 1996 and May 18, 1997, beginning with "Treehouse of Horror VII". The showrunners for the eighth production season were Bill Oakley and Josh Weinstein. The aired season contained two episodes which were hold-over episodes from season seven, which Oakley and Weinstein also ran. It also contained two episodes for which Al Jean and Mike Reiss were the show runners.\\n\\nSeason eight won multiple awards, including two Emmy Awards: "Homer's Phobia" won for Outstanding Animated Program in 1997, and Alf Clausen and Ken Keeler won for "Outstanding Individual Achievement in Music and Lyrics" with the song "We Put The Spring In Springfield" from the episode "Bart After Dark". Clausen also received an Emmy nomination for "Outstanding Music Direction" for "Simpsoncalifragilisticexpialacious". "Brother from Another Series" was nominated for the Emmy for "Sound Mixing For a Comedy Series or a Special". For "Homer's Phobia", Mike Anderson won the Annie Award for Best Individual Achievement: Directing in a TV Production, and the WAC Winner Best Director for Primetime Series at the 1998 World Animation Celebration. Gay & Lesbian Alliance Against Defamation awarded the episode the GLAAD Media Award for "Outstanding TV – Individual Episode".	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/vghnz8dq8l6fhvqlpjve.jpg	46	8	The Simpsons
15	Season 2	2012-04-01 00:00:00+00	The cold winds of winter are rising in Westeros...war is coming...and five kings continue their savage quest for control of the all-powerful Iron Throne. With winter fast approaching, the coveted Iron Throne is occupied by the cruel Joffrey, counseled by his conniving mother Cersei and uncle Tyrion. But the Lannister hold on the Throne is under assault on many fronts. Meanwhile, a new leader is rising among the wildings outside the Great Wall, adding new perils for Jon Snow and the order of the Night's Watch.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/i9erbhw4d1i2kwgzpj0b.jpg	47	2	Game of Thrones
18	Season 7	1995-09-17 00:00:00+00	The Simpsons' seventh season originally aired on the Fox network between September 17, 1995 and May 19, 1996. The show runners for the seventh production season were Bill Oakley and Josh Weinstein who would executive produce 21 episodes this season. David Mirkin executive produced the remaining four, including two hold overs that were produced for the previous season. The season was nominated for two Primetime Emmy Awards, including Outstanding Animated Program and won an Annie Award for Best Animated Television Program. The DVD box set was released in Region 1 December 13, 2005, Region 2 January 30, 2006 and Region 4 on March 22, 2006. The set was released in two different forms: a Marge-shaped box and also a standard rectangular-shaped box in which the theme is a movie premiere.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/fdkgmnpjkim36k89jfic.jpg	49	7	The Simpsons
18	Season 22	2010-09-26 00:00:00+00	The Simpsons' twenty-second season began airing on Fox on September 26, 2010 and ended on May 22, 2011. The Simpsons was renewed for at least two additional seasons during the twentieth season leading up to this season. The cast is currently signed through the 25th season. On November 11, 2010, the series was renewed for a 23rd season by Fox with 22 episodes.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/buwzvgyr6p2lmgj4ihk1.jpg	51	22	The Simpsons
3	Season 1	2017-09-25 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/c6allwqcvlbbd7khu9br.jpg	54	1	The Good Doctor
5	Season 9	2012-09-27 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/o7katylobv2otmckclfv.jpg	55	9	Grey's Anatomy
18	Season 4	1992-09-24 00:00:00+00	The Simpsons' fourth season originally aired on the Fox network between September 24, 1992 and May 13, 1993, beginning with "Kamp Krusty." The showrunners for the fourth production season were Al Jean and Mike Reiss. The aired season contained two episodes which were hold-over episodes from season three, which Jean and Reiss also ran. Following the end of the production of the season, Jean, Reiss and most of the original writing staff left the show. The season was nominated for two Primetime Emmy Awards and Dan Castellaneta would win one for his performance as Homer in "Mr. Plow". The fourth season was released on DVD in Region 1 on June 15, 2004, Region 2 on August 2, 2004 and in Region 4 on August 25, 2004.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/fyd1op80hpyfbndbtzpl.jpg	56	4	The Simpsons
5	Season 8	2011-09-22 00:00:00+00	The eighth season of the American television medical drama Grey's Anatomy, commenced airing on the American Broadcasting Company on September 22, 2011, with a special two-hour episode and ended on May 17, 2012 with the eighth season having a total of 24 episodes. The season was produced by ABC Studios, in association with Shondaland Production Company and The Mark Gordon Company; the showrunner being Shonda Rhimes.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/koicorsk888xgyz2hslj.jpg	58	8	Grey's Anatomy
11	Season 1	2019-11-12 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/pbnszcivf7le66zde395.jpg	100	1	The Mandalorian
18	Season 13	2001-11-06 00:00:00+00	The Simpsons' thirteenth season originally aired on the Fox network between November 6, 2001 and May 22, 2002 and consists of 22 episodes. The show runner for the thirteenth production season was Al Jean who executive-produced 17 episodes. Mike Scully executive-produced the remaining five, which were all hold-overs that were produced for the previous season. The Simpsons is an animated series about a working-class family, which consists of Homer, Marge, Bart, Lisa, and Maggie. The show is set in the fictional city of Springfield, and lampoons American culture, society, television and many aspects of the human condition.\\n\\nThe season won an Annie Award for Best Animated Television Production, and was nominated for several other awards, including two Primetime Emmy Awards, three Writers Guild of America Awards, and an Environmental Media Award. The Simpsons ranked 30th in the season ratings with an average viewership of 12.4 million viewers. It was the second highest rated show on Fox after Malcolm in the Middle. The DVD boxset was released in the United States and Canada on August 24, 2010, eight years after it had completed broadcast on television.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/vxfn82nsbydhzwq5nix3.jpg	57	13	The Simpsons
15	Season 8	2019-04-14 01:00:00+01	The Great War has come, the Wall has fallen and the Night King's army of the dead marches towards Westeros. The end is here, but who will take the Iron Throne?	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/l39kaeyo4ka9nuhz7pod.jpg	59	8	Game of Thrones
18	Season 19	2007-09-23 00:00:00+00	The Simpsons' nineteenth season originally aired on the Fox network between September 23, 2007 and May 18, 2008.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/bbztlq6hzujmycqrajq5.jpg	65	19	The Simpsons
18	Season 10	1998-08-23 00:00:00+00	The tenth season of the animated television series The Simpsons was originally broadcast on the Fox network in the United States between August 23, 1998 and May 16, 1999. It contains twenty-three episodes, starting with "Lard of the Dance". The Simpsons is a satire of a middle class American lifestyle epitomized by its family of the same name, which consists of Homer, Marge, Bart, Lisa and Maggie. Set in the fictional city of Springfield, the show lampoons American culture, society, television, and many aspects of the human condition.\\n\\nThe showrunner for the tenth season was Mike Scully. Before production began, a salary dispute between the main cast members of The Simpsons and Fox arose. However, it was soon settled and the actors' salaries were raised to $125,000 per episode. In addition to the large Simpsons cast, many guest stars appeared in season ten, including Phil Hartman in his last appearance before his death.\\n\\nThe season, which won the Annie Award for "Outstanding Achievement in an Animated Television Program", has been cited by several critics as the beginning of the series' decline in quality. It ranked twenty-fifth in the season ratings with an average of 13.5 million viewers per episode. The tenth season DVD boxset was released in the United States and Canada on August 7, 2007. It is available in two different packagings, both featuring Bart.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/lsk7q5wcntyyaviubn5y.jpg	66	10	The Simpsons
5	Season 3	2006-09-21 00:00:00+00	The third season of the American television medical drama Grey's Anatomy, commenced airing on the American Broadcasting Company on September 21, 2006, and concluded on May 17, 2007. The season was produced by Touchstone Television, in association with Shondaland Production Company and The Mark Gordon Company, the showrunner being Shonda Rhimes. Actors Ellen Pompeo, Sandra Oh, Katherine Heigl, Justin Chambers, and T.R. Knight reprised their roles as surgical interns Meredith Grey, Cristina Yang, Izzie Stevens, Alex Karev, and George O'Malley, respectively, continuing their expansive storylines as focal points throughout the season. Previous main cast members Chandra Wilson, James Pickens, Jr., Kate Walsh, Isaiah Washington, and Patrick Dempsey also returned, while previous guest stars Sara Ramirez and Eric Dane were promoted to series regulars, following the extension of their contracts.\\n\\nThe season followed the continuation of the surgical residency of five young interns, as they experience the demands of the competitive field of medicine, which becomes defining in their personal evolution. Although set in fictional Seattle Grace Hospital, located in Seattle, Washington, filming primarily occurred in Los Angeles, California. Whereas the first season mainly focused on the impact the surgical field has on the main characters, and the second one provided a detailed perspective on the physicians' private lives, the third season deals with the tough challenges brought by the last phase of the surgeons' internship, combining the professional motif emphasized in the first season, with the complex personal background used in the second. Through the season, several new storylines are introduced, including the arrival of Dane's character, Dr. Mark Sloan, conceived and introduced as an antagonizing presence.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/p2qz6dmhdgeldqyyzjgm.jpg	67	3	Grey's Anatomy
18	Season 32	2020-09-27 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/uyconoyxsjtahdthh3eo.jpg	70	32	The Simpsons
9	Season 3	2017-10-02 01:00:00+01	As Lucifer struggles with an identity crisis, a gruff new police lieutenant shakes up the status quo with Chloe and the rest of the LAPD.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/vdnsuuiqahcn5faodstw.jpg	99	3	Lucifer
8	Season 2	2014-02-27 00:00:00+00	Season two brings crises of faith, of power, of relationships. Brothers rise up against one another. Loyalties shift from friend to foe, and unlikely alliances are formed in the name of supremacy. Ragnar’s indiscretions threaten his marriage to Lagertha, tearing him and his beloved son apart. Plots are hatched, scores are settled, blood is spilled…all under the watchful eyes of the gods.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/oiovcbcwq0zippteqsr7.jpg	103	2	Vikings
6	Season 1	2021-01-08 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/azocudwd5mrguvrbvlny.jpg	104	1	Marvel Studios: Legends
17	Season 6	2019-10-08 01:00:00+01	When Barry and Iris deal with loss of their daughter, the team faces their greatest threat yet - one that threatens to destroy all of Central City; Killer Frost has a brush with death that will change her relationship with Caitlin. Faced with the news of his impending death, Barry's resiliency suffers as he struggles to fight fate.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/a04ulthaqrqjpzabrqfb.jpg	105	6	The Flash
3	Season 4	2020-11-02 01:00:00+01	Dr. Shaun Murphy continues to use his extraordinary medical gifts at St. Bonaventure Hospital’s surgical unit. As his romantic relationship with Lea deepens, he will also face new responsibilities as a fourth-year resident when he is put in charge of supervising a new set of residents that will test him in ways he cannot predict. Meanwhile, the team must deal with the uncertainty and pressure that the COVID-19 pandemic brings now that it has hit their hospital.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/jpgrruq6wa6elhcl1i3e.jpg	106	4	The Good Doctor
17	Season 4	2017-10-10 01:00:00+01	The mission of Barry Allen, aka The Flash, is once more to protect Central City from metahuman threats. But with Barry trapped in the Speed Force, this mission falls to his family – Detective Joe West; fiancée Iris West; and Wally West/Kid Flash – and the team at S.T.A.R. Labs: Caitlin Snow/Killer Frost, Cisco Ramon/Vibe and brilliant scientist Harrison Wells. When a powerful villain threatens to level the city unless The Flash appears, Cisco risks everything to free Barry. But this is only the first move in a deadly game with Clifford DeVoe, aka The Thinker, a mastermind who’s always ten steps ahead of Barry, no matter how fast Barry runs.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/sdxmguj867wjoccemhff.jpg	107	4	The Flash
5	Season 16	2019-09-26 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/xwd7uto8afnbhm2gvzxd.jpg	108	16	Grey's Anatomy
11	Season 2	2020-10-30 01:00:00+01	The Mandalorian and the Child continue their journey, facing enemies and rallying allies as they make their way through a dangerous galaxy in the tumultuous era after the collapse of the Galactic Empire.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/hrs6onsolexcorwhd7bk.jpg	109	2	The Mandalorian
5	Season 5	2008-09-25 00:00:00+00	The fifth season of the American television medical drama Grey's Anatomy, created by Shonda Rhimes, commenced airing on American Broadcasting Company in the United States on September 25, 2008 and concluded on May 14, 2009 with twenty-four aired episodes. The season follows the story of a group of surgeons as they go through their residency, while they also deal with the personal challenges and relationships with their mentors. Season five had thirteen series regulars with twelve of them returning from the previous season. The season aired in the Thursday night timeslot at 9:00 pm. The season was officially released on DVD as seven-disc boxset under the title of Grey's Anatomy: The Complete Fifth Season – More Moments on September 9, 2009 by Buena Vista Home Entertainment.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/gg1wep7okqy8rdold0wa.jpg	60	5	Grey's Anatomy
10	Season 1	2021-01-20 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190439/klgc60yussgzyuko4wgc.jpg	64	1	Daughter From Another Mother
9	Season 4	2019-05-08 00:00:00+00	As Chloe struggles to come to terms with Lucifer's disturbing revelation, a rogue priest sets out to stop a long-rumored prophecy.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/qg7mvdhu2ajzylhglakr.jpg	68	4	Lucifer
18	Season 5	1993-09-30 00:00:00+00	The Simpsons' fifth season originally aired on the Fox network between September 30, 1993 and May 19, 1994. The showrunner for the fifth production season was David Mirkin who executive produced 20 episodes. Al Jean and Mike Reiss executive produced the remaining two, which were both hold overs that were produced for the previous season. The season contains some of the series' most acclaimed episodes, including "Cape Feare" and "Rosebud". It also includes the 100th episode, "Sweet Seymour Skinner's Baadasssss Song". The season was nominated for two Primetime Emmy Awards and won an Annie Award for Best Animated Television Program as well as an Environmental Media Award and a Genesis Award. The DVD box set was released in Region 1 on December 21, 2004, Region 2 on March 21, 2005, and Region 4 on March 23, 2005.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/rg75goopo2yjpnlphtsd.jpg	69	5	The Simpsons
12	Season 2	2018-10-09 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ghvwo8grrmmmapl3719k.jpg	72	2	Black Lightning
18	Season 23	2011-09-25 00:00:00+00	The Simpsons' twenty-third season began airing on Fox on September 25, 2011 and ended on May 20, 2012. The show's 500th episode, "At Long Last Leave", aired on February 19, 2012.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/uj5rtizjkkp0xohfbwva.jpg	73	23	The Simpsons
5	Season 13	2016-09-22 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/pra5sbzhhbxvoq98eyji.jpg	74	13	Grey's Anatomy
19	Season 1	2020-05-17 00:00:00+00		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/b5slhhuz6ysco4wowbkt.jpg	87	1	Snowpiercer
13	Season 1	2021-01-22 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/zsuwmnf0d3lfjyxsvbad.jpg	88	1	Fate: The Winx Saga
18	Season 1	1989-12-16 00:00:00+00		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/jfbvf6lczj1tnzvp87va.jpg	89	1	The Simpsons
4	Season 1	2018-10-25 01:00:00+01	Continuing the tradition of The Vampire Diaries and The Originals, the story of the next generation of supernatural beings at the Salvatore Boarding School for the Young & Gifted. Klaus Mikaelson's daughter, 17-year-old Hope Mikaelson; Alaric Saltzman's twins, Lizzie and Josie Saltzman; and other young adults come of age in the most unconventional way possible, nurtured to be their best selves... in spite of their worst impulses. Will these young witches, vampires and werewolves become the heroes they want to be — or the villains they were born to be?	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/trqjzj6mubrp7pensjkg.jpg	90	1	Legacies
17	Season 5	2018-10-09 01:00:00+01	Barry Allen and his new wife, Iris West, finally settling into married life when they're visited by Nora West-Allen, their speedster daughter from the future. Nora's arrival brings to light the legacy every member of Team Flash will leave years from now, causing many to question who they are today. And while Nora idolizes Barry, she holds a mysterious grudge against Iris. As Team Flash adjusts to the next generation of speedster, they discover Nora's presence has triggered the arrival of the most ruthless, vicious and relentless villain they have ever faced: Cicada!	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/hy3gs4ghcbs6aphnluey.jpg	91	5	The Flash
7	Season 1	2018-05-02 01:00:00+01	Decades after the tournament that changed their lives, the rivalry between Johnny and Daniel reignites.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/cqezeyciklgeyicyvrid.jpg	92	1	Cobra Kai
17	Season 1	2014-10-07 01:00:00+01	When an unexpected accident at the S.T.A.R. Labs Particle Accelerator facility strikes Barry, he finds himself suddenly charged with the incredible power to move at super speeds. While Barry has always been a hero in his soul, his newfound powers have finally given him the ability to act like one. With the help of the research team at S.T.A.R. Labs, Barry begins testing the limits of his evolving powers and using them to stop crime. With a winning personality and a smile on his face, Barry Allen — aka The Flash — is finally moving forward in life … very, very fast!	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/cpxylj43enjtpjkumicf.jpg	93	1	The Flash
5	Season 11	2014-09-25 01:00:00+01	During an interview, Shonda Rhimes stated that "Season 11 is really a Meredith-centric season. She lost her ‘person’, her half-sister has shown up, her husband is chafing to go someplace else…” She went on to reveal that she's been wanting to do the "familial grenade" storyline for a long time, and at the end of Season 10, she knew it was the time to do it. Rhimes also claimed that Season 11 will pick up right where Season 10 left us, so there won't be much that the audience won't see. In another interview discussing this storyline, Rhimes revealed that she and the writers are thinking about doing flashback periods to the younger days of Drs. Ellis Grey and Richard Webber.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/rteepioyxanqyenvxypm.jpg	94	11	Grey's Anatomy
5	Season 14	2017-09-28 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/o82s7ykbbnrx8p6nqq74.jpg	95	14	Grey's Anatomy
18	Season 20	2008-09-28 00:00:00+00	The Simpsons' twentieth season aired on Fox from September 28, 2008 to May 17, 2009. With this season, the show tied Gunsmoke as the longest running American primetime television series in terms of total number of seasons. The season was released on BD January 12, 2010, making this the first season released on BD. It was released on DVD in Region 1 on January 12, 2010, and in Region 4 on January 20, 2010. The season was only released on DVD in Region 2 in a few areas.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/bqq5hbfmhup824sqtset.jpg	96	20	The Simpsons
18	Season 3	1991-09-19 00:00:00+00	The Simpsons' third season originally aired on the Fox network between September 19, 1991 and May 7, 1992. The showrunners for the third production season were Al Jean and Mike Reiss who executive produced 22 episodes for the season, while two other episodes were produced by James L. Brooks, Matt Groening, and Sam Simon. An additional episode, "Brother, Can You Spare Two Dimes?", aired on August 27, 1992 after the official end of the third season and is included on the Season 3 DVD set. Season three won six Primetime Emmy Awards for "Outstanding Voice-Over Performance" and also received a nomination for "Outstanding Animated Program" for the episode "Radio Bart". The complete season was released on DVD in Region 1 on August 26, 2003, Region 2 on October 6, 2003, and in Region 4 on October 22, 2003.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ihmsne7t0jkdassvvyrw.jpg	76	3	The Simpsons
18	Season 12	2000-11-01 00:00:00+00	The Simpsons' 12th season began on Wednesday, November 1, 2000 with "Treehouse of Horror XI". The season contains three hold over episodes from the season 11 production line. The show runner for the twelfth production was Mike Scully. The season features three episodes that were produced for the eleventh season which was also run by Scully. The season won and was nominated for numerous awards including two Primetime Emmy Awards wins and an Annie Award.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ktfaqu0k0q4sufr76t7t.jpg	77	12	The Simpsons
1	Season 1	2021-01-15 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/rcvj0rnswivyj1lohacn.jpg	78	1	WandaVision
18	Season 15	2003-11-02 00:00:00+00	The Simpsons' 15th season began on Sunday, November 2, 2003, with "Treehouse of Horror XIV". The season contains five hold-over episodes from the season 14 production line. The most watched episode had 16.2 million viewers and the least watched had 6.2 million viewers.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/fm92jckl6r8ryk51uiyh.jpg	79	15	The Simpsons
3	Season 3	2019-09-23 01:00:00+01	Dr. Shaun Murphy continues to use his extraordinary medical gifts at St. Bonaventure Hospital’s surgical unit. As his friendships deepen, Shaun tackles the world of dating for the first time and continues to work harder than he ever has before.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/mnqot4xailen3tbijvsy.jpg	80	3	The Good Doctor
3	Season 2	2018-09-24 01:00:00+01	Dr. Shaun Murphy’s world has begun to expand as he continues to work harder than he ever has before, navigating his new environment and relationships to prove to his colleagues at the prestigious St. Bonaventure Hospital’s surgical unit that his extraordinary medical gifts will save lives.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/yrvalfdjhhakqi3csnhq.jpg	81	2	The Good Doctor
8	Season 4	2016-02-18 00:00:00+00	A ferocious battle between the Vikings and the French eventually comes down to Ragnar against Rollo. The outcome will seal the fate of the two brothers.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/stqir2t23bul308qevcl.jpg	82	4	Vikings
5	Season 7	2010-09-23 00:00:00+00	The seventh season of the American television medical drama Grey's Anatomy, commenced airing on September 23, 2010 on the American Broadcasting Company, and concluded on May 19, 2011 ending the season with a total of 22 episodes. The season was produced by ABC Studios, in association with Shondaland Production Company and The Mark Gordon Company; the showrunner being Shonda Rhimes.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/iirxcidgrrdft4zoy4ng.jpg	83	7	Grey's Anatomy
17	Season 2	2015-10-06 01:00:00+01	Following the dramatic events of season 1, Team Flash quickly turns their attention to a threat high above Central City. Armed with the heart of a hero and the ability to move at super speeds, will Barry be able to save his city from impending doom?	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/zsk1pshqajcmflmaivnz.jpg	84	2	The Flash
7	Season 2	2019-04-24 01:00:00+01	Johnny continues building a new life, but a face from his past could disrupt his future. Meanwhile, Daniel opens a Miyagi-Do studio to rival Cobra Kai.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/duiopa92etjd0bhridj3.jpg	85	2	Cobra Kai
12	Season 1	2018-01-16 00:00:00+00		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/yfoyfhct4neotazjbx2h.jpg	86	1	Black Lightning
5	Season 10	2013-09-26 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/dviwf0i5b6nkzlynpgxl.jpg	98	10	Grey's Anatomy
5	Season 12	2015-09-24 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/kmblwwqxjdnx3eql5mfv.jpg	118	12	Grey's Anatomy
12	Season 3	2019-10-07 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/obp7wav1kc63ctw0r0qp.jpg	119	3	Black Lightning
5	Season 1	2005-03-27 00:00:00+00	The first season of the American television medical drama Grey's Anatomy, began airing in the United States on the American Broadcasting Company on March 27, 2005 and concluded on May 22, 2005. The first season introduces the main character, Meredith Grey, as she enrolls in Seattle Grace Hospital's internship program and faces unexpected challenges and surprises. Season one had nine series regulars, six of whom have been part of the main cast ever since. The season initially served as a mid-season replacement for the legal drama Boston Legal, airing in the Sunday night time slot at 10:00, after Desperate Housewives. Although no clip shows have been produced for this season, the events that occur are recapped in "Straight to Heart", a clip-show which aired one week before the winter holiday hiatus of the second season ended. The season was officially released on DVD as two-disc Region 1 box set under the title of Grey's Anatomy: Season One on February 14, 2006 by Buena Vista Home Entertainment.\\n\\nThe season's reviews and critiques were generally positive, and the series received several awards and nominations for the cast and crew. The first five episodes of the second season were conceived, written and shot to air as the final five episodes of the first season, but aired during the 2005-2006 season due to the high number of viewers that watched "Who's Zoomin' Who?", the season's highest-rated episode with 22.22 million viewers tuning in.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ksiltzfum11cu2jmuzte.jpg	111	1	Grey's Anatomy
8	Season 3	2015-02-19 00:00:00+00	With the promise of new land from the English, Ragnar leads his people to an uncertain fate on the shores of Wessex. King Ecbert has made many promises and it remains to be seen if he will keep them. But ever the restless wanderer, Ragnar is searching for something more … and he finds it in the mythical city of Paris.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/ktqyzg22nlusovekhzdq.jpg	117	3	Vikings
4	Season 2	2019-10-10 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/tltwsxfprv3fsdaxfijd.jpg	120	2	Legacies
2	Season 5	2021-01-20 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/fszosx1bqckkvgiw9vs7.jpg	121	5	Riverdale
12	Season 4	2021-02-08 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190441/wstr1t3uxcydr84rp1qx.jpg	122	4	Black Lightning
2	Season 2	2017-10-11 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/qd1ajl6crctwzifjopnh.jpg	123	2	Riverdale
5	Season 17	2020-11-12 01:00:00+01		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190441/b70enzlirvnvg3vrntx4.jpg	124	17	Grey's Anatomy
9	Season 5	2020-08-21 01:00:00+01	Lucifer makes a tumultuous return to the land of the living in hopes of making things right with Chloe. A devil’s work is never done.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190441/olp22q4zs0mmkexzfak6.jpg	125	5	Lucifer
19	Season 2	2021-01-25 01:00:00+01	In season two, an entirely new power struggle emerges, causing a dangerous rift as people are divided between their loyalty to Layton and to Mr. Wilford, who has a new train, new technology and a game plan that keeps everyone guessing. While Layton battles Wilford for the soul of Snowpiercer, Melanie leads the charge on a shocking new discovery that could change the fate of humanity.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190441/hurjfsxl9mtj4hkwqflw.jpg	126	2	Snowpiercer
4	Season 3	2021-01-21 01:00:00+01	As season three begins, Hope has risked everything to pull her friends back from the brink of a monstrous prophecy that threatened them. But when a heartbreaking loss shatters her whole world, Hope Mikaelson will be forced to fight fate itself.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190442/vl7nbfrdbhlk9bgejbzk.jpg	127	3	Legacies
7	Season 3	2021-01-01 01:00:00+01	With a new sensei at the helm of the Cobra Kai dojo, a three-way feud takes center stage. Old grudges — like Cobra Kai — never die.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/mocnll6oqv2sdg0xjodo.jpg	112	3	Cobra Kai
8	Season 5	2017-11-29 00:00:00+00	Season five begins with Ivar the Boneless asserting his leadership over the Great Heathen Army, while Lagertha reigns as Queen of Kattegat. Ivar’s murder of his brother Sigurd sets the stage for vicious battles to come as Ragnar’s sons plot their next moves after avenging their father’s death. Bjorn follows his destiny into the Mediterranean Sea and Floki who is suffering from the loss of his wife Helga, takes to the seas submitting himself to the will of the Gods. This season is full of startling alliances and unbelievable betrayals as the Vikings fight to rule the world.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/efvsrt86godbvadrn0ob.jpg	113	5	Vikings
2	Season 1	2017-01-26 00:00:00+00		http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/whc2coby23vvhugwdusr.jpg	114	1	Riverdale
8	Season 6	2019-12-04 01:00:00+01	The final season finds Bjorn now the king of Kattegat, while Ivar is a fugitive in Russia and Lagertha plans a peaceful retirement to a country farm.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/h53l6laltxijgjf3g2x2.jpg	115	6	Vikings
17	Season 7	2021-03-02 01:00:00+01	After a thrilling cliffhanger last season which saw the new Mirror Master victorious and still-at-large in Central City, The Flash must regroup in order to stop her and find a way to make contact with his missing wife, Iris West-Allen. With help from the rest of Team Flash, Barry will ultimately defeat Mirror Master. But in doing so, he’ll also unleash an even more powerful and devastating threat on Central City: one that threatens to tear his team—and his marriage—apart.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190440/fceb4rzkd3aenqykohet.jpg	116	7	The Flash
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.series (description, image, language, name, network, tagline, url, id, air_date, in_production) FROM stdin;
In another world, ninja are the ultimate power, and in the Village Hidden in the Leaves live the stealthiest ninja in the land. Twelve years earlier, the fearsome Nine-Tailed Fox terrorized the village and claimed many lives before it was subdued and its spirit sealed within the body of a baby boy. That boy, Naruto Uzumaki, has grown up to become a ninja-in-training who's more interested in pranks than in studying ninjutsu.. but Naruto is determined to become the greatest ninja ever!	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190279/irbf4dxuts1xn0fpichv.jpg	ja	Naruto	TV Tokyo		http://www.tv-tokyo.co.jp/anime/naruto2002/	20	2002-10-03 00:00:00+00	f
After realizing their babies were exchanged at birth, two women develop a plan to adjust to their new lives: creating a single —and peculiar— family.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/s3icusbb9pjzdg6pygql.jpg	es	Daughter From Another Mother	Netflix		https://www.netflix.com/title/81002483	10	2021-01-20 01:00:00+01	t
Revisit the epic heroes, villains and moments from across the MCU in preparation for the stories still to come. Each dynamic segment feeds directly into the upcoming series — setting the stage for future events. This series weaves together the many threads that constitute the unparalleled Marvel Cinematic Universe.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/q1emqpdeuggn9s3xeg4s.jpg	en	Marvel Studios: Legends	Disney+	As the universe expands, explore the stories of those destined to become legends.	https://www.disneyplus.com/series/wp/7YmtoS60RMH6	6	2021-01-08 01:00:00+01	t
The story of two vampire brothers obsessed with the same girl, who bears a striking resemblance to the beautiful but ruthless vampire they knew and loved in 1864.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/zgl3gt3stmt7ftkkrr5c.jpg	en	The Vampire Diaries	The CW	You remember your first kiss forever... and ever.	http://www.cwtv.com/shows/the-vampire-diaries	16	2009-09-10 00:00:00+00	f
After the fall of the Galactic Empire, lawlessness has spread throughout the galaxy. A lone gunfighter makes his way through the outer reaches, earning his keep as a bounty hunter.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/layakxqrxv46gylzum7b.jpg	en	The Mandalorian	Disney+	Bounty hunting is a complicated profession.	https://www.disneyplus.com/series/the-mandalorian/3jLIGMDYINqD	11	2019-11-12 01:00:00+01	t
The notorious Cecil Hotel grows in infamy when guest Elisa Lam vanishes. A dive into crime's darkest places.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/m8pjg0papksg5qnj8khb.jpg	en	Crime Scene: The Vanishing at the Cecil Hotel	Netflix		https://www.netflix.com/title/81183727	14	2021-02-10 01:00:00+01	f
The coming-of-age journey of five fairies attending Alfea, a magical boarding school in the Otherworld where they must learn to master their powers while navigating love, rivalries, and the monsters that threaten their very existence.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/dzpfbwobi8f9zlsmkkjl.jpg	en	Fate: The Winx Saga	Netflix	Channel your element. Change your fate.	https://www.netflix.com/title/80220679	13	2021-01-22 01:00:00+01	t
A young surgeon with Savant syndrome is recruited into the surgical unit of a prestigious hospital. The question will arise: can a person who doesn't have the ability to relate to people actually save their lives	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/clhi2ng89uzjxxn8ieew.jpg	en	The Good Doctor	ABC	His mind is a mystery, his methods are a miracle.	http://abc.go.com/shows/the-good-doctor	3	2017-09-25 01:00:00+01	t
Bored and unhappy as the Lord of Hell, Lucifer Morningstar abandoned his throne and retired to Los Angeles, where he has teamed up with LAPD detective Chloe Decker to take down criminals. But the longer he's away from the underworld, the greater the threat that the worst of humanity could escape.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/pnktas6kv8ycuukvvtb9.jpg	en	Lucifer	FOX	It's good to be bad.	https://www.netflix.com/title/80057918	9	2016-01-25 00:00:00+00	t
After a particle accelerator causes a freak storm, CSI Investigator Barry Allen is struck by lightning and falls into a coma. Months later he awakens with the power of super speed, granting him the ability to move through Central City like an unseen guardian angel. Though initially excited by his newfound powers, Barry is shocked to discover he is not the only "meta-human" who was created in the wake of the accelerator explosion -- and not everyone is using their new powers for good. Barry partners with S.T.A.R. Labs and dedicates his life to protect the innocent. For now, only a few close friends and associates know that Barry is literally the fastest man alive, but it won't be long before the world learns what Barry Allen has become...The Flash.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/cume39t69gdm2lk91ozz.jpg	en	The Flash	The CW	The fastest man alive.	http://www.cwtv.com/shows/the-flash/	17	2014-10-07 01:00:00+01	t
Follows the personal and professional lives of a group of doctors at Seattle’s Grey Sloan Memorial Hospital.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/dtng34dz9dyf6pnjki1c.jpg	en	Grey's Anatomy	ABC	The life you save may be your own.	http://abc.go.com/shows/greys-anatomy	5	2005-03-27 00:00:00+00	t
Set more than seven years after the world has become a frozen wasteland, the remnants of humanity inhabit a gigantic, perpetually-moving train that circles the globe as class warfare, social injustice and the politics of survival play out.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/gwulevi6tvggbdrquu7g.jpg	en	Snowpiercer	TNT	Prepare to brace.	https://www.tntdrama.com/snowpiercer	19	2020-05-17 00:00:00+00	t
This Karate Kid sequel series picks up 30 years after the events of the 1984 All Valley Karate Tournament and finds Johnny Lawrence on the hunt for redemption by reopening the infamous Cobra Kai karate dojo. This reignites his old rivalry with the successful Daniel LaRusso, who has been working to maintain the balance in his life without mentor Mr. Miyagi.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/xocskbfnjylydvbfgvgc.jpg	en	Cobra Kai	Netflix	Cobra Kai never dies.	https://www.netflix.com/title/81002370	7	2018-05-02 01:00:00+01	t
Set in Springfield, the average American town, the show focuses on the antics and everyday adventures of the Simpson family; Homer, Marge, Bart, Lisa and Maggie, as well as a virtual cast of thousands. Since the beginning, the series has been a pop culture icon, attracting hundreds of celebrities to guest star. The show has also made name for itself in its fearless satirical take on politics, media and American life in general.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/wssh1ggao1o8jxavj83j.jpg	en	The Simpsons	FOX	On your marks, get set, d'oh!	http://www.thesimpsons.com/	18	1989-12-16 00:00:00+00	t
Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/ir2wgajpfmenjyssajha.jpg	en	Game of Thrones	HBO	Winter Is Coming	http://www.hbo.com/game-of-thrones	15	2011-04-17 01:00:00+01	f
Set in the present, the series offers a bold, subversive take on Archie, Betty, Veronica and their friends, exploring the surreality of small-town life, the darkness and weirdness bubbling beneath Riverdale’s wholesome facade.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/f3z9x407eqyqyxusixmb.jpg	en	Riverdale	The CW	Small town. Big secrets.	http://www.cwtv.com/shows/riverdale/	2	2017-01-26 00:00:00+00	t
The adventures of Ragnar Lothbrok, the greatest hero of his age. The series tells the sagas of Ragnar's band of Viking brothers and his family, as he rises to become King of the Viking tribes. As well as being a fearless warrior, Ragnar embodies the Norse traditions of devotion to the gods. Legend has it that he was a direct descendant of Odin, the god of war and warriors.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190281/nkg2tj2oisxpmrytvohf.jpg	en	Vikings	Amazon		http://www.history.com/shows/vikings	8	2013-03-03 00:00:00+00	f
Jefferson Pierce is a man wrestling with a secret. As the father of two daughters and principal of a charter high school that also serves as a safe haven for young people in a New Orleans neighborhood overrun by gang violence, he is a hero to his community.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190283/dnwckg8qsmivwjkfzzwm.jpg	en	Black Lightning	The CW	High voltage action	http://cwtv.com/shows/black-lightning	12	2018-01-16 00:00:00+00	t
Wanda Maximoff and Vision—two super-powered beings living idealized suburban lives—begin to suspect that everything is not as it seems.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190280/m8a1ejihufgivlzqi5x3.jpg	en	WandaVision	Disney+	Experience a new vision of reality.	https://www.disneyplus.com/series/wandavision/4SrN28ZjDLwH	1	2021-01-15 01:00:00+01	t
In a place where young witches, vampires, and werewolves are nurtured to be their best selves in spite of their worst impulses, Klaus Mikaelson’s daughter, 17-year-old Hope Mikaelson, Alaric Saltzman’s twins, Lizzie and Josie Saltzman, among others, come of age into heroes and villains at The Salvatore School for the Young and Gifted.	http://res.cloudinary.com/vef2-2021-h2/image/upload/v1616190282/yvkwludgip5ykkljcyfm.jpg	en	Legacies	The CW	Heroes. Villains. Whatever.	http://www.cwtv.com/shows/legacies	4	2018-10-25 01:00:00+01	t
\.


--
-- Data for Name: series_genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.series_genres (series_id, genres_name) FROM stdin;
20	Animation
10	Comedy
6	Documentary
11	Sci-Fi & Fantasy
16	Drama
14	Documentary
13	Sci-Fi & Fantasy
20	Action & Adventure
13	Drama
14	Mystery
20	Sci-Fi & Fantasy
10	Drama
9	Sci-Fi & Fantasy
3	Drama
9	Crime
17	Drama
17	Sci-Fi & Fantasy
5	Drama
19	Sci-Fi & Fantasy
7	Action & Adventure
7	Drama
18	Animation
16	Sci-Fi & Fantasy
18	Comedy
18	Family
11	Action & Adventure
14	Crime
15	Sci-Fi & Fantasy
15	Drama
15	Action & Adventure
2	Mystery
2	Drama
2	Crime
1	Sci-Fi & Fantasy
1	Mystery
1	Drama
8	Action & Adventure
8	Drama
4	Sci-Fi & Fantasy
4	Drama
12	Action & Adventure
12	Sci-Fi & Fantasy
12	Drama
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
-- Name: seasons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seasons_id_seq', 127, true);


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
-- Name: episode validate; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.episode
    ADD CONSTRAINT validate CHECK ((number > 0)) NOT VALID;


--
-- Name: seasons validate; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.seasons
    ADD CONSTRAINT validate CHECK ((number > 0)) NOT VALID;


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

