package fill_between

import plt "../src"
import "core:math"

main :: proc() {
	// Prepare data.
	n := 5000

	x := make([]f32, n)
	defer delete(x)

	y := make([]f32, n)
	defer delete(y)

	z := make([]f32, n)
	defer delete(z)

	w := make([]f32, n)
	defer delete(w)

	for i in 0 ..< n {
		x[i] = f32(i * i)
		y[i] = math.sin_f32(2.0 * math.PI * f32(i) / 360.0)
		z[i] = math.log10(f32(i + 1))
	}

	// Prepare keywords to pass to PolyCollection. See
	// https://matplotlib.org/api/_as_gen/matplotlib.axes.Axes.fill_between.html
	keywords: map[string]string
	defer delete(keywords)
	// TODO: support myltiple types for valyes on keywords (ints, strings, bools)
	// keywords["alpha"] = 0.4
	keywords["hatch"] = "\\/..."
	// keywords["color"] = "coral"

	plt.fill_between(x[:], y[:], z[:], keywords)
	plt.show()
}
