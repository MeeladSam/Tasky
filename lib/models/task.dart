class Task {
  final String id;
  String title;
  String description;
  bool isHighPriority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isHighPriority = false,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'isHighPriority': isHighPriority,
        'isCompleted': isCompleted,
      };

  factory Task.fromMap(Map<String, dynamic> m) => Task(
        id: m['id'] as String,
        title: m['title'] as String,
        description: (m['description'] ?? '') as String,
        isHighPriority: (m['isHighPriority'] ?? false) as bool,
        isCompleted: (m['isCompleted'] ?? false) as bool,
      );
}
