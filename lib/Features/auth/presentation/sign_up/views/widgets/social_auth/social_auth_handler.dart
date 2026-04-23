import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_event.dart';
 import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:go_router/go_router.dart';

class SocialAuthHandler {
  static Future<void> handle({
    required BuildContext context,
    required UserCredential? userCredential,
    required LoginViewModel viewModel,
  }) async {
    if (userCredential?.user == null) return;

    final user = userCredential!.user!;
    final isNewUser =
        userCredential.additionalUserInfo?.isNewUser ?? false;

    if (!context.mounted) return;

    if (isNewUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete registration"),
        ),
      );

      context.goNamed(
        Routes.signupName,
        extra: {"user": user , "step":1},
      );
    } else {
      await viewModel.doIntent(
        SocialLoginEvent(
          email: user.email ?? "",
         ),
      );

      context.goNamed(Routes.homeName);
    }
  }
}