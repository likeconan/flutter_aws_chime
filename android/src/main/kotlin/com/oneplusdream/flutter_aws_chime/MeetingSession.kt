package com.oneplusdream.flutter_aws_chime

import com.amazonaws.services.chime.sdk.meetings.session.DefaultMeetingSession
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoObserver
import com.amazonaws.services.chime.sdk.meetings.audiovideo.AudioVideoFacade
import com.amazonaws.services.chime.sdk.meetings.realtime.datamessage.DataMessageObserver
import com.amazonaws.services.chime.sdk.meetings.utils.logger.ConsoleLogger

object MeetingSessionManager {
    private val meetingSessionlogger: ConsoleLogger = ConsoleLogger()

    var realtimeObserver: RealtimeObserver? = null
    var videoTileObserver: VideoTileObserver? = null
    var audioVideoObserver: AudioVideoObserver? = null
    var dataMessageObserver: DataMessageObserver? = null

    var meetingSession: DefaultMeetingSession? = null


    private val NULL_MEETING_SESSION_RESPONSE: MethodChannelResult =
            MethodChannelResult(false, Response.meeting_session_is_null.msg)

    fun startMeeting(
            realtimeObserver: RealtimeObserver? = null,
            videoTileObserver: VideoTileObserver? = null,
            audioVideoObserver: AudioVideoObserver? = null,
            dataMessageObserver: DataMessageObserver? = null
    ): MethodChannelResult {
        val audioVideo: AudioVideoFacade =
                meetingSession?.audioVideo ?: return NULL_MEETING_SESSION_RESPONSE
        addObservers(realtimeObserver, videoTileObserver, audioVideoObserver, dataMessageObserver)
        audioVideo.start()
        audioVideo.startRemoteVideo()
        return MethodChannelResult(true, Response.create_meeting_success.msg)
    }

    fun stop(): MethodChannelResult {
        meetingSession?.audioVideo?.stopRemoteVideo() ?: return NULL_MEETING_SESSION_RESPONSE
        meetingSession?.audioVideo?.stop() ?: return NULL_MEETING_SESSION_RESPONSE
        removeObservers()
        meetingSession = null
        return MethodChannelResult(true, Response.meeting_stopped_successfully.msg)
    }

    private fun addObservers(
            realtimeObserver: RealtimeObserver?,
            videoTileObserver: VideoTileObserver?,
            audioVideoObserver: AudioVideoObserver?,
            dataMessageObserver: DataMessageObserver?,
    ) {
        val audioVideo: AudioVideoFacade = meetingSession?.audioVideo ?: return
        realtimeObserver?.let {
            audioVideo.addRealtimeObserver(it)
            this.realtimeObserver = realtimeObserver
            meetingSessionlogger.debug("RealtimeObserver", "RealtimeObserver initialized")
        }
        audioVideoObserver?.let {
            audioVideo.addAudioVideoObserver(it)
            this.audioVideoObserver = audioVideoObserver
            meetingSessionlogger.debug("AudioVideoObserver", "AudioVideoObserver initialized")
        }
        videoTileObserver?.let {
            audioVideo.addVideoTileObserver(videoTileObserver)
            this.videoTileObserver = videoTileObserver
            meetingSessionlogger.debug("VideoTileObserver", "VideoTileObserver initialized")
        }

        dataMessageObserver?.let {
            audioVideo.addRealtimeDataMessageObserver("chat", dataMessageObserver)
            this.dataMessageObserver = dataMessageObserver
            meetingSessionlogger.debug("DataMessageObserver", "DataMessageObserver initialized")
        }
    }

    private fun removeObservers() {
        realtimeObserver?.let {
            meetingSession?.audioVideo?.removeRealtimeObserver(it)
        }
        audioVideoObserver?.let {
            meetingSession?.audioVideo?.removeAudioVideoObserver(it)
        }
        videoTileObserver?.let {
            meetingSession?.audioVideo?.removeVideoTileObserver(it)
        }
        dataMessageObserver?.let {
            meetingSession?.audioVideo?.removeRealtimeDataMessageObserverFromTopic("chat")
        }
    }
}
