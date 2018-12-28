package com.smugp.spclient

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.core.Core

class MainActivity: FlutterActivity() {
  private val BASE_CHANNEL = "spclient.smugp.com/"
  private val OPENCV_CHANNEL = BASE_CHANNEL + "opencv"

  init {
    System.loadLibrary(Core.NATIVE_LIBRARY_NAME)
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, OPENCV_CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getVersionString") {
        val versionString = Core.getVersionString()
        result.success(versionString)
      } else {
        result.notImplemented()
      }
    }
  }
}
