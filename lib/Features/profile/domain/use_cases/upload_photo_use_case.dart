import 'dart:io';
import 'package:fitness_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadPhotoUseCase {
  final ProfileRepoContract _repo;

  UploadPhotoUseCase(this._repo);

  Future<BaseResponse<String>> call(File file) async {
    return await _repo.uploadPhoto(file);
  }
}