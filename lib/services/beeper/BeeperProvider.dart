//! import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import 'package:amigotools/config/services/BeeperConfig.dart';

class BeeperProvider
{
  //! final _audioPlayer = AudioCache(prefix: BeeperConfig.SoundsFilesPath);

  void noise(SignalTypes type)
  {
    sound(type);
    vibrate(type);
  }

  void sound(SignalTypes type)
  {
    // todo: do first time: player.loadAll(['explosion.mp3', 'music.mp3'])
    // todo: audio_service: ^0.17.1

    final pattern = BeeperConfig.Patterns[type];

    if (pattern?.item2 != null)
    {
      //! _audioPlayer.play(pattern!.item2!);
    }
  }

  void vibrate(SignalTypes type)
  {
    final pattern = BeeperConfig.Patterns[type];

    if (pattern?.item1 != null)
    {
      Vibration.vibrate(pattern: pattern!.item1!);
    }
    else
    {
      Vibration.vibrate();
      print("Unknown SignalType $type");
    }
  }
}