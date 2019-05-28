import 'package:audioplayers/audio_cache.dart';

class Audio {
  static AudioCache player = AudioCache(prefix: 'audio/');

  Audio() {
    player.loadAll(['magic.mp3']);
  }

}