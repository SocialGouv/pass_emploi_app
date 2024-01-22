//
//  CvmEventChannel.swift
//  Runner
//
//  Created by jordan.chapuy on 16/01/2024.
//

import Foundation
import Flutter

@objc public class CvmRoomChannel: NSObject, FlutterStreamHandler {
    
    private static let CHANNEL_NAME = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms"
    
    private let repository: CvmRepository
    private var channel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    init(repository: CvmRepository) {
        self.repository = repository
    }
    
    func setupChannel(messenger: FlutterBinaryMessenger) {
        repository.setHasRoomCallback(onCvmRoom)
        
        channel = FlutterEventChannel(name: CvmRoomChannel.CHANNEL_NAME, binaryMessenger: messenger)
        channel?.setStreamHandler(self)
    }
    
    private func onCvmRoom(hasRoom: Bool) {
        guard let eventSink = eventSink else { return }
        eventSink(hasRoom)
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
