import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/core/base_response/base_response.dart';
import 'package:fitness_app/core/base_state/base_state.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/core/di/di.dart';

@injectable
class EditProfileViewModel extends Cubit<EditProfileStates> {
  EditProfileViewModel({required this.editProfileUseCase})
    : super(const EditProfileStates());
  final EditProfileUseCase editProfileUseCase;
  void doIntent(EditProfileEvents event) {
    switch (event) {
      case EditProfileEvent():
        _editProfile(event.request);
        break;
    }
  }

  void _editProfile(EditProfileRequest request) async {
    emit(state.copyWith(editProfileState: BaseState(isLoading: true)));
    final result = await editProfileUseCase(request);
    switch (result) {
      case SuccessResponse<UserEntity>():
        getIt<SessionController>().initSession();

        emit(
          state.copyWith(
            editProfileState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;
      case ErrorResponse<UserEntity>():
        emit(
          state.copyWith(
            editProfileState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
