import 'package:fitness_app/Features/workouts/domain/entities/exercise_entity.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_states.dart';
import 'package:fitness_app/Features/workouts/presentation/view_models/exercises/exercises_view_model.dart';
import 'package:fitness_app/Features/workouts/presentation/views/screens/video_player_screen.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widget/shared_scaffold.dart';
import '../../view_models/exercises/exercises_events.dart';
import '../widgets/difficulty_tabs.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_header.dart';
import '../widgets/exercises_shimmer.dart';

class ExercisesScreen extends StatefulWidget {
  final String primeMoverMuscleId;
  final String muscleTitle;
  final bool showTabs;
  final String? fixedLevelId;
  final List<ExerciseEntity>? preloadedExercises;
  final String? muscleImage;

  const ExercisesScreen({
    super.key,
    required this.primeMoverMuscleId,
    required this.muscleTitle,
    this.showTabs = true,
    this.fixedLevelId,
    this.preloadedExercises,
    this.muscleImage,
  });

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_onScroll);
    });

    if (widget.preloadedExercises != null) {
      context.read<ExercisesViewModel>().doIntent(
        LoadPreloadedExercises(exercises: widget.preloadedExercises!),
      );
    } else {
      context.read<ExercisesViewModel>().doIntent(
        GetLevels(
          primeMoverMuscleId: widget.primeMoverMuscleId,
          fixedLevelId: widget.fixedLevelId,
        ),
      );
    }
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.maxScrollExtent == 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      final state = context.read<ExercisesViewModel>().state;

      if (widget.preloadedExercises != null) return;

      if (state.hasMore &&
          !state.isLoadingMore &&
          state.selectedLevelId != null) {
        context.read<ExercisesViewModel>().doIntent(
          LoadMoreExercises(
            primeMoverMuscleId: widget.primeMoverMuscleId,
            difficultyLevelId: state.selectedLevelId!,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.exercisesBackground.path,
      showBackButton: false,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ─────────────────────────────────────────────
          // 1. Header (SliverAppBar)
          // ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: ExerciseHeaderWidget(
                title: widget.muscleTitle,
                description: context.l10n.buildYourMusclesWorkout,
                timeInMinutes: context.l10n.thirtyMin,
                calories: context.l10n.oneHundredThirtyCal,
                imageUrl:
                    widget.muscleImage ??
                    Assets.images.exercisesBackground.path,
                onBackTapped: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
              ),
            ),
          ),

          // ─────────────────────────────────────────────
          // 2. Difficulty Tabs Section
          // ─────────────────────────────────────────────
          if (widget.showTabs)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BlocBuilder<ExercisesViewModel, ExercisesState>(
                  buildWhen: (previous, current) =>
                      previous.levelsState != current.levelsState ||
                      previous.selectedLevelId != current.selectedLevelId,
                  builder: (context, state) {
                    if (state.levelsState?.isLoading == true) {
                      return const DifficultyTabsShimmer();
                    }

                    if (state.levelsState?.errorMessage != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            state.levelsState!.errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }

                    final levels = state.levelsState?.data ?? [];
                    if (levels.isEmpty) return const SizedBox.shrink();
                    final selectedId = state.selectedLevelId ?? levels.first.id;

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: DifficultyTabsWidget(
                        levels: levels,
                        selectedLevelId: selectedId,
                        onTabChanged: (id) {
                          context.read<ExercisesViewModel>().doIntent(
                            ChangeLevel(
                              newDifficultyLevelId: id,
                              primeMoverMuscleId: widget.primeMoverMuscleId,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

          // ─────────────────────────────────────────────
          // 3. Exercises List Section
          // ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SharedContainer(
                borderRadius: 20,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    BlocBuilder<ExercisesViewModel, ExercisesState>(
                      buildWhen: (previous, current) =>
                          previous.exercisesState != current.exercisesState ||
                          previous.levelsState != current.levelsState ||
                          previous.selectedLevelId != current.selectedLevelId,
                      builder: (context, state) {
                        final exerciseData = state.exercisesState?.data;

                        if (state.exercisesState == null ||
                            (state.exercisesState?.isLoading == true &&
                                (exerciseData == null ||
                                    exerciseData.isEmpty))) {
                          return const ExercisesListShimmer();
                        }

                        if (state.exercisesState?.errorMessage != null &&
                            (exerciseData == null || exerciseData.isEmpty)) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Center(
                              child: Text(
                                state.exercisesState!.errorMessage!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }

                        final exercises = exerciseData ?? [];
                        if (exercises.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Center(
                              child: Text(
                                context.l10n.noExercisesFoundForThisLevel,
                                style: const TextStyle(
                                  color: AppColors.light400,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            return ExerciseCardWidget(
                              exercise: exercises[index],
                              onPlayTapped: exercises[index].videoUrl != null
                                  ? () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayerScreen(
                                          videoUrl: exercises[index].videoUrl!,
                                          title: exercises[index].title,
                                        ),
                                      ),
                                    )
                                  : null,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.white.withOpacity(0.08),
                              height: 1,
                              thickness: 1,
                            );
                          },
                        );
                      },
                    ),

                    if (widget.preloadedExercises == null)
                      BlocBuilder<ExercisesViewModel, ExercisesState>(
                        buildWhen: (previous, current) =>
                            previous.isLoadingMore != current.isLoadingMore,
                        builder: (context, state) {
                          if (!state.isLoadingMore) {
                            return const SizedBox.shrink();
                          }
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }
}
