import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import '../../../features/tasks/models/task_model.dart';

class WidgetService {
  static const String _appGroupId = 'group.com.example.smarttasktracker';
  static const String _widgetName = 'TaskWidget';

  static final WidgetService _instance = WidgetService._();
  factory WidgetService() => _instance;
  WidgetService._();

  Future<void> updateWidget(List<TaskModel> tasks) async {
    await HomeWidget.setAppGroupId(_appGroupId);

    final now = DateTime.now();
    final incompleteTasks = tasks
        .where((t) => t.status != TaskStatus.done)
        .toList();

    // Öncelik sırasına göre sırala
    incompleteTasks.sort((a, b) {
      int priorityOrder(TaskPriority p) {
        switch (p) {
          case TaskPriority.high: return 0;
          case TaskPriority.medium: return 1;
          case TaskPriority.low: return 2;
        }
      }
      return priorityOrder(a.priority).compareTo(priorityOrder(b.priority));
    });

    // İlk 3 task
    final widgetTasks = incompleteTasks.take(3).map((t) => {
      'id': t.id,
      'title': t.title,
      'priority': t.priority.name,
      'isOverdue': t.dueDate != null &&
          t.dueDate!.isBefore(now) &&
          t.status != TaskStatus.done,
    }).toList();

    final totalCount = tasks.length;
    final completedCount =
        tasks.where((t) => t.status == TaskStatus.done).length;

    await HomeWidget.saveWidgetData('widget_tasks', jsonEncode(widgetTasks));
    await HomeWidget.saveWidgetData('widget_total_count', totalCount);
    await HomeWidget.saveWidgetData('widget_completed_count', completedCount);

    await HomeWidget.updateWidget(
      iOSName: _widgetName,
    );
  }
}