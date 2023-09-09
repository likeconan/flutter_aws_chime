
import 'flutter_aws_chime_platform_interface.dart';

class FlutterAwsChime {
  Future<String?> getPlatformVersion() {
    return FlutterAwsChimePlatform.instance.getPlatformVersion();
  }
}
