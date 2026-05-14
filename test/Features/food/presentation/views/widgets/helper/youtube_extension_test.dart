import 'package:fitness_app/Features/food/presentation/views/widgets/helper/youtube_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YoutubeExtension Tests', () {

     test('should return correct youtubeId from various URL formats', () {
      //   (Arrange)
      const shortUrl = "https://youtu.be/dQw4w9WgXcQ";
      const longUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
      const urlWithExtraParams = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=10s";

      //   (Assert)
      expect(shortUrl.youtubeId, 'dQw4w9WgXcQ');
      expect(longUrl.youtubeId, 'dQw4w9WgXcQ');
      expect(urlWithExtraParams.youtubeId, 'dQw4w9WgXcQ');
    });

     test('should return correct youtubeThumbnail URL', () {
      //   (Arrange)
      const videoId = "dQw4w9WgXcQ";
      const url = "https://youtu.be/$videoId";

      //   (Act)
      final thumbnail = url.youtubeThumbnail;

      //   (Assert)
      expect(thumbnail, "https://img.youtube.com/vi/$videoId/hqdefault.jpg");
    });

     test('should return empty string for invalid youtube URLs', () {
      //   (Arrange)
      const invalidUrl = "https://google.com";
      const randomText = "not_a_url";

      //   (Assert)
      expect(invalidUrl.youtubeId, '');
      expect(randomText.youtubeId, '');
    });
  });
}