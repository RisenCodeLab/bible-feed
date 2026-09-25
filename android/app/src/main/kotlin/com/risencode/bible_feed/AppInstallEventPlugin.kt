package com.risencode.bible_feed

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel

class AppInstallEventPlugin : FlutterPlugin {
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel = EventChannel(binding.binaryMessenger, "com.risencode.bible_feed/app_install_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            private var receiver: BroadcastReceiver? = null

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val filter = IntentFilter().apply {
                    addAction(Intent.ACTION_PACKAGE_ADDED)
                    addAction(Intent.ACTION_PACKAGE_REMOVED)
                    addDataScheme("package")
                }
                receiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        val packageName = intent?.data?.schemeSpecificPart ?: return
                        when (intent.action) {
                            Intent.ACTION_PACKAGE_ADDED -> events?.success("AppInstalled:$packageName")
                            Intent.ACTION_PACKAGE_REMOVED -> events?.success("AppUninstalled:$packageName")
                        }
                    }
                }
                binding.applicationContext.registerReceiver(receiver, filter)
            }

            override fun onCancel(arguments: Any?) {
                receiver?.let { binding.applicationContext.unregisterReceiver(it) }
                receiver = null
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel.setStreamHandler(null)
    }
}
