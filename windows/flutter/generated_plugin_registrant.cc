//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <lychee_player/media_player_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <system_clock/system_clock_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  MediaPlayerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MediaPlayerPlugin"));
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  SystemClockPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemClockPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
