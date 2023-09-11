package com.example.udpconnect

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.example.udpconnect.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private var receiveMessage = "受信したメッセージ"
    private var stateText = "受信開始前です"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        binding = ActivityMainBinding.inflate(layoutInflater)
        val view = binding.root
        setContentView(view)
    }

    fun onClickSendButton(){

    }

    fun onClickStartReceiveButton(){

    }

    fun onClickEndReceiveButton(){

    }
}