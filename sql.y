/* Companion source code for "flex & bison", published by O'Reilly
 * Media, ISBN 978-0-596-15597-1
 * Copyright (c) 2009, Taughannock Networks. All rights reserved.
 * See the README file for license conditions and contact info.
 * $Header: /home/johnl/flnb/code/sql/RCS/lpmysql.y,v 2.1 2009/11/08 02:53:39 johnl Exp $
 */

%define api.pure
%parse-param { struct psql_state *pstate }

/*
 * Parser for mysql subset
 */
%{
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "sql-parser.h"

 %}

%code requires {
char *filename;

typedef struct YYLTYPE {
  int first_line;
  int first_column;
  int last_line;
  int last_column;
  char *filename;
} YYLTYPE;
# define YYLTYPE_IS_DECLARED 1

# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (N)                                                            \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	  (Current).filename     = YYRHSLOC (Rhs, 1).filename;	        \
	}								\
      else								\
	{ /* empty RHS */						\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	  (Current).filename  = NULL;					\
	}								\
    while (0)
}


%union {
	int intval;
	double floatval;
	char *strval;
	int subtok;
}

%{
#include "sql.lex.h"
#include "sql-parser-state.h"
#define YYLEX_PARAM pstate->scaninfo
%}
	
	/* names and literal values */

%token <strval> NAME
%token <strval> STRING
%token <intval> INTNUM
%token <intval> BOOL
%token <floatval> APPROXNUM

       /* user @abc names */

%token <strval> USERVAR

       /* operators and precedence levels */

%right ASSIGN
%left OR
%left XOR
%left ANDOP
%nonassoc IN IS LIKE REGEXP
%left NOT '!'
%left BETWEEN
%left <subtok> COMPARISON /* = <> < > <= >= <=> */
%left '|'
%left '&'
%left <subtok> SHIFT /* << >> */
%left '+' '-'
%left '*' '/' '%' MOD
%left '^'
%nonassoc UMINUS

%token ADD
%token ALL
%token ALTER
%token ANALYZE
%token AND
%token ANY
%token AS
%token ASC
%token AUTO_INCREMENT
%token BEFORE
%token BETWEEN
%token BIGINT
%token BINARY
%token BIT
%token BLOB
%token BOTH
%token BY
%token CALL
%token CASCADE
%token CASE
%token CHANGE
%token CHAR
%token CHECK
%token COLLATE
%token COLUMN
%token COMMENT
%token CONDITION
%token CONSTRAINT
%token CONTINUE
%token CONVERT
%token CREATE
%token CROSS
%token CURRENT_DATE
%token CURRENT_TIME
%token CURRENT_TIMESTAMP
%token CURRENT_USER
%token CURSOR
%token DATABASE
%token DATABASES
%token DATE
%token DATETIME
%token DAY_HOUR
%token DAY_MICROSECOND
%token DAY_MINUTE
%token DAY_SECOND
%token DECIMAL
%token DECLARE
%token DEFAULT
%token DELAYED
%token DELETE
%token DESC
%token DESCRIBE
%token DETERMINISTIC
%token DISTINCT
%token DISTINCTROW
%token DIV
%token DOUBLE
%token DROP
%token DUAL
%token EACH
%token ELSE
%token ELSEIF
%token ENCLOSED
%token END
%token ENUM
%token ESCAPED
%token <subtok> EXISTS
%token EXIT
%token EXPLAIN
%token FETCH
%token FLOAT
%token FOR
%token FORCE
%token FOREIGN
%token FROM
%token FULLTEXT
%token GRANT
%token GROUP
%token HAVING
%token HIGH_PRIORITY
%token HOUR_MICROSECOND
%token HOUR_MINUTE
%token HOUR_SECOND
%token IF
%token IGNORE
%token IN
%token INDEX
%token INFILE
%token INNER
%token INOUT
%token INSENSITIVE
%token INSERT
%token INT
%token INTEGER
%token INTERVAL
%token INTO
%token ITERATE
%token JOIN
%token KEY
%token KEYS
%token KILL
%token LEADING
%token LEAVE
%token LEFT
%token LIKE
%token LIMIT
%token LINES
%token LOAD
%token LOCALTIME
%token LOCALTIMESTAMP
%token LOCK
%token LONG
%token LONGBLOB
%token LONGTEXT
%token LOOP
%token LOW_PRIORITY
%token MATCH
%token MEDIUMBLOB
%token MEDIUMINT
%token MEDIUMTEXT
%token MINUTE_MICROSECOND
%token MINUTE_SECOND
%token MOD
%token MODIFIES
%token NATURAL
%token NOT
%token NO_WRITE_TO_BINLOG
%token NULLX
%token NUMBER
%token ON
%token ONDUPLICATE
%token OPTIMIZE
%token OPTION
%token OPTIONALLY
%token OR
%token ORDER
%token OUT
%token OUTER
%token OUTFILE
%token PRECISION
%token PRIMARY
%token PROCEDURE
%token PURGE
%token QUICK
%token READ
%token READS
%token REAL
%token REFERENCES
%token REGEXP
%token RELEASE
%token RENAME
%token REPEAT
%token REPLACE
%token REQUIRE
%token RESTRICT
%token RETURN
%token REVOKE
%token RIGHT
%token ROLLUP
%token SCHEMA
%token SCHEMAS
%token SECOND_MICROSECOND
%token SELECT
%token SENSITIVE
%token SEPARATOR
%token SET
%token SHOW
%token SMALLINT
%token SOME
%token SONAME
%token SPATIAL
%token SPECIFIC
%token SQL
%token SQLEXCEPTION
%token SQLSTATE
%token SQLWARNING
%token SQL_BIG_RESULT
%token SQL_CALC_FOUND_ROWS
%token SQL_SMALL_RESULT
%token SSL
%token STARTING
%token STRAIGHT_JOIN
%token TABLE
%token TEMPORARY
%token TEXT
%token TERMINATED
%token THEN
%token TIME
%token TIMESTAMP
%token TINYBLOB
%token TINYINT
%token TINYTEXT
%token TO
%token TRAILING
%token TRIGGER
%token UNDO
%token UNION
%token UNIQUE
%token UNLOCK
%token UNSIGNED
%token UPDATE
%token USAGE
%token USE
%token USING
%token UTC_DATE
%token UTC_TIME
%token UTC_TIMESTAMP
%token VALUES
%token VARBINARY
%token VARCHAR
%token VARYING
%token WHEN
%token WHERE
%token WHILE
%token WITH
%token WRITE
%token XOR
%token YEAR
%token YEAR_MONTH
%token ZEROFILL

 /* functions with special syntax */
