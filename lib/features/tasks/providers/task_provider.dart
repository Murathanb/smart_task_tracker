import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/badge_service.dart';
import '../../../core/services/widget_service.dart';
import '../../../features/auth/providers/auth_state_provider.dart';
import '../models/task_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final taskListProvider = StreamProvider<List<TaskModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.watch(firestoreServiceProvider).watchTasks(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (e, _) => const Stream.empty(),
  );
});

final cachedTaskListProvider = FutureProvider<List<TaskModel>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;
  if (user == null) return [];
  return ref.watch(firestoreServiceProvider).getCachedTasks(user.uid);
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final statusFilterProvider = StateProvider<TaskStatus?>((ref) => null);
final priorityFilterProvider = StateProvider<TaskPriority?>((ref) => null);

List<TaskModel> _sortAndFilter({
  required List<TaskModel> tasks,
  required String query,
  required TaskStatus? statusFilter,
  required TaskPriority? priorityFilter,
}) {
  final filtered = tasks.where((task) {
    final matchesQuery = query.isEmpty ||
        task.title.toLowerCase().contains(query) ||
        task.description.toLowerCase().contains(query);
    final matchesStatus =
        statusFilter == null || task.status == statusFilter;
    final matchesPriority =
        priorityFilter == null || task.priority == priorityFilter;
    return matchesQuery && matchesStatus && matchesPriority;
  }).toList();

  int priorityOrder(TaskPriority p) {
    switch (p) {
      case TaskPriority.high:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.low:
        return 2;
    }
  }

  filtered.sort((a, b) {
    final pComp =
        priorityOrder(a.priority).compareTo(priorityOrder(b.priority));
    if (pComp != 0) return pComp;
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
  });

  return filtered;
}

final filteredTaskListProvider = Provider<List<TaskModel>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final statusFilter = ref.watch(statusFilterProvider);
  final priorityFilter = ref.watch(priorityFilterProvider);

  return tasksAsync.when(
    data: (tasks) => _sortAndFilter(
      tasks: tasks,
      query: query,
      statusFilter: statusFilter,
      priorityFilter: priorityFilter,
    ),
    loading: () {
      final cached = ref.watch(cachedTaskListProvider).value ?? [];
      return _sortAndFilter(
        tasks: cached,
        query: query,
        statusFilter: statusFilter,
        priorityFilter: priorityFilter,
      );
    },
    error: (e, _) {
      final cached = ref.watch(cachedTaskListProvider).value ?? [];
      return _sortAndFilter(
        tasks: cached,
        query: query,
        statusFilter: statusFilter,
        priorityFilter: priorityFilter,
      );
    },
  );
});

final badgeProvider = Provider<void>((ref) {
  final tasks = ref.watch(filteredTaskListProvider);
  final incomplete = tasks.where((t) => t.status != TaskStatus.done).length;
  BadgeService().updateBadge(incomplete);
});

final widgetProvider = Provider<void>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  tasksAsync.whenData((tasks) {
    WidgetService().updateWidget(tasks);
  });
});

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreService _service;
  final String _userId;
  final _notifications = NotificationService();

  TaskNotifier(this._service, this._userId)
      : super(const AsyncValue.data(null));

  Future<void> addTask({
    required String title,
    required String description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final task = TaskModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        status: TaskStatus.todo,
        priority: priority,
        createdAt: DateTime.now(),
        dueDate: dueDate,
        userId: _userId,
      );
      await _service.addTask(task);
      if (dueDate != null) {
        await _notifications.scheduleTaskReminder(
          id: task.id.hashCode,
          title: title,
          dueDate: dueDate,
        );
      }
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _service.updateTask(task);
      await _notifications.cancelTaskReminder(task.id.hashCode);
      if (task.dueDate != null && task.status != TaskStatus.done) {
        await _notifications.scheduleTaskReminder(
          id: task.id.hashCode,
          title: task.title,
          dueDate: task.dueDate!,
        );
      }
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    await _service.updateTaskStatus(_userId, taskId, status);
    if (status == TaskStatus.done) {
      await _notifications.cancelTaskReminder(taskId.hashCode);
    }
  }

  Future<void> deleteTask(String taskId) async {
    await _notifications.cancelTaskReminder(taskId.hashCode);
    await _service.deleteTask(_userId, taskId);
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  final user = ref.watch(authStateProvider).value;
  return TaskNotifier(
    ref.watch(firestoreServiceProvider),
    user?.uid ?? '',
  );
});