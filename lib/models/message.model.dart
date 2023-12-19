class MessageModel {
  final String attendeeId;
  final String externalUserId;
  final String message;
  final bool? throttled;
  final String topic;
  final num timestampMs;

  MessageModel(
    this.attendeeId,
    this.externalUserId,
    this.message,
    this.topic,
    this.timestampMs, {
    this.throttled,
  });

  factory MessageModel.fromJson(dynamic json) {
    return MessageModel(
      json["attendeeId"],
      json["externalUserId"],
      json['message'],
      json['topic'],
      json['timestampMs'],
      throttled: json['throttled'],
    );
  }
}

class MessageSendModel {
  final String topic;
  final String message;
  final num? lifetimeMs;
  MessageSendModel(this.topic, this.message, {this.lifetimeMs});
  factory MessageSendModel.fromJson(dynamic json) {
    return MessageSendModel(
      json["topic"],
      json["message"],
      lifetimeMs: json['lifetimeMs'],
    );
  }
}
