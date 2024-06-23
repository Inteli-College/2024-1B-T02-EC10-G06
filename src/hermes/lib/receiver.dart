import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hermes/models.dart';
import 'package:hermes/functions.dart';
import 'package:hermes/widgets/ticketCard.dart' as TicketOpen;
import 'package:hermes/widgets/ticketCardOperation.dart' as TicketOperation;

class ReceiverPage extends StatefulWidget {
  const ReceiverPage({super.key});

  @override
  _ReceiverPageState createState() => _ReceiverPageState();
}

class _ReceiverPageState extends State<ReceiverPage> {
  List<Ticket> _tickets = [];
  List<Ticket> _opTickets = [];
  String? _clickedTicketId;
  bool _isLoading = true;
  dynamic _credentials = {};
  late int _selectedIndex = 0;
  int ticketLen = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
    fetchTickets();
    _initializeCredentials();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);
      fetchTickets();
    });
  }

  Future<void> _initializeCredentials() async {
    try {
      String token = await getTokenFromStorage();
      _credentials = await postToken(token);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize credentials: $e')),
      );
    }
  }

  Future<void> fetchTickets() async {
    final response =
        await http.get(Uri.parse('${dotenv.env["API_URL"]}/api/tickets/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      _tickets = data.map((item) => Ticket.fromJson(item)).toList();
      _tickets = _tickets.where((ticket) => ticket.status == 'open').toList();
      ticketLen = _tickets.length;
      setState(() {
        _tickets = data.map((item) => Ticket.fromJson(item)).toList();
        _opTickets = _tickets.where((ticket) =>
                (ticket.status == 'open' ||
                    ticket.operator_id == _credentials['user']) &&
                (ticket.status != 'closed'))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch tickets')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleCardTapped(String? ticketId) {
    setState(() {
      if (_clickedTicketId == ticketId) {
        _clickedTicketId = null;
      } else {
        _clickedTicketId = ticketId;
      }
    });
  }

  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
   
        fetchTickets();

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
            onPressed: fetchTickets,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                setState(() {
                  _clickedTicketId = null;
                });
              },
              child: ListView.builder(
                itemCount: _opTickets.length,
                itemBuilder: (context, index) {
                  return _selectedIndex == 1
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                          child: TicketOpen.TicketCard(
                            ticket: _opTickets[index],
                            isExpanded:
                                _opTickets[index].id == _clickedTicketId,
                            onCardTapped: _handleCardTapped,
                            credentials: _credentials,
                            fetchData: fetchTickets,
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                          child: TicketOperation.TicketCard(
                            ticket: _opTickets[index],
                            isExpanded:
                                _opTickets[index].id == _clickedTicketId,
                            onCardTapped: _handleCardTapped,
                            credentials: _credentials,
                            fetchData: fetchTickets,
                          ));
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.toc),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: ticketLen <= 0 ? const Icon(Icons.notifications) : badges.Badge(
              badgeStyle: const badges.BadgeStyle(
                padding: EdgeInsets.all(8.0),
                badgeColor: Colors.deepPurple,
              ),
              position: badges.BadgePosition.topEnd(top: -20, end: -15),
              badgeContent:  Text('$ticketLen', style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
              child: const Icon(Icons.notifications),
            ),
            label: 'Notificações',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
