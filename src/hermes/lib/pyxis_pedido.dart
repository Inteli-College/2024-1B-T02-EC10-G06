import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Task {
  final String id;
  final String description;

  Task({required this.id, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
    );
  }
}

class PyxisPedidoPage extends StatefulWidget {
  final String qrCode;

  const PyxisPedidoPage({super.key, required this.qrCode});

  @override
  _PyxisPedidoPageState createState() => _PyxisPedidoPageState();
}

class _PyxisPedidoPageState extends State<PyxisPedidoPage> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _rawJson = '';

  @override
  void initState() {
    super.initState();
    _consultarPyxis();
  }

  Future<void> _consultarPyxis() async {
    final response = await http.get(Uri.parse('http://172.17.0.1:5001/pyxis/663fb8124ee113672c92646f'));
    if (response.statusCode == 200) {
      setState(() {
        _rawJson = response.body;
        _tasks = (json.decode(response.body) as List)
            .map((data) => Task.fromJson(data))
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pyxis Pedido'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Text(
                    'Código QR: ${widget.qrCode}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_rawJson, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return ListTile(
                          title: Text(task.id),
                          subtitle: Text(task.description),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
