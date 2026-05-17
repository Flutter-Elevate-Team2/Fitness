import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_avatar.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEditProfileViewModel extends Mock implements EditProfileViewModel {}

void main() {
  late MockEditProfileViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockEditProfileViewModel();

    when(() => mockViewModel.state).thenReturn(const EditProfileStates());
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  group('UserInfoSection Widget Tests', () {
    testWidgets(
      'displays user name and ProfileAvatar correctly when user data is provided',
      (WidgetTester tester) async {
        final testUser = UserEntity(
          id: '1',
          firstName: 'Ahmed',
          lastName: 'Ali',
          email: 'test@example.com',
          photo: 'https://example.com/photo.jpg',
          gender: 'male',
          age: 25,
          weight: 75,
          height: 175,
          activityLevel: 'High',
          goal: 'Fit',
        );

        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<EditProfileViewModel>.value(
                value: mockViewModel,
                child: SingleChildScrollView(
                  child: UserInfoSection(currentUser: testUser),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Ahmed Ali'), findsOneWidget);

        expect(find.byType(ProfileAvatar), findsOneWidget);
      },
    );

    testWidgets('displays empty fields when user is null', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<EditProfileViewModel>.value(
              value: mockViewModel,
              child: const SingleChildScrollView(
                child: UserInfoSection(currentUser: null),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(' '), findsOneWidget);
      expect(find.byType(ProfileAvatar), findsOneWidget);
    });
  });
}
