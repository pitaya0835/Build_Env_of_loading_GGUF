# WSL2で実績のあるPyTorchの安定版を土台にする
FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# ★ここを追加：GitHub Actions（オンライン）の時点でC++ライブラリを最新にしておく
RUN conda install -y -c conda-forge libstdcxx-ng

# llama-cpp-pythonの公式完成品をインストール
RUN pip install --no-cache-dir llama-cpp-python \
    --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu121
