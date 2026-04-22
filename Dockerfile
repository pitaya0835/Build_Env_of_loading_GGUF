# WSL2で実績のあるPyTorch安定版（これのおかげでnvidia-smiは成功しました）
FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel
ENV DEBIAN_FRONTEND=noninteractive

# 必要なビルドツールのインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. Conda特有のリンカーバグを削除（前回成功した回避策）
RUN rm -f /opt/conda/compiler_compat/ld

# 2. ★最強のハック★ GitHub Actions（GPUなし）を騙すためのダミーファイルを配置
# これにより `libcuda.so.1 not found` のビルドエラーが消滅します
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1 || true

# 3. ご自身のRTX 5070 Ti (アーキテクチャ89) 用に自力で完全コンパイル
ENV CMAKE_ARGS="-DGGML_CUDA=on -DCMAKE_CUDA_ARCHITECTURES=89 -DGGML_NATIVE=OFF"
ENV FORCE_CMAKE="1"
RUN pip install --no-cache-dir "llama-cpp-python[server]"
