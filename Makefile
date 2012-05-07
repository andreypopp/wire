SRC = $(wildcard src/*.co)
PARSERSRC = $(wildcard src/*.pegjs)
TESTSRC = $(wildcard testsrc/*.co)
LIB = $(patsubst src/%.co, lib/%.js, $(SRC))
PARSER = $(patsubst src/%.pegjs, lib/%.js, $(PARSERSRC))
TESTLIB = $(patsubst testsrc/%.co, test/%.js, $(TESTSRC))

PEGJS = ./pegjs/bin/pegjs --wrapper-template "(function(root, factory) {	\
	if (typeof exports === 'object') {                                     	\
		module.exports = factory();																						\
	} else if (typeof define === 'function' && define.amd) {                \
		define(function() {                                                   \
			root.wire = root.wire || {};                                        \
			return (root.wire.templateparser = factory());                      \
		});                                                                   \
	} else {                                                                \
		root.wire = root.wire || {};                                          \
		root.wire.templateparser = factory()                                  \
	}                                                                       \
})(this, function() { return %s; })"


all: lib test parser

lib: $(LIB)

parser: $(PARSER)

test: $(TESTLIB)

watch:
	watch -n  0.5 $(MAKE) all

lib/%.js: src/%.co
	@mkdir -p $(@D)
	coco -bpc $< > $@

lib/%.js: src/%.pegjs
	@mkdir -p $(@D)
	$(PEGJS) --track-line-and-column $< $@

test/%.js: testsrc/%.co
	coco -bpc $< > $@

clean:
	rm -rf lib/
	rm $(TESTLIB)
