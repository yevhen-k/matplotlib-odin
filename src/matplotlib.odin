package matplotlib

import "base:intrinsics"
import "core:c"
import "core:fmt"
import "core:strings"


when ODIN_OS == .Linux {
	foreign import plt "../build/lib/libmatplotlib.so"
	foreign import py "system:libpython3.10.so"
}


PyObject :: distinct rawptr
Py_ssize_t :: uint

Interpreter :: struct {
	s_python_function_arrow:           PyObject,
	s_python_function_show:            PyObject,
	s_python_function_close:           PyObject,
	s_python_function_draw:            PyObject,
	s_python_function_pause:           PyObject,
	s_python_function_save:            PyObject,
	s_python_function_figure:          PyObject,
	s_python_function_fignum_exists:   PyObject,
	s_python_function_plot:            PyObject,
	s_python_function_quiver:          PyObject,
	s_python_function_contour:         PyObject,
	s_python_function_semilogx:        PyObject,
	s_python_function_semilogy:        PyObject,
	s_python_function_loglog:          PyObject,
	s_python_function_fill:            PyObject,
	s_python_function_fill_between:    PyObject,
	s_python_function_hist:            PyObject,
	s_python_function_imshow:          PyObject,
	s_python_function_scatter:         PyObject,
	s_python_function_boxplot:         PyObject,
	s_python_function_subplot:         PyObject,
	s_python_function_subplot2grid:    PyObject,
	s_python_function_legend:          PyObject,
	s_python_function_xlim:            PyObject,
	s_python_function_ion:             PyObject,
	s_python_function_ginput:          PyObject,
	s_python_function_ylim:            PyObject,
	s_python_function_title:           PyObject,
	s_python_function_axis:            PyObject,
	s_python_function_axhline:         PyObject,
	s_python_function_axvline:         PyObject,
	s_python_function_axvspan:         PyObject,
	s_python_function_xlabel:          PyObject,
	s_python_function_ylabel:          PyObject,
	s_python_function_gca:             PyObject,
	s_python_function_xticks:          PyObject,
	s_python_function_yticks:          PyObject,
	s_python_function_margins:         PyObject,
	s_python_function_tick_params:     PyObject,
	s_python_function_grid:            PyObject,
	s_python_function_cla:             PyObject,
	s_python_function_clf:             PyObject,
	s_python_function_errorbar:        PyObject,
	s_python_function_annotate:        PyObject,
	s_python_function_tight_layout:    PyObject,
	s_python_colormap:                 PyObject,
	s_python_empty_tuple:              PyObject,
	s_python_function_stem:            PyObject,
	s_python_function_xkcd:            PyObject,
	s_python_function_text:            PyObject,
	s_python_function_suptitle:        PyObject,
	s_python_function_bar:             PyObject,
	s_python_function_barh:            PyObject,
	s_python_function_colorbar:        PyObject,
	s_python_function_subplots_adjust: PyObject,
	s_python_function_rcparams:        PyObject,
	s_python_function_spy:             PyObject,
}

npy_intp :: distinct uint // c.size_t

NPY_TYPES :: enum c.int {
	NPY_BOOL = 0,
	NPY_BYTE,
	NPY_UBYTE,
	NPY_SHORT,
	NPY_USHORT,
	NPY_INT,
	NPY_UINT,
	NPY_LONG,
	NPY_ULONG,
	NPY_LONGLONG,
	NPY_ULONGLONG,
	NPY_FLOAT,
	NPY_DOUBLE,
	NPY_LONGDOUBLE,
	NPY_CFLOAT,
	NPY_CDOUBLE,
	NPY_CLONGDOUBLE,
	NPY_OBJECT = 17,
	NPY_STRING,
	NPY_UNICODE,
	NPY_VOID,
	/*
  * New 1.6 types appended, may be integrated
  * into the above in 2.0.
  */
	NPY_DATETIME,
	NPY_TIMEDELTA,
	NPY_HALF,
	NPY_CHAR, /* Deprecated, will raise if used */

	/* The number of *legacy* dtypes */
	NPY_NTYPES_LEGACY = 24,

	/* assign a high value to avoid changing this in the
                       future when new dtypes are added */
	NPY_NOTYPE = 25,
	NPY_USERDEF = 256, /* leave room for characters */

	/* The number of types not including the new 1.6 types */
	NPY_NTYPES_ABI_COMPATIBLE = 21,

	/*
  * New DTypes which do not share the legacy layout
  * (added after NumPy 2.0).  VSTRING is the first of these
  * we may open up a block for user-defined dtypes in the
  * future.
  */
	NPY_VSTRING = 2056,
}


@(default_calling_convention = "c")
foreign plt {
	interpreter_get :: proc() -> ^Interpreter ---
	interpreter_delete :: proc(interpreter: ^Interpreter) ---

	PyArray_SimpleNewFromData_NP :: proc(nd: c.int, dims: ^npy_intp, typenum: NPY_TYPES, data: rawptr) -> PyObject ---
	Py_DECREF_PY :: proc(o: PyObject) ---
}

