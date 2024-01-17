//
//  CvmRepository.swift
//  Runner
//
//  Created by jordan.chapuy on 16/01/2024.
//

import Foundation
import BenedicteSDK

class CvmRepository {
    
    private var room: Room?
    private var onMessages: (([String]) -> Void)?
    
    func initializeCvm() {
        MatrixManager.sharedInstance.initialize(paginationPageSize: 20)
    }
    
    func setMessageCallback(_ onMessages: @escaping (([String]) -> Void)) {
        print("#CVM CvmRepository.setMessageCallback")
        self.onMessages = onMessages
    }
    
    func startListenMessage(token: String, ex160Url: String) {
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
                            let messages = events.compactMap { event in
                                event.message
                            }
                            self?.onMessages?(messages)
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
    
    func stopListenMessage() {}
    
    func sendMessage(message: String) {
        print("#CVM CvmRepository.sendMessage \(message)")
    }
    
    func loadMore() {}
}
