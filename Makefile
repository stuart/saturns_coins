TARGETS = tlk hak erf module readme
OBJECTS = build/saturns_coins.tlk build/saturns_coins.hak build/saturns_coins.erf build/saturns_coins.mod build/README.html build/README.pdf
VERSION = $(shell grep version nasher.cfg | awk '{print $$3}' | tr -d \")

.PHONY : all clean

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

setup:
	nwn_key_unpack ~/.steam/steam/steamapps/common/Neverwinter\ Nights/data/nwn_base.key ./bif