%token FSUBSTRING
%token FTRIM
%token FDATE_ADD FDATE_SUB
%token FCOUNT

%type <intval> select_opts select_expr_list
%type <intval> val_list opt_val_list case_list
%type <intval> groupby_list opt_with_rollup opt_asc_desc
%type <intval> table_references opt_inner_cross opt_outer
%type <intval> left_or_right opt_left_or_right_outer column_list
%type <intval> index_list opt_for_join

%type <intval> delete_opts delete_list
%type <intval> insert_opts insert_vals insert_vals_list
%type <intval> insert_asgn_list opt_if_not_exists update_opts update_asgn_list
%type <intval> opt_if_exists table_list
%type <intval> opt_temporary opt_length opt_binary opt_uz enum_list
%type <intval> column_atts data_type opt_ignore_replace create_col_list

%start stmt_list

%{
void yyerror(YYLTYPE *, struct psql_state *pstate, char *s, ...);
void lyyerror(YYLTYPE t, char *s, ...);
 %}
  /* free discarded tokens */
%destructor { printf ("free at %d %s\n",@$.first_line, $$); free($$); } <strval>

%%

stmt_list: stmt ';'
  | stmt_list stmt ';'
  ;

stmt_list: error ';'
   | stmt_list error ';' ;

   /* statements: select statement */

stmt: select_stmt { sqlp_stmt(); }
   ;

select_stmt: SELECT select_opts select_expr_list
                        { sqlp_select_nodata($2, $3); } ;
    | SELECT select_opts select_expr_list
     FROM table_references
     opt_where opt_groupby opt_having opt_orderby opt_limit
     opt_into_list { sqlp_select($2, $3, $5); } ;
;

opt_where: /* nil */ 
   | WHERE expr { sqlp_where(); };

opt_groupby: /* nil */ 
   | GROUP BY groupby_list opt_with_rollup
                             { sqlp_group_by_list($3, $4); }
;

groupby_list: expr opt_asc_desc
                             { sqlp_group_by($2); $$ = 1; }
   | groupby_list ',' expr opt_asc_desc
                             { sqlp_group_by($4); $$ = $1 + 1; }
   ;

opt_asc_desc: /* nil */ { $$ = 0; }
   | ASC                { $$ = 0; }
   | DESC               { $$ = 1; }
    ;

opt_with_rollup: /* nil */  { $$ = 0; }
   | WITH ROLLUP  { $$ = 1; }
   ;

opt_having: /* nil */ | HAVING expr { sqlp_having(); };

opt_orderby: /* nil */ | ORDER BY groupby_list { sqlp_order_by($3); }
   ;

opt_limit: /* nil */ | LIMIT expr { sqlp_limit(0); }
  | LIMIT expr ',' expr             { sqlp_limit(1); }
  ; 

opt_into_list: /* nil */ 
   | INTO column_list { sqlp_into($2); }
   ;

column_list: NAME          { sqlp_column($1); free($1); $$ = 1; }
  | STRING                 { lyyerror(@1, "string %s found where name required", $1);
                              sqlp_column($1); free($1); $$ = 1; }
  | column_list ',' NAME   { sqlp_column($3); free($3); $$ = $1 + 1; }
  | column_list ',' STRING { lyyerror(@3, "string %s found where name required", $1);
                            sqlp_column($3); free($3); $$ = $1 + 1; }
  ;

