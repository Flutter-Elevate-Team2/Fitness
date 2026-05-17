import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_screen_body.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  final String? email;
  const LoginScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginViewModel>(),
      child: BlocListener<LoginViewModel, LoginState>(
        listenWhen: (previous, current) =>
            previous.loginState != current.loginState,
        listener: (context, state) {
          final loginState = state.loginState;
           if (loginState?.isLoading == true) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: SharedContainer(
                  borderRadius: 50,
                  blur: 20.6,
                  opacity: .0001,
                  child:   CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (loginState?.data != null) {
             context.goNamed(Routes.homeName);
          } else if (loginState?.errorMessage != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loginState!.errorMessage!),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: const LoginScreenBody(),
      ),
    );
  }
}
