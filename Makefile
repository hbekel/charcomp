CC?=gcc
CFLAGS=-Wall -O2

PREFIX=/usr/local
DESTDIR=

.PHONY: all install uninstall clean

all: charcomp

charcomp: charcomp.c
	$(CC) $(CFLAGS) -o $@ $<

test-mixed: charcomp 
	(cd test && ../charcomp -m mixed.64c test.rom)
	xlink load -a 0x3000 test/test.rom && \
	xlink poke 0xd018,0x1c && \
	xlink load test/screen.prg || true
	rm -vf test/test.rom

test-upper: charcomp 
	(cd test && ../charcomp upper.64c test.rom)
	xlink load -a 0x3000 test/test.rom && \
	xlink poke 0xd018,0x1c && \
	xlink load test/screen.prg || true
	rm -vf test/test.rom

test-full: charcomp 
	(cd test && ../charcomp full.64c test.rom)
	xlink load -a 0x3000 test/test.rom && \
	xlink poke 0xd018,0x1c && \
	xlink load test/screen.prg || true
	rm -vf test/test.rom

install: charcomp
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m755 charcomp $(DESTDIR)$(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/charcomp

clean:
	rm -vf charcomp{,.exe}
	rm -vf test/*.pbm
	rm -vf test/*.rom
