import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_header_test.mocks.dart';

// Generate the mock class
@GenerateMocks([ProfileViewModel])

void main() {
  late MockProfileViewModel mockProfileViewModel;

  setUp(() {
    mockProfileViewModel = MockProfileViewModel();

    // Default stubbing for Bloc/Cubit requirements
    when(mockProfileViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  /// Helper to wrap the widget with necessary providers and localization
  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ProfileViewModel>.value(
          value: mockProfileViewModel,
          child: const HomeHeader(),
        ),
      ),
    );
  }

  testWidgets('Should display user first name when profile data is available', (WidgetTester tester) async {
    // Arrange
    final user = UserEntity(firstName: "John", photo: "", id: '', lastName: '', email: '', gender: '', age: 20, weight: 70, height: 170, activityLevel: '', goal: '');
    final successState = ProfileStates(
      profileState: BaseState(isLoading: false, data: user),
    );

    when(mockProfileViewModel.state).thenReturn(successState);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Trigger a frame to settle the UI

    // Assert
    expect(find.textContaining('John'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget); // Icon shows because photo is empty
  });

  testWidgets('Should display "User" as default when state data is null', (WidgetTester tester) async {
    // Arrange
    const emptyState = ProfileStates(
      profileState: BaseState(isLoading: false, data: null),
    );

    when(mockProfileViewModel.state).thenReturn(emptyState);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.textContaining('User'), findsOneWidget);
  });

  testWidgets('Should show CircleAvatar with person icon when imageUrl is empty', (WidgetTester tester) async {
    // Arrange
    when(mockProfileViewModel.state).thenReturn(const ProfileStates());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    final circleAvatar = find.byType(CircleAvatar);
    expect(circleAvatar, findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}