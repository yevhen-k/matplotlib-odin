package matplotlib

import "base:intrinsics"
import "core:c"
import "core:fmt"
import "core:strings"

PY_VER :: #config(PY_VER, -1)

when ODIN_OS == .Linux {
	foreign import plt "../build/lib/libmatplotlib.so"
	when PY_VER == 3.10 {
		foreign import py "system:libpython3.10.so"
	} else when PY_VER == 3.11 {
		foreign import py "system:libpython3.11.so"
	} else when PY_VER == 3.12 {
		foreign import py "system:libpython3.12.so"
	} else when PY_VER == 3.13 {
		foreign import py "system:libpython3.13.so"
	} else {
		#panic("Undefined PY_VER var or unsupported python version")
	}
} else when ODIN_OS == .Windows {
	foreign import plt "../build/lib/matplotlib.lib"
	when PY_VER == 310 {
		foreign import py "system:python310.lib"
	} else when PY_VER == 311 {
		foreign import py "system:python311.lib"
	} else when PY_VER == 312 {
		foreign import py "system:python312.lib"
	} else when PY_VER == 313 {
		foreign import py "system:python313.lib"
	} else {
		#panic("Undefined PY_VER var or unsupported python version")
	}
} else {
	#panic("Unsuported OS.")
}

// @(private = "package")
PyObject :: distinct rawptr
@(private = "package")
Py_ssize_t :: uint
@(private = "package")
PyArrayObject :: distinct rawptr

@(private = "package")
Interpreter :: struct {
	// TODO: implement
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
	// TODO: implement
	s_python_function_semilogx:        PyObject,
	// TODO: implement
	s_python_function_semilogy:        PyObject,
	// TODO: implement
	s_python_function_loglog:          PyObject,
	s_python_function_fill:            PyObject,
	s_python_function_fill_between:    PyObject,
	// TODO: implement
	s_python_function_hist:            PyObject,
	s_python_function_imshow:          PyObject,
	// TODO: implement
	s_python_function_scatter:         PyObject,
	// TODO: implement
	s_python_function_boxplot:         PyObject,
	s_python_function_subplot:         PyObject,
	s_python_function_subplot2grid:    PyObject,
	s_python_function_legend:          PyObject,
	s_python_function_xlim:            PyObject,
	s_python_function_ion:             PyObject,
	// TODO: implement
	s_python_function_ginput:          PyObject,
	s_python_function_ylim:            PyObject,
	s_python_function_title:           PyObject,
	s_python_function_axis:            PyObject,
	// TODO: implement
	s_python_function_axhline:         PyObject,
	// TODO: implement
	s_python_function_axvline:         PyObject,
	// TODO: implement
	s_python_function_axvspan:         PyObject,
	s_python_function_xlabel:          PyObject,
	s_python_function_ylabel:          PyObject,
	s_python_function_gca:             PyObject,
	// TODO: implement
	s_python_function_xticks:          PyObject,
	// TODO: implement
	s_python_function_yticks:          PyObject,
	// TODO: implement
	s_python_function_margins:         PyObject,
	// TODO: implement
	s_python_function_tick_params:     PyObject,
	s_python_function_grid:            PyObject,
	// TODO: implement
	s_python_function_cla:             PyObject,
	s_python_function_clf:             PyObject,
	// TODO: implement
	s_python_function_errorbar:        PyObject,
	// TODO: implement
	s_python_function_annotate:        PyObject,
	// TODO: implement
	s_python_function_tight_layout:    PyObject,
	s_python_colormap:                 PyObject,
	s_python_empty_tuple:              PyObject,
	// TODO: implement
	s_python_function_stem:            PyObject,
	s_python_function_xkcd:            PyObject,
	s_python_function_text:            PyObject,
	s_python_function_suptitle:        PyObject,
	s_python_function_bar:             PyObject,
	// TODO: implement
	s_python_function_barh:            PyObject,
	s_python_function_colorbar:        PyObject,
	// TODO: implement
	s_python_function_subplots_adjust: PyObject,
	// TODO: implement
	s_python_function_rcparams:        PyObject,
	s_python_function_spy:             PyObject,
}

@(private = "package")
npy_intp :: distinct uint // c.size_t

@(private = "package")
NPY_TYPES :: enum i32 {
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

	PyArray_SimpleNewFromData_NP :: proc(nd: i32, dims: ^npy_intp, typenum: NPY_TYPES, data: rawptr) -> PyObject ---

	PyArray_SimpleNew_NP :: proc(nd: i32, dims: ^npy_intp, typenum: NPY_TYPES) -> PyObject ---
	PyArray_DATA_NP :: proc(arr: PyArrayObject) -> rawptr ---
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
	PyBool_FromLong :: proc(b: c.long) -> PyObject ---
	PyList_SetItem :: proc(list: PyObject, index: Py_ssize_t, item: PyObject) -> i32 ---
	PyTuple_GetItem :: proc(p: PyObject, pos: Py_ssize_t) -> PyObject ---
	PyFloat_AsDouble :: proc(pyfloat: PyObject) -> f64 ---
	PyList_New :: proc(len: Py_ssize_t) -> PyObject ---
	PyLong_FromSize_t :: proc(v: uint) -> PyObject ---
	PyLong_FromLong :: proc(v: c.long) -> PyObject ---
	PyObject_GetAttrString :: proc(o: PyObject, attr_name: cstring) -> PyObject ---
	PyGILState_Check :: proc() -> i32 ---
	PyImport_Import :: proc(name: PyObject) -> PyObject ---
	PyObject_IsTrue :: proc(o: PyObject) -> i32 ---
	Py_IncRef :: proc(o: PyObject) ---
}

PyString_FromString :: PyUnicode_FromString

// Functionality of the Kwargs type can be extended accoridng to
// https://docs.python.org/3/c-api/dict.html#dictionary-objects
// if necessary
Kwargs :: distinct PyObject
kwags_init :: proc() -> Kwargs {
	interpreter_get()
	kwargs: PyObject = PyDict_New()
	assert(kwargs != nil)
	return Kwargs(kwargs)
}

kwags_delete :: proc(kwargs: ^Kwargs) {
	Py_DecRef(PyObject(kwargs^))
}

kwargs_append_cstr :: proc(kwargs: ^Kwargs, key: cstring, val: cstring) {
	ret := PyDict_SetItemString(PyObject(kwargs^), key, PyString_FromString(val))
	assert(ret == 0)
}

