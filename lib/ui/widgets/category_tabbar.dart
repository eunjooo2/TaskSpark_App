import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/category.dart';
import '../../service/category_service.dart';
import 'category_form.dart';

class CategoryTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onRefreshCategories;
  final CategoryService categoryService;

  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.onRefreshCategories,
    required this.categoryService,
  });

  void _openAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CategoryFormDialog(
        categoryService: categoryService,
        onSuccess: onRefreshCategories,
      ),
    );
  }

  void _openEditDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (_) => CategoryFormDialog(
        categoryService: categoryService,
        categoryToEdit: category,
        onSuccess: onRefreshCategories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildChip(
                context: context,
                label: "전체",
                selected: selectedCategoryId == null,
                onSelected: () => onCategorySelected(null),
              ),
              const SizedBox(width: 6),
              ...categories.map((c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onLongPress: () => _openEditDialog(context, c),
                  child: _buildChip(
                    context: context,
                    label: "${c.emoji ?? ''} ${c.name}",
                    selected: selectedCategoryId == c.id,
                    onSelected: () => onCategorySelected(c.id),
                  ),
                ),
              )),
              const SizedBox(width: 6),
              ChoiceChip(
                label: const Icon(Icons.add, size: 18),
                selected: false,
                onSelected: (_) => _openAddDialog(context),
                backgroundColor: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: Colors.white,
      backgroundColor: Colors.grey[300],
      labelStyle: TextStyle(
        color: selected ? Theme.of(context).colorScheme.primary : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
