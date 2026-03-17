import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

/// TaskListScreen displays a list of tasks for the student.
/// Shows task title, course code, due date, and completion checkbox.
/// Uses a hardcoded list of at least 3 tasks.
/// Implements state management and data persistence with SharedPreferences.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List to store tasks
  List<Task> _tasks = [];
  
  // Key for SharedPreferences storage
  static const String _tasksKey = 'tasks_list';

  @override
  void initState() {
    super.initState();
    // Load tasks when the screen initializes
    _loadTasks();
  }

  /// Load tasks from SharedPreferences
  /// If no saved data exists, use the hardcoded list
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_tasksKey);

    if (tasksJson != null) {
      // Load saved tasks
      final List<dynamic> decoded = json.decode(tasksJson);
      setState(() {
        _tasks = decoded.map((item) => Task(
          title: item['title'],
          courseCode: item['courseCode'],
          dueDate: DateTime.parse(item['dueDate']),
          isComplete: item['isComplete'],
        )).toList();
      });
    } else {
      // Use hardcoded list if no saved data
      setState(() {
        _tasks = [
          Task(
            title: 'Mobile Development Project',
            courseCode: 'CSC301',
            dueDate: DateTime(2026, 4, 15),
            isComplete: false,
          ),
          Task(
            title: 'Database Assignment',
            courseCode: 'CSC205',
            dueDate: DateTime(2026, 3, 25),
            isComplete: true,
          ),
          Task(
            title: 'Algorithm Analysis Quiz',
            courseCode: 'CSC201',
            dueDate: DateTime(2026, 3, 30),
            isComplete: false,
          ),
          Task(
            title: 'Web Development Portfolio',
            courseCode: 'CSC302',
            dueDate: DateTime(2026, 5, 1),
            isComplete: false,
          ),
        ];
      });
      // Save the hardcoded list
      _saveTasks();
    }
  }

  /// Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_tasks.map((task) => {
      'title': task.title,
      'courseCode': task.courseCode,
      'dueDate': task.dueDate.toIso8601String(),
      'isComplete': task.isComplete,
    }).toList());
    await prefs.setString(_tasksKey, encoded);
  }

  /// Format date as dd/mm/yyyy
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Show dialog to add a new task
  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final courseCodeController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'Enter task title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: courseCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Course Code',
                      hintText: 'e.g., CSC301',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Due Date: '),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Text(_formatDate(selectedDate)),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty && 
                        courseCodeController.text.isNotEmpty) {
                      // Add new task to the list
                      setState(() {
                        _tasks.add(Task(
                          title: titleController.text,
                          courseCode: courseCodeController.text,
                          dueDate: selectedDate,
                          isComplete: false,
                        ));
                      });
                      // Save to SharedPreferences
                      _saveTasks();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.green,
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isComplete ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Course: ${task.courseCode}'),
                        Text('Due Date: ${_formatDate(task.dueDate)}'),
                      ],
                    ),
                    trailing: Checkbox(
                      value: task.isComplete,
                      onChanged: (bool? value) {
                        // Toggle completion status and update UI
                        setState(() {
                          task.isComplete = value ?? false;
                        });
                        // Save to SharedPreferences when toggled
                        _saveTasks();
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                );
              },
            ),
      // FloatingActionButton to add new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
