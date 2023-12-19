package com.oneplusdream.flutter_aws_chime

import com.amazonaws.services.chime.sdk.meetings.audiovideo.video.VideoTileState
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessage
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessageObserver

class DataMessageObserver(val methodChannel: MethodChannelCoordinator) : DataMessageObserver {
    override fun onDataMessageReceived(dataMessage: DataMessage) {
        methodChannel.callFlutterMethod(MethodCall.messageReceived, dataMessageToMap(dataMessage))
    }

    private fun dataMessageToMap(state: DataMessage): Map<String, Any?> {
        return mapOf(
                "attendeeId" to state.senderAttendeeId,
                "externalUserId" to state.senderExternalUserId,
                "topic" to state.topic,
                "timestampMs" to state.timestampMs,
                "message" to String(state.data),
                "throttled" to state.throttled
        )
    }
}