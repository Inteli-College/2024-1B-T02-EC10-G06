import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MedSelecaoPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const MedSelecaoPage({Key? key, required this.data}) : super(key: key);

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
    final idPyxis = widget.data['idPyxis'];
    final response = await http.get(Uri.parse('http://172.17.0.1:5001/pyxis/$idPyxis'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _medicines = List<Map<String, dynamic>>.from(data['medicines']);
        _medicines.sort((a, b) => a['name'].compareTo(b['name']));
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
        .map((entry) => _medicines.firstWhere((med) => med['id'] == entry.key)['name'])
        .toList();

    final updatedData = {
      ...widget.data,
      'body': selectedMedicines,
    };

    print(updatedData);
    final response = await http.post(Uri.parse('http://172.17.0.1:5001/tickets/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 201) {
      // Successfully created the ticket
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket criado com sucesso!')),
      );
    } else {
      // Failed to create the ticket
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao criar o ticket')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleção de Medicamentos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(
                        'Selecione os Medicamentos:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      ..._medicines.map((medicine) {
                        return CheckboxListTile(
                          title: Text(medicine['name']),
                          subtitle: Text(medicine['descrition']),
                          value: _selectedMedicines[medicine['id']],
                          onChanged: (bool? value) {
                            _onMedicineSelected(medicine['id'], value);
                          },
                        );
                      }).toList(),
                      SizedBox(height: 60), // Padding to prevent overlap with the button
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: _onConfirmSelection,
                    child: Text('Confirmar Seleção'),
                  ),
                ),
              ],
            ),
    );
  }
}