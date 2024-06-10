import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'med_selecao.dart';
import 'erro.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Task {
  final String id;
  final String description;

  Task({required this.id, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      description: json['description'] ?? '', // Certifique-se de que o campo esteja correto
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
    print('${dotenv.env['API_URL']}');
    final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/pyxis/${widget.qrCode}'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        setState(() {
          _rawJson = utf8.decode(response.bodyBytes); // Decodifica a resposta como UTF-8
          final Map<String, dynamic> data = json.decode(_rawJson);
          _tasks = [Task.fromJson(data)];
          _isLoading = false;
        });
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ErrorPage(message: 'Pyxis não encontrado - Código inválido'),
        ));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ErrorPage(message: 'QR Code inválido - Tente novamente'),
      ));
    }
  }

  void _onNextPressed() {
    final Map<String, dynamic> jsonToSend = {
      'idPyxis': widget.qrCode,
      'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : 'Sem descrição',
    };
    print(jsonToSend);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedSelecaoPage(data: jsonToSend),
      ),
    );
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pyxis',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _tasks.isNotEmpty ? _tasks[0].description : 'Sem descrição',
                          style: const TextStyle(fontSize: 18),
                        ),
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
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onNextPressed,
                                child: const Text('Próximo'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
