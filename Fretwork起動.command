#!/bin/bash
# Fretwork（ギター基礎練習アプリ）起動用
#
# マイク判定を使うにはブラウザの「安全なページ」扱いが必要で、
# index.htmlを直接ダブルクリックする方式（file://）では動かない。
# このスクリプトは簡易サーバーを立ててから http://localhost で開くことで、
# マイクが使える状態にする。
#
# 使い方：このファイルをダブルクリックするだけ。
# 終わるときは開いた黒いウィンドウで Control+C、またはウィンドウを閉じる。

cd "$(dirname "$0")" || exit 1
PORT=8971

# すでに動いていれば流用する（二重起動を防ぐ）
if curl -s -o /dev/null "http://localhost:${PORT}/index.html" 2>/dev/null; then
  echo "すでに起動しています。ブラウザを開きます..."
  open "http://localhost:${PORT}/index.html"
  exit 0
fi

echo "Fretwork を起動します..."
python3 -m http.server "$PORT" > /dev/null 2>&1 &
SERVER_PID=$!

sleep 1
open "http://localhost:${PORT}/index.html"

echo ""
echo "起動しました： http://localhost:${PORT}/index.html"
echo "マイクの許可を聞かれたら「許可」を押してください。"
echo ""
echo "終わるときは Control+C を押すか、このウィンドウを閉じてください。"

# Control+C で確実にサーバーを止める
trap 'kill $SERVER_PID 2>/dev/null; echo "終了しました。"; exit 0' INT TERM
wait $SERVER_PID
