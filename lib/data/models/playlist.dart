import 'song.dart';

/// Playlist model for both Firestore playlists and YT Music playlists.
class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? thumbnail;
  final String createdBy;
  final String ownerName;
  final List<String> members;
  final List<Song> songs;
  final String visibility;
  final String type; // 'PULSE', 'YTM_PLAYLIST', 'YTM_ALBUM'
  final int? totalTracks; // Header-reported total (may exceed songs.length)
  final DateTime? createdAt;
  final DateTime? lastPlayedAt;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.thumbnail,
    this.createdBy = '',
    this.ownerName = '',
    this.members = const [],
    this.songs = const [],
    this.visibility = 'Public',
    this.type = 'PULSE',
    this.totalTracks,
    this.createdAt,
    this.lastPlayedAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Playlist',
      description: json['description']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      createdBy: json['createdBy']?.toString() ?? '',
      ownerName: json['ownerName']?.toString() ?? '',
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      songs: (json['songs'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (json['tracks'] as List<dynamic>?)
                  ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      visibility: json['visibility']?.toString() ?? 'Public',
      type: json['type']?.toString() ?? 'PULSE',
      totalTracks: json['totalTracks'] as int?,
    );
  }

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnail,
    List<Song>? songs,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      createdBy: createdBy,
      ownerName: ownerName,
      members: members,
      songs: songs ?? this.songs,
      visibility: visibility,
      type: type,
      totalTracks: totalTracks,
      createdAt: createdAt,
      lastPlayedAt: lastPlayedAt,
    );
  }
}
