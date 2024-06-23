import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hermes/models.dart';

import 'package:http/http.dart' as http;

class TicketCard extends StatefulWidget {
  final Ticket ticket;
  final bool isExpanded;
  final Function(String?) onCardTapped;
  final dynamic credentials;
  final void Function()? fetchData; 
  

  const TicketCard({super.key,
    required this.ticket,
    required this.isExpanded,
    required this.onCardTapped,
    required this.credentials,
    required this.fetchData, 
    
  });

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {

  void _toggleFunc() {
    widget.onCardTapped(widget.ticket.id);
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
              child: const Text('Encerrar', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _closeTicket() async {
    final response = await http.put(
      Uri.parse('${dotenv.env["API_URL"]}/api/tickets/${widget.ticket.id}/status'),
      body: jsonEncode({
        'status': 'closed',
        'operator_id': widget.credentials['user'].toString(),
        }),
        headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket encerrado com sucesso!'),
        ),
      );
      widget.fetchData!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao encerrar ticket!'),
        ),
      );
    }
    widget.onCardTapped(widget.ticket.idPyxis);
  }

  Future<void> _confirmOperate() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Operar Ticket'),
          content: const Text('Deseja operar o ticket?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _operateTicket();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
              ),
              child: const Text('Operar', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _operateTicket() async {
    final response = await http.put( 
      Uri.parse('${dotenv.env["API_URL"]}/api/tickets/${widget.ticket.id}/status'),
      body: jsonEncode({
        'status': 'operation',
        'operator_id': widget.credentials['user'].toString(),
        }),
        headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket encaminhado com sucesso!'),
        ),
      );
      widget.fetchData!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao encaminhar o ticket.'),
        ),
      );
    }
    widget.onCardTapped(widget.ticket.idPyxis);
  }

  @override
  Widget build(BuildContext context) {
    return widget.ticket.status == "open" ? Card(
      child: InkWell(
        onTap: _toggleFunc,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                'Status: ${widget.ticket.status}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.ticket.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              ...widget.ticket.body.map((medication) => Text('${medication.name}: ${medication.description}')),
              const SizedBox(height: 8),
              Text(
                widget.ticket.created_at.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              widget.isExpanded ? Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _confirmOperate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700],
                  ),
                  child: const Text('Operar Ticket', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ):Container(),
            ],
          ),
        ),
      ),
    ): Container();
  }
}
