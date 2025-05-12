import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var repository: CvmRepository!
    private var eventChannel: CvmEventChannel!
    private var roomChannel: CvmRoomChannel!
    private var methodChannel: CvmMethodChannel!
    
    private var eventSink: FlutterEventSink?
    private var apnsToken: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        setupCvm()
        setupApnsTokenChannel()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupCvm() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        repository = CvmRepository()
        
        eventChannel = CvmEventChannel(repository: repository)
        eventChannel.setupChannel(messenger: controller.binaryMessenger)
        roomChannel = CvmRoomChannel(repository: repository)
        roomChannel.setupChannel(messenger: controller.binaryMessenger)
        
        methodChannel = CvmMethodChannel(repository: repository, messenger: controller.binaryMessenger)
    }

    private func setupApnsTokenChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }
        let tokenChannel = FlutterMethodChannel(name: "apns_token_channel", binaryMessenger: controller.binaryMessenger)
        
        tokenChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getApnsToken" {
                result(self?.apnsToken)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        apnsToken = tokenParts.joined()
        print("APNs token: \(apnsToken ?? "")")
    }

    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error)")
    }
}
