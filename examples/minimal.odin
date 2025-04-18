package minimal

import plt "../src"

main :: proc() {
	x: []f64 = {1, 3, 2, 4}
	plt.plot(x[:])
	plt.show()
}
