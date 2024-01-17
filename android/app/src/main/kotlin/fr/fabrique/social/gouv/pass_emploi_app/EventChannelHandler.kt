package fr.fabrique.social.gouv.pass_emploi_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

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
        cvmRepository.setCallback { messages -> eventsSink?.success(messages) }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventsSink = events
    }

    override fun onCancel(arguments: Any?) {
        cvmRepository.stopListenMessage()
        eventsSink = null
    }
}
