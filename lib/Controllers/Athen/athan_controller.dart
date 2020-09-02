import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

/*
* in this class you can control the athan with play the athan mp3 file and pause it or stop it
*/

class AthanController extends ControllerMVC{
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");


  playAthan(String athanType){
    if(athanType == "normal"){
      assetsAudioPlayer.open(
        Audio("audios/azan_sheek_maroof.mp3"),
      );

      assetsAudioPlayer.play();
    }else if(athanType == "fajer"){
      assetsAudioPlayer.open(
        Audio("audios/azan_alfajer_sheek_maroof.mp3"),
      );

      assetsAudioPlayer.play();
    }
  }

  stopeAthan() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
  }
}