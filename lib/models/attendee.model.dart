import './video_tile.model.dart';

class AttendeeModel {
  final String attendeeId;
  final String externalUserId;

  bool muteStatus = true;
  bool isVideoOn = false;

  VideoTileModel? videoTile;
  final DateTime joinedAt;

  AttendeeModel(
    this.attendeeId,
    this.externalUserId, {
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory AttendeeModel.fromJson(dynamic json) {
    return AttendeeModel(json["attendeeId"], json["externalUserId"]);
  }
}
