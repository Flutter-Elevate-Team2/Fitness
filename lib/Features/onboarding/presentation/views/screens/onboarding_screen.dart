import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:fitness_app/Features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/widgets/onboarding_screen_body.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingViewModel>(),
      child: BlocConsumer<OnboardingViewModel, OnboardingState>(
        listener: (context, state) {
          if (state.isFinished) {
            context.go(Routes.loginPath);
          }
        },
        builder: (context, state) {
          return OnboardingScreenBody(state: state);
        },
      ),
    );
  }
}
