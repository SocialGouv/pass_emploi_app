import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var repository: CvmRepository!
    private var eventChannel: CvmEventChannel!
    private var roomChannel: CvmRoomChannel!
    private var methodChannel: CvmMethodChannel!
    
    
    private var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        setupCvm()
        
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
}
