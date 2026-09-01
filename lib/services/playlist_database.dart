import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/playlist.dart';
import '../models/song.dart';

class PlaylistDatabase {
  static const String _playlistsTable = 'playlists';
  static const String _playlistSongsTable = 'playlist_songs';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'mzaj_playlists.db');

    return openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_playlistsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_playlistSongsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlistId INTEGER NOT NULL,
        trackId INTEGER NOT NULL,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        album TEXT NOT NULL,
        previewUrl TEXT,
        artworkUrl100 TEXT,
        trackTimeMillis INTEGER,
        FOREIGN KEY (playlistId) REFERENCES $_playlistsTable (id) ON DELETE CASCADE,
        UNIQUE (playlistId, trackId)
      )
    ''');
  }

  /// Create a new playlist
  Future<int> createPlaylist(Playlist playlist) async {
    final db = await database;
    return await db.insert(_playlistsTable, playlist.toMap());
  }

  /// Get all playlists
  Future<List<Playlist>> getAllPlaylists() async {
    final db = await database;
    final maps = await db.query(_playlistsTable);
    return List.generate(maps.length, (i) => Playlist.fromMap(maps[i]));
  }

  /// Get a specific playlist with all its songs
  Future<Playlist?> getPlaylistWithSongs(int playlistId) async {
    final db = await database;
    final playlistMaps = await db.query(
      _playlistsTable,
      where: 'id = ?',
      whereArgs: [playlistId],
    );

    if (playlistMaps.isEmpty) return null;

    final playlist = Playlist.fromMap(playlistMaps.first);
    final songMaps = await db.query(
      _playlistSongsTable,
      where: 'playlistId = ?',
      whereArgs: [playlistId],
    );

    final songs = songMaps.map((map) => Song.fromJson(map)).toList();
    return playlist.copyWith(songs: songs);
  }

  /// Add a song to a playlist
  Future<void> addSongToPlaylist(int playlistId, Song song) async {
    final db = await database;
    try {
      await db.insert(_playlistSongsTable, {
        'playlistId': playlistId,
        'trackId': song.id,
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'previewUrl': song.previewUrl,
        'artworkUrl100': song.artworkUrl,
        'trackTimeMillis': song.durationMs,
      });
    } catch (e) {
      // Song already exists in playlist - ignore duplicate insertion
      if (!e.toString().contains('UNIQUE')) rethrow;
    }
  }

  /// Remove a song from a playlist
  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await database;
    await db.delete(
      _playlistSongsTable,
      where: 'playlistId = ? AND trackId = ?',
      whereArgs: [playlistId, songId],
    );
  }

  /// Update playlist metadata
  Future<void> updatePlaylist(Playlist playlist) async {
    final db = await database;
    await db.update(
      _playlistsTable,
      playlist.toMap(),
      where: 'id = ?',
      whereArgs: [playlist.id],
    );
  }

  /// Delete a playlist and all its songs
  Future<void> deletePlaylist(int playlistId) async {
    final db = await database;
    await db.delete(_playlistsTable, where: 'id = ?', whereArgs: [playlistId]);
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
