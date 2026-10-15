import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onToggleToday;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggleToday,
    required this.onDelete,
  });

  IconData _resolveIcon(int iconCode) {
    if (iconCode == Icons.water_drop_rounded.codePoint) {
      return Icons.water_drop_rounded;
    } else if (iconCode == Icons.menu_book_rounded.codePoint) {
      return Icons.menu_book_rounded;
    } else if (iconCode == Icons.fitness_center_rounded.codePoint) {
      return Icons.fitness_center_rounded;
    } else if (iconCode == Icons.directions_run_rounded.codePoint) {
      return Icons.directions_run_rounded;
    } else if (iconCode == Icons.self_improvement_rounded.codePoint) {
      return Icons.self_improvement_rounded;
    } else if (iconCode == Icons.code_rounded.codePoint) {
      return Icons.code_rounded;
    }
    return Icons.star_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = habit.isCompletedToday;

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.priorityHigh.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_forever_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isDone ? AppColors.habitGradient : null,
              color: isDone ? null : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _resolveIcon(habit.iconCode),
              color: isDone ? Colors.white : AppColors.primary,
              size: 22,
            ),
          ),
          title: Text(
            habit.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(width: 2),
                Text(
                  '${habit.currentStreak} Gün',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.timer_outlined,
                  size: 15,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 2),
                Text(
                  'Her ${habit.reminderValue} ${habit.reminderUnit}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              isDone
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isDone ? AppColors.primary : Colors.grey.shade400,
              size: 32,
            ),
            onPressed: onToggleToday,
          ),
        ),
      ),
    );
  }
}
