import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_aws_chime/models/attendee.model.dart';
import 'package:flutter_aws_chime/models/message.model.dart';

import 'package:flutter_aws_chime/models/video_tile.model.dart';
import 'package:rxdart/subjects.dart';

import '../handlers/method_channel_coordinator.dart';
import '../handlers/response_enums.dart';
import '../interfaces/audio_devices_interface.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../interfaces/video_tile_interfcae.dart';
import 'join_info.model.dart';

class MeetingModel
    implements
        RealtimeInterface,
        VideoTileInterface,
        AudioDevicesInterface,
        AudioVideoInterface {
  static final MeetingModel _instance = MeetingModel._internal();

  late MethodChannelCoordinator methodChannelProvider;
  late JoinInfo meetingData;

  BehaviorSubject<String?> localAttendeeId = BehaviorSubject.seeded(null);
  BehaviorSubject<String?> remoteAttendeeId = BehaviorSubject.seeded(null);
  BehaviorSubject<String?> contentAttendeeId = BehaviorSubject.seeded(null);

  String? selectedAudioDevice;
  List<String?> deviceList = [];
  String topic = 'chat';
  bool controlLock = true;
  BehaviorSubject<bool> controlVisible = BehaviorSubject.seeded(true);

  // AttendeeId is the key
  BehaviorSubject<Map<String, AttendeeModel>> currAttendees =
      BehaviorSubject.seeded({
    // '1': AttendeeModel("attendeeId1", "externalUserId1"),
    // '2': AttendeeModel("attendeeId2", "externalUserId2"),
    // '3': AttendeeModel("attendeeId3", "externalUserId3"),
    // '4': AttendeeModel("attendeeId4", "externalUserId4"),
    // '5': AttendeeModel("attendeeId5", "externalUserId5"),
    // '6': AttendeeModel("attendeeId6", "externalUserId6"),
    // '7': AttendeeModel("attendeeId7", "externalUserId7"),
    // '8': AttendeeModel("attendeeId8", "externalUserId8"),
    // '9': AttendeeModel("attendeeId9", "externalUserId9"),
  });
  BehaviorSubject<MessageModel?> receivedMessage = BehaviorSubject.seeded(null);

  BehaviorSubject<bool> isReceivingScreenShare = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> isMeetingActive = BehaviorSubject.seeded(false);
  BehaviorSubject<int> currentPageIndex = BehaviorSubject.seeded(0);
  Timer? controlHideDelay;

  factory MeetingModel() {
    return _instance;
  }

  MeetingModel._internal() {
    // initialization logic
    methodChannelProvider = MethodChannelCoordinator();
  }

  void config({required JoinInfo meetingData}) {
    _instance.meetingData = meetingData;
    var attendeeId = meetingData.attendee.attendeeId;
    localAttendeeId.add(attendeeId);
    _updateCurrentAttendee(
        AttendeeModel(attendeeId, meetingData.attendee.externalUserId));
    methodChannelProvider.initializeObservers(MeetingModel());
  }

  bool _checkPermissions(bool audioPermissions, bool videoPermissions) {
    if (!audioPermissions && !videoPermissions) {
      // Response.audio_and_video_permission_denied
      return false;
    } else if (!audioPermissions) {
      // Response.audio_not_authorized
      return false;
    } else if (!videoPermissions) {
      // Response.video_not_authorized
      return false;
    }
    return true;
  }

  Future<bool> _isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> sendMessage(String message) {
    return methodChannelProvider.sendMessage(MessageSendModel(topic, message));
  }

  Future<bool> toggleMute({bool? unmute}) async {
    var local = getLocalAttendee();

    var res = (unmute ?? local.muteStatus)
        ? await methodChannelProvider.callMethod(MethodCallOption.unmute)
        : await methodChannelProvider.callMethod(MethodCallOption.mute);
    if (res == null || !res.result) {
      debugPrint('Toggle mute failed');
      throw 'Failed to toggle your audio';
    }
    local.muteStatus = unmute ?? !local.muteStatus;
    _updateCurrentAttendee(local);
    return local.muteStatus;
  }

  Future<bool> toggleVideo() async {
    var local = getLocalAttendee();
    var res = local.isVideoOn
        ? await methodChannelProvider.callMethod(MethodCallOption.localVideoOff)
        : await methodChannelProvider.callMethod(MethodCallOption.localVideoOn);
    if (res == null || !res.result) {
      throw 'Failed to toggle your audio';
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    return getLocalAttendee().isVideoOn;
  }

  AttendeeModel getLocalAttendee() {
    var local = currAttendees.value[localAttendeeId.value];
    if (local == null) {
      throw 'You did not join the meeting, please leave and join again.';
    }
    return local;
  }

  bool getMuteStatus() {
    try {
      return getLocalAttendee().muteStatus;
    } catch (e) {
      debugPrint('Error getMuteStatus: $e');
      return true;
    }
  }

  bool getVideoOn() {
    try {
      return getLocalAttendee().isVideoOn;
    } catch (e) {
      debugPrint('Error getVideoOn: $e');
      return false;
    }
  }

  List<AttendeeModel> getSortedAttendees() {
    var res = currAttendees.value.keys
        .map((k) => currAttendees.value[k])
        .whereType<AttendeeModel>()
        .where((e) => !_isAttendeeContent(e.attendeeId))
        .toList();
    res.sort((a, b) {
      if (a.isVideoOn && !b.isVideoOn) {
        return -1;
      } else if (!b.isVideoOn && a.isVideoOn) {
        return 1;
      } else {
        return a.joinedAt.isBefore(b.joinedAt) ? -1 : 1;
      }
    });
    return res;
  }

  int getTotal() {
    var total = currAttendees.value.keys
        .map((k) => currAttendees.value[k])
        .whereType<AttendeeModel>()
        .where((e) => !_isAttendeeContent(e.attendeeId))
        .length;
    return total;
  }

  Future<bool> join() async {
    // call after config method
    debugPrint('join meeting');
    bool audioPermissions =
        await methodChannelProvider.requestAudioPermissions();
    bool videoPermissions =
        await methodChannelProvider.requestVideoPermissions();

    // Create error messages for incorrect permissions
    if (!_checkPermissions(audioPermissions, videoPermissions)) {
      return false;
    }

    // Check if device is connected to the internet
    bool deviceIsConnected = await _isConnectedToInternet();
    if (!deviceIsConnected) {
      // Response.not_connected_to_internet
      return false;
    }
    // Send JSON to iOS
    MethodChannelResponse? joinResponse = await methodChannelProvider
        .callMethod(MethodCallOption.join, meetingData.toJson());

    if (joinResponse == null) {
      // Response.null_join_response
      return false;
    }

    if (joinResponse.result) {
      await listAudioDevices();
      await initialAudioSelection();
      await toggleMute(unmute: false);
      return true;
    } else {
      // To do error
      return false;
    }
  }

  Future<bool> stopMeeting() async {
    MethodChannelResponse? stopResponse =
        await methodChannelProvider.callMethod(MethodCallOption.stop);
    return stopResponse?.result ?? false;
  }

  void hideControlInSeconds() {
    if (controlLock) {
      return;
    }
    controlVisible.add(true);
    controlHideDelay?.cancel();
    controlHideDelay = null;
    controlHideDelay = Timer(const Duration(seconds: 5), () {
      if (!controlLock) {
        controlVisible.add(false);
      }
      controlHideDelay = null;
    });
  }

  @override
  void attendeeDidJoin(AttendeeModel attendee) {
    debugPrint(
        'attendeeDidJoin: ${attendee.attendeeId}, ${attendee.externalUserId}');
    if (_isAttendeeContent(attendee.attendeeId)) {
      contentAttendeeId.add(attendee.attendeeId);
      return;
    }
    if (attendee.attendeeId != localAttendeeId.value) {
      remoteAttendeeId.add(attendee.attendeeId);
    }
    _updateCurrentAttendee(attendee);
  }

  @override
  void attendeeDidLeave(AttendeeModel attendee, {required bool didDrop}) {
    _updateCurrentAttendee(attendee, isRemove: true);
    debugPrint(
        '${attendee.externalUserId} has ${didDrop ? 'dropped' : 'left'} from the meeting');
  }

  @override
  void attendeeDidMute(AttendeeModel attendee) {
    debugPrint('attendeeDidMute: ${attendee.attendeeId}');
    _changeMuteStatus(attendee, mute: true);
  }

  @override
  void attendeeDidUnmute(AttendeeModel attendee) {
    debugPrint('attendeeDidUnmute: ${attendee.attendeeId}');
    _changeMuteStatus(attendee, mute: false);
  }

  @override
  void audioSessionDidStop() {
    _resetMeetingValues();
  }

  void _resetMeetingValues() {
    localAttendeeId.add(null);
    remoteAttendeeId.add(null);
    contentAttendeeId.add(null);
    selectedAudioDevice = null;
    currAttendees.add({});
    isReceivingScreenShare.add(false);
    isMeetingActive.add(false);
  }

  @override
  Future<void> initialAudioSelection() async {
    MethodChannelResponse? device = await methodChannelProvider
        .callMethod(MethodCallOption.initialAudioSelection);
    if (device == null) {
      debugPrint(Response.null_initial_audio_device);
      return;
    }
    selectedAudioDevice = device.arguments;
  }

  @override
  Future<void> listAudioDevices() async {
    MethodChannelResponse? devices = await methodChannelProvider
        .callMethod(MethodCallOption.listAudioDevices);

    if (devices == null) {
      debugPrint(Response.null_audio_device_list);
      return;
    }
    final deviceIterable = devices.arguments.map((device) => device.toString());
    final devList = List<String?>.from(deviceIterable.toList());
    debugPrint("Devices available: $devList");
    deviceList = devList;
  }

  @override
  Future<void> updateCurrentDevice(String device) async {
    if (device == '') {
      var res = await methodChannelProvider.callMethod(
          MethodCallOption.toggleSound, true);
      selectedAudioDevice = device;
      debugPrint('Turn off sound successfully with ${res?.result}');
      return;
    }
    MethodChannelResponse? updateDeviceResponse = await methodChannelProvider
        .callMethod(MethodCallOption.updateAudioDevice, device);
    if (updateDeviceResponse == null) {
      debugPrint(Response.null_audio_device_update);
      return;
    }

    if (updateDeviceResponse.result) {
      debugPrint("${updateDeviceResponse.arguments} to: $device");
      await methodChannelProvider.callMethod(
          MethodCallOption.toggleSound, false);
      selectedAudioDevice = device;
    } else {
      debugPrint("error: ${updateDeviceResponse.arguments}");
    }
  }

  @override
  void videoTileDidAdd(String attendeeId, VideoTileModel videoTile) {
    debugPrint("videoTileDidAdd to: $attendeeId");
    // TODO hack fix, stream height is wrong for mobile side
    if (!videoTile.isContentShare &&
        videoTile.videoStreamContentWidth != 960 &&
        videoTile.videoStreamContentHeight != 540) {
      var width = videoTile.videoStreamContentWidth;
      var height = videoTile.videoStreamContentHeight;
      videoTile.videoStreamContentHeight = max(height, width);
      videoTile.videoStreamContentWidth = min(height, width);
    }
    currAttendees.value[attendeeId]?.videoTile = videoTile;
    if (videoTile.isContentShare) {
      isReceivingScreenShare.add(true);
      return;
    }
    currAttendees.value[attendeeId]?.isVideoOn = true;
    currAttendees.add(currAttendees.value);
  }

  @override
  void videoTileDidRemove(String attendeeId, VideoTileModel videoTile) {
    debugPrint("videoTileDidRemove to: $attendeeId");
    if (videoTile.isContentShare) {
      currAttendees.value[contentAttendeeId.value]?.videoTile = null;
      isReceivingScreenShare.add(false);
    } else {
      currAttendees.value[attendeeId]?.videoTile = null;
      currAttendees.value[attendeeId]?.isVideoOn = false;
    }
    currAttendees.add(currAttendees.value);
  }

  bool _isAttendeeContent(String? attendeeId) {
    List<String>? attendeeIdArray = attendeeId?.split("#");
    return attendeeIdArray?.length == 2;
  }

  void _changeMuteStatus(AttendeeModel attendee, {required bool mute}) {
    var val = currAttendees.value[attendee.attendeeId] ?? attendee;
    val.muteStatus = mute;
    _updateCurrentAttendee(val);
    debugPrint(
        '${attendee.externalUserId} has been ${mute ? 'muted' : 'unmuted'}');
  }

  void _updateCurrentAttendee(AttendeeModel attendee, {bool isRemove = false}) {
    var val = Map<String, AttendeeModel>.from(currAttendees.value);
    if (isRemove) {
      val.remove(attendee.attendeeId);
    } else {
      val[attendee.attendeeId] = attendee;
    }
    currAttendees.add(val);
    debugPrint(
        'currAttendees: ${currAttendees.value} value is changed in here');
  }

  @override
  void messageDidReceive(MessageModel msg) {
    print("message received in here ${msg.attendeeId}, ${msg.message}");
    if (msg.throttled ?? false) {
      return;
    }
    if ((receivedMessage.value?.timestampMs ?? 0) > msg.timestampMs) {
      return;
    }
    receivedMessage.add(msg);
  }
}

void hideControl() {
  try {
    MeetingModel().hideControlInSeconds();
    // ignore: empty_catches
  } catch (e) {
    debugPrint("Error hide $e");
  }
}
