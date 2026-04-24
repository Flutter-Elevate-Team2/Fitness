
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class ProfileStates {
  final BaseState<UserEntity>? profileState;

  const ProfileStates({
    this.profileState,

  });

  ProfileStates copyWith({
    BaseState<UserEntity>? profileState,
  }) {
    return ProfileStates(
      profileState: profileState ?? this.profileState,
    );
  }
}
