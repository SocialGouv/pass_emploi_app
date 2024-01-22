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
        self.repository = repository
        
        channel = FlutterMethodChannel(name: CvmMethodChannel.CHANNEL_NAME, binaryMessenger: messenger)
        channel.setMethodCallHandler({ [weak self] (call, result) -> Void in
            self?.handleMethod(call: call, result: result)
        })
    }
    
    private func handleMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>

        switch (call.method) {
        case "initializeCvm":
            initializeCvm(result: result)
        case "login":
            login(args: args, result: result)
        case "joinFirstRoom":
            joinFirstRoom(result: result)
        case "startListenRoom":
            startListenRoom(result: result)
        case "stopListenRoom":
            startListenRoom(result: result)
        case "startListenMessages":
            startListenMessages(result: result)
        case "stopListenMessages":
            stopListenMessages(result: result)
        case "sendMessage":
            sendMessage(args: args, result: result)
        case "loadMore":
            loadMore(result: result)
        case "logout":
            logout(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeCvm(result: FlutterResult) {
        repository.initializeCvm()
        result(true)
    }

    private func login(args: Dictionary<String, Any>?, result: @escaping FlutterResult) {
        guard let token = args?["token"] as? String, let ex160Url = args?["ex160"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }
        repository.login(token: token, ex160Url: ex160Url) { success in
            result(success)
        }
    }

    private func joinFirstRoom(result: @escaping FlutterResult) {
        repository.joinFirstRoom() { success in
            result(success)
        }
    }

    private func startListenRoom(result: @escaping FlutterResult) {
        repository.startListenRoom() { success in
            result(success)
        }
    }

    private func stopListenRoom(result: FlutterResult) {
        repository.stopListenRoom()
        result(true)
    }

    private func startListenMessages(result: @escaping FlutterResult) {
        repository.startListenMessages() { success in
            result(success)
        }
    }

    private func stopListenMessages(result: FlutterResult) {
        repository.stopListenMessages()
        result(true)
    }

    private func sendMessage(args: Dictionary<String, Any>?, result: @escaping FlutterResult) {
        guard let message = args?["message"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }
        repository.sendMessage(message) { success in
            result(success)
        }
    }

    private func loadMore(result: @escaping FlutterResult) {
        repository.loadMore() {
            result(true)
        }
    }

    private func logout(result: FlutterResult) {
        repository.logout()
        result(true)
    }
}
