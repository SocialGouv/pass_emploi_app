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
            repository.startListenMessage(token: args!["token"] as! String, ex160Url: args!["ex160"] as! String)
            //TODO: séparer init et startlisten, et éviter force unwrap, et gérer les erreurs du startListen
            result(nil)
        case "start":
            //TODO: start cvm
            result(FlutterMethodNotImplemented)
        case "stop":
            //TODO: stop cvm
            result(FlutterMethodNotImplemented)
        case "sendMessage":
            //TODO: send message cvm
            let message = args!["message"] as! String
            repository.sendMessage(message: message)
            result(FlutterMethodNotImplemented)
        case "loadMore":
            //TODO: load more messages cvm
            result(FlutterMethodNotImplemented)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
