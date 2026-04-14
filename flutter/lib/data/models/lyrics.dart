/// Lyrics model — supports both synced (line-by-line timestamps) and plain text.
class Lyrics {
  final String? plainText;
  final List<SyncedLine>? syncedLines;
  final String source; // 'lrclib', 'musixmatch', 'genius', 'youtube_music'
  final bool isSynced;

  const Lyrics({
    this.plainText,
    this.syncedLines,
    required this.source,
    this.isSynced = false,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    final lines = json['syncedLyrics'] ?? json['lines'];
    List<SyncedLine>? syncedLines;
    bool isSynced = false;

    if (lines is List && lines.isNotEmpty) {
      syncedLines = lines
          .map((e) => SyncedLine.fromJson(e as Map<String, dynamic>))
          .toList();
      isSynced = true;
    }

    return Lyrics(
      plainText: json['plainLyrics']?.toString() ??
          json['lyrics']?.toString() ??
          json['text']?.toString(),
      syncedLines: syncedLines,
      source: json['source']?.toString() ?? 'unknown',
      isSynced: isSynced,
    );
  }

  Map<String, dynamic> toJson() => {
        'plainLyrics': plainText,
        'syncedLyrics': syncedLines?.map((e) => e.toJson()).toList(),
        'source': source,
      };
}

class SyncedLine {
  final double timestamp; // seconds
  final String text;

  const SyncedLine({required this.timestamp, required this.text});

  factory SyncedLine.fromJson(Map<String, dynamic> json) {
    return SyncedLine(
      timestamp: (json['time'] ?? json['timestamp'] ?? 0).toDouble(),
      text: json['text']?.toString() ?? json['line']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'time': timestamp, 'text': text};
}
