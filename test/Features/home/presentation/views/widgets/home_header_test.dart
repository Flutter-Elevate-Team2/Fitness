import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  final testUser = UserEntity(
    firstName: "John",
    photo: "https://example.com/photo.jpg",
    id: '1',
    lastName: 'Doe',
    email: 'test@test.com',
    gender: 'male',
    age: 25,
    weight: 80,
    height: 180,
    activityLevel: 'high',
    goal: 'muscle',
  );

  Widget createWidgetUnderTest(BaseResponse<HomeSection>? response) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: HomeHeader(response: response)),
    );
  }

  group('HomeHeader Coverage Tests', () {
    testWidgets('1. Should show Shimmer when response is null', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(null));
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('2. Should display user first name on SuccessResponse', (
      tester,
    ) async {
      final successResponse = SuccessResponse<HomeSection>(
        data: UserProfileSection(testUser),
      );

      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest(successResponse));
        await tester.pump();

        expect(find.textContaining('John'), findsOneWidget);
        expect(find.textContaining('Hi'), findsOneWidget);
      });
    });

    testWidgets('3. Should show fallback text when ErrorResponse occurs', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(ErrorResponse(errorMessage: "Error")),
      );
      await tester.pump();
      expect(find.textContaining('Hi Profile'), findsOneWidget);
    });

    testWidgets('4. Should show Person Icon when photo is empty', (
      tester,
    ) async {
      final userNoPhoto = testUser.copyWith(photo: "");

      await tester.pumpWidget(
        createWidgetUnderTest(
          SuccessResponse(data: UserProfileSection(userNoPhoto)),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('5. Should set NetworkImage when photo is NOT empty', (
      tester,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            SuccessResponse(data: UserProfileSection(testUser)),
          ),
        );

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<NetworkImage>());
        expect((avatar.backgroundImage as NetworkImage).url, testUser.photo);
      });
    });
  });
}
