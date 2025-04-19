package quiver

import plt "../src"
import "core:fmt"
import "core:io"
import "core:math"


main :: proc() {

	interp := plt.interpreter_get()
	defer plt.interpreter_delete(interp)

    // u and v are respectively the x and y components of the arrows we're plotting
    x: [dynamic]f64
    defer delete(x)
    y: [dynamic]f64
    defer delete(y)
    u: [dynamic]f64
    defer delete(u)
    v: [dynamic]f64
    defer delete(v)

    for  i in -5..= 5 {
        for j in -5..= 5 {
            append(&x, f64(i))
            append(&u, f64(-i))
            append(&y, f64(j))
            append(&v, f64(-j))
        }
    }

    plt.quiver(x[:], y[:], u[:], v[:])
    plt.show()
}
