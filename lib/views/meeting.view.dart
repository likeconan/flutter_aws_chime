import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/models/join_info.model.dart';
import 'package:flutter_aws_chime/models/meeting.model.dart';
import 'package:flutter_aws_chime/views/main.view.dart';
import 'package:flutter_aws_chime/views/title.view.dart';

import 'actions.view.dart';
import 'control_visible.view.dart';
import 'messages.view.dart';
import 'page_indicator.view.dart';

class MeetingView extends StatefulWidget {
  final JoinInfo joinData;
  final void Function(bool didStop)? onLeave;

  const MeetingView(this.joinData, {this.onLeave, super.key});

  @override
  State<MeetingView> createState() => _MeetingViewState();
}

class _MeetingViewState extends State<MeetingView> {
  MeetingModel meeting = MeetingModel();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    meeting.config(meetingData: widget.joinData);
    var res = await meeting.join();
    debugPrint("join res: $res");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GestureDetector(
        onTap: hideControl,
        child: Stack(
          children: [
            const MainView(),
            ControlVisibleView(
              child: TitleView(
                title: widget.joinData.meeting.externalMeetingId,
                onLeave: widget.onLeave,
              ),
            ),
            const ControlVisibleView(
              child: MessagesView(),
            ),
            ControlVisibleView(
              child: ActionsView(),
            ),
            const ControlVisibleView(
              child: PageIndicatorView(),
            ),
          ],
        ),
      ),
    );
  }
}
