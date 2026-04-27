import 'dart:io';

import 'package:fitness_app/Features/workouts/presentation/views/widgets/thumbanil_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HttpErrorOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
   }
}

void main() {

  group('ThumbnailWidget Tests', () {

    testWidgets('should show Asset Image when URL does not start with http', (tester) async {
       const String localPath = 'assets/images/test_image.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: ThumbnailWidget(thumbnailUrl: localPath),
        ),
      );

       expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should show CachedNetworkImage when URL starts with http', (tester) async {
      const String networkUrl = 'https://example.com/image.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: ThumbnailWidget(thumbnailUrl: networkUrl),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should show circular progress while loading', (tester) async {
       await tester.pumpWidget(
        const MaterialApp(
          home: ThumbnailWidget(thumbnailUrl: 'https://any-url.com/img.png'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}