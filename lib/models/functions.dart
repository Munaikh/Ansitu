import 'dart:convert';
import 'package:dio/dio.dart';
import '/models/app_data.dart';
import '/models/reader.dart';
import '/models/surah.dart';

Future<void> getSurahList() async {
  var surahJson;

  try {
    surahJson =
        await Dio().get('https://www.mp3quran.net/api/arabic__sura.json');
  } catch (e) {
    print(e);
  }

  AppData.suraList = List.generate(
    (surahJson.data['Suras_Name'] as List).length,
    (index) => Surah.fromMap(
        (surahJson.data['Suras_Name'] as List)[index] as Map<String, dynamic>),
  );
}

Future<void> getReaderList() async {
  var readersJson;

  try {
    readersJson = await Dio().get('https://www.mp3quran.net/api/_arabic.json');
  } catch (e) {
    print(e);
  }

  // print(readersJson.data);
  // print((jsonDecode(readersJson.data)['reciters'] as List));
  var data = jsonDecode(readersJson.data)['reciters'] as List;
  AppData.readerList = List.generate(
    data.length,
    (index) => Reader.fromMap(data[index] as Map<String, dynamic>),
  );
}

// Future<void> loadAppData() async {
//   final prefs = await SharedPreferences.getInstance();
//   List<String>? res = await prefs.getStringList('AppData');

//   if (res != null) {
//     for (var reader in res) {
//       AppData.favoriteReaders.add(Reader.fromJson(reader));
//     }
//   }
// }

// Future<void> saveAppData() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setStringList(
//       'AppData',
//       List<String>.generate(AppData.favoriteReaders.length,
//           (index) => AppData.favoriteReaders[index].toJson()));
// }
