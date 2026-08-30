import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

class AudioService {
  AudioService() : _player = AudioPlayer();

  final AudioPlayer _player;
  Song? _currentSong;

  Song? get currentSong => _currentSong;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  bool get isPlaying => _player.playing;

  Future<void> playPreview(Song song) async {
    if (!song.hasPreview) return;

    if (_currentSong?.id == song.id) {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
      return;
    }

    _currentSong = song;
    await _player.setUrl(song.previewUrl!);
    await _player.play();
  }

  Future<void> pause() async {
    if (!_player.playing) return;
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
