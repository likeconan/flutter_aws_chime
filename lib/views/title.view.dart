import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/views/icon.button.view.dart';

import '../models/meeting.model.dart';
import '../models/meeting.theme.model.dart';

class TitleView extends StatelessWidget {
  final String title;
  final void Function(bool didStop)? onLeave;

  const TitleView({super.key, this.title = '', this.onLeave});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MeetingTheme().baseUnit * 2,
      left: MeetingTheme().baseUnit * 2,
      right: MeetingTheme().baseUnit * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButtonView(
            icon: Icons.arrow_back_ios_new_outlined,
            onTap: () async {
              var res = await MeetingModel().stopMeeting();
              if (onLeave != null) {
                onLeave!(res);
              }
            },
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButtonView(
            icon: MeetingModel().controlLock
                ? Icons.lock_outline
                : Icons.lock_open_outlined,
            onTap: () async {
              MeetingModel().controlLock = !MeetingModel().controlLock;
              MeetingModel().controlVisible.add(MeetingModel().controlLock);
              return MeetingModel().controlLock
                  ? Icons.lock_outline
                  : Icons.lock_open_outlined;
            },
          ),
        ],
      ),
    );
  }
}
