import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart'; // Import the themes file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: lightTheme, // Default theme
      home: TaskListScreen(),
    );
  }
}

class Task {
  String title;
  DateTime dueDate;
  bool isCompleted;
  String priority;
  List<String> tags;
  DateTime? reminderDateTime; // New field for reminder

  Task({
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = 'medium',
    this.tags = const [],
    this.reminderDateTime,
  });
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  List<Task> tasks = [];
  List<Task> allTasks = []; // Store a copy of the original list
  ThemeData _currentTheme = lightTheme; // Default theme
  String _tagFilter = ''; // Variable to store the tag filter
  ThemeData _currentFontTheme = robotoTheme;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadTheme();
    _loadFontTheme();
  }

  void _initializeNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _applyTheme(ThemeData theme) async {
    setState(() {
      _currentTheme = theme;
    });
    final prefs = await SharedPreferences.getInstance();
    if (theme == lightTheme) {
      prefs.setString('theme', 'light');
    } else if (theme == darkTheme) {
      prefs.setString('theme', 'dark');
    } else if (theme == customTheme) {
      prefs.setString('theme', 'custom');
    }
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';
    if (theme == 'dark') {
      _applyTheme(darkTheme);
    } else if (theme == 'custom') {
      _applyTheme(customTheme);
    } else {
      _applyTheme(lightTheme);
    }
  }

  void _applyFontTheme(ThemeData fontTheme) async {
    setState(() {
      _currentFontTheme = fontTheme;
    });
    final prefs = await SharedPreferences.getInstance();
    if (fontTheme == robotoTheme) {
      prefs.setString('font', 'roboto');
    } else if (fontTheme == latoTheme) {
      prefs.setString('font', 'lato');
    } else if (fontTheme == openSansTheme) {
      prefs.setString('font', 'opensans');
    }
  }

  Future<void> _loadFontTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final font = prefs.getString('font') ?? 'roboto';
    if (font == 'lato') {
      _applyFontTheme(latoTheme);
    } else if (font == 'opensans') {
      _applyFontTheme(openSansTheme);
    } else {
      _applyFontTheme(robotoTheme);
    }
  }

  void _showThemeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Light Theme'),
              onTap: () {
                _applyTheme(lightTheme);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Dark Theme'),
              onTap: () {
                _applyTheme(darkTheme);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Custom Theme'),
              onTap: () {
                _applyTheme(customTheme);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Font'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Roboto'),
              onTap: () {
                _applyFontTheme(robotoTheme);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Lato'),
              onTap: () {
                _applyFontTheme(latoTheme);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Open Sans'),
              onTap: () {
                _applyFontTheme(openSansTheme);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTask(String title, DateTime dueDate, String priority, List<String> tags, DateTime? reminderDateTime) {
    final newTask = Task(
      title: title,
      dueDate: dueDate,
      priority: priority,
      tags: tags,
      reminderDateTime: reminderDateTime,
    );
    setState(() {
      tasks.add(newTask);
      allTasks.add(newTask); // Add to the original list as well
      _scheduleNotification(newTask);
    });
  }

  void _scheduleNotification(Task task) {
    if (task.reminderDateTime != null) {
      final tz.TZDateTime tzReminderDateTime = tz.TZDateTime.from(task.reminderDateTime!, tz.local);

      const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder',
        'Reminder for task: ${task.title}',
        tzReminderDateTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    final tz.TZDateTime tzDueDate = tz.TZDateTime.from(task.dueDate, tz.local);

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Task Due',
      task.title,
      tzDueDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _filterByPriority(String priority) {
    setState(() {
      tasks = allTasks.where((task) => task.priority == priority).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      tasks = List.from(allTasks);
    });
  }

  void _showTagFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter by Tag'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter Tag'),
              onChanged: (value) {
                _tagFilter = value;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tasks = allTasks.where((task) => task.tags.contains(_tagFilter)).toList();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Filter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tagFilter = ''; // Clear the tag filter
                      tasks = List.from(allTasks); // Show all tasks
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Clear Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Optional: Set a different color for the Clear Filter button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteTaskDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                allTasks.removeAt(index);
                tasks.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: AddTaskDialog(onAddTask: _addTask),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme.copyWith(
        textTheme: _currentFontTheme.textTheme,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List'),
          actions: [
            PopupMenuButton<String>(
              onSelected: _sortTasks,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'DueDateAscending',
                  child: Text('Sort by Due Date (Ascending)'),
                ),
                PopupMenuItem(
                  value: 'DueDateDescending',
                  child: Text('Sort by Due Date (Descending)'),
                ),
                PopupMenuItem(
                  value: 'Priority',
                  child: Text('Sort by Priority'),
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'All') {
                  _clearFilters();
                } else {
                  _filterByPriority(value);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'All',
                  child: Text('Show All'),
                ),
                PopupMenuItem(
                  value: 'low',
                  child: Text('Filter by Low Priority'),
                ),
                PopupMenuItem(
                  value: 'medium',
                  child: Text('Filter by Medium Priority'),
                ),
                PopupMenuItem(
                  value: 'high',
                  child: Text('Filter by High Priority'),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.tag),
              onPressed: _showTagFilterDialog,
            ),
            IconButton(
              icon: Icon(Icons.font_download),
              onPressed: _showFontSelectionDialog,
            ),
            IconButton(
              icon: Icon(Icons.palette),
              onPressed: _showThemeSelectionDialog,
            ),
          ],
        ),
        body: tasks.isEmpty
            ? Center(child: Text('No tasks added yet'))
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text('Due: ${DateFormat.yMMMd().format(task.dueDate)} | Priority: ${task.priority.capitalize()} | Tags: ${task.tags.join(', ')}'),
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    task.isCompleted = value ?? false;
                  });
                },
              ),
              onLongPress: () => _showDeleteTaskDialog(index),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _sortTasks(String sortOption) {
    setState(() {
      if (sortOption == 'DueDateAscending') {
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      } else if (sortOption == 'DueDateDescending') {
        tasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      } else if (sortOption == 'Priority') {
        const priorityOrder = {'low': 1, 'medium': 2, 'high': 3};
        tasks.sort((a, b) => priorityOrder[b.priority]!.compareTo(priorityOrder[a.priority]!));
      }
    });
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(String, DateTime, String, List<String>, DateTime?) onAddTask;

  AddTaskDialog({required this.onAddTask});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _priority = 'medium';
  final _tagsController = TextEditingController();
  DateTime? _reminderDateTime; // New field for reminder time

  void _submit() {
    final title = _titleController.text;
    final tags = _tagsController.text.split(',').map((e) => e.trim()).toList();
    widget.onAddTask(title, _dueDate, _priority, tags, _reminderDateTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Task Title'),
        ),
        TextField(
          controller: _tagsController,
          decoration: InputDecoration(labelText: 'Tags (comma separated)'),
        ),
        DropdownButton<String>(
          value: _priority,
          onChanged: (String? newValue) {
            setState(() {
              _priority = newValue!;
            });
          },
          items: <String>['low', 'medium', 'high']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.capitalize()),
            );
          }).toList(),
        ),
        // Add reminder time picker
        TextButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _reminderDateTime ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_reminderDateTime ?? DateTime.now()),
              );
              if (pickedTime != null) {
                setState(() {
                  _reminderDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                });
              }
            }
          },
          child: Text(_reminderDateTime == null ? 'Set Reminder' : 'Reminder: ${DateFormat.yMMMd().format(_reminderDateTime!)} ${DateFormat.jm().format(_reminderDateTime!)}'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Add Task'),
        ),
      ],
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
