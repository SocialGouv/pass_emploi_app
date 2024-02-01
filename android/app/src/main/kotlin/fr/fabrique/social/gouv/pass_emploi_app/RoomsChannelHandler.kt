package fr.fabrique.social.gouv.pass_emploi_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class RoomsChannelHandler(
    private val flutterEngine: FlutterEngine,
    private val cvmRepository: CvmRepository
) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms"
    }

    private var eventsSink: EventChannel.EventSink? = null

    fun initialize() {
        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        eventChannel.setStreamHandler(this)
        cvmRepository.setRoomsCallback { hasRoom -> eventsSink?.success(hasRoom) }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventsSink = events
    }

    override fun onCancel(arguments: Any?) {
        cvmRepository.stopListenRoom()
        eventsSink = null
    }
}
