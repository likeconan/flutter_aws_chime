package com.oneplusdream.flutter_aws_chime

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAwsChimePlugin */
class FlutterAwsChimePlugin : FlutterPlugin, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var methodChannel: MethodChannelCoordinator
    private lateinit var binaryMessenger: BinaryMessenger

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        flutterPluginBinding.platformViewRegistry.registerViewFactory("videoTile", FlutterVideoTileFactory())
        binaryMessenger = flutterPluginBinding.binaryMessenger;

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {


    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        methodChannel = MethodChannelCoordinator(binaryMessenger, binding.activity);
        methodChannel?.setupMethodChannel()
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }


}
