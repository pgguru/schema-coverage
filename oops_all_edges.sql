/* script to create a schema with various edge cases */

/*** column-related attributes ***/
/* 0 columns */
CREATE TABLE no_column_table ();

/* max columns */
WITH colname AS (SELECT generate_series(1,1600) colname )
SELECT format($$CREATE TABLE many_columns (%s) $$, string_agg('data' || colname || ' int', ', ')) FROM colname \gexec
/* multiple dropped columns */
/* namespaces */


/*** datatypes ***/
/* custom data types */
/* custom data types with arrays */
/* jsonb */
/* geometry column */
/* bytea */


/*** references ***/
/* identity PK */
/* generated columns PK */
/* composite PK/FK */
/* simple FK */
/* composite FK */
/* self-referential table */
/* circular dependency */
/* ON UPDATE/ON DELETE SET NULL */
/* ON UPDATE/ON DELETE RESTRICT */
/* ON UPDATE/ON DELETE CASCADE */
