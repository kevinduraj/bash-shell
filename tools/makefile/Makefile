# the compiler to use.
CC=c++
EXE=fast
# options  pass to the compiler.
CFLAGS=-c -Wall
all: program

program: main.o hello.o name.o
	$(CC) main.o hello.o name.o -o $(EXE) 

main.o: main.cpp
	$(CC) $(CFLAGS) main.cpp

hello.o: hello.cpp
	$(CC) $(CFLAGS) hello.cpp

name.o: name.cpp
	$(CC) $(CFLAGS) name.cpp

clean:
	rm -rf *o $(EXE)

