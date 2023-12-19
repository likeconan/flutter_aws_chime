class JoinInfo {
  final MeetingInfo meeting;

  final AttendeeInfo attendee;

  JoinInfo(this.meeting, this.attendee);

  factory JoinInfo.fromJson(Map<String, dynamic> json) {
    return JoinInfo(
      MeetingInfo.fromJson(json['meeting']),
      AttendeeInfo.fromJson(json['attendee']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> flattenedJSON = {
      "MeetingId": meeting.meetingId,
      "ExternalMeetingId": meeting.externalMeetingId,
      "MediaRegion": meeting.mediaRegion,
      "AudioHostUrl": meeting.mediaPlacement.audioHostUrl,
      "AudioFallbackUrl": meeting.mediaPlacement.audioFallbackUrl,
      "SignalingUrl": meeting.mediaPlacement.signalingUrl,
      "TurnControlUrl": meeting.mediaPlacement.turnControllerUrl,
      "ExternalUserId": attendee.externalUserId,
      "AttendeeId": attendee.attendeeId,
      "JoinToken": attendee.joinToken
    };

    return flattenedJSON;
  }
}

class MeetingInfo {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;

  MeetingInfo(this.meetingId, this.externalMeetingId, this.mediaRegion,
      this.mediaPlacement);

  factory MeetingInfo.fromJson(Map<String, dynamic> json) {
    return MeetingInfo(
      json['MeetingId'],
      json['ExternalMeetingId'],
      json['MediaRegion'],
      MediaPlacement.fromJson(json['MediaPlacement']),
    );
  }
}

class AttendeeInfo {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;

  AttendeeInfo(this.externalUserId, this.attendeeId, this.joinToken);

  factory AttendeeInfo.fromJson(Map<String, dynamic> json) {
    return AttendeeInfo(
      json['ExternalUserId'],
      json['AttendeeId'],
      json['JoinToken'],
    );
  }
}

class MediaPlacement {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControllerUrl;

  MediaPlacement(this.audioHostUrl, this.audioFallbackUrl, this.signalingUrl,
      this.turnControllerUrl);

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    return MediaPlacement(
      json['AudioHostUrl'],
      json['AudioFallbackUrl'],
      json['SignalingUrl'],
      json['TurnControlUrl'],
    );
  }
}
