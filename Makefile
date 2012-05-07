SRC = $(wildcard src/*.co)
TESTSRC = $(wildcard testsrc/*.co)
LIB = $(patsubst src/%.co, lib/%.js, $(SRC))
TESTLIB = $(patsubst testsrc/%.co, test/%.js, $(TESTSRC))

all: lib test

lib: $(LIB)

test: $(TESTLIB)

watch:
	watch -n  0.5 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	coco -bpc $< > $@

test/%.js: testsrc/%.co
	coco -bpc $< > $@

clean:
	rm -rf lib/
	rm $(TESTLIB)
