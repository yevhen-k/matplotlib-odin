package imshow

import plt "../src"
import "core:fmt"
import "core:math"

main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	//  Prepare data
	ncols :: 500
	nrows :: 300
	z: [dynamic]f32
	defer delete(z)
	for j := 0; j < nrows; j += 1 {
		for i := 0; i < ncols; i += 1 {
			append(&z, math.sin_f32(math.hypot_f32(f32(i - ncols / 2.0), f32(j - nrows / 2.0))))
		}
	}

	colors :: 1
	plt.title("My matrix")
	plt.imshow(z[:], nrows, ncols, colors, nil, nil)

	// Show plots
	plt.save("imshow.png")
	fmt.println("Result saved to 'imshow.png'.")
}
