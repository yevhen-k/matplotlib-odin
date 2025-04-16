.PHONY: all build_dirs python310 object shared build clear examples bar animation basic \
	colorbar contour fill_between

CUR_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
LIB_OUT := build/lib
BIN_OUT := build/bin

LINK := `python3.10-config --ldflags --embed`
INCLUDE_PY := `python3.10-config --includes`
INCLUDE_NUMPY := venv310/lib/python3.10/site-packages/numpy/_core/include/

build_dirs:
	mkdir -p $(LIB_OUT)
	mkdir -p $(BIN_OUT)

python310:
	python3.10 -m venv venv310 && \
	source venv310/bin/activate && \
	pip install -r requirements/310.txt

object:
	gcc -c -Wall -Werror -fpic \
	$(INCLUDE_PY) \
	-I$(CUR_DIR)/$(INCLUDE_NUMPY) \
	src/lib/matplotlib.c -o $(LIB_OUT)/matplotlib.o

shared: object
	gcc -shared -o \
	$(LIB_OUT)/libmatplotlib.so \
	$(LIB_OUT)/matplotlib.o \
	$(LINK)

build: shared
	odin build src/ -out=$(BIN_OUT)/matplotlib && \
	./$(BIN_OUT)/matplotlib \
	-extra-linker-flags="$(LINK)"

clear:
	rm -rf $(BIN_OUT)/*
	rm -rf $(LIB_OUT)/*

all: build_dirs build

examples: all bar animation basic colorbar

bar:
	odin build examples/bar.odin -file -out=$(BIN_OUT)/bar

animation:
	odin build examples/animation.odin -file -out=$(BIN_OUT)/animation

basic:
	odin build examples/basic.odin -file -out=$(BIN_OUT)/basic

colorbar:
	odin build examples/colorbar.odin -file -out=$(BIN_OUT)/colorbar

contour:
	odin build examples/contour.odin -file -out=$(BIN_OUT)/contour

fill_between:
	odin build examples/fill_between.odin -file -out=$(BIN_OUT)/fill_between
