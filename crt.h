#define gotoxy(x,y) printf("\033[%d;%dH",y,x)
#define assign(f,s) f=fopen(s,"r")
#define assign1(f,s) f=fopen(s,"w")
#define clrscr()    printf ("\033[H\033[J")
