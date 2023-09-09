#include "include/flutter_aws_chime/flutter_aws_chime_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_aws_chime_plugin.h"

void FlutterAwsChimePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_aws_chime::FlutterAwsChimePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
