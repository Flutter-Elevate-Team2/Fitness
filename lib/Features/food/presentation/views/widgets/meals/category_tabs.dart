import 'package:fitness_app/Features/food/presentation/view_models/meals_event.dart';
import 'package:fitness_app/Features/food/presentation/view_models/meals_view_model.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTabsWidget extends StatefulWidget {
  final String initialCategory;
  final List<String> categories;

  const CategoryTabsWidget({
    super.key,
    required this.initialCategory,
    required this.categories,
  });

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  late String selectedCategory;
  late ScrollController _scrollController;
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    _scrollController = ScrollController();
    _itemKeys = List.generate(widget.categories.length, (_) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _scrollToSelected() {
    final index = widget.categories.indexOf(selectedCategory);
    if (index <= 0) return;

    final keyContext = _itemKeys[index].currentContext;
    if (keyContext == null) return;

    Scrollable.ensureVisible(
      keyContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: widget.categories.asMap().entries.map((entry) {
          final index = entry.key;
          final cat = entry.value;
          final isSelected = selectedCategory == cat;

          return GestureDetector(
            onTap: () {
              setState(() => selectedCategory = cat);
              context.read<MealsViewModel>().doIntent(
                FetchMealsByCategoryEvent(cat),
              );
            },
            child: Container(
              key: _itemKeys[index],
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
