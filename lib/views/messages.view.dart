import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_aws_chime/models/meeting.model.dart';
import 'package:flutter_aws_chime/models/meeting.theme.model.dart';
import 'package:flutter_aws_chime/models/message.model.dart';

import '../utils/format.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  List<MessageModel> messages = [];
  late StreamSubscription<MessageModel?> sub;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    sub = MeetingModel().receivedMessage.listen((value) {
      if (value != null && mounted) {
        setState(() {
          messages.add(value);
        });
      }
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      left: MeetingTheme().baseUnit * 2,
      bottom: MeetingTheme().actionViewHeight,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 0,
          maxHeight: min(size.height / 2.5, MeetingTheme().messageViewHeight),
          maxWidth: MeetingTheme().messageViewWidth,
          minWidth: 0,
        ),
        child: SingleChildScrollView(
          reverse: true,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) => chatBubble(messages[index])),
        ),
      ),
    );
  }

  Widget chatBubble(MessageModel message) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: MeetingTheme().baseUnit),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MeetingTheme().baseUnit * 2,
          vertical: MeetingTheme().baseUnit,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.all(
            Radius.circular(MeetingTheme().baseUnit * 2),
          ),
        ),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: shortTextWithAsterisk(message.externalUserId),
                style:
                    MeetingModel().localAttendeeId.value == message.attendeeId
                        ? TextStyle(
                            color: Colors.black,
                            background: Paint()
                              ..color = Colors.white
                              ..style = PaintingStyle.fill
                              ..strokeCap = StrokeCap.round
                              ..strokeWidth = 1.0,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )
                        : MeetingTheme().chatNameTextStyle,
              ),
              TextSpan(
                text: ': ',
                style: MeetingTheme().chatNameTextStyle,
              ),
              TextSpan(
                text: message.message,
                style: MeetingTheme().chatMessageTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
