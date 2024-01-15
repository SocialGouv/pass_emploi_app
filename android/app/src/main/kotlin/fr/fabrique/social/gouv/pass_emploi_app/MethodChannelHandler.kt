package fr.fabrique.social.gouv.pass_emploi_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MethodChannelHandler(
    private val flutterEngine: FlutterEngine,
    private val cvmRepository: CvmRepository,
    private val eventChannelHandler: EventChannelHandler,
) : MethodCallHandler {

    companion object {
        const val CHANNEL = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods"
    }

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initializeCvm" -> {
                val token: String = call.argument("token") ?: run {
                    result.error("ARGUMENT_ERROR", "Token is missing", null)
                    return
                }
                initializeCvm(token, result)
            }
            "sendMessage" -> {
                println("🔴 sendMessage")
                val message: String = call.argument("message") ?: run {
                    result.error("ARGUMENT_ERROR", "Message is missing", null)
                    return
                }
                CoroutineScope(Dispatchers.IO).launch {
                    sendMessage(message, result)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun initializeCvm(token: String, result: Result) {
        cvmRepository.initCvm(token, onInit = {
            eventChannelHandler.startListeningMessages()
        })
        result.success(null)
    }

    private suspend fun sendMessage(message: String, result: Result) {
        cvmRepository.sendMessage(message)
        result.success(null)
    }
}
