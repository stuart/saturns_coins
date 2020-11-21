TARGETS = tlk hak erf module readme
OBJECTS = build/saturns_coins.tlk build/saturns_coins.hak build/saturns_coins.erf build/saturns_coins.mod build/README.html build/README.pdf
VERSION = $(shell grep version nasher.cfg | awk '{print $$3}' | tr -d \")

.PHONY : all clean install

all: ${TARGETS}

release: ${TARGETS}
	zip build/saturns_coins_${VERSION}.zip ${OBJECTS}

module:
	nasher pack --yes module

hak:
	nasher pack --yes hak

erf:
	nasher pack --yes erf

tlk:
	nasher pack --yes tlk

readme: README.md
	pandoc -f markdown -r html README.md -o build/README.html

clean:
	rm -f build/*
	rm -rf .nasher/cache/*
	rm -rf .nasher/tmp/*

install:
	nasher install
