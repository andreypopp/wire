SRC = $(shell find src -type f -name '*.co')
LIB = $(SRC:src/%.co=lib/%.js)

TESTSRC = $(shell find test/src -type f -name '*.co')
TESTLIB = $(TESTSRC:test/src/%.co=test/lib/tests/%.js)

COCO = coco -bcp

all: lib test

lib: $(LIB)

test: $(TESTLIB)

watch:
	watch -n  0.3 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

test/lib/tests/%.js: test/src/%.co
	@mkdir -p $(@D)
	$(COCO) $< > $@

clean:
	rm -rf lib/
	rm -rf $(TESTLIB)
