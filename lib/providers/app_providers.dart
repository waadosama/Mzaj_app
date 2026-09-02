import 'package:flutter/foundation.dart';

import '../models/playlist.dart';
import '../models/song.dart';
import '../services/audio_service.dart';
import '../services/itunes_api.dart';
import '../services/playlist_database.dart';

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

  Future<void> pause() async {
    if (currentSong == null) return;
    await _audio.pause();
    notifyListeners();
  }

  bool isCurrentSong(Song song) => _audio.currentSong?.id == song.id;

  Future<void> stop() => _audio.stop();

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }
}

class PlaylistProvider extends ChangeNotifier {
  PlaylistProvider(this._database);

  final PlaylistDatabase _database;

  List<Playlist> _playlists = [];
  Playlist? _currentPlaylist;
  bool _isLoading = false;
  String? _errorMessage;

  List<Playlist> get playlists => _playlists;
  Playlist? get currentPlaylist => _currentPlaylist;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPlaylists() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _playlists = await _database.getAllPlaylists();
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to load playlists: ${e.toString()}';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<bool> createPlaylist(String name, {String description = ''}) async {
    try {
      final playlist = Playlist(
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      final id = await _database.createPlaylist(playlist);
      final newPlaylist = playlist.copyWith(id: id);
      _playlists.add(newPlaylist);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create playlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<Playlist?> createMoodPlaylist(String mood, List<Song> songs) async {
    if (songs.isEmpty) return null;

    try {
      final playlist = Playlist(
        name: '$mood Mood',
        description: 'A playlist made for your $mood mood.',
        createdAt: DateTime.now(),
      );
      final playlistId = await _database.createPlaylist(playlist);
      for (final song in songs) {
        await _database.addSongToPlaylist(playlistId, song);
      }

      final savedPlaylist = playlist.copyWith(id: playlistId, songs: songs);
      _playlists.add(savedPlaylist);
      notifyListeners();
      return savedPlaylist;
    } catch (e) {
      _errorMessage = 'Failed to create mood playlist: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deletePlaylist(int playlistId) async {
    try {
      await _database.deletePlaylist(playlistId);
      _playlists.removeWhere((p) => p.id == playlistId);
      if (_currentPlaylist?.id == playlistId) {
        _currentPlaylist = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete playlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadPlaylistWithSongs(int playlistId) async {
    try {
      _currentPlaylist = await _database.getPlaylistWithSongs(playlistId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load playlist: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> addSongToPlaylist(int playlistId, Song song) async {
    try {
      await _database.addSongToPlaylist(playlistId, song);
      if (_currentPlaylist?.id == playlistId) {
        _currentPlaylist = await _database.getPlaylistWithSongs(playlistId);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add song: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeSongFromPlaylist(int playlistId, int songId) async {
    try {
      await _database.removeSongFromPlaylist(playlistId, songId);
      if (_currentPlaylist?.id == playlistId) {
        _currentPlaylist = await _database.getPlaylistWithSongs(playlistId);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to remove song: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePlaylist(Playlist playlist) async {
    try {
      await _database.updatePlaylist(playlist);
      final index = _playlists.indexWhere((p) => p.id == playlist.id);
      if (index >= 0) {
        _playlists[index] = playlist;
      }
      if (_currentPlaylist?.id == playlist.id) {
        _currentPlaylist = playlist;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update playlist: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