kwargs_append_float :: proc(kwargs: ^Kwargs, key: cstring, val: f64) {
	ret := PyDict_SetItemString(PyObject(kwargs^), key, PyFloat_FromDouble(val))
	assert(ret == 0)
}

kwargs_append_long :: proc(kwargs: ^Kwargs, key: cstring, val: c.long) {
	ret := PyDict_SetItemString(PyObject(kwargs^), key, PyLong_FromLong(val))
	assert(ret == 0)
}

kwargs_append_bool :: proc(kwargs: ^Kwargs, key: cstring, val: bool) {
	ret := PyDict_SetItemString(PyObject(kwargs^), key, PyBool_FromLong(c.long(val)))
	assert(ret == 0)
}

kwargs_append :: proc {
	kwargs_append_cstr,
	kwargs_append_float,
	kwargs_append_long,
	kwargs_append_bool,
}

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

	assert(len(v) > 0)

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
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) {
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
		assert(kwargs != nil)
	}

	cec := strings.clone_to_cstring(ec)
	cls := strings.clone_to_cstring(ls)
	defer {
		delete(cec)
		delete(cls)
	}
	PyDict_SetItemString(kwargs, "ec", PyString_FromString(cec))
	PyDict_SetItemString(kwargs, "ls", PyString_FromString(cls))
	PyDict_SetItemString(kwargs, "lw", PyFloat_FromDouble(lw))

	plot_args: PyObject = PyTuple_New(2)
	PyTuple_SetItem(plot_args, 0, xarray)
	PyTuple_SetItem(plot_args, 1, yarray)

	assert(plot_args != nil)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_bar, plot_args, kwargs)
	ok = res != nil
	if ok {
		Py_DecRef(res)
	}
	Py_DecRef(plot_args)
	if keywords == nil do Py_DecRef(kwargs)

	return
}

get_2darray_slice :: proc(v: $T/[][]$E) -> PyObject where intrinsics.type_is_numeric(E) {
	assert(len(v) > 0, "get_2d_array v too small")

	rows := npy_intp(len(v))
	cols := npy_intp(len(v[0]))
	vsize: [2]npy_intp = {rows, cols}

	varray: PyArrayObject = PyArrayObject(PyArray_SimpleNew_NP(2, &vsize[0], NPY_TYPES.NPY_DOUBLE))

	vd_begin: [^]f64 = cast([^]f64)(PyArray_DATA_NP(varray))
	assert(vd_begin != nil)

	for row, i in v {
		assert(len(row) == int(vsize[1]), "2d matrix is not rectangular")
		for col, j in row {
			// vd_begin[row][col]
			vd_begin[i * int(cols) + j] = f64(v[i][j])
		}
	}

	res := PyObject(varray)
	return res
}

get_2darray_dyn :: proc(
	v: $T/[dynamic][dynamic]$E,
) -> PyObject where intrinsics.type_is_numeric(E) {
	assert(len(v) > 0, "get_2d_array v too small")

	rows := npy_intp(len(v))
	cols := npy_intp(len(v[0]))
	vsize: [2]npy_intp = {rows, cols}

	varray: PyArrayObject = PyArrayObject(PyArray_SimpleNew_NP(2, &vsize[0], NPY_TYPES.NPY_DOUBLE))

	vd_begin: [^]f64 = cast([^]f64)(PyArray_DATA_NP(varray))
	assert(vd_begin != nil)

	for row, i in v {
		assert(len(row) == int(vsize[1]), "2d matrix is not rectangular")
		for col, j in row {
			// vd_begin[row][col]
			vd_begin[i * int(cols) + j] = f64(v[i][j])
		}
	}

	res := PyObject(varray)
	return res
}

get_2darray_raw :: proc(
	v: $T/[]$E,
	rows: uint,
	cols: uint,
) -> PyObject where intrinsics.type_is_numeric(E) {
	assert(len(v) > 0, "get_2d_array v too small")

	vsize: [2]npy_intp = {npy_intp(rows), npy_intp(cols)}

	varray: PyArrayObject = PyArrayObject(PyArray_SimpleNew_NP(2, &vsize[0], NPY_TYPES.NPY_DOUBLE))

	vd_begin: [^]f64 = cast([^]f64)(PyArray_DATA_NP(varray))
	assert(vd_begin != nil)

	for row, i in v {
		vd_begin[i] = f64(row)
	}

	res := PyObject(varray)
	return res
}

get_2darray :: proc {
	get_2darray_slice,
	get_2darray_dyn,
	get_2darray_raw,
}

bar5 :: proc(
	x: []$T,
	ec: string = "black",
	ls: string = "-",
	lw: f64 = 1.0,
	keywords: Kwargs = nil,
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
	y: []$U,
	ec: string = "black",
	ls: string = "-",
	lw: f64 = 1.0,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) &&
	intrinsics.type_is_numeric(U) {
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


clf :: proc() -> (ok: bool) {
	interpreter_get()
	res: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_clf,
		interpreter_get().s_python_empty_tuple,
	)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to clf() failed.")
	}

	Py_DecRef(res)
	return
}


plot_xy_style :: proc(
	x: []$T,
	y: []$U,
	style: string = "",
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) &&
	intrinsics.type_is_numeric(U) {


	assert(len(x) == len(y))
	interpreter_get()
	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)

	cs := strings.clone_to_cstring(style)
	defer delete(cs)
	pystring: PyObject = PyString_FromString(cs)

	plot_args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(plot_args, 0, xarray)
	PyTuple_SetItem(plot_args, 1, yarray)
	PyTuple_SetItem(plot_args, 2, pystring)

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_plot, plot_args)

	Py_DecRef(plot_args)
	ok = res != nil
	if ok do Py_DecRef(res)

	return
}


plot_xy_kwargs :: proc(
	x: []$T,
	y: []$U,
	keywords: Kwargs,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) &&
	intrinsics.type_is_numeric(U) {
	assert(len(x) == len(y))
	interpreter_get()
	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)

	// construct positional args
	args: PyObject = PyTuple_New(2)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, yarray)
	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_plot, args, kwargs)

	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)

	ok = res != nil
	if ok do Py_DecRef(res)

	return
}


