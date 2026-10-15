import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../providers/app_providers.dart';

// Kullanıcının görev ve alışkanlık tamamlanma verilerine göre dinamik grafik üreten ekran.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final habits = ref.watch(habitListProvider);

    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    final totalTasks = tasks.length;
    final taskRate = totalTasks == 0
        ? 0
        : ((completedTasks.length / totalTasks) * 100).toInt();

    final completedHabitsToday = habits.where((h) => h.isCompletedToday).length;
    final totalHabits = habits.length;
    final habitRate = totalHabits == 0
        ? 0
        : ((completedHabitsToday / totalHabits) * 100).toInt();

    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    // Haftalık tamamlanan görev sayıları
    final weeklyData = List.generate(7, (index) {
      return completedTasks
          .where((t) => t.completedAt?.weekday == (index + 1))
          .length;
    });

    final hasCompletedData = weeklyData.any((count) => count > 0);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Performans & İstatistik'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Görev Başarısı',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '%$taskRate',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${completedTasks.length} / $totalTasks tamamlandı',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Bugünün Alışkanlığı',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '%$habitRate',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.priorityLow,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedHabitsToday / $totalHabits yapıldı',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Haftalık Görev Tamamlama Grafiği',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    !hasCompletedData
                        ? SizedBox(
                            height: 180,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.bar_chart_rounded,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Henüz tamamlanmış bir görev verisi yok.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 220,
                            child: BarChart(
                              BarChartData(
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= 0 && index < days.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              days[index],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: List.generate(7, (index) {
                                  final count = weeklyData[index];
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: count.toDouble(),
                                        color: AppColors.primary,
                                        width: 18,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
