import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

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
  Future<void>_fetchTickets() async {
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
      "status": "Open"
    },
    {
      "idPyxis": "2",
      "descrition": "Sample ticket 2",
      "body": ["Body content 2"],
      "created_at": "2024-05-14T12:00:00Z",
      "status": "Closed"
    }
  ]
  ''';

      final List<dynamic> data = jsonDecode(mockData);
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
      });
      //throw Exception('Failed to load tickets');
    }
  }

  Future _fetchPyxis() async {
    final response = await http.get(Uri.parse('https://api.hermes.com/pyxis'));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
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
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navegue para a página de configurações ou qualquer outra página
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildInfoCard(
                  'Tickets Totais',
                  _tickets.length,
                  Colors.yellow),

                _buildInfoCard(
                  'Abertos',
                  _tickets.where((ticket) => ticket.status == 'Open').length,
                  Colors.red),

                _buildInfoCard(
                  'Finalizados',
                  _tickets.where((ticket) => ticket.status == 'Closed').length,
                  Colors.green),
              ],
            ),
            
            SizedBox(height: 20),
            Text('Histórico de Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            //_buildGraph(_tickets),

            SizedBox(height: 20),
            Text('Tickets Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildRecentTickets(_tickets),
            
            SizedBox(height: 20),
            // Row(
            //   children: [
            //     Expanded(child: _buildOrderedList('Pyxis mais pedidos', data?['mostOrderedPyxis'])),
            //     SizedBox(width: 20),
            //     Expanded(child: _buildOrderedList('Remédios mais pedidos', data?['mostOrderedMedicines'])),
            //   ],
            // ),
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
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraph(List<dynamic>? data) {
    return SizedBox(
      height: 200,
      width: 720,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data?.map<FlSpot>((item) => FlSpot(item['day'], item['count'])).toList() ?? [],
              isCurved: true,
              colors: [Colors.purple],
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTickets(List<Ticket> tickets) {
    return Column(
      children: tickets.map((ticket) {
        return Card(
          child: ListTile(
            title: Text(ticket.idPyxis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ticket.body.map((bodyItem) => Text(bodyItem)).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderedList(String title, List<dynamic>? items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...items?.map((item) => ListTile(
          title: Text(item['name']),
          trailing: Text(item['count'].toString()),
        )).toList() ?? [],
      ],
    );
  }
}

class Ticket {
  final String idPyxis;
  final String descrition;
  final List<String> body;
  final DateTime created_at;
  final String status;

  Ticket({
    required this.idPyxis,
    required this.descrition,
    required this.body,
    required this.created_at,
    required this.status,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      idPyxis: json['idPyxis'],
      descrition: json['descrition'],
      body: List<String>.from(json['body']),
      created_at: DateTime.parse(json['created_at']),
      status: json['status'],
    );
  }
}

class Medicine {
  final String id;
  final String name;
  final String descrition;

  Medicine({
    required this.id,
    required this.name,
    required this.descrition,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      descrition: json['descrition'],
    );
  }
}

class Pyxi {
  final String id;
  final String descrition;
  final Medicine medicine;

  Pyxi({
    required this.id,
    required this.descrition,
    required this.medicine,
  });

  factory Pyxi.fromJson(Map<String, dynamic> json) {
    return Pyxi(
      id: json['id'],
      descrition: json['descrition'],
      medicine: Medicine.fromJson(json['medicine']),
    );
  }
}