SRC = $(shell find src -type f -name '*.co')
LIB = $(SRC:src/%.co=lib/%.js)

TESTSRC = $(shell find test/src -type f -name '*.co')
TESTLIB = $(TESTSRC:test/src/%.co=test/lib/tests/%.js)

PEGSRC = $(shell find src -type f -name '*.pegjs')
PEGLIB = $(PEGSRC:src/%.pegjs=lib/%.js)

COCO = coco -bcp
PEGJS = pegjs

all: lib test pegjs

lib: $(LIB)

test: $(TESTLIB)

pegjs: $(PEGLIB)

watch:
	watch -n  0.3 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

lib/%.js: src/%.pegjs
	@mkdir -p $(@D)
	$(PEGJS) $< $@

test/lib/tests/%.js: test/src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

clean:
	rm -rf lib/
	rm -rf $(TESTLIB)
