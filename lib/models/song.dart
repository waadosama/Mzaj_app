class Song {
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    this.previewUrl,
    this.artworkUrl,
    this.durationMs,
  });

  final int id;
  final String title;
  final String artist;
  final String album;
  final String? previewUrl;
  final String? artworkUrl;
  final int? durationMs;

  bool get hasPreview => previewUrl != null && previewUrl!.isNotEmpty;

  String get highResArtwork {
    if (artworkUrl == null) return '';
    return artworkUrl!.replaceAll('100x100bb', '300x300bb');
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    // Handle both iTunes API format and database format
    return Song(
      id: json['trackId'] as int? ?? json['id'] as int? ?? 0,
      title:
          json['trackName'] as String? ??
          json['title'] as String? ??
          'Unknown Track',
      artist:
          json['artistName'] as String? ??
          json['artist'] as String? ??
          'Unknown Artist',
      album:
          json['collectionName'] as String? ??
          json['album'] as String? ??
          'Unknown Album',
      previewUrl: json['previewUrl'] as String?,
      artworkUrl: json['artworkUrl100'] as String?,
      durationMs: json['trackTimeMillis'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'trackId': id,
    'trackName': title,
    'artistName': artist,
    'collectionName': album,
    'previewUrl': previewUrl,
    'artworkUrl100': artworkUrl,
    'trackTimeMillis': durationMs,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
