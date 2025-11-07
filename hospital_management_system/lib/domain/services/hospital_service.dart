import '../entities/staff.dart';
import '../entities/patient.dart';
import '../entities/room.dart';
import '../entities/appointment.dart';
import '../entities/prescription.dart';
import '../repositories/interfaces.dart';

class HospitalService {
  final IStaffRepository _staffRepository;
  final IPatientRepository _patientRepository;
  final IRoomRepository _roomRepository;
  final IAppointmentRepository _appointmentRepository;
  final IPrescriptionRepository _prescriptionRepository;

  HospitalService({
    required IStaffRepository staffRepository,
    required IPatientRepository patientRepository,
    required IRoomRepository roomRepository,
    required IAppointmentRepository appointmentRepository,
    required IPrescriptionRepository prescriptionRepository,
  }) : _staffRepository = staffRepository,
       _patientRepository = patientRepository,
       _roomRepository = roomRepository,
       _appointmentRepository = appointmentRepository,
       _prescriptionRepository = prescriptionRepository;

  // Staff Management
  Future<void> hireStaff(Staff staff) async {
    await _staffRepository.addStaff(staff);
  }

  Future<List<Doctor>> getDoctors() async {
    print('[Service] Getting doctors from repository...');
    final staff = await _staffRepository.getStaffByRole('Doctor');
    print('[Service] Retrieved ${staff.length} staff with role Doctor');
    final doctors = staff.whereType<Doctor>().toList();
    print('[Service] Converted to ${doctors.length} Doctor objects');
    return doctors;
  }

  Future<List<Nurse>> getNurses() async {
    final staff = await _staffRepository.getStaffByRole('Nurse');
    return staff.whereType<Nurse>().toList();
  }

  Future<Staff?> getStaffById(String id) async {
    return await _staffRepository.getStaffById(id);
  }

  Future<List<Staff>> getAllStaff() async {
    return await _staffRepository.getAllStaff();
  }

  Future<List<Room>> getAllRooms() async {
    return await _roomRepository.getAllRooms();
  }

  // Patient Management
  Future<void> admitPatient(Patient patient) async {
    await _patientRepository.addPatient(patient);
  }

  Future<Patient?> getPatientById(String id) async {
    return await _patientRepository.getPatientById(id);
  }

  Future<List<Patient>> getAllPatients() async {
    return await _patientRepository.getAllPatients();
  }

  Future<List<Patient>> searchPatients(String query) async {
    return await _patientRepository.searchPatients(query);
  }

  // Room Management
  Future<void> addRoom(Room room) async {
    await _roomRepository.addRoom(room);
  }

  Future<Bed?> assignPatientToBed(
    String patientId,
    RoomType preferredType,
  ) async {
    final rooms = await _roomRepository.getRoomsByType(preferredType);

    for (final room in rooms) {
      final availableBed = room.getAvailableBed();
      if (availableBed != null) {
        availableBed.assignPatient(patientId);
        await _roomRepository.updateRoom(room);
        return availableBed;
      }
    }
    return null;
  }

  Future<void> dischargePatientFromBed(String patientId) async {
    final allRooms = await _roomRepository.getAllRooms();

    for (final room in allRooms) {
      for (final bed in room.beds) {
        if (bed.patientId == patientId) {
          bed.dischargePatient();
          await _roomRepository.updateRoom(room);
          return;
        }
      }
    }
    throw Exception('Patient not found in any bed');
  }

  Future<List<Room>> getAvailableRooms() async {
    return await _roomRepository.getAvailableRooms();
  }

  // Appointment Management
  Future<Appointment> scheduleAppointment({
    required String patientId,
    required String doctorId,
    required DateTime scheduledTime,
    required String reason,
    String? appointmentType,
    String? roomId,
  }) async {
    // Check if patient exists
    final patient = await _patientRepository.getPatientById(patientId);
    if (patient == null) {
      throw ArgumentError('Patient not found');
    }

    // Check if doctor exists and is actually a doctor
    final staff = await _staffRepository.getStaffById(doctorId);
    if (staff == null || staff.role != 'Doctor') {
      throw ArgumentError('Doctor not found');
    }

    final appointment = Appointment(
      id: 'APT-${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      doctorId: doctorId,
      scheduledTime: scheduledTime,
      reason: reason,
      appointmentType: appointmentType,
      roomId: roomId,
    );

    await _appointmentRepository.scheduleAppointment(appointment);

    // Add to patient and doctor records
    patient.addAppointment(appointment.id);
    await _patientRepository.updatePatient(patient);

    if (staff is Doctor) {
      staff.addAppointment(appointment.id);
      await _staffRepository.updateStaff(staff);
    }

    return appointment;
  }

  Future<void> startAppointment(String appointmentId) async {
    final appointment = await _appointmentRepository.getAppointmentById(
      appointmentId,
    );
    if (appointment == null) {
      throw Exception('Appointment not found');
    }
    appointment.startAppointment();
    await _appointmentRepository.updateAppointment(appointment);
  }

