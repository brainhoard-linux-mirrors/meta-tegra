FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

inherit cuda

def opencv_cuda_flags(d):
    arch = d.getVar('TEGRA_CUDA_ARCHITECTURE')
    if not arch:
        return ''
    return '-DWITH_CUDA=ON -DCUDA_ARCH_BIN="{}.{}" -DCUDA_ARCH_PTX=""'.format(arch[0:1], arch[1:2])

PACKAGECONFIG[cuda] = "${@opencv_cuda_flags(d)},-DWITH_CUDA=OFF,${CUDA_DEPENDS} cudnn"

OPENCV_CUDA_SUPPORT ?= "${@'cuda dnn' if opencv_cuda_flags(d) else ''}"
PACKAGECONFIG:append:cuda = " ${OPENCV_CUDA_SUPPORT}"
EXTRA_OECMAKE:append:cuda = ' -DOPENCV_CUDA_DETECTION_NVCC_FLAGS="-ccbin ${CUDAHOSTCXX}" -DCMAKE_SUPPRESS_REGENERATION=ON'

SRC_URI:append:cuda = " \
    file://0001-Fix-search-paths-in-FindCUDNN.cmake.patch \
    file://0002-Fix-broken-override-of-CUDA_TOOLKIT_TARGET_DIR-setti.patch \
    file://0003-cudaarithm-fix-the-compile-faiure-of-CUDA-12.4.x.patch;patchdir=contrib \
    file://0004-Get-code-to-compile-with-CUDA-12.4.patch;patchdir=contrib \
    file://0005-Merge-pull-request-3607-from-chacha21-cuda_phase_int.patch;patchdir=contrib \
    file://0006-Workaround-for-CUDA-12.6-tuple_size-issue-3773.patch;patchdir=contrib \
    file://0007-Merge-pull-request-3744-from-asmorkalov-as-variadic_.patch;patchdir=contrib \
    file://0008-Merge-pull-request-3751-from-peters-4.x.patch;patchdir=contrib \
    file://0009-Merge-pull-request-25412-from-ZelboK-update-cudnn-to.patch \
    file://0010-Added-branch-with-variadic-version-of-Trust-tuple.patch \
"

OPTICALFLOW_MD5 = "a73cd48b18dcc0cc8933b30796074191"
OPTICALFLOW_HASH = "edb50da3cf849840d680249aa6dbef248ebce2ca"

SRC_URI:append:cuda = " https://github.com/NVIDIA/NVIDIAOpticalFlowSDK/archive/${OPTICALFLOW_HASH}.zip;name=opticalflow;unpack=false;subdir=${OPENCV_DLDIR}/nvidia_optical_flow;downloadfilename=${OPTICALFLOW_MD5}-${OPTICALFLOW_HASH}.zip"

SRC_URI[opticalflow.md5sum] = "${OPTICALFLOW_MD5}"
SRC_URI[opticalflow.sha256sum] = "e300c02e4900741700b2b857965d2589f803390849e1e2022732e02f4ae9be44"

# No stable URI is available for NVIDIAOpticalFlowSDK
INSANE_SKIP:append:cuda = " src-uri-bad"