plot_y_style :: proc(
	x: []$T,
	style: string = "",
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) {
	interpreter_get()
	xarray: PyObject = get_array(x)

	y: [dynamic]T
	defer delete(y)
	for i in 0 ..< len(x) {
		append(&y, T(i))
	}

	yarray: PyObject = get_array(y[:])

	cs := strings.clone_to_cstring(style)
	defer delete(cs)
	pystring: PyObject = PyString_FromString(cs)

	plot_args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(plot_args, 0, yarray)
	PyTuple_SetItem(plot_args, 1, xarray)
	PyTuple_SetItem(plot_args, 2, pystring)

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_plot, plot_args)

	Py_DecRef(plot_args)
	ok = res != nil
	if ok do Py_DecRef(res)

	return
}


plot_y_kwargs :: proc(
	x: []$T,
	keywords: Kwargs,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) {
	interpreter_get()
	xarray: PyObject = get_array(x)

	y: [dynamic]T
	defer delete(y)
	for i in 0 ..< len(x) {
		append(&y, T(i))
	}

	yarray: PyObject = get_array(y[:])

	// construct positional args
	args: PyObject = PyTuple_New(2)
	PyTuple_SetItem(args, 0, yarray)
	PyTuple_SetItem(args, 1, xarray)
	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_plot, args, kwargs)

	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)

	ok = res != nil
	if ok do Py_DecRef(res)

	return
}

plot :: proc {
	plot_xy_style,
	plot_xy_kwargs,
	plot_y_style,
	plot_y_kwargs,
}

subplot :: proc(nrows: uint, ncols: uint, plot_number: uint) -> (ok: bool) {
	interpreter_get()

	// construct positional args
	args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(args, 0, PyLong_FromLong(c.long(nrows)))
	PyTuple_SetItem(args, 1, PyLong_FromLong(c.long(ncols)))
	PyTuple_SetItem(args, 2, PyLong_FromLong(c.long(plot_number)))

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_subplot, args)
	Py_DecRef(args)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to subplot() failed.")
		return
	}
	Py_DecRef(res)
	return
}

subplot2grid :: proc(
	nrows: uint,
	ncols: uint,
	rowid: uint = 0,
	colid: uint = 0,
	rowspan: uint = 1,
	colspan: uint = 1,
) -> (
	ok: bool,
) {
	interpreter_get()

	shape: PyObject = PyTuple_New(2)
	PyTuple_SetItem(shape, 0, PyLong_FromLong(c.long(nrows)))
	PyTuple_SetItem(shape, 1, PyLong_FromLong(c.long(ncols)))

	loc: PyObject = PyTuple_New(2)
	PyTuple_SetItem(loc, 0, PyLong_FromLong(c.long(rowid)))
	PyTuple_SetItem(loc, 1, PyLong_FromLong(c.long(colid)))

	args: PyObject = PyTuple_New(4)
	PyTuple_SetItem(args, 0, shape)
	PyTuple_SetItem(args, 1, loc)
	PyTuple_SetItem(args, 2, PyLong_FromLong(c.long(rowspan)))
	PyTuple_SetItem(args, 3, PyLong_FromLong(c.long(colspan)))

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_subplot2grid, args)

	Py_DecRef(shape)
	Py_DecRef(loc)
	Py_DecRef(args)
	ok = res != nil
	if !ok {
		fmt.eprintln("Call to subplot2grid() failed.")
		return
	}

	Py_DecRef(res)
	return
}


plot3 :: proc(
	x: $T/[]$E,
	y: $T1/[]$E1,
	z: $T2/[]$E2,
	keywords: Kwargs = nil,
	fig_number: c.long = 0,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	interpreter_get()

	assert(len(x) == len(y))
	assert(len(y) == len(z))

	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)
	zarray: PyObject = get_array(z)

	// construct positional args
	args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, yarray)
	PyTuple_SetItem(args, 2, zarray)

	// Build up the kw args.
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	fig_args: PyObject = PyTuple_New(1)
	fig: PyObject
	PyTuple_SetItem(fig_args, 0, PyLong_FromLong(fig_number))
	fig_exists: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_fignum_exists,
		fig_args,
	)
	if (PyObject_IsTrue(fig_exists) == 0) {
		fig = PyObject_CallObject(
			interpreter_get().s_python_function_figure,
			interpreter_get().s_python_empty_tuple,
		)
	} else {
		fig = PyObject_CallObject(interpreter_get().s_python_function_figure, fig_args)
	}
	Py_DecRef(fig_exists)
	ok = fig != nil
	if (!ok) {
		fmt.eprintln("Call to figure() failed.")
		return
	}

	gca_kwargs: PyObject = PyDict_New()
	PyDict_SetItemString(gca_kwargs, "projection", PyString_FromString("3d"))

	add_subplot: PyObject = PyObject_GetAttrString(fig, "add_subplot")
	ok = add_subplot != nil
	if (!ok) {
		fmt.eprintln("No add_subplot")
		return
	}
	Py_IncRef(add_subplot)

	axis: PyObject = PyObject_Call(add_subplot, interpreter_get().s_python_empty_tuple, gca_kwargs)

	ok = axis != nil
	if (!ok) {
		fmt.eprintln("No axis")
		return
	}
	Py_IncRef(axis)

	Py_DecRef(add_subplot)
	Py_DecRef(gca_kwargs)

	plot3: PyObject = PyObject_GetAttrString(axis, "plot")
	ok = plot3 != nil
	if (!ok) {
		fmt.eprintln("No 3D line plot")
		return
	}
	Py_IncRef(plot3)
	res: PyObject = PyObject_Call(plot3, args, kwargs)

	Py_DecRef(plot3)
	Py_DecRef(axis)
	Py_DecRef(args)

	ok = res != nil
	if (!ok) {
		fmt.eprintln("Failed 3D line plot")
		return
	}

	if keywords == nil do Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}


