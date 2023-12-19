/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aws_chime/models/message.model.dart';

import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../interfaces/video_tile_interfcae.dart';
import '../models/attendee.model.dart';
import '../models/meeting.model.dart';
import '../models/video_tile.model.dart';
import 'response_enums.dart';

class MethodChannelCoordinator {
  late MethodChannel methodChannel;

  static final MethodChannelCoordinator _instance =
      MethodChannelCoordinator._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory MethodChannelCoordinator() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  MethodChannelCoordinator._internal() {
    // initialization logic
    methodChannel =
        const MethodChannel("com.oneplusdream.aws.chime.methodChannel");
    methodChannel.setMethodCallHandler(methodCallHandler);
  }

  RealtimeInterface? realtimeObserver;
  VideoTileInterface? videoTileObserver;
  AudioVideoInterface? audioVideoObserver;

  void initializeRealtimeObserver(RealtimeInterface realtimeInterface) {
    realtimeObserver = realtimeInterface;
  }

  void initializeAudioVideoObserver(AudioVideoInterface audioVideoInterface) {
    audioVideoObserver = audioVideoInterface;
  }

  void initializeVideoTileObserver(VideoTileInterface videoTileInterface) {
    videoTileObserver = videoTileInterface;
  }

  void initializeObservers(MeetingModel meeting) {
    initializeRealtimeObserver(meeting);
    initializeAudioVideoObserver(meeting);
    initializeVideoTileObserver(meeting);
  }

  Future<MethodChannelResponse?> callMethod(String methodName,
      [dynamic args]) async {
    try {
      dynamic response = await methodChannel.invokeMethod(methodName, args);
      return MethodChannelResponse.fromJson(response);
    } catch (e) {
      return MethodChannelResponse(false, null);
    }
  }

  Future<void> methodCallHandler(MethodCall call) async {
    debugPrint("method called ${call.method} ${call.arguments}");
    try {
      switch (call.method) {
        case MethodCallOption.join:
          final AttendeeModel attendee = AttendeeModel.fromJson(call.arguments);
          realtimeObserver?.attendeeDidJoin(attendee);
          break;
        case MethodCallOption.leave:
          final AttendeeModel attendee = AttendeeModel.fromJson(call.arguments);
          realtimeObserver?.attendeeDidLeave(attendee, didDrop: false);
          break;
        case MethodCallOption.drop:
          final AttendeeModel attendee = AttendeeModel.fromJson(call.arguments);
          realtimeObserver?.attendeeDidLeave(attendee, didDrop: true);
          break;
        case MethodCallOption.mute:
          final AttendeeModel attendee = AttendeeModel.fromJson(call.arguments);
          realtimeObserver?.attendeeDidMute(attendee);
          break;
        case MethodCallOption.unmute:
          final AttendeeModel attendee = AttendeeModel.fromJson(call.arguments);
          realtimeObserver?.attendeeDidUnmute(attendee);
          break;
        case MethodCallOption.videoTileAdd:
          final String attendeeId = call.arguments["attendeeId"];
          final VideoTileModel videoTile =
              VideoTileModel.fromJson(call.arguments);
          videoTileObserver?.videoTileDidAdd(attendeeId, videoTile);
          break;
        case MethodCallOption.videoTileRemove:
          final String attendeeId = call.arguments["attendeeId"];
          final VideoTileModel videoTile =
              VideoTileModel.fromJson(call.arguments);
          videoTileObserver?.videoTileDidRemove(attendeeId, videoTile);
          break;
        case MethodCallOption.audioSessionDidStop:
          audioVideoObserver?.audioSessionDidStop();
          break;
        case MethodCallOption.messageReceived:
          realtimeObserver
              ?.messageDidReceive(MessageModel.fromJson(call.arguments));
          break;
        default:
          debugPrint(
              "Method ${call.method} with args ${call.arguments} does not exist");
      }
    } catch (e) {
      debugPrint(
          "Error: call ${call.method} with arguments ${call.arguments} failed: $e");
    }
  }

  Future<bool> requestAudioPermissions() async {
    MethodChannelResponse? audioPermission =
        await callMethod(MethodCallOption.manageAudioPermissions);
    if (audioPermission == null) {
      return false;
    }
    return audioPermission.result;
  }

  Future<bool> requestVideoPermissions() async {
    MethodChannelResponse? videoPermission =
        await callMethod(MethodCallOption.manageVideoPermissions);
    if (videoPermission != null) {
      return videoPermission.result;
    }
    return false;
  }

  Future<bool> sendMessage(MessageSendModel data) async {
    MethodChannelResponse? res = await callMethod(
      MethodCallOption.sendMessage,
      {
        "topic": data.topic,
        "message": data.message,
        "lifetimeMs": data.lifetimeMs,
      },
    );
    if (res == null) {
      return false;
    }
    return res.result;
  }

  Future<bool> toggleSound(bool off) async {
    MethodChannelResponse? res =
        await callMethod(MethodCallOption.toggleSound, off);
    if (res == null) {
      return false;
    }
    return res.result;
  }
}

class MethodChannelResponse {
  late bool result;
  dynamic arguments;

  MethodChannelResponse(this.result, this.arguments);

  factory MethodChannelResponse.fromJson(dynamic json) {
    return MethodChannelResponse(json["result"], json["arguments"]);
  }
}
