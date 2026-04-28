import 'package:fitness_app/Features/smart_coach/domain/entities/smart_coach_entity.dart';

class SmartCoachState {
  final bool isLoading;
  final SmartCoachEntity? data;
  final String? errorMessage;

  SmartCoachState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  SmartCoachState copyWith({
    bool? isLoading,
    SmartCoachEntity? data,
    String? errorMessage,
  }) {
    return SmartCoachState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
