import 'package:equatable/equatable.dart';
import 'package:fitness_app/Features/home/domain/entities/home_section.dart';
import 'package:fitness_app/core/base_response/base_response.dart';

class HomeState extends Equatable {
  final List<BaseResponse<HomeSection>> homeData;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.homeData = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<BaseResponse<HomeSection>>? homeData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      homeData: homeData ?? this.homeData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [homeData, isLoading, errorMessage];
}
