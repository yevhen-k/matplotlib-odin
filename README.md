# Matplotlib.odin

This project binds Matplotlib library to the Odin language.

This is initial stage of the project and testing the idea on linux and python3.10. Other version of python and OS will be added later.

The idea is completely stolen from [lava/matplotlib-cpp](https://github.com/lava/matplotlib-cpp)

## Quick start

Initialize venv:
```bash
PY_VER=3.10 make python
```

Source venv:
```bash
source venv3.10/bin/activate
```

Compile and run sample:
```bash
PY_VER=3.10 make all
PY_VER=3.10 make animation
./build/bin/animation
```
![](./examples/animation.gif)

## References:
- https://docs.python.org/3.10/extending/embedding.html
- https://docs.python.org/3/c-api/init_config.html#init-config