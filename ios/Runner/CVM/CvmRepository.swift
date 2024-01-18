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

class CvmRepository {
    
    private var room: Room?
    private var onMessages: EventsReceived?
    
    func initializeCvm() {
        MatrixManager.sharedInstance.initialize(paginationPageSize: 5)
    }
    
    func setMessageCallback(_ onMessages: @escaping EventsReceived) {
        print("#CVM CvmRepository.setMessageCallback")
        self.onMessages = onMessages
    }
    
    func startListenMessages(token: String, ex160Url: String) {
        //TODO: refactoring
        print("#CVM CvmRepository.startListenMessage")
        MatrixManager.sharedInstance.loginAndStartSession(accessToken: token, oauthServer: ex160Url) { success in
            print("#CVM CvmRepository.startListenMessage login ? \(success)")
            if (success) {
                MatrixManager.sharedInstance.joinFirstRoom { [weak self] room in
                    print("#CVM CvmRepository.startListenMessage room ? \(room)")
                    self?.room = room
                    if let room = room {
                        MatrixManager.sharedInstance.startMessageListener(room: room) { [weak self] events in
                            print("#CVM CvmRepository.startListenMessage events callback - count(\(events.count) - \(events)")
                            
                            //TODO: gestion erreurs - json sans toutes les valeurs
                            let eventsJson = events.compactMap { event in
                                [
                                    "id": event.eventId ?? "no-id",
                                    "isFromUser": event.senderID == SessionManager.sharedInstance.userId,
                                    "content": event.message ?? "no-message",
                                    "date": Int64((event.date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970) * 1000),
                                    //TODO: d'autres champs ?
                                    // "readBy": event.readBy,
                                    // eventType
                                ]
                            }
                            
                            self?.onMessages?(eventsJson)
                        }
                    } else {
                        //TODO: gestion erreurs - pas de room
                        //TODO: listen room ?
                    }
                    
                }
            } else {
                //TODO: gestion erreurs - login échec
            }
        }
    }
    
    func stopListenMessages() {
        //TODO: MatrixManager.sharedInstance.stopRoomListener() ?
        if let room = room {
            MatrixManager.sharedInstance.stopMessageListener(room: room)
        }
        MatrixManager.sharedInstance.stopSession()
        self.room = nil
    }
    
    func sendMessage(_ message: String) {
        print("#CVM CvmRepository.sendMessage \(message)")

        guard let room = self.room else { return }
        MatrixManager.sharedInstance.sendMessage(room: room, message: message) { success in
            print("#CVM CvmRepository.sendMessage success ? \(success)")
            //TODO: erreur
        }
    }
    
    func loadMore() {
        print("#CVM CvmRepository.loadMore")
        guard let room = self.room else { return }
        
        MatrixManager.sharedInstance.loadMoreMessage(room: room, withPaginationSize: 5) {
            print("#CVM CvmRepository.loadMore completion")
        }
    }
}
