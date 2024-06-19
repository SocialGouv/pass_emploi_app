package fr.fabrique.social.gouv.pass_emploi_app

import android.content.Context
import androidx.lifecycle.LifecycleOwner
import com.poleemploi.matrixlib.Manager.MatrixManager
import com.poleemploi.matrixlib.Manager.SessionManager
import com.poleemploi.matrixlib.Model.Event
import com.poleemploi.matrixlib.Model.EventType
import com.poleemploi.matrixlib.Model.Room

class CvmRepository(
    private val context: Context,
    private val lifecycleOwner: LifecycleOwner,
) {

    private var room: Room? = null
    private var onMessage: (List<Map<String, Any?>>) -> Unit = {}
    private var onRoom: (Boolean) -> Unit = {}

    fun setEventCallback(callback: (List<Map<String, Any?>>) -> Unit) {
        this.onMessage = callback
    }

    fun setRoomsCallback(callback: (Boolean) -> Unit) {
        this.onRoom = callback
    }

    fun initCvm() {
        MatrixManager.initContext(context)
    }

    fun login(ex160: String, token: String, onResult: (Boolean) -> Unit) {
        try {
            MatrixManager.getInstance().loginAndStartSession(token, ex160)
            onResult(true)
        } catch (ignored: Exception) {
            onResult(false)
        }
    }

    fun joinFirstRoom(onResult: (Boolean) -> Unit) {
        MatrixManager.getInstance().joinFirstRoom(lifecycleOwner) {
            this.room = it
            onResult(true)
        }
    }

    suspend fun sendMessage(message: String, callback: (Boolean) -> Unit) {
        this.room?.let { room ->
            MatrixManager.getInstance().sendMessage(
                room.id!!,
                message,
                { _: String -> callback(true) },
                { _: Int, _: String -> callback(false) }
            )
        } ?: callback(false)
    }


    fun startListenMessages(callback: (Boolean) -> Unit) {
        if (this.room == null) {
            callback(false)
            return
        }
        MatrixManager.getInstance().startListenMessage(room!!.id!!) { events ->
            val allMessages = events.map { event ->
                mapOf(
                    "id" to event.eventId,
                    "type" to stringify(event.eventType),
                    "isFromUser" to (event.senderId == SessionManager.matrixUserId),
                    "message" to event.message,
                    "fileInfo" to event.url,
                    "date" to event.date?.time,
                    "readByConseiller" to event.readByConseiller(),
                    "readByJeune" to event.readByJeune()
                )
            }
            this.onMessage(allMessages)
        }
        callback(true)
    }

    fun loadMore(limit: Int, callback: (Boolean) -> Unit) {
        if (MatrixManager.getInstance().hasMoreMessages == true) {
            MatrixManager.getInstance().loadMoreMessages(limit)
        }
        callback(true)
    }

    suspend fun markAsRead(eventId: String, callback: (Boolean) -> Unit) {
        this.room?.let { room ->
            MatrixManager.getInstance().markAsRead(room.id!!, eventId)
            callback(true)
        } ?: callback(false)
    }

    fun stopListenMessage() {
        MatrixManager.getInstance().stopListenMessage()
    }

    fun startListenRoom() {
        MatrixManager.getInstance().startRoomListener(lifecycleOwner) { rooms ->
            this.room = rooms.firstOrNull()
            this.onRoom(this.room != null)
        }
    }

    fun stopListenRoom() {
        MatrixManager.getInstance().stopRoomListener(lifecycleOwner)
    }

    fun logout() {
        MatrixManager.getInstance().stopSession()
        this.room = null
    }
}

private fun stringify(eventType: EventType): String {
    return when (eventType) {
        EventType.MESSAGE -> "message"
        EventType.FILE -> "file"
        EventType.IMAGE -> "image"
        EventType.TYPING -> "typing"
        else -> "unknown"
    }
}

private fun Event.readByConseiller(): Boolean {
    println("🚀🚀🚀 CvmRepository.kotlin#message ->  $message")
    println("🚀🚀🚀 CvmRepository.kotlin#readBy ->  $readBy")
    val readByConseiller = readBy?.filterNot { it == SessionManager.matrixUserId }?.isNotEmpty() == true
    println("🚀🚀🚀 CvmRepository.kotlin#readByConseiller ->  $readByConseiller")
    println("🚀🚀🚀 ----------")
    return readByConseiller
}

private fun Event.readByJeune(): Boolean {
    return readBy?.any { it == SessionManager.matrixUserId } == true
}
