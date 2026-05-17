import 'dart:async';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserCubit extends Cubit<UserEntity?> {
  final SessionController _sessionController;
  StreamSubscription<UserEntity?>? _userSubscription;

  UserCubit(this._sessionController) : super(_sessionController.user) {
    _userSubscription = _sessionController.onUserChanged.listen((user) {
      if (!isClosed) emit(user);
    });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
