import 'package:flutter/material.dart';
import 'package:hermes/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReceiverPage extends StatefulWidget {
  const ReceiverPage({super.key});

  @override
  _ReceiverPageState createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  List<Ticket> _tickets = [];
  List<Ticket> _openTickets = [];
  String? _clickedTicketId;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

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
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Add your profile button action here
            },
          ),
        ],
      ),
      body: GestureDetector(
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
              isExpanded: _openTickets[index].idPyxis == _clickedTicketId,
              onCardTapped: _handleCardTapped,
            );
          },
        ),
      ),
    );
  }
}

class TicketCard extends StatefulWidget {
  final Ticket ticket;
  final bool isExpanded;
  final Function(String) onCardTapped;

  const TicketCard({super.key, 
    required this.ticket,
    required this.isExpanded,
    required this.onCardTapped,
  });

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  void _toggleFunc() {
    widget.onCardTapped(widget.ticket.idPyxis);
  }

  Future<void> _confirmClose() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Encerrar Ticket'),
          content: const Text('Deseja encerrar o ticket?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _closeTicket();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Encerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _closeTicket() async {
    final response = await http.put(
      Uri.parse('https://api.hermes.com/tickets/${widget.ticket.idPyxis}/Closed'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket encerrado com sucesso!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao encerrar ticket!'),
        ),
      );
    }
    widget.onCardTapped(widget.ticket.idPyxis);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _toggleFunc,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.ticket.idPyxis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.ticket.descrition,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              ...widget.ticket.body.map((medication) => Text(medication)),
              const SizedBox(height: 16),
              widget.isExpanded ? Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _confirmClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Encerrar Ticket'),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}