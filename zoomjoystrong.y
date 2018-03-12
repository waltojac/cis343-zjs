%{
#include <stdio.h>
#include "zoomjoystrong.h"
  void yyerror(const char* msg);
  void drawLine(int x, int y, int u, int v);
  void drawPoint(int x, int y);
  void drawCircle(int x, int y, int r);
  void drawRectangle(int x, int y, int w, int h);
  void draw_set_color(int r, int g, int b);
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
	{ drawLine($2, $3, $4, $5); }
;

point: POINT INT INT END_STATEMENT
	{ drawPoint($2, $3); }
;

circle: CIRCLE INT INT INT END_STATEMENT
	{ drawCircle($2, $3, $4); }
;

rectangle: RECTANGLE INT INT INT INT END_STATEMENT
	{ drawRectangle($2, $3, $4, $5); }
;

set_color: SET_COLOR INT INT INT END_STATEMENT
	{ draw_set_color($2, $3, $4); }
;

end: END END_STATEMENT
	{ printf("\n%s", $1); finish(); return 0; }
;


%%
int main(int argc, char** argv)
{
  printf("\n==========\n");
  setup();
  yyparse();
  return 0;
}

void yyerror(const char* msg)
{
  fprintf(stderr, "ERROR! %s\n", msg);
}

void drawLine(int x, int y, int u, int v)
{
  if ( (x > 0 && x < WIDTH) && (y > 0 && y < HEIGHT )
       && (u > 0 && u < WIDTH) && (v > 0 && v < HEIGHT))
  {
    line(x, y, u, v);
  }
  else
  {
    printf("\nLine values exceed the window size.\n");
  }

}

void drawPoint(int x, int y)
{
  if ((x > 0 && x < WIDTH) && (y > 0 && y < WIDTH))
  {
    point(x, y);
  }
  else
  {
    printf("\nPoint values exceed the window size.\n");
  }
}
void drawCircle(int x, int y, int r)
{
  if (((x - r) > 0 && (x + r) < WIDTH) && ((y - r) > 0
      && (y + r) < HEIGHT))
{
  circle(x, y, r);
  }
  else
  {
    printf("\nCircle values exceed the window size.\n");
  }
}

void drawRectangle(int x, int y, int w, int h)
{
  if (((x + w) < WIDTH && (y + h) < HEIGHT))
{
  rectangle(x, y, w, h);
  }
  else
  {
    printf("\nRectangle values exceed the window size.\n");
  }
}

void draw_set_color(int r, int g, int b)
{
  if (((0 <= r) && (r <= 255)) && ((0 <= g) && (g <= 255)) && ((0 <= b)
      && (b <= 255)))
  {
    set_color(r, g, b);
  }
  else
  {
    printf("\nColor values must be between 0-255.\n");
  }
}

