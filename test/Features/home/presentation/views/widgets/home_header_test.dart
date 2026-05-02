import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/user_cubit/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

class MockUserCubit extends Mock implements UserCubit {
  UserEntity? _state;

  MockUserCubit([this._state]);

  @override
  UserEntity? get state => _state;

  @override
  Stream<UserEntity?> get stream => const Stream.empty();

  @override
  bool get isClosed => false;

  @override
  Future<void> close() async {}
}

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

  Widget createWidgetUnderTest(MockUserCubit cubit) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<UserCubit>.value(
        value: cubit,
        child: const Scaffold(body: HomeHeader()),
      ),
    );
  }

  group('HomeHeader Coverage Tests', () {
    testWidgets('1. Should show fallback text when user is null', (tester) async {
      final cubit = MockUserCubit(null);
      await tester.pumpWidget(createWidgetUnderTest(cubit));
      await tester.pump();

      // When user is null, firstName defaults to "" so it shows "Hi ,"
      expect(find.textContaining('Hi'), findsOneWidget);
    });

    testWidgets('2. Should display user first name when user is available', (
      tester,
    ) async {
      final cubit = MockUserCubit(testUser);

      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest(cubit));
        await tester.pump();

        expect(find.textContaining('John'), findsOneWidget);
        expect(find.textContaining('Hi'), findsOneWidget);
      });
    });

    testWidgets('3. Should show Person Icon when photo is empty', (
      tester,
    ) async {
      final userNoPhoto = testUser.copyWith(photo: "");
      final cubit = MockUserCubit(userNoPhoto);

      await tester.pumpWidget(createWidgetUnderTest(cubit));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('4. Should set NetworkImage when photo is NOT empty', (
      tester,
    ) async {
      final cubit = MockUserCubit(testUser);

      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest(cubit));

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.backgroundImage, isA<NetworkImage>());
        expect((avatar.backgroundImage as NetworkImage).url, testUser.photo);
      });
    });
  });
}
