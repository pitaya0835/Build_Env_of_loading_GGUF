# WSL2で実績のあるPyTorchの安定版を土台にする
FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel
ENV DEBIAN_FRONTEND=noninteractive

# 必要なビルドツールのインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ★ここがPyTorch(Conda)環境特有のバグ回避策★
# 邪魔なCondaのリンカーを削除し、システム標準のものを使わせる
RUN rm -f /opt/conda/compiler_compat/ld

# llama-cpp-pythonのGPUビルド（RTX 5070 Ti用のアーキテクチャ89指定）
ENV CMAKE_ARGS="-DGGML_CUDA=on -DCMAKE_CUDA_ARCHITECTURES=89"
ENV FORCE_CMAKE="1"
RUN pip install --no-cache-dir llama-cpp-python
