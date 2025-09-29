import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var eventSink: FlutterEventSink?
    private var apnsToken: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        setupApnsTokenChannel()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
