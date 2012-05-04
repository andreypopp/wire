SRC = $(wildcard src/*.co)
LIB = $(patsubst src/%.co, lib/%.js, $(SRC))

all: $(LIB)

lib/%.js: src/%.co
	@mkdir -p $(@D)
	coco -bpc $< > $@

clean:
	rm -rf lib/
