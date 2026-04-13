# WSL2で実績のあるPyTorchの安定版を土台にする
FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# ★ここが特効薬：自力コンパイルを回避し、公式の「CUDA 12.1用完成品」をインストールする
RUN pip install --no-cache-dir llama-cpp-python \
    --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu121

# （※Condaのld削除や、CMAKE_ARGSの設定、ninja-buildのインストールすら不要になります）
