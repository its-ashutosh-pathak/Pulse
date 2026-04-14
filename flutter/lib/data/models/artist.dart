import 'song.dart';

/// Artist model — maps to ytmusic.wrapper.js getArtist() output.
class Artist {
  final String browseId;
  final String name;
  final String description;
  final String thumbnail;
  final String subscribers;
  final List<Song> topSongs;
  final List<ArtistAlbum> albums;
  final List<ArtistAlbum> singles;

  const Artist({
    required this.browseId,
    required this.name,
    this.description = '',
    this.thumbnail = '',
    this.subscribers = '',
    this.topSongs = const [],
    this.albums = const [],
    this.singles = const [],
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      browseId: json['browseId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Artist',
      description: json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      subscribers: json['subscribers']?.toString() ?? '',
      topSongs: (json['topSongs'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      albums: (json['albums'] as List<dynamic>?)
              ?.map((e) => ArtistAlbum.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      singles: (json['singles'] as List<dynamic>?)
              ?.map((e) => ArtistAlbum.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ArtistAlbum {
  final String browseId;
  final String title;
  final String year;
  final String thumbnail;
  final String type;

  const ArtistAlbum({
    required this.browseId,
    required this.title,
    this.year = '',
    this.thumbnail = '',
    this.type = 'ALBUM',
  });

  factory ArtistAlbum.fromJson(Map<String, dynamic> json) {
    return ArtistAlbum(
      browseId: json['browseId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      type: json['type']?.toString() ?? 'ALBUM',
    );
  }
}
