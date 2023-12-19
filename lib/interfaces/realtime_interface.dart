import 'package:flutter_aws_chime/models/message.model.dart';

import '../models/attendee.model.dart';

class RealtimeInterface {
  void attendeeDidJoin(AttendeeModel attendee) {
    // Gets called when an attendee joins the meeting
  }

  void attendeeDidLeave(AttendeeModel attendee, {required bool didDrop}) {
    // Gets called when an attendee leaves or drops the meeting
  }

  void attendeeDidMute(AttendeeModel attendee) {
    // Gets called when an mutes themselves
  }

  void attendeeDidUnmute(AttendeeModel attendee) {
    // Gets called when an unmutes themselves
  }

  void messageDidReceive(MessageModel message) {
    // Gets called when an message received
  }
}