plot_surface_slice :: proc(
	x: $T/[][]$E,
	y: $T1/[][]$E1,
	z: $T2/[][]$E2,
	keywords: Kwargs = nil,
	fig_number: c.long = 0,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {

	interpreter_get()


	assert(len(x) == len(y))
	assert(len(y) == len(z))

	// using numpy arrays
	xarray: PyObject = get_2darray(x)
	yarray: PyObject = get_2darray(y)
	zarray: PyObject = get_2darray(z)


	return plot_surface_impl(xarray, yarray, zarray, keywords, fig_number)

}

plot_surface_dyn :: proc(
	x: $T/[dynamic][dynamic]$E,
	y: $T1/[dynamic][dynamic]$E1,
	z: $T2/[dynamic][dynamic]$E2,
	keywords: Kwargs = nil,
	fig_number: c.long = 0,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_2darray(x)
	yarray: PyObject = get_2darray(y)
	zarray: PyObject = get_2darray(z)

	ok = plot_surface_impl(xarray, yarray, zarray, keywords, fig_number)
	return
}

plot_surface_raw :: proc(
	x: $T/[]$E,
	y: $T1/[]$E1,
	z: $T2/[]$E2,
	rows: uint,
	cols: uint,
	keywords: Kwargs = nil,
	fig_number: c.long = 0,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_2darray(x, rows, cols)
	yarray: PyObject = get_2darray(y, rows, cols)
	zarray: PyObject = get_2darray(z, rows, cols)

	ok = plot_surface_impl(xarray, yarray, zarray, keywords, fig_number)
	return
}

@(private = "package")
plot_surface_impl :: proc(
	xarray: PyObject,
	yarray: PyObject,
	zarray: PyObject,
	keywords: Kwargs = nil,
	fig_number: c.long = 0,
) -> (
	ok: bool,
) {
	// construct positional args
	args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, yarray)
	PyTuple_SetItem(args, 2, zarray)
	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}
	PyDict_SetItemString(kwargs, "rstride", PyLong_FromLong(1))
	PyDict_SetItemString(kwargs, "cstride", PyLong_FromLong(1))

	python_colormap_coolwarm: PyObject = PyObject_GetAttrString(
		interpreter_get().s_python_colormap,
		"coolwarm",
	)

	PyDict_SetItemString(kwargs, "cmap", python_colormap_coolwarm)

	fig_args: PyObject = PyTuple_New(1)
	fig: PyObject
	PyTuple_SetItem(fig_args, 0, PyLong_FromLong(fig_number))
	fig_exists: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_fignum_exists,
		fig_args,
	)
	if (PyObject_IsTrue(fig_exists) == 0) {
		fig = PyObject_CallObject(
			interpreter_get().s_python_function_figure,
			interpreter_get().s_python_empty_tuple,
		)
	} else {
		fig = PyObject_CallObject(interpreter_get().s_python_function_figure, fig_args)
	}
	Py_DecRef(fig_exists)
	ok = fig != nil
	if (!ok) {
		fmt.eprintln("Call to figure() failed.")
		return
	}

	gca_kwargs: PyObject = PyDict_New()
	PyDict_SetItemString(gca_kwargs, "projection", PyString_FromString("3d"))

	add_subplot: PyObject = PyObject_GetAttrString(fig, "add_subplot")
	ok = add_subplot != nil
	if (!ok) {
		fmt.eprintln("No add_subplot")
		return
	}
	Py_IncRef(add_subplot)

	axis: PyObject = PyObject_Call(add_subplot, interpreter_get().s_python_empty_tuple, gca_kwargs)

	ok = axis != nil
	if (!ok) {
		fmt.eprintln("No axis")
		return
	}
	Py_IncRef(axis)

	Py_DecRef(add_subplot)
	Py_DecRef(gca_kwargs)

	plot_surface: PyObject = PyObject_GetAttrString(axis, "plot_surface")
	ok = plot_surface != nil
	if (!ok) {
		fmt.eprintln("No surface")
		return
	}

	Py_IncRef(plot_surface)
	res: PyObject = PyObject_Call(plot_surface, args, kwargs)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("failed surface")
		return
	}
	Py_DecRef(plot_surface)

	Py_DecRef(axis)
	Py_DecRef(args)
	Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}

plot_surface :: proc {
	plot_surface_slice,
	plot_surface_dyn,
	plot_surface_raw,
}


named_plot_label_x_fmt :: proc(
	label: string,
	x: []$T,
	format: string = "",
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) {

	interpreter_get()
	kwargs: PyObject = PyDict_New()
	cname := strings.clone_to_cstring(label)
	defer delete(cname)
	PyDict_SetItemString(kwargs, "label", PyString_FromString(cname))

	xarray: PyObject = get_array(x)

	cformat := strings.clone_to_cstring(format)
	defer delete(cformat)
	pystring: PyObject = PyString_FromString(cformat)

	plot_args: PyObject = PyTuple_New(2)

	PyTuple_SetItem(plot_args, 0, xarray)
	PyTuple_SetItem(plot_args, 1, pystring)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_plot, plot_args, kwargs)

	Py_DecRef(kwargs)
	Py_DecRef(plot_args)
	ok = res != nil
	if ok do Py_DecRef(res)

	return
}


named_plot_label_xy_fmt :: proc(
	label: string,
	x: []$T,
	y: []$U,
	format: string = "",
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) &&
	intrinsics.type_is_numeric(U) {

	interpreter_get()
	kwargs: PyObject = PyDict_New()

	cname := strings.clone_to_cstring(label)
	defer delete(cname)
	PyDict_SetItemString(kwargs, "label", PyString_FromString(cname))

	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)

	cformat := strings.clone_to_cstring(format)
	defer delete(cformat)
	pystring: PyObject = PyString_FromString(cformat)

	plot_args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(plot_args, 0, xarray)
	PyTuple_SetItem(plot_args, 1, yarray)
	PyTuple_SetItem(plot_args, 2, pystring)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_plot, plot_args, kwargs)

	Py_DecRef(kwargs)
	Py_DecRef(plot_args)
	ok = res != nil
	if ok do Py_DecRef(res)

	return
}

named_plot :: proc {
	named_plot_label_x_fmt,
	named_plot_label_xy_fmt,
}


xlim_lr :: proc(left: $T, right: T) -> (ok: bool) where intrinsics.type_is_numeric(T) {
	interpreter_get()

	list: PyObject = PyList_New(2)
	PyList_SetItem(list, 0, PyFloat_FromDouble(f64(left)))
	PyList_SetItem(list, 1, PyFloat_FromDouble(f64(right)))

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, list)

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_xlim, args)

	Py_DecRef(args)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to xlim() failed.")
		return
	}

	Py_DecRef(res)

	return
}


