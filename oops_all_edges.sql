/* script to create a schema with various edge cases */

BEGIN;

/*** column-related attributes ***/
/* 0 columns */
CREATE TABLE no_column_table ();

/* max columns */
WITH colname AS (SELECT generate_series(1,1600) colname )
SELECT format($$CREATE TABLE many_columns (%s) $$, string_agg('data' || colname || ' int', ', ')) FROM colname \gexec

/* multiple dropped columns */
CREATE TABLE multicol_dropped (
    id serial primary key,
    column1 int,
    column2 int,
    column3 int,
    column4 int,
    column5 int,
    column6 int,
    column7 int
);

ALTER TABLE multicol_dropped DROP COLUMN column1, DROP COLUMN column4, ADD COLUMN column8 int;
ALTER TABLE multicol_dropped DROP COLUMN column2, ADD COLUMN column1 int, ADD COLUMN column9 int;

/* namespaces */
-- TODO

/*** datatypes ***/
/* non-core data types */
CREATE EXTENSION citext;
CREATE TABLE citext_container (
    id serial primary key,
    data citext
);
    
/* non-core data types with arrays */
CREATE TABLE citext_array_container (
    id serial primary key,
    data citext[]
);

/* jsonb */
CREATE TABLE jsonb_container (
    id serial primary key,
    data jsonb
);

/* geometry column */
CREATE EXTENSION postgis;
CREATE TABLE geometery_container (
    id serial primary key,
    data public.geometry
);

/* bytea */
CREATE TABLE bytea_container (
    id serial primary key,
    data bytea
);

/*** references ***/
/* identity PK */
CREATE TABLE identity_pk (
    id integer generated always as identity,
    data text
);

/* generated columns */
CREATE TABLE generated_cols (
    id integer generated always as identity,
    width float,
    height float,
    depth float,
    surface_area float generated always as (2 * width * height + 2 * width * depth + 2 * height * depth) stored,
    volume float generated always as (width * height * depth) stored
);

/* composite PK/FK */
CREATE TABLE composite_key (
    a int not null,
    b int not null,
    data text,
    primary key (a,b)
);

CREATE TABLE composite_key_target (
    id serial primary key,
    a int,
    b int,
    data text,
    foreign key (a,b) references composite_key(a,b)
);

/* self-referential table */
CREATE TABLE test_tree (
    id serial primary key,
    parent int,
    data text,
    foreign key (parent) references test_tree(id)
);

/* circular dependency */
/* ON UPDATE/ON DELETE SET NULL */
/* ON UPDATE/ON DELETE RESTRICT */
/* ON UPDATE/ON DELETE CASCADE */

COMMIT;
