import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/profile_text_field_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/update_button_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/user_info_section.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/user_entity.dart';

class EditProfileForm extends StatefulWidget {
  final UserEntity user;

  const EditProfileForm({super.key, required this.user});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  double? _selectedWeight;
  String? _selectedGoal;
  String? _selectedActivity;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  UserEntity? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getIt<SessionController>().user ?? widget.user;

    if (currentUser != null) {
      _selectedWeight = currentUser?.weight.toDouble();
      _selectedGoal = currentUser?.goal;
      _selectedActivity = currentUser?.activityLevel;
    }

    firstNameController = TextEditingController(
      text: currentUser?.firstName ?? "",
    );
    lastNameController = TextEditingController(
      text: currentUser?.lastName ?? "",
    );
    emailController = TextEditingController(text: currentUser?.email ?? "");

    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String _getActivityText(BuildContext context, String? activity) {
    if (activity == null) return 'Not specified';
    switch (activity) {
      case 'level1':
        return context.l10n.rookie;
      case 'level2':
        return context.l10n.beginner;
      case 'level3':
        return context.l10n.intermediate;
      case 'level4':
        return context.l10n.advance;
      case 'level5':
        return context.l10n.trueBeast;
      default:
        return activity;
    }
  }

  String _getGoalText(BuildContext context, String? goal) {
    if (goal == null) return 'Not specified';
    switch (goal) {
      case 'gain_weight':
        return context.l10n.gainWeight;
      case 'lose_weight':
        return context.l10n.loseWeight;
      case 'get_fitter':
        return context.l10n.getFitter;
      case 'gain_more_flexible':
        return context.l10n.gainMoreFlexible;
      case 'learn_the_basic':
        return context.l10n.learnTheBasic;
      default:
        return goal;
    }
  }

  void _updateButtonState() {
    if (!mounted) return;

    bool isValid = _formKey.currentState?.validate() ?? false;

    bool hasChanges =
        currentUser != null &&
        (firstNameController.text != (currentUser?.firstName ?? "") ||
            lastNameController.text != (currentUser?.lastName ?? "") ||
            emailController.text != (currentUser?.email ?? "") ||
            _selectedWeight != currentUser?.weight.toDouble() ||
            _selectedGoal != currentUser?.goal ||
            _selectedActivity != currentUser?.activityLevel);

    setState(() {
      _isButtonEnabled = isValid && hasChanges;
    });
  }

  void _sendUpdateRequest() {
    context.read<EditProfileViewModel>().doIntent(
      EditProfileEvent(
        EditProfileRequest(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          weight: _selectedWeight,
          goal: _selectedGoal,
          activityLevel: _selectedActivity,
        ),
      ),
    );
  }

  void _editWeight() {
    context.pushNamed(
      Routes.editWeightName,
      extra: {
        'initialWeight': _selectedWeight?.toInt() ?? 70,
        'onWeightChanged': (int weight) {
          setState(() {
            _selectedWeight = weight.toDouble();
          });
        },
        'onStepComplete': () {
          context.pop();
          _sendUpdateRequest();
        },
        'onBackButtonPressed': () {
          context.pop();
        },
      },
    );
  }

  void _editGoal() {
    context.pushNamed(
      Routes.editGoalName,
      extra: {
        'initialGoal': _selectedGoal,
        'onGoalSelected': (goal) {
          setState(() {
            _selectedGoal = goal;
          });
          _sendUpdateRequest();
        },
        'onBackButtonPressed': () {
          context.pop();
        },
      },
    );
  }

  void _editActivity() {
    context.pushNamed(
      Routes.editActivityName,
      extra: {
        'initialActivity': _selectedActivity,
        'onActivitySelected': (activity) {
          setState(() {
            _selectedActivity = activity;
          });
          _sendUpdateRequest();
        },
        'onBackButtonPressed': () {
          context.pop();
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditProfileViewModel, EditProfileStates>(
          listenWhen: (previous, current) =>
              previous.editProfileState != current.editProfileState,
          listener: (context, state) {
            final editState = state.editProfileState;
            if (editState?.isLoading ?? false) return;

            if (editState?.data != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileUpdatedSuccess)),
              );
              getIt<SessionController>().updateUser(editState!.data!);
              setState(() {
                currentUser = editState.data!;
              });
              _updateButtonState();
            } else if (editState?.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(editState!.errorMessage!)));
            }
          },
        ),
      ],
      child: Form(
        key: _formKey,
        onChanged: _updateButtonState,
        child: Column(
          children: [
            UserInfoSection(currentUser: currentUser),
            ProfileTextFieldSection(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              emailController: emailController,
              onChanged: _updateButtonState,
              weightText: _selectedWeight != null
                  ? '${_selectedWeight!.toInt()} KG'
                  : '',
              goalText: _getGoalText(context, _selectedGoal),
              activityText: _getActivityText(context, _selectedActivity),
              onEditWeight: _editWeight,
              onEditGoal: _editGoal,
              onEditActivity: _editActivity,
            ),
            const SizedBox(height: 32),
            UpdateButtonSection(
              isButtonEnabled: _isButtonEnabled,
              formKey: _formKey,
              onPressed: _sendUpdateRequest,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
