class Ticket {
  final String idPyxis;
  final String description;
  final List<String> body;
  final DateTime created_at;
  final DateTime fixed_at;
  final String status;
  final String owner_id;
  final String operator_id;

  Ticket({
    required this.idPyxis,
    required this.description,
    required this.body,
    required this.created_at,
    required this.fixed_at,
    required this.status,
    required this.owner_id,
    required this.operator_id,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      idPyxis:      json['idPyxis'],
      description:   json['description'],
      body:         List<String>.from(json['body']),
      created_at:   DateTime.parse(json['created_at']),
      fixed_at:     DateTime.parse(json['fixed_at']),
      status:       json['status'],
      owner_id:     json['owner_id'],
      operator_id:  json['operator_id'],
    );
  }
}

class Medicine {
  final String id;
  final String name;
  final String description;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Pyxi {
  final String id;
  final String description;
  final Medicine medicine;

  Pyxi({
    required this.id,
    required this.description,
    required this.medicine,
  });

  factory Pyxi.fromJson(Map<String, dynamic> json) {
    return Pyxi(
      id: json['id'],
      description: json['description'],
      medicine: Medicine.fromJson(json['medicine']),
    );
  }
}