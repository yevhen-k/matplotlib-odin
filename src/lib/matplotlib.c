// Python headers must be included before any system headers, since
// they define _POSIX_C_SOURCE
#include <Python.h>
#include <stdio.h>


#define NPY_NO_DEPRECATED_API NPY_1_7_API_VERSION
#include <numpy/arrayobject.h>

#if PY_MAJOR_VERSION >= 3
#  define PyString_FromString PyUnicode_FromString
#  define PyInt_FromLong PyLong_FromLong
#  define PyString_FromString PyUnicode_FromString
#endif

static const char s_backend[128] = {};

typedef struct Interpreter {
    PyObject* s_python_function_arrow;
    PyObject *s_python_function_show;
    PyObject *s_python_function_close;
    PyObject *s_python_function_draw;
    PyObject *s_python_function_pause;
    PyObject *s_python_function_save;
    PyObject *s_python_function_figure;
    PyObject *s_python_function_fignum_exists;
    PyObject *s_python_function_plot;
    PyObject *s_python_function_quiver;
    PyObject *s_python_function_contour;
    PyObject *s_python_function_semilogx;
    PyObject *s_python_function_semilogy;
    PyObject *s_python_function_loglog;
    PyObject *s_python_function_fill;
    PyObject *s_python_function_fill_between;
    PyObject *s_python_function_hist;
    PyObject *s_python_function_imshow;
    PyObject *s_python_function_scatter;
    PyObject *s_python_function_boxplot;
    PyObject *s_python_function_subplot;
    PyObject *s_python_function_subplot2grid;
    PyObject *s_python_function_legend;
    PyObject *s_python_function_xlim;
    PyObject *s_python_function_ion;
    PyObject *s_python_function_ginput;
    PyObject *s_python_function_ylim;
    PyObject *s_python_function_title;
    PyObject *s_python_function_axis;
    PyObject *s_python_function_axhline;
    PyObject *s_python_function_axvline;
    PyObject *s_python_function_axvspan;
    PyObject *s_python_function_xlabel;
    PyObject *s_python_function_ylabel;
    PyObject *s_python_function_gca;
    PyObject *s_python_function_xticks;
    PyObject *s_python_function_yticks;
    PyObject *s_python_function_margins;
    PyObject *s_python_function_tick_params;
    PyObject *s_python_function_grid;
    PyObject *s_python_function_cla;
    PyObject *s_python_function_clf;
    PyObject *s_python_function_errorbar;
    PyObject *s_python_function_annotate;
    PyObject *s_python_function_tight_layout;
    PyObject *s_python_colormap;
    PyObject *s_python_empty_tuple;
    PyObject *s_python_function_stem;
    PyObject *s_python_function_xkcd;
    PyObject *s_python_function_text;
    PyObject *s_python_function_suptitle;
    PyObject *s_python_function_bar;
    PyObject *s_python_function_barh;
    PyObject *s_python_function_colorbar;
    PyObject *s_python_function_subplots_adjust;
    PyObject *s_python_function_rcparams;
    PyObject *s_python_function_spy;
} Interpreter;

#if PY_MAJOR_VERSION >= 3
void *import_numpy() {
    import_array(); // initialize C-API
    return NULL;
}
#else
void import_numpy() {
    import_array(); // initialize C-API
}
#endif


/// @brief Function to import functions from python module
/// @param module: Python moduel, instance of PyObject *
/// @param fname: name of the function to be imported
/// @return PyObject* : pointer to the imported function or NULL if failed
PyObject *safe_import(PyObject *module, const char* fname);