  Future<void> completeAppointment(String appointmentId, String notes) async {
    final appointment = await _appointmentRepository.getAppointmentById(
      appointmentId,
    );
    if (appointment == null) {
      throw Exception('Appointment not found');
    }
    appointment.addNotes(notes);
    appointment.complete();
    await _appointmentRepository.updateAppointment(appointment);
  }

  Future<List<Appointment>> getUpcomingAppointments() async {
    return await _appointmentRepository.getUpcomingAppointments();
  }

  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId) async {
    return await _appointmentRepository.getAppointmentsByDoctor(doctorId);
  }

  // Prescription Management
  Future<Prescription> createPrescription({
    required String patientId,
    required String doctorId,
    required String diagnosis,
    required List<Medication> items,
    required double totalCost,
    required String instructions,
    DateTime? followUpDate,
    String? notes,
  }) async {
    // Verify patient and doctor exist
    final patient = await _patientRepository.getPatientById(patientId);
    if (patient == null) {
      throw Exception('Patient not found');
    }

    final doctor = await _staffRepository.getStaffById(doctorId);
    if (doctor == null || doctor.role != 'Doctor') {
      throw Exception('Doctor not found');
    }

    final prescription = Prescription(
      id: 'RX-${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      doctorId: doctorId,
      issueDate: DateTime.now(),
      diagnosis: diagnosis,
      items: items,
      totalCost: totalCost,
      instructions: instructions,
      followUpDate: followUpDate,
      notes: notes,
    );

    await _prescriptionRepository.addPrescription(prescription);

    // Add to patient record
    patient.addPrescription(prescription.id);
    await _patientRepository.updatePatient(patient);

    return prescription;
  }

  Future<List<Prescription>> getPatientPrescriptions(String patientId) async {
    return await _prescriptionRepository.getPrescriptionsByPatient(patientId);
  }

  Future<List<Prescription>> getActivePrescriptions(String patientId) async {
    return await _prescriptionRepository.getActivePrescriptions(patientId);
  }

  // Business Intelligence and Reports
  Future<Map<String, dynamic>> getHospitalStats() async {
    final allStaff = await _staffRepository.getAllStaff();
    final allPatients = await _patientRepository.getAllPatients();
    final allRooms = await _roomRepository.getAllRooms();
    final upcomingAppointments = await _appointmentRepository
        .getUpcomingAppointments();
    final todayAppointments = await _appointmentRepository
        .getAppointmentsByDate(DateTime.now());

    final doctors = allStaff.whereType<Doctor>().length;
    final nurses = allStaff.whereType<Nurse>().length;
    final admins = allStaff.whereType<Administrative>().length;

    int availableBeds = 0;
    int occupiedBeds = 0;
    int maintenanceBeds = 0;

    for (final room in allRooms) {
      availableBeds += room.availableBedsCount;
      occupiedBeds += room.occupiedBedsCount;
      maintenanceBeds += room.maintenanceBedsCount;
    }

    // Calculate revenue (simplified)
    double dailyRevenue = 0;
    for (final room in allRooms) {
      dailyRevenue += room.occupiedBedsCount * room.pricePerDay;
    }

    return {
      'totalStaff': allStaff.length,
      'doctors': doctors,
      'nurses': nurses,
      'administrative': admins,
      'totalPatients': allPatients.length,
      'totalRooms': allRooms.length,
      'availableBeds': availableBeds,
      'occupiedBeds': occupiedBeds,
      'maintenanceBeds': maintenanceBeds,
      'upcomingAppointments': upcomingAppointments.length,
      'todayAppointments': todayAppointments.length,
      'estimatedDailyRevenue': dailyRevenue,
      'occupancyRate': allRooms.isEmpty
          ? 0
          : (occupiedBeds / (availableBeds + occupiedBeds + maintenanceBeds)) *
                100,
    };
  }

  Future<Map<String, dynamic>> getDoctorPerformance(String doctorId) async {
    final appointments = await _appointmentRepository.getAppointmentsByDoctor(
      doctorId,
    );
    final prescriptions = await _prescriptionRepository
        .getPrescriptionsByDoctor(doctorId);

    final completedAppointments = appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .length;
    final cancelledAppointments = appointments
        .where((a) => a.status == AppointmentStatus.cancelled)
        .length;
    final totalAppointments = appointments.length;

    final completionRate = totalAppointments > 0
        ? (completedAppointments / totalAppointments) * 100
        : 0;

    return {
      'totalAppointments': totalAppointments,
      'completedAppointments': completedAppointments,
      'cancelledAppointments': cancelledAppointments,
      'completionRate': completionRate,
      'totalPrescriptions': prescriptions.length,
      'activePrescriptions': prescriptions.where((p) => p.isValid).length,
    };
  }
}
