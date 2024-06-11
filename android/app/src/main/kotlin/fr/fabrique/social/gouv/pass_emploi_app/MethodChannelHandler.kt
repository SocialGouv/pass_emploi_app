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
    flutterEngine: FlutterEngine,
    private val cvmRepository: CvmRepository,
) : MethodCallHandler {

    companion object {
        const val CHANNEL = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods"
    }

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initializeCvm" -> initializeCvm(result)
            "login" -> login(call, result)
            "joinFirstRoom" -> joinFirstRoom(result)
            "startListenRoom" -> startListenRoom(result)
            "stopListenRoom" -> stopListenRoom(result)
            "startListenMessages" -> startListenMessages(result)
            "stopListenMessages" -> stopListenMessages(result)
            "sendMessage" -> sendMessage(call, result)
            "loadMore" -> loadMore(call, result)
            "markAsRead" -> markAsRead(call, result)
            "logout" -> logout(result)
            else -> result.notImplemented()
        }
    }

    private fun initializeCvm(result: Result) {
        cvmRepository.initCvm()
        result.success(true)
    }

    private fun login(call: MethodCall, result: Result) {
        val ex160: String = call.argument("ex160") ?: run {
            result.error("ARGUMENT_ERROR", "ex160 is missing", null)
            return
        }
        val token: String = call.argument("token") ?: run {
            result.error("ARGUMENT_ERROR", "Token is missing", null)
            return
        }

        cvmRepository.login(ex160, token) { success ->
            result.success(success)
        }
    }

    private fun joinFirstRoom(result: Result) {
        cvmRepository.joinFirstRoom { success ->
            result.success(success)
        }
    }

    private fun startListenRoom(result: Result) {
        cvmRepository.startListenRoom()
        result.success(true)
    }

    private fun stopListenRoom(result: Result) {
        cvmRepository.stopListenRoom()
        result.success(true)
    }

    private fun startListenMessages(result: Result) {
        cvmRepository.startListenMessages { success ->
            result.success(success)
        }
    }

    private fun stopListenMessages(result: Result) {
        cvmRepository.stopListenMessage()
        result.success(true)
    }

    private fun sendMessage(call: MethodCall, result: Result) {
        val message: String = call.argument("message") ?: run {
            result.error("ARGUMENT_ERROR", "Message is missing", null)
            return
        }
        CoroutineScope(Dispatchers.IO).launch {
            cvmRepository.sendMessage(message) {success ->
                result.success(success)
            }
        }
    }

    private fun loadMore(call: MethodCall, result: Result) {
        val limit: Int = call.argument("limit") ?: run {
            result.error("ARGUMENT_ERROR", "Limit is missing", null)
            return
        }
        cvmRepository.loadMore(limit) { success ->
            result.success(success)
        }
    }

    private fun markAsRead(call: MethodCall, result: Result) {
        val eventId: String = call.argument("eventId") ?: run {
            result.error("ARGUMENT_ERROR", "eventId is missing", null)
            return
        }
        CoroutineScope(Dispatchers.IO).launch {
            cvmRepository.markAsRead(eventId) { success ->
                result.success(success)
            }
        }
    }

    private fun logout(result: Result) {
        cvmRepository.logout()
        result.success(true)
    }
}
