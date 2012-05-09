SRC = $(wildcard src/*.co)
TESTSRC = $(wildcard testsrc/*.co)
GRAMMAR = $(wildcard src/*.pegjs)
LIB = $(patsubst src/%.co, lib/%.js, $(SRC))
TESTLIB = $(patsubst testsrc/%.co, test/%.js, $(TESTSRC))
PARSER = $(patsubst src/%.pegjs, lib/%.js, $(GRAMMAR))

COCO = coco -bcp
PEGJS = ./pegjs/bin/pegjs

all: lib test parser

lib: $(LIB)

test: $(TESTLIB)

parser: $(PARSER)

watch:
	watch -n  0.3 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

lib/%.js: src/%.pegjs
	@mkdir -p $(@D)
	$(PEGJS) $< $@

test/%.js: testsrc/%.co
	$(COCO) $< > $@

clean:
	rm -rf lib/
	rm $(TESTLIB)
