import 'package:flutter/foundation.dart';

import '../models/song.dart';
import '../services/audio_service.dart';
import '../services/itunes_api.dart';

enum SearchStatus { idle, loading, success, error }

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._api);

  final ItunesApi _api;

  SearchStatus status = SearchStatus.idle;
  List<Song> results = [];
  String? errorMessage;
  String lastQuery = '';

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      clear();
      return;
    }

    if (trimmed == lastQuery && status == SearchStatus.success) return;

    lastQuery = trimmed;
    status = SearchStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      results = await _api.searchSongs(trimmed);
      status = SearchStatus.success;
      if (results.isEmpty) {
        errorMessage = 'No previewable tracks found. Try another vibe.';
      }
    } on ItunesApiException catch (e) {
      status = SearchStatus.error;
      errorMessage = e.message;
      results = [];
    } catch (_) {
      status = SearchStatus.error;
      errorMessage = 'Something went wrong. Check your connection.';
      results = [];
    }

    notifyListeners();
  }

  void clear() {
    lastQuery = '';
    status = SearchStatus.idle;
    results = [];
    errorMessage = null;
    notifyListeners();
  }
}

class PlayerProvider extends ChangeNotifier {
  PlayerProvider(this._audio);

  final AudioService _audio;

  Song? get currentSong => _audio.currentSong;
  Stream<Duration> get positionStream => _audio.positionStream;
  Stream<Duration?> get durationStream => _audio.durationStream;
  bool get isPlaying => _audio.isPlaying;

  void init() {
    _audio.playerStateStream.listen((_) => notifyListeners());
  }

  Future<void> togglePreview(Song song) => _audio.playPreview(song);

  Future<void> toggleCurrent() async {
    final song = currentSong;
    if (song == null) return;
    await togglePreview(song);
  }

  bool isCurrentSong(Song song) => _audio.currentSong?.id == song.id;

  Future<void> stop() => _audio.stop();

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }
}
