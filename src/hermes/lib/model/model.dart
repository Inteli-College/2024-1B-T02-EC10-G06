import 'dart:convert';
import 'package:http/http.dart' as http;


class Task {
  final int id;
  final String title;
  final String description;
  final bool isActive;

  Task({
    required this.title,
    required this.description,
    required this.id,
    required this.isActive,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}

class User {
  final String email;
  final int id;
  final List<Task> tasks;

  User({
    required this.email,
    required this.id,
    required this.tasks,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Task> tasks = [];
    if (json['tasks'] != null) {
      tasks = List<Task>.from(json['tasks'].map((task) => Task.fromJson(task)));
    }

    return User(
      email: json['email'] ?? '',
      id: json['id'] ?? 0,
      tasks: tasks,
    );
  }
}






class TasksModel {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
  }

  Future<Task> createTask(String title, String description, String userId) async {
    final response = await http.post(
      Uri.parse('http://172.29.96.1:8000/users/$userId/tasks/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description
      }),
    );

    if (response.statusCode == 200) {
      
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Task.');
    }
  }

  Future<void> updateTask(String taskId, String title, String description) async {
    final response = await http.put(
      Uri.parse('http://172.29.96.1:8000/tasks/$taskId'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description
      }),
    );

    if (response.statusCode == 200) {
      
      //return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Task.');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('http://172.29.96.1:8000/tasks/$taskId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      
      //return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Task.');
    }
  }

  Future<User> fetchUser(String userId) async {
  final response = await http.get(Uri.parse('http://172.29.96.1:8000/users/$userId/'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);

    final List<Task> tasks = [];
    if (jsonData['tasks'] != null) {
      tasks.addAll((jsonData['tasks'] as List).map((task) => Task.fromJson(task)));
    }
    return User(
      email: jsonData['email'] ?? '',
      id: jsonData['id'] ?? 0,
      tasks: tasks,
    );
  } else {
    throw Exception('Failed to load user');
  }
}

}









