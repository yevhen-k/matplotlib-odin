package spy

import plt "../src"
import "core:fmt"
import "core:math"
import "core:math/rand"

slice_example :: proc(kwargs: plt.Kwargs) {
	rows := 20
	cols := 20

	x2d := make([][]f32, rows)
	for &row in x2d {
		row = make([]f32, cols)
	}
	defer {
		for row in x2d do delete(row)
		delete(x2d)
	}

	// iterate rows
	for i in 0 ..< rows {
		// iterate columns
		for j in 0 ..< cols {
			if i == 5 || j == 12 {
				x2d[i][j] = 0
			} else {
				x2d[i][j] = rand.float32()
			}
		}
	}

	plt.spy(x2d, kwargs)
	plt.show()
}

dyn_example :: proc(kwargs: plt.Kwargs) {
	rows := 20
	cols := 20

	x2d := make([dynamic][dynamic]f32, cols)
	for &row in x2d {
		row = make([dynamic]f32, rows)
	}
	defer {
		for row in x2d do delete(row)
		delete(x2d)
	}

	// iterate rows
	for i in 0 ..< rows {
		// iterate columns
		for j in 0 ..< cols {
			if i == 5 || j == 12 {
				x2d[i][j] = 0
			} else {
				x2d[i][j] = rand.float32()
			}
		}
	}

	plt.spy(x2d, kwargs)
	plt.show()
}

raw_example :: proc(kwargs: plt.Kwargs) {
	rows := 20
	cols := 20

	x2d := make([]f32, rows * cols)
	defer delete(x2d)

	// iterate rows
	for i in 0 ..< rows {
		// iterate columns
		for j in 0 ..< cols {
			if i == 5 || j == 12 {
				x2d[i * int(cols) + j] = 0
			} else {
				x2d[i * int(cols) + j] = rand.float32()
			}
		}
	}

	plt.spy(x2d, uint(rows), uint(cols), kwargs)
	plt.show()
}

main :: proc() {

	// https://matplotlib.org/stable/gallery/images_contours_and_fields/spy_demos.html

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	seed :: 1337
	rand.reset(seed)

	example :: 2

	kwargs := plt.kwags_init()
	defer plt.kwags_delete(&kwargs)
	plt.kwargs_append(&kwargs, cstring("marker"), cstring("o"))
	plt.kwargs_append(&kwargs, cstring("precision"), f64(0.1))
	plt.kwargs_append(&kwargs, cstring("markersize"), 5)

	switch example {
	case 0:
		slice_example(kwargs)
	case 1:
		dyn_example(kwargs)
	case 2:
		raw_example(kwargs)
	}
}
