/// Format duration in seconds to mm:ss or hh:mm:ss string.
String formatDuration(int seconds) {
  if (seconds <= 0) return '0:00';
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;

  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  return '$minutes:${secs.toString().padLeft(2, '0')}';
}

/// Format a Duration object to mm:ss.
String formatPosition(Duration position) {
  final total = position.inSeconds;
  if (total <= 0) return '0:00';
  final minutes = total ~/ 60;
  final seconds = total % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

/// Format a number with K/M suffixes.
String formatCount(int count) {
  if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
  return count.toString();
}
