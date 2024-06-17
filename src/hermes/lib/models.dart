class Ticket {
  final String? id;
  final String idPyxis;
  final String description;
  final List<dynamic> body;
  final DateTime created_at;
  final String fixed_at;
  final String status;
  final String owner_id;
  final String operator_id;

  Ticket({
    required this.id,
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
      id:           json['id'],
      idPyxis:      json['idPyxis'],
      description:  json['description'],
      body:         (json['body'] as List<dynamic>)
                    .map((item) => item.toString())
                    .toList(),
      created_at:   DateTime.parse(json['created_at']),
      fixed_at:     json['fixed_at'],
      status:       json['status'],
      owner_id:     json['owner_id'],
      operator_id:  json['operator_id'] ,
    );
  }
}

class Medication {
  final String id;
  final String name;
  final String description;

  Medication({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Pyxi {
  final String id;
  final String description;
  final Medication medicine;

  Pyxi({
    required this.id,
    required this.description,
    required this.medicine,
  });

  factory Pyxi.fromJson(Map<String, dynamic> json) {
    return Pyxi(
      id: json['id'],
      description: json['description'],
      medicine: Medication.fromJson(json['medicine']),
    );
  }
}