/// Song model — maps 1:1 to the normalized shape from ytmusic.wrapper.js normItem/normTrack.
class Song {
  final String id;
  final String videoId;
  final String title;
  final String artist;
  final String album;
  final String thumbnail;
  final int duration; // seconds
  final String? browseId;
  final String? playlistId;
  final String? albumBrowseId;
  final String? artistBrowseId;
  final String? year;
  final String? itemCount;
  final String type; // SONG, ALBUM, PLAYLIST, ARTIST, SINGLE

  const Song({
    required this.id,
    required this.videoId,
    required this.title,
    required this.artist,
    this.album = '',
    this.thumbnail = '',
    this.duration = 0,
    this.browseId,
    this.playlistId,
    this.albumBrowseId,
    this.artistBrowseId,
    this.year,
    this.itemCount,
    this.type = 'SONG',
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    final videoId = json['videoId']?.toString() ?? json['id']?.toString() ?? '';
    return Song(
      id: json['id']?.toString() ?? videoId,
      videoId: videoId,
      title: json['title']?.toString() ?? 'Unknown',
      artist: json['artist']?.toString() ?? 'Unknown',
      album: json['album']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ??
          json['cover']?.toString() ??
          json['artworkUrl']?.toString() ??
          '',
      duration: (json['duration'] is int)
          ? json['duration'] as int
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      browseId: json['browseId']?.toString(),
      playlistId: json['playlistId']?.toString(),
      albumBrowseId: json['albumBrowseId']?.toString(),
      artistBrowseId: json['artistBrowseId']?.toString(),
      year: json['year']?.toString(),
      itemCount: json['itemCount']?.toString(),
      type: json['type']?.toString() ?? 'SONG',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'videoId': videoId,
        'title': title,
        'artist': artist,
        'album': album,
        'thumbnail': thumbnail,
        'duration': duration,
        'browseId': browseId,
        'playlistId': playlistId,
        'albumBrowseId': albumBrowseId,
        'artistBrowseId': artistBrowseId,
        'year': year,
        'itemCount': itemCount,
        'type': type,
      };

  /// Whether this is a playable song (11-char YouTube video ID).
  bool get isPlayable => videoId.length == 11;

  Song copyWith({
    String? id,
    String? videoId,
    String? title,
    String? artist,
    String? album,
    String? thumbnail,
    int? duration,
    String? browseId,
    String? playlistId,
    String? albumBrowseId,
    String? artistBrowseId,
    String? year,
    String? itemCount,
    String? type,
  }) {
    return Song(
      id: id ?? this.id,
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      browseId: browseId ?? this.browseId,
      playlistId: playlistId ?? this.playlistId,
      albumBrowseId: albumBrowseId ?? this.albumBrowseId,
      artistBrowseId: artistBrowseId ?? this.artistBrowseId,
      year: year ?? this.year,
      itemCount: itemCount ?? this.itemCount,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
