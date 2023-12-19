//
//  DataMessageObserver.swift
//  flutter_aws_chime
//
//  Created by Conan on 2023/9/20.
//

import Foundation
import AmazonChimeSDK
import AmazonChimeSDKMedia
import AVFoundation
import Flutter
import UIKit

class MyDataMessageObserver: DataMessageObserver {
    func dataMessageDidReceived(dataMessage: AmazonChimeSDK.DataMessage) {
        methodChannel.callFlutterMethod(method: .messageReceived, args: messageInfoToDictionary(dataMessage:dataMessage))
    }
    
    var methodChannel: MethodChannelCoordinator

    init(withMethodChannel methodChannel: MethodChannelCoordinator) {
        self.methodChannel = methodChannel
    }

    private func messageInfoToDictionary(dataMessage: AmazonChimeSDK.DataMessage) ->[String:Any] {
        return [
            "attendeeId": dataMessage.senderAttendeeId,
            "externalUserId": dataMessage.senderExternalUserId,
            "topic":dataMessage.topic,
            "timestampMs":dataMessage.timestampMs,
            "message":  String(data: dataMessage.data, encoding: .utf8),
            "throttled": dataMessage.throttled,
        ]
    }
}
