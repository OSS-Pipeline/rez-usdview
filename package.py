name = "usdview"

version = "19.07"

authors = [
    "Pixar"
]

description = \
    """
    usdview is the most fully-featured USD tool, combining interactive gl preview, scenegraph navigation and
    introspection, a (growing) set of diagnostic and debugging facilities, and an interactive python interpreter.
    """

requires = [
    "cmake-3+",
    "gcc-6+",
    "usd-{version}".format(version=str(version))
]

variants = [
    ["platform-linux"]
]

tools = [
    "testusdview",
    "usdview"
]

build_system = "cmake"

with scope("config") as config:
    config.build_thread_count = "logical_cores"

uuid = "usdview-{version}".format(version=str(version))

def commands():
    env.PATH.prepend("{root}/bin")
    env.LD_LIBRARY_PATH.prepend("{root}/lib")
    env.PYTHONPATH.prepend("{root}/lib/python")

    # Helper environment variables.
    env.USDVIEW_BINARY_PATH.set("{root}/bin")
    env.USDVIEW_INCLUDE_PATH.set("{root}/include")
    env.USDVIEW_LIBRARY_PATH.set("{root}/lib")
