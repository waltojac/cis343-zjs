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
	| 	end
;

statement_list: statement
    | 	statement statement_list
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
	{ finish(); return 0; }
;


%%
int main(int argc, char** argv)
{
	//instructions for the program to be displayed.
    printf("\n=================================================================\n");
	printf("*** Welcome to Zoomjoystrong: Modern antiquated graphics tool ***");
	printf("\nThe commands are as follows (must be followed by a ;):");
	printf("\n  ** line x y u v will plot a line from x,y to u,v.");
	printf("\n  ** point x y plots a single point at x,y.");
	printf("\n  ** circle x y r plots a circle of radius r around the center point at x, y.");
	printf("\n  ** rectangle x y w h will draw a rectangle of height h and width w beginning\n\tat the top left edge x,y.");
	printf("\n  ** set_color r g b changes the current drawing color to the r,g,b tuple.");
	printf("\n  ** end will display the image for a few more seconds and quit the program");
	printf("\n=================================================================\n");

	//fucntion to setup the graphics
	setup();

	//set default color to black
	set_color(0,0,0);

	//parse the input data stream
	yyparse();

	//quit the program after parsing
	printf("\nThanks for flying Zoomjoystrong!\n");
	return 0;
}

//function to handle errors in parsing
void yyerror(const char* msg)
{
	fprintf(stderr, "ERROR! %s\n", msg);

	//start parsing again so program doesn't crash
	yyparse();
}

//function to draw a line with error checking included.
void drawLine(int x, int y, int u, int v)
{
	//checks for valid input
	if ( (x > 0 && x < WIDTH) && (y > 0 && y < HEIGHT )
	 && (u > 0 && u < WIDTH) && (v > 0 && v < HEIGHT)){
		line(x, y, u, v);
	}
	else {
		printf("\nLine values exceed the window size.\n");
	}
}

//function to draw a point with error checking included.
void drawPoint(int x, int y)
{
	if ((x > 0 && x < WIDTH) && (y > 0 && y < WIDTH)){
		point(x, y);
	} else{
		printf("\nPoint values exceed the window size.\n");
	}
}

//function to draw a circle with error checking included.
void drawCircle(int x, int y, int r)
{
	if (((x - r) > 0 && (x + r) < WIDTH) && ((y - r) > 0
	  && (y + r) < HEIGHT)){
		circle(x, y, r);
	}
	else {
		printf("\nCircle values exceed the window size.\n");
	}
}

//function to draw a rectangle with error checking included.
void drawRectangle(int x, int y, int w, int h)
{
	if (((x + w) < WIDTH && (y + h) < HEIGHT)){
		rectangle(x, y, w, h);
	} else{
		printf("\nRectangle values exceed the window size.\n");
	}
}

//function to set the color with error checking included.
void draw_set_color(int r, int g, int b)
{
	if (((0 <= r) && (r <= 255)) && ((0 <= g) && (g <= 255)) && ((0 <= b)
	  && (b <= 255))){
	set_color(r, g, b);
	} else {
		printf("\nColor values must be between 0-255.\n");
	}
}

