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

	z := make([]f64, n)
	defer delete(z)

	for i in 0 ..< n {
		x[i] = f32(i * i)
		y[i] = math.sin_f32(2.0 * math.PI * f32(i) / 360.0)
		z[i] = math.log10(f64(i + 1))
	}

	keywords := plt.kwags_init()
	defer plt.kwags_delete(&keywords)
	plt.kwargs_append(&keywords, cstring("alpha"), f64(0.4))
	plt.kwargs_append(&keywords, cstring("hatch"), cstring("\\/..."))
	plt.kwargs_append(&keywords, cstring("color"), cstring("coral"))

	plt.fill_between(x[:], y[:], z[:], keywords)
	plt.show()
}
