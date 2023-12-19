import 'dart:async';

import 'package:flutter/material.dart';

import '../models/meeting.model.dart';

class ControlVisibleView extends StatefulWidget {
  final Widget child;

  const ControlVisibleView({super.key, required this.child});
  @override
  State<ControlVisibleView> createState() => _ControlVisibleViewState();
}

class _ControlVisibleViewState extends State<ControlVisibleView> {
  late StreamSubscription<bool> sub;
  bool _visible = true;

  @override
  void initState() {
    sub = MeetingModel().controlVisible.listen((bool val) {
      if (mounted) {
        setState(() {
          _visible = val;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return Container();
    }
    return widget.child;
  }
}
