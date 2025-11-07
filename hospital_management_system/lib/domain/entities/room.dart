enum RoomType {
  generalWard('General Ward'),
  privateRoom('Private Room'),
  icu('ICU'),
  emergency('Emergency'),
  operatingRoom('Operating Room'),
  consultationRoom('Consultation Room'),
  maternity('Maternity Ward');

  const RoomType(this.displayName);
  final String displayName;
}

class Room {
  final String id;
  final String number;
  final RoomType type;
  final int capacity;
  final double pricePerDay;
  final List<String> _equipment;
  final List<Bed> _beds;

  Room({
    required this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.pricePerDay,
    List<String>? equipment,
  })  : _equipment = equipment ?? [],
        _beds = [] {
    for (int i = 1; i <= capacity; i++) {
      _beds.add(
        Bed(
          id: '$id-B${i.toString().padLeft(2, '0')}',
          roomId: id,
          bedNumber: i,
        ),
      );
    }
  }

  List<Bed> get beds => List.unmodifiable(_beds);
  List<String> get equipment => List.unmodifiable(_equipment);

  int get availableBedsCount =>
      _beds.where((bed) => bed.status == BedStatus.available).length;

  int get occupiedBedsCount =>
      _beds.where((bed) => bed.status == BedStatus.occupied).length;

  int get maintenanceBedsCount =>
      _beds.where((bed) => bed.status == BedStatus.maintenance).length;

  Bed? getAvailableBed() {
    try {
      return _beds.firstWhere((bed) => bed.status == BedStatus.available);
    } catch (e) {
      return null;
    }
  }

  void addEquipment(String item) {
    if (!_equipment.contains(item)) {
      _equipment.add(item);
    }
  }

  void removeEquipment(String item) {
    _equipment.remove(item);
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    final room = Room(
      id: json['id'],
      number: json['number'],
      type: RoomType.values.firstWhere((e) => e.name == json['type']),
      capacity: json['capacity'],
      pricePerDay: json['pricePerDay'],
      equipment: (json['equipment'] as List?)?.cast<String>(),
    );

    // Restore bed states if available
    if (json['beds'] != null) {
      final bedsJson = json['beds'] as List;
      for (int i = 0; i < bedsJson.length && i < room._beds.length; i++) {
        final bedJson = bedsJson[i];
        final bed = room._beds[i];

        // Restore bed status
        bed.status = BedStatus.values.firstWhere(
          (e) => e.name == bedJson['status'],
          orElse: () => BedStatus.available,
        );

        // Restore patient assignment if occupied
        if (bedJson['patientId'] != null) {
          bed._patientId = bedJson['patientId'];
        }

        if (bedJson['assignedDate'] != null) {
          bed._assignedDate = DateTime.parse(bedJson['assignedDate']);
        }

        if (bedJson['dischargeDate'] != null) {
          bed._dischargeDate = DateTime.parse(bedJson['dischargeDate']);
        }
      }
    }

    return room;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'type': type.name,
      'capacity': capacity,
      'pricePerDay': pricePerDay,
      'equipment': _equipment,
      'beds': _beds.map((bed) => bed.toJson()).toList(),
      'availableBedsCount': availableBedsCount,
      'occupiedBedsCount': occupiedBedsCount,
    };
  }
}

enum BedStatus { available, occupied, maintenance }

class Bed {
  final String id;
  final String roomId;
  final int bedNumber;
  BedStatus status;
  String? _patientId;
  DateTime? _assignedDate;
  DateTime? _dischargeDate;

  Bed({
    required this.id,
    required this.roomId,
    required this.bedNumber,
    this.status = BedStatus.available,
  });

  String? get patientId => _patientId;
  DateTime? get assignedDate => _assignedDate;
  DateTime? get dischargeDate => _dischargeDate;

  void assignPatient(String patientId) {
    if (status != BedStatus.available) {
      throw StateError('Bed is not available for assignment');
    }
    _patientId = patientId;
    _assignedDate = DateTime.now();
    status = BedStatus.occupied;
  }

  void dischargePatient() {
    _patientId = null;
    _dischargeDate = DateTime.now();
    status = BedStatus.available;
  }

  void setMaintenance() {
    _patientId = null;
    _assignedDate = null;
    status = BedStatus.maintenance;
  }

  Duration? get occupancyDuration {
    if (_assignedDate == null) return null;
    final endDate = _dischargeDate ?? DateTime.now();
    return endDate.difference(_assignedDate!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'bedNumber': bedNumber,
      'status': status.name,
      'patientId': _patientId,
      'assignedDate': _assignedDate?.toIso8601String(),
      'dischargeDate': _dischargeDate?.toIso8601String(),
    };
  }
}
