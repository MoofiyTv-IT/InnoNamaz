import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:inno_namaz/resources/strings.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

/*
* in this class you can control the athan with play the athan mp3 file and pause it or stop it
*/
final athanMap = {
  al_sheek_maroof : al_sheek_maroof_athan_mp3,
};


class AthanController extends ControllerMVC {
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  playAthan() {
      assetsAudioPlayer.open(
        Audio(
          al_sheek_maroof_athan_mp3,
        ),
      );

      assetsAudioPlayer.play();
  }

  stopeAthan() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
  }
}
