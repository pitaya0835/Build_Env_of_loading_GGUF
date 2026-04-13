# ★ここが最大の変更点：WSL2で実績のあるPyTorchの安定版を土台にします
FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel
ENV DEBIAN_FRONTEND=noninteractive

# PyTorchイメージには既にPython等が入っているため、必要なビルドツールだけ追加
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# llama-cpp-pythonのGPUビルド（RTX 5070 Ti用のアーキテクチャ89指定）
ENV CMAKE_ARGS="-DGGML_CUDA=on -DCMAKE_CUDA_ARCHITECTURES=89"
ENV FORCE_CMAKE="1"
RUN pip install --no-cache-dir llama-cpp-python
