import 'package:mzaj/models/song.dart';

class Playlist {
  final int? id;
  final String name;
  final String description;
  final DateTime createdAt;
  final List<Song> songs;

  Playlist({
    this.id,
    required this.name,
    this.description = '',
    required this.createdAt,
    this.songs = const [],
  });

  int get songCount => songs.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Playlist copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    List<Song>? songs,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      songs: songs ?? this.songs,
    );
  }
}