@(default_calling_convention = "c")
foreign py {
	PyDict_New :: proc() -> PyObject ---
	PyDict_SetItemString :: proc(kwargs: PyObject, key: cstring, val: PyObject) -> i32 ---
	PyUnicode_FromString :: proc(s: cstring) -> PyObject ---
	PyFloat_FromDouble :: proc(v: f64) -> PyObject ---
	PyTuple_New :: proc(len: uint) -> PyObject ---
	PyTuple_SetItem :: proc(p: PyObject, pos: Py_ssize_t, o: PyObject) -> i32 ---
	PyObject_Call :: proc(callable: PyObject, args: PyObject, kwargs: PyObject) -> PyObject ---
	Py_DecRef :: proc(o: PyObject) ---
	PyObject_CallObject :: proc(callable: PyObject, args: PyObject) -> PyObject ---
	PyBool_FromLong :: proc(_: c.long) -> PyObject ---
}

PyString_FromString :: PyUnicode_FromString


@(private = "package")
select_npy_type :: proc($T: typeid) -> NPY_TYPES {
	when T == bool {
		return .NPY_BOOL
	};when T == i8 {
		return .NPY_BYTE
	};when T == u8 {
		return .NPY_UBYTE
	};when T == i16 {
		return .NPY_SHORT
	};when T == u16 {
		return .NPY_USHORT
	};when T == i32 {
		return .NPY_INT
	};when T == u32 {
		return .NPY_UINT
	};when T == i64 || T == int {
		return .NPY_LONGLONG
	};when T == u64 {
		return .NPY_ULONGLONG
	};when T == f32 {
		return .NPY_FLOAT
	};when T == f64 {
		return .NPY_DOUBLE
	} else {
		// TODO: use `.NPY_NOTYPE` instead of panic
		// Default or error case
		fmt.panicf("Unsupported type for NumPy conversion: %v", typeid_of(T))
	}
}

@(private = "package")
get_array :: proc(
	v: []$T,
) -> PyObject where intrinsics.type_is_numeric(T) ||
	intrinsics.type_is_boolean(T) {
	vsize: npy_intp = npy_intp(len(v))
	type: NPY_TYPES = select_npy_type(T)
	varray: PyObject = PyArray_SimpleNewFromData_NP(1, &vsize, type, &v[0])
	return varray
}

@(private = "package")
bar_impl :: proc(
	xarray: PyObject,
	yarray: PyObject,
	ec: string = "black",
	ls: string = "-",
	lw: f64 = 1.0,
	keywords: map[string]string = {},
) -> (
	ok: bool,
) {
	kwargs: PyObject = PyDict_New()
	assert(kwargs != nil)

	PyDict_SetItemString(kwargs, "ec", PyString_FromString(strings.unsafe_string_to_cstring(ec)))
	PyDict_SetItemString(kwargs, "ls", PyString_FromString(strings.unsafe_string_to_cstring(ls)))
	PyDict_SetItemString(kwargs, "lw", PyFloat_FromDouble(lw))

	for k, v in keywords {
		PyDict_SetItemString(
			kwargs,
			strings.unsafe_string_to_cstring(k),
			PyUnicode_FromString(strings.unsafe_string_to_cstring(v)),
		)
	}

	plot_args: PyObject = PyTuple_New(2)
	PyTuple_SetItem(plot_args, 0, xarray)
	PyTuple_SetItem(plot_args, 1, yarray)

	assert(plot_args != nil)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_bar, plot_args, kwargs)
	ok = res != nil
	if ok {
		Py_DECREF_PY(res)
	}
	Py_DECREF_PY(plot_args)
	Py_DECREF_PY(kwargs)

	ok = true
	return
}

bar5 :: proc(
	x: []$T,
	ec: string = "black",
	ls: string = "-",
	lw: f64 = 1.0,
	keywords: map[string]string = {},
) -> bool where intrinsics.type_is_numeric(T) {
	interpreter_get()

	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(x)

	assert(xarray != nil)
	assert(yarray != nil)

	return bar_impl(xarray, yarray, ec, ls, lw, keywords)
}

bar6 :: proc(
	x: []$T,
	y: []T,
	ec: string = "black",
	ls: string = "-",
	lw: f64 = 1.0,
	keywords: map[string]string = {},
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) {
	interpreter_get()
	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)

	assert(xarray != nil)
	assert(yarray != nil)

	return bar_impl(xarray, yarray, ec, ls, lw, keywords)
}


bar :: proc {
	bar5,
	bar6,
}


show :: proc(block: bool = true) -> (ok: bool) {
	interpreter_get()
	res: PyObject
	if block {
		res = PyObject_CallObject(
			interpreter_get().s_python_function_show,
			interpreter_get().s_python_empty_tuple,
		)
	} else {
		kwargs: PyObject = PyDict_New()
		py_false: PyObject = PyBool_FromLong(c.long(0))
		PyDict_SetItemString(kwargs, "block", py_false)
		res = PyObject_Call(
			interpreter_get().s_python_function_show,
			interpreter_get().s_python_empty_tuple,
			kwargs,
		)
		Py_DECREF_PY(kwargs)
		Py_DECREF_PY(py_false)
	}

	ok = true
	if (res == nil) {
		fmt.eprintln("Call to show() failed.")
		ok = false
	}

	Py_DECREF_PY(res)
	return
}


main :: proc() {

	interp := interpreter_get()
	interp2 := interpreter_get()
	fmt.printfln("Interpreters: %p == %p is %t", interp, interp2, interp == interp2)

	interpreter_delete(interp)

}
