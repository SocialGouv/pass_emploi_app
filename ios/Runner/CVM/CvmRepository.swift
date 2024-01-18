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
typealias SuccessCompletion = (Bool) -> Void
typealias VoidCompletion = () -> Void

class CvmRepository {
    
    private var room: Room?
    private var onMessages: EventsReceived?
    
    func initializeCvm() {
        MatrixManager.sharedInstance.initialize(paginationPageSize: 5)
    }
    
    func setMessageCallback(_ onMessages: @escaping EventsReceived) {
        self.onMessages = onMessages
    }
    
    func startListenMessages(token: String, ex160Url: String, completion: @escaping SuccessCompletion) {
        loginThenListenEvents(token: token, ex160Url: ex160Url, completion: completion)
    }

    private func loginThenListenEvents(token: String, ex160Url: String, completion: @escaping SuccessCompletion) {
        MatrixManager.sharedInstance.loginAndStartSession(accessToken: token, oauthServer: ex160Url) { [weak self] success in
            if (success) {
                self?.joinRoomThenListenEvents(completion: completion)
            } else {
                completion(false)
            }
        }
    }

    private func joinRoomThenListenEvents(completion: @escaping SuccessCompletion) {
        MatrixManager.sharedInstance.joinFirstRoom { [weak self] room in
            self?.room = room
            if let room = room {
                self?.startListenEvents(room: room, completion: completion)
            } else {
                completion(false)
                //TODO: listen room ? c'est peut-être plus complexe que ça
                // peut-être qu'on veut retourner une erreur, et que c'est au client Flutter de dire
                // "ok on commence à listen room"
                // ou peut-être qu'on veut même dire que re-join à chaque fois qu'on affiche la page ?
            }
        }
    }
    
    private func startListenEvents(room: Room, completion: @escaping SuccessCompletion) {
        MatrixManager.sharedInstance.startMessageListener(room: room) { [weak self] events in
            self?.onMessages?(events.map { $0.toJson() })
        }
        completion(true)
    }
    
    func stopListenMessages() {
        if let room = room {
            MatrixManager.sharedInstance.stopMessageListener(room: room)
        }
        MatrixManager.sharedInstance.stopSession()
        self.room = nil
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
