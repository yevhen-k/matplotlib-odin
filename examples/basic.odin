package basic

import "core:fmt"
import "core:math"

import plt "../src"

main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	// Prepare data.
	n := 5000
	x := make([dynamic]f64, n)
	y := make([dynamic]f64, n)
	z := make([dynamic]f64, n)
	w := make([dynamic]f64, n)

	for i in 0 ..< n {
		x[i] = f64(i * i)
		y[i] = math.sin_f64(2.0 * math.PI * f64(i) / 360.0)
		z[i] = math.log10(f64(i + 1))
		w[i] = 2
	}

	// Set the size of output image = 1200x780 pixels
	plt.figure_size(1200, 780)

	// Plot line from given x and y data. Color is selected automatically.
	plt.plot(x[:], y[:])

	// Plot a red dashed line from given x and y data.
	plt.plot(x[:], w[:], "r--")

	// Plot a line whose name will show up as "log(x)" in the legend.
	plt.named_plot("log(x)", x[:], z[:])

	// Set x-axis to interval [0,1000000]
	plt.xlim(0, 1000 * 1000)

	// Add graph title
	plt.title("Sample figure")

	// Enable legend.
	plt.legend()

	// save figure
	filename := "./basic.png"
	fmt.printfln("Saving result to %s", filename)
	plt.save(filename)

}
