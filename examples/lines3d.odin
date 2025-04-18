package lines3d

import plt "../src"
import "core:math"


// https://matplotlib.org/stable/gallery/mplot3d/lines3d.html
main :: proc() {
	x: [dynamic]f64
	defer delete(x)

	y: [dynamic]f64
	defer delete(y)

	z: [dynamic]f64
	defer delete(z)

	theta: f64
	r: f64
	z_inc := 4.0 / 99.0
	theta_inc := (8.0 * math.PI) / 99.0

	for i := 0; i < 100; i += 1 {
		theta = -4.0 * math.PI + theta_inc * f64(i)
		append(&z, f64(-2.0 + z_inc * f64(i)))
		r = z[i] * z[i] + 1
		append(&x, f64(r * math.sin_f64(theta)))
		append(&y, f64(r * math.cos_f64(theta)))
	}

	keywords: plt.Kwargs = plt.kwags_init()
	defer plt.kwags_delete(&keywords)
	plt.kwargs_append(&keywords, cstring("label"), cstring("parametric curve"))

	plt.plot3(x[:], y[:], z[:], keywords)
	plt.set_xlabel("x label")
	plt.set_ylabel("y label")
	plt.set_zlabel("z label")


	legend_kwargs: plt.Kwargs = plt.kwags_init()
	defer plt.kwags_delete(&legend_kwargs)
	plt.kwargs_append(&legend_kwargs, cstring("fontsize"), 10)

	plt.legend(legend_kwargs)
	plt.show()
}
