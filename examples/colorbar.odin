package colorbar

import "core:fmt"
import "core:math"

import plt "../src"

main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	// Prepare data
	ncols := 500
	nrows := 300

	z := make([dynamic]f32, ncols * nrows)
	defer delete(z)
	for j in 0 ..< nrows {
		for i in 0 ..< ncols {
			x := f32(i - ncols / 2)
			y := f32(j - nrows / 2)
			z[ncols * j + i] = math.sin_f32(math.hypot_f32(x, y))
		}
	}

	colors := 1

	plt.title("My matrix")
	mat: plt.PyObject
	plt.imshow(z[:], uint(nrows), uint(ncols), uint(colors), nil, &mat)
	if &mat == nil {
		fmt.panicf("Failed to call imshow_floatptr()")
	}
	defer plt.Py_DecRef(mat)
	plt.colorbar(mat)

	// Show plots
	plt.show()
	plt.close()
}
