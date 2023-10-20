import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.flutter_bridge_demo", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            guard call.method == "getMessagesFromNative" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.getMessage(result: result)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getMessage(result: FlutterResult) {
        let message = "Message from Swift code"
        if message.isEmpty {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Message from Kotlin code is empty",
                                details: nil))
        } else {
            result(message)
        }
    }
}
