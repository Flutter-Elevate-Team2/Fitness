import 'dart:async';
import 'package:fitness_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:fitness_app/Features/workouts/data/models/difficulty_level_response/difficulty_level_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/exercises_response/exercise_hive_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_group_model.dart';
import 'package:fitness_app/Features/workouts/data/models/muscle_model.dart';
import 'package:fitness_app/Features/workouts/data/models/random_muscle_model.dart';
 import 'package:fitness_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/controller/session_controller.dart';
import 'package:fitness_app/core/controller/session_expired.dart';
import 'package:fitness_app/core/data_base/hive_database_service.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:fitness_app/core/l10n/app_localizations.dart';
import 'package:fitness_app/core/theming/app_theming.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
 import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_ce/hive.dart';

import 'Features/food/data/models/meals_models/category_model.dart';
import 'Features/food/data/models/meals_models/meal_details_model.dart';
import 'Features/food/data/models/meals_models/meal_model.dart';
import 'Features/profile/presentation/view_model/profile_view_model.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
  await dotenv.load(fileName: ".env");

  await HiveDatabaseService.init(
    registerAdapters: () {
      Hive.registerAdapter(DifficultyLevelHiveModelAdapter()); // typeId: 1
      Hive.registerAdapter(ExerciseHiveModelAdapter()); // typeId: 2
      Hive.registerAdapter(CategoryModelAdapter());
      Hive.registerAdapter(MealModelAdapter());
      Hive.registerAdapter(MealDetailsModelAdapter());
      Hive.registerAdapter(MuscleGroupModelAdapter());
      Hive.registerAdapter(MuscleModelAdapter());
      Hive.registerAdapter(RandomMuscleModelAdapter());
    },
  );
  await configureDependencies();
  runApp(const MyApp());

}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sessionController = getIt<SessionController>();
  final List<StreamSubscription> _subscriptions = [];
  bool _isSplashRemoved = false;
  @override
  void initState() {
    super.initState();

    _subscriptions.add(
      _sessionController.onSessionExpired.listen((_) {
        SessionExpiredHandler.handle();
      }),
    );

    _subscriptions.add(
      _sessionController.onLogout.listen((_) {
        AppRouter.router.goNamed(Routes.onBoardingName);
      }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isSplashRemoved) {
      precacheImage(
        AssetImage(Assets.images.authBackground.path),
        context,
      ).then((_) {
        FlutterNativeSplash.remove();
        _isSplashRemoved = true;
      });
    }
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
           BlocProvider(
            create: (_) =>
            getIt<ProfileViewModel>()..doIntent(GetUserProfileEvent()),
          ),
        ],
        child:  MaterialApp.router(
     return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<LoginViewModel>(),
        )
      ],
      child: MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Super Fitness',
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.darkTheme,
    )
    );
  }
}
