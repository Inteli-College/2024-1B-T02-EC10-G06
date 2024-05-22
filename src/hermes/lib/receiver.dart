import 'package:flutter/material.dart';
import 'package:hermes/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReceiverPage extends StatefulWidget {
  @override
  _ReceiverPageState createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  List<Ticket> _tickets = [];
  List<Ticket> _openTickets = [];

  Future<void> _fetchTickets() async {
    final response = await http.get(Uri.parse('https://api.hermes.com/dashboard'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
        _openTickets = _tickets.where((ticket) => ticket.status == 'Open').toList();
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
        _openTickets = _tickets.where((ticket) => ticket.status == 'Open').toList();
      });
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
      body: ListView.builder(
        itemCount: _openTickets.length,
        itemBuilder: (context, index) {
          return TicketCard(ticket: _openTickets[index]);
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

  Future<void> _closeTicket() async {
    final response = await http.put(
      Uri.parse('https://api.hermes.com/tickets/${widget.ticket.idPyxis}/Closed'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket encerrado com sucesso!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao encerrar ticket!'),
        ),
      );
    }
    initState();
  }

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
                  _closeTicket();
                },
                child: Text('Encerrar Ticket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}