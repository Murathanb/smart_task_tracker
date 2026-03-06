import 'package:hive_flutter/hive_flutter.dart';
import '../../features/tasks/models/task_model.dart';

class LocalCacheService {
  static const String _tasksBoxName = 'tasks_cache';
  static const String _connectivityBoxName = 'connectivity';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_tasksBoxName);
    await Hive.openBox<bool>(_connectivityBoxName);
  }

  Box<Map> get _tasksBox => Hive.box<Map>(_tasksBoxName);

  // Kullanıcının tüm tasklerini cache'e yaz
  Future<void> cacheTasks(String userId, List<TaskModel> tasks) async {
    final box = _tasksBox;
    // Önce bu kullanıcının eski cache'ini temizle
    final keysToDelete = box.keys
        .where((k) => k.toString().startsWith('${userId}_'))
        .toList();
    for (final key in keysToDelete) {
      await box.delete(key);
    }
    // Yeni taskları yaz
    for (final task in tasks) {
      await box.put('${userId}_${task.id}', task.toHive());
    }
  }

  // Cache'den taskları oku
  List<TaskModel> getCachedTasks(String userId) {
    final box = _tasksBox;
    return box.keys
        .where((k) => k.toString().startsWith('${userId}_'))
        .map((k) => TaskModel.fromHive(box.get(k)!))
        .toList();
  }

  // Tek task güncelle
  Future<void> upsertTask(String userId, TaskModel task) async {
    await _tasksBox.put('${userId}_${task.id}', task.toHive());
  }

  // Tek task sil
  Future<void> deleteTask(String userId, String taskId) async {
    await _tasksBox.delete('${userId}_$taskId');
  }

  // Cache'i temizle
  Future<void> clearCache(String userId) async {
    final keysToDelete = _tasksBox.keys
        .where((k) => k.toString().startsWith('${userId}_'))
        .toList();
    for (final key in keysToDelete) {
      await _tasksBox.delete(key);
    }
  }
}