import 'package:audioplayers/audio_cache.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class AudioModel extends Model {
  static AudioCache player = AudioCache(prefix: 'audio/');
}

/////
///

class Audio {
  static AudioCache player = AudioCache(prefix: 'audio/');

  Audio() {
    player.loadAll(['magic.mp3']);
  }
}
