// Alışkanlık veri modeli
class HabitModel {
  final String id;
  final String title;
  final int iconCode;
  final DateTime createdAt;
  final List<String> completedDates; // 'YYYY-MM-DD' formatında tarihler
  final int reminderValue; // Örn: 10, 30, 1
  final String reminderUnit; // 'Saniye', 'Dakika', 'Saat'

  HabitModel({
    required this.id,
    required this.title,
    required this.iconCode,
    required this.createdAt,
    this.completedDates = const [],
    this.reminderValue = 10,
    this.reminderUnit = 'Saniye',
  });

  bool get isCompletedToday {
    final todayKey = dateToKey(DateTime.now());
    return completedDates.contains(todayKey);
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    int streak = 0;
    DateTime checkDate = DateTime.now();

    while (true) {
      final key = dateToKey(checkDate);
      if (completedDates.contains(key)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        if (streak == 0) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          final yesterdayKey = dateToKey(checkDate);
          if (completedDates.contains(yesterdayKey)) {
            continue;
          }
        }
        break;
      }
    }
    return streak;
  }

  static String dateToKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconCode': iconCode,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates,
      'reminderValue': reminderValue,
      'reminderUnit': reminderUnit,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      title: map['title'] as String,
      iconCode: map['iconCode'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedDates: List<String>.from(map['completedDates'] ?? []),
      reminderValue: map['reminderValue'] ?? 10,
      reminderUnit: map['reminderUnit'] ?? 'Saniye',
    );
  }

  HabitModel copyWith({
    List<String>? completedDates,
    int? reminderValue,
    String? reminderUnit,
  }) {
    return HabitModel(
      id: id,
      title: title,
      iconCode: iconCode,
      createdAt: createdAt,
      completedDates: completedDates ?? this.completedDates,
      reminderValue: reminderValue ?? this.reminderValue,
      reminderUnit: reminderUnit ?? this.reminderUnit,
    );
  }
}
