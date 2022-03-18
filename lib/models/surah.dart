import 'dart:convert';

class Surah {
  final String id;
  final String name;
  Surah({
    required this.id,
    required this.name,
  });

  Surah copyWith({
    String? id,
    String? name,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      id: map['id'] ?? '',
      name: map['name'].replaceAll('\n', '').replaceAll('\r', '') ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Surah.fromJson(String source) => Surah.fromMap(json.decode(source));

  @override
  String toString() => 'Surah(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Surah && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}