class Patient {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String phoneNumber;
  final String email;
  final String? emergencyPhone;
  final String bloodType;
  final List<String> _medicalHistory;
  final List<String> _appointmentIds;
  final List<String> _prescriptionIds;
  final List<String> _allergies;
  final List<String> _medicalConditions;
  final DateTime _createdAt;

  Patient({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.emergencyPhone,
    required this.bloodType,
    List<String>? medicalHistory,
    List<String>? allergies,
    List<String>? medicalConditions,
  })  : _medicalHistory = medicalHistory ?? [],
        _appointmentIds = [],
        _prescriptionIds = [],
        _allergies = allergies ?? [],
        _medicalConditions = medicalConditions ?? [],
        _createdAt = DateTime.now();

  List<String> get medicalHistory => List.unmodifiable(_medicalHistory);
  List<String> get appointmentIds => List.unmodifiable(_appointmentIds);
  List<String> get prescriptionIds => List.unmodifiable(_prescriptionIds);
  List<String> get allergies => List.unmodifiable(_allergies);
  List<String> get medicalConditions => List.unmodifiable(_medicalConditions);
  DateTime get createdAt => _createdAt;
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  void addMedicalHistory(String history) {
    _medicalHistory.add(history);
  }

  void addAppointment(String appointmentId) {
    _appointmentIds.add(appointmentId);
  }

  void removeAppointment(String appointmentId) {
    _appointmentIds.remove(appointmentId);
  }

  void addPrescription(String prescriptionId) {
    _prescriptionIds.add(prescriptionId);
  }

  void addAllergy(String allergy) {
    _allergies.add(allergy);
  }

  void addMedicalCondition(String condition) {
    _medicalConditions.add(condition);
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      emergencyPhone: json['emergencyPhone'],
      bloodType: json['bloodType'],
      medicalHistory: List<String>.from(json['medicalHistory'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'emergencyPhone': emergencyPhone,
      'bloodType': bloodType,
      'medicalHistory': _medicalHistory,
      'appointmentIds': _appointmentIds,
      'prescriptionIds': _prescriptionIds,
      'allergies': _allergies,
      'medicalConditions': _medicalConditions,
      'createdAt': _createdAt.toIso8601String(),
      'age': age,
    };
  }
}
