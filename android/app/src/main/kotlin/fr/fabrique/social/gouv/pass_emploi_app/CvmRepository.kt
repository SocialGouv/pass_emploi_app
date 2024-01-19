package fr.fabrique.social.gouv.pass_emploi_app

import android.content.Context
import androidx.lifecycle.LifecycleOwner
import com.poleemploi.matrixlib.Manager.MatrixManager
import com.poleemploi.matrixlib.Manager.SessionManager
import com.poleemploi.matrixlib.Model.Room

class CvmRepository(
    private val context: Context,
    private val lifecycleOwner: LifecycleOwner,
) {

    private var room: Room? = null
    private var onMessage: (List<Map<String, Any>>) -> Unit = {}

    fun setCallback(callback: (List<Map<String, Any>>) -> Unit) {
        this.onMessage = callback
    }

    fun initCvm() {
        MatrixManager.initContext(context)
    }

    fun login(ex160: String, token: String, onResult: (Boolean) -> Unit) {
        MatrixManager.getInstance().loginAndStartSession(token, ex160)
        onResult(true)
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
                    "id" to (event.eventId ?: ""),
                    "isFromUser" to (event.senderId == SessionManager.matrixUserId),
                    "content" to (event.message ?: ""),
                    "date" to (event.date?.time ?: 0L)
                )
            }
            this.onMessage(allMessages)
        }
        callback(true)
    }

    fun loadMore(callback: (Boolean) -> Unit) {
        if (MatrixManager.getInstance().hasMoreMessages == true) {
            MatrixManager.getInstance().loadMoreMessages(20)
        }
        callback(true)
    }

    fun stopListenMessage() {
        MatrixManager.getInstance().stopListenMessage()
        MatrixManager.getInstance().stopSession()
        this.room = null
    }

    fun startListenRoom(callback: (Boolean) -> Unit) {
        MatrixManager.getInstance().startRoomListener(lifecycleOwner) { rooms ->
            this.room = rooms.firstOrNull()
            if (this.room != null) {
                callback(true)
            } else {
                callback(false)
            }
        }
    }

    fun stopListenRoom(callback: (Boolean) -> Unit) {
        MatrixManager.getInstance().stopRoomListener(lifecycleOwner)
        callback(true)
    }

}