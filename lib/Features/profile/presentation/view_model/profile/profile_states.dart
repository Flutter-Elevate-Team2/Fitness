
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/base_state/base_state.dart';

class ProfileStates {
  final BaseState<UserEntity>? profileState;
  final BaseState<void>? logoutState;

  const ProfileStates({
    this.profileState,
    this.logoutState,

  });

  ProfileStates copyWith({
    BaseState<UserEntity>? profileState,
    BaseState<void>? logoutState,

  }) {
    return ProfileStates(
      profileState: profileState ?? this.profileState,
      logoutState: logoutState ?? this.logoutState,

    );
  }
}