select_opts:                          { $$ = 0; }
| select_opts ALL                 { if($$ & 01) lyyerror(@2,"duplicate ALL option"); $$ = $1 | 01; }
| select_opts DISTINCT            { if($$ & 02) lyyerror(@2,"duplicate DISTINCT option"); $$ = $1 | 02; }
| select_opts DISTINCTROW         { if($$ & 04) lyyerror(@2,"duplicate DISTINCTROW option"); $$ = $1 | 04; }
| select_opts HIGH_PRIORITY       { if($$ & 010) lyyerror(@2,"duplicate HIGH_PRIORITY option"); $$ = $1 | 010; }
| select_opts STRAIGHT_JOIN       { if($$ & 020) lyyerror(@2,"duplicate STRAIGHT_JOIN option"); $$ = $1 | 020; }
| select_opts SQL_SMALL_RESULT    { if($$ & 040) lyyerror(@2,"duplicate SQL_SMALL_RESULT option"); $$ = $1 | 040; }
| select_opts SQL_BIG_RESULT      { if($$ & 0100) lyyerror(@2,"duplicate SQL_BIG_RESULT option"); $$ = $1 | 0100; }
| select_opts SQL_CALC_FOUND_ROWS { if($$ & 0200) lyyerror(@2,"duplicate SQL_CALC_FOUND_ROWS option"); $$ = $1 | 0200; }
    ;

select_expr_list: select_expr { $$ = 1; }
    | select_expr_list ',' select_expr {$$ = $1 + 1; }
    | '*' { sqlp_select_all(); $$ = 1; }
    ;

select_expr: expr opt_as_alias ;

table_references:    table_reference { $$ = 1; }
    | table_references ',' table_reference { $$ = $1 + 1; }
    ;

table_reference:  table_factor
  | join_table
;

table_factor:
    NAME opt_as_alias index_hint { sqlp_table(NULL, $1); free($1); }
  | NAME '.' NAME opt_as_alias index_hint { sqlp_table($1, $3);
                               free($1); free($3); }
  | table_subquery opt_as NAME { sqlp_subquery_as($3); free($3); }
  | '(' table_references ')' { sqlp_table_refs($2); }
  ;

opt_as: AS 
  | /* nil */
  ;

opt_as_alias: AS NAME { sqlp_alias($2); free($2); }
  | NAME              { sqlp_alias($1); free($1); }
  | /* nil */
  ;

join_table:
    table_reference opt_inner_cross JOIN table_factor opt_join_condition
                  { sqlp_join(0100+$2); }
  | table_reference STRAIGHT_JOIN table_factor
                  { sqlp_join(0200); }
  | table_reference STRAIGHT_JOIN table_factor ON expr
                  { sqlp_join(0200); }
  | table_reference left_or_right opt_outer JOIN table_factor join_condition
                  { sqlp_join(0300+$2+$3); }
  | table_reference NATURAL opt_left_or_right_outer JOIN table_factor
                  { sqlp_join(0400+$3); }
  ;

opt_inner_cross: /* nil */ { $$ = 0; }
   | INNER { $$ = 1; }
   | CROSS  { $$ = 2; }
;

opt_outer: /* nil */  { $$ = 0; }
   | OUTER {$$ = 4; }
   ;

left_or_right: LEFT { $$ = 1; }
    | RIGHT { $$ = 2; }
    ;

opt_left_or_right_outer: LEFT opt_outer { $$ = 1 + $2; }
   | RIGHT opt_outer  { $$ = 2 + $2; }
   | /* nil */ { $$ = 0; }
   ;

opt_join_condition: join_condition | /* nil */ ;

join_condition:
    ON expr { sqlp_join_expr(); }
    | USING '(' column_list ')' { sqlp_join_using($3); }
    ;

index_hint:
     USE KEY opt_for_join '(' index_list ')'
                  { sqlp_index_hint($5, 010+$3); }
   | IGNORE KEY opt_for_join '(' index_list ')'
                  { sqlp_index_hint($5, 020+$3); }
   | FORCE KEY opt_for_join '(' index_list ')'
                  { sqlp_index_hint($5, 030+$3); }
   | /* nil */
   ;

opt_for_join: FOR JOIN { $$ = 1; }
   | /* nil */ { $$ = 0; }
   ;

index_list: NAME  { sqlp_index($1); free($1); $$ = 1; }
   | index_list ',' NAME { sqlp_index($3); free($3); $$ = $1 + 1; }
   ;

table_subquery: '(' select_stmt ')' { sqlp_subquery(); }
   ;

   /* statements: delete statement */

stmt: delete_stmt { sqlp_stmt(); }
   ;

