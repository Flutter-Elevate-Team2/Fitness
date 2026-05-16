import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_chat_screen.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_welcome_screen.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root entry point for the Smart Coach feature.
///
/// Creates the [SmartCoachViewModel] via DI, loads history,
/// and decides whether to show the welcome or chat screen
/// based on the current state.
class SmartCoachScreen extends StatelessWidget {
  final VoidCallback? onBack;
  
  const SmartCoachScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final vm = getIt<SmartCoachViewModel>();
        // Fix #9: inject localized strings before any action.
        vm.setLocalizedStrings(
          defaultSessionTitle: context.l10n.smartCoachDefaultSessionTitle,
          safetyBlockMessage: context.l10n.smartCoachSafetyBlockMessage,
        );
        vm.loadHistory();
        return vm;
      },
      child: BlocBuilder<SmartCoachViewModel, SmartCoachState>(
        builder: (context, state) {
          // Fix #4: Proper routing logic.
         return switch (state) {
            SmartCoachInitial() => const _LoadingIndicator(),
            SmartCoachLoading() => const _LoadingIndicator(),
            SmartCoachSessionLoaded() => SmartCoachWelcomeScreen(onBack: onBack),
            SmartCoachStreamDone() => const SmartCoachChatScreen(),
            SmartCoachStreaming() => const SmartCoachChatScreen(),
            SmartCoachError() => const SmartCoachChatScreen(),
            SmartCoachSafetyBlocked() => const SmartCoachChatScreen(),
          };
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFFFF4100)),
      ),
    );
  }
}
