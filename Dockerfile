# CUDAツールキットが含まれたNVIDIA公式イメージを使用
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

# Pythonとビルドツールのインストール
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# GPU (CUDA) サポートを有効にしてllama-cpp-pythonをビルド・インストール
ENV CMAKE_ARGS="-DGGML_CUDA=on"
ENV FORCE_CMAKE="1"
RUN pip3 install --no-cache-dir llama-cpp-python

# 必要なPythonパッケージがあれば追加
# RUN pip3 install ...

# モデル配置用ディレクトリ作成
RUN mkdir -p /app/models

# ※ Dev Containerで使用するため ENTRYPOINT は記述しません
