package bar

import "core:fmt"
import "core:os"

import plt "../src"

main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

	x := []int{1, 2, 3, 4, 5}
	y := []f32{1, 2, 3, 4, 5}
	ok := plt.bar(x, y)
	if !ok {
		fmt.eprintln("Plotting failed")
		os.exit(1)
	}

	ok = plt.show()
	if !ok {
		fmt.eprintln("Failed to show plot")
		os.exit(1)
	}

}
