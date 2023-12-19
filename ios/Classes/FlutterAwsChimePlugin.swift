import Flutter
import UIKit

public class FlutterAwsChimePlugin: NSObject, FlutterPlugin {
    
    static var methodChannel: MethodChannelCoordinator?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger();
        // view
        let viewFactory = FlutterVideoTileFactory(messenger: binaryMessenger)
        registrar.register(viewFactory, withId: "videoTile")
        // method channel
        methodChannel = MethodChannelCoordinator(binaryMessenger: binaryMessenger)
        methodChannel?.setUpMethodCallHandler()
    }
    
}
