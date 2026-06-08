/// Thumbnail utilities — port of frontend/src/utils.js getHighResThumb.
class ThumbnailUtils {
  ThumbnailUtils._();

  /// Upgrades a YouTube/Google thumbnail URL to higher resolution.
  /// Non-destructive: returns original URL if parsing fails.
  static String getHighRes(String? url, {int size = 500}) {
    if (url == null || url.isEmpty) return '';

    // Force HTTPS
    var result = url.replaceFirst('http://', 'https://');
    if (result.startsWith('//')) {
      result = 'https:$result';
    }

    try {
      // Handle lh3.googleusercontent.com / ggpht.com (YouTube Music art)
      if (result.contains('googleusercontent.com') ||
          result.contains('ggpht.com')) {
        var newUrl = result.replaceFirstMapped(
          RegExp(r'=w\d+-h\d+'),
          (m) => '=w$size-h$size',
        );
        if (newUrl == result) {
          newUrl = result.replaceFirstMapped(
            RegExp(r'=s\d+'),
            (m) => '=s$size',
          );
        }
        
        // If it doesn't have size params but has -c, we can append the size param
        if (newUrl == result && !result.contains('=w') && !result.contains('=s')) {
            if (result.contains('-c')) {
                newUrl = result.replaceFirst('-c', '=w$size-h$size-c');
            } else {
                newUrl = '$result=w$size-h$size';
            }
        }
        
        return newUrl;
      }

      // Handle i.ytimg.com thumbnails
      if (result.contains('i.ytimg.com')) {
        if (result.contains('maxresdefault')) return result;
        if (result.contains('hqdefault')) {
          return result.replaceFirst('hqdefault', 'mqdefault');
        }
        return result;
      }

      // Handle YouTube Music thumbnails with /vi/ path
      if (result.contains('ytimg.com') && result.contains('/vi/')) {
        return result.replaceFirstMapped(
          RegExp(r'/(default|mqdefault|hqdefault|sddefault)\.jpg'),
          (m) => '/hqdefault.jpg',
        );
      }
    } catch (_) {
      // If parsing fails, return original
    }

    return result;
  }
}
