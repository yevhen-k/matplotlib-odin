package minimal

import plt "../src"

main :: proc() {
	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	x: []f64 = {1, 3, 2, 4}
	plt.plot(x[:])
	plt.show()
}
