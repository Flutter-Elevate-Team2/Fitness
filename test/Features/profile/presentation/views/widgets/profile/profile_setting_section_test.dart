import 'dart:convert';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/logout_dialog.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_setting_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_settings_tile.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/l10n/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

 class MockProfileViewModel extends MockBloc<ProfileEvents, ProfileStates>
    implements ProfileViewModel {}

class MockLocaleCubit extends MockCubit<Locale> implements LocaleCubit {}
class MockGoRouter extends Mock implements GoRouter {}

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

  setUp(() {
    mockLocaleCubit = MockLocaleCubit();
    mockProfileViewModel = MockProfileViewModel();

    when(() => mockLocaleCubit.state).thenReturn(const Locale('en'));
    when(() => mockProfileViewModel.state).thenReturn(const ProfileStates());

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final String assetName = utf8.decode(message!.buffer.asUint8List());

       if (assetName.contains('AssetManifest')) {
        final Map<String, List<Object>> manifest = {};
        return const StandardMessageCodec().encodeMessage(manifest);
      }

       return ByteData.view(kTransparentImage.buffer);
    });
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
        child: const Scaffold(body: ProfileSettingSection()),
      ),
    );
  }

  group('ProfileSettingSection Tests', () {
    testWidgets('renders exactly 7 ProfileSettingsTile items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileSettingsTile), findsNWidgets(7));
    });

    testWidgets('toggling language switch calls toggleLanguage in Cubit', (tester) async {
       when(() => mockLocaleCubit.state).thenReturn(const Locale('en'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

       final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

       await tester.tap(switchFinder);
      await tester.pump();

       verify(() => mockLocaleCubit.toggleLanguage(any())).called(1);
    });

    testWidgets('renders correct number of ProfileSettingsTile', (tester) async {
      when(() => mockLocaleCubit.state).thenReturn(const Locale('en'));

      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(ProfileSettingsTile), findsNWidgets(7));
    });
    testWidgets('shows logout dialog when logout tile is tapped', (tester) async {
       await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

    final logoutTile = find.text('Logout');

      expect(logoutTile, findsOneWidget);

       await tester.tap(logoutTile);

       await tester.pumpAndSettle();

       expect(find.byType(LogoutDialog), findsOneWidget);
    });
    testWidgets('verify specific tiles properties (Security, Policy, Help)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

     final tiles = tester.widgetList<ProfileSettingsTile>(find.byType(ProfileSettingsTile));

      bool hasSecurity = tiles.any((t) => t.webView == 'security');
      bool hasPrivacy = tiles.any((t) => t.webView == 'privacy-policy');
      bool hasHelp = tiles.any((t) => t.webView == 'help');

      expect(hasSecurity, isTrue);
      expect(hasPrivacy, isTrue);
      expect(hasHelp, isTrue);
    });
  });
}