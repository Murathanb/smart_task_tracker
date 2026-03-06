// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TaskFlow';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get or => 'or';

  @override
  String get tasks => 'Tasks';

  @override
  String get newTask => 'New Task';

  @override
  String get taskTitle => 'Title';

  @override
  String get taskDescription => 'Description (optional)';

  @override
  String get taskDueDate => 'Due date (optional)';

  @override
  String get taskPriority => 'Priority';

  @override
  String get add => 'Add';

  @override
  String get addTask => 'Add Task';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTaskConfirm => 'Delete Task';

  @override
  String get deleteTaskMessage => 'Are you sure you want to delete this task?';

  @override
  String get noTasks => 'No tasks yet 🎯';

  @override
  String get noTasksSubtitle => 'Tap + to add your first task';

  @override
  String get statusTodo => 'To Do';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusDone => 'Done';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get signOutTitle => 'Sign Out';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get languageEn => 'English';

  @override
  String get languageTr => 'Turkish';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDesc => 'Get reminders at task due times';

  @override
  String get due => 'Due';

  @override
  String get overdue => 'Overdue';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get noDueDate => 'No date';

  @override
  String get taskDone => 'Task completed!';

  @override
  String get greeting => 'Welcome Back 👋';

  @override
  String get createAccount => 'Create Account';

  @override
  String get passwordsNoMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get taskReminders => 'Task reminders';

  @override
  String get taskRemindersDesc =>
      'Get notified when a task due date is approaching';

  @override
  String get version => 'Smart Task Tracker v1.0.0';

  @override
  String get filter => 'Filter';

  @override
  String get filterClear => 'Clear';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterPriority => 'Priority';

  @override
  String get editTask => 'Edit Task';

  @override
  String get save => 'Save';

  @override
  String get searchHint => 'Search tasks...';

  @override
  String get statistics => 'Statistics';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String tasksCount(int done, int total) {
    return '$done / $total tasks';
  }

  @override
  String get completed => 'completed';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get statTodo => 'To Do';

  @override
  String get statInProgress => 'In Progress';

  @override
  String get statDone => 'Completed';

  @override
  String get statOverdue => 'Overdue';

  @override
  String get statusDistribution => 'Status Distribution';

  @override
  String get priorityDistribution => 'Priority Distribution';

  @override
  String get priorityLowShort => 'Low';

  @override
  String get priorityMediumShort => 'Medium';

  @override
  String get priorityHighShort => 'High';
}
