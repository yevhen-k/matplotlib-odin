examples: all bar animation basic colorbar fill_between fill imshow lines3d minimal quiver quiver3d spy subplot subplot2grid surface xkcd

.PHONY: all build_dirs python object shared build clear examples $(examples)

CUR_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
LIB_OUT := build/lib
BIN_OUT := build/bin

LINK := `python${PY_VER}-config --ldflags --embed`
INCLUDE_PY := `python${PY_VER}-config --includes`
INCLUDE_NUMPY := venv${PY_VER}/lib/python${PY_VER}/site-packages/numpy/_core/include/

build_dirs:
	mkdir -p $(LIB_OUT)
	mkdir -p $(BIN_OUT)

python:
	python${PY_VER} -m venv venv${PY_VER} && \
	source venv${PY_VER}/bin/activate && \
	pip install -r requirements/requirements${PY_VER}.txt

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

build_test: shared
	odin build src/ -out=$(BIN_OUT)/matplotlib && \
	./$(BIN_OUT)/matplotlib \
	-extra-linker-flags="$(LINK)"

clear:
	rm -rf $(BIN_OUT)/*
	rm -rf $(LIB_OUT)/*

all: build_dirs build

bar:
	odin build examples/bar.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/bar

animation:
	odin build examples/animation.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/animation

basic:
	odin build examples/basic.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/basic

colorbar:
	odin build examples/colorbar.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/colorbar

contour:
	odin build examples/contour.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/contour

fill_between:
	odin build examples/fill_between.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/fill_between

fill:
	odin build examples/fill.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/fill

imshow:
	odin build examples/imshow.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/imshow

lines3d:
	odin build examples/lines3d.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/lines3d

minimal:
	odin build examples/minimal.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/minimal

quiver:
	odin build examples/quiver.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/quiver

quiver3d:
	odin build examples/quiver3d.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/quiver3d

spy:
	odin build examples/spy.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/spy

subplot:
	odin build examples/subplot.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/subplot

subplot2grid:
	odin build examples/subplot2grid.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/subplot2grid

surface:
	odin build examples/surface.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/surface

xkcd:
	odin build examples/xkcd.odin -file -define:PY_VER=${PY_VER} -out=$(BIN_OUT)/xkcd