delete_stmt: DELETE delete_opts FROM NAME
    opt_where opt_orderby opt_limit
                  { sqlp_delete($2, $4); free($4); }
;

delete_opts: delete_opts LOW_PRIORITY { $$ = $1 + 01; }
   | delete_opts QUICK { $$ = $1 + 02; }
   | delete_opts IGNORE { $$ = $1 + 04; }
   | /* nil */ { $$ = 0; }
   ;

delete_stmt: DELETE delete_opts
    delete_list
    FROM table_references opt_where
            { sqlp_delete_multi($2, $3, $5); }

delete_list: NAME opt_dot_star { sqlp_table(NULL, $1); free($1); $$ = 1; }
   | delete_list ',' NAME opt_dot_star
            { sqlp_table(NULL, $3); free($3); $$ = $1 + 1; }
   ;

opt_dot_star: /* nil */ | '.' '*' ;

delete_stmt: DELETE delete_opts
    FROM delete_list
    USING table_references opt_where
            { sqlp_delete_multi($2, $4, $6); }
;

   /* statements: insert statement */

stmt: insert_stmt { sqlp_stmt(); }
   ;

insert_stmt: INSERT insert_opts opt_into NAME
     opt_col_names
     VALUES insert_vals_list
     opt_ondupupdate { sqlp_insert($2, $7, $4); free($4) }
   ;

opt_ondupupdate: /* nil */
   | ONDUPLICATE KEY UPDATE insert_asgn_list { sqlp_ins_dup_update($4); }
   ;

insert_opts: /* nil */ { $$ = 0; }
   | insert_opts LOW_PRIORITY { $$ = $1 | 01 ; }
   | insert_opts DELAYED { $$ = $1 | 02 ; }
   | insert_opts HIGH_PRIORITY { $$ = $1 | 04 ; }
   | insert_opts IGNORE { $$ = $1 | 010 ; }
   ;

opt_into: INTO | /* nil */
   ;

opt_col_names: /* nil */
   | '(' column_list ')' { sqlp_ins_cols($2); }
   ;

insert_vals_list: '(' insert_vals ')' { sqlp_values($2); $$ = 1; }
   | insert_vals_list ',' '(' insert_vals ')' { sqlp_values($4); $$ = $1 + 1; }

insert_vals:
     expr { $$ = 1; }
   | DEFAULT { sqlp_ins_default(); $$ = 1; }
   | insert_vals ',' expr { $$ = $1 + 1; }
   | insert_vals ',' DEFAULT { sqlp_ins_default(); $$ = $1 + 1; }
   ;

insert_stmt: INSERT insert_opts opt_into NAME
    SET insert_asgn_list
    opt_ondupupdate
     { sqlp_insert_assn($2, $6, $4); free($4) }
   ;

insert_stmt: INSERT insert_opts opt_into NAME opt_col_names
    select_stmt
    opt_ondupupdate { sqlp_insert_sel($2, $4); free($4); }
  ;

insert_asgn_list:
     NAME COMPARISON expr 
       { if ($2 != 4) { lyyerror(@2,"bad insert assignment to %s", $1); YYERROR; }
       sqlp_assign(NULL, $1); free($1); $$ = 1; }
   | NAME COMPARISON DEFAULT
       { if ($2 != 4) { lyyerror(@2,"bad insert assignment to %s", $1); YYERROR; }
                 sqlp_ins_default(); sqlp_assign(NULL, $1); free($1); $$ = 1; }
   | insert_asgn_list ',' NAME COMPARISON expr
       { if ($4 != 4) { lyyerror(@4,"bad insert assignment to %s", $1); YYERROR; }
                 sqlp_assign(NULL, $3); free($3); $$ = $1 + 1; }
   | insert_asgn_list ',' NAME COMPARISON DEFAULT
       { if ($4 != 4) { lyyerror(@4,"bad insert assignment to %s", $1); YYERROR; }
                 sqlp_ins_default(); sqlp_assign(NULL, $3); free($3); $$ = $1 + 1; }
   ;

   /** replace just like insert **/
stmt: replace_stmt { sqlp_stmt(); }
   ;

replace_stmt: REPLACE insert_opts opt_into NAME
     opt_col_names
     VALUES insert_vals_list
     opt_ondupupdate { sqlp_replace_vals($2, $7, $4); free($4) }
   ;

replace_stmt: REPLACE insert_opts opt_into NAME
    SET insert_asgn_list
    opt_ondupupdate
     { sqlp_replace_assn($2, $6, $4); free($4) }
   ;

replace_stmt: REPLACE insert_opts opt_into NAME opt_col_names
    select_stmt
    opt_ondupupdate { sqlp_replace_sel($2, $4); free($4); }
  ;

/** update **/
stmt: update_stmt { sqlp_stmt(); }
   ;

update_stmt: UPDATE update_opts table_references
    SET update_asgn_list
    opt_where
    opt_orderby
opt_limit { sqlp_update($2, $3, $5); }
;

update_opts: /* nil */ { $$ = 0; }
   | insert_opts LOW_PRIORITY { $$ = $1 | 01 ; }
   | insert_opts IGNORE { $$ = $1 | 010 ; }
   ;

update_asgn_list:
     NAME COMPARISON expr 
     { if ($2 != 4) { lyyerror(@2,"bad update assignment to %s", $1); YYERROR; }
	 sqlp_assign(NULL, $1); free($1); $$ = 1; }
   | NAME '.' NAME COMPARISON expr 
   { if ($4 != 4) { lyyerror(@4,"bad update assignment to %s", $1); YYERROR; }
	 sqlp_assign($1, $3); free($1); free($3); $$ = 1; }
   | update_asgn_list ',' NAME COMPARISON expr
   { if ($4 != 4) { lyyerror(@4,"bad update assignment to %s", $3); YYERROR; }
	 sqlp_assign(NULL, $3); free($3); $$ = $1 + 1; }
   | update_asgn_list ',' NAME '.' NAME COMPARISON expr
   { if ($6 != 4) { lyyerror(@6,"bad update  assignment to %s.$s", $3, $5); YYERROR; }
	 sqlp_assign($3, $5); free($3); free($5); $$ = 1; }
   ;


   /** create database **/

stmt: create_database_stmt { sqlp_stmt(); }
   ;

create_database_stmt: 
     CREATE DATABASE opt_if_not_exists NAME { sqlp_create_db($3, $4); free($4); }
   | CREATE SCHEMA opt_if_not_exists NAME { sqlp_create_db($3, $4); free($4); }
   ;

opt_if_not_exists:  /* nil */ { $$ = 0; }
   | IF EXISTS        { if(!$2) { lyyerror(@2,"IF EXISTS doesn't exist"); YYERROR; }
                        $$ = $2; /* NOT EXISTS hack */ }
   ;

   /** drop database **/

stmt: drop_database_stmt { sqlp_stmt(); }
   ;

drop_database_stmt: 
     DROP DATABASE opt_if_exists NAME { sqlp_drop_db($3, $4); free($4); }
   | DROP SCHEMA opt_if_exists NAME { sqlp_drop_db($3, $4); free($4); }
   ;

opt_if_exists:  /* nil */ { $$ = 0; }
   | IF EXISTS        { $$ = 1; }
   ;


   /** create table **/
stmt: create_table_stmt { sqlp_stmt(); }
   ;

create_table_stmt: CREATE opt_temporary TABLE opt_if_not_exists NAME
   '(' create_col_list ')' { sqlp_create_tbl($2, $4, $7, NULL, $5); free($5); }
   ;

create_table_stmt: CREATE opt_temporary TABLE opt_if_not_exists NAME '.' NAME
   '(' create_col_list ')' { sqlp_create_tbl($2, $4, $9, $5, $7);
                          free($5); free($7); }
   ;

create_table_stmt: CREATE opt_temporary TABLE opt_if_not_exists NAME
   '(' create_col_list ')'
create_select_statement { sqlp_create_tbl_sel($2, $4, $7, NULL, $5); free($5); }
    ;

create_table_stmt: CREATE opt_temporary TABLE opt_if_not_exists NAME
   create_select_statement { sqlp_create_tbl_sel($2, $4, 0, NULL, $5); free($5); }
    ;

create_table_stmt: CREATE opt_temporary TABLE opt_if_not_exists NAME '.' NAME
   '(' create_col_list ')'
   create_select_statement  { sqlp_create_tbl_sel($2, $4, 0, $5, $7);
                              free($5); free($7); }
    ;

create_table_stmt: CREATE opt_temporary TABLE opt_if_not_exists NAME '.' NAME
   create_select_statement { sqlp_create_tbl_sel($2, $4, 0, $5, $7);
                          free($5); free($7); }
    ;

create_col_list: create_definition { $$ = 1; }
    | create_col_list ',' create_definition { $$ = $1 + 1; }
    ;

create_definition: { sqlp_start_col(); } NAME data_type column_atts
                   { sqlp_def_col($3, $2); free($2); }

    | PRIMARY KEY '(' column_list ')'    { sqlp_col_key_pri($4); }
    | KEY '(' column_list ')'            { sqlp_col_key($3); }
    | INDEX '(' column_list ')'          { sqlp_col_key($3); }
    | FULLTEXT INDEX '(' column_list ')' { sqlp_col_key_textidx($4); }
    | FULLTEXT KEY '(' column_list ')'   { sqlp_col_key_textidx($4); }
    ;

column_atts: /* nil */ { $$ = 0; }
    | column_atts NOT NULLX             { sqlp_col_attr(SCA_NOTNULL); $$ = $1 + 1; }
    | column_atts NULLX
    | column_atts DEFAULT STRING        { sqlp_col_def_str($3); free($3); $$ = $1 + 1; }
    | column_atts DEFAULT INTNUM        { sqlp_col_def_num($3); $$ = $1 + 1; }
    | column_atts DEFAULT APPROXNUM     { sqlp_col_def_float($3); $$ = $1 + 1; }
    | column_atts DEFAULT BOOL          { sqlp_col_def_bool($3); $$ = $1 + 1; }
    | column_atts AUTO_INCREMENT        { sqlp_col_attr(SCA_AUTOINC); $$ = $1 + 1; }
    | column_atts UNIQUE '(' column_list ')' { sqlp_col_attr_uniq($4); $$ = $1 + 1; }
    | column_atts UNIQUE KEY { sqlp_col_attr_uniq(0); $$ = $1 + 1; }
    | column_atts PRIMARY KEY { sqlp_col_attr(SCA_PRIMARY_KEY); $$ = $1 + 1; }
    | column_atts KEY { sqlp_col_attr(SCA_PRIMARY_KEY); $$ = $1 + 1; }
    | column_atts COMMENT STRING { sqlp_col_attr_comm($3); free($3); $$ = $1 + 1; }
    ;

opt_length: /* nil */ { $$ = 0; }
   | '(' INTNUM ')' { $$ = $2; }
   | '(' INTNUM ',' INTNUM ')' { $$ = $2 + 1000*$4; }
   ;

opt_binary: /* nil */ { $$ = 0; }
   | BINARY { $$ = 4000; }
   ;

opt_uz: /* nil */ { $$ = 0; }
   | opt_uz UNSIGNED { $$ = $1 | 1000; }
   | opt_uz ZEROFILL { $$ = $1 | 2000; }
   ;

opt_csc: /* nil */
   | opt_csc CHAR SET STRING { sqlp_col_charset($4); free($4); }
   | opt_csc COLLATE STRING { sqlp_col_collate($3); free($3); }
   ;

data_type:
     BIT opt_length { $$ = 10000 + $2; }
   | TINYINT opt_length opt_uz { $$ = 10000 + $2; }
   | SMALLINT opt_length opt_uz { $$ = 20000 + $2 + $3; }
   | MEDIUMINT opt_length opt_uz { $$ = 30000 + $2 + $3; }
   | INT opt_length opt_uz { $$ = 40000 + $2 + $3; }
   | INTEGER opt_length opt_uz { $$ = 50000 + $2 + $3; }
   | BIGINT opt_length opt_uz { $$ = 60000 + $2 + $3; }
   | REAL opt_length opt_uz { $$ = 70000 + $2 + $3; }
   | DOUBLE opt_length opt_uz { $$ = 80000 + $2 + $3; }
   | FLOAT opt_length opt_uz { $$ = 90000 + $2 + $3; }
   | DECIMAL opt_length opt_uz { $$ = 110000 + $2 + $3; }
   | DATE { $$ = 100001; }
   | TIME { $$ = 100002; }
   | TIMESTAMP { $$ = 100003; }
   | DATETIME { $$ = 100004; }
   | YEAR { $$ = 100005; }
   | CHAR opt_length opt_csc { $$ = 120000 + $2; }
   | VARCHAR '(' INTNUM ')' opt_csc { $$ = 130000 + $3; }
   | BINARY opt_length { $$ = 140000 + $2; }
   | VARBINARY '(' INTNUM ')' { $$ = 150000 + $3; }
   | TINYBLOB { $$ = 160001; }
   | BLOB { $$ = 160002; }
   | MEDIUMBLOB { $$ = 160003; }
   | LONGBLOB { $$ = 160004; }
   | TINYTEXT opt_binary opt_csc { $$ = 170000 + $2; }
   | TEXT opt_binary opt_csc { $$ = 171000 + $2; }
   | MEDIUMTEXT opt_binary opt_csc { $$ = 172000 + $2; }
   | LONGTEXT opt_binary opt_csc { $$ = 173000 + $2; }
   | ENUM '(' enum_list ')' opt_csc { $$ = 200000 + $3; }
   | SET '(' enum_list ')' opt_csc { $$ = 210000 + $3; }
   ;

enum_list: STRING { sqlp_enum_val($1); free($1); $$ = 1; }
   | enum_list ',' STRING { sqlp_enum_val($3); free($3); $$ = $1 + 1; }
   ;

create_select_statement: opt_ignore_replace opt_as select_stmt { sqlp_create_sel($1) }
   ;

opt_ignore_replace: /* nil */ { $$ = 0; }
   | IGNORE { $$ = 1; }
   | REPLACE { $$ = 2; }
   ;

opt_temporary:   /* nil */ { $$ = 0; }
   | TEMPORARY { $$ = 1;}
   ;

   /** drop table **/

stmt: drop_table_stmt { sqlp_stmt(); }
   ;

drop_table_stmt: 
   DROP opt_temporary TABLE opt_if_exists table_list { sqlp_drop_table($2, $4, $5); }
   ;

table_list: NAME          { sqlp_table(NULL, $1); free($1); $$ = 1; }
  | STRING                 { lyyerror(@1, "string %s found where name required", $1);
                              sqlp_table(NULL, $1); free($1); $$ = 1; }
  | table_list ',' NAME   { sqlp_table(NULL, $3); free($3); $$ = $1 + 1; }
  | table_list ',' STRING { lyyerror(@3, "string %s found where name required", $1);
                            sqlp_table(NULL, $3); free($3); $$ = $1 + 1; }
  ;

   /**** set user variables ****/

stmt: set_stmt { sqlp_stmt(); }
   ;

set_stmt: SET set_list ;

set_list: set_expr | set_list ',' set_expr ;

set_expr:
USERVAR COMPARISON expr { if ($2 != 4) { lyyerror(@2,"bad set to @%s", $1); YYERROR; }
		 sqlp_set($1); free($1); }
    | USERVAR ASSIGN expr { sqlp_set($1); free($1); }
    ;

   /**** expressions ****/

expr: NAME          { sqlp_name($1); free($1); }
   | USERVAR         { sqlp_uservar($1); free($1); }
   | NAME '.' NAME { sqlp_fieldname($1, $3); free($1); free($3); }
   | STRING        { sqlp_string($1); free($1); }
   | INTNUM        { sqlp_number($1); }
   | APPROXNUM     { sqlp_float($1); }
   | BOOL          { sqlp_bool($1); }
   ;

expr: expr '+' expr { sqlp_expr_op(SEO_ADD); }
   | expr '-' expr { sqlp_expr_op(SEO_SUB); }
   | expr '*' expr { sqlp_expr_op(SEO_MUL); }
   | expr '/' expr { sqlp_expr_op(SEO_DIV); }
   | expr '%' expr { sqlp_expr_op(SEO_MOD); }
   | expr MOD expr { sqlp_expr_op(SEO_MOD); }
   | '-' expr %prec UMINUS { sqlp_expr_op(SEO_NEG); }
   | expr ANDOP expr { sqlp_expr_op(SEO_AND); }
   | expr OR expr { sqlp_expr_op(SEO_OR); }
   | expr XOR expr { sqlp_expr_op(SEO_XOR); }
   | expr COMPARISON expr { sqlp_expr_cmp($2); }
   | expr COMPARISON '(' select_stmt ')' { sqlp_expr_cmp_sel(0, $2); }
   | expr COMPARISON ANY '(' select_stmt ')' { sqlp_expr_cmp_sel(1, $2); }
   | expr COMPARISON SOME '(' select_stmt ')' { sqlp_expr_cmp_sel(2, $2); }
   | expr COMPARISON ALL '(' select_stmt ')' { sqlp_expr_cmp_sel(3, $2); }
   | expr '|' expr { sqlp_expr_op(SEO_BITOR); }
   | expr '&' expr { sqlp_expr_op(SEO_BITAND); }
   | expr '^' expr { sqlp_expr_op(SEO_BITXOR); }
   | expr SHIFT expr { sqlp_expr_op($2 == 1 ? SEO_SHL : SEO_SHR); }
   | NOT expr { sqlp_expr_op(SEO_NOT); }
   | '!' expr { sqlp_expr_op(SEO_NOT); }
   | USERVAR ASSIGN expr { sqlp_assign_at($1); free($1); }
   ;    

expr:  expr IS NULLX     { sqlp_expr_op(SEO_IS_NULL); }
   |   expr IS NOT NULLX { sqlp_expr_op(SEO_IS_NULL); sqlp_expr_op(SEO_NOT); }
   |   expr IS BOOL      { sqlp_expr_is_bool($3); }
   |   expr IS NOT BOOL  { sqlp_expr_is_bool($4); sqlp_expr_op(SEO_NOT); }
   ;

expr: expr BETWEEN expr AND expr %prec BETWEEN { sqlp_expr_op(SEO_BETWEEN); }
   ;


val_list: expr { $$ = 1; }
   | expr ',' val_list { $$ = 1 + $3; }
   ;

opt_val_list: /* nil */ { $$ = 0 }
   | val_list
   ;

expr: expr IN '(' val_list ')'       { sqlp_expr_is_in($4); }
   | expr NOT IN '(' val_list ')'    { sqlp_expr_is_in($5); sqlp_expr_op(SEO_NOT); }
   | expr IN '(' select_stmt ')'     { sqlp_expr_op(SEO_IN_SELECT); }
   | expr NOT IN '(' select_stmt ')' { sqlp_expr_op(SEO_IN_SELECT); sqlp_expr_op(SEO_NOT); }
   | EXISTS '(' select_stmt ')'      { sqlp_expr_op(SEO_EXISTS); if($1)sqlp_expr_op(SEO_NOT); }
   ;

expr: NAME '(' opt_val_list ')' {  sqlp_call($3, $1); free($1); }
   ;

  /* functions with special syntax */
