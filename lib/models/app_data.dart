import 'package:assets_audio_player/assets_audio_player.dart';

import 'reader.dart';
import 'surah.dart';

class AppData {
  static List<Surah> suraList = [];
  static List<Reader> readerList = [];
  static List<Reader> favoriteReaders = [];

  static final assetsAudioPlayer = AssetsAudioPlayer();

  String toJSON() {
    Map<String, List> json = {
      'favoriteReaders': favoriteReaders,
    };
    return json.toString();
  }
}
