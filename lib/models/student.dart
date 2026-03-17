/// Student model class representing a student profile.
/// Contains basic student information including name, student ID,
/// programme of study, and academic level.
class Student {
  // Student's full name
  final String name;
  
  // Unique student identifier
  final String studentId;
  
  // Programme of study (e.g., Computer Science, Business)
  final String programme;
  
  // Academic level (e.g., 100, 200, 300, 400)
  final int level;

  /// Constructor with required parameters for creating a Student instance.
  /// 
  /// [name] - The student's full name
  /// [studentId] - The unique student identification number
  /// [programme] - The programme/course of study
  /// [level] - The academic level (e.g., 300 for third year)
  Student({
    required this.name,
    required this.studentId,
    required this.programme,
    required this.level,
  });

  /// Returns a string representation of the Student object.
  @override
  String toString() {
    return 'Student(name: $name, studentId: $studentId, programme: $programme, level: $level)';
  }
}
