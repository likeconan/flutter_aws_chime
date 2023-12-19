import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/views/pinch_view.dart';
import '../models/attendee.model.dart';
import '/views/video_tile.view.dart';
import '../models/meeting.theme.model.dart';

class VideosView extends StatelessWidget {
  final List<AttendeeModel> attendees;

  const VideosView({super.key, required this.attendees});

  @override
  Widget build(BuildContext context) {
    return _buildPageAttendees(attendees);
  }

  Widget _buildPageAttendees(List<AttendeeModel> attendees) {
    List<Widget> rows = [];

    if (attendees.length <= 2) {
      rows.addAll(attendees.map((e) => Expanded(child: _buildAttendeeItem(e))));
    } else {
      for (var i = 0; i < attendees.length / 2; i++) {
        var index = i * 2;
        rows.add(
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildAttendeeItem(attendees[index])),
                if (index + 1 < attendees.length)
                  Expanded(child: _buildAttendeeItem(attendees[index + 1]))
              ],
            ),
          ),
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: rows,
          ),
        );
      },
    );
  }

  Widget _buildAttendeeItem(AttendeeModel item) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var widget = item.isVideoOn && item.videoTile?.tileId != null
            ? PinchView(
                contentRatio: item.videoTile!.videoStreamContentWidth /
                    item.videoTile!.videoStreamContentHeight,
                child: VideoTileView(
                  paramsVT: item.videoTile!.tileId,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 48,
                    color: Colors.white70,
                  ),
                  Padding(
                    padding: EdgeInsets.all(MeetingTheme().baseUnit),
                    child: Text(
                      item.externalUserId,
                      softWrap: true,
                      style: MeetingTheme().nameTextStyle,
                    ),
                  ),
                ],
              );

        return Container(
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          margin: const EdgeInsets.all(2),
          clipBehavior: Clip.hardEdge,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: widget,
        );
      },
    );
  }
}
