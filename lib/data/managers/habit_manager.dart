import '../models/habit_model.dart';
import '../services/local_storage_service.dart';

// Alışkanlıkların CRUD işlemlerini yöneten sınıf.
class HabitManager {
  final LocalStorageService _storageService;

  HabitManager(this._storageService);

  List<HabitModel> getAllHabits() {
    final box = _storageService.habitsBox;
    final habits = box.values
        .map(
          (item) => HabitModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();

    habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return habits;
  }

  Future<void> saveHabit(HabitModel habit) async {
    await _storageService.habitsBox.put(habit.id, habit.toMap());
  }

  Future<void> deleteHabit(String id) async {
    await _storageService.habitsBox.delete(id);
  }

  Future<HabitModel> toggleHabitForToday(HabitModel habit) async {
    final todayKey = HabitModel.dateToKey(DateTime.now());
    final updatedDates = List<String>.from(habit.completedDates);

    if (updatedDates.contains(todayKey)) {
      updatedDates.remove(todayKey);
    } else {
      updatedDates.add(todayKey);
    }

    final updatedHabit = habit.copyWith(completedDates: updatedDates);
    await saveHabit(updatedHabit);
    return updatedHabit;
  }
}
