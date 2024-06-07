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
  bool _isLoadingTickets = true;
  bool _isLoadingPyxis = true;

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
        _isLoadingTickets = false;
      });
    } else {
      const String mockData = '''
      [
        {
          "idPyxis": "1",
          "description": "Sample ticket 1",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "open",
          "owner_id": "1",
          "operator_id": "2"
        },
        {
          "idPyxis": "2",
          "description": "Sample ticket 2",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "closed",
          "owner_id": "2",
          "operator_id": "3"
        },
        {
          "idPyxis": "3",
          "description": "Sample ticket 3",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "open",
          "owner_id": "3",
          "operator_id": "1"
        }
      ]
      ''';

      final List<dynamic> data = jsonDecode(mockData);
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
        _isLoadingTickets = false;
      });
    }
  }

  Future<void> _fetchPyxis() async {
    final response = await http.get(Uri.parse('https://api.hermes.com/pyxis'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _pyxis = data.map((item) => Pyxi.fromJson(item)).toList();
        _isLoadingPyxis = false;
      });
    } else {
      const String mockData = '''
      [
        {
          "id": "1",
          "description": "Sample pyxi 1",
          "medicine": {
            "id": "1",
            "name": "Medicine 1",
            "description": "Sample medicine 1"
          }
        },
        {
          "id": "2",
          "description": "Sample pyxi 2",
          "medicine": {
            "id": "2",
            "name": "Medicine 2",
            "description": "Sample medicine 2"
          }
        },
        {
          "id": "3",
          "description": "Sample pyxi 3",
          "medicine": {
            "id": "3",
            "name": "Medicine 3",
            "description": "Sample medicine 3"
          }
        }
      ]
      ''';

      final List<dynamic> data = jsonDecode(mockData);
      setState(() {
        _pyxis = data.map((item) => Pyxi.fromJson(item)).toList();
        _isLoadingPyxis = false;
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

  Widget _buildStatusBarChart(List<Ticket> tickets) {
    final openTickets = tickets.where((ticket) => ticket.status == 'open').length;
    final closedTickets = tickets.where((ticket) => ticket.status == 'closed').length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Ticket Status'),
          SizedBox(
            height: 200,
            width: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: openTickets.toDouble(), color: Colors.blue),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: closedTickets.toDouble(), color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusByOwnerChart(List<Ticket> tickets) {
    final owner1OpenTickets = tickets.where((ticket) => ticket.status == 'open' && ticket.owner_id == '1').length;
    final owner1ClosedTickets = tickets.where((ticket) => ticket.status == 'closed' && ticket.owner_id == '1').length;
    final owner2OpenTickets = tickets.where((ticket) => ticket.status == 'open' && ticket.owner_id == '2').length;
    final owner2ClosedTickets = tickets.where((ticket) => ticket.status == 'closed' && ticket.owner_id == '2').length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Status by Owner'),
          SizedBox(
            height: 200,
            width: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: owner1OpenTickets.toDouble(), color: Colors.blue),
                      BarChartRodData(toY: owner1ClosedTickets.toDouble(), color: Colors.green),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: owner2OpenTickets.toDouble(), color: Colors.blue),
                      BarChartRodData(toY: owner2ClosedTickets.toDouble(), color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderCountChart(List<Ticket> tickets) {
    final senderCounts = tickets.map((ticket) => ticket.operator_id.length).toList();
    final count2Senders = senderCounts.where((count) => count == 2).length;
    final count3Senders = senderCounts.where((count) => count == 3).length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Number of Senders per Ticket'),
          SizedBox(
            height: 200,
            width: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: count2Senders.toDouble(), color: Colors.orange),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: count3Senders.toDouble(), color: Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPieChart(List<Ticket> tickets) {
    final openTickets = tickets.where((ticket) => ticket.status == 'open').length;
    final closedTickets = tickets.where((ticket) => ticket.status == 'closed').length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Proportion of Tickets by Status'),
          SizedBox(
            height: 200,
            width: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: openTickets.toDouble(),
                    color: Colors.redAccent,
                    title: 'open',
                  ),
                  PieChartSectionData(
                    value: closedTickets.toDouble(),
                    color: Colors.green,
                    title: 'closed',
                  ),
                ],
              ),
            ),
          ),
        ],
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
          DataCell(Text(pyxi.description)),
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
          DataCell(Text(pyxi.medicine.description)),
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
                  _buildInfoCard('Abertos', _tickets.where((ticket) => ticket.status == 'open').length, Colors.red),
                  _buildInfoCard('Finalizados', _tickets.where((ticket) => ticket.status == 'closed').length, Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Histórico de Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatusBarChart(_tickets),
                    _buildStatusByOwnerChart(_tickets),
                    //_buildSenderCountChart(_tickets),
                    _buildStatusPieChart(_tickets),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tabela de Pyxis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _isLoadingPyxis ? CircularProgressIndicator() : _buildPyxisTable(_pyxis),
              const SizedBox(height: 20),
              const Text('Tabela de Medicamentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _isLoadingPyxis ? CircularProgressIndicator() : _buildMedicineTable(_pyxis),
              const SizedBox(height: 20),
              const Text('Tickets Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _isLoadingTickets ? CircularProgressIndicator() : _buildRecentTickets(_tickets),
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

  const TicketCard({
    super.key,
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
              Text(ticket.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('ID Pyxis: ${ticket.idPyxis}'),
              Text('Descrição: ${ticket.description}'),
              Text('Status: ${ticket.status}'),
              if (isExpanded) ...[
                Text('Conteúdo: ${ticket.body.join(', ')}'),
                Text('Data de Criação: ${ticket.created_at}'),
                if (ticket.status == 'closed') Text('Data de Conclusão: ${ticket.fixed_at}'),
                Text('Remetente: ${ticket.owner_id}'),
                Text('Operador: ${ticket.operator_id}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}