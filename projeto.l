%x C_PINCA
%x C_GIRAR
%x C_ANDAR
%{

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void Pinca(int);
	void Andar(int);
	void PrintarInfor();
	void Girar(int);
	int x,y=0;
	int dir=0;//0 NORTE - 1 ESTE - 2 SUL - 3 OESTE
	int p=0; //0 fechado - 1 aberto
	int angulo=0; //angulo do braço do robo
	char buffer[100];
	int aux,aHelper,bufferHelper;
%}

VIRARD VIRAR-DIREITA
VIRARE VIRAR-ESQUERDA

%%
ANDAR	BEGIN(C_ANDAR);
<C_ANDAR>.$ {	printf("ERROR"); BEGIN(INITIAL);}
<C_ANDAR>\(([1-9]|[0-9]{2}|100)\)	{
	bufferHelper=0;
	for(aux=0;aux<sizeof(buffer);aux++)
	{
		if( (yytext[aux] != '(') && (yytext[aux]!=')') )
		{
			buffer[bufferHelper]=yytext[aux];
			bufferHelper++;
		}
	}
	aHelper=atoi(buffer);
	switch(dir)
	{
		case 0://norte
			if(y+aHelper<=100)
			{
				Andar(aHelper);
			}else{
			 	printf("Não foi possivel andar tudo porque senão eu cairia, logo vou só até o fim \n");
				y=100;
			}
			break;
		case 1://este
			if(x+aHelper <= 100)
			{
				Andar(aHelper);
			}else{
				printf("Não foi possivel andar tudo porque senão eu cairia, logo só vou até o fim \n");
				x=100;
			}
			break;
		case 2://sul
			if(y-aHelper >= 0)
			{
				Andar(aHelper);
			}else{
				printf("Não foi possivel andar tudo porque senão cairia, logo só vou até o fim\n");
				y=0;
			}
			break;
		case 3://oeste
			if(x-aHelper >=0)
			{
				Andar(aHelper);
			}else{
				printf("Não foi possivel andar tudo porque senão cairia,logo só vou ate o fim \n");
				x=0;
			}
			break;
	}
	BEGIN(INITIAL);
}
RODAR	BEGIN(C_GIRAR);
<C_GIRAR>\(-?(45|90|135|180|235|270|315|360)\) {
	bufferHelper=0;
	for(aux=0;aux<sizeof(buffer);aux++)
	{
		if((yytext[aux]!='(')&&(yytext[aux]!=')'))
		{
			buffer[bufferHelper]=yytext[aux];
			bufferHelper++;
		}
	}
	aHelper=atoi(buffer);
	int new=0;
	new=angulo + aHelper;
	if(new>360) new-=360;
	if(new<0) new +=360;
	if(new!=angulo)	Girar(new);
	else	printf("Não vou rodar o meu braço para continuar igual,cansa muito");
	BEGIN(INITIAL);
	}
<C_GIRAR>.$ {	printf("error"); BEGIN(INITIAL);}
PINCA	BEGIN(C_PINCA);

<C_PINCA>\(ABRIR\)	{

	if(p!=1)
	{
		Pinca(1);
		BEGIN(INITIAL);
	}else
	{
		printf("A pinça já esta aberta");
		BEGIN(INITIAL);
	}
	}
<C_PINCA>\(FECHAR\)	{
	
	if(p!=0)
	{
		Pinca(0);
		BEGIN(INITIAL);
	}else
	{
		printf("A pinca já esta fechada");
		BEGIN(INITIAL);
	
	}	
	}
{VIRARE} {
 	if(dir==0)
	{ 
		dir=3;
	}else
	{
		dir--;
	}
	
	}

{VIRARD}  {
	if(dir==3)
	{
		dir=0;
	}else
	{
		dir++;
	}
	
	
	}

%%
//codigo
void PrintarInfor()
{
	printf("As minhas coordenadas são ( %d , %d )\n",x,y);
	printf("O meu braço está no angulo : %d \n",angulo);
	switch(dir)
	{
		case 0:
		printf("Estou virado para o NORTE\n");
			break;
		case 1:
		printf("Estou virado para o ESTE\n");
			break;
		case 2:
		printf("Estou virado para o SUL\n");
			break;
		case 3:
		printf("Estou virado para o OESTE\n");
			break;
	}
	printf("A minha pinça está :");
	if(p==0) printf("Fechada\n");
	else if (p==1) printf("Aberta\n");
}

void Pinca(int situacao)
{	
	if(situacao == 0 || situacao==1)
	{
		p=situacao;
	}
}

void Girar(int new)
{
	angulo = new;
}

void Andar(int n)
{
	switch(dir)
	{
		case 0:
			y=y+n;
			break;
		case 1:
			x=x+n;
			break;
		case 2:
			y=y-n;
			break;
		case 3:
			x=x-n;
			break;
	}
}
void main()
{	
	//CODIGO PARA INPUT DO FICHEIRO A LER
	FILE *fp;
	char filename[50];
	printf("Enter the fileName for the input of the FLEX: \n");
	scanf("%s",filename);
	fp=fopen(filename,"r");
	yyin=fp;
	//INPUT DO FICHEIRO A LER
	

	yylex();
	PrintarInfor();
}
