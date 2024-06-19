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
            initializeCvm(args: args, result: result)
        case "login":
            login(args: args, result: result)
        case "joinFirstRoom":
            joinFirstRoom(result: result)
        case "startListenRoom":
            startListenRoom(result: result)
        case "stopListenRoom":
            stopListenRoom(result: result)
        case "startListenMessages":
            startListenMessages(result: result)
        case "stopListenMessages":
            stopListenMessages(result: result)
        case "sendMessage":
            sendMessage(args: args, result: result)
        case "loadMore":
            loadMore(args: args, result: result)
        case "markAsRead":
            markAsRead(args: args, result: result)
        case "logout":
            logout(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeCvm(args: Dictionary<String, Any>?, result: FlutterResult) {
        guard let limit = args?["limit"] as? Int64 else {
            result(FlutterMethodNotImplemented)
            return
        }
        repository.initializeCvm(limit: Int(truncatingIfNeeded: limit))
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
        repository.startListenRoom()
        result(true)
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

    private func loadMore(args: Dictionary<String, Any>?, result: @escaping FlutterResult) {
        guard let limit = args?["limit"] as? Int64 else {
            result(FlutterMethodNotImplemented)
            return
        }
        repository.loadMore(limit: Int(truncatingIfNeeded: limit)) {
            result(true)
        }
    }
    
    private func markAsRead(args: Dictionary<String, Any>?, result: @escaping FlutterResult) {
        guard let eventId = args?["eventId"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }
        repository.markAsRead(eventId) { success in
            result(success)
        }
    }

    private func logout(result: FlutterResult) {
        repository.logout()
        result(true)
    }
}
