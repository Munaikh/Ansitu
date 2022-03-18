import 'package:dio/dio.dart';
import '/models/app_data.dart';
import 'dart:convert';
import 'surah.dart';
import 'package:collection/collection.dart';

class Reader {
  final String id;
  final String name;
  final String server;
  final String rewaya;
  final String count;
  final String letter;
  final List<Surah> suras;
  String? instagram;
  String? twitter;
  String? youtube;

  Reader({
    required this.id,
    required this.name,
    required this.server,
    required this.rewaya,
    required this.count,
    required this.letter,
    required this.suras,
    this.instagram = '',
    this.twitter = '',
    this.youtube = '',
  });

  Reader copyWith({
    String? id,
    String? name,
    String? server,
    String? rewaya,
    String? count,
    String? letter,
    List<Surah>? suras,
  }) {
    return Reader(
      id: id ?? this.id,
      name: name ?? this.name,
      server: server ?? this.server,
      rewaya: rewaya ?? this.rewaya,
      count: count ?? this.count,
      letter: letter ?? this.letter,
      suras: suras ?? this.suras,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'server': server,
      'rewaya': rewaya,
      'count': count,
      'letter': letter,
      'suras': suras.map((x) => x.toMap()).toList(),
    };
  }

  factory Reader.fromMap(Map<String, dynamic> map) {
    String suras = map['suras'];
    List<Surah> finalSuras = [];

    suras.split(',').forEach((id) {
      finalSuras.add(AppData.suraList.where((surah) => surah.id == id).first);
    });
    return Reader(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      server: map['Server'] ?? '',
      rewaya: map['rewaya'] ?? '',
      count: map['count'] ?? '',
      letter: map['letter'] ?? '',
      suras: finalSuras,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reader.fromJson(String source) => Reader.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reader(id: $id, name: $name, server: $server, rewaya: $rewaya, count: $count, letter: $letter, suras: $suras)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Reader &&
        other.id == id &&
        other.name == name &&
        other.server == server &&
        other.rewaya == rewaya &&
        other.count == count &&
        other.letter == letter &&
        listEquals(other.suras, suras);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        server.hashCode ^
        rewaya.hashCode ^
        count.hashCode ^
        letter.hashCode ^
        suras.hashCode;
  }

  Future<String> getAudio(int surahId) async {
    print('$server/${surahId.toString().padLeft(3, '0')}.mp3');
    var audio =
        await Dio().get('$server/${surahId.toString().padLeft(3, '0')}.mp3');
    // print(audio.data);
    return audio.data;
  }
}
