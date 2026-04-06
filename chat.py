from llama_cpp import Llama
import sys

# コンテナ内でモデルがマウントされるパスを指定
MODEL_PATH = "/app/models/model.gguf"

try:
    # n_gpu_layers=-1 を追加し、すべてのレイヤーをGPUに割り当てる
    llm = Llama(
        model_path=MODEL_PATH, 
        n_ctx=2048, 
        n_gpu_layers=-1,  # ← これを追加
        verbose=False
    )
except ValueError:
    print(f"[エラー] モデルが見つかりません。{MODEL_PATH} にモデルがマウントされているか確認してください。")
    sys.exit(1)

# システムプロンプト（AIのキャラクター設定）
messages = [
    {"role": "system", "content": "あなたは親切で優秀なAIアシスタントです。日本語で答えてください。"}
]

print("========================================")
print(" GGUF オフラインチャットへようこそ！")
print(" (終了するには 'quit' または 'exit' と入力)")
print("========================================\n")

while True:
    try:
        user_input = input("あなた: ")
        if user_input.lower() in ['quit', 'exit']:
            print("チャットを終了します。")
            break
        if not user_input.strip():
            continue

        # ユーザーの発言を履歴に追加
        messages.append({"role": "user", "content": user_input})

        print("AI: ", end="", flush=True)
        
        # チャットの生成とストリーミング出力
        response = llm.create_chat_completion(
            messages=messages,
            stream=True
        )

        reply_content = ""
        for chunk in response:
            delta = chunk['choices'][0]['delta']
            if 'content' in delta:
                content = delta['content']
                print(content, end="", flush=True)
                reply_content += content
        print("\n")

        # AIの返答を履歴に追加（文脈を維持するため）
        messages.append({"role": "assistant", "content": reply_content})

    except KeyboardInterrupt:
        print("\nチャットを終了します。")
        break
