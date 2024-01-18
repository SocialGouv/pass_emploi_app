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
) : MethodCallHandler {

    companion object {
        const val CHANNEL = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods"
    }

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        //TODO: result true quand c'est ok
        //TODO: result du booléen success donné par les callback de startListenMessages et sendMessage
        when (call.method) {
            "initializeCvm" -> {
                cvmRepository.initCvm()
                result.success(null)
            }
            "startListenMessages" -> {
                val ex160: String = call.argument("ex160") ?: run {
                    result.error("ARGUMENT_ERROR", "ex160 is missing", null)
                    return
                }
                val token: String = call.argument("token") ?: run {
                    result.error("ARGUMENT_ERROR", "Token is missing", null)
                    return
                }
                cvmRepository.startListenMessages(ex160, token)
                result.success(null)
            }
            "stopListenMessages" -> {
                cvmRepository.stopListenMessage()
                result.success(null)
            }
            "sendMessage" -> {
                val message: String = call.argument("message") ?: run {
                    result.error("ARGUMENT_ERROR", "Message is missing", null)
                    return
                }
                CoroutineScope(Dispatchers.IO).launch {
                    sendMessage(message, result)
                }
            }
            "loadMore" -> {
                cvmRepository.loadMore()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private suspend fun sendMessage(message: String, result: Result) {
        cvmRepository.sendMessage(message)
        result.success(null)
    }
}
