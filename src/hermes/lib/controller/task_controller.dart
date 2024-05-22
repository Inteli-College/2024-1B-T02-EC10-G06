import 'package:hermes/model/task_model.dart';

class TasksController {
  final TasksModel _model = TasksModel();

  int get counter => _model.counter;

  void incrementCounter() {
    
    _model.incrementCounter();
  }

Future<void> updateTask(String userId, String title, String description) async{
    return await _model.updateTask(userId, title, description);
  }

  Future<void> deleteTask(String userId) async{
    return await _model.deleteTask(userId);
  }

  Future<User> getUsers(String userId) async{
    return  await _model.fetchUser(userId);
  }
}