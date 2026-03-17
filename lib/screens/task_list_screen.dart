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
              title: Row(
                children: [
                  Icon(Icons.add_task, color: Colors.teal[700]),
                  const SizedBox(width: 8),
                  const Text('Add New Task'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'Enter task title',
                        prefixIcon: Icon(Icons.title, color: Colors.teal[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: courseCodeController,
                      decoration: InputDecoration(
                        labelText: 'Course Code',
                        hintText: 'e.g., CSC301',
                        prefixIcon: Icon(Icons.book, color: Colors.teal[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.teal[700]),
                          const SizedBox(width: 12),
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
                            child: Text(
                              _formatDate(selectedDate),
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add one!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  elevation: 2,
                  shadowColor: Colors.teal.withOpacity(0.2),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: task.isComplete
                          ? LinearGradient(
                              colors: [Colors.grey[200]!, Colors.grey[100]!],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: task.isComplete
                              ? Colors.grey[300]
                              : Colors.teal[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.assignment,
                          color: task.isComplete ? Colors.grey : Colors.teal[700],
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: task.isComplete
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isComplete ? Colors.grey : Colors.grey[800],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.courseCode,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(task.dueDate),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
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
                        activeColor: Colors.teal[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      // FloatingActionButton to add new tasks
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