xlim_void :: proc() -> (left, right: f64, ok: bool) {
	interpreter_get()
	args: PyObject = PyTuple_New(0)
	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_xlim, args)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to xlim() failed.")
		return
	}

	left_py: PyObject = PyTuple_GetItem(res, 0)
	right_py: PyObject = PyTuple_GetItem(res, 1)
	left = PyFloat_AsDouble(left_py)
	right = PyFloat_AsDouble(right_py)

	Py_DecRef(res)
	return
}

xlim :: proc {
	xlim_lr,
	xlim_void,
}


ylim_bt :: proc(bottom: $T, top: T) -> (ok: bool) where intrinsics.type_is_numeric(T) {
	interpreter_get()

	list: PyObject = PyList_New(2)
	PyList_SetItem(list, 0, PyFloat_FromDouble(f64(bottom)))
	PyList_SetItem(list, 1, PyFloat_FromDouble(f64(top)))

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, list)

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_ylim, args)

	Py_DecRef(args)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to ylim() failed.")
		return
	}

	Py_DecRef(res)

	return
}


ylim_void :: proc() -> (bottom, top: f64, ok: bool) {
	interpreter_get()
	args: PyObject = PyTuple_New(0)
	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_ylim, args)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to ylim() failed.")
		return
	}

	bottom_py: PyObject = PyTuple_GetItem(res, 0)
	top_py: PyObject = PyTuple_GetItem(res, 1)
	bottom = PyFloat_AsDouble(bottom_py)
	top = PyFloat_AsDouble(top_py)

	Py_DecRef(res)
	return
}

ylim :: proc {
	ylim_bt,
	ylim_void,
}


title :: proc(titlestr: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	ctitlestr := strings.clone_to_cstring(titlestr)
	defer delete(ctitlestr)

	pytitlestr: PyObject = PyString_FromString(ctitlestr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pytitlestr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_title, args, kwargs)

	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to title() failed.")
		return
	}
	Py_DecRef(res)
	return
}

suptitle :: proc(suptitlestr: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	suptitle := strings.clone_to_cstring(suptitlestr)
	defer delete(suptitle)
	pysuptitlestr: PyObject = PyString_FromString(suptitle)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pysuptitlestr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_suptitle, args, kwargs)
	ok = res != nil

	Py_DecRef(args)
	Py_DecRef(kwargs)

	if !ok {
		fmt.eprintln("Call to suptitle() failed.")
		return
	}
	Py_DecRef(res)
	return
}


legend_void :: proc() -> (ok: bool) {
	interpreter_get()

	res: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_legend,
		interpreter_get().s_python_empty_tuple,
	)
	ok = res != nil
	if !ok {
		fmt.eprintln("Call to legend() failed.")
		return
	}

	Py_DecRef(res)
	return
}


legend_kwargs :: proc(keywords: Kwargs) -> (ok: bool) {
	interpreter_get()

	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(
		interpreter_get().s_python_function_legend,
		interpreter_get().s_python_empty_tuple,
		kwargs,
	)

	if keywords == nil do Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to legend() failed.")
		return
	}

	Py_DecRef(res)
	return
}

legend :: proc {
	legend_void,
	legend_kwargs,
}

text :: proc(x: $T, y: T, text: string = "") -> (ok: bool) where intrinsics.type_is_numeric(T) {
	interpreter_get()

	ctext := strings.clone_to_cstring(text)
	defer delete(ctext)
	args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(args, 0, PyFloat_FromDouble(f64(x)))
	PyTuple_SetItem(args, 1, PyFloat_FromDouble(f64(y)))
	PyTuple_SetItem(args, 2, PyString_FromString(ctext))

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_text, args)
	ok = res != nil
	Py_DecRef(args)
	if !ok {
		fmt.eprintln("Call to text() failed.")
		return
	}

	Py_DecRef(res)
	return
}

xlabel :: proc(str: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)
	pystr: PyObject = PyString_FromString(cstr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pystr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_xlabel, args, kwargs)

	Py_DecRef(args)
	Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to xlabel() failed.")
		return
	}
	Py_DecRef(res)
	return
}

ylabel :: proc(str: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)
	pystr: PyObject = PyString_FromString(cstr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pystr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_ylabel, args, kwargs)

	Py_DecRef(args)
	Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to ylabel() failed.")
		return
	}
	Py_DecRef(res)
	return
}

set_xlabel :: proc(str: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)
	pystr: PyObject = PyString_FromString(cstr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pystr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	ax: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_gca,
		interpreter_get().s_python_empty_tuple,
	)
	ok = ax != nil
	if (!ok) {
		fmt.eprintln("Call to gca() failed.")
		return
	}
	Py_IncRef(ax)

	xlabel: PyObject = PyObject_GetAttrString(ax, "set_xlabel")
	ok = xlabel != nil
	if (!ok) {
		fmt.eprintln("Attribute set_xlabel not found.")
		return
	}

	Py_IncRef(xlabel)

	res: PyObject = PyObject_Call(xlabel, args, kwargs)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to set_xlabel() failed.")
		return
	}
	Py_DecRef(xlabel)

	Py_DecRef(ax)
	Py_DecRef(args)
	Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}

set_ylabel :: proc(str: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)
	pystr: PyObject = PyString_FromString(cstr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pystr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	ax: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_gca,
		interpreter_get().s_python_empty_tuple,
	)
	ok = ax != nil
	if (!ok) {
		fmt.eprintln("Call to gca() failed.")
		return
	}
	Py_IncRef(ax)

	ylabel: PyObject = PyObject_GetAttrString(ax, "set_ylabel")
	ok = ylabel != nil
	if (!ok) {
		fmt.eprintln("Attribute set_ylabel not found.")
		return
	}

	Py_IncRef(ylabel)

	res: PyObject = PyObject_Call(ylabel, args, kwargs)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to set_ylabel() failed.")
		return
	}
	Py_DecRef(ylabel)

	Py_DecRef(ax)
	Py_DecRef(args)
	Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}

