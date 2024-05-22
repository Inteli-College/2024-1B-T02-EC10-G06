import 'package:flutter/material.dart';
import 'package:hermes/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicationRequestPage extends StatefulWidget {
  @override
  _MedicationRequestPageState createState() => _MedicationRequestPageState();
}

class _MedicationRequestPageState extends State<MedicationRequestPage> {
  late Future<List<Ticket>> tickets;

  @override
  void initState() {
    super.initState();
    tickets = fetchTickets();
  }

  Future<List<Ticket>> fetchTickets() async {
    final response = await http.get(Uri.parse('https://api.example.com/tickets'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((ticket) => Ticket.fromJson(ticket)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Add your profile button action here
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Ticket>>(
        future: tickets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TicketCard(
                  title: snapshot.data![index].descrition,
                  location: 'Pyxis ${snapshot.data![index].idPyxis}',
                  medications: snapshot.data![index].body,
                  onClose: () {
                    // Add your close ticket action here
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.ticket.idPyxis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.ticket.descrition,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            ...widget.ticket.body.map((medication) => Text(medication)).toList(),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                child: Text('Encerrar Ticket'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}