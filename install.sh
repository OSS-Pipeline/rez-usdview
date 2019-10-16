#!/usr/bin/bash

# Will exit the Bash script the moment any command will itself exit with a non-zero status, thus an error.
set -e

BUILD_PATH=$1
INSTALL_PATH=${REZ_BUILD_INSTALL_PATH}
USDVIEW_VERSION=${REZ_BUILD_PROJECT_VERSION}

# We print the arguments passed to the Bash script.
echo -e "\n"
echo -e "==============="
echo -e "=== INSTALL ==="
echo -e "==============="
echo -e "\n"

echo -e "[INSTALL][ARGS] BUILD PATH: ${BUILD_PATH}"
echo -e "[INSTALL][ARGS] INSTALL PATH: ${INSTALL_PATH}"
echo -e "[INSTALL][ARGS] USDVIEW VERSION: ${USDVIEW_VERSION}"

# We check if the arguments variables we need are correctly set.
# If not, we abort the process.
if [[ -z ${BUILD_PATH} || -z ${INSTALL_PATH} || -z ${USDVIEW_VERSION} ]]; then
    echo -e "\n"
    echo -e "[INSTALL][ARGS] One or more of the argument variables are empty. Aborting..."
    echo -e "\n"

    exit 1
fi

# We install usdview.
echo -e "\n"
echo -e "[INSTALL] Installing usdview-${USDVIEW_VERSION}..."
echo -e "\n"

cd ${BUILD_PATH}

make \
    -j${REZ_BUILD_THREAD_COUNT} \
    install

# We make use of a little Python script to allow the "pxr" Python module to be built from multiple paths.
PXR_PYTHON_INIT_FILE="${INSTALL_PATH}/lib/python/pxr/__init__.py"
PYTHON_EXTEND_MODULE_SCRIPT="\n\
from pkgutil import extend_path\n\
__path__ = extend_path(__path__, __name__)"

if [ ! -f ${PXR_PYTHON_INIT_FILE} ]; then
    echo -e "\n"
    echo -e "[INSTALL][PYTHON] The \"pxr\" Python module \"__init__.py\" file does not exist, and will be created!"

    touch ${PXR_PYTHON_INIT_FILE}
fi

echo -e ${PYTHON_EXTEND_MODULE_SCRIPT} >> ${PXR_PYTHON_INIT_FILE}

echo -e "\n"
echo -e "[INSTALL][PYTHON] The \"pxr\" Python module has been successfully extended!"

echo -e "\n"
echo -e "[INSTALL] Finished installing usdview-${USDVIEW_VERSION}!"
echo -e "\n"
