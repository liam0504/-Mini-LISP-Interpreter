%{
   #include "y.tab.h"
   #include <string.h>
   void yyerror(const char*) ;
%}
separator   [\t\n\r ]
letter      [a-z]
digit       [0-9]
number      0|[1-9]{digit}*|\-[1-9]{digit}*
id          {letter}({letter}|{digit}|\-)*
%%
{separator}         {;}
"+"|"-"|"*"|"/"     { return(yytext[0]); }
"mod"               { return modulus; }
{number}            { yylval.ival = atoi(yytext); return(number); }
"print-num"         { return printnum; }
"print-bool"        { return printbool; }
"#t"		    { return true;}
"#f"		    { return false;}
"and"               { return And ; }
"or"                { return Or ; }
"not"               { return Not; }
"if"                { return If; }
"define"            { return define_rep ; }
{id}                { yylval.name = strdup(yytext); return(id); }
.                   { return(yytext[0]); }
%%
int yywrap(void){
   return 1;
}
