import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:fitness_app/Features/food/domain/entities/meal_details_entity.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_state.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/meal_details_screen_body.dart';
import 'package:fitness_app/Features/food/presentation/views/widgets/ingredients_list.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([MealsViewModel])
import 'meal_details_screen_body_test.mocks.dart';

void main() {
  late MockMealsViewModel mockViewModel;

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
        child: const MealDetailsScreenBody(),
      ),
    );
  }

  group('MealDetailsScreenBody Widget Tests', () {
    testWidgets('should show CircularProgressIndicator when state is loading', (tester) async {
      when(mockViewModel.state).thenReturn(
        const MealsState(mealDetailsState: BaseState(isLoading: true)),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should render meal details correctly on success state', (tester) async {
       await HttpOverrides.runZoned(() async {
        final mockMeal = MealDetailEntity(
          id: '1',
          name: 'Test Meal',
          instructions: 'Steps to cook...',
          youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          ingredients: [],
          category: 'Beef',
          area: '',
          image: 'https://test.com/image.png',
        );

        final successState = MealsState(
          mealDetailsState: BaseState(data: mockMeal),
          mealsByCategoryState: const BaseState(data: []),
        );

        when(mockViewModel.state).thenReturn(successState);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text('Test Meal'), findsWidgets);
        expect(find.byType(IngredientsList), findsOneWidget);
      }, createHttpClient: (_) => _createMockHttpClient());
    });
  });
}

 HttpClient _createMockHttpClient() {
  final client = _FakeHttpClient();
  return client;
}

class _FakeHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();
}

class _FakeHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers => _FakeHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();
}

class _FakeHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _emptyImage.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_emptyImage]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class _FakeHttpHeaders extends Mock implements HttpHeaders {}

final Uint8List _emptyImage = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);