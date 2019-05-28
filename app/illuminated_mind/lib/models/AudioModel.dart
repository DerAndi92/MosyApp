import 'package:audioplayers/audio_cache.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class AudioModel extends Model {
  static AudioCache player = AudioCache(prefix: 'audio/');

  static AudioModel of(BuildContext context) =>
      ScopedModel.of<AudioModel>(context);

  loadAudio() {
    player.loadAll(['magic.mp3']);
  }

  play(String name) {
    player.play(name);
  }
}
