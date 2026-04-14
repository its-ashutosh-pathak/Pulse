import 'song.dart';

/// Home feed section — maps to ytmusic.wrapper.js getHome() output.
class HomeSection {
  final String title;
  final List<Song> items;

  const HomeSection({required this.title, required this.items});

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      title: json['title']?.toString() ?? 'Recommended',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
