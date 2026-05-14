import 'package:fitness_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/change_password/change_password_form.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? userEmail;

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_updateButtonState);
    _newPasswordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);

  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _oldPasswordController.text.isNotEmpty &&
              _newPasswordController.text.isNotEmpty &&
              _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _oldPasswordController.removeListener(_updateButtonState);
    _oldPasswordController.dispose();
    _newPasswordController.removeListener(_updateButtonState);
    _newPasswordController.dispose();
    _confirmPasswordController.removeListener(_updateButtonState);
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ChangePasswordViewModel>();
    return SharedAuthLayout(
      showBackButton: true,
      isGreeting: true,
      title: context.l10n.passwordMismatch,
      subtitle: context.l10n.createNewPassword,
      buttonTitle: context.l10n.done,
      onButtonPressed: _isButtonEnabled
          ? () {
        if (_formKey.currentState!.validate() ) {

          viewModel.doIntent(
            ChangePasswordEvent(
                request: ChangePasswordRequest(
                  password: _oldPasswordController.text,
                  newPassword: _newPasswordController.text,
                )
            ),
          );
        } else {
          setState(() {
            _autoValidateMode = AutovalidateMode.always;
          });
        }
      }
          : null,
      formBody: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: ChangePasswordForm(
          oldPasswordController: _oldPasswordController,
          newPasswordController: _newPasswordController,
          confirmPasswordController: _confirmPasswordController,
         ),
      ),
     );
  }
}

