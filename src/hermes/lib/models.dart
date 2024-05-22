class Ticket {
  final String idPyxis;
  final String descrition;
  final List<String> body;
  final DateTime created_at;
  final String status;
  final String sender;
  final String receiver;

  Ticket({
    required this.idPyxis,
    required this.descrition,
    required this.body,
    required this.created_at,
    required this.status,
    required this.sender,
    required this.receiver,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      idPyxis: json['idPyxis'],
      descrition: json['descrition'],
      body: List<String>.from(json['body']),
      created_at: DateTime.parse(json['created_at']),
      status: json['status'],
      sender: json['sender'],
      receiver: json['receiver'],
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