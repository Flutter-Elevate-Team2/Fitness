import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentIndex;
  final bool isFinished;

  const OnboardingState({
    this.currentIndex = 0,
    this.isFinished = false,
  });

  OnboardingState copyWith({
    int? currentIndex,
    bool? isFinished,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  List<Object?> get props => [currentIndex, isFinished];
}