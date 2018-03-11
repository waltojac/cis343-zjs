%{
	#include <stdio.h>
	#include "zoomjoystrong.h"
	void yyerror(const char* msg);
	int yylex();
%}

%error-verbose
%start zoomjoystrong

%union { int i; char* str; float  f; }

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT

%type<str> END
%type<str> END_STATEMENT
%type<str> POINT
%type<str> LINE
%type<str> CIRCLE
%type<str> RECTANGLE
%type<str> SET_COLOR
%type<i> INT
%type<f> FLOAT

%%

zoomjoystrong: statement_list end
;

statement_list: statement
	| statement statement_list
;

statement: line
	|	point
	|	circle
	|	rectangle
	|	set_color
;

line: LINE INT INT INT INT END_STATEMENT
	{ printf("\n %s %d %d %d %d", $1, $2, $3, $4, $5); line($2, $3, $4, $5); }
;

point: POINT INT INT END_STATEMENT
	{ printf("\n%s %d %d", $1, $2, $3); point($2, $3); }
;

circle: CIRCLE INT INT INT END_STATEMENT
	{ printf("\n%s %d %d %d", $1, $2, $3, $4); circle($2, $3, $4); }
;

rectangle: RECTANGLE INT INT INT INT END_STATEMENT
	{ printf("\n%s %d %d %d %d", $1, $2, $3, $4, $5); rectangle($2, $3, $4, $5); }
;

set_color: SET_COLOR INT INT INT END_STATEMENT
	{ printf("\n%s %d %d %d", $1, $2, $3, $4); set_color($2, $3, $4); }
;

end: END END_STATEMENT
	{ printf("\n%s", $1); finish(); return 0; }
;


%%
int main(int argc, char** argv){
	printf("\n==========\n");
	yyparse();
	return 0;
}
void yyerror(const char* msg){
	fprintf(stderr, "ERROR! %s\n", msg);
}
