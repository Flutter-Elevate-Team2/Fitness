import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_screen_body.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_shimmer.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ProfileViewModel>();
    if (viewModel.state.profileState?.data == null) {
      viewModel.doIntent(GetUserProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileStates>(
      listenWhen: (previous, current) =>
          previous.logoutState != current.logoutState,
      listener: _handleLogoutState,
      child: BlocBuilder<ProfileViewModel, ProfileStates>(
        buildWhen: (previous, current) =>
            previous.profileState != current.profileState,
        builder: (context, state) {
          final profileState = state.profileState;

          if (profileState?.isLoading == true) {
            return ProfilePageShimmer();
          }

          if (profileState?.errorMessage != null) {
            return _ErrorStateWidget(
              errorMessage: profileState!.errorMessage!,
              onRetry: () {
                context.read<ProfileViewModel>().doIntent(
                  GetUserProfileEvent(),
                );
              },
            );
          }

          if (profileState?.data != null) {
            final user = profileState!.data!;
            return ProfileScreenBody(
              user: user,
              onProfileUpdated: () {
                context.read<ProfileViewModel>().doIntent(
                  GetUserProfileEvent(),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleLogoutState(BuildContext context, ProfileStates state) {
    if (state.logoutState?.isLoading == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (state.logoutState?.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.logoutState!.errorMessage!),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }
}

class _ErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorStateWidget({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(color: AppColors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n?.retryButton ?? 'Retry'),
          ),
        ],
      ),
    );
  }
}
