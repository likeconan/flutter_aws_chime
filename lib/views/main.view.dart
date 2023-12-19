import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/views/content_share.view.dart';
import 'package:flutter_aws_chime/views/videos.view.dart';

import '../models/attendee.model.dart';
import '../models/meeting.model.dart';
import '../models/meeting.theme.model.dart';
import '../models/video_tile.model.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool isScreenSharing = MeetingModel().isReceivingScreenShare.value;
  int currentIndex = MeetingModel().currentPageIndex.value;

  late StreamSubscription<bool> sub;
  late StreamSubscription<int> subCurrentPageIndex;
  late StreamSubscription<Map<String, AttendeeModel>> subAttendee;
  List<VideoTileModel> tiles = [];
  List<AttendeeModel> attendees = [];

  @override
  void initState() {
    super.initState();
    sub = MeetingModel().isReceivingScreenShare.listen((bool val) {
      if (mounted) {
        setState(() {
          isScreenSharing = val;
          if (val) {
            MeetingModel().currentPageIndex.add(0);
          }
        });
      }
    });

    subCurrentPageIndex = MeetingModel().currentPageIndex.listen((value) {
      setState(() {
        currentIndex = value;
      });
      attendeesListener();
    });
    subAttendee = MeetingModel().currAttendees.listen((_) {
      attendeesListener();
    });
  }

  void attendeesListener() {
    if (mounted) {
      var pageSize = MeetingTheme().pageAttendeeSize;
      var res = MeetingModel().getSortedAttendees();
      setState(() {
        var ind = max(0, currentIndex - (isScreenSharing ? 1 : 0));
        attendees = res
            .getRange(ind * pageSize, min((ind + 1) * pageSize, res.length))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
    subCurrentPageIndex.cancel();
    subAttendee.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideControl,
      child: Container(
          color: Colors.transparent,
          child: isScreenSharing && currentIndex == 0
              ? const ContentShareView()
              : VideosView(attendees: attendees)),
    );
  }
}
