//
//  CvmRepository.swift
//  Runner
//
//  Created by jordan.chapuy on 16/01/2024.
//

import Foundation

class CvmRepository {
    
    private var onMessages: (([String]) -> Void)?
    
    func initializeCvm() {}
    
    func setMessageCallback(_ onMessages: @escaping (([String]) -> Void)) {
        print("#CVM CvmRepository.setMessageCallback")
        self.onMessages = onMessages
    }
    
    func startListenMessage() {}
    
    func stopListenMessage() {}
    
    func sendMessage(message: String) {
        print("#CVM CvmRepository.sendMessage \(message)")
        onMessages?([message])
    }
    
    func loadMore() {}
}
