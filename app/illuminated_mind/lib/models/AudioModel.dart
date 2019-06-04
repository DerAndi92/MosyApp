import 'package:audioplayers/audio_cache.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class AudioModel extends Model {
  static AudioCache player = AudioCache(prefix: 'audio/');

  static AudioModel of(BuildContext context) =>
      ScopedModel.of<AudioModel>(context);

  loadAudio() {
    player.loadAll([
      'rune_1.mp3',
      'rune_2.mp3',
      'rune_3.mp3',
      'rune_4.mp3',
      'rune_5.mp3',
      'rune_6.mp3',
      'background.mp3',
    ]);
  }

  play(String name) {
    player.play(name);
  }

  playBackground() {
    player.loop('background.mp3', volume: 0.2);
  }

}
