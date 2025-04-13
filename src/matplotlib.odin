package matplotlib

import "base:intrinsics"
import "core:fmt"


Interpreter :: distinct rawptr

when ODIN_OS == .Linux do foreign import plt "../build/lib/libmatplotlib.so"

@(default_calling_convention = "c")
foreign plt {
	interpreter_get :: proc() -> Interpreter ---
	interpreter_delete :: proc(interpreter: Interpreter) ---
}


main :: proc() {

	interp := interpreter_get()
	interp2 := interpreter_get()
	fmt.printfln("Interpreters: %p == %p is %t", interp, interp2, interp == interp2)

	interpreter_delete(interp)

}
