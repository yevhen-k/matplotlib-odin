package fill

import plt "../src"
import "core:math"


main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	// https://matplotlib.org/gallery/misc/fill_spiral.html

	// Prepare data.
	theta: [dynamic]f64
	defer delete(theta)
	for d := 0.0; d < 8.0 * math.PI; d += 0.1 {
		append(&theta, d)
	}

	a :: 1
	b :: 0.2

	for dt := 0.0; dt < 2.0 * math.PI; dt += math.PI / 2.0 {
		x: [dynamic]f64
		y: [dynamic]f64
		x2: [dynamic]f64
		y2: [dynamic]f64
		defer {
			delete(x)
			delete(y)
			delete(x2)
			delete(y2)
		}
		for th in theta {
			append(&x, (a * math.cos_f64(th + dt) * math.exp_f64(b * th)))
			append(&y, (a * math.sin_f64(th + dt) * math.exp_f64(b * th)))

			append(&x2, (a * math.cos_f64(th + dt + math.PI / 4.0) * math.exp_f64(b * th)))
			append(&y2, (a * math.sin_f64(th + dt + math.PI / 4.0) * math.exp_f64(b * th)))
		}

		assert(len(x2) == len(y2))
		for i := len(x2) - 1; i >= 0; i = i - 1 {
			append(&x, x2[i])
			append(&y, y2[i])
		}

		plt.fill(x[:], y[:], nil)
	}
	plt.show()
}
