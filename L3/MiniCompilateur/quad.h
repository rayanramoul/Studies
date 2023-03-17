typedef struct qdr{
char oper[100]; 
char op1[100];   
char op2[100];   
char res[100];  
}qdr;

qdr quad[1000];

extern int qc;


void quadr(char opr[],char op1[],char op2[],char res[])
{


	if(strcmp(opr,"!=")==0)
	{strcpy(quad[qc].oper,"BNE");}
	if(strcmp(opr,"=")==0)
	{strcpy(quad[qc].oper,"BE");}
	if(strcmp(opr,"<")==0)
	{strcpy(quad[qc].oper,"BL");}
	if(strcmp(opr,">")==0)
	{strcpy(quad[qc].oper,"BG");}	
	if(strcmp(opr,"<=")==0)
	{strcpy(quad[qc].oper,"BLE");}	
	if(strcmp(opr,">=")==0)
	{strcpy(quad[qc].oper,"BGE");}
	else
	{strcpy(quad[qc].oper,opr);}


	strcpy(quad[qc].op1,op1);
	strcpy(quad[qc].op2,op2);
	strcpy(quad[qc].res,res);
	qc++;
}

void ajour_quad(int num_quad, int colon_quad, char val [])
{
	if (colon_quad==0)    
		strcpy(quad[num_quad].oper ,  val);
	else if (colon_quad==1)   
		strcpy(quad[num_quad].op1  ,  val);
	else if (colon_quad==2)    
		strcpy(quad[num_quad].op2  ,   val);
	else if (colon_quad==3)    
		strcpy(quad[num_quad].res  ,   val);
}


void afccer_qdr()
{
	printf("/*********************Les Quadruplets***********************/\n");
	int i;
	for(i=0;i<qc;i++)
	{
	printf("\n %d - (%s,%s,%s,%s )",i,quad[i].oper,quad[i].op1,quad[i].op2,quad[i].res); 
	printf("\n---------------------------------------------------\n");
	}
}

