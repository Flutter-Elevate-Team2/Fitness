import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_screen_body.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_setting_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_user_card.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/l10n/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

 class MockLocaleCubit extends MockCubit<Locale> implements LocaleCubit {}
class MockProfileViewModel extends Mock implements ProfileViewModel {}

void main() {
  late MockLocaleCubit mockLocaleCubit;
  late MockProfileViewModel mockProfileViewModel;

   final Uint8List kTransparentImage = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  final testUser = UserEntity(
    id: '1',
    firstName: 'Ahmed',
    lastName: 'Ali',
    email: 'ahmed@test.com',
    photo: '',
    gender: 'male',
    age: 25,
    weight: 80,
    height: 180,
    activityLevel: 'high',
    goal: 'gain muscle',
  );

  setUp(() {
    mockLocaleCubit = MockLocaleCubit();
    mockProfileViewModel = MockProfileViewModel();

     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final String assetName = utf8.decode(message!.buffer.asUint8List());
      if (assetName.contains('AssetManifest')) {
        return const StandardMessageCodec().encodeMessage({});
      }
      return ByteData.view(kTransparentImage.buffer);
    });

     when(() => mockLocaleCubit.state).thenReturn(const Locale('en'));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
          BlocProvider<ProfileViewModel>.value(value: mockProfileViewModel),
        ],
        child: ProfileScreenBody(user: testUser, onProfileUpdated: () {  },),
      ),
    );
  }

  group('ProfileScreenBody Integration Tests', () {
    testWidgets('renders all major components correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

       expect(find.byType(ProfileUserCard), findsOneWidget);
      expect(find.text('Ahmed Ali'), findsOneWidget);

       expect(find.byType(ProfileSettingSection), findsOneWidget);

       expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('is scrollable when content exceeds screen height', (tester) async {
       tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

       final scrollFinder = find.byType(SingleChildScrollView);
      await tester.drag(scrollFinder, const Offset(0, -300));
      await tester.pump();

       expect(tester.getTopLeft(find.byType(ProfileSettingSection)).dy, lessThan(600));

       addTearDown(tester.view.resetPhysicalSize);
    });
  });
}