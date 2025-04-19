package xkcd

import plt "../src"

import "core:math"

main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	t := make([dynamic]f32, 1000)
	defer delete(t)
	x := make([dynamic]f32, 1000)
	defer delete(x)

	for i in 0 ..< len(t) {
		t[i] = f32(i) / 100.0
		x[i] = math.sin_f32(2.0 * math.PI * 1.0 * t[i])
	}

	plt.xkcd()
	plt.plot(t[:], x[:])
	plt.title("AN ORDINARY SIN WAVE")
	plt.show()

}
