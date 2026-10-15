import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../providers/app_providers.dart';
import 'widgets/add_habit_dialog.dart';
import 'widgets/habit_card.dart';

// Günlük alışkanlıkların listelendiği ve takibinin yapıldığı ekran.
class HabitScreen extends ConsumerWidget {
  const HabitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Alışkanlık Takibi'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => const AddHabitDialog());
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: habits.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.stars_rounded, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Henüz eklenmiş bir alışkanlığınız yok.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Sağ alttaki + butonuna basarak yeni alışkanlık oluşturabilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitCard(
                  habit: habit,
                  onToggleToday: () => ref
                      .read(habitListProvider.notifier)
                      .toggleHabitToday(habit),
                  onDelete: () => ref
                      .read(habitListProvider.notifier)
                      .deleteHabit(habit.id),
                );
              },
            ),
    );
  }
}
