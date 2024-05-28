import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Task {
  final String id;
  final String description;

  Task({required this.id, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
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

  final List<String> _pedidoTypes = ['Medicamento', 'Utilitário', 'Ambos'];
  String? _selectedPedidoType;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _consultarPyxis();
  }

  Future<void> _consultarPyxis() async {
    final response = await http.get(Uri.parse('http://3.213.45.125:5001/pyxis/${widget.qrCode}'));
    if (response.statusCode == 200) {
      setState(() {
        _rawJson = response.body;
        final Map<String, dynamic> data = json.decode(response.body);
        _tasks = [Task.fromJson(data)];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load task');
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
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pyxis ID:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.qrCode,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Resposta:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(_rawJson, style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    const Text(
                      'Tipo de Pedido:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedPedidoType,
                      hint: const Text('Selecione o tipo de pedido'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPedidoType = newValue;
                        });
                      },
                      items: _pedidoTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Descrição:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite a descrição do pedido',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Ação do botão "Próximo"
                          },
                          child: const Text('Próximo'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
