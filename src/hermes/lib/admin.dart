import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:hermes/models.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Ticket> _tickets = [];
  List<Pyxi> _pyxis = [];
  String? _clickedTicketId;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
    _fetchPyxis();
  }

  Future<void> _fetchTickets() async {
    final response = await http.get(Uri.parse('https://api.hermes.com/dashboard'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
      });
    } else {
      const String mockData = '''
      [
        {
          "idPyxis": "1",
          "descrition": "Sample ticket 1",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "Open",
          "owner_id": "1",
          "sender_id": ["1", "2"]
        },
        {
          "idPyxis": "2",
          "descrition": "Sample ticket 2",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "Closed",
          "owner_id": "2",
          "sender_id": ["2", "3"]
        },
        {
          "idPyxis": "3",
          "descrition": "Sample ticket 3",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "Open",
          "owner_id": "3",
          "sender_id": ["3", "1"]
        }
      ]
      ''';

      final List<dynamic> data = jsonDecode(mockData);
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
      });
    }
  }

  Future<void> _fetchPyxis() async {
    final response = await http.get(Uri.parse('https://api.hermes.com/pyxis'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _pyxis = data.map((item) => Pyxi.fromJson(item)).toList();
      });
    } else {
      const String mockData = '''
      [
        {
          "id": "1",
          "descrition": "Sample pyxi 1",
          "medicine": {
            "id": "1",
            "name": "Medicine 1",
            "descrition": "Sample medicine 1"
          }
        },
        {
          "id": "2",
          "descrition": "Sample pyxi 2",
          "medicine": {
            "id": "2",
            "name": "Medicine 2",
            "descrition": "Sample medicine 2"
          }
        },
        {
          "id": "3",
          "descrition": "Sample pyxi 3",
          "medicine": {
            "id": "3",
            "name": "Medicine 3",
            "descrition": "Sample medicine 3"
          }
        }
      ]
      ''';

      final List<dynamic> data = jsonDecode(mockData);
      setState(() {
        _pyxis = data.map((item) => Pyxi.fromJson(item)).toList();
      });
    }
  }

  void _handleCardTapped(String ticketId) {
    setState(() {
      if (_clickedTicketId == ticketId) {
        _clickedTicketId = null;
      } else {
        _clickedTicketId = ticketId;
      }
    });
  }

  Map<String, int> _prepareTicketData(List<Ticket> tickets) {
    Map<String, int> data = {};

    for (var ticket in tickets) {
      String date = ticket.created_at.toLocal().toString().split(' ')[0]; // Get the date part
      if (data.containsKey(date)) {
        data[date] = data[date]! + 1;
      } else {
        data[date] = 1;
      }
    }

    return data;
  }

  Widget _buildTicketGraph(List<Ticket> tickets) {
    Map<String, int> ticketData = _prepareTicketData(tickets);
    List<FlSpot> spots = [];

    int index = 0;
    for (var entry in ticketData.entries) {
      spots.add(FlSpot(index.toDouble(), entry.value.toDouble()));
      index++;
    }

    return SizedBox(
      height: 200,
      width: 400,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, int? count, Color color) {
    return SizedBox(
      width: 180,
      height: 110,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(count.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPyxisTable(List<Pyxi> pyxis) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Medicamento')),
        DataColumn(label: Text('Descrição')),
      ],
      rows: pyxis.map((pyxi) {
        return DataRow(cells: [
          DataCell(Text(pyxi.id)),
          DataCell(Text(pyxi.medicine.name)),
          DataCell(Text(pyxi.descrition)),
        ]);
      }).toList(),
    );
  }

  Widget _buildMedicineTable(List<Pyxi> pyxis) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nome')),
        DataColumn(label: Text('Descrição')),
      ],
      rows: pyxis.map((pyxi) {
        return DataRow(cells: [
          DataCell(Text(pyxi.medicine.id)),
          DataCell(Text(pyxi.medicine.name)),
          DataCell(Text(pyxi.medicine.descrition)),
        ]);
      }).toList(),
    );
  }

  Widget _buildRecentTickets(List<Ticket> tickets) {
    return Column(
      children: tickets.map((ticket) {
        return TicketCard(
          ticket: ticket,
          isExpanded: ticket.idPyxis == _clickedTicketId,
          onCardTapped: _handleCardTapped,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildInfoCard('Tickets Totais', _tickets.length, Colors.yellow),
                  _buildInfoCard('Abertos', _tickets.where((ticket) => ticket.status == 'Open').length, Colors.red),
                  _buildInfoCard('Finalizados', _tickets.where((ticket) => ticket.status == 'Closed').length, Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Histórico de Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTicketGraph(_tickets),
              const SizedBox(height: 20),
              const Text('Tabela de Pyxis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildPyxisTable(_pyxis),
              const SizedBox(height: 20),
              const Text('Tabela de Medicamentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildMedicineTable(_pyxis),
              const SizedBox(height: 20),
              const Text('Tickets Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRecentTickets(_tickets),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final bool isExpanded;
  final Function(String) onCardTapped;

  const TicketCard({super.key, 
    required this.ticket,
    required this.isExpanded,
    required this.onCardTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCardTapped(ticket.idPyxis),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ticket.descrition, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('ID Pyxis: ${ticket.idPyxis}'),
              Text('Descrição: ${ticket.descrition}'),
              Text('Status: ${ticket.status}'),
              if (isExpanded) ...[
                Text('Conteúdo: ${ticket.body.join(', ')}'),
                Text('Data de Criação: ${ticket.created_at}'),
                Text('Remetente: ${ticket.owner_id}'),
                Text('Destinatário: ${ticket.sender_id.join(', ')}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}