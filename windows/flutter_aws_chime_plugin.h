#ifndef FLUTTER_PLUGIN_FLUTTER_AWS_CHIME_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_AWS_CHIME_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_aws_chime {

class FlutterAwsChimePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterAwsChimePlugin();

  virtual ~FlutterAwsChimePlugin();

  // Disallow copy and assign.
  FlutterAwsChimePlugin(const FlutterAwsChimePlugin&) = delete;
  FlutterAwsChimePlugin& operator=(const FlutterAwsChimePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_aws_chime

#endif  // FLUTTER_PLUGIN_FLUTTER_AWS_CHIME_PLUGIN_H_
