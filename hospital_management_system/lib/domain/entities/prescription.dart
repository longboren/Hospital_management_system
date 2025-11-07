class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String? notes;
  final double cost;
  final bool isValid;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    this.notes,
    required this.cost,
    this.isValid = true,
  });

  String get dosageDescription => '$dosage, $frequency';
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      notes: json['notes'],
      cost: json['cost'],
      isValid: json['isValid'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'notes': notes,
      'cost': cost,
      'isValid': isValid,
    };
  }
}

class Prescription {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime issueDate;
  final String diagnosis;
  final List<Medication> items;
  final double totalCost;
  final String instructions;
  final DateTime? followUpDate;
  final bool _isFilled;
  final String? notes;

  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.issueDate,
    required this.diagnosis,
    required this.items,
    required this.totalCost,
    required this.instructions,
    this.followUpDate,
    this.notes,
  }) : _isFilled = false;

  bool get isFilled => _isFilled;

  // Check if prescription is still valid (not expired)
  bool get isValid => items.every((item) => item.isValid);

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      issueDate: DateTime.parse(json['issueDate']),
      diagnosis: json['diagnosis'],
      items: (json['items'] as List)
          .map((itemJson) => Medication.fromJson(itemJson))
          .toList(),
      totalCost: json['totalCost'],
      instructions: json['instructions'],
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'issueDate': issueDate.toIso8601String(),
      'diagnosis': diagnosis,
      'items': items.map((m) => m.toJson()).toList(),
      'totalCost': totalCost,
      'instructions': instructions,
      'followUpDate': followUpDate?.toIso8601String(),
      'isFilled': _isFilled,
      'isValid': isValid,
      'notes': notes,
    };
  }
}
