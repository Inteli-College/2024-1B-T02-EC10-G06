import 'package:flutter/material.dart';
import 'package:hermes/controller/task_controller.dart';
import 'package:hermes/model/task_model.dart';
import 'package:hermes/view/taskUpdate.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key, required this.idUser});

  final String idUser;

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final TasksController _controller = TasksController();
  late Future<User> futureUser;

  Future<void> _deleteTask(int id) async {
    await _controller.deleteTask('$id');
    setState(() {
      futureUser = _controller.getUsers(widget.idUser);
    });
  }

  @override
  void initState() {
    super.initState();
    futureUser = _controller.getUsers(widget.idUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(snapshot.data!.email),
                const SizedBox(height: 20),
                const Text('Tasks:'),
                Expanded(
                  child: snapshot.data!.tasks.isEmpty
                      ? const Center(
                          child: Text("Adicione uma nova task"),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.tasks.length,
                          itemBuilder: (context, index) {
                            final task = snapshot.data!.tasks[index];
                            return ListTile(
                              style: ListTileStyle.list,
                              title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, overflow: TextOverflow.fade)),
                              subtitle: Text(task.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _deleteTask(task.id);
                                      },
                                      child: const Icon(Icons.delete),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => UpdateTaskView(idTask: '${task.id}')),
                                        );
                                        if (result != null && result == true) {
                                          setState(() {
                                            futureUser = _controller.getUsers(widget.idUser);
                                          });
                                        }
                                      },
                                      child: const Icon(Icons.edit),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureUser = _controller.getUsers(widget.idUser);
                    });
                  },
                  child: const Text('Reload'),
                ),
              ],
            );
          } else {
            return const Text('No data found');
          }
        },
      ),
    );
  }
}