/// @brief Function to get singleton python matplotlib interpreter. Allocated interpreter
///        should be freed.
/// @return Pointer to the python matplotlib interpreter. NULL if failed.
Interpreter* interpreter_get() {
  static Interpreter *python = NULL;

  if(python == NULL) {
    python = (Interpreter *)malloc(sizeof(Interpreter));

        Py_Initialize();
        
        #if PY_MINOR_VERSION < 11
        
            wchar_t const *dummy_args[] = {L"Python", NULL};  // const is needed because literals must not be modified
            wchar_t const **argv = dummy_args;
            int             argc = sizeof(dummy_args)/sizeof(dummy_args[0])-1;
            PySys_SetArgv(argc, (wchar_t **)(argv));
        
        #else

            PyStatus status;
            PyConfig config;
            PyConfig_InitPythonConfig(&config);
            config.isolated = 1;

            wchar_t const* dummy_args[] = { L"Python", NULL };  // const is needed because literals must not be modified
            wchar_t* const* argv = (wchar_t**)(dummy_args);
            int             argc = sizeof(dummy_args) / sizeof(dummy_args[0]) - 1;
            if (argc && argv) {
                status = PyConfig_SetArgv(&config, argc, argv);
                if (PyStatus_Exception(status)) {
                    PyConfig_Clear(&config);
                }
            }
            status = Py_InitializeFromConfig(&config);
            if (PyStatus_Exception(status)) {
                PyConfig_Clear(&config);
            }
            PyConfig_Clear(&config);
        #endif
        
        import_numpy(); // initialize numpy C-API
        
        PyObject* matplotlibname = PyString_FromString("matplotlib");
        PyObject* pyplotname = PyString_FromString("matplotlib.pyplot");
        PyObject* cmname  = PyString_FromString("matplotlib.cm");
        PyObject* pylabname  = PyString_FromString("pylab");
        if (!pyplotname || !pylabname || !matplotlibname || !cmname) {
            fprintf(stderr, "couldnt create string\n");
            return NULL;
        }
        
        PyObject* matplotlib = PyImport_Import(matplotlibname);
        
        Py_DECREF(matplotlibname);
        if (!matplotlib) {
            PyErr_Print();
            fprintf(stderr, "Error loading module matplotlib!\n");
            return NULL;
        }
        
        // matplotlib.use() must be called *before* pylab, matplotlib.pyplot,
        // or matplotlib.backends is imported for the first time
        if (strlen(s_backend) > 0) {
            PyObject* res = PyObject_CallMethod(matplotlib, "use", "s", s_backend);
            Py_DECREF(res);
        }

        
        PyObject* pymod = PyImport_Import(pyplotname);
        Py_DECREF(pyplotname);
        if (!pymod) { fprintf(stderr, "Error loading module matplotlib.pyplot!\n"); return NULL; }
        
        python->s_python_colormap = PyImport_Import(cmname);
        Py_DECREF(cmname);
        if (!python->s_python_colormap) { fprintf(stderr, "Error loading module matplotlib.cm!\n"); return NULL;}
        
        
        PyObject* pylabmod = PyImport_Import(pylabname);
        Py_DECREF(pylabname);
        if (!pylabmod) { fprintf(stderr, "Error loading module pylab!\n");
          return NULL;
        }

        python->s_python_function_arrow = safe_import(pymod, "arrow");
        assert(python->s_python_function_arrow != NULL);
        
        python->s_python_function_show = safe_import(pymod, "show");
        assert(python->s_python_function_show != NULL);

        python->s_python_function_close = safe_import(pymod, "close");
        assert(python->s_python_function_close != NULL);

        python->s_python_function_draw = safe_import(pymod, "draw");
        assert(python->s_python_function_draw != NULL);

        python->s_python_function_pause = safe_import(pymod, "pause");
        assert(python->s_python_function_pause != NULL);

        python->s_python_function_figure = safe_import(pymod, "figure");
        assert(python->s_python_function_figure != NULL);

        python->s_python_function_fignum_exists = safe_import(pymod, "fignum_exists");
        assert(python->s_python_function_fignum_exists != NULL);

        python->s_python_function_plot = safe_import(pymod, "plot");
        assert(python->s_python_function_plot != NULL);

        python->s_python_function_quiver = safe_import(pymod, "quiver");
        assert(python->s_python_function_quiver != NULL);

        python->s_python_function_contour = safe_import(pymod, "contour");
        assert(python->s_python_function_contour != NULL);

        python->s_python_function_semilogx = safe_import(pymod, "semilogx");
        assert(python->s_python_function_semilogx != NULL);

        python->s_python_function_semilogy = safe_import(pymod, "semilogy");
        assert(python->s_python_function_semilogy != NULL);

        python->s_python_function_loglog = safe_import(pymod, "loglog");
        assert(python->s_python_function_loglog != NULL);

        python->s_python_function_fill = safe_import(pymod, "fill");
        assert(python->s_python_function_fill != NULL);

        python->s_python_function_fill_between = safe_import(pymod, "fill_between");
        assert(python->s_python_function_fill_between != NULL);

        python->s_python_function_hist = safe_import(pymod,"hist");
        assert(python->s_python_function_hist != NULL);

        python->s_python_function_scatter = safe_import(pymod,"scatter");
        assert(python->s_python_function_scatter != NULL);

        python->s_python_function_boxplot = safe_import(pymod,"boxplot");
        assert(python->s_python_function_boxplot != NULL);

        python->s_python_function_subplot = safe_import(pymod, "subplot");
        assert(python->s_python_function_subplot != NULL);

        python->s_python_function_subplot2grid = safe_import(pymod, "subplot2grid");
        assert(python->s_python_function_subplot2grid != NULL);

        python->s_python_function_legend = safe_import(pymod, "legend");
        assert(python->s_python_function_legend != NULL);

        python->s_python_function_xlim = safe_import(pymod, "xlim");
        assert(python->s_python_function_xlim != NULL);

        python->s_python_function_ylim = safe_import(pymod, "ylim");
        assert(python->s_python_function_ylim != NULL);

        python->s_python_function_title = safe_import(pymod, "title");
        assert(python->s_python_function_title != NULL);

        python->s_python_function_axis = safe_import(pymod, "axis");
        assert(python->s_python_function_axis != NULL);

        python->s_python_function_axhline = safe_import(pymod, "axhline");
        assert(python->s_python_function_axhline != NULL);

        python->s_python_function_axvline = safe_import(pymod, "axvline");
        assert(python->s_python_function_axvline != NULL);

        python->s_python_function_axvspan = safe_import(pymod, "axvspan");
        assert(python->s_python_function_axvspan != NULL);

        python->s_python_function_xlabel = safe_import(pymod, "xlabel");
        assert(python->s_python_function_xlabel != NULL);

        python->s_python_function_ylabel = safe_import(pymod, "ylabel");
        assert(python->s_python_function_ylabel != NULL);

        python->s_python_function_gca = safe_import(pymod, "gca");
        assert(python->s_python_function_gca != NULL);

        python->s_python_function_xticks = safe_import(pymod, "xticks");
        assert(python->s_python_function_xticks != NULL);

        python->s_python_function_yticks = safe_import(pymod, "yticks");
        assert(python->s_python_function_yticks != NULL);

        python->s_python_function_margins = safe_import(pymod, "margins");
        assert(python->s_python_function_margins != NULL);

        python->s_python_function_tick_params = safe_import(pymod, "tick_params");
        assert(python->s_python_function_tick_params != NULL);

        python->s_python_function_grid = safe_import(pymod, "grid");
        assert(python->s_python_function_grid != NULL);

        python->s_python_function_ion = safe_import(pymod, "ion");
        assert(python->s_python_function_ion != NULL);

        python->s_python_function_ginput = safe_import(pymod, "ginput");
        assert(python->s_python_function_ginput != NULL);

        python->s_python_function_save = safe_import(pylabmod, "savefig");
        assert(python->s_python_function_save != NULL);

        python->s_python_function_annotate = safe_import(pymod,"annotate");
        assert(python->s_python_function_annotate != NULL);

        python->s_python_function_cla = safe_import(pymod, "cla");
        assert(python->s_python_function_cla != NULL);

        python->s_python_function_clf = safe_import(pymod, "clf");
        assert(python->s_python_function_clf != NULL);

        python->s_python_function_errorbar = safe_import(pymod, "errorbar");
        assert(python->s_python_function_errorbar != NULL);

        python->s_python_function_tight_layout = safe_import(pymod, "tight_layout");
        assert(python->s_python_function_tight_layout != NULL);

        python->s_python_function_stem = safe_import(pymod, "stem");
        assert(python->s_python_function_stem != NULL);

        python->s_python_function_xkcd = safe_import(pymod, "xkcd");
        assert(python->s_python_function_xkcd != NULL);

        python->s_python_function_text = safe_import(pymod, "text");
        assert(python->s_python_function_text != NULL);

        python->s_python_function_suptitle = safe_import(pymod, "suptitle");
        assert(python->s_python_function_suptitle != NULL);

        python->s_python_function_bar = safe_import(pymod,"bar");
        assert(python->s_python_function_bar != NULL);

        python->s_python_function_barh = safe_import(pymod, "barh");
        assert(python->s_python_function_barh != NULL);

        python->s_python_function_colorbar = PyObject_GetAttrString(pymod, "colorbar");
        assert(python->s_python_function_colorbar != NULL);

        python->s_python_function_subplots_adjust = safe_import(pymod,"subplots_adjust");
        assert(python->s_python_function_subplots_adjust != NULL);

        python->s_python_function_rcparams = PyObject_GetAttrString(pymod, "rcParams");
        assert(python->s_python_function_rcparams != NULL);

        python->s_python_function_spy = PyObject_GetAttrString(pymod, "spy");
        assert(python->s_python_function_spy != NULL);


        python->s_python_function_imshow = safe_import(pymod, "imshow");
        assert(python->s_python_function_imshow != NULL);

        python->s_python_empty_tuple = PyTuple_New(0);
    }

    return python;
    
};

/// @brief Dealocates interpreter instance and undo Python initialization 
/// @param python: Interpreter* object to be freed
void interpreter_delete(Interpreter* python) {
    PyRun_SimpleString("print('matplotlib.c: exiting...')");
    free(python);
    Py_Finalize();
}

PyObject* safe_import(PyObject* module, const char* fname) {
    PyObject* fn = PyObject_GetAttrString(module, fname);

    if (!fn) {
        fprintf(stderr, "Couldn't find required function: %s\n", fname);
        return NULL;
    }

    if (!PyFunction_Check(fn)) {
        fprintf(stderr, "%s  is unexpectedly not a PyFunction.\n", fname);
        return NULL;
    }

    return fn;
}

PyObject* PyArray_SimpleNewFromData_NP(int nd, npy_intp* dims, int typenum, void* data) {
    return PyArray_SimpleNewFromData(nd, dims, typenum, data);
}

PyObject * PyArray_SimpleNew_NP(int nd, npy_intp const *dims, int typenum) {
  return PyArray_SimpleNew(nd, dims, typenum);
}

void *PyArray_DATA_NP(const PyArrayObject *arr) {
    return PyArray_DATA(arr);
}