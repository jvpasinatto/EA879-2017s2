%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>

void yyerror(char *c);
int yylex(void);

%}
%union {
  char    strval[50];
  int     ival;
  float   fval;
}
%token <strval> STRING STRINGUE
%token <ival> VAR IGUAL EOL ASPA MULT DIV
%token <fval> BRILHO
%left SOMA MULT 

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    | STRING IGUAL STRING {
        printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }

    | STRING IGUAL STRING MULT BRILHO {
        imagem I = abrir_imagem($3);
        printf("multiplicando brilho\n");
        brilho_mult($5, &I);
        salvar_imagem($1, &I);
                                      }

    | STRING IGUAL STRING DIV BRILHO {
        imagem I = abrir_imagem($3);
        brilho_div($5, &I);
        salvar_imagem($1, &I);
                                     }

    | STRINGUE {
        imagem I = abrir_imagem($1);
        max_valor(&I);    
    
               }
    ;


%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
