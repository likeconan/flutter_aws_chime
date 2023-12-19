package com.oneplusdream.flutter_aws_chime

import android.util.Log
import com.amazonaws.services.chime.sdk.meetings.realtime.RealtimeObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AttendeeInfo
import com.amazonaws.services.chime.sdk.meetings.audiovideo.SignalUpdate
import com.amazonaws.services.chime.sdk.meetings.audiovideo.VolumeUpdate
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger

class RealtimeObserver(val methodChannel: MethodChannelCoordinator) : RealtimeObserver {
    private val realtimeLogger: ConsoleLogger = ConsoleLogger()
    override fun onAttendeesDropped(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                    MethodCall.drop,
                    attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesJoined(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                    MethodCall.join,
                    attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesLeft(attendeeInfo: Array<AttendeeInfo>) {
        for (currentAttendeeInfo in attendeeInfo) {
            methodChannel.callFlutterMethod(
                    MethodCall.leave,
                    attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onAttendeesMuted(attendeeInfo: Array<AttendeeInfo>) {
        realtimeLogger.debug("RealtimeObserver", "onAttendeesMuted called")
        for (currentAttendeeInfo in attendeeInfo) {
            realtimeLogger.debug("RealtimeObserver", "muted: " + currentAttendeeInfo.attendeeId)
            methodChannel.callFlutterMethod(MethodCall.mute, attendeeInfoToMap(currentAttendeeInfo))
        }
    }

    override fun onAttendeesUnmuted(attendeeInfo: Array<AttendeeInfo>) {
        realtimeLogger.debug("RealtimeObserver", "onAttendeesUnmuted called")
        for (currentAttendeeInfo in attendeeInfo) {
            realtimeLogger.debug("RealtimeObserver", "unmuted: " + currentAttendeeInfo.attendeeId)
            methodChannel.callFlutterMethod(
                    MethodCall.unmute,
                    attendeeInfoToMap(currentAttendeeInfo)
            )
        }
    }

    override fun onSignalStrengthChanged(signalUpdates: Array<SignalUpdate>) {
        // Out of Scope
    }

    override fun onVolumeChanged(volumeUpdates: Array<VolumeUpdate>) {
        // Out of Scope
    }

    private fun attendeeInfoToMap(attendee: AttendeeInfo): Map<String, Any?> {
        return mapOf(
                "attendeeId" to attendee.attendeeId,
                "externalUserId" to attendee.externalUserId
        )
    }
}