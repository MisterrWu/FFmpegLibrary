package com.wh.ffmpeglibrary

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Example of a call to a native method
        sample_text.text = stringFromJNI()
        protocol.setOnClickListener { sample_text.text = urlprotocolinfo() }
        format.setOnClickListener{ sample_text.text = avformatinfo() }
        codec.setOnClickListener { sample_text.text = avcodecinfo() }
        filter.setOnClickListener { sample_text.text = avfilterinfo() }
    }

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    external fun stringFromJNI(): String
    external fun urlprotocolinfo(): String
    external fun avformatinfo(): String
    external fun avcodecinfo(): String
    external fun avfilterinfo(): String

    companion object {

        // Used to load the 'native-lib' library on application startup.
        init {
            System.loadLibrary("avutil")
            System.loadLibrary("swresample")
            System.loadLibrary("swscale")
            System.loadLibrary("avformat")
            System.loadLibrary("avcodec")
            System.loadLibrary("avfilter")
            System.loadLibrary("native-lib")
        }
    }
}
