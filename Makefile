TARGETS = tlk hak erf module readme
OBJECTS = build/saturns_coins.tlk build/saturns_coins.hak build/saturns_coins.erf build/saturns_coins.mod build/README.html build/README.pdf
VERSION = $(shell grep version nasher.cfg | awk '{print $$3}' | tr -d \")
INSTALL_DIR = ~/Documents/Neverwinter\ Nights

.PHONY : all clean install

all: ${TARGETS}

release: ${TARGETS}
	zip build/saturns_coins_${VERSION}.zip ${OBJECTS}

module:
	nasher pack module

hak:
	nasher pack hak

erf:
	nasher pack erf

tlk:
	nasher pack tlk

readme: README.md
	pandoc -f markdown -r html README.md -o build/README.html

clean:
	rm -f build/*
	rm -rf .nasher/cache/*
	rm -rf .nasher/tmp/*

install:
	cp build/*.mod ${INSTALL_DIR}/mod
	cp build/*.erf ${INSTALL_DIR}/erf
	cp build/*.hak ${INSTALL_DIR}/hak
	cp build/*.tlk ${INSTALL_DIR}/tlk

setup:
	nwn_key_unpack ~/.steam/steam/steamapps/common/Neverwinter\ Nights/data/nwn_base.key ./bif
