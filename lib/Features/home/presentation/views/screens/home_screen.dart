import 'dart:ui';

import 'package:fitness_app/Features/home/presentation/views/widgets/custom_bottom_nav_bar.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_category.dart';
import 'package:fitness_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/workouts_screen.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    /// Placeholder pages for each tab
    final List<Widget> pages = [
      _PlaceholderTab(title: context.l10n.explore),
      _PlaceholderTab(title: context.l10n.chatAi),
      const WorkoutsScreen(),
      _PlaceholderTab(title: context.l10n.profile),
    ];

    return SharedScaffold(
      backgroundImage: Assets.images.homeBackground.path,
      showBackButton: false,
      body: Stack(
        children: [
          /// ── Blur overlay on the background image ──
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.5, sigmaY: 12.5),
              child: Container(color: const Color(0x801A1A1A)),
            ),
          ),

          /// ── Page content ──
          Positioned.fill(child: pages[_currentIndex]),

          /// ── Floating Bottom Nav Bar ──
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

/// Temporary placeholder for tabs until real content is built
class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: Column(
        children: [
          HomeHeader(),
          SizedBox(height: 24,),
          CategorySection(),
        ],
      ),
    );
  }
}
