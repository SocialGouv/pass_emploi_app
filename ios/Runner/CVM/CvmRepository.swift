import Foundation
import BenedicteSDK

typealias EventJson = Dictionary<String, Any>
typealias EventsReceived = ([EventJson]) -> Void
typealias RoomsReceived = (Bool) -> Void
typealias SuccessCompletion = (Bool) -> Void
typealias VoidCompletion = () -> Void

class CvmRepository {
    
    private var room: Room?
    private var onMessages: EventsReceived?
    private var onHasRooms: RoomsReceived?
    
    func initializeCvm(limit: Int) {
        MatrixManager.sharedInstance.initialize(paginationPageSize: limit)
    }
    
    func setMessageCallback(_ onMessages: @escaping EventsReceived) {
        self.onMessages = onMessages
    }
    
    func setHasRoomCallback(_ onHasRooms: @escaping RoomsReceived) {
        self.onHasRooms = onHasRooms
    }

    func login(token: String, ex160Url: String, completion: @escaping SuccessCompletion) {
        MatrixManager.sharedInstance.loginAndStartSession(accessToken: token, oauthServer: ex160Url, completion: completion)
    }

    func joinFirstRoom(completion: @escaping SuccessCompletion) {
        MatrixManager.sharedInstance.joinFirstRoom { [weak self] room in
            self?.room = room
            completion(room != nil)
        }
    }
    
    func startListenMessages(completion: @escaping SuccessCompletion) {
        guard let room = self.room else {
            completion(false)
            return
        }

        MatrixManager.sharedInstance.startMessageListener(room: room) { [weak self] events in
            self?.onMessages?(events.map { $0.toJson() })
        }
        completion(true)
    }
    
    func stopListenMessages() {
        if let room = room {
            MatrixManager.sharedInstance.stopMessageListener(room: room)
        }
    }
    
    func sendMessage(_ message: String, completion: @escaping SuccessCompletion) {
        guard let room = self.room else {
            completion(false)
            return
        }
        MatrixManager.sharedInstance.sendMessage(room: room, message: message, completion: completion)
    }
    
    func loadMore(limit: Int, completion: @escaping VoidCompletion) {
        guard let room = self.room else {
            completion()
            return
        }
        
        MatrixManager.sharedInstance.loadMoreMessage(room: room, withPaginationSize: limit, completion: completion)
    }
    
    func markAsRead(_ eventId: String, completion: @escaping SuccessCompletion) {
        guard let room = self.room else {
            completion(false)
            return
        }
        
        MatrixManager.sharedInstance.markAsRead(room.id, eventId: eventId, completion: completion)
    }

    func startListenRoom() {
        MatrixManager.sharedInstance.startRoomListener { [weak self] rooms in
            self?.onHasRooms?(rooms?.first != nil)
        }
    }

    func stopListenRoom() {
        MatrixManager.sharedInstance.stopRoomListener()
    }

    func logout() {
        MatrixManager.sharedInstance.stopSession()
        self.room = nil
    }
}

private extension Event {
    func toJson() -> EventJson {
        return [
            "id": eventId,
            "type": eventType.toString(),
            "isFromUser": senderID == SessionManager.sharedInstance.userId,
            "message": message,
            "date": timestamp,
            "fileInfo": attachmentID,
            "readByConseiller": readByConseiller
        ]
    }

    private var timestamp: Int64? {
        guard let date = date else {
            return nil
        }
        return Int64((date.timeIntervalSince1970) * 1000)
    }
    
    private var readByConseiller: Bool{
        print("🚀🚀🚀 CvmRepository.swift#message -> ", message)
        print("🚀🚀🚀 CvmRepository.swift#readBy -> ", readBy)
        return !readBy.filter({ $0 != SessionManager.sharedInstance.userId }).isEmpty
    }
}

private extension EventType {
    func toString() -> String {
        switch self {
        case .UNKNOWN:
            return "unknown"
        case .MESSAGE:
            return "message"
        case .FILE:
            return "file"
        case .IMAGE:
            return "image"
        case .TYPING:
            return "typing"
        case .READ:
            return "read"
        case .MEMBER:
            return "member"
        }
    }
}
