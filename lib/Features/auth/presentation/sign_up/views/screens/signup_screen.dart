import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_events.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_states.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/view_model/sign_up_view_model.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/activity_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/goal_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_age_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_first_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_gender_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_height_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_weight_step.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  final int step;
  final  user;
  const SignupScreen({super.key , this.step = 0 , this.user});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final PageController _pageController;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  /// ── Step tracking ──
  int _currentStep = 0;

  /// ── Step 2: Gender ──
  String? _selectedGender;

  /// ── Steps 3–5: Age / Weight / Height ──
  int _selectedAge = 25;
  int _selectedWeight = 70;
  int _selectedHeight = 170;

  /// ── Step 6: Goal ──
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.step;
    _pageController = PageController(initialPage: widget.step);
    final displayName = widget.user?.displayName ?? "";

    final parts = displayName.split(" ");
    _firstNameController = TextEditingController(text: parts.isNotEmpty ? parts.first : "");
    _lastNameController = TextEditingController( text: parts.length > 1 ? parts.last : "");
    _emailController = TextEditingController(text: widget.user?.email);
    _passwordController = TextEditingController( text:widget.user != null ? ApiConstants.defaultPassword:"");
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    final nextPage = _currentStep + 1;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpViewModel>(
      create: (_) => getIt<SignUpViewModel>(),
      child: BlocListener<SignUpViewModel, SignUpStates>(
        listener: (context, state) {
          final signUpState = state.signUpState;
          if (signUpState == null) return;

          if (signUpState.isLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Dismiss loading dialog if showing
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }

            if (signUpState.data != null) {
              // ── Success ──
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.goNamed(Routes.loginName);
            } else if (signUpState.errorMessage != null) {
              // ── Error ──
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(signUpState.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: SharedScaffold(
          showBackButton: _currentStep > 1,
          onBackButtonPressed: _goToPreviousPage,
          title: Image.asset(Assets.images.appIcon1.path, height: 38),
          backgroundImage: Assets.images.authBackground.path,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentStep = index),
            children: [
              /// ── Step 1: Account Info ──
              SignupFirstStep(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                emailController: _emailController,
                passwordController: _passwordController,
                onNextStep: _goToNextPage,
                useScaffold: false,
              ),

              /// ── Step 2: Gender Selection ──
              SignupGenderStep(
                selectedGender: _selectedGender,
                currentStep: _currentStep,
                onGenderSelected: (gender) {
                  setState(() => _selectedGender = gender);
                },
                onNextStep: _goToNextPage,
                onBackButtonPressed: _goToPreviousPage,
                useScaffold: false,
              ),

              /// ── Step 3: Age ──
              SignupAgeStep(
                selectedAge: _selectedAge,
                currentStep: _currentStep,
                onAgeChanged: (age) => setState(() => _selectedAge = age),
                onNextStep: _goToNextPage,
                onBackButtonPressed: _goToPreviousPage,
                useScaffold: false,
              ),

              /// ── Step 4: Weight ──
              SignupWeightStep(
                selectedWeight: _selectedWeight,
                currentStep: _currentStep,
                onWeightChanged: (w) => setState(() => _selectedWeight = w),
                onNextStep: _goToNextPage,
                onBackButtonPressed: _goToPreviousPage,
                useScaffold: false,
              ),

              /// ── Step 5: Height ──
              SignupHeightStep(
                selectedHeight: _selectedHeight,
                currentStep: _currentStep,
                onHeightChanged: (h) => setState(() => _selectedHeight = h),
                onNextStep: _goToNextPage,
                onBackButtonPressed: _goToPreviousPage,
                useScaffold: false,
              ),

              /// —— Step 6: Goal
              GoalScreen(
                currentStep: _currentStep,
                onNextStep: (goal) {
                  _selectedGoal = goal;
                  _goToNextPage();
                },
                onBackButtonPressed: _goToPreviousPage,
                useScaffold: false,
              ),

              /// —— Step 7: Activity Level
              Builder(
                builder: (context) {
                  return ActivityScreen(
                    currentStep: _currentStep,
                    onNextStep: (activityLevel) {
                      context.read<SignUpViewModel>().doIntent(
                            OnSignUpClickEvent(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              rePassword: _passwordController.text,
                              gender: _selectedGender ?? '',
                              age: _selectedAge,
                              weight: _selectedWeight,
                              height: _selectedHeight,
                              goal: _selectedGoal ?? '',
                              activityLevel: activityLevel,
                            ),
                          );
                    },
                    onBackButtonPressed: _goToPreviousPage,
                    useScaffold: false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
