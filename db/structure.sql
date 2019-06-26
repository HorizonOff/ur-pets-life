SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
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


--
-- Name: order_item_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.order_item_status AS ENUM (
    'pending',
    'confirmed',
    'on_the_way',
    'delivered',
    'delivered_by_cash',
    'delivered_by_card',
    'cancelled'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: additional_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.additional_services (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    picture character varying,
    mobile_number character varying,
    website character varying,
    description text,
    is_active boolean DEFAULT false,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: additional_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.additional_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: additional_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.additional_services_id_seq OWNED BY public.additional_services.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
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
    is_active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_super_admin boolean DEFAULT false,
    avatar character varying,
    name character varying,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_type character varying,
    invited_by_id bigint,
    invitations_count integer DEFAULT 0,
    deleted_at timestamp without time zone,
    unread_commented_appointments_count integer DEFAULT 0 NOT NULL,
    is_employee boolean DEFAULT false,
    unread_commented_orders_count integer DEFAULT 0 NOT NULL,
    is_cataloger boolean DEFAULT false,
    is_msh_admin boolean DEFAULT false
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: app_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_versions (
    id bigint NOT NULL,
    android_version character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ios_version character varying
);


--
-- Name: app_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_versions_id_seq OWNED BY public.app_versions.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id bigint NOT NULL,
    admin_id bigint,
    user_id bigint,
    bookable_type character varying,
    bookable_id bigint,
    vet_id bigint,
    calendar_id bigint,
    main_appointment_id integer,
    comment character varying,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    status integer,
    total_price integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    number_of_days integer DEFAULT 1,
    dates text[] DEFAULT '{}'::text[],
    is_viewed boolean DEFAULT false,
    comments_count integer DEFAULT 0,
    unread_comments_count_by_user integer DEFAULT 0 NOT NULL,
    unread_comments_count_by_admin integer DEFAULT 0 NOT NULL
);


--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: appointments_pets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments_pets (
    appointment_id bigint NOT NULL,
    pet_id bigint NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blocked_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blocked_times (
    id bigint NOT NULL,
    blockable_type character varying,
    blockable_id bigint,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blocked_times_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blocked_times_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blocked_times_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blocked_times_id_seq OWNED BY public.blocked_times.id;


--
-- Name: boardings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boardings (
    id bigint NOT NULL,
    admin_id bigint,
    name character varying,
    email character varying,
    picture character varying,
    mobile_number character varying,
    website character varying,
    description text,
    is_active boolean DEFAULT true,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: boardings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boardings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boardings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boardings_id_seq OWNED BY public.boardings.id;


--
-- Name: boardings_service_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boardings_service_options (
    boarding_id bigint NOT NULL,
    service_option_id bigint NOT NULL
);


--
-- Name: breeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.breeds (
    id bigint NOT NULL,
    name character varying,
    pet_type_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: breeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.breeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: breeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.breeds_id_seq OWNED BY public.breeds.id;


--
-- Name: calendars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendars (
    id bigint NOT NULL,
    vet_id bigint,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calendars_id_seq OWNED BY public.calendars.id;


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    pet_id bigint,
    appointment_id bigint,
    serviceable_type character varying,
    serviceable_id bigint,
    price integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity integer DEFAULT 1,
    total_price integer,
    service_option_time_id bigint
);


--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ckeditor_assets (
    id bigint NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    type character varying(30),
    width integer,
    height integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ckeditor_assets_id_seq OWNED BY public.ckeditor_assets.id;


--
-- Name: clinics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clinics (
    id bigint NOT NULL,
    admin_id bigint,
    name character varying,
    email character varying,
    picture character varying,
    mobile_number character varying,
    consultation_fee integer,
    website character varying,
    description text,
    is_active boolean DEFAULT true,
    is_emergency boolean DEFAULT false,
    vets_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: clinics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clinics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clinics_id_seq OWNED BY public.clinics.id;


--
-- Name: clinics_pet_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clinics_pet_types (
    clinic_id bigint NOT NULL,
    pet_type_id bigint NOT NULL
);


--
-- Name: clinics_specializations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clinics_specializations (
    clinic_id bigint NOT NULL,
    specialization_id bigint NOT NULL
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    commentable_type character varying,
    commentable_id bigint,
    writable_type character varying,
    writable_id bigint,
    read_at timestamp without time zone,
    mobile_image_url character varying,
    image character varying,
    video character varying,
    video_duration integer,
    mobile_video_url character varying
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: contact_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_requests (
    id bigint NOT NULL,
    user_id bigint,
    email character varying,
    subject character varying,
    message character varying,
    is_answered boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_name character varying,
    is_viewed boolean DEFAULT false
);


--
-- Name: contact_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_requests_id_seq OWNED BY public.contact_requests.id;


--
-- Name: day_care_centres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.day_care_centres (
    id bigint NOT NULL,
    admin_id bigint,
    name character varying,
    email character varying,
    picture character varying,
    mobile_number character varying,
    website character varying,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: day_care_centres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.day_care_centres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: day_care_centres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.day_care_centres_id_seq OWNED BY public.day_care_centres.id;


--
-- Name: diagnoses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diagnoses (
    id bigint NOT NULL,
    appointment_id bigint,
    message text,
    condition character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pet_id bigint
);


--
-- Name: diagnoses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diagnoses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diagnoses_id_seq OWNED BY public.diagnoses.id;


--
-- Name: discount_domains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_domains (
    id bigint NOT NULL,
    domain character varying,
    discount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: discount_domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discount_domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discount_domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discount_domains_id_seq OWNED BY public.discount_domains.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorites (
    id bigint NOT NULL,
    user_id bigint,
    favoritable_type character varying,
    favoritable_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: grooming_centres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grooming_centres (
    id bigint NOT NULL,
    admin_id bigint,
    name character varying,
    email character varying,
    mobile_number character varying,
    picture character varying,
    website character varying,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: grooming_centres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grooming_centres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grooming_centres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.grooming_centres_id_seq OWNED BY public.grooming_centres.id;


--
-- Name: item_brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_brands (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    picture character varying,
    brand_discount double precision
);


--
-- Name: item_brands_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_brands_categories (
    item_category_id bigint NOT NULL,
    item_brand_id bigint NOT NULL
);


--
-- Name: item_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_brands_id_seq OWNED BY public.item_brands.id;


--
-- Name: item_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_categories (
    id bigint NOT NULL,
    name character varying,
    picture character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "IsHaveBrand" boolean
);


--
-- Name: item_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_categories_id_seq OWNED BY public.item_categories.id;


--
-- Name: item_categories_pet_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_categories_pet_types (
    pet_type_id bigint NOT NULL,
    item_category_id bigint NOT NULL
);


--
-- Name: item_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_reviews (
    id bigint NOT NULL,
    user_id bigint,
    item_id bigint,
    rating integer,
    comment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    order_item_id bigint
);


--
-- Name: item_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_reviews_id_seq OWNED BY public.item_reviews.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    id bigint NOT NULL,
    name character varying,
    price double precision,
    discount double precision,
    weight integer,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    unit character varying,
    item_brand_id bigint,
    picture character varying,
    rating integer,
    review_count integer,
    item_categories_id bigint,
    pet_type_id bigint,
    avg_rating integer,
    quantity integer,
    short_description character varying,
    unit_price double precision,
    buying_price double precision,
    is_active boolean DEFAULT true,
    expiry_at timestamp without time zone,
    deleted_at timestamp without time zone,
    supplier character varying,
    supplier_code character varying
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    place_type character varying,
    place_id bigint,
    latitude double precision,
    longitude double precision,
    city character varying,
    area character varying,
    street character varying,
    building_type integer,
    building_name character varying,
    unit_number character varying,
    villa_number character varying,
    comment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: my_second_house_member_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.my_second_house_member_invitations (
    id bigint NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    unsubscribe boolean DEFAULT false,
    name character varying,
    token character varying,
    member_type integer DEFAULT 1
);


--
-- Name: my_second_house_member_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.my_second_house_member_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: my_second_house_member_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.my_second_house_member_invitations_id_seq OWNED BY public.my_second_house_member_invitations.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    admin_id bigint,
    user_id bigint,
    appointment_id bigint,
    pet_id bigint,
    message character varying,
    skip_push_sending boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    viewed_at timestamp without time zone,
    is_for_vaccine boolean DEFAULT false,
    order_id bigint
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint,
    item_id bigint,
    "Quantity" integer,
    "Unit_Price" double precision,
    "Total_Price" double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "IsRecurring" boolean,
    "Interval" integer,
    recurssion_interval_id bigint,
    "IsReviewed" boolean,
    status public.order_item_status,
    isdiscounted boolean,
    next_recurring_due_date timestamp without time zone
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint,
    location_id bigint,
    "Delivery_Date" timestamp without time zone,
    "Order_Notes" character varying,
    "Subtotal" double precision,
    "Delivery_Charges" double precision,
    "Vat_Charges" double precision,
    "Total" double precision,
    "IsCash" boolean,
    "Order_Status" integer,
    "Payment_Status" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shipmenttime character varying,
    "RedeemPoints" integer,
    "TransactionId" character varying,
    "TransactionDate" timestamp without time zone,
    earned_points integer,
    is_viewed boolean,
    order_status_flag public.order_item_status,
    unread_comments_count_by_user integer DEFAULT 0 NOT NULL,
    unread_comments_count_by_admin integer DEFAULT 0 NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL,
    company_discount double precision,
    is_user_from_company boolean DEFAULT false,
    delivery_at timestamp without time zone,
    is_pre_recurring boolean DEFAULT false
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: pet_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pet_types (
    id bigint NOT NULL,
    name character varying,
    is_additional_type boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    picture character varying,
    "IsHaveCategories" boolean,
    seq integer
);


--
-- Name: pet_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pet_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pet_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pet_types_id_seq OWNED BY public.pet_types.id;


--
-- Name: pet_types_trainers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pet_types_trainers (
    pet_type_id bigint NOT NULL,
    trainer_id bigint NOT NULL
);


--
-- Name: pet_types_vaccine_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pet_types_vaccine_types (
    pet_type_id bigint NOT NULL,
    vaccine_type_id bigint NOT NULL
);


--
-- Name: pet_types_vets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pet_types_vets (
    pet_type_id bigint NOT NULL,
    vet_id bigint NOT NULL
);


--
-- Name: pets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pets (
    id bigint NOT NULL,
    user_id bigint,
    breed_id bigint,
    pet_type_id bigint,
    additional_type character varying,
    name character varying,
    birthday timestamp without time zone,
    sex integer,
    weight double precision,
    comment character varying,
    avatar character varying,
    lost_at timestamp without time zone,
    found_at timestamp without time zone,
    is_for_adoption boolean DEFAULT false,
    description character varying,
    mobile_number character varying,
    additional_comment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    microchip character varying,
    municipality_tag character varying
);


--
-- Name: pets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pets_id_seq OWNED BY public.pets.id;


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pictures (
    id bigint NOT NULL,
    attachment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    picturable_type character varying,
    picturable_id bigint
);


--
-- Name: pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pictures_id_seq OWNED BY public.pictures.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    title character varying,
    message text,
    comments_count integer DEFAULT 0,
    pet_type_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    mobile_image_url character varying,
    image character varying,
    video character varying,
    video_duration integer,
    mobile_video_url character varying,
    author_type character varying,
    author_id bigint
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: qualifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.qualifications (
    id bigint NOT NULL,
    skill_type character varying,
    skill_id bigint,
    diploma character varying,
    university character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: qualifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.qualifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: qualifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.qualifications_id_seq OWNED BY public.qualifications.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipes (
    id bigint NOT NULL,
    instruction text,
    diagnosis_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: recurssion_intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recurssion_intervals (
    id bigint NOT NULL,
    weeks integer,
    days integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    label character varying
);


--
-- Name: recurssion_intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recurssion_intervals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recurssion_intervals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recurssion_intervals_id_seq OWNED BY public.recurssion_intervals.id;


--
-- Name: redeem_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redeem_points (
    id bigint NOT NULL,
    net_worth integer,
    last_net_worth integer,
    last_reward_type character varying,
    last_reward_worth integer,
    last_reward_update timestamp without time zone,
    last_net_update timestamp without time zone,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    totalearnedpoints integer,
    totalavailedpoints integer
);


--
-- Name: redeem_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.redeem_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: redeem_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.redeem_points_id_seq OWNED BY public.redeem_points.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    id bigint NOT NULL,
    schedulable_type character varying,
    schedulable_id bigint,
    day_and_night boolean DEFAULT false,
    monday_open_at timestamp without time zone,
    monday_close_at timestamp without time zone,
    tuesday_open_at timestamp without time zone,
    tuesday_close_at timestamp without time zone,
    wednesday_open_at timestamp without time zone,
    wednesday_close_at timestamp without time zone,
    thursday_open_at timestamp without time zone,
    thursday_close_at timestamp without time zone,
    friday_open_at timestamp without time zone,
    friday_close_at timestamp without time zone,
    saturday_open_at timestamp without time zone,
    saturday_close_at timestamp without time zone,
    sunday_open_at timestamp without time zone,
    sunday_close_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: service_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_details (
    id bigint NOT NULL,
    service_type_id bigint,
    pet_type_id bigint,
    weight double precision,
    total_space double precision,
    price integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    min_weight double precision DEFAULT 0.0
);


--
-- Name: service_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_details_id_seq OWNED BY public.service_details.id;


--
-- Name: service_option_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_option_details (
    id bigint NOT NULL,
    service_option_id bigint,
    service_optionable_type character varying,
    service_optionable_id bigint,
    deleted_at timestamp without time zone,
    price integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: service_option_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_option_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_option_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_option_details_id_seq OWNED BY public.service_option_details.id;


--
-- Name: service_option_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_option_times (
    id bigint NOT NULL,
    service_option_detail_id bigint,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: service_option_times_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_option_times_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_option_times_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_option_times_id_seq OWNED BY public.service_option_times.id;


--
-- Name: service_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_options (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: service_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_options_id_seq OWNED BY public.service_options.id;


--
-- Name: service_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_types (
    id bigint NOT NULL,
    name character varying,
    description text,
    serviceable_type character varying,
    serviceable_id bigint,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: service_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_types_id_seq OWNED BY public.service_types.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    token character varying,
    device_type character varying,
    device_id character varying,
    push_token character varying,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: shopping_cart_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shopping_cart_items (
    id bigint NOT NULL,
    "IsRecurring" boolean,
    "Interval" integer,
    quantity integer,
    item_id bigint,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recurssion_interval_id bigint
);


--
-- Name: shopping_cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shopping_cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shopping_cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shopping_cart_items_id_seq OWNED BY public.shopping_cart_items.id;


--
-- Name: specializations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specializations (
    id bigint NOT NULL,
    name character varying,
    is_for_trainer boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: specializations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.specializations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specializations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.specializations_id_seq OWNED BY public.specializations.id;


--
-- Name: specializations_trainers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specializations_trainers (
    specialization_id bigint NOT NULL,
    trainer_id bigint NOT NULL
);


--
-- Name: specializations_vets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specializations_vets (
    specialization_id bigint NOT NULL,
    vet_id bigint NOT NULL
);


--
-- Name: terms_and_conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.terms_and_conditions (
    id bigint NOT NULL,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: terms_and_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.terms_and_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: terms_and_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.terms_and_conditions_id_seq OWNED BY public.terms_and_conditions.id;


--
-- Name: trainers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trainers (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    picture character varying,
    mobile_number character varying,
    is_active boolean DEFAULT true,
    experience integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: trainers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trainers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trainers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trainers_id_seq OWNED BY public.trainers.id;


--
-- Name: user_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_posts (
    id bigint NOT NULL,
    user_id bigint,
    post_id bigint,
    unread_post_comments_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_posts_id_seq OWNED BY public.user_posts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    email character varying,
    mobile_number character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    facebook_id character varying,
    google_id character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    gender integer,
    birthday timestamp without time zone,
    notifications_count integer DEFAULT 0,
    commented_appointments_count integer DEFAULT 0 NOT NULL,
    unread_commented_appointments_count integer DEFAULT 0 NOT NULL,
    last_transaction_ref character varying,
    last_transaction_date timestamp without time zone,
    commented_orders_count integer DEFAULT 0 NOT NULL,
    unread_commented_orders_count integer DEFAULT 0 NOT NULL,
    spends_eligble double precision DEFAULT 0.0 NOT NULL,
    spends_not_eligble double precision DEFAULT 0.0 NOT NULL,
    unread_post_comments_count integer DEFAULT 0,
    member_type integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vaccinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vaccinations (
    id bigint NOT NULL,
    vaccine_type_id bigint,
    pet_id bigint,
    done_at timestamp without time zone,
    picture character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vaccinations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vaccinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vaccinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vaccinations_id_seq OWNED BY public.vaccinations.id;


--
-- Name: vaccine_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vaccine_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vaccine_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vaccine_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vaccine_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vaccine_types_id_seq OWNED BY public.vaccine_types.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: vets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vets (
    id bigint NOT NULL,
    clinic_id bigint,
    name character varying,
    email character varying,
    mobile_number character varying,
    avatar character varying,
    is_active boolean DEFAULT true,
    is_emergency boolean DEFAULT false,
    use_clinic_location boolean DEFAULT false,
    consultation_fee integer,
    experience integer,
    session_duration integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: vets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vets_id_seq OWNED BY public.vets.id;


--
-- Name: wishlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wishlists (
    id bigint NOT NULL,
    user_id bigint,
    item_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wishlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wishlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wishlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wishlists_id_seq OWNED BY public.wishlists.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_services ALTER COLUMN id SET DEFAULT nextval('public.additional_services_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions ALTER COLUMN id SET DEFAULT nextval('public.app_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_times ALTER COLUMN id SET DEFAULT nextval('public.blocked_times_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boardings ALTER COLUMN id SET DEFAULT nextval('public.boardings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.breeds ALTER COLUMN id SET DEFAULT nextval('public.breeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars ALTER COLUMN id SET DEFAULT nextval('public.calendars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('public.ckeditor_assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinics ALTER COLUMN id SET DEFAULT nextval('public.clinics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_requests ALTER COLUMN id SET DEFAULT nextval('public.contact_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_care_centres ALTER COLUMN id SET DEFAULT nextval('public.day_care_centres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses ALTER COLUMN id SET DEFAULT nextval('public.diagnoses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_domains ALTER COLUMN id SET DEFAULT nextval('public.discount_domains_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooming_centres ALTER COLUMN id SET DEFAULT nextval('public.grooming_centres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_brands ALTER COLUMN id SET DEFAULT nextval('public.item_brands_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_categories ALTER COLUMN id SET DEFAULT nextval('public.item_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_reviews ALTER COLUMN id SET DEFAULT nextval('public.item_reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.my_second_house_member_invitations ALTER COLUMN id SET DEFAULT nextval('public.my_second_house_member_invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pet_types ALTER COLUMN id SET DEFAULT nextval('public.pet_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets ALTER COLUMN id SET DEFAULT nextval('public.pets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pictures ALTER COLUMN id SET DEFAULT nextval('public.pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qualifications ALTER COLUMN id SET DEFAULT nextval('public.qualifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurssion_intervals ALTER COLUMN id SET DEFAULT nextval('public.recurssion_intervals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeem_points ALTER COLUMN id SET DEFAULT nextval('public.redeem_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_details ALTER COLUMN id SET DEFAULT nextval('public.service_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_option_details ALTER COLUMN id SET DEFAULT nextval('public.service_option_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_option_times ALTER COLUMN id SET DEFAULT nextval('public.service_option_times_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_options ALTER COLUMN id SET DEFAULT nextval('public.service_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_types ALTER COLUMN id SET DEFAULT nextval('public.service_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shopping_cart_items ALTER COLUMN id SET DEFAULT nextval('public.shopping_cart_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specializations ALTER COLUMN id SET DEFAULT nextval('public.specializations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.terms_and_conditions ALTER COLUMN id SET DEFAULT nextval('public.terms_and_conditions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainers ALTER COLUMN id SET DEFAULT nextval('public.trainers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_posts ALTER COLUMN id SET DEFAULT nextval('public.user_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vaccinations ALTER COLUMN id SET DEFAULT nextval('public.vaccinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vaccine_types ALTER COLUMN id SET DEFAULT nextval('public.vaccine_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vets ALTER COLUMN id SET DEFAULT nextval('public.vets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists ALTER COLUMN id SET DEFAULT nextval('public.wishlists_id_seq'::regclass);


--
-- Name: additional_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.additional_services
    ADD CONSTRAINT additional_services_pkey PRIMARY KEY (id);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: app_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_pkey PRIMARY KEY (id);


--
-- Name: appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blocked_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blocked_times
    ADD CONSTRAINT blocked_times_pkey PRIMARY KEY (id);


--
-- Name: boardings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boardings
    ADD CONSTRAINT boardings_pkey PRIMARY KEY (id);


--
-- Name: breeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.breeds
    ADD CONSTRAINT breeds_pkey PRIMARY KEY (id);


--
-- Name: calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT calendars_pkey PRIMARY KEY (id);


--
-- Name: cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: clinics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinics
    ADD CONSTRAINT clinics_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contact_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_requests
    ADD CONSTRAINT contact_requests_pkey PRIMARY KEY (id);


--
-- Name: day_care_centres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_care_centres
    ADD CONSTRAINT day_care_centres_pkey PRIMARY KEY (id);


--
-- Name: diagnoses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT diagnoses_pkey PRIMARY KEY (id);


--
-- Name: discount_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_domains
    ADD CONSTRAINT discount_domains_pkey PRIMARY KEY (id);


--
-- Name: favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: grooming_centres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooming_centres
    ADD CONSTRAINT grooming_centres_pkey PRIMARY KEY (id);


--
-- Name: item_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_brands
    ADD CONSTRAINT item_brands_pkey PRIMARY KEY (id);


--
-- Name: item_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_categories
    ADD CONSTRAINT item_categories_pkey PRIMARY KEY (id);


--
-- Name: item_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_reviews
    ADD CONSTRAINT item_reviews_pkey PRIMARY KEY (id);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: my_second_house_member_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.my_second_house_member_invitations
    ADD CONSTRAINT my_second_house_member_invitations_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pet_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pet_types
    ADD CONSTRAINT pet_types_pkey PRIMARY KEY (id);


--
-- Name: pets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (id);


--
-- Name: pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: qualifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qualifications
    ADD CONSTRAINT qualifications_pkey PRIMARY KEY (id);


--
-- Name: recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: recurssion_intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recurssion_intervals
    ADD CONSTRAINT recurssion_intervals_pkey PRIMARY KEY (id);


--
-- Name: redeem_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeem_points
    ADD CONSTRAINT redeem_points_pkey PRIMARY KEY (id);


--
-- Name: schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: service_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_details
    ADD CONSTRAINT service_details_pkey PRIMARY KEY (id);


--
-- Name: service_option_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_option_details
    ADD CONSTRAINT service_option_details_pkey PRIMARY KEY (id);


--
-- Name: service_option_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_option_times
    ADD CONSTRAINT service_option_times_pkey PRIMARY KEY (id);


--
-- Name: service_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_options
    ADD CONSTRAINT service_options_pkey PRIMARY KEY (id);


--
-- Name: service_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_types
    ADD CONSTRAINT service_types_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: shopping_cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shopping_cart_items
    ADD CONSTRAINT shopping_cart_items_pkey PRIMARY KEY (id);


--
-- Name: specializations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specializations
    ADD CONSTRAINT specializations_pkey PRIMARY KEY (id);


--
-- Name: terms_and_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.terms_and_conditions
    ADD CONSTRAINT terms_and_conditions_pkey PRIMARY KEY (id);


--
-- Name: trainers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trainers
    ADD CONSTRAINT trainers_pkey PRIMARY KEY (id);


--
-- Name: user_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_posts
    ADD CONSTRAINT user_posts_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vaccinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vaccinations
    ADD CONSTRAINT vaccinations_pkey PRIMARY KEY (id);


--
-- Name: vaccine_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vaccine_types
    ADD CONSTRAINT vaccine_types_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: vets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vets
    ADD CONSTRAINT vets_pkey PRIMARY KEY (id);


--
-- Name: wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- Name: index_additional_services_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_additional_services_on_deleted_at ON public.additional_services USING btree (deleted_at);


--
-- Name: index_additional_services_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_additional_services_on_email ON public.additional_services USING btree (email);


--
-- Name: index_additional_services_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_additional_services_on_is_active ON public.additional_services USING btree (is_active);


--
-- Name: index_additional_services_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_additional_services_on_name ON public.additional_services USING btree (name);


--
-- Name: index_admins_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_deleted_at ON public.admins USING btree (deleted_at);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_invitation_token ON public.admins USING btree (invitation_token);


--
-- Name: index_admins_on_invitations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_invitations_count ON public.admins USING btree (invitations_count);


--
-- Name: index_admins_on_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_invited_by_id ON public.admins USING btree (invited_by_id);


--
-- Name: index_admins_on_invited_by_type_and_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_invited_by_type_and_invited_by_id ON public.admins USING btree (invited_by_type, invited_by_id);


--
-- Name: index_admins_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_is_active ON public.admins USING btree (is_active);


--
-- Name: index_admins_on_is_super_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_is_super_admin ON public.admins USING btree (is_super_admin);


--
-- Name: index_admins_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_name ON public.admins USING btree (name);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_admins_on_unread_commented_appointments_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_unread_commented_appointments_count ON public.admins USING btree (unread_commented_appointments_count);


--
-- Name: index_appointments_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_admin_id ON public.appointments USING btree (admin_id);


--
-- Name: index_appointments_on_bookable_type_and_bookable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_bookable_type_and_bookable_id ON public.appointments USING btree (bookable_type, bookable_id);


--
-- Name: index_appointments_on_calendar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_calendar_id ON public.appointments USING btree (calendar_id);


--
-- Name: index_appointments_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_created_at ON public.appointments USING btree (created_at);


--
-- Name: index_appointments_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_deleted_at ON public.appointments USING btree (deleted_at);


--
-- Name: index_appointments_on_end_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_end_at ON public.appointments USING btree (end_at);


--
-- Name: index_appointments_on_main_appointment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_main_appointment_id ON public.appointments USING btree (main_appointment_id);


--
-- Name: index_appointments_on_start_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_start_at ON public.appointments USING btree (start_at);


--
-- Name: index_appointments_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_status ON public.appointments USING btree (status);


--
-- Name: index_appointments_on_total_price; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_total_price ON public.appointments USING btree (total_price);


--
-- Name: index_appointments_on_unread_comments_count_by_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_unread_comments_count_by_admin ON public.appointments USING btree (unread_comments_count_by_admin);


--
-- Name: index_appointments_on_unread_comments_count_by_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_unread_comments_count_by_user ON public.appointments USING btree (unread_comments_count_by_user);


--
-- Name: index_appointments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_user_id ON public.appointments USING btree (user_id);


--
-- Name: index_appointments_on_vet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_vet_id ON public.appointments USING btree (vet_id);


--
-- Name: index_blocked_times_on_blockable_type_and_blockable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blocked_times_on_blockable_type_and_blockable_id ON public.blocked_times USING btree (blockable_type, blockable_id);


--
-- Name: index_blocked_times_on_end_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blocked_times_on_end_at ON public.blocked_times USING btree (end_at);


--
-- Name: index_blocked_times_on_start_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blocked_times_on_start_at ON public.blocked_times USING btree (start_at);


--
-- Name: index_boardings_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_admin_id ON public.boardings USING btree (admin_id);


--
-- Name: index_boardings_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_deleted_at ON public.boardings USING btree (deleted_at);


--
-- Name: index_boardings_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_email ON public.boardings USING btree (email);


--
-- Name: index_boardings_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_is_active ON public.boardings USING btree (is_active);


--
-- Name: index_boardings_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_mobile_number ON public.boardings USING btree (mobile_number);


--
-- Name: index_boardings_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_name ON public.boardings USING btree (name);


--
-- Name: index_breeds_on_pet_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_breeds_on_pet_type_id ON public.breeds USING btree (pet_type_id);


--
-- Name: index_calendars_on_end_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendars_on_end_at ON public.calendars USING btree (end_at);


--
-- Name: index_calendars_on_start_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendars_on_start_at ON public.calendars USING btree (start_at);


--
-- Name: index_calendars_on_vet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calendars_on_vet_id ON public.calendars USING btree (vet_id);


--
-- Name: index_cart_items_on_appointment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_appointment_id ON public.cart_items USING btree (appointment_id);


--
-- Name: index_cart_items_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_pet_id ON public.cart_items USING btree (pet_id);


--
-- Name: index_cart_items_on_service_option_time_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_service_option_time_id ON public.cart_items USING btree (service_option_time_id);


--
-- Name: index_cart_items_on_serviceable_type_and_serviceable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_serviceable_type_and_serviceable_id ON public.cart_items USING btree (serviceable_type, serviceable_id);


--
-- Name: index_ckeditor_assets_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ckeditor_assets_on_type ON public.ckeditor_assets USING btree (type);


--
-- Name: index_clinics_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_admin_id ON public.clinics USING btree (admin_id);


--
-- Name: index_clinics_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_deleted_at ON public.clinics USING btree (deleted_at);


--
-- Name: index_clinics_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_email ON public.clinics USING btree (email);


--
-- Name: index_clinics_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_is_active ON public.clinics USING btree (is_active);


--
-- Name: index_clinics_on_is_emergency; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_is_emergency ON public.clinics USING btree (is_emergency);


--
-- Name: index_clinics_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_mobile_number ON public.clinics USING btree (mobile_number);


--
-- Name: index_clinics_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_name ON public.clinics USING btree (name);


--
-- Name: index_clinics_on_vets_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clinics_on_vets_count ON public.clinics USING btree (vets_count);


--
-- Name: index_comments_on_commentable_type_and_commentable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable_type_and_commentable_id ON public.comments USING btree (commentable_type, commentable_id);


--
-- Name: index_comments_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_deleted_at ON public.comments USING btree (deleted_at);


--
-- Name: index_comments_on_read_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_read_at ON public.comments USING btree (read_at);


--
-- Name: index_comments_on_writable_type_and_writable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_writable_type_and_writable_id ON public.comments USING btree (writable_type, writable_id);


--
-- Name: index_contact_requests_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_requests_on_email ON public.contact_requests USING btree (email);


--
-- Name: index_contact_requests_on_is_answered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_requests_on_is_answered ON public.contact_requests USING btree (is_answered);


--
-- Name: index_contact_requests_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_requests_on_user_id ON public.contact_requests USING btree (user_id);


--
-- Name: index_day_care_centres_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_day_care_centres_on_admin_id ON public.day_care_centres USING btree (admin_id);


--
-- Name: index_day_care_centres_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_day_care_centres_on_deleted_at ON public.day_care_centres USING btree (deleted_at);


--
-- Name: index_day_care_centres_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_day_care_centres_on_email ON public.day_care_centres USING btree (email);


--
-- Name: index_day_care_centres_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_day_care_centres_on_is_active ON public.day_care_centres USING btree (is_active);


--
-- Name: index_day_care_centres_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_day_care_centres_on_mobile_number ON public.day_care_centres USING btree (mobile_number);


--
-- Name: index_day_care_centres_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_day_care_centres_on_name ON public.day_care_centres USING btree (name);


--
-- Name: index_diagnoses_on_appointment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diagnoses_on_appointment_id ON public.diagnoses USING btree (appointment_id);


--
-- Name: index_diagnoses_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_diagnoses_on_pet_id ON public.diagnoses USING btree (pet_id);


--
-- Name: index_favorites_on_favoritable_type_and_favoritable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_favoritable_type_and_favoritable_id ON public.favorites USING btree (favoritable_type, favoritable_id);


--
-- Name: index_favorites_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorites_on_user_id ON public.favorites USING btree (user_id);


--
-- Name: index_grooming_centres_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooming_centres_on_admin_id ON public.grooming_centres USING btree (admin_id);


--
-- Name: index_grooming_centres_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooming_centres_on_deleted_at ON public.grooming_centres USING btree (deleted_at);


--
-- Name: index_grooming_centres_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooming_centres_on_email ON public.grooming_centres USING btree (email);


--
-- Name: index_grooming_centres_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooming_centres_on_is_active ON public.grooming_centres USING btree (is_active);


--
-- Name: index_grooming_centres_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooming_centres_on_mobile_number ON public.grooming_centres USING btree (mobile_number);


--
-- Name: index_grooming_centres_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_grooming_centres_on_name ON public.grooming_centres USING btree (name);


--
-- Name: index_item_reviews_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_reviews_on_item_id ON public.item_reviews USING btree (item_id);


--
-- Name: index_item_reviews_on_order_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_reviews_on_order_item_id ON public.item_reviews USING btree (order_item_id);


--
-- Name: index_item_reviews_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_reviews_on_user_id ON public.item_reviews USING btree (user_id);


--
-- Name: index_items_on_item_brands_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_item_brands_id ON public.items USING btree (item_brand_id);


--
-- Name: index_items_on_item_categories_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_item_categories_id ON public.items USING btree (item_categories_id);


--
-- Name: index_items_on_pet_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_pet_type_id ON public.items USING btree (pet_type_id);


--
-- Name: index_locations_on_city; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_city ON public.locations USING btree (city);


--
-- Name: index_locations_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_deleted_at ON public.locations USING btree (deleted_at);


--
-- Name: index_locations_on_place_type_and_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_place_type_and_place_id ON public.locations USING btree (place_type, place_id);


--
-- Name: index_my_second_house_member_invitations_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_my_second_house_member_invitations_on_token ON public.my_second_house_member_invitations USING btree (token);


--
-- Name: index_notifications_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_admin_id ON public.notifications USING btree (admin_id);


--
-- Name: index_notifications_on_appointment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_appointment_id ON public.notifications USING btree (appointment_id);


--
-- Name: index_notifications_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_order_id ON public.notifications USING btree (order_id);


--
-- Name: index_notifications_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_pet_id ON public.notifications USING btree (pet_id);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_user_id ON public.notifications USING btree (user_id);


--
-- Name: index_notifications_on_viewed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_viewed_at ON public.notifications USING btree (viewed_at);


--
-- Name: index_order_items_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_item_id ON public.order_items USING btree (item_id);


--
-- Name: index_order_items_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_order_id ON public.order_items USING btree (order_id);


--
-- Name: index_order_items_on_recurssion_intervals_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_recurssion_intervals_id ON public.order_items USING btree (recurssion_interval_id);


--
-- Name: index_order_items_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_items_on_status ON public.order_items USING btree (status);


--
-- Name: index_orders_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_location_id ON public.orders USING btree (location_id);


--
-- Name: index_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_user_id ON public.orders USING btree (user_id);


--
-- Name: index_pets_on_breed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_breed_id ON public.pets USING btree (breed_id);


--
-- Name: index_pets_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_deleted_at ON public.pets USING btree (deleted_at);


--
-- Name: index_pets_on_found_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_found_at ON public.pets USING btree (found_at);


--
-- Name: index_pets_on_is_for_adoption; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_is_for_adoption ON public.pets USING btree (is_for_adoption);


--
-- Name: index_pets_on_lost_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_lost_at ON public.pets USING btree (lost_at);


--
-- Name: index_pets_on_pet_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_pet_type_id ON public.pets USING btree (pet_type_id);


--
-- Name: index_pets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pets_on_user_id ON public.pets USING btree (user_id);


--
-- Name: index_pictures_on_picturable_type_and_picturable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pictures_on_picturable_type_and_picturable_id ON public.pictures USING btree (picturable_type, picturable_id);


--
-- Name: index_posts_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_author_type_and_author_id ON public.posts USING btree (author_type, author_id);


--
-- Name: index_posts_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_deleted_at ON public.posts USING btree (deleted_at);


--
-- Name: index_posts_on_pet_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_pet_type_id ON public.posts USING btree (pet_type_id);


--
-- Name: index_qualifications_on_skill_type_and_skill_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_qualifications_on_skill_type_and_skill_id ON public.qualifications USING btree (skill_type, skill_id);


--
-- Name: index_recipes_on_diagnosis_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_diagnosis_id ON public.recipes USING btree (diagnosis_id);


--
-- Name: index_redeem_points_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_redeem_points_on_user_id ON public.redeem_points USING btree (user_id);


--
-- Name: index_schedules_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_deleted_at ON public.schedules USING btree (deleted_at);


--
-- Name: index_schedules_on_schedulable_type_and_schedulable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_schedulable_type_and_schedulable_id ON public.schedules USING btree (schedulable_type, schedulable_id);


--
-- Name: index_service_and_option; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_and_option ON public.service_option_details USING btree (service_optionable_type, service_optionable_id);


--
-- Name: index_service_details_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_details_on_deleted_at ON public.service_details USING btree (deleted_at);


--
-- Name: index_service_details_on_pet_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_details_on_pet_type_id ON public.service_details USING btree (pet_type_id);


--
-- Name: index_service_details_on_service_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_details_on_service_type_id ON public.service_details USING btree (service_type_id);


--
-- Name: index_service_option_details_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_option_details_on_deleted_at ON public.service_option_details USING btree (deleted_at);


--
-- Name: index_service_option_details_on_service_option_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_option_details_on_service_option_id ON public.service_option_details USING btree (service_option_id);


--
-- Name: index_service_option_times_on_service_option_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_option_times_on_service_option_detail_id ON public.service_option_times USING btree (service_option_detail_id);


--
-- Name: index_service_types_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_types_on_deleted_at ON public.service_types USING btree (deleted_at);


--
-- Name: index_service_types_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_types_on_is_active ON public.service_types USING btree (is_active);


--
-- Name: index_service_types_on_serviceable_type_and_serviceable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_types_on_serviceable_type_and_serviceable_id ON public.service_types USING btree (serviceable_type, serviceable_id);


--
-- Name: index_sessions_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_token ON public.sessions USING btree (token);


--
-- Name: index_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_user_id ON public.sessions USING btree (user_id);


--
-- Name: index_shopping_cart_items_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shopping_cart_items_on_item_id ON public.shopping_cart_items USING btree (item_id);


--
-- Name: index_shopping_cart_items_on_recurssion_intervals_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shopping_cart_items_on_recurssion_intervals_id ON public.shopping_cart_items USING btree (recurssion_interval_id);


--
-- Name: index_shopping_cart_items_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shopping_cart_items_on_user_id ON public.shopping_cart_items USING btree (user_id);


--
-- Name: index_specializations_on_is_for_trainer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_specializations_on_is_for_trainer ON public.specializations USING btree (is_for_trainer);


--
-- Name: index_trainers_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainers_on_deleted_at ON public.trainers USING btree (deleted_at);


--
-- Name: index_trainers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainers_on_email ON public.trainers USING btree (email);


--
-- Name: index_trainers_on_experience; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainers_on_experience ON public.trainers USING btree (experience);


--
-- Name: index_trainers_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainers_on_is_active ON public.trainers USING btree (is_active);


--
-- Name: index_trainers_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainers_on_mobile_number ON public.trainers USING btree (mobile_number);


--
-- Name: index_trainers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trainers_on_name ON public.trainers USING btree (name);


--
-- Name: index_user_posts_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_posts_on_post_id ON public.user_posts USING btree (post_id);


--
-- Name: index_user_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_posts_on_user_id ON public.user_posts USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_deleted_at ON public.users USING btree (deleted_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_facebook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_facebook_id ON public.users USING btree (facebook_id);


--
-- Name: index_users_on_google_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_google_id ON public.users USING btree (google_id);


--
-- Name: index_users_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_is_active ON public.users USING btree (is_active);


--
-- Name: index_users_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_mobile_number ON public.users USING btree (mobile_number);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unread_commented_appointments_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_unread_commented_appointments_count ON public.users USING btree (unread_commented_appointments_count);


--
-- Name: index_vaccinations_on_done_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vaccinations_on_done_at ON public.vaccinations USING btree (done_at);


--
-- Name: index_vaccinations_on_pet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vaccinations_on_pet_id ON public.vaccinations USING btree (pet_id);


--
-- Name: index_vaccinations_on_vaccine_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vaccinations_on_vaccine_type_id ON public.vaccinations USING btree (vaccine_type_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_vets_on_clinic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_clinic_id ON public.vets USING btree (clinic_id);


--
-- Name: index_vets_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_deleted_at ON public.vets USING btree (deleted_at);


--
-- Name: index_vets_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_email ON public.vets USING btree (email);


--
-- Name: index_vets_on_experience; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_experience ON public.vets USING btree (experience);


--
-- Name: index_vets_on_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_is_active ON public.vets USING btree (is_active);


--
-- Name: index_vets_on_is_emergency; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_is_emergency ON public.vets USING btree (is_emergency);


--
-- Name: index_vets_on_mobile_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_mobile_number ON public.vets USING btree (mobile_number);


--
-- Name: index_vets_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vets_on_name ON public.vets USING btree (name);


--
-- Name: index_wishlists_on_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlists_on_item_id ON public.wishlists USING btree (item_id);


--
-- Name: index_wishlists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlists_on_user_id ON public.wishlists USING btree (user_id);


--
-- Name: fk_rails_012133d340; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinics
    ADD CONSTRAINT fk_rails_012133d340 FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_07b8c492c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_reviews
    ADD CONSTRAINT fk_rails_07b8c492c1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_0fa4bae6b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_0fa4bae6b1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_191805e18e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_reviews
    ADD CONSTRAINT fk_rails_191805e18e FOREIGN KEY (order_item_id) REFERENCES public.order_items(id);


--
-- Name: fk_rails_19904d1dd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT fk_rails_19904d1dd0 FOREIGN KEY (diagnosis_id) REFERENCES public.diagnoses(id);


--
-- Name: fk_rails_1e59adc8b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendars
    ADD CONSTRAINT fk_rails_1e59adc8b4 FOREIGN KEY (vet_id) REFERENCES public.vets(id);


--
-- Name: fk_rails_214fd881af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.breeds
    ADD CONSTRAINT fk_rails_214fd881af FOREIGN KEY (pet_type_id) REFERENCES public.pet_types(id);


--
-- Name: fk_rails_247b774c63; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.day_care_centres
    ADD CONSTRAINT fk_rails_247b774c63 FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_27ea9098b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_rails_27ea9098b6 FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: fk_rails_360f47fcb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shopping_cart_items
    ADD CONSTRAINT fk_rails_360f47fcb6 FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: fk_rails_38a7c4b06f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_posts
    ADD CONSTRAINT fk_rails_38a7c4b06f FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: fk_rails_3e402078fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_rails_3e402078fd FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: fk_rails_46a2bc0d7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_details
    ADD CONSTRAINT fk_rails_46a2bc0d7b FOREIGN KEY (service_type_id) REFERENCES public.service_types(id);


--
-- Name: fk_rails_5102d9670d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shopping_cart_items
    ADD CONSTRAINT fk_rails_5102d9670d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_53a5878905; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeem_points
    ADD CONSTRAINT fk_rails_53a5878905 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_53e2df5fce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_53e2df5fce FOREIGN KEY (item_brand_id) REFERENCES public.item_brands(id);


--
-- Name: fk_rails_54c616f418; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_54c616f418 FOREIGN KEY (breed_id) REFERENCES public.breeds(id);


--
-- Name: fk_rails_5b9551c291; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_5b9551c291 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: fk_rails_5f0de18556; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_rails_5f0de18556 FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: fk_rails_636732d23d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_636732d23d FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: fk_rails_6c6a346128; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_posts
    ADD CONSTRAINT fk_rails_6c6a346128 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_758836b4f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_rails_758836b4f0 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_79d7faf1bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grooming_centres
    ADD CONSTRAINT fk_rails_79d7faf1bd FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_7a115718fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT fk_rails_7a115718fc FOREIGN KEY (pet_type_id) REFERENCES public.pet_types(id);


--
-- Name: fk_rails_7a3e8824e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vaccinations
    ADD CONSTRAINT fk_rails_7a3e8824e1 FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: fk_rails_7d9dad7484; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_7d9dad7484 FOREIGN KEY (item_categories_id) REFERENCES public.item_categories(id);


--
-- Name: fk_rails_859d9950f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_859d9950f0 FOREIGN KEY (calendar_id) REFERENCES public.calendars(id);


--
-- Name: fk_rails_97ab850fb8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_requests
    ADD CONSTRAINT fk_rails_97ab850fb8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_9877f90194; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shopping_cart_items
    ADD CONSTRAINT fk_rails_9877f90194 FOREIGN KEY (recurssion_interval_id) REFERENCES public.recurssion_intervals(id);


--
-- Name: fk_rails_9d113f9d4b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_9d113f9d4b FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: fk_rails_9e31213785; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_9e31213785 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_a11712551f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_rails_a11712551f FOREIGN KEY (service_option_time_id) REFERENCES public.service_option_times(id);


--
-- Name: fk_rails_a2ee297040; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_a2ee297040 FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_a3ca26ac4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_rails_a3ca26ac4d FOREIGN KEY (recurssion_interval_id) REFERENCES public.recurssion_intervals(id);


--
-- Name: fk_rails_a77d9b33fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_a77d9b33fe FOREIGN KEY (vet_id) REFERENCES public.vets(id);


--
-- Name: fk_rails_a7d0f42310; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boardings
    ADD CONSTRAINT fk_rails_a7d0f42310 FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_b080fb4855; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_b080fb4855 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_b2f5576160; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT fk_rails_b2f5576160 FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: fk_rails_bdf324d099; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vaccinations
    ADD CONSTRAINT fk_rails_bdf324d099 FOREIGN KEY (vaccine_type_id) REFERENCES public.vaccine_types(id);


--
-- Name: fk_rails_c8228c5f59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vets
    ADD CONSTRAINT fk_rails_c8228c5f59 FOREIGN KEY (clinic_id) REFERENCES public.clinics(id);


--
-- Name: fk_rails_d0b857f867; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_d0b857f867 FOREIGN KEY (pet_type_id) REFERENCES public.pet_types(id);


--
-- Name: fk_rails_d0e2182ccd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT fk_rails_d0e2182ccd FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: fk_rails_d15744e438; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT fk_rails_d15744e438 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_d537a727d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_details
    ADD CONSTRAINT fk_rails_d537a727d4 FOREIGN KEY (pet_type_id) REFERENCES public.pet_types(id);


--
-- Name: fk_rails_d552b889ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diagnoses
    ADD CONSTRAINT fk_rails_d552b889ea FOREIGN KEY (pet_id) REFERENCES public.pets(id);


--
-- Name: fk_rails_e3cb28f071; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_rails_e3cb28f071 FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: fk_rails_e45eff1e25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_option_times
    ADD CONSTRAINT fk_rails_e45eff1e25 FOREIGN KEY (service_option_detail_id) REFERENCES public.service_option_details(id);


--
-- Name: fk_rails_e53fecd820; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_option_details
    ADD CONSTRAINT fk_rails_e53fecd820 FOREIGN KEY (service_option_id) REFERENCES public.service_options(id);


--
-- Name: fk_rails_eb66139660; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT fk_rails_eb66139660 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_f49bb25abc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_reviews
    ADD CONSTRAINT fk_rails_f49bb25abc FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: fk_rails_f4fa737302; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_f4fa737302 FOREIGN KEY (admin_id) REFERENCES public.admins(id);


--
-- Name: fk_rails_f868b47f6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_f868b47f6a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_fd5a31cf2f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_fd5a31cf2f FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: fk_rails_fef139bea2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_fef139bea2 FOREIGN KEY (pet_type_id) REFERENCES public.pet_types(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20171114131930'),
('20171115080542'),
('20171116131454'),
('20171127131336'),
('20171127131337'),
('20171127131338'),
('20171129094956'),
('20171129103829'),
('20171201142846'),
('20171204133045'),
('20171204133046'),
('20171205120620'),
('20171205120622'),
('20171205122356'),
('20171205142411'),
('20171206091857'),
('20171206092639'),
('20171207143555'),
('20171207144129'),
('20171207144218'),
('20171208090754'),
('20171208094351'),
('20171208094755'),
('20171215090530'),
('20171215090531'),
('20171218155523'),
('20171218161820'),
('20171221102411'),
('20171226081146'),
('20180119150931'),
('20180124121010'),
('20180125110459'),
('20180125121557'),
('20180125121558'),
('20180208062449'),
('20180208062545'),
('20180213130745'),
('20180214100825'),
('20180214110638'),
('20180215163431'),
('20180221090440'),
('20180221103050'),
('20180223084620'),
('20180227101733'),
('20180301130740'),
('20180310110714'),
('20180322125220'),
('20180326091943'),
('20180328085909'),
('20180402135948'),
('20180403102415'),
('20180406131529'),
('20180504093237'),
('20180507122044'),
('20180508082357'),
('20180509073938'),
('20180511134439'),
('20180515130912'),
('20180530114940'),
('20180616185213'),
('20181015133452'),
('20181015144234'),
('20181015150019'),
('20181015160054'),
('20181015160439'),
('20181016115458'),
('20181016120927'),
('20181016131252'),
('20181016144642'),
('20181017120624'),
('20181017121342'),
('20181018142800'),
('20181018144258'),
('20181020090805'),
('20181023060144'),
('20181023070228'),
('20181023151151'),
('20181025124843'),
('20181025154744'),
('20181027072002'),
('20181027073213'),
('20181027073822'),
('20181027091433'),
('20181027095141'),
('20181027103149'),
('20181027135536'),
('20181101110321'),
('20181106130832'),
('20181108104415'),
('20181109162758'),
('20181109164659'),
('20181112083001'),
('20181119135555'),
('20181119135556'),
('20181120114743'),
('20181121135340'),
('20181126153349'),
('20181127114618'),
('20181128100727'),
('20181130102218'),
('20181205120936'),
('20181205120946'),
('20181205120959'),
('20181206073249'),
('20181207172207'),
('20181212093409'),
('20181213123314'),
('20181214120540'),
('20181218101755'),
('20181222141637'),
('20181224104638'),
('20181225104517'),
('20181227093934'),
('20181227134303'),
('20190412121525'),
('20190419141622'),
('20190424073441'),
('20190426081550'),
('20190503070829'),
('20190503134211'),
('20190506145806'),
('20190514074821'),
('20190514114144'),
('20190516142135'),
('20190520082024'),
('20190521112407'),
('20190527071941'),
('20190527113051'),
('20190530123640'),
('20190606115107'),
('20190607124136'),
('20190607125447'),
('20190610125009'),
('20190611081442'),
('20190614103926'),
('20190620083531'),
('20190620123632'),
('20190626112218');


