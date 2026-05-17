import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/helpers/app_regex.dart';
import 'package:flutter/widgets.dart';

class FormValidators {
  FormValidators._();

  static String? validateEmail(BuildContext context, String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return context.l10n.emailRequired;
    }
    if (!AppRegex.isEmailValid(trimmedValue)) {
      return context.l10n.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return context.l10n.passwordRequired;
    }
    if (!AppRegex.hasMinLength(trimmedValue)) {
      return context.l10n.passwordTooShort;
    }
    if (!AppRegex.isPasswordValid(trimmedValue)) {
      return context.l10n.passwordWeak;
    }
    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return context.l10n.passwordRequired;
    }
    if (value != password) {
      return context.l10n.passwordMismatch;
    }
    return null;
  }

  static String? validatePhone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.phoneRequired;
    }
    if (!AppRegex.isPhoneNumberValid(value)) {
      return context.l10n.phoneInvalid;
    }
    return null;
  }

  static String? validateRequired(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? validateLoginPassword(BuildContext context, String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return context.l10n.passwordRequired;
    }

    if (trimmedValue.length < 8) {
      return context.l10n.passwordTooShort;
    }

    return null;
  }

  static String? validateNationalId(BuildContext context, String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return context.l10n.nationalIdRequired; //
    }

    if (trimmedValue.length != 14) {
      return context.l10n.nationalIdInvalidLength;
    }

    if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
      return context.l10n.nationalIdInvalidChars;
    }

    return null;
  }

  static String? validateVehicleNumber(BuildContext context, String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return context.l10n.vehicleNumberRequired;
    }

    if (trimmedValue.length < 3 || trimmedValue.length > 10) {
      return context.l10n.vehicleNumberLength;
    }

    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(trimmedValue)) {
      return context.l10n.vehicleNumberInvalidChars;
    }

    return null;
  }
}
