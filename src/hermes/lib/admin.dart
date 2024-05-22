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
  @override
  void initState() {
    super.initState();
    _fetchTickets();
    _fetchPyxis();
  }

  List<Ticket> _tickets = [];

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
          "body": ["Body content 1"],
          "created_at": "2024-05-15T10:00:00Z",
          "status": "Open",
          "sender": "John Doe",
          "receiver": "Jane Doe"
        },
        {
          "idPyxis": "2",
          "descrition": "Sample ticket 2",
          "body": ["Body content 2"],
          "created_at": "2024-05-14T12:00:00Z",
          "status": "Closed",
          "sender": "yoda",
          "receiver": "luke"
        },
        {
          "idPyxis": "3",
          "descrition": "Sample ticket 3",
          "body": ["Body content 3"],
          "created_at": "2024-05-13T14:00:00Z",
          "status": "Open",
          "sender": "JJJameson",
          "receiver": "Peter Parker"
        }
      ]
      ''';

      final List<dynamic> data = jsonDecode(mockData);
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
      });
    }
  }

  List<Pyxi> _pyxis = [];

  Future _fetchPyxis() async {
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
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: true),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                int idx = value.toInt();
                if (idx < ticketData.keys.length) {
                  return ticketData.keys.elementAt(idx);
                }
                return '';
              },
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: [Colors.blue],
              barWidth: 4,
              belowBarData: BarAreaData(show: true, colors: [Colors.blue.withOpacity(0.3)]),
            ),
          ],
        ),
      ),
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
        child:
          SingleChildScrollView(
          child:
          Column(
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
            const Text('Tickets Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildRecentTickets(_tickets),
            const SizedBox(height: 20),
            const Text('Pyxis mais Pedidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildPyxisTable(_pyxis),
            const SizedBox(height: 20),
            const Text('Medicamentos mais Pedidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildMedicineTable(_pyxis),
          ],
        ),
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
        return TicketCard(ticket: ticket);
      }).toList(),
    );
  }
}

class TicketCard extends StatefulWidget {
  final Ticket ticket;

  const TicketCard({required this.ticket});

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool _clickedTicket = false;

  void _toggleDescription() {
    setState(() {
      _clickedTicket = !_clickedTicket;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _toggleDescription,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.ticket.idPyxis, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Status: ${widget.ticket.status}'),
              Text('Criado em: ${widget.ticket.created_at}'),
              if (_clickedTicket) Text('Enviado por: ${widget.ticket.sender}'),
              if (_clickedTicket) Text('Recebido por: ${widget.ticket.receiver}'),
              if (_clickedTicket) Text(widget.ticket.descrition),
            ],
          ),
        ),
      ),
    );
  }
}