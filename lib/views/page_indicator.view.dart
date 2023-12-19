import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../models/attendee.model.dart';
import '../models/meeting.model.dart';
import '../models/meeting.theme.model.dart';

class PageIndicatorView extends StatefulWidget {
  const PageIndicatorView({super.key});

  @override
  State<PageIndicatorView> createState() => _PageIndicatorViewState();
}

class _PageIndicatorViewState extends State<PageIndicatorView> {
  late int totalPage = _calculatePageTotal();
  bool isScreenSharing = MeetingModel().isReceivingScreenShare.value;
  int currentIndex = MeetingModel().currentPageIndex.value;

  late StreamSubscription<bool> sub;
  late StreamSubscription<Map<String, AttendeeModel>> subAttendee;
  late StreamSubscription<int> subCurrentPageIndex;

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
    });
    subAttendee = MeetingModel().currAttendees.listen((_) {
      if (mounted) {
        setState(() {
          totalPage = _calculatePageTotal();
        });
      }
    });
  }

  int _calculatePageTotal() {
    return (MeetingModel().getTotal() / MeetingTheme().pageAttendeeSize).ceil();
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
    subAttendee.cancel();
    subCurrentPageIndex.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var total = totalPage + (isScreenSharing ? 1 : 0);
    if (total <= 1) {
      return Container();
    }
    return Positioned(
      bottom: MeetingTheme().actionViewHeight,
      left: 0,
      right: 0,
      child: Center(
        child: DotsIndicator(
          dotsCount: total,
          position: currentIndex,
          decorator: DotsDecorator(
            activeColor: MeetingTheme().dotActiveColor,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          onTap: (int index) {
            MeetingModel().currentPageIndex.add(index);
          },
        ),
      ),
    );
  }
}
