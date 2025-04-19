package subplot

import plt "../src"
import "core:math"


main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	// Prepare data
	n := 500
	x: [dynamic]f64
	defer delete(x)
	y: [dynamic]f64
	defer delete(y)
	z: [dynamic]f64
	defer delete(z)

	for i in 0 ..< n {
		append(&x, f64(i))
		append(&y, math.sin_f64(2.0 * math.PI * f64(i) / 360.0))
		append(&z, 100.0 / f64(i))
	}

	// Set the "super title"
	plt.suptitle("My plot")
	plt.subplot(1, 2, 1)
	plt.plot(x[:], y[:], "r-")
	plt.subplot(1, 2, 2)
	plt.plot(x[:], z[:], "k-")
	// Add some text to the plot
	plt.text(100, 90, "Hello!")

	// Show plots
	plt.show()

}
