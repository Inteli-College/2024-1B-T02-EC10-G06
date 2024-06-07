import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hermes/models.dart';

class ReceiverPage extends StatefulWidget {
  const ReceiverPage({super.key});

  @override
  _ReceiverPageState createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  List<Ticket> _tickets = [];
  List<Ticket> _openTickets = [];
  String? _clickedTicketId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    // final response = await http.get(Uri.parse('${dotenv.env["API_URL"]}/tickets'));

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    //   setState(() {
    //     _tickets = data.map((item) => Ticket.fromJson(item)).toList();
    //     _openTickets = _tickets.where((ticket) => ticket.status == 'open').toList();
    //     _isLoading = false;
    //   });
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Failed to fetch tickets')),
    //   );
      setState(() {
        _isLoading = false;
      });
    //}

    const String mockData = '''
      [
        {
          "idPyxis": "1",
          "descrition": "Sample ticket 1",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "open",
          "owner_id": "1",
          "operator_id": "2"
        },
        {
          "idPyxis": "2",
          "descrition": "Sample ticket 2",
          "body": ["Item 1", "Item 2"],
          "created_at": "2022-01-01T00:00:00Z",
          "fixed_at": "2022-01-01T00:00:00Z",
          "status": "closed",
          "owner_id": "2",
          "operator_id": "3"
        },
        {
          "idPyxis": "3",
          "descrition": "Sample ticket 3",
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
        _openTickets = _tickets.where((ticket) => ticket.status == 'open').toList();
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTickets,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
            onTap: () {
              setState(() {
                _clickedTicketId = null;
              });
            },
            child: ListView.builder(
              itemCount: _openTickets.length,
              itemBuilder: (context, index) {
                return TicketCard(
                  ticket: _openTickets[index],
                  //isExpanded: _openTickets[index].idPyxis == _clickedTicketId,
                  //onCardTapped: _handleCardTapped,
            );
              },
            ),
          ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  //final bool isExpanded;
  //final Function(String) onCardTapped;

  const TicketCard({super.key,
    required this.ticket,
    //required this.isExpanded,
    //required this.onCardTapped,
  });

  // void _toggleFunc() {
  //   onCardTapped(ticket.idPyxis);
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.idPyxis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            ...ticket.body.map((medication) => Text('${medication.name}: ${medication.description}')),
            const SizedBox(height: 8),
            Text(
              'Status: ${ticket.status}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Created At: ${ticket.created_at}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
