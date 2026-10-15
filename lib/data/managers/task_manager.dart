import '../models/task_model.dart';
import '../services/local_storage_service.dart';

// Görevlerin CRUD ve sıralama işlemlerini yöneten sınıf.
class TaskManager {
  final LocalStorageService _storageService;

  TaskManager(this._storageService);

  List<TaskModel> getAllTasks() {
    final box = _storageService.tasksBox;
    final tasks = box.values
        .map((item) => TaskModel.fromMap(Map<dynamic, dynamic>.from(item)))
        .toList();

    // Tamamlanmayanlar üstte, kendi içinde tarihe göre sıralı
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.dueDate.compareTo(b.dueDate);
    });

    return tasks;
  }

  Future<void> saveTask(TaskModel task) async {
    await _storageService.tasksBox.put(task.id, task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _storageService.tasksBox.delete(id);
  }

  Future<TaskModel> toggleTaskCompletion(TaskModel task) async {
    final nowCompleted = !task.isCompleted;
    final updatedTask = task.copyWith(
      isCompleted: nowCompleted,
      completedAt: nowCompleted ? DateTime.now() : null,
      clearCompletedAt: !nowCompleted,
    );
    await saveTask(updatedTask);
    return updatedTask;
  }

  // Başlangıçta örnek görev eklenmez, liste tamamen boş başlar.
  Future<void> seedInitialTasksIfNeeded() async {}
}
