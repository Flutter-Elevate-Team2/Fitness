import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/social_icon_button.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginRow extends StatelessWidget {
  final void Function(String email, String firstName, String lastName , String password)
  onGoogleSuccess;

  const SocialLoginRow({super.key, required this.onGoogleSuccess});

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                // TODO: Facebook login
              },
            ),
            const SizedBox(width: 24),
            SocialIconButton(
              assetPath: Assets.icons.google.path,
              onTap: () async {
                final googleUser = await GoogleSignIn().signIn();
                if (googleUser == null) return;

                final googleAuth = await googleUser.authentication;

                final credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );

                final userCredential = await FirebaseAuth.instance
                    .signInWithCredential(credential);

                final user = userCredential.user;

                final email = user?.email ?? "";
                final displayName = user?.displayName ?? "";

                final parts = displayName.split(" ");
                final firstName = parts.isNotEmpty ? parts.first : "";
                final lastName = parts.length > 1 ? parts.last : "";
                final password = ApiConstants.defaultPassword;

                // 🔥 send data upward
                onGoogleSuccess(email, firstName, lastName , password);
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
