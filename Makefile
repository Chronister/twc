COMPILE_FLAGS= -std=c99 -Wall -g
LINK_FLAGS=
LIBS= -lcurl
.PHONY: all clean dir

all: dir build/linux64/libtwc.a

build/linux64/libtwc.a: build/twitter.o
	ar rcs $@ $?

build/twitter.o: twc_codegen code/twitter.c code/twitter.h code/byte_utils.c api.json
	./twc_codegen code/twitter.c api.json
	cc $(COMPILE_FLAGS) -c code/twitter.c -o $@

twc_codegen: build/codegen.o build/json.o
	cc $(LINK_FLAGS) $^ $(LIBS) -o $@

build/codegen.o: code/codegen.c code/tokenizer.c code/twitter.h code/json.h
	cc $(COMPILE_FLAGS) -c code/codegen.c -o $@
build/json.o: code/json.c code/json.h
	cc $(COMPILE_FLAGS) -c code/json.c -o $@

dir:
	mkdir -p build/linux64

clean: 
	rm -r build
	rm -f code/twitter_api.c
	rm -f code/twitter_api.h
