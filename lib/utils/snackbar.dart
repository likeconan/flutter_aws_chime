import 'package:flutter/material.dart';

import '../models/meeting.theme.model.dart';

void showSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: MeetingTheme().errorTextStyle,
    ),
    backgroundColor: MeetingTheme().errorBackground,
  ));
}
