extension YoutubeThumbnailExt on String {
  String getYoutubeThumbnail({
    ThumbnailQuality quality = ThumbnailQuality.high,
  }) {
    final videoId = extractYoutubeVideoId();
    if (videoId == null) return '';
    return 'https://img.youtube.com/vi/$videoId/${quality.fileName}';
  }

  String? extractYoutubeVideoId() {
    final cleanUrl = trim();
    if (cleanUrl.isEmpty) return null;

    // لو الـ input هو الـ video ID مباشرةً (11 حرف)
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(cleanUrl)) {
      return cleanUrl;
    }

    Uri? uri;
    try {
      uri = Uri.parse(cleanUrl);
    } catch (_) {
      return null;
    }

    // ✅ scheme validation - نقبل https و http بس
    if (uri.scheme != 'https' && uri.scheme != 'http') return null;

    final host = uri.host.replaceFirst('www.', '').replaceFirst('m.', '');

    // youtu.be/VIDEO_ID
    if (host == 'youtu.be') {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      return _validateId(id);
    }

    if (host == 'youtube.com' || host == 'youtube-nocookie.com') {
      final path = uri.path;

      // /watch?v=VIDEO_ID
      if (uri.queryParameters.containsKey('v')) {
        return _validateId(uri.queryParameters['v']);
      }

      // /embed/ /v/ /shorts/ /live/
      final pathPatterns = ['/embed/', '/v/', '/shorts/', '/live/'];
      for (final pattern in pathPatterns) {
        if (path.startsWith(pattern)) {
          final segments = uri.pathSegments;
          if (segments.length >= 2) {
            return _validateId(segments[1]);
          }
        }
      }

      // /attribution_link?u=/watch?v=VIDEO_ID
      if (path == '/attribution_link') {
        final u = uri.queryParameters['u'];
        if (u != null) {
          return u.extractYoutubeVideoId();
        }
      }
    }

    return null;
  }

  String? _validateId(String? id) {
    if (id == null) return null;
    final clean = id.split('?').first.split('&').first;
    return RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(clean) ? clean : null;
  }
}

enum ThumbnailQuality {
  /// 120x90
  default_('default.jpg'),
  /// 120x90
  high('hqdefault.jpg'),
  /// 320x180
  medium('mqdefault.jpg'),
  /// 480x360
  standard('sddefault.jpg'),
  /// 1280x720
  max('maxresdefault.jpg');

  const ThumbnailQuality(this.fileName);
  final String fileName;
}
