import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/managers/habit_manager.dart';
import '../data/managers/task_manager.dart';
import '../data/models/habit_model.dart';
import '../data/models/task_model.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/notification_service.dart';

// Veritabanı servisini sunar
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'localStorageService main.dart içinde override edilmelidir.',
  );
});

// Bildirim servisini sunar
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Task Manager Provider
final taskManagerProvider = Provider<TaskManager>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return TaskManager(storage);
});

// Habit Manager Provider
final habitManagerProvider = Provider<HabitManager>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return HabitManager(storage);
});

// Karanlık Mod Notifier
class DarkModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final storage = ref.watch(localStorageServiceProvider);
    return storage.isDarkMode;
  }

  void toggleTheme() {
    final storage = ref.read(localStorageServiceProvider);
    final newValue = !state;
    storage.setDarkMode(newValue);
    state = newValue;
  }
}

final darkModeProvider = NotifierProvider<DarkModeNotifier, bool>(() {
  return DarkModeNotifier();
});

// Navigasyon Notifier
class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final navigationProvider = NotifierProvider<NavigationNotifier, int>(() {
  return NavigationNotifier();
});

// Görev Listesi Notifier
class TaskListNotifier extends Notifier<List<TaskModel>> {
  late final TaskManager _taskManager;

  @override
  List<TaskModel> build() {
    _taskManager = ref.read(taskManagerProvider);
    _loadTasks();
    return [];
  }

  Future<void> _loadTasks() async {
    await _taskManager.seedInitialTasksIfNeeded();
    state = _taskManager.getAllTasks();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskPriority priority,
  }) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      createdAt: DateTime.now(),
    );
    await _taskManager.saveTask(newTask);
    state = _taskManager.getAllTasks();
  }

  Future<void> toggleTask(TaskModel task) async {
    await _taskManager.toggleTaskCompletion(task);
    state = _taskManager.getAllTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskManager.deleteTask(id);
    state = _taskManager.getAllTasks();
  }
}

final taskListProvider = NotifierProvider<TaskListNotifier, List<TaskModel>>(
  () {
    return TaskListNotifier();
  },
);

// Alışkanlık Listesi Notifier
class HabitListNotifier extends Notifier<List<HabitModel>> {
  late final HabitManager _habitManager;

  @override
  List<HabitModel> build() {
    _habitManager = ref.read(habitManagerProvider);
    final habits = _habitManager.getAllHabits();
    _scheduleNotifications(habits);
    return habits;
  }

  void _scheduleNotifications(List<HabitModel> habits) {
    final notificationService = ref.read(notificationServiceProvider);

    for (var habit in habits) {
      final habitNotificationId = habit.id.hashCode;

      notificationService.cancelNotification(habitNotificationId);

      if (!habit.isCompletedToday) {
        int seconds = habit.reminderValue;
        if (habit.reminderUnit == 'Dakika') {
          seconds = habit.reminderValue * 60;
        } else if (habit.reminderUnit == 'Saat') {
          seconds = habit.reminderValue * 3600;
        }

        if (seconds > 0) {
          notificationService.scheduleRepeatedNotification(
            id: habitNotificationId,
            title: 'Hatırlatıcı: ${habit.title} 🎯',
            body:
                'Bugün henüz "${habit.title}" alışkanlığınızı tamamlamadınız!',
            seconds: seconds,
          );
        }
      }
    }
  }

  void refreshHabits() {
    final habits = _habitManager.getAllHabits();
    state = habits;
    _scheduleNotifications(habits);
  }

  Future<void> addHabit({
    required String title,
    required int iconCode,
    required int reminderValue,
    required String reminderUnit,
  }) async {
    final newHabit = HabitModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      iconCode: iconCode,
      createdAt: DateTime.now(),
      reminderValue: reminderValue,
      reminderUnit: reminderUnit,
    );
    await _habitManager.saveHabit(newHabit);
    refreshHabits();
  }

  Future<void> toggleHabitToday(HabitModel habit) async {
    await _habitManager.toggleHabitForToday(habit);
    refreshHabits();
  }

  Future<void> deleteHabit(String id) async {
    await _habitManager.deleteHabit(id);
    refreshHabits();
  }
}

final habitListProvider = NotifierProvider<HabitListNotifier, List<HabitModel>>(
  () {
    return HabitListNotifier();
  },
);
