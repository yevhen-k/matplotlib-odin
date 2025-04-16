package contour

import "core:fmt"
import "core:math"

import plt "../src"


slice_example :: proc() {
	xs := make([dynamic]f32)
	ys := make([dynamic]f32)
	defer delete(xs)
	defer delete(ys)
	for i := -5.0; i <= 5.0; i += 0.25 {
		append(&xs, f32(i))
		append(&ys, f32(i))
	}

	size := len(xs)

	x2d := make([][]f32, size)
	for &row in x2d {
		row = make([]f32, size)
	}
	defer {
		for row in x2d do delete(row)
		delete(x2d)
	}

	y2d := make([][]f32, size)
	for &row in y2d {
		row = make([]f32, size)
	}
	defer {
		for row in y2d do delete(row)
		delete(y2d)
	}

	z2d := make([][]f32, size)
	for &row in z2d {
		row = make([]f32, size)
	}
	defer {
		for row in z2d do delete(row)
		delete(z2d)
	}

	// iterate rows
	for x, i in xs {
		// iterate columns
		for y, j in ys {
			x2d[i][j] = x
			y2d[i][j] = y
			z2d[i][j] = math.hypot_f32(y, x)
		}
	}

	plt.contour(x2d, y2d, z2d)
	plt.show()
}


dyn_example :: proc() {
	xs := make([dynamic]f32)
	ys := make([dynamic]f32)
	defer delete(xs)
	defer delete(ys)
	for i := -5.0; i <= 5.0; i += 0.25 {
		append(&xs, f32(i))
		append(&ys, f32(i))
	}

	size := len(xs)

	x2d := make([dynamic][dynamic]f32, size)
	for &row in x2d {
		row = make([dynamic]f32, size)
	}
	defer {
		for row in x2d do delete(row)
		delete(x2d)
	}

	y2d := make([dynamic][dynamic]f32, size)
	for &row in y2d {
		row = make([dynamic]f32, size)
	}
	defer {
		for row in y2d do delete(row)
		delete(y2d)
	}

	z2d := make([dynamic][dynamic]f32, size)
	for &row in z2d {
		row = make([dynamic]f32, size)
	}
	defer {
		for row in z2d do delete(row)
		delete(z2d)
	}

	// iterate rows
	for x, i in xs {
		// iterate columns
		for y, j in ys {
			x2d[i][j] = x
			y2d[i][j] = y
			z2d[i][j] = math.hypot_f32(y, x)
		}
	}

	plt.contour(x2d, y2d, z2d)
	plt.show()
}

raw_example :: proc() {
	xs := make([dynamic]f32)
	ys := make([dynamic]f32)
	defer delete(xs)
	defer delete(ys)
	for i := -5.0; i <= 5.0; i += 0.25 {
		append(&xs, f32(i))
		append(&ys, f32(i))
	}

	size := len(xs)

	rows := size
	cols := size

	x2d := make([]f32, rows * cols)
	defer delete(x2d)

	y2d := make([]f32, rows * cols)
	defer delete(y2d)

	z2d := make([]f32, rows * cols)
	defer delete(z2d)

	// iterate rows
	for x, i in xs {
		// iterate columns
		for y, j in ys {
			x2d[i * int(cols) + j] = x
			y2d[i * int(cols) + j] = y
			z2d[i * int(cols) + j] = math.hypot_f32(y, x)
		}
	}

	plt.contour(x2d, y2d, z2d, uint(rows), uint(cols))
	plt.show()
}

main :: proc() {
	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	example :: 0

	switch example {
	case 0:
		slice_example()
	case 1:
		dyn_example()
	case 2:
		raw_example()
	}

}
