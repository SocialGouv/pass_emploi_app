package fr.fabrique.social.gouv.pass_emploi_app

import android.content.Context
import androidx.lifecycle.LifecycleOwner
import com.poleemploi.matrixlib.Manager.MatrixManager
import com.poleemploi.matrixlib.Manager.SessionManager
import com.poleemploi.matrixlib.Model.Room

class CvmRepository(
    private val context: Context,
    private val lifecycleOwner: LifecycleOwner
) {

    var room: Room? = null

    fun initCvm(ex160: String, token: String, onInit: () -> Unit) {
        MatrixManager.initContext(context)
        MatrixManager.getInstance().loginAndStartSession(token, ex160)
        MatrixManager.getInstance().joinFirstRoom(lifecycleOwner) {
            this.room = it
            onInit()
        }
    }

    suspend fun sendMessage(message: String) {
        this.room?.let {
            MatrixManager.getInstance().sendMessage(
                room!!.id!!,
                message,
                { a: String -> Unit },
                { a: Int, b: String -> Unit })
        }
    }

    fun listenMessage(callback: (List<Map<String, Any>>) -> Unit) {
        MatrixManager.getInstance().startListenMessage(room!!.id!!) { events ->
            val allMessages = events.map { event ->
                mapOf(
                    "id" to (event.eventId ?: ""),
                    "isFromUser" to (event.senderId == SessionManager.matrixUserId),
                    "content" to (event.message ?: ""),
                    "date" to (event.date?.time ?: 0L)
                )
            }
            callback(allMessages)
        }
    }

    fun stopListenMessage() {
        MatrixManager.getInstance().stopListenMessage()
    }

}