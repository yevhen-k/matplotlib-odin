package animation

import plt "../src"
import "core:fmt"
import "core:math"

main :: proc() {
	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	n := 1000
	x := make([]f64, n)
	y := make([]f64, n)
	z := make([]f64, n)
	defer {
		delete(x)
		delete(y)
		delete(z)
	}

	for i in 0 ..< n {
		x[i] = f64(i * i)
		y[i] = math.sin_f64(2.0 * math.PI * f64(i) / 360.0)
		z[i] = math.log_f64(f64(i + 1), base = 10)

		if i % 10 == 0 && (len(x[:i]) > 0) {
			// Clear previous plot
			plt.clf()
			// Plot line from given x and y data. Color is selected automatically.
			plt.plot(x[:i], y[:i], "--r")
			// Plot a line whose name will show up as "log(x)" in the legend.
			plt.named_plot("log(x)", x[:i], z[:i])
			// Set x-axis to interval [0,1000000]
			plt.xlim(0, n * n)
			// Add graph title
			plt.title("Sample figure")
			// Enable legend.
			plt.legend()
			// Display plot continuously
			plt.pause(0.01)
		}
	}
}
