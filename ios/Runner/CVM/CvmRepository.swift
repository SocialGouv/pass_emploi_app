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
        MatrixManager.sharedInstance.initialize(paginationPageSize: 20)
    }
    
    func setMessageCallback(_ onMessages: @escaping EventsReceived) {
        print("#CVM CvmRepository.setMessageCallback")
        self.onMessages = onMessages
    }
    
    func startListenMessages(token: String, ex160Url: String) {
        print("#CVM CvmRepository.startListenMessage")
        MatrixManager.sharedInstance.loginAndStartSession(accessToken: token, oauthServer: ex160Url) { success in
            print("#CVM CvmRepository.startListenMessage login ? \(success)")
            if (success) {
                MatrixManager.sharedInstance.joinFirstRoom { [weak self] room in
                    print("#CVM CvmRepository.startListenMessage room ? \(room)")
                    self?.room = room
                    if let room = room {
                        MatrixManager.sharedInstance.startMessageListener(room: room) { [weak self] events in
                            print("#CVM CvmRepository.startListenMessage events ? \(events)")
                            
                            //TODO: que faire si pas toutes les valeurs ?
                            let eventsJson = events.compactMap { event in
                                [
                                    "id": event.eventId ?? "no-id",
                                    "isFromUser": event.senderID == SessionManager.sharedInstance.userId,
                                    "content": event.message ?? "no-message",
                                    "date": Int64((event.date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970) * 1000),
                                ]
                            }
                            
                            self?.onMessages?(eventsJson)
                        }
                    } else {
                        //TODO: ?
                    }
                    
                }
            } else {
                //TODO: ?
            }
        }
    }
    
    func stopListenMessages() {}
    
    func sendMessage(message: String) {
        print("#CVM CvmRepository.sendMessage \(message)")
    }
    
    func loadMore() {}
}
