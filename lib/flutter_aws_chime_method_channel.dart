import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_aws_chime_platform_interface.dart';

/// An implementation of [FlutterAwsChimePlatform] that uses method channels.
class MethodChannelFlutterAwsChime extends FlutterAwsChimePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_aws_chime');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
