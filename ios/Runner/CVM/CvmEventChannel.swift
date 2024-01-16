//
//  CvmEventChannel.swift
//  Runner
//
//  Created by jordan.chapuy on 16/01/2024.
//

import Foundation
import Flutter

@objc public class CvmEventChannel: NSObject, FlutterStreamHandler {
    
    private static let CHANNEL_NAME = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events"
    
    private let repository: CvmRepository
    private var channel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    init(repository: CvmRepository) {
        print("#CVM CvmEventChannel.init")
        
        self.repository = repository
    }
    
    func setupChannel(messenger: FlutterBinaryMessenger) {
        print("#CVM CvmEventChannel.setupChannel")
        
        repository.setMessageCallback(onCvmMessages)
        
        channel = FlutterEventChannel(name: CvmEventChannel.CHANNEL_NAME, binaryMessenger: messenger)
        channel?.setStreamHandler(self)
    }
    
    private func onCvmMessages(messages: [String]) {
        print("#CVM CvmEventChannel.onCvmMessages \(messages)")
        
        guard let eventSink = eventSink else {
            print("#CVM CvmEventChannel.onCvmMessages NULL SINK!")
            return
        }
        
        let message: [String : Any] = [
            "id": "id1",
            "isFromUser": true,
            "content": messages[0],
            "date": 1641031200000,
        ]
        eventSink(message)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("#CVM CvmEventChannel.onListen")
        self.eventSink = eventSink
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("#CVM CvmEventChannel.onCancel")
        eventSink = nil
        return nil
    }
}
