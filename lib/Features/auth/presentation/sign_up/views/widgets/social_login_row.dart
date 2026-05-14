import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/social_login_auth/auth_services.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_auth/social_auth_handler.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_icon_button.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginRow extends StatelessWidget {
  final void Function(
    String email,
    String firstName,
    String lastName,
    String password,
  )
  onGoogleSuccess;

  const SocialLoginRow({super.key, required this.onGoogleSuccess});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ── "Or" Divider ──
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.light600, thickness: 0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.or,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.light600,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.light600, thickness: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// ── Social Icons Row ──
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(
              assetPath: Assets.icons.facebook.path,
              onTap: () async {
                final userCredential = await AuthServices.signInWithFacebook();

                if (!context.mounted) return;

                await SocialAuthHandler.handle(
                  context: context,
                  userCredential: userCredential,
                  viewModel: vm,
                );
              },
            ),
            const SizedBox(width: 24),
            SocialIconButton(
              assetPath: Assets.icons.google.path,
              onTap: () async {
                try {
                  // final googleUser = await GoogleSignIn().signIn();
                  // if (googleUser == null) return;
                  //
                  // final googleAuth = await googleUser.authentication;
                  //
                  // final credential = GoogleAuthProvider.credential(
                  //   accessToken: googleAuth.accessToken,
                  //   idToken: googleAuth.idToken,
                  // );
                  //
                  // final userCredential = await FirebaseAuth.instance
                  //     .signInWithCredential(credential);
                  final userCredential = await AuthServices.signInWithGoogle();

                  if (context.mounted) {
                    await SocialAuthHandler.handle(
                      context: context,
                      userCredential: userCredential,
                      viewModel: vm,
                     );
                  }
                } catch (e) {
                  debugPrint("Google Sign-In Error: $e");
                }
              },
            ),
            const SizedBox(width: 24),
            SocialIconButton(
              assetPath: Assets.icons.apple.path,
              onTap: () {
                // TODO: Apple login
              },
            ),
          ],
        ),
      ],
    );
  }
}
