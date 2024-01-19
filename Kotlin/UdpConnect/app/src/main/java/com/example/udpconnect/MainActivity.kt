package com.example.udpconnect
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.util.Log

class MainActivity : AppCompatActivity() {
    private lateinit var textView: TextView

    // ネイティブライブラリのロード
    init {
        System.loadLibrary("native-lib")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        textView = findViewById(R.id.text_view)

        val sendButton: Button = findViewById(R.id.send_button)
        val receiveButton: Button = findViewById(R.id.receive_button)

        setCallback(
            { message -> debugCallback(message) },
            { message, length, flags -> receiveCallback(message, length, flags) },
            { message -> startCallback(message) }
        )

        sendButton.setOnClickListener {
            sendUDPMessage("10.0.2.2", 8000, "Hello from Kotlin!")
        }

        receiveButton.setOnClickListener {
            startReceiving()
        }
    }

    // UDPメッセージを送信
    private external fun sendUDPMessage(ip: String, port: Int, message: String)

    // UDPメッセージを受信開始
    private fun startReceiving() {
        preReceiveUDPMessage(8001)
        Thread {
            receiveUDPMessage()
        }.start()
    }

    private fun debugCallback(message: String) {
        runOnUiThread { Log.d("debug",message) }
    }

    private fun receiveCallback(message: String, length: Int, flags: Int) {
        runOnUiThread { textView.text = "Receive: $message" }
    }

    private fun startCallback(message: String) {
        runOnUiThread { Log.d("start",message) }
    }

    // コールバックとその他のネイティブメソッド
    private external fun setCallback(
        debug: CallbackType,
        receive: ReceiveCallbackType,
        start: CallbackType
    )
    private external fun preReceiveUDPMessage(port: Int)
    private external fun receiveUDPMessage()
    private external fun socketClose()

    // KotlinからC++へのコールバックインターフェース
    fun interface CallbackType {
        fun invoke(message: String)
    }

    fun interface ReceiveCallbackType {
        fun invoke(message: String, length: Int, flags: Int)
    }

    // アクティビティ破棄時の処理
    override fun onDestroy() {
        Log.d("debug","onDestroy呼び出し")
        socketClose()
        super.onDestroy()
    }
}