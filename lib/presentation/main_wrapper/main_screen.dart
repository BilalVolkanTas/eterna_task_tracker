import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/app_providers.dart';
import '../habit/habit_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_screen.dart';

// Alt gezinti çubuğunu (Bottom Navigation Bar) yöneten ana ekran sarmalayıcısı.
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    HabitScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(
              Icons.task_alt_rounded,
              color: AppColors.primary,
            ),
            label: 'Görevler',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars_rounded, color: AppColors.primary),
            label: 'Alışkanlıklar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primary,
            ),
            label: 'İstatistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(
              Icons.settings_rounded,
              color: AppColors.primary,
            ),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