expr: FCOUNT '(' '*' ')' { sqlp_call(0, "COUNTALL") }
   | FCOUNT '(' expr ')' { sqlp_call(1, "COUNT"); } 

expr: FSUBSTRING '(' val_list ')' {  sqlp_call($3, "SUBSTR");}
   | FSUBSTRING '(' expr FROM expr ')' {  sqlp_call(2, "SUBSTR"); }
   | FSUBSTRING '(' expr FROM expr FOR expr ')' {  sqlp_call(3, "SUBSTR"); }
| FTRIM '(' val_list ')' { sqlp_call($3, "TRIM"); }
   | FTRIM '(' trim_ltb expr FROM val_list ')' { sqlp_call(3, "TRIM"); }
   ;

trim_ltb: LEADING { sqlp_call_trim_opts(0); }
   | TRAILING { sqlp_call_trim_opts(1); }
   | BOTH { sqlp_call_trim_opts(2); }
   ;

expr: FDATE_ADD '(' expr ',' interval_exp ')' { sqlp_call_date(3, SEO_ADD); }
   |  FDATE_SUB '(' expr ',' interval_exp ')' { sqlp_call_date(3, SEO_SUB); }
   ;

interval_exp: INTERVAL expr DAY_HOUR { sqlp_date_interval(SDI_DAY_HOUR); }
   | INTERVAL expr DAY_MICROSECOND { sqlp_date_interval(SDI_DAY_MICROSECOND); }
   | INTERVAL expr DAY_MINUTE { sqlp_date_interval(SDI_DAY_MINUTE); }
   | INTERVAL expr DAY_SECOND { sqlp_date_interval(SDI_DAY_SECOND); }
   | INTERVAL expr YEAR_MONTH { sqlp_date_interval(SDI_YEAR_MONTH); }
   | INTERVAL expr YEAR       { sqlp_date_interval(SDI_YEAR); }
   | INTERVAL expr HOUR_MICROSECOND { sqlp_date_interval(SDI_HOUR_MICROSECOND); }
   | INTERVAL expr HOUR_MINUTE { sqlp_date_interval(SDI_HOUR_MINUTE); }
   | INTERVAL expr HOUR_SECOND { sqlp_date_interval(SDI_HOUR_SECOND); }
   ;

expr: CASE expr case_list END           { sqlp_caseval($3, 0); }
   |  CASE expr case_list ELSE expr END { sqlp_caseval($3, 1); }
   |  CASE case_list END                { sqlp_case($2, 0); }
   |  CASE case_list ELSE expr END      { sqlp_case($2, 1); }
   ;

case_list: WHEN expr THEN expr     { $$ = 1; }
         | case_list WHEN expr THEN expr { $$ = $1+1; } 
   ;

expr: expr LIKE expr { sqlp_expr_op(SEO_LIKE); }
   | expr NOT LIKE expr { sqlp_expr_op(SEO_LIKE); sqlp_expr_op(SEO_NOT); }
   ;

expr: expr REGEXP expr { sqlp_expr_op(SEO_REGEX); }
   | expr NOT REGEXP expr { sqlp_expr_op(SEO_REGEX); sqlp_expr_op(SEO_NOT); }
   ;

expr: CURRENT_TIMESTAMP { sqlp_now(); };
   | CURRENT_DATE	{ sqlp_now(); };
   | CURRENT_TIME	{ sqlp_now(); };
   ;

expr: BINARY expr %prec UMINUS { sqlp_expr_op(SEO_STRTOBIN); }
   ;

%%

void
yyerror(YYLTYPE *t, struct psql_state *pstate, char *s, ...)
{
  va_list ap;
  va_start(ap, s);

  if(t->first_line)
    fprintf(stderr, "%s:%d.%d-%d.%d: error: ", t->filename, t->first_line, t->first_column,
	    t->last_line, t->last_column);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");

}

void
lyyerror(YYLTYPE t, char *s, ...)
{
  va_list ap;
  va_start(ap, s);

  if(t.first_line)
    fprintf(stderr, "%s:%d.%d-%d.%d: error: ", t.filename, t.first_line, t.first_column,
	    t.last_line, t.last_column);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

int
main(int ac, char **av)
{
  FILE *in_f;
  struct psql_state pstate;

  if(ac > 1 && !strcmp(av[1], "-d")) {
    yydebug = 1; ac--; av++;
  }

  memset(&pstate, 0, sizeof(pstate));
  if (yylex_init_extra(&pstate, &pstate.scaninfo))
  	return 1;

  if(ac > 1) {
    if((in_f = fopen(av[1], "r")) == NULL) {
      perror(av[1]);
      exit(1);
    }
    filename = av[1];
  } else {
    filename = "(stdin)";
    in_f = stdin;
  }

  yyset_in(in_f, &pstate.scaninfo);

  if(!yyparse(&pstate))
    printf("SQL parse worked\n");
  else
    printf("SQL parse failed\n");

  return 0;
} /* main */
