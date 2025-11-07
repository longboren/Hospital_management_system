enum AppointmentStatus { scheduled, inProgress, completed, cancelled, noShow }

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime scheduledTime;
  DateTime? actualStartTime;
  DateTime? actualEndTime;
  final String reason;
  AppointmentStatus status;
  String? _notes;
  final String _appointmentType;
  final DateTime _createdAt;
  final String? _roomId;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.scheduledTime,
    required this.reason,
    this.status = AppointmentStatus.scheduled,
    String? appointmentType,
    String? roomId,
    DateTime? startTime,
    DateTime? endTime,
  })  : _appointmentType = appointmentType ?? 'General Checkup',
        _roomId = roomId,
        _createdAt = DateTime.now() {
    actualStartTime = startTime;
    actualEndTime = endTime;
  }

  String? get notes => _notes;
  String get appointmentType => _appointmentType;
  String? get roomId => _roomId;
  DateTime get createdAt => _createdAt;

  void addNotes(String notes) {
    _notes = notes;
  }

  void startAppointment() {
    if (status == AppointmentStatus.scheduled) {
      status = AppointmentStatus.inProgress;
      actualStartTime = DateTime.now();
    }
  }

  void complete() {
    if (status == AppointmentStatus.inProgress) {
      status = AppointmentStatus.completed;
      actualEndTime = DateTime.now();
    }
  }

  void cancel() {
    status = AppointmentStatus.cancelled;
  }

  void markAsNoShow() {
    status = AppointmentStatus.noShow;
  }

  bool get isUpcoming =>
      status == AppointmentStatus.scheduled &&
      scheduledTime.isAfter(DateTime.now());

  bool get isPast => scheduledTime.isBefore(DateTime.now());

  Duration? get duration {
    if (actualStartTime == null || actualEndTime == null) return null;
    return actualEndTime!.difference(actualStartTime!);
  }

  bool get isInProgress => status == AppointmentStatus.inProgress;

  bool get canStart =>
      status == AppointmentStatus.scheduled &&
      scheduledTime.isBefore(DateTime.now().add(Duration(minutes: 30))) &&
      scheduledTime.isAfter(DateTime.now().subtract(Duration(hours: 1)));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'actualStartTime': actualStartTime?.toIso8601String(),
      'actualEndTime': actualEndTime?.toIso8601String(),
      'reason': reason,
      'status': status.name,
      'notes': _notes,
      'appointmentType': _appointmentType,
      'roomId': _roomId,
      'createdAt': _createdAt.toIso8601String(),
      'isUpcoming': isUpcoming,
      'isPast': isPast,
      'isInProgress': isInProgress,
      'duration': duration?.inMinutes,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      reason: json['reason'],
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      appointmentType: json['appointmentType'],
      roomId: json['roomId'],
      startTime: json['actualStartTime'] != null
          ? DateTime.parse(json['actualStartTime'])
          : null,
      endTime: json['actualEndTime'] != null
          ? DateTime.parse(json['actualEndTime'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Appointment{id: $id, patientId: $patientId, doctorId: $doctorId, '
        'scheduled: $scheduledTime, status: $status, type: $_appointmentType}';
  }
}
