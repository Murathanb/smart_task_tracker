import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/ui/settings_page.dart';
import '../../dashboard/ui/dashboard_page.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFF8896B0);
      case TaskStatus.inProgress:
        return const Color(0xFFF59E0B);
      case TaskStatus.done:
        return const Color(0xFF10B981);
    }
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF10B981);
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.high:
        return const Color(0xFFEF4444);
    }
  }

  String _statusLabel(TaskStatus status, AppLocalizations l10n) {
    switch (status) {
      case TaskStatus.todo:
        return l10n.statusTodo;
      case TaskStatus.inProgress:
        return l10n.statusInProgress;
      case TaskStatus.done:
        return l10n.statusDone;
    }
  }

  String _priorityLabel(TaskPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TaskPriority.low:
        return l10n.priorityLow;
      case TaskPriority.medium:
        return l10n.priorityMedium;
      case TaskPriority.high:
        return l10n.priorityHigh;
    }
  }

  IconData _statusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked_rounded;
      case TaskStatus.inProgress:
        return Icons.timelapse_rounded;
      case TaskStatus.done:
        return Icons.check_circle_rounded;
    }
  }

  void _showFilterSheet(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final statusFilter = ref.watch(statusFilterProvider);
          final priorityFilter = ref.watch(priorityFilterProvider);
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: scheme.onSurface.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.filter,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    TextButton(
                      onPressed: () {
                        ref.read(statusFilterProvider.notifier).state = null;
                        ref.read(priorityFilterProvider.notifier).state =
                            null;
                      },
                      child: Text(l10n.filterClear,
                          style: const TextStyle(
                              color: Color(0xFFE8443A))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.filterStatus,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: TaskStatus.values.map((s) {
                    final isSelected = statusFilter == s;
                    final color = _statusColor(s);
                    return GestureDetector(
                      onTap: () {
                        ref.read(statusFilterProvider.notifier).state =
                            isSelected ? null : s;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : scheme.onSurface
                                    .withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          _statusLabel(s, l10n),
                          style: TextStyle(
                            color: isSelected ? color : null,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(l10n.filterPriority,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: TaskPriority.values.map((p) {
                    final isSelected = priorityFilter == p;
                    final color = _priorityColor(p);
                    return GestureDetector(
                      onTap: () {
                        ref.read(priorityFilterProvider.notifier).state =
                            isSelected ? null : p;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : scheme.onSurface
                                    .withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          _priorityLabel(p, l10n),
                          style: TextStyle(
                            color: isSelected ? color : null,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.filterApply),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTaskSheet(AppLocalizations l10n) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime? selectedDueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(l10n.newTask,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration:
                    InputDecoration(labelText: l10n.taskTitle),
                autofocus: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration:
                    InputDecoration(labelText: l10n.taskDescription),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Text(l10n.taskPriority,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: TaskPriority.values.map((p) {
                  final isSelected = selectedPriority == p;
                  final color = _priorityColor(p);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setSheetState(
                            () => selectedPriority = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.12),
                            ),
                          ),
                          child: Text(
                            _priorityLabel(p, l10n),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? color : null,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now()
                        .add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now()
                        .add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setSheetState(() => selectedDueDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .inputDecorationTheme
                        .fillColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Text(
                        selectedDueDate == null
                            ? l10n.taskDueDate
                            : '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year}',
                        style: TextStyle(
                          color: selectedDueDate == null
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5)
                              : null,
                        ),
                      ),
                      const Spacer(),
                      if (selectedDueDate != null)
                        GestureDetector(
                          onTap: () => setSheetState(
                              () => selectedDueDate = null),
                          child: Icon(Icons.close,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) return;
                  await ref
                      .read(taskNotifierProvider.notifier)
                      .addTask(
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        priority: selectedPriority,
                        dueDate: selectedDueDate,
                      );
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(l10n.addTask),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditTaskSheet(AppLocalizations l10n, TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    final descController =
        TextEditingController(text: task.description);
    TaskPriority selectedPriority = task.priority;
    DateTime? selectedDueDate = task.dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(l10n.editTask,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration:
                    InputDecoration(labelText: l10n.taskTitle),
                autofocus: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                decoration:
                    InputDecoration(labelText: l10n.taskDescription),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Text(l10n.taskPriority,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: TaskPriority.values.map((p) {
                  final isSelected = selectedPriority == p;
                  final color = _priorityColor(p);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setSheetState(
                            () => selectedPriority = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.12),
                            ),
                          ),
                          child: Text(
                            _priorityLabel(p, l10n),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? color : null,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDueDate ??
                        DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now()
                        .subtract(const Duration(days: 365)),
                    lastDate: DateTime.now()
                        .add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setSheetState(() => selectedDueDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .inputDecorationTheme
                        .fillColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 18,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Text(
                        selectedDueDate == null
                            ? l10n.taskDueDate
                            : '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year}',
                        style: TextStyle(
                          color: selectedDueDate == null
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5)
                              : null,
                        ),
                      ),
                      const Spacer(),
                      if (selectedDueDate != null)
                        GestureDetector(
                          onTap: () => setSheetState(
                              () => selectedDueDate = null),
                          child: Icon(Icons.close,
                              size: 18,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.4)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) return;
                  await ref
                      .read(taskNotifierProvider.notifier)
                      .updateTask(task.copyWith(
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        priority: selectedPriority,
                        dueDate: selectedDueDate,
                      ));
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusPicker(TaskModel task, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(l10n.updateStatus,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...TaskStatus.values.map((status) {
              final isSelected = task.status == status;
              final color = _statusColor(status);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.4)
                        : scheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),
                child: ListTile(
                  leading: Icon(_statusIcon(status),
                      color: color, size: 22),
                  title: Text(
                    _statusLabel(status, l10n),
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? color : null,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded,
                          color: color, size: 20)
                      : null,
                  onTap: () async {
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .updateStatus(task.id, status);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _dueDateLabel(DateTime? dueDate, AppLocalizations l10n) {
    if (dueDate == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;
    if (diff < 0) return l10n.overdue;
    if (diff == 0) return l10n.today;
    if (diff == 1) return l10n.tomorrow;
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(badgeProvider);
    ref.watch(widgetProvider);
    final filteredTasks = ref.watch(filteredTaskListProvider);
    final taskListAsync = ref.watch(taskListProvider);
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final statusFilter = ref.watch(statusFilterProvider);
    final priorityFilter = ref.watch(priorityFilterProvider);
    final hasFilter = statusFilter != null || priorityFilter != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _isSearching
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: scheme.onSurface
                                  .withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search_rounded,
                                    size: 18,
                                    color: scheme.onSurface
                                        .withValues(alpha: 0.4)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: l10n.searchHint,
                                      border: InputBorder.none,
                                      filled: false,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        color: scheme.onSurface
                                            .withValues(alpha: 0.4),
                                        fontSize: 15,
                                      ),
                                    ),
                                    onChanged: (val) {
                                      ref
                                          .read(searchQueryProvider
                                              .notifier)
                                          .state = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() => _isSearching = false);
                            _searchController.clear();
                            ref
                                .read(searchQueryProvider.notifier)
                                .state = '';
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: scheme.onSurface
                                  .withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'İptal',
                              style: TextStyle(
                                color: Color(0xFFE8443A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DashboardPage()),
                          ),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: scheme.onSurface
                                  .withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.bar_chart_rounded,
                                size: 20,
                                color: scheme.onSurface
                                    .withValues(alpha: 0.7)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              l10n.appName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsPage()),
                          ),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: scheme.onSurface
                                  .withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.settings_rounded,
                                size: 20,
                                color: scheme.onSurface
                                    .withValues(alpha: 0.7)),
                          ),
                        ),
                      ],
                    ),
            ),
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _isSearching = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: scheme.onSurface
                                .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search_rounded,
                                  size: 18,
                                  color: scheme.onSurface
                                      .withValues(alpha: 0.4)),
                              const SizedBox(width: 8),
                              Text(
                                l10n.searchHint,
                                style: TextStyle(
                                  color: scheme.onSurface
                                      .withValues(alpha: 0.4),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showFilterSheet(context, l10n),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: hasFilter
                              ? const Color(0xFFE8443A)
                                  .withValues(alpha: 0.12)
                              : scheme.onSurface.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: hasFilter
                              ? Border.all(
                                  color: const Color(0xFFE8443A)
                                      .withValues(alpha: 0.3))
                              : null,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 20,
                          color: hasFilter
                              ? const Color(0xFFE8443A)
                              : scheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: taskListAsync.when(
                data: (_) {
                  if (filteredTasks.isEmpty) {
                    return FadeIn(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task_alt_rounded,
                                size: 72,
                                color: scheme.onSurface
                                    .withValues(alpha: 0.15)),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noTasks,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.noTasksSubtitle,
                              style: TextStyle(
                                color: scheme.onSurface
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final todo = filteredTasks
                      .where((t) => t.status == TaskStatus.todo)
                      .toList();
                  final inProgress = filteredTasks
                      .where(
                          (t) => t.status == TaskStatus.inProgress)
                      .toList();
                  final done = filteredTasks
                      .where((t) => t.status == TaskStatus.done)
                      .toList();

                  return ListView(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    children: [
                      if (todo.isNotEmpty) ...[
                        _SectionHeader(
                          label: l10n.statusTodo,
                          count: todo.length,
                          color: const Color(0xFF8896B0),
                        ),
                        ...todo.asMap().entries.map((e) => FadeInUp(
                              delay: Duration(
                                  milliseconds: e.key * 50),
                              child: _TaskCard(
                                task: e.value,
                                onStatusTap: () => _showStatusPicker(
                                    e.value, l10n),
                                onDelete: () => ref
                                    .read(
                                        taskNotifierProvider.notifier)
                                    .deleteTask(e.value.id),
                                onEdit: () => _showEditTaskSheet(
                                    l10n, e.value),
                                onComplete: () => ref
                                    .read(
                                        taskNotifierProvider.notifier)
                                    .updateStatus(
                                        e.value.id, TaskStatus.done),
                                dueDateLabel: _dueDateLabel(
                                    e.value.dueDate, l10n),
                                statusColor:
                                    _statusColor(e.value.status),
                                statusLabel: _statusLabel(
                                    e.value.status, l10n),
                                priorityColor:
                                    _priorityColor(e.value.priority),
                                priorityLabel: _priorityLabel(
                                    e.value.priority, l10n),
                                deleteConfirmTitle:
                                    l10n.deleteTaskConfirm,
                                deleteConfirmMessage:
                                    l10n.deleteTaskMessage,
                                cancelLabel: l10n.cancel,
                                deleteLabel: l10n.delete,
                              ),
                            )),
                      ],
                      if (inProgress.isNotEmpty) ...[
                        _SectionHeader(
                          label: l10n.statusInProgress,
                          count: inProgress.length,
                          color: const Color(0xFFF59E0B),
                        ),
                        ...inProgress.asMap().entries.map((e) =>
                            FadeInUp(
                              delay: Duration(
                                  milliseconds: e.key * 50),
                              child: _TaskCard(
                                task: e.value,
                                onStatusTap: () => _showStatusPicker(
                                    e.value, l10n),
                                onDelete: () => ref
                                    .read(
                                        taskNotifierProvider.notifier)
                                    .deleteTask(e.value.id),
                                onEdit: () => _showEditTaskSheet(
                                    l10n, e.value),
                                onComplete: () => ref
                                    .read(
                                        taskNotifierProvider.notifier)
                                    .updateStatus(
                                        e.value.id, TaskStatus.done),
                                dueDateLabel: _dueDateLabel(
                                    e.value.dueDate, l10n),
                                statusColor:
                                    _statusColor(e.value.status),
                                statusLabel: _statusLabel(
                                    e.value.status, l10n),
                                priorityColor:
                                    _priorityColor(e.value.priority),
                                priorityLabel: _priorityLabel(
                                    e.value.priority, l10n),
                                deleteConfirmTitle:
                                    l10n.deleteTaskConfirm,
                                deleteConfirmMessage:
                                    l10n.deleteTaskMessage,
                                cancelLabel: l10n.cancel,
                                deleteLabel: l10n.delete,
                              ),
                            )),
                      ],
                      if (done.isNotEmpty) ...[
                        _SectionHeader(
                          label: l10n.statusDone,
                          count: done.length,
                          color: const Color(0xFF10B981),
                        ),
                        ...done.asMap().entries.map((e) => FadeInUp(
                              delay: Duration(
                                  milliseconds: e.key * 50),
                              child: _TaskCard(
                                task: e.value,
                                onStatusTap: () => _showStatusPicker(
                                    e.value, l10n),
                                onDelete: () => ref
                                    .read(
                                        taskNotifierProvider.notifier)
                                    .deleteTask(e.value.id),
                                onEdit: () => _showEditTaskSheet(
                                    l10n, e.value),
                                onComplete: () => ref
                                    .read(
                                        taskNotifierProvider.notifier)
                                    .updateStatus(
                                        e.value.id, TaskStatus.done),
                                dueDateLabel: _dueDateLabel(
                                    e.value.dueDate, l10n),
                                statusColor:
                                    _statusColor(e.value.status),
                                statusLabel: _statusLabel(
                                    e.value.status, l10n),
                                priorityColor:
                                    _priorityColor(e.value.priority),
                                priorityLabel: _priorityLabel(
                                    e.value.priority, l10n),
                                deleteConfirmTitle:
                                    l10n.deleteTaskConfirm,
                                deleteConfirmMessage:
                                    l10n.deleteTaskMessage,
                                cancelLabel: l10n.cancel,
                                deleteLabel: l10n.delete,
                              ),
                            )),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskSheet(l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.newTask),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onStatusTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onComplete;
  final String dueDateLabel;
  final Color statusColor;
  final String statusLabel;
  final Color priorityColor;
  final String priorityLabel;
  final String deleteConfirmTitle;
  final String deleteConfirmMessage;
  final String cancelLabel;
  final String deleteLabel;

  const _TaskCard({
    required this.task,
    required this.onStatusTap,
    required this.onDelete,
    required this.onEdit,
    required this.onComplete,
    required this.dueDateLabel,
    required this.statusColor,
    required this.statusLabel,
    required this.priorityColor,
    required this.priorityLabel,
    required this.deleteConfirmTitle,
    required this.deleteConfirmMessage,
    required this.cancelLabel,
    required this.deleteLabel,
  });

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;
  bool _showCheck = false;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  void _handleComplete() async {
    setState(() => _showCheck = true);
    _checkController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    widget.onComplete();
    if (mounted) {
      setState(() => _showCheck = false);
      _checkController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDone = widget.task.status == TaskStatus.done;
    final isOverdue = widget.task.isOverdue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        key: ValueKey(widget.task.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => widget.onEdit(),
              backgroundColor: const Color(0xFF4F8EF7),
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              borderRadius: BorderRadius.circular(14),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          dismissible: DismissiblePane(onDismissed: widget.onDelete),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onDelete(),
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              borderRadius: BorderRadius.circular(14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: InkWell(
                onTap: widget.onStatusTap,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: isDone ? null : _handleComplete,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10),
                              child: isDone
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF10B981),
                                      size: 22,
                                    )
                                  : AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 200),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: widget.statusColor
                                              .withValues(alpha: 0.5),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isDone
                                    ? scheme.onSurface
                                        .withValues(alpha: 0.4)
                                    : null,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onStatusTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.statusColor
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.statusColor
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                widget.statusLabel,
                                style: TextStyle(
                                  color: widget.statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.task.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Text(
                            widget.task.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: widget.priorityColor
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.priorityLabel,
                                style: TextStyle(
                                  color: widget.priorityColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (widget.dueDateLabel.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.schedule_rounded,
                                size: 13,
                                color: isOverdue
                                    ? const Color(0xFFEF4444)
                                    : scheme.onSurface
                                        .withValues(alpha: 0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.dueDateLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isOverdue
                                      ? const Color(0xFFEF4444)
                                      : scheme.onSurface
                                          .withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showCheck)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: ScaleTransition(
                      scale: _checkAnimation,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}