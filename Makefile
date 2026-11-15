# Baut index.html aus dem Ada-Programm.
GPRBUILD ?= gprbuild

.PHONY: all clean

all: index.html

index.html: site.gpr src/*.ads src/*.adb
	$(GPRBUILD) -p -P site.gpr
	./bin/site -o index.html

clean:
	-gprclean -P site.gpr
	rm -rf obj bin
	rm -f index.html
