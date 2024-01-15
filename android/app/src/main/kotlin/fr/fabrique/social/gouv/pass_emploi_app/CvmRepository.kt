package fr.fabrique.social.gouv.pass_emploi_app

import android.content.Context
import androidx.lifecycle.LifecycleOwner
import com.poleemploi.matrixlib.Manager.MatrixManager
import com.poleemploi.matrixlib.Manager.SessionManager
import com.poleemploi.matrixlib.Model.Room



private const val EX_160_URL_NEW =
    "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ"

class CvmRepository(
    private val context: Context,
    private val lifecycleOwner: LifecycleOwner
) {

    var room: Room? = null

    fun initCvm(token: String, onInit: () -> Unit) {
        MatrixManager.initContext(context)
        MatrixManager.getInstance().loginAndStartSession(token, EX_160_URL_NEW)
        MatrixManager.getInstance().joinFirstRoom(lifecycleOwner) {
            this.room = it
            println("✅ init done ${room?.id}")
            onInit()
        }
    }

    suspend fun sendMessage(message: String) {
        try {
            this.room?.let {
                MatrixManager.getInstance().sendMessage(
                    room!!.id!!,
                    message,
                    { a: String -> Unit },
                    { a: Int, b: String -> Unit })
            }
        } catch (e: Exception) {
            print("🔴 sendMessage error: $e")
        }
    }

    fun listenMessage(callback: (List<Map<String, Any>>) -> Unit) {
       try {
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
       } catch (e: Exception) {
           print("🔴 listenMessage error: $e")
       }
    }

    fun stopListenMessage() {
        MatrixManager.getInstance().stopListenMessage()
    }

}