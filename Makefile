SRC = $(shell find src -type f -name '*.co')
LIB = $(SRC:src/%.co=lib/%.js)

TESTSRC = $(shell find test/src -type f -name '*.co')
TESTLIB = $(TESTSRC:test/src/%.co=test/lib/tests/%.js)

EXAMPLESSRC = $(shell find examples/src -type f -name '*.co')
EXAMPLESLIB = $(EXAMPLESSRC:examples/src/%.co=examples/lib/%.js)

PEGSRC = $(shell find src -type f -name '*.pegjs')
PEGLIB = $(PEGSRC:src/%.pegjs=lib/%.js)

COCO = coco -bcp
PEGJS = pegjs --cache

all: lib test pegjs examples

lib: $(LIB)

examples: lib $(EXAMPLESLIB)

test: lib $(TESTLIB)

pegjs: $(PEGLIB)

watch:
	watch -n  0.3 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

lib/%.js: src/%.pegjs
	@mkdir -p $(@D)
	$(PEGJS) -e 'var __parser' $< $@
	echo 'define(__parser);' >> $@

test/lib/tests/%.js: test/src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

examples/lib/%.js: examples/src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

clean:
	rm -rf lib/
	rm -rf $(TESTLIB) $(EXAMPLESLIB)
