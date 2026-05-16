import 'package:fitness_app/Features/home/presentation/views/screens/explore_screen.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:fitness_app/Features/profile/presentation/views/screens/profile_screen.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/workouts_screen.dart';
import 'package:fitness_app/Features/smart_coach/presentation/views/screens/smart_coach_screen.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _selectedWorkoutGroupId;

  void _switchToWorkoutsTab({String? selectedGroupId}) {
    setState(() {
      _currentIndex = 2;
      if (selectedGroupId != null) {
        _selectedWorkoutGroupId = selectedGroupId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ExploreScreen(onSeeAllWorkoutsTapped: _switchToWorkoutsTab),
      SmartCoachScreen(
        onBack: () => setState(() => _currentIndex = 0),
      ),
      WorkoutsScreen(initialGroupId: _selectedWorkoutGroupId),
      ProfileScreen(),
    ];

    return SharedScaffold(
      backgroundImage: Assets.images.food.path,
      showBackButton: false,
      body: Stack(
        children: [

          Positioned.fill(child: pages[_currentIndex]),


          /// Hidden when the Smart Coach tab (index 1) is active.
          if (_currentIndex != 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
            ),
        ],
      ),
    );
  }
}
