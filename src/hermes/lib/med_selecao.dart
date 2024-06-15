import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sucesso.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MedSelecaoPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const MedSelecaoPage({super.key, required this.data});

  @override
  _MedSelecaoPageState createState() => _MedSelecaoPageState();
}

class _MedSelecaoPageState extends State<MedSelecaoPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _medicines = [];
  Map<String, bool> _selectedMedicines = {};

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    print('${dotenv.env['API_URL']}');
    final idPyxis = widget.data['idPyxis'];
    final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/pyxis/$idPyxis'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _medicines = List<Map<String, dynamic>>.from(data['medicines'])
            .where((medicine) => medicine.containsKey('id') && medicine.containsKey('name'))
            .toList();
        _medicines.sort((a, b) {
          final nameA = a['name'] ?? '';
          final nameB = b['name'] ?? '';
          return nameA.compareTo(nameB);
        });
        _selectedMedicines = {for (var med in _medicines) med['id']: false};
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load medicines');
    }
  }

  void _onMedicineSelected(String id, bool? selected) {
    setState(() {
      _selectedMedicines[id] = selected ?? false;
    });
  }

  Future<void> _onConfirmSelection() async {
    final selectedMedicines = _selectedMedicines.entries
        .where((entry) => entry.value)
        .map((entry) => _medicines.firstWhere((med) => med['id'] == entry.key))
        .toList();

    final ticketData = {
      'idPyxis': widget.data['idPyxis'],
      'owner_id': '3', // Definido fixo conforme solicitado
      'description': widget.data['description'],
      'body': selectedMedicines,
    };

    // Converte o mapa para uma string JSON formatada com indentação
    String jsonString = const JsonEncoder.withIndent('  ').convert(ticketData);

    // Imprime a string JSON no terminal
    print(jsonString);

    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/api/tickets/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ticketData),
    );

    if (response.statusCode == 200) {
      // Sucesso ao criar o ticket
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket criado com sucesso!')),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SucessoPage(),
      ));
    } else {
      // Falha ao criar o ticket
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao criar o ticket')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Medicamentos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      const Text(
                        'Selecione os Medicamentos:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ..._medicines.map((medicine) {
                        return CheckboxListTile(
                          title: Text(medicine['name']),
                          subtitle: Text(medicine['description']),
                          value: _selectedMedicines[medicine['id']],
                          onChanged: (bool? value) {
                            _onMedicineSelected(medicine['id'], value);
                          },
                        );
                      }),
                      const SizedBox(height: 60), // Padding to prevent overlap with the button
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: _onConfirmSelection,
                    child: const Text('Confirmar Seleção'),
                  ),
                ),
              ],
            ),
    );
  }
}