set_zlabel :: proc(str: string, keywords: Kwargs = nil) -> (ok: bool) {
	interpreter_get()

	cstr := strings.clone_to_cstring(str)
	defer delete(cstr)
	pystr: PyObject = PyString_FromString(cstr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pystr)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	ax: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_gca,
		interpreter_get().s_python_empty_tuple,
	)
	ok = ax != nil
	if (!ok) {
		fmt.eprintln("Call to gca() failed.")
		return
	}
	Py_IncRef(ax)

	zlabel: PyObject = PyObject_GetAttrString(ax, "set_zlabel")
	ok = zlabel != nil
	if (!ok) {
		fmt.eprintln("Attribute set_zlabel not found.")
		return
	}

	Py_IncRef(zlabel)

	res: PyObject = PyObject_Call(zlabel, args, kwargs)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to set_zlabel() failed.")
		return
	}
	Py_DecRef(zlabel)

	Py_DecRef(ax)
	Py_DecRef(args)
	Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}


figure_size :: proc(
	w: $T,
	h: $U,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(T) &&
	intrinsics.type_is_numeric(U) {
	interpreter_get()

	dpi: f64 = 100.0
	size: PyObject = PyTuple_New(2)
	PyTuple_SetItem(size, 0, PyFloat_FromDouble(f64(w) / dpi))
	PyTuple_SetItem(size, 1, PyFloat_FromDouble(f64(h) / dpi))

	kwargs: PyObject = PyDict_New()
	PyDict_SetItemString(kwargs, "figsize", size)
	PyDict_SetItemString(kwargs, "dpi", PyLong_FromSize_t(uint(dpi)))

	res: PyObject = PyObject_Call(
		interpreter_get().s_python_function_figure,
		interpreter_get().s_python_empty_tuple,
		kwargs,
	)

	Py_DecRef(kwargs)
	Py_DecRef(size)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to figure_size() failed.")
		return
	}

	Py_DecRef(res)
	return
}


imshow_impl :: proc(
	ptr: rawptr,
	type: NPY_TYPES,
	rows: uint,
	columns: uint,
	colors: uint,
	keywords: Kwargs = nil,
	out: ^PyObject,
) {
	// TODO: implement more types
	assert(type == NPY_TYPES.NPY_UBYTE || type == NPY_TYPES.NPY_FLOAT)
	assert(colors == 1 || colors == 3 || colors == 4)
	assert(ptr != nil)

	interpreter_get()

	// construct args
	dims: [3]npy_intp = {npy_intp(rows), npy_intp(columns), npy_intp(colors)}
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(
		args,
		0,
		PyArray_SimpleNewFromData_NP(colors == 1 ? 2 : 3, &dims[0], type, ptr),
	)

	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_imshow, args, kwargs)
	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)

	if (res == nil) {
		fmt.eprintln("Call to imshow() failed")
	}
	if out != nil do out^ = res
}

imshow_rawptr :: proc(
	ptr: rawptr,
	rows: uint,
	columns: uint,
	colors: uint,
	keywords: Kwargs = nil,
	out: ^PyObject = nil,
) {
	assert(ptr != nil)
	imshow_impl(ptr, NPY_TYPES.NPY_UBYTE, rows, columns, colors, keywords, out)
}

imshow_floatptr :: proc(
	ptr: []f32,
	rows: uint,
	columns: uint,
	colors: uint,
	keywords: Kwargs = nil,
	out: ^PyObject = nil,
) {
	assert(len(ptr) > 0)
	imshow_impl(&ptr[0], NPY_TYPES.NPY_FLOAT, rows, columns, colors, keywords, out)
}

imshow :: proc {
	imshow_floatptr,
	imshow_rawptr,
	imshow_impl,
}


colorbar :: proc(mappable: PyObject, keywords: Kwargs = nil) -> (ok: bool) {
	ok = mappable != nil
	if !ok {
		fmt.eprintln(
			"Must call colorbar with PyObject* returned from an image, contour, surface, etc.",
		)
	}


	interpreter_get()

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, mappable)

	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_colorbar, args, kwargs)

	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to colorbar() failed.")
		return
	}

	Py_DecRef(res)
	return
}


contour_slice :: proc(
	x: $T/[][]$E,
	y: $T1/[][]$E1,
	z: $T2/[][]$E2,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_2darray(x)
	yarray: PyObject = get_2darray(y)
	zarray: PyObject = get_2darray(z)

	ok = contour_impl(xarray, yarray, zarray, keywords)
	return
}

contour_dyn :: proc(
	x: $T/[dynamic][dynamic]$E,
	y: $T1/[dynamic][dynamic]$E1,
	z: $T2/[dynamic][dynamic]$E2,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_2darray(x)
	yarray: PyObject = get_2darray(y)
	zarray: PyObject = get_2darray(z)

	ok = contour_impl(xarray, yarray, zarray, keywords)
	return
}

contour_raw :: proc(
	x: $T/[]$E,
	y: $T1/[]$E1,
	z: $T2/[]$E2,
	rows: uint,
	cols: uint,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_2darray(x, rows, cols)
	yarray: PyObject = get_2darray(y, rows, cols)
	zarray: PyObject = get_2darray(z, rows, cols)

	ok = contour_impl(xarray, yarray, zarray, keywords)
	return
}

@(private = "package")
contour_impl :: proc(
	xarray: PyObject,
	yarray: PyObject,
	zarray: PyObject,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) {
	// construct positional args
	args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, yarray)
	PyTuple_SetItem(args, 2, zarray)

	// Build up the kw args.
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	python_colormap_coolwarm: PyObject = PyObject_GetAttrString(
		interpreter_get().s_python_colormap,
		"coolwarm",
	)

	PyDict_SetItemString(kwargs, "cmap", python_colormap_coolwarm)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_contour, args, kwargs)
	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)
	ok = res != nil
	if !ok {
		fmt.eprintln("failed contour")
		return
	}
	Py_DecRef(res)
	return
}

contour :: proc {
	contour_slice,
	contour_dyn,
	contour_raw,
}


spy_slice :: proc(
	x: $T/[][]$E,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) {
	interpreter_get()
	// using numpy arrays
	xarray: PyObject = get_2darray(x)
	ok = spy_impl(xarray, keywords)
	return

}

spy_dyn :: proc(
	x: $T/[dynamic][dynamic]$E,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) {
	interpreter_get()
	// using numpy arrays
	xarray: PyObject = get_2darray(x)
	ok = spy_impl(xarray, keywords)
	return
}

spy_raw :: proc(
	x: $T/[]$E,
	rows: uint,
	cols: uint,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) {
	interpreter_get()
	// using numpy arrays
	xarray: PyObject = get_2darray(x, rows, cols)
	ok = spy_impl(xarray, keywords)
	return
}

@(private = "package")
spy_impl :: proc(xarray: PyObject, keywords: Kwargs = nil) -> (ok: bool) {
	// Build up the kwargs.
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	plot_args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(plot_args, 0, xarray)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_spy, plot_args, kwargs)

	Py_DecRef(plot_args)
	Py_DecRef(kwargs)
	ok = res != nil
	if !ok {
		fmt.eprintln("failed spy")
		return
	}
	Py_DecRef(res)
	return
}

spy :: proc {
	spy_slice,
	spy_dyn,
	spy_raw,
}

quiver4 :: proc(
	x: $T/[]$E,
	y: $T1/[]$E1,
	u: $T2/[]$E2,
	w: $T3/[]$E3,
	keywords: Kwargs = nil,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) &&
	intrinsics.type_is_numeric(E3) {
	assert(len(x) == len(y) && len(x) == len(u) && len(u) == len(w))

	interpreter_get()

	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)
	uarray: PyObject = get_array(u)
	warray: PyObject = get_array(w)

	plot_args: PyObject = PyTuple_New(4)
	PyTuple_SetItem(plot_args, 0, xarray)
	PyTuple_SetItem(plot_args, 1, yarray)
	PyTuple_SetItem(plot_args, 2, uarray)
	PyTuple_SetItem(plot_args, 3, warray)

	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_quiver, plot_args, kwargs)

	Py_DecRef(kwargs)
	Py_DecRef(plot_args)
	ok = res != nil
	if !ok {
		fmt.eprintln("failed call quiver()")
		return
	}
	Py_DecRef(res)

	return
}

quiver6 :: proc(
	x: $T/[]$E,
	y: $T1/[]$E1,
	z: $T2/[]$E2,
	u: $T3/[]$E3,
	w: $T4/[]$E4,
	v: $T5/[]$E5,
	keywords: Kwargs = nil,
	fig_number: c.long = 0,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) &&
	intrinsics.type_is_numeric(E3) &&
	intrinsics.type_is_numeric(E4) &&
	intrinsics.type_is_numeric(E5) {

	//assert sizes match up
	assert(
		len(x) == len(y) &&
		len(x) == len(u) &&
		len(u) == len(w) &&
		len(x) == len(z) &&
		len(x) == len(v) &&
		len(u) == len(v),
	)

	interpreter_get()

	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)
	zarray: PyObject = get_array(z)
	uarray: PyObject = get_array(u)
	varray: PyObject = get_array(v)
	warray: PyObject = get_array(w)

	args: PyObject = PyTuple_New(6)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, yarray)
	PyTuple_SetItem(args, 2, zarray)
	PyTuple_SetItem(args, 3, uarray)
	PyTuple_SetItem(args, 4, varray)
	PyTuple_SetItem(args, 5, warray)

	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}


	fig_args: PyObject = PyTuple_New(1)
	fig: PyObject
	PyTuple_SetItem(fig_args, 0, PyLong_FromLong(fig_number))
	fig_exists: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_fignum_exists,
		fig_args,
	)
	if (PyObject_IsTrue(fig_exists) == 0) {
		fig = PyObject_CallObject(
			interpreter_get().s_python_function_figure,
			interpreter_get().s_python_empty_tuple,
		)
	} else {
		fig = PyObject_CallObject(interpreter_get().s_python_function_figure, fig_args)
	}
	Py_DecRef(fig_exists)
	ok = fig != nil
	if (!ok) {
		fmt.eprintln("Call to figure() failed.")
		return
	}

	gca_kwargs: PyObject = PyDict_New()
	PyDict_SetItemString(gca_kwargs, "projection", PyString_FromString("3d"))

	add_subplot: PyObject = PyObject_GetAttrString(fig, "add_subplot")
	ok = add_subplot != nil
	if (!ok) {
		fmt.eprintln("No add_subplot")
		return
	}
	Py_IncRef(add_subplot)

	axis: PyObject = PyObject_Call(add_subplot, interpreter_get().s_python_empty_tuple, gca_kwargs)

	ok = axis != nil
	if (!ok) {
		fmt.eprintln("No axis")
		return
	}
	Py_IncRef(axis)

	Py_DecRef(add_subplot)
	Py_DecRef(gca_kwargs)

	plot3: PyObject = PyObject_GetAttrString(axis, "quiver")
	ok = plot3 != nil
	if (!ok) {
		fmt.eprintln("No 3D quiver")
		return
	}
	Py_IncRef(plot3)
	res: PyObject = PyObject_Call(plot3, args, kwargs)

	Py_DecRef(plot3)
	Py_DecRef(axis)
	Py_DecRef(args)

	ok = res != nil
	if (!ok) {
		fmt.eprintln("failed call quiver() in 3d")
		return
	}

	if keywords == nil do Py_DecRef(kwargs)
	Py_DecRef(res)
	return

}

quiver :: proc {
	quiver4,
	quiver6,
}

fill_between :: proc(
	x: $T/[]$E,
	y1: $T1/[]$E1,
	y2: $T2/[]$E2,
	keywords: Kwargs,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) &&
	intrinsics.type_is_numeric(E2) {
	assert(len(x) == len(y1))
	assert(len(x) == len(y2))

	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_array(x)
	y1array: PyObject = get_array(y1)
	y2array: PyObject = get_array(y2)

	// construct positional args
	args: PyObject = PyTuple_New(3)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, y1array)
	PyTuple_SetItem(args, 2, y2array)

	// construct keyword args
	kwargs: PyObject = PyObject(keywords)

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_fill_between, args, kwargs)

	Py_DecRef(args)
	Py_DecRef(kwargs)
	ok = res != nil
	if !ok {
		fmt.eprintln("failed fill_between")
		return
	}
	Py_DecRef(res)
	return
}


fill :: proc(
	x: $T/[]$E,
	y: $T1/[]$E1,
	keywords: Kwargs,
) -> (
	ok: bool,
) where intrinsics.type_is_numeric(E) &&
	intrinsics.type_is_numeric(E1) {
	assert(len(x) == len(y))

	interpreter_get()

	// using numpy arrays
	xarray: PyObject = get_array(x)
	yarray: PyObject = get_array(y)

	// construct positional args
	args: PyObject = PyTuple_New(2)
	PyTuple_SetItem(args, 0, xarray)
	PyTuple_SetItem(args, 1, yarray)

	// construct keyword args
	kwargs: PyObject
	if keywords != nil {
		kwargs = PyObject(keywords)
	} else {
		kwargs = PyDict_New()
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_fill, args, kwargs)

	Py_DecRef(args)
	if keywords == nil do Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("failed contour")
		return
	}
	Py_DecRef(res)
	return
}

