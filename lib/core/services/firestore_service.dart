import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/tasks/models/task_model.dart';
import 'local_cache_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final LocalCacheService _cache = LocalCacheService();

  CollectionReference _tasksRef(String userId) {
    return _db.collection('users').doc(userId).collection('tasks');
  }

  Stream<List<TaskModel>> watchTasks(String userId) {
    return _tasksRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      final tasks =
          snap.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
      _cache.cacheTasks(userId, tasks);
      return tasks;
    });
  }

  Future<List<TaskModel>> getCachedTasks(String userId) async {
    return _cache.getCachedTasks(userId);
  }

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> addTask(TaskModel task) async {
    await _cache.upsertTask(task.userId, task);
    await _tasksRef(task.userId).doc(task.id).set(task.toFirestore());
  }

  Future<void> updateTask(TaskModel task) async {
    await _cache.upsertTask(task.userId, task);
    await _tasksRef(task.userId).doc(task.id).update(task.toFirestore());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _cache.deleteTask(userId, taskId);
    await _tasksRef(userId).doc(taskId).delete();
  }

  Future<void> updateTaskStatus(
      String userId, String taskId, TaskStatus status) async {
    final cached = _cache.getCachedTasks(userId);
    final task = cached.where((t) => t.id == taskId).firstOrNull;
    if (task != null) {
      await _cache.upsertTask(userId, task.copyWith(status: status));
    }
    await _tasksRef(userId).doc(taskId).update({'status': status.name});
  }
}