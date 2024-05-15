import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://api.example.com/data'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard('Tickets Totais', 10, Colors.yellow),
                        _buildInfoCard('Abertos', 5, Colors.red),
                        _buildInfoCard('Finalizados', 5, Colors.green),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Histórico de Tickets - Por dia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                                spots: [
                                FlSpot(1, 10),
                                FlSpot(2, 15),
                                FlSpot(3, 20),
                                FlSpot(4, 18),
                                FlSpot(5, 12),
                                FlSpot(6, 16),
                                FlSpot(7, 22),
                                ],
                              isCurved: true,
                              colors: [Colors.purple],
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Tickets Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    //_buildRecentTickets(data['recentTickets']),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        // Expanded(child: _buildOrderedList('Pyxis mais pedidos', data['mostOrderedPyxis'])),
                        // SizedBox(width: 20),
                        // Expanded(child: _buildOrderedList('Remédios mais pedidos', data['mostOrderedMedicines'])),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, int count, Color color) {
    return Card(
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
    );
  }

  Widget _buildRecentTickets(List<dynamic> tickets) {
    return Column(
      children: tickets.map((ticket) {
        return Card(
          child: ListTile(
            title: Text(ticket['pyxis']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (ticket['medicines'] as List<dynamic>).map((med) => Text(med)).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderedList(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...items.map((item) => ListTile(
          title: Text(item['name']),
          trailing: Text(item['count'].toString()),
        )).toList(),
      ],
    );
  }
}