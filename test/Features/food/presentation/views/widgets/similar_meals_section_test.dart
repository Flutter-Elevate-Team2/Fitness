import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/domain/entities/meals_by_category_entity.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/similar_meals_section.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meal_details_screen_body_test.mocks.dart';


 final Uint8List transparentPixel = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

@GenerateMocks([
  MealsViewModel,
  HttpClient,
  HttpClientRequest,
  HttpClientResponse,
  HttpHeaders,
])
void main() {
  late MockMealsViewModel mockViewModel;

  final mockMealsList = [
    MealsByCategoryEntity(id: '1', name: 'Healthy Salad', image: 'https://test.com/1.png'),
    MealsByCategoryEntity(id: '2', name: 'Grilled Chicken', image: 'https://test.com/2.png'),
    MealsByCategoryEntity(id: '3', name: 'Oatmeal', image: 'https://test.com/3.png'),
  ];

  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  setUp(() {
    mockViewModel = MockMealsViewModel();
    when(mockViewModel.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<MealsViewModel>.value(
        value: mockViewModel,
        child: const Scaffold(body: SimilarMealsSection()),
      ),
    );
  }

  group('SimilarMealsSection Widget Tests (Mockito Full)', () {
    testWidgets('renders nothing when meals list is empty', (tester) async {
      when(mockViewModel.state).thenReturn(
        const MealsState(mealsByCategoryState: BaseState(data: [])),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(Column), findsNothing);
    });
    testWidgets('renders similar meals list excluding the current meal', (tester) async {
      when(mockViewModel.state).thenReturn(
        MealsState(
          mealsByCategoryState: BaseState(data: mockMealsList),
          mealDetailsState: BaseState(
            data: MealDetailEntity(
              id: '1',
              name: 'Healthy Salad',
              category: 'Diet',
              area: '', instructions: '', image: '', ingredients: [],
            ),
          ),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Grilled Chicken'), findsOneWidget);
      expect(find.text('Oatmeal'), findsOneWidget);
      expect(find.text('Healthy Salad'), findsNothing);
    });

    testWidgets('triggers FetchMealDetailsEvent when a meal card is tapped', (tester) async {
      when(mockViewModel.state).thenReturn(
        MealsState(mealsByCategoryState: BaseState(data: mockMealsList)),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Healthy Salad'));
      await tester.pump();

      verify(mockViewModel.doIntent(any)).called(1);
    });
  });
}

 class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeMockHttpClient();
}

class _FakeMockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeMockHttpClientRequest();
}

class _FakeMockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeMockHttpClientResponse();
  @override
  HttpHeaders get headers => _FakeMockHttpHeaders();
}

class _FakeMockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => transparentPixel.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
     return Stream<List<int>>.fromIterable([transparentPixel]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _FakeMockHttpHeaders extends Mock implements HttpHeaders {}