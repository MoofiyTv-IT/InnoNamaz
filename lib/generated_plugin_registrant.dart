//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:assets_audio_player_web/web/assets_audio_player_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(PluginRegistry registry) {
  AssetsAudioPlayerWebPlugin.registerWith(registry.registrarFor(AssetsAudioPlayerWebPlugin));
  UrlLauncherPlugin.registerWith(registry.registrarFor(UrlLauncherPlugin));
  registry.registerMessageHandler();
}
