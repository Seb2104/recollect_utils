#include "include/recollect_utils/recollect_utils_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "recollect_utils_plugin.h"

void RecollectUtilsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  recollect_utils::RecollectUtilsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
