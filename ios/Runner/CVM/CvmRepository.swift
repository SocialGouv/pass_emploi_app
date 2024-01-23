//
//  CvmRepository.swift
//  Runner
//
//  Created by jordan.chapuy on 16/01/2024.
//

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
    
    func initializeCvm() {
        MatrixManager.sharedInstance.initialize(paginationPageSize: 5)
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
    
    func loadMore(completion: @escaping VoidCompletion) {
        guard let room = self.room else {
            completion()
            return
        }
        
        MatrixManager.sharedInstance.loadMoreMessage(room: room, withPaginationSize: 5, completion: completion)
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
            "id": eventId ?? "no-id",
            "isFromUser": senderID == SessionManager.sharedInstance.userId,
            "content": message ?? "no-message",
            "date": Int64((date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970) * 1000),
            //TODO: d'autres champs ?
            // "readBy": event.readBy,
            // eventType
        ]
    }
}
