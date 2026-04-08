# CUDAツールキットが含まれたNVIDIA公式イメージを使用
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

# Pythonとビルドツールのインストール
# ★ここに ninja-build を追加しました
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ★追加: GitHub Actions(GPUなし環境)でのビルドエラーを回避するための設定
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64/stubs:${LD_LIBRARY_PATH}"
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1

# GPU (CUDA) サポートを有効にしてllama-cpp-pythonをビルド・インストール
ENV CMAKE_ARGS="-DGGML_CUDA=on -DCMAKE_CUDA_ARCHITECTURES=all"
ENV FORCE_CMAKE="1"
RUN pip3 install --no-cache-dir llama-cpp-python

# 必要なPythonパッケージがあれば追加
# RUN pip3 install ...

# モデル配置用ディレクトリ作成
RUN mkdir -p /app/models
