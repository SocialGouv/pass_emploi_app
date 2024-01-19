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
    private var callback: (List<Map<String, Any>>) -> Unit = {}

    fun setCallback(callback: (List<Map<String, Any>>) -> Unit) {
        this.callback = callback
    }

    fun initCvm() {
        MatrixManager.initContext(context)
    }

    fun startListenMessages(ex160: String, token: String): Boolean {
        MatrixManager.getInstance().loginAndStartSession(token, ex160)
        var isSuccess = false
        MatrixManager.getInstance().joinFirstRoom(lifecycleOwner) {
                this.room = it
                listenMessage()
                isSuccess = true
        }
        return isSuccess
    }

    suspend fun sendMessage(message: String): Boolean {
        return this.room?.let {
            var isSuccess = false
            MatrixManager.getInstance().sendMessage(
                room!!.id!!,
                message,
                { _: String -> isSuccess = true },
                { _: Int, _: String -> isSuccess = false }
            )
            isSuccess
        } ?: false
    }


    private fun listenMessage() {
        MatrixManager.getInstance().startListenMessage(room!!.id!!) { events ->
            val allMessages = events.map { event ->
                mapOf(
                    "id" to (event.eventId ?: ""),
                    "isFromUser" to (event.senderId == SessionManager.matrixUserId),
                    "content" to (event.message ?: ""),
                    "date" to (event.date?.time ?: 0L)
                )
            }
            this.callback(allMessages)
        }
    }

    fun loadMore() {
        if (MatrixManager.getInstance().hasMoreMessages == true) {
            MatrixManager.getInstance().loadMoreMessages(20)
        }
    }

    fun stopListenMessage() {
        MatrixManager.getInstance().stopListenMessage()
        MatrixManager.getInstance().stopSession()
        this.room = null
    }

}