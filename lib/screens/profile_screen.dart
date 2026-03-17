import 'package:flutter/material.dart';
import '../models/student.dart';
import 'task_list_screen.dart';

/// ProfileScreen displays the student's profile information.
/// Shows student name, ID, programme, and level in a card layout.
/// Provides navigation to the task list screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a sample student for demonstration
    final student = Student(
      name: 'John Doe',
      studentId: 'STU12345',
      programme: 'Computer Science',
      level: 300,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CircleAvatar with student's initial
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Card widget displaying student details
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow('Name', student.name),
                      const Divider(),
                      _buildInfoRow('Student ID', student.studentId),
                      const Divider(),
                      _buildInfoRow('Programme', student.programme),
                      const Divider(),
                      _buildInfoRow('Level', 'Level ${student.level}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Edit Profile button
              ElevatedButton(
                onPressed: () {
                  // Edit functionality not required - button only
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Profile clicked')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              
              // View Tasks button (navigation to TaskListScreen)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskListScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'View Tasks',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
