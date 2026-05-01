import 'dart:io';

import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


@GenerateMocks([ProfileRepoContract])
import 'upload_photo_use_case_test.mocks.dart';

void main() {
  late UploadPhotoUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = UploadPhotoUseCase(mockRepo);

    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: ''));
  });

  group('UploadPhotoUseCase', () {
    final file = File('test/fixtures/test_image.png');

    test('returns SuccessResponse with photo URL when repo succeeds', () async {
      when(mockRepo.uploadPhoto(file)).thenAnswer(
            (_) async => SuccessResponse(data: 'https://example.com/photo.jpg'),
      );

      final result = await useCase(file);

      expect(result, isA<SuccessResponse<String>>());
      expect((result as SuccessResponse).data, 'https://example.com/photo.jpg');
      verify(mockRepo.uploadPhoto(file)).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      when(
        mockRepo.uploadPhoto(file),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Upload failed'));

      final result = await useCase(file);

      expect(result, isA<ErrorResponse<String>>());
      expect((result as ErrorResponse).errorMessage, 'Upload failed');
      verify(mockRepo.uploadPhoto(file)).called(1);
    });

    test('delegates call directly to repo', () async {
      when(
        mockRepo.uploadPhoto(file),
      ).thenAnswer((_) async => SuccessResponse(data: 'url'));

      await useCase(file);

      verify(mockRepo.uploadPhoto(file)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
