import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_avatar.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEditProfileViewModel
    extends MockBloc<EditProfileEvent, EditProfileStates>
    implements EditProfileViewModel {}

class FakeEditProfileStates extends Fake implements EditProfileStates {}

class FakeEditProfileEvents extends Fake implements EditProfileEvent {}

void main() {
  late MockEditProfileViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(FakeEditProfileStates());
    registerFallbackValue(FakeEditProfileEvents());
  });

  setUp(() {
    mockViewModel = MockEditProfileViewModel();

    when(() => mockViewModel.state).thenReturn(
      const EditProfileStates(editProfileState: null, uploadPhotoState: null),
    );
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest({String? photoUrl}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: BlocProvider<EditProfileViewModel>.value(
          value: mockViewModel,
          child: ProfileAvatar(photoUrl: photoUrl),
        ),
      ),
    );
  }

  group('ProfileAvatar Widget Tests', () {
    testWidgets('renders ProfilePlaceholder when no image or URL is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(photoUrl: null));
      await tester.pumpAndSettle();

      expect(find.byType(ProfilePlaceholder), findsOneWidget);
      expect(find.byType(ProfileImagePicker), findsOneWidget);
    });

    testWidgets('renders CachedNetworkImage when photoUrl is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(photoUrl: 'https://example.com/photo.jpg'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('displays LoadingOverlay when isUploading is true', (
      WidgetTester tester,
    ) async {
      when(() => mockViewModel.state).thenReturn(
        const EditProfileStates(
          uploadPhotoState: BaseState<String>(isLoading: true),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(LoadingOverlay), findsOneWidget);
    });

    testWidgets(
      'handles uploadPhotoState error message, triggers setState, and displays correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final newState = const EditProfileStates(
          uploadPhotoState: BaseState<String>(
            isLoading: false,
            errorMessage: 'Failed to upload photo',
          ),
        );

        when(() => mockViewModel.state).thenReturn(newState);

        whenListen(
          mockViewModel,
          Stream.fromIterable([newState]),
          initialState: const EditProfileStates(),
        );

        await tester.pump();

        expect(find.byType(ProfileImageDisplay), findsOneWidget);
      },
    );

    testWidgets('tests ImageSourceBottomSheet actions correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: const Scaffold(body: ImageSourceBottomSheet()),
        ),
      );

      await tester.pumpAndSettle();

      final cameraFinder = find.byType(ListTile).first;
      await tester.tap(cameraFinder);
      await tester.pumpAndSettle();
    });
  });
}
