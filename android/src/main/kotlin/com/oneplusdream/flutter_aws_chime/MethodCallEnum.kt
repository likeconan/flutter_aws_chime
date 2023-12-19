package com.oneplusdream.flutter_aws_chime

enum class MethodCall(val call: String) {
    manageAudioPermissions("manageAudioPermissions"),
    manageVideoPermissions("manageVideoPermissions"),
    initialAudioSelection("initialAudioSelection"),
    join("join"),
    stop("stop"),
    leave("leave"),
    drop("drop"),
    mute("mute"),
    unmute("unmute"),
    startLocalVideo("startLocalVideo"),
    stopLocalVideo("stopLocalVideo"),
    videoTileAdd("videoTileAdd"),
    videoTileRemove("videoTileRemove"),
    listAudioDevices("listAudioDevices"),
    updateAudioDevice("updateAudioDevice"),
    audioSessionDidStop("audioSessionDidStop"),
    sendMessage("sendMessage"),
    messageReceived("messageReceived"),
}