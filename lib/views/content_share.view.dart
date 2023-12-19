import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/views/pinch_view.dart';
import '/models/meeting.model.dart';
import '/views/video_tile.view.dart';

class ContentShareView extends StatelessWidget {
  const ContentShareView({super.key});

  @override
  Widget build(BuildContext context) {
    var videoTile = MeetingModel()
        .currAttendees
        .value[MeetingModel().contentAttendeeId.value]
        ?.videoTile;
    if (videoTile == null) {
      return Container(
        color: Colors.black,
        child: const Center(
            child: Text(
          'Error: cannot get shared screen content.',
          style: TextStyle(color: Colors.white),
        )),
      );
    }
    return PinchView(
      contentRatio: videoTile.videoStreamContentWidth /
          videoTile.videoStreamContentHeight,
      child: VideoTileView(paramsVT: videoTile.tileId),
    );
  }
}
