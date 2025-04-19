package subplot2grid

import plt "../src"
import "core:math"

main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	// Prepare data
	n := 500

	x: [dynamic]f64
	defer delete(x)
	u: [dynamic]f64
	defer delete(u)
	v: [dynamic]f64
	defer delete(v)
	w: [dynamic]f64
	defer delete(w)

	for i in 0 ..< n {
		append(&x, f64(i))
		append(&u, math.sin_f64(2.0 * math.PI * f64(i) / 500.0))
		append(&v, 100.0 / f64(i))
		append(&w, math.sin_f64(2.0 * math.PI * f64(i) / 1000.0))
	}

	// Set the "super title"
	plt.suptitle("My plot")

	nrows: uint = 3
	ncols: uint = 3
	row: uint = 2
	col: uint = 2

	plt.subplot2grid(nrows, ncols, row, col)
	plt.plot(x[:], w[:], "g-")

	spanr: uint = 1
	spanc: uint = 2
	col = 0
	plt.subplot2grid(nrows, ncols, row, col, spanr, spanc)
	plt.plot(x[:], v[:], "r-")

	spanr = 2
	spanc = 3
	row = 0
	col = 0
	plt.subplot2grid(nrows, ncols, row, col, spanr, spanc)
	plt.plot(x[:], u[:], "b-")
	// Add some text to the plot
	plt.text(100., -0.5, "Hello!")

	// Show plots
	plt.show()
}
