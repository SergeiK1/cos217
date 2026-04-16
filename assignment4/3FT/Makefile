#--------------------------------------------------------------------
# Makefile for Assignment 4, Part 3 sample implementation
# Invoke with the command:
# 	make -f Makefile.sampleft
# Author: Sergei Kudriavtcev, Joshua (Kimyung) Song
#--------------------------------------------------------------------

CC=gcc217


TARGETS = ft sampleft

all: $(TARGETS)

clean:
	rm -f sampleft

clobber: clean
	rm -f ft_client.o *~

sampleft: sampleft.o ft_client.o
	$(CC) sampleft.o ft_client.o -o sampleft

ft_client.o: ft_client.c ft.h a4def.h
	$(CC) -c ft_client.c

ft: ft.o nodeFT.o path.o dynarray.o ft_client.o
	$(CC) ft.o nodeFT.o path.o dynarray.o ft_client.o -o ft

ft.o: ft.c ft.h nodeFT.h a4def.h path.h
	$(CC) -c ft.c

nodeFT.o: nodeFT.c nodeFT.h
	$(CC) -c nodeFT.c

dynarray.o: dynarray.c dynarray.h
	$(CC) -c dynarray.c

path.o: path.c dynarray.h path.h a4def.h
	$(CC) -c path.c

