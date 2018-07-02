SRC=$(wildcard *.ml)

.PHONY: clean

default : main.native

clean:
	rm -f Report/*.aux
	rm -f Report/*.bbl
	rm -f Report/*.bcf
	rm -f Report/*.blg
	rm -f Report/*.log
	rm -f Report/*.out
	rm -f Report/*.xml
	rm -f Report/*.synctex.gz


