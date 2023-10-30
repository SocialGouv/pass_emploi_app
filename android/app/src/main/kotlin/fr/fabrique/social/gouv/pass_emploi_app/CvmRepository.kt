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

    fun initCvm(token: String) {
        MatrixManager.initContext(context)
        MatrixManager.getInstance().loginAndStartSession(token, EX_160_URL_NEW)
        MatrixManager.getInstance().joinFirstRoom(lifecycleOwner) {
            room = it
        }
    }

    suspend fun sendMessage(message: String) {
        room?.let {
            MatrixManager.getInstance().sendMessage(
                room!!.id!!,
                message,
                { a: String -> Unit },
                { a: Int, b: String -> Unit })
        }
    }
}