package quiver3d

import plt "../src"
import "core:fmt"
import "core:io"
import "core:math"


printX :: proc(X: []f64, dim_z: uint) {
	count := -1
	for x, i in X {
		fmt.printf("%f ", x)
		count += 1
		if count == int(dim_z) - 1 {
			fmt.println()
			count = -1
		}
	}
}

main :: proc() {

	// https://matplotlib.org/stable/gallery/mplot3d/quiver3d.html

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	xs: [dynamic]f64
	defer delete(xs)
	ys: [dynamic]f64
	defer delete(ys)
	zs: [dynamic]f64
	defer delete(zs)

	for i := -3.8; i < -1; i += 0.2 {
		// fmt.printf("%f  ", i)
		append(&xs, f64(i))
	}
	for i := -0.8; i < 1; i += 0.2 {
		// fmt.printf("%f  ", i)
		append(&ys, f64(i))
	}
	for i := -0.8; i < 1; i += 0.8 {
		// fmt.printf("%f  ", i)
		append(&zs, f64(i))
	}

	// meshgrid components
	X: [dynamic]f64
	defer delete(X)
	Y: [dynamic]f64
	defer delete(Y)
	Z: [dynamic]f64
	defer delete(Z)

	// Make the direction data for the arrows
	U: [dynamic]f64
	defer delete(U)
	V: [dynamic]f64
	defer delete(V)
	W: [dynamic]f64
	defer delete(W)

	// emulating numpy.meshgrid(as, bs, cs, indexing='xy')
	// see https://numpy.org/doc/2.2/reference/generated/numpy.meshgrid.html
	// as [-3.8 -3.6 -3.4 -3.2 -3.  -2.8 -2.6 -2.4 -2.2 -2.  -1.8 -1.6 -1.4 -1.2]
	// bs [-0.8 -0.6 -0.4 -0.2 0  0.2  0.4  0.6 0.8]
	// cs [-0.8  0.   0.8]
	for y in ys {
		for x in xs {
			for z in zs {
				append(&X, x)
				append(&Y, y)
				append(&Z, z)

				u :=
					math.sin_f64(math.PI * x) *
					math.cos_f64(math.PI * y) *
					math.cos_f64(math.PI * z)
				append(&U, u)

				v :=
					-math.cos_f64(math.PI * x) *
					math.sin_f64(math.PI * y) *
					math.cos_f64(math.PI * z)
				append(&V, v)

				w :=
					math.sqrt_f64(2.0 / 3.0) *
					math.cos_f64(math.PI * x) *
					math.cos_f64(math.PI * y) *
					math.sin_f64(math.PI * z)
				append(&W, w)
			}
		}
	}
	// printX(X[:], dim_z = len(cs))
	// printX(Y[:], dim_z = len(cs))
	// printX(Z[:], dim_z = len(cs))

	kwargs: plt.Kwargs = plt.kwags_init()
	defer plt.kwags_delete(&kwargs)
	plt.kwargs_append(&kwargs, cstring("length"), 0.1)
	plt.kwargs_append(&kwargs, cstring("normalize"), true)

	plt.quiver(X[:], Y[:], Z[:], U[:], V[:], W[:], kwargs)
	plt.show()
}
