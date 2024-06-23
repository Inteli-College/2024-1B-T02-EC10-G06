import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:hermes/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    setState(() {
      _isLoadingTickets = true;
    });

    try {
      final response = await http.get(Uri.parse('${dotenv.env["API_URL"]}/api/tickets/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _tickets = data.map<Ticket>((item) => Ticket.fromJson(item)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch tickets')),
        );
      }
    } catch (e) {
        print(e);
    } finally {
      setState(() {
        _isLoadingTickets = false;
      });
    }
  }

  Future<void> _fetchPyxis() async {
    setState(() {
      _isLoadingPyxis = true;
    });

    try {
      final response = await http.get(Uri.parse('${dotenv.env["API_URL"]}/api/pyxis/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _pyxis = data.map<Pyxi>((item) => Pyxi.fromJson(item)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch pyxis')),
        );
      }
    } catch (e) {
        print(e);
    } finally {
      setState(() {
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

  Widget _buildStatusByOperatorChart(List<Ticket> tickets) {
    final Map<String, Map<String, int>> ticketCounts = {};

    tickets = tickets.where((ticket) => ticket.status == 'operation' || ticket.status == 'closed').toList();

    for (var ticket in tickets) {
      final operatorId = ticket.operator_id;
      final status = ticket.status;

      if (!ticketCounts.containsKey(operatorId)) {
        ticketCounts[operatorId] = {'operation': 0, 'closed': 0};
      }
      
      ticketCounts[operatorId]![status] = (ticketCounts[operatorId]![status] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups = [];
    Map<int, String> xLabels = {};
    int x = 0;

    ticketCounts.forEach((operatorId, counts) {
      final operationTickets = counts['operation']?.toDouble() ?? 0;
      final closedTickets = counts['closed']?.toDouble() ?? 0;

    barGroups.add(
      BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(toY: operationTickets, color: Colors.yellow),
          BarChartRodData(toY: closedTickets, color: Colors.green),
        ],
      ),
    );
    xLabels[x] = operatorId;
    x++;
  });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Status by Operator'),
          SizedBox(
            height: 200,
            width: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        xLabels[value.toInt()] ?? '?',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusByOwnerChart(List<Ticket> tickets) {
    final Map<String, int> ticketCounts = {};

    for (var ticket in tickets) {
      final ownerId = ticket.owner_id;

      if (!ticketCounts.containsKey(ownerId)) {
        ticketCounts[ownerId] = 0;
      }

      ticketCounts[ownerId] = (ticketCounts[ownerId] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups = [];
    Map<int, String> xLabels = {};
    int x = 0;

    ticketCounts.forEach((ownerId, tickets) {
      final ticketsCount = tickets.toDouble();
    
      barGroups.add(
        BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(toY: ticketsCount, color: Colors.orange),
          ],
        ),
      );
      xLabels[x] = ownerId;
      x++;
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Status by Owner'),
          SizedBox(
            height: 200,
            width: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        xLabels[value.toInt()] ?? '?',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPieChart(List<Ticket> tickets) {
    final openTickets = tickets.where((ticket) => ticket.status == 'open').length;
    final operationTickets = tickets.where((ticket) => ticket.status == 'operation').length;
    final closedTickets = tickets.where((ticket) => ticket.status == 'closed').length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Proportion of Tickets by Status'),
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
                    value: operationTickets.toDouble(),
                    color: Colors.yellow,
                    title: 'operation',
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
        //DataColumn(label: Text('ID')),
        DataColumn(label: Text('Medicamento')),
        DataColumn(label: Text('Descrição')),
      ],
      rows: pyxis.map((pyxi) {
        return DataRow(cells: [
          //DataCell(Text(pyxi.id)),
          DataCell(Text(pyxi.medicine.name)),
          DataCell(Text(pyxi.description)),
        ]);
      }).toList(),
    );
  }

  Widget _buildMedicineTable(List<Pyxi> pyxis) {
    return DataTable(
      columns: const [
        //DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nome')),
        DataColumn(label: Text('Descrição')),
      ],
      rows: pyxis.map((pyxi) {
        return DataRow(cells: [
          //DataCell(Text(pyxi.medicine.id)),
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
          isExpanded: ticket.id == _clickedTicketId,
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
          actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchTickets();
              _fetchPyxis();
            },
          ),
        ],
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
               Flex( direction: Axis.vertical, children: [
              _buildInfoCard(
                    'Tickets Totais',
                    _tickets.length,
                    Colors.orange,
                  ),
              _buildInfoCard(
                'Abertos',
                _tickets.where((ticket) => ticket.status == 'open').length,
                Colors.red,
              ),
              _buildInfoCard(
                    'Em Operação',
                    _tickets.where((ticket) => ticket.status == 'operation').length,
                    Colors.yellow,
                  ),
              _buildInfoCard(
                    'Finalizados',
                    _tickets.where((ticket) => ticket.status == 'closed').length,
                    Colors.green,
                  ),
              ]),
             
              const SizedBox(height: 20),
              const Text('Histórico de Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatusByOwnerChart(_tickets),
                    _buildStatusByOperatorChart(_tickets),
                    _buildStatusPieChart(_tickets),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Tabela de Pyxis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _isLoadingPyxis ? const CircularProgressIndicator() : _buildPyxisTable(_pyxis),
              const SizedBox(height: 20),
              const Text('Tabela de Medicamentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _isLoadingPyxis ? const CircularProgressIndicator() : _buildMedicineTable(_pyxis),
              const SizedBox(height: 20),
              const Text('Tickets Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _isLoadingTickets ? const CircularProgressIndicator() : _buildRecentTickets(_tickets),
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
      onTap: () => onCardTapped(ticket.id),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ticket.status, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('ID Pyxis: ${ticket.idPyxis}'),
              const SizedBox(height: 8),
              Text('Descrição: ${ticket.description}'),
              const SizedBox(height: 8),
              if (isExpanded) ...[
                ...ticket.body.map((medication) => Text('${medication.name}: ${medication.description}')),
                const SizedBox(height: 8),
                Text('Remetente: ${ticket.owner_id}'),
                const SizedBox(height: 8),
                Text('Data de Criação: ${ticket.created_at}'),
                if (ticket.status == 'operation' || ticket.status == 'closed') ...[
                  const SizedBox(height: 8),
                  Text('Operador: ${ticket.operator_id}'),
                  if (ticket.status == 'closed') ...[
                    const SizedBox(height: 8),
                    Text('Data de Encerramento: ${ticket.fixed_at}'),
                  ],
                ],   
              ],
            ],
          ),
        ),
      ),
    );
  }
}
