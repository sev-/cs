CC=gcc
CFLAGS=-g

OFILES= base.o comp.o cs.o curve.o edit5.o header.o incide.o interp.o load.o\
	parse.o picture.o search.o servi.o toks.o 

.SUFFIXES: .pas

cs: $(OFILES)
	$(CC) -o cs $(CFLAGS) $(OFILES) -lp2c -L/user/sev/lib

.pas.c:
	p2c $<


