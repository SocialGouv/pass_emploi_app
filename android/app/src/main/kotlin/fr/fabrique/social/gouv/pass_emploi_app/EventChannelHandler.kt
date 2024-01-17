package fr.fabrique.social.gouv.pass_emploi_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class EventChannelHandler(
    private val flutterEngine: FlutterEngine,
    private val cvmRepository: CvmRepository
) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events"
    }

    private var eventsSink: EventChannel.EventSink? = null

    fun initializeEventChannel() {
        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        eventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventsSink = events
    }

    override fun onCancel(arguments: Any?) {
        cvmRepository.stopListenMessage()
        eventsSink = null
    }

    fun startListeningMessages() {
        cvmRepository.listenMessage { messages ->
            //TODO: passer en liste
            messages.forEach { message ->
                eventsSink?.success(message)
            }
        }
    }
}
