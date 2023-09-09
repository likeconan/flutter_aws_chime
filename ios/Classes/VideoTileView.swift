//
//  VideoTileView.swift
//  flutter_aws_chime
//
//  Created by Conan on 2023/9/9.
//

 
import AmazonChimeSDK
import Foundation
import Flutter

class VideoTileView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) {
        _view = DefaultVideoRenderView()
        super.init()
           
        // Receieve tileId as a param.
        let tileId = args as! Int
        let videoRenderView = _view as! VideoRenderView
           
        // Bind view to VideoView
        MeetingSession.shared.meetingSession?.audioVideo.bindVideoView(videoView: videoRenderView, tileId: tileId)
           
        // Fix aspect ratio
        _view.contentMode = .scaleAspectFit
           
        // Declare _view as UIView for Flutter interpretation
        _view = _view as UIView
    }

    func view() -> UIView {
        return _view
    }
}

