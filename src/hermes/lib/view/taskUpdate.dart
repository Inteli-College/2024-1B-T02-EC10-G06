// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hermes/controller/task_controller.dart';

class UpdateTaskView extends StatefulWidget {
  const UpdateTaskView({super.key, required this.idTask});
  final String idTask;

  @override
  State<UpdateTaskView> createState() => _UpdateTaskViewState();
}

class _UpdateTaskViewState extends State<UpdateTaskView> {
  final TasksController _controller = TasksController();
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  
Future<void> _updateTaskAndRefreshList(String id) async {
  await _controller.updateTask(id, _controllerTitle.text, _controllerDescription.text);
  _controllerTitle.text = "";
  _controllerDescription.text = "";
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Taks")),
      body: Center(
        child: Column(
          children: [
                const Text('Create Task:'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerTitle,
                    decoration: const InputDecoration(hintText: 'Digite o Titulo'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerDescription,
                    decoration: const InputDecoration(hintText: 'Digite uma descrição'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await _updateTaskAndRefreshList(widget.idTask);
                      Navigator.pop(context, true);
                    },
                    child: const Text('Update'),
                  ),
          ],
        ),
      )
    );
  }
}

