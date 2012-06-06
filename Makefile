SRC = $(wildcard src/*.co)
LIB = $(SRC:src/%.co=lib/%.js)

TESTSRC = $(wildcard testsrc/*.co)
TESTLIB = $(TESTSRC:testsrc/%.co=test/%.js)

COCO = coco -bcp

all: lib test

lib: $(LIB)

test: $(TESTLIB)

watch:
	watch -n  0.3 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

test/%.js: testsrc/%.co
	$(COCO) $< > $@

clean:
	rm -rf lib/
	rm $(TESTLIB)
