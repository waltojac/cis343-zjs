%{
	#include "zoomjoystrong.tab.h"
	#include <stdlib.h>
%}

%option noyywrap

%%

(end)							{printf("\nShutting down...\n"); yylval.str = strdup(yytext); return END;}
;								{return END_STATEMENT;}
(point)							{yylval.str = strdup(yytext); return POINT;}
(line)							{yylval.str = strdup(yytext); return LINE;}
(circle)						{yylval.str = strdup(yytext); return CIRCLE;}
(rectangle)						{yylval.str = strdup(yytext); return RECTANGLE;}
(set_color)						{yylval.str = strdup(yytext); return SET_COLOR;}
[0-9]+							{yylval.i = atof(yytext); return INT;}
[0-9]+\.[0-9]+					{yylval.f = atof(yytext); return FLOAT;}
[ \n\t]	; 
. ;				                {printf("\nInvalid input.\n");}

%%
