import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
class EditProfileStates {
 final BaseState<UserEntity>? editProfileState;
  final BaseState<String>? uploadPhotoState;

const  EditProfileStates({this.editProfileState, this.uploadPhotoState});

  EditProfileStates copyWith({
    BaseState<UserEntity>? editProfileState,
    BaseState<String>? uploadPhotoState,
  }) {
    return EditProfileStates(
     editProfileState: editProfileState ?? this.editProfileState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
    );
  }
}