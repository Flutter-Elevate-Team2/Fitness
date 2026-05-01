import 'package:fitness_app/Features/auth/domain/use_cases/login_use_cases/valid_token_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_screen.dart';
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/Features/home/presentation/views/screens/home_screen.dart';
import 'package:fitness_app/Features/auth/presentation/sign_up/views/screens/signup_screen.dart';
import 'package:fitness_app/Features/auth/presentation/forget_password/views/screens/forget_password_screen.dart';
import 'package:fitness_app/Features/auth/presentation/login/views/screens/login_screen.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/Features/food/presentation/views/screens/meals/home_meal_test.dart';
import 'package:fitness_app/Features/food/presentation/views/screens/meals/meals_screen.dart';
import 'package:fitness_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:fitness_app/Features/onboarding/presentation/views/screens/onboarding_screen.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/edit_profile/edit_profile_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_activity.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_goal.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_weight.dart';
import 'package:fitness_app/core/constants/api_constants.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/change_password_screen.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/profile_screen.dart';
import 'package:fitness_app/Features/food/presentation/views/screens/meal_details_screen.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_view_model.dart';
import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/exercises_screen.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/video_player_screen.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Features/profile/domain/entities/user_entity.dart';

// coverage:ignore-file

class Routes {
  static const String onBoardingPath = '/onBoarding';
  static const String onBoardingName = 'onBoarding';

  static const String loginPath = '/login';
  static const String loginName = 'login';

  static const String signupPath = '/signup';
  static const String signupName = 'signup';

  static const String forgetPasswordPath = '/forgetpassword';
  static const String forgetPasswordName = 'forgetPassword';

  static const String homePath = '/home';
  static const String homeName = 'home';

  static const String exercisesPath = '/exercises';
  static const String exercisesName = 'exercises';
  static const String videoPlayerPath = '/video-player';
  static const String videoPlayerName = 'videoPlayer';
  static const String workoutPath = '/workout';
  static const String workoutName = 'workout';
  static const String mealsPath = '/meals';
  static const String mealsName = 'meals';

  static const String mealDetailsPath = '/mealdetails';
  static const String mealDetailsName = 'mealdetails';

  static const String homeMealTestPath = '/homeMealTest';
  static const String homeMealTestName = 'homeMealTest';

  static const String profilePath = '/profile';
  static const String profileName = 'profile';

  static const String changePasswordPath = '/changepassword';
  static const String changePasswordName = 'changepassword';

  static const String editProfilePath = '/editProfile';
  static const String editProfileName = 'editProfile';

  static const String editWeightPath = '/editweight';
  static const String editWeightName = 'editweight';

  static const String editGoalPath = '/editgoal';
  static const String editGoalName = 'editgoal';

  static const String editActivityPath = '/editactivity';
  static const String editActivityName = 'editactivity';

  static const String smartCoachChatPath = '/smart-coach-chat';
  static const String smartCoachChatName = 'smartCoachChat';
}

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.homePath,
    redirect: (context, state) async {
      final hasValidTokenUseCase = getIt<HasValidTokenUseCase>();
      final prefs = getIt<SharedPreferences>();
      final firebaseUser = FirebaseAuth.instance.currentUser;

      final bool firebaseLoggedIn = firebaseUser != null;

      final bool isLoggedIn = await hasValidTokenUseCase.call();
      final bool hasVisitedOnboarding =
          prefs.getBool(ApiConstants.onboardingKey) ?? false;

      final isAuthRoute =
          state.matchedLocation == Routes.loginPath ||
          state.matchedLocation == Routes.signupPath ||
          state.matchedLocation == Routes.forgetPasswordPath;

      if (!hasVisitedOnboarding &&
          state.matchedLocation != Routes.onBoardingPath) {
        return Routes.onBoardingPath;
      }

      if (hasVisitedOnboarding &&
          state.matchedLocation == Routes.onBoardingPath) {
        return Routes.loginPath;
      }

      if (!isLoggedIn &&
          !isAuthRoute &&
          state.matchedLocation != Routes.onBoardingPath) {
        return Routes.loginPath;
      }

      if (isLoggedIn && isAuthRoute && firebaseLoggedIn) {
        return Routes.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onBoardingPath,
        name: Routes.onBoardingName,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.loginPath,
        name: Routes.loginName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.signupPath,
        name: Routes.signupName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return SignupScreen(step: extra?["step"], user: extra?["user"]);
        },
      ),
      GoRoute(
        path: Routes.forgetPasswordPath,
        name: Routes.forgetPasswordName,
        builder: (context, state) => ForgetPasswordScreen(),
      ),
      GoRoute(
        path: Routes.homePath,
        name: Routes.homeName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<HomeViewModel>(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.exercisesPath,
        name: Routes.exercisesName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          if (extra == null) return const HomeScreen();

          return BlocProvider(
            create: (context) => getIt<ExercisesViewModel>(),
            child: ExercisesScreen(
              primeMoverMuscleId: extra['primeMoverMuscleId'] as String,
              muscleTitle: extra['title'] as String,
              muscleImage: extra['image'] as String?,
              preloadedExercises:
                  extra['preloadedExercises'] as List<ExerciseEntity>?,
              fixedLevelId: extra['fixedLevelId'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.mealsPath,
        name: Routes.mealsName,
        builder: (context, state) {
          final args =
              state.extra as MealsNavArgs? ??
              MealsNavArgs(selectedCategory: 'Beef', categories: const []);

          return BlocProvider(
            create: (context) => getIt<MealsViewModel>(),
            child: MealsScreen(
              selectedCategory: args.selectedCategory,
              categories: args.categories,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.videoPlayerPath,
        name: Routes.videoPlayerName,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return VideoPlayerScreen(
            videoUrl: extra['videoUrl']!,
            title: extra['title']!,
          );
        },
      ),

      GoRoute(
        path: Routes.homeMealTestPath,
        name: Routes.homeMealTestName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<HomeViewModel>(),
          child: const HomeMealTest(),
        ),
      ),
      GoRoute(
        path: Routes.mealDetailsPath,
        name: Routes.mealDetailsName,
        builder: (context, state) {
          final mealId = state.extra as String;

          return BlocProvider(
            create: (context) => getIt<MealsViewModel>(),
            child: MealDetailsScreen(mealId),
          );
        },
      ),
      GoRoute(
        path: Routes.smartCoachChatPath,
        name: Routes.smartCoachChatName,
        builder: (context, state) => const SmartCoachScreen(),
      ),
      GoRoute(
        path: Routes.profilePath,
        name: Routes.profileName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.changePasswordPath,
        name: Routes.changePasswordName,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<ChangePasswordViewModel>(),
            child: ChangePasswordScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.editProfilePath,
        name: Routes.editProfileName,
        builder: (context, state) {
          final user = state.extra as UserEntity;

          return BlocProvider(
            create: (context) => getIt<EditProfileViewModel>(),
            child: EditProfileScreen(user: user),
          );
        },
      ),
      GoRoute(
        path: Routes.editWeightPath,
        name: Routes.editWeightName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return EditWeightScreen(
            initialWeight: extra['initialWeight'],
            onWeightChanged: extra['onWeightChanged'],
            onStepComplete: extra['onStepComplete'],
            onBackButtonPressed: extra['onBackButtonPressed'],
          );
        },
      ),
      GoRoute(
        path: Routes.editGoalPath,
        name: Routes.editGoalName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditGoal(
            initialGoal: extra['initialGoal'],
            onGoalSelected: extra['onGoalSelected'],
            onBackButtonPressed: extra['onBackButtonPressed'],
          );
        },
      ),
      GoRoute(
        path: Routes.editActivityPath,
        name: Routes.editActivityName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditActivity(
            initialActivity: extra['initialActivity'],
            onActivitySelected: extra['onActivitySelected'],
            onBackButtonPressed: extra['onBackButtonPressed'],
          );
        },
      ),
      // GoRoute(
      //   path: Routes.homePath,
      //   name: Routes.homeName,
      //   builder: (context, state) => const HomeScreen(),
      // ),
    ],
  );
}
