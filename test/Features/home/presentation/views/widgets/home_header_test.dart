import 'package:fitness_app/Features/home/presentation/view_model/home_state.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart'; // تأكد من المسار الصحيح للـ Entity
import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // يفضل استخدام mocktail مع Bloc لسهولة التعامل

// إنشاء Mock باستخدام mocktail أو استبدله بـ Mockito إذا كنت تفضلها
class MockHomeViewModel extends Mock implements HomeViewModel {}

void main() {
  late MockHomeViewModel mockHomeViewModel;

  setUp(() {
    mockHomeViewModel = MockHomeViewModel();

    // إعدادات افتراضية للـ Stream والـ State لتجنب أخطاء البناء
    when(() => mockHomeViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: BlocProvider<HomeViewModel>.value(
          value: mockHomeViewModel,
          child: const HomeHeader(),
        ),
      ),
    );
  }

  testWidgets('Should display user first name when user data is available', (tester) async {
    // Arrange
    final user = UserEntity(
        firstName: "John",
        photo: "",
        id: '1',
        lastName: 'Doe',
        email: 'test@test.com',
        gender: 'male',
        age: 25,
        weight: 80,
        height: 180,
        activityLevel: 'high',
        goal: 'muscle'
    );

    // إرسال State تحتوي على المستخدم
    when(() => mockHomeViewModel.state).thenReturn(HomeState(user: user));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.textContaining('John'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('Should display "User" as default when user is null', (tester) async {
    // Arrange
    when(() => mockHomeViewModel.state).thenReturn(const HomeState(user: null));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.textContaining('User'), findsOneWidget);
  });

  testWidgets('Should show CircleAvatar with person icon when imageUrl is empty', (tester) async {
    // Arrange
    when(() => mockHomeViewModel.state).thenReturn(const HomeState(user: null));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}