//
//  CvmMethodChannel.swift
//  Runner
//
//  Created by jordan.chapuy on 16/01/2024.
//

import Foundation
import Flutter

class CvmMethodChannel {
    
    private static let CHANNEL_NAME = "fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods"
    
    private let repository: CvmRepository
    private let channel: FlutterMethodChannel
    
    init(repository: CvmRepository, messenger: FlutterBinaryMessenger) {
        print("#CVM CvmMethodChannel.init")
        
        self.repository = repository
        
        channel = FlutterMethodChannel(name: CvmMethodChannel.CHANNEL_NAME, binaryMessenger: messenger)
        channel.setMethodCallHandler({ [weak self] (call, result) -> Void in
            self?.handleMethod(call: call, result: result)
        })
    }
    
    private func handleMethod(call: FlutterMethodCall, result: FlutterResult) {
        print("#CVM CvmMethodChannel.handleMethod \(call.method)")
        let args = call.arguments as? Dictionary<String, Any>
        
        switch (call.method) {
        case "initializeCvm":
            repository.initializeCvm()
            result(nil)
        case "startListenMessages":
            //TODO: gérer les erreurs du startListen, et erreur args
            guard let token = args?["token"] as? String, let ex160Url = args?["ex160"] as? String else { return }
            repository.startListenMessages(token: token, ex160Url: ex160Url)
            result(nil)
        case "stopListenMessages":
            repository.stopListenMessages()
            result(nil)
        case "sendMessage":
            //TODO: gérer les erreurs
            guard let message = args?["message"] as? String else { return }
            repository.sendMessage(message)
            result(nil)
        case "loadMore":
            //TODO: erreurs ?
            repository.loadMore()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
