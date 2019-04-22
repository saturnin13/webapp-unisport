--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: check_creator_has_phone_number(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_creator_has_phone_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
               BEGIN
                 IF NOT EXISTS
                    (WITH helper AS
                       (SELECT users.telephone_number,
                               events.user_id,
                               events.id AS event_id
                        FROM users JOIN events ON users.id = events.user_id)
                     SELECT *
                     FROM helper
                     WHERE helper.user_id = NEW.user_id
                     AND   helper.event_id = NEW.id
                     AND   helper.telephone_number IS NOT NULL)
                 THEN RAISE EXCEPTION 'User has not given his telephone number.';
                 END IF;
                 RETURN NEW;
               END;
             $$;


--
-- Name: check_email_is_valid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_email_is_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
               BEGIN
                 IF NOT EXISTS (SELECT *
                                FROM university_mails
                                WHERE NEW.email ILIKE ('%@' || university_mails.mail_extension))
                 THEN RETURN NULL;
                 END IF;
                 RETURN NEW;
               END;
             $$;


--
-- Name: check_participants_is_valid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_participants_is_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
               BEGIN
                 IF EXISTS
                    (WITH helper AS
                      (SELECT SUM (CASE WHEN event_participants.confirmed
                                        THEN event_participants.participants ELSE 0 END)
                              OVER (PARTITION BY event_participants.event_id) AS confirmed_participants,
                              events.needed AS needed,
                              events.id AS event_id
                       FROM events JOIN event_participants ON events.id = event_participants.event_id)
                     SELECT *
                     FROM helper
                     WHERE helper.event_id = NEW.event_id
                     AND  ((NEW.confirmed = true AND helper.confirmed_participants > helper.needed)
                           OR (NEW.confirmed = false AND helper.confirmed_participants + NEW.participants > helper.needed)))
                 THEN RAISE EXCEPTION 'Too many participants';
                 END IF;
                 RETURN NEW;
               END;
             $$;


--
-- Name: check_participants_is_valid_creator(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_participants_is_valid_creator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
               BEGIN
                 IF EXISTS
                    (WITH helper AS
                      (SELECT SUM (CASE WHEN event_participants.confirmed
                                        THEN event_participants.participants ELSE 0 END)
                              OVER (PARTITION BY event_participants.event_id) AS confirmed_participants,
                              events.needed AS needed,
                              events.id AS event_id
                       FROM events JOIN event_participants ON events.id = event_participants.event_id)
                     SELECT *
                     FROM helper
                     WHERE helper.confirmed_participants > helper.needed
                     AND   helper.event_id = NEW.id)
                 THEN RAISE EXCEPTION 'Too many participants';
                 END IF;
                 RETURN NEW;
               END;
             $$;


--
-- Name: check_university_is_valid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_university_is_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
               BEGIN
                 IF NEW.university_location NOT IN (SELECT DISTINCT university_name
                                                    FROM university_mails)
                 THEN RETURN NULL;
                 END IF;
                 RETURN NEW;
               END;
             $$;


--
-- Name: check_user_has_phone_number(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION check_user_has_phone_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
               BEGIN
                 IF NOT EXISTS
                    (WITH helper AS
                       (SELECT users.telephone_number,
                               event_participants.user_id,
                               event_participants.event_id
                        FROM users JOIN event_participants ON users.id = event_participants.user_id)
                     SELECT *
                     FROM helper
                     WHERE helper.user_id = NEW.user_id
                     AND   helper.event_id = NEW.event_id
                     AND   helper.telephone_number IS NOT NULL)
                 THEN RAISE EXCEPTION 'User has not given his telephone number.';
                 END IF;
                 RETURN NEW;
               END;
             $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: event_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_participants (
    event_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    participants integer NOT NULL,
    confirmed boolean NOT NULL,
    message character varying,
    CONSTRAINT participants_gteq_one CHECK ((participants >= 1))
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    sport character varying NOT NULL,
    date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    location character varying NOT NULL,
    additional_info character varying,
    needed integer NOT NULL,
    min_participants integer,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    university_location character varying NOT NULL,
    level integer DEFAULT 0,
    CONSTRAINT level_between_zero_and_three CHECK (((level >= 0) AND (level <= 3))),
    CONSTRAINT logical_times CHECK ((start_time < end_time)),
    CONSTRAINT min_participants_gteq_two CHECK (((min_participants < 2) IS NOT TRUE)),
    CONSTRAINT needed_gteq_zero CHECK ((needed >= 1))
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: favourite_sports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE favourite_sports (
    user_id integer NOT NULL,
    sport character varying NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sports (
    name character varying NOT NULL,
    image_path character varying
);


--
-- Name: university_mails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE university_mails (
    mail_extension character varying NOT NULL,
    university_name character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    telephone_number character varying,
    description character varying,
    filename character varying,
    content_type character varying,
    file_contents bytea
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: event_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_participants
    ADD CONSTRAINT event_participants_pkey PRIMARY KEY (event_id, user_id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: sports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sports
    ADD CONSTRAINT sports_pkey PRIMARY KEY (name);


--
-- Name: university_mails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY university_mails
    ADD CONSTRAINT university_mails_pkey PRIMARY KEY (mail_extension);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_event_participants_on_event_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_event_participants_on_event_id_and_user_id ON event_participants USING btree (event_id, user_id);


--
-- Name: index_university_mails_on_mail_extension; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_university_mails_on_mail_extension ON university_mails USING btree (mail_extension);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: existing_email; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER existing_email AFTER INSERT OR UPDATE ON users NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_email_is_valid();


--
-- Name: existing_university; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER existing_university AFTER INSERT OR UPDATE ON events NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_university_is_valid();


--
-- Name: phone_number_given; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER phone_number_given AFTER INSERT OR UPDATE ON event_participants NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_user_has_phone_number();


--
-- Name: phone_number_given_creator; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER phone_number_given_creator AFTER INSERT OR UPDATE ON events NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_creator_has_phone_number();


--
-- Name: valid_participants; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER valid_participants AFTER INSERT OR UPDATE ON event_participants NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_participants_is_valid();


--
-- Name: valid_participants_creator; Type: TRIGGER; Schema: public; Owner: -
--

CREATE CONSTRAINT TRIGGER valid_participants_creator AFTER INSERT OR UPDATE ON events NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_participants_is_valid_creator();


--
-- Name: event_to_sport_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT event_to_sport_fk FOREIGN KEY (sport) REFERENCES sports(name);


--
-- Name: fav_sport_to_sport_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favourite_sports
    ADD CONSTRAINT fav_sport_to_sport_fk FOREIGN KEY (sport) REFERENCES sports(name);


--
-- Name: fk_rails_0cb5590091; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_0cb5590091 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_565ef9d942; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_participants
    ADD CONSTRAINT fk_rails_565ef9d942 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- Name: fk_rails_66517d4b5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favourite_sports
    ADD CONSTRAINT fk_rails_66517d4b5b FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_d47e705293; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_participants
    ADD CONSTRAINT fk_rails_d47e705293 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160521163520');

INSERT INTO schema_migrations (version) VALUES ('20160524115044');

INSERT INTO schema_migrations (version) VALUES ('20160524184621');

INSERT INTO schema_migrations (version) VALUES ('20160525102626');

INSERT INTO schema_migrations (version) VALUES ('20160525191352');

INSERT INTO schema_migrations (version) VALUES ('20160526120051');

INSERT INTO schema_migrations (version) VALUES ('20160526132053');

INSERT INTO schema_migrations (version) VALUES ('20160527095147');

INSERT INTO schema_migrations (version) VALUES ('20160528114049');

INSERT INTO schema_migrations (version) VALUES ('20160528175538');

INSERT INTO schema_migrations (version) VALUES ('20160530213709');

INSERT INTO schema_migrations (version) VALUES ('20160531133414');

INSERT INTO schema_migrations (version) VALUES ('20160531171817');

INSERT INTO schema_migrations (version) VALUES ('20160531223133');

INSERT INTO schema_migrations (version) VALUES ('20160531223222');

INSERT INTO schema_migrations (version) VALUES ('20160603213435');

INSERT INTO schema_migrations (version) VALUES ('20160606113611');

INSERT INTO schema_migrations (version) VALUES ('20160608104417');

INSERT INTO schema_migrations (version) VALUES ('20160608132307');

INSERT INTO schema_migrations (version) VALUES ('20160608174612');

INSERT INTO schema_migrations (version) VALUES ('20160608214727');

INSERT INTO schema_migrations (version) VALUES ('20160609001702');

INSERT INTO schema_migrations (version) VALUES ('20160609112605');

INSERT INTO schema_migrations (version) VALUES ('20160609124907');

INSERT INTO schema_migrations (version) VALUES ('20160609134816');

INSERT INTO schema_migrations (version) VALUES ('20160609135959');

INSERT INTO schema_migrations (version) VALUES ('20160612114358');

