SRC = $(wildcard src/*.co)
TESTSRC = $(wildcard testsrc/*.co)
LIB = $(patsubst src/%.co, lib/%.js, $(SRC))
TESTLIB = $(patsubst testsrc/%.co, test/%.js, $(TESTSRC))

all: lib test

lib: $(LIB)

test: $(TESTLIB)

lib/%.js: src/%.co
	@mkdir -p $(@D)
	coco -bpc $< > $@

test/%.js: testsrc/%.co
	@mkdir -p $(@D)
	coco -bpc $< > $@

clean:
	rm -rf lib/
	rm $(TESTLIB)
