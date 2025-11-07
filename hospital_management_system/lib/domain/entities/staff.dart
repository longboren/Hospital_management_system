// Base abstract class for all staff members
abstract class Staff {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime joinDate;
  final String department;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.joinDate,
    required this.department,
  });

  String get role;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'joinDate': joinDate.toIso8601String(),
      'department': department,
      'role': role,
    };
  }
}

class Doctor extends Staff {
  final String specialization;
  final String licenseNumber;
  final List<String> _appointmentIds;
  final List<String> _qualifications;

  Doctor({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.joinDate,
    required super.department,
    required this.specialization,
    required this.licenseNumber,
    List<String>? qualifications,
  }) : _appointmentIds = [],
       _qualifications = qualifications ?? [];

  @override
  String get role => 'Doctor';

  List<String> get appointmentIds => List.unmodifiable(_appointmentIds);
  List<String> get qualifications => List.unmodifiable(_qualifications);

  void addAppointment(String appointmentId) {
    _appointmentIds.add(appointmentId);
  }

  void removeAppointment(String appointmentId) {
    _appointmentIds.remove(appointmentId);
  }

  void addQualification(String qualification) {
    _qualifications.add(qualification);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'appointmentIds': _appointmentIds,
      'qualifications': _qualifications,
    };
  }
}

class Nurse extends Staff {
  final String ward;
  final String shift;
  final List<String> _specialties;

  Nurse({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.joinDate,
    required super.department,
    required this.ward,
    required this.shift,
    List<String>? specialties,
  }) : _specialties = specialties ?? [];

  @override
  String get role => 'Nurse';

  List<String> get specialties => List.unmodifiable(_specialties);

  void addSpecialty(String specialty) {
    _specialties.add(specialty);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'ward': ward,
      'shift': shift,
      'specialties': _specialties,
    };
  }
}

class Administrative extends Staff {
  final String position;
  final List<String> _responsibilities;

  Administrative({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.joinDate,
    required super.department,
    required this.position,
    List<String>? responsibilities,
  }) : _responsibilities = responsibilities ?? [];

  @override
  String get role => 'Administrative';

  List<String> get responsibilities => List.unmodifiable(_responsibilities);

  void addResponsibility(String responsibility) {
    _responsibilities.add(responsibility);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'position': position,
      'responsibilities': _responsibilities,
    };
  }
}
