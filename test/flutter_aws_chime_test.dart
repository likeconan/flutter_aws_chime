import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aws_chime/flutter_aws_chime.dart';
import 'package:flutter_aws_chime/flutter_aws_chime_platform_interface.dart';
import 'package:flutter_aws_chime/flutter_aws_chime_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAwsChimePlatform
    with MockPlatformInterfaceMixin
    implements FlutterAwsChimePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAwsChimePlatform initialPlatform = FlutterAwsChimePlatform.instance;

  test('$MethodChannelFlutterAwsChime is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAwsChime>());
  });

  test('getPlatformVersion', () async {
    FlutterAwsChime flutterAwsChimePlugin = FlutterAwsChime();
    MockFlutterAwsChimePlatform fakePlatform = MockFlutterAwsChimePlatform();
    FlutterAwsChimePlatform.instance = fakePlatform;

    expect(await flutterAwsChimePlugin.getPlatformVersion(), '42');
  });
}