set_aspect :: proc(ratio: $T) -> (ok: bool) where intrinsics.type_is_numeric(T) {
	interpreter_get()

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, PyFloat_FromDouble(ratio))
	kwargs: PyObject = PyDict_New()

	ax: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_gca,
		interpreter_get().s_python_empty_tuple,
	)

	ok = ax != nil
	if !ok {
		fmt.eprintln("Call to gca() failed.")
		return
	}
	Py_IncRef(ax)

	set_aspect: PyObject = PyObject_GetAttrString(ax, "set_aspect")
	ok = set_aspect != nil
	if (!ok) {
		fmt.eprintln("Attribute set_aspect not found.")
		return
	}
	Py_IncRef(set_aspect)

	res: PyObject = PyObject_Call(set_aspect, args, kwargs)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to set_aspect() failed.")
		return
	}
	Py_DecRef(set_aspect)

	Py_DecRef(ax)
	Py_DecRef(args)
	Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}

set_aspect_equal :: proc() -> (ok: bool) {
	// expect ratio == "equal". Leaving error handling to matplotlib.
	interpreter_get()

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, PyString_FromString("equal"))
	kwargs: PyObject = PyDict_New()

	ax: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_gca,
		interpreter_get().s_python_empty_tuple,
	)

	ok = ax != nil
	if !ok {
		fmt.eprintln("Call to gca() failed.")
		return
	}
	Py_IncRef(ax)

	set_aspect: PyObject = PyObject_GetAttrString(ax, "set_aspect")
	ok = set_aspect != nil
	if (!ok) {
		fmt.eprintln("Attribute set_aspect not found.")
		return
	}
	Py_IncRef(set_aspect)

	res: PyObject = PyObject_Call(set_aspect, args, kwargs)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to set_aspect() failed.")
		return
	}
	Py_DecRef(set_aspect)

	Py_DecRef(ax)
	Py_DecRef(args)
	Py_DecRef(kwargs)
	Py_DecRef(res)
	return
}

xkcd :: proc() -> (ok: bool) {
	interpreter_get()

	kwargs: PyObject = PyDict_New()
	res: PyObject = PyObject_Call(
		interpreter_get().s_python_function_xkcd,
		interpreter_get().s_python_empty_tuple,
		kwargs,
	)

	Py_DecRef(kwargs)

	ok = res != nil

	if !ok {
		fmt.eprintln("Call to show() failed.")
		return
	}
	Py_DecRef(res)
	return
}

pause :: proc(interval: $T) -> (ok: bool) where intrinsics.type_is_numeric(T) {
	interpreter_get()

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, PyFloat_FromDouble(f64(interval)))

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_pause, args)
	Py_DecRef(args)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to pause() failed.")
		return
	}

	Py_DecRef(res)
	return
}

grid :: proc(flag: bool) -> (ok: bool) {
	interpreter_get()

	pyflag: PyObject = PyBool_FromLong(c.long(flag))
	Py_IncRef(pyflag)

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pyflag)

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_grid, args)
	Py_DecRef(args)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to grid() failed.")
		return
	}
	Py_DecRef(res)
	Py_DecRef(pyflag)
	return
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
		py_false: PyObject = PyBool_FromLong(c.long(block))
		PyDict_SetItemString(kwargs, "block", py_false)
		res = PyObject_Call(
			interpreter_get().s_python_function_show,
			interpreter_get().s_python_empty_tuple,
			kwargs,
		)
		Py_DecRef(kwargs)
		Py_DecRef(py_false)
	}

	ok = true
	if (res == nil) {
		fmt.eprintln("Call to show() failed.")
		ok = false
	}

	Py_DecRef(res)
	return
}

ion :: proc() -> (ok: bool) {
	interpreter_get()

	res: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_ion,
		interpreter_get().s_python_empty_tuple,
	)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to ion() failed.")
		return
	}

	Py_DecRef(res)
	return
}

draw :: proc() -> (ok: bool) {
	interpreter_get()

	res: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_draw,
		interpreter_get().s_python_empty_tuple,
	)

	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to draw() failed.")
		return
	}

	Py_DecRef(res)
	return
}

axis :: proc(axisstr: string) -> (ok: bool) {
	interpreter_get()

	axiscstr := strings.clone_to_cstring(axisstr)
	defer delete(axiscstr)
	str: PyObject = PyString_FromString(axiscstr)
	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, str)

	res: PyObject = PyObject_CallObject(interpreter_get().s_python_function_axis, args)
	ok = res != nil
	if (!ok) {
		fmt.eprintln("Call to title() failed.")
		return
	}

	Py_DecRef(args)
	Py_DecRef(res)
	return
}

save :: proc(filename: string, dpi: i64 = 0) -> (ok: bool) {
	interpreter_get()

	cfilename := strings.clone_to_cstring(filename)
	defer delete(cfilename)
	pyfilename: PyObject = PyString_FromString(cfilename)

	args: PyObject = PyTuple_New(1)
	PyTuple_SetItem(args, 0, pyfilename)

	kwargs: PyObject = PyDict_New()

	if (dpi > 0) {
		PyDict_SetItemString(kwargs, "dpi", PyLong_FromLong(c.long(dpi)))
	}

	res: PyObject = PyObject_Call(interpreter_get().s_python_function_save, args, kwargs)

	Py_DecRef(args)
	Py_DecRef(kwargs)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to save() failed.")
		return
	}

	Py_DecRef(res)
	return
}


close :: proc() -> (ok: bool) {
	interpreter_get()

	res: PyObject = PyObject_CallObject(
		interpreter_get().s_python_function_close,
		interpreter_get().s_python_empty_tuple,
	)

	ok = res != nil
	if !ok {
		fmt.eprintln("Call to close() failed.")
		return
	}

	Py_DecRef(res)
	return
}


main :: proc() {

	interp := interpreter_get()
	interp2 := interpreter_get()
	fmt.printfln("Interpreters: %p == %p is %t", interp, interp2, interp == interp2)

	interpreter_delete(interp)

}
