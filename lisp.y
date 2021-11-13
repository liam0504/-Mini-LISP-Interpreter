%{    
    #include <stdio.h>
    #include <string.h>
    int yylex(void);
    void yyerror(const char*);
    char* id_name_array[100];
    int id_num_array[100];
    int s = 0;
%}

%code provides {}

%union{
    int ival;
    char* name;
}

%token <ival> number
%token <name> id
%token printnum
%token printbool
%token modulus
%token And
%token Or
%token Not
%token true
%token false
%token If
%token END
%token define_rep
%type <ival> Plus
%type <ival> Pluss
%type <ival> Minus
%type <ival> Multiply
%type <ival>Multiplyy
%type <ival> Divide
%type <ival> Modulus
%type <ival>Greater
%type <ival> Smaller
%type <ival> Equal
%type <ival> Equall
%type <ival> EXP
%type <ival>AND_OP
%type <ival> AND_OPP
%type <ival> OR_OP
%type <ival> OR_OPP
%type <ival> NOT_OP
%type <ival> bool_val
%type <ival> If_EXP
%type <ival> Logical_Op
%type <ival> Num_Op
%type <ival> Variable
%%
program  	: STMTs 
		;
STMTs  		: STMTs STMT 
		| STMT
		; 
STMT  		: EXP
		| DEF_STMT  
		| Print_STMT
		;
DEF_STMT    	: '(' define_rep Variable EXP ')'{ id_name_array[s] = $3;
						   id_num_array[s] = $4;
						   s++;
						 }
		;
Variable	: id { int i;
                       for(i = 0; i < s; i++) 
                           if(strcmp(id_name_array[i], $1) == 0){
                                $$ = id_num_array[i];
                                break;
                           }
                       if(i >= s)   
                            $$ = $1;
                       }
		;
Print_STMT 	: '(' printnum EXP ')'  { printf("%d\n",$3); }
		| '(' printbool EXP ')' { if(1==$3) printf("#t\n");
      					   else  printf("#f\n");
     					 }
		;
EXP  		: bool_val | number | Num_Op | Logical_Op | If_EXP | Variable
		;
bool_val 	: true  { $$=1; } 
  		| false { $$=0; }
		; 
Num_Op  	: Plus | Minus | Multiply | Divide | Modulus | Greater | Smaller | Equal
		; 
Plus  		: Pluss ')'  { $$=$1; }
		;
Pluss  		: '(' '+' EXP EXP  { $$=$3+$4; }
  		| Pluss EXP  { $$=$1+$2; }
   		;
Minus  		: '(' '-' EXP EXP ')' { $$=$3-$4; } 
		;
Multiply 	: '(' Multiplyy ')'  { $$=$2; }
		;
Multiplyy 	: '*' EXP EXP  { $$=$2*$3; }
  		| Multiplyy EXP  { $$=$1*$2; }
		;
Divide  	: '(' '/' EXP EXP ')' { $$=$3/$4; }
		;
Modulus  	: '(' modulus EXP EXP ')'{ $$=$3%$4; }
		;
Greater  	: '(' '>' EXP EXP ')' { if($3>$4) $$=1; 
     					else  $$=0;        }
          	;
Smaller  	: '(' '<' EXP EXP ')'  { if($3<$4) $$=1;          
					 else  $$=0;}
		;
Equal  		: Equall ')'  { $$=$1; }
		;
Equall  	: '(' '=' EXP EXP { if($3==$4){
     				    	$$=$3;
      				    }
      				   else $$=0;
   				  }
  		| Equall EXP  { if($1==0) $$=0;
      				 else{
     					 if($2==$1){
      					 $$=1;
    					 }
     					 else{
       						$$=0;
     					     }
       					}
     			      }
		;
Logical_Op 	: AND_OP 
		| OR_OP 
		| NOT_OP
		;
AND_OP  	: AND_OPP ')'  { $$=$1; }
		;
AND_OPP  	: '(' And EXP EXP { if(1==$3 && 1==$4) $$=1; 
       					else   $$=0; 
     				  }
 		| AND_OPP EXP  { if(1==$1 && 1==$2) $$=1;
      				 else   $$=0;
   			       }
		;
OR_OP  		: OR_OPP ')'  { $$=$1; }
		;
OR_OPP  	: '(' Or EXP EXP { if(0==$3 && 0==$4) $$=0;
       				   else   $$=1;
     				 }
  		| OR_OPP EXP  { if(0==$1 && 0==$2) $$=0;
       				else   $$=1;
     			      }					
   		;
NOT_OP  	: '(' Not EXP ')' { if(1==$3)  $$=0;
       					else   $$=1;
    				  }
		;
If_EXP  	: '(' If EXP EXP EXP ')' { 
					   if($3==1) $$=$4;            
					   else   $$=$5;
      					 }
		;        
%%

void yyerror(const char *message) {
   printf("syntax error\n");
}

int main(void) {
    yyparse();
    return (0);
}
