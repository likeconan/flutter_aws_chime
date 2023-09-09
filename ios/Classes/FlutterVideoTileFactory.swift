//
//  FlutterVideoTileFactory.swift
//  flutter_aws_chime
//
//  Created by Conan on 2023/9/9.
//
 
import Flutter
import Foundation

class FlutterVideoTileFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return VideoTileView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

