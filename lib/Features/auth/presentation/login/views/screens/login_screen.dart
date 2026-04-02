import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/widgets/login_screen_body.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginViewModel>(),
      child: BlocListener<LoginViewModel, LoginState>(
        listenWhen: (previous, current) => previous.loginState != current.loginState,
        listener: (context, state) {
          if (state.loginState?.errorMessage != null) {
            // إظهار SnackBar بالخطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.loginState!.errorMessage!)),
            );
          }
          if (state.loginState?.data != null) {
            // التوجه للصفحة الرئيسية بعد النجاح
            // context.pushNamed(Routes.home);
          }
        },
        child: const LoginScreenBody(),
      ),
    );
  }
}