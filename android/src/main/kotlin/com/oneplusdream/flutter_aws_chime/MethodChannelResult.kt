package com.oneplusdream.flutter_aws_chime

class MethodChannelResult(val result: Boolean, val arguments: Any?) {

    fun toFlutterCompatibleType(): Map<String, Any?> {
        return mapOf("result" to result, "arguments" to arguments)
    }
}