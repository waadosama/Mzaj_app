import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/song.dart';

class ItunesApiException implements Exception {
  ItunesApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ItunesApi {
  static const _baseUrl = 'https://itunes.apple.com/search';

  Future<List<Song>> searchSongs(String query, {int limit = 30}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'term': trimmed,
        'entity': 'song',
        'limit': '$limit',
      },
    );

    final response = await http.get(uri).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw ItunesApiException('Search timed out'),
        );

    if (response.statusCode != 200) {
      throw ItunesApiException('Could not reach music catalog');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];

    return results
        .map((item) => Song.fromJson(item as Map<String, dynamic>))
        .where((song) => song.hasPreview)
        .toList();
  }
}
