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
        self.repository = repository
    }
    
    func setupChannel(messenger: FlutterBinaryMessenger) {
        repository.setMessageCallback(onCvmMessages)
        
        channel = FlutterEventChannel(name: CvmEventChannel.CHANNEL_NAME, binaryMessenger: messenger)
        channel?.setStreamHandler(self)
    }
    
    private func onCvmMessages(messages: [EventJson]) {
        guard let eventSink = eventSink else { return }
        eventSink(messages)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
