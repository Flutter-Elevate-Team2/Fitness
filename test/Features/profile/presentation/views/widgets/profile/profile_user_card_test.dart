import 'dart:convert';

import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_user_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // مهم للـ ByteData
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
   final Uint8List kTransparentImage = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

   UserEntity createTestUser({String photo = '', String firstName = 'Ahmed'}) {
    return UserEntity(
      id: '1',
      firstName: firstName,
      lastName: 'Ali',
      email: 'test@example.com',
      photo: photo,
      gender: 'male',
      age: 25,
      weight: 80,
      height: 180,
      activityLevel: 'high',
      goal: 'muscle gain',
    );
  }

  Widget createWidgetUnderTest(UserEntity user) {
    return MaterialApp(home: Scaffold(body: ProfileUserCard(user: user)));
  }

  group('ProfileUserCard Tests', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final String assetName = utf8.decode(message!.buffer.asUint8List());

        if (assetName.contains('AssetManifest')) {
          return null;
        }

        return ByteData.view(kTransparentImage.buffer);
      });
    });

    testWidgets('renders user full name correctly', (tester) async {
      final user = createTestUser(firstName: 'Ahmed');
      await tester.pumpWidget(createWidgetUnderTest(user));
      expect(find.text('Ahmed Ali'), findsOneWidget);
    });

    testWidgets('displays person icon and no background image when photo is empty', (tester) async {
      final user = createTestUser(photo: '');
      await tester.pumpWidget(createWidgetUnderTest(user));

      expect(find.byIcon(Icons.person), findsOneWidget);
      final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isNull);
    });

    testWidgets('uses NetworkImage for web URLs', (tester) async {
      final user = createTestUser(photo: 'https://image.com/pro.png');
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(user));
        final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<NetworkImage>());
        expect((avatar.backgroundImage as NetworkImage).url, user.photo);
      });
    });
 });


}