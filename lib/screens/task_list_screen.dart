import 'package:flutter/material.dart';
import '../models/task.dart';

/// TaskListScreen displays a list of tasks for the student.
/// Shows task title, course code, due date, and completion checkbox.
/// Uses a hardcoded list of at least 3 tasks.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Hardcoded list of tasks
  final List<Task> _tasks = [
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

  /// Format date as dd/mm/yyyy
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
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
                  setState(() {
                    task.isComplete = value ?? false;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
