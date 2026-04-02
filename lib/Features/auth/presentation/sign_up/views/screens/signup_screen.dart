import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_age_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_first_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_gender_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_height_step.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/widgets/signup_weight_step.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
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
          ),

          /// ── Step 2: Gender Selection ──
          SignupGenderStep(
            selectedGender: _selectedGender,
            currentStep: _currentStep,
            onGenderSelected: (gender) {
              setState(() => _selectedGender = gender);
            },
            onNextStep: _goToNextPage,
          ),

          /// ── Step 3: Age ──
          SignupAgeStep(
            selectedAge: _selectedAge,
            currentStep: _currentStep,
            onAgeChanged: (age) => setState(() => _selectedAge = age),
            onNextStep: _goToNextPage,
          ),

          /// ── Step 4: Weight ──
          SignupWeightStep(
            selectedWeight: _selectedWeight,
            currentStep: _currentStep,
            onWeightChanged: (w) => setState(() => _selectedWeight = w),
            onNextStep: _goToNextPage,
          ),

          /// ── Step 5: Height ──
          SignupHeightStep(
            selectedHeight: _selectedHeight,
            currentStep: _currentStep,
            onHeightChanged: (h) => setState(() => _selectedHeight = h),
            onNextStep: _goToNextPage,
          ),

          /// ── Step 6: Placeholder ──
          Container(color: AppColors.black),
        ],
      ),
    );
  }
}
