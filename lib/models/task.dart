/// Task model class representing an assignment or task.
/// Contains task details including title, course code, due date,
/// and completion status.
class Task {
  // Title/name of the task/assignment
  final String title;
  
  // Course code associated with the task (e.g., CSC301)
  final String courseCode;
  
  // Due date for the task
  final DateTime dueDate;
  
  // Completion status - true if task is completed, false otherwise
  // Defaults to false (incomplete)
  bool isComplete;

  /// Constructor with required parameters for creating a Task instance.
  /// 
  /// [title] - The title/name of the task
  /// [courseCode] - The course code (e.g., CSC301)
  /// [dueDate] - The due date for the task
  /// [isComplete] - Completion status (optional, defaults to false)
  Task({
    required this.title,
    required this.courseCode,
    required this.dueDate,
    this.isComplete = false, // Default value: false
  });

  /// Marks the task as complete.
  void markComplete() {
    isComplete = true;
  }

  /// Marks the task as incomplete.
  void markIncomplete() {
    isComplete = false;
  }

  /// Returns a string representation of the Task object.
  @override
  String toString() {
    return 'Task(title: $title, courseCode: $courseCode, dueDate: $dueDate, isComplete: $isComplete)';
  }
}
