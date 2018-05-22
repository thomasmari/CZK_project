SRC=$(wildcard *.ml)

.PHONY: clean

default : main.native

clean:
	ocamlbuild -clean
	rm -f _buid/*
	rm -f _build
	rm -f *.sm
	rm -f *.cmi
	rm -f *.cmo
	rm -f *.native
	rm -f *.pyc
	rm -f *.gz
	rm -f *.aux
	rm -f *.log
	rm -f *.out

