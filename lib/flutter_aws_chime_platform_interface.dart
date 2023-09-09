import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_aws_chime_method_channel.dart';

abstract class FlutterAwsChimePlatform extends PlatformInterface {
  /// Constructs a FlutterAwsChimePlatform.
  FlutterAwsChimePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAwsChimePlatform _instance = MethodChannelFlutterAwsChime();

  /// The default instance of [FlutterAwsChimePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAwsChime].
  static FlutterAwsChimePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAwsChimePlatform] when
  /// they register themselves.
  static set instance(FlutterAwsChimePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
