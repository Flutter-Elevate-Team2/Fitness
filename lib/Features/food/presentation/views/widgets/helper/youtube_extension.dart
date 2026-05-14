extension YoutubeExtension on String {
  String get youtubeId {
    final uri = Uri.parse(this);

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first;
    } else if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }

    return '';
  }

  String get youtubeThumbnail {
    return "https://img.youtube.com/vi/$youtubeId/hqdefault.jpg";
  }
}