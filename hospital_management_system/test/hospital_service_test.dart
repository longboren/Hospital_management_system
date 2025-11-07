import 'package:test/test.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/domain/entities/prescription.dart';
import 'package:hospital_management_system/domain/services/hospital_service.dart';
import 'package:hospital_management_system/data/repositories/staff_repository.dart';
import 'package:hospital_management_system/data/repositories/patient_repository.dart';
import 'package:hospital_management_system/data/repositories/room_repository.dart';
import 'package:hospital_management_system/data/repositories/appointment_repository.dart';
import 'package:hospital_management_system/data/repositories/prescription_repository.dart';

void main() {
  group('Hospital Service Integration Tests', () {
    late HospitalService hospitalService;
    late StaffRepository staffRepository;
    late PatientRepository patientRepository;
    late RoomRepository roomRepository;
    late AppointmentRepository appointmentRepository;
    late PrescriptionRepository prescriptionRepository;

    setUp(() async {
      staffRepository = StaffRepository();
      patientRepository = PatientRepository();
      roomRepository = RoomRepository();
      appointmentRepository = AppointmentRepository();
      prescriptionRepository = PrescriptionRepository();

      // Clear all data before each test to ensure clean state
      await Future.delayed(
          Duration(milliseconds: 100)); // Give time for data to load
      await staffRepository.clearAll();
      await patientRepository.clearAll();
      await roomRepository.clearAll();
      await appointmentRepository.clearAll();
      await prescriptionRepository.clearAll();

      hospitalService = HospitalService(
        staffRepository: staffRepository,
        patientRepository: patientRepository,
        roomRepository: roomRepository,
        appointmentRepository: appointmentRepository,
        prescriptionRepository: prescriptionRepository,
      );
    });

    test('Complete Patient Admission and Bed Assignment Flow', () async {
      // Arrange
      final doctor = Doctor(
        id: 'DOC_TEST',
        name: 'Dr. Test Doctor',
        email: 'test@hospital.com',
        phoneNumber: '123-456-7890',
        joinDate: DateTime.now(),
        department: 'Cardiology',
        specialization: 'Cardiology',
        licenseNumber: 'TEST123',
      );

      final patient = Patient(
        id: 'PAT_TEST',
        name: 'Test Patient',
        dateOfBirth: DateTime(1980, 1, 1),
        gender: 'Male',
        phoneNumber: '123-456-7891',
        email: 'patient@test.com',
        address: 'Test Address',
        bloodType: 'A+',
        emergencyPhone: '123-456-7892',
      );

      final room = Room(
        id: 'RM_TEST',
        number: '999',
        type: RoomType.privateRoom,
        capacity: 1,
        pricePerDay: 200.0,
      );

      // Act
      await hospitalService.hireStaff(doctor);
      await hospitalService.admitPatient(patient);
      await hospitalService.addRoom(room);

      final assignedBed = await hospitalService.assignPatientToBed(
        'PAT_TEST',
        RoomType.privateRoom,
      );

      final appointment = await hospitalService.scheduleAppointment(
        patientId: 'PAT_TEST',
        doctorId: 'DOC_TEST',
        scheduledTime: DateTime.now().add(const Duration(hours: 2)),
        reason: 'Test appointment',
      );

      // Assert
      expect(assignedBed, isNotNull);
      expect(assignedBed!.patientId, 'PAT_TEST');
      expect(assignedBed.status, BedStatus.occupied);

      expect(appointment.patientId, 'PAT_TEST');
      expect(appointment.doctorId, 'DOC_TEST');
      expect(appointment.isUpcoming, isTrue);
    });

    test('Hospital Statistics Calculation', () async {
      // Arrange
      final doctor = Doctor(
        id: 'DOC_STATS',
        name: 'Dr. Stats',
        email: 'stats@hospital.com',
        phoneNumber: '123-456-7893',
        joinDate: DateTime.now(),
        department: 'Neurology',
        specialization: 'Neurology',
        licenseNumber: 'STATS123',
      );

      final patient = Patient(
        id: 'PAT_STATS',
        name: 'Stats Patient',
        dateOfBirth: DateTime(1975, 1, 1),
        gender: 'Female',
        phoneNumber: '123-456-7894',
        email: 'stats@patient.com',
        address: 'Stats Address',
        bloodType: 'O+',
        emergencyPhone: '123-456-7895',
      );

      final room = Room(
        id: 'RM_STATS',
        number: '888',
        type: RoomType.generalWard,
        capacity: 4,
        pricePerDay: 150.0,
      );

      // Act
      await hospitalService.hireStaff(doctor);
      await hospitalService.admitPatient(patient);
      await hospitalService.addRoom(room);

      final stats = await hospitalService.getHospitalStats();

      // Assert
      expect(stats['totalStaff'], 1);
      expect(stats['doctors'], 1);
      expect(stats['totalPatients'], 1);
      expect(stats['totalRooms'], 1);
      expect(stats['availableBeds'], 4); // All 4 beds initially available
    });

    test('Prescription Management Flow', () async {
      // Arrange
      final doctor = Doctor(
        id: 'DOC_RX',
        name: 'Dr. Prescription',
        email: 'rx@hospital.com',
        phoneNumber: '123-456-7896',
        joinDate: DateTime.now(),
        department: 'Internal Medicine',
        specialization: 'Internal Medicine',
        licenseNumber: 'RX123',
      );

      final patient = Patient(
        id: 'PAT_RX',
        name: 'RX Patient',
        dateOfBirth: DateTime(1985, 1, 1),
        gender: 'Male',
        phoneNumber: '123-456-7897',
        email: 'rx@patient.com',
        address: 'RX Address',
        bloodType: 'B+',
        emergencyPhone: '123-456-7898',
      );

      final items = [
        Medication(
          name: 'Test Medication',
          dosage: '500mg',
          frequency: 'daily',
          cost: 1.0,
        ),
      ];

      // Act
      await hospitalService.hireStaff(doctor);
      await hospitalService.admitPatient(patient);

      final prescription = await hospitalService.createPrescription(
        patientId: 'PAT_RX',
        doctorId: 'DOC_RX',
        items: items,
        totalCost: 1.0,
        instructions: 'Take with food',
        diagnosis: 'Test diagnosis',
      );

      final patientPrescriptions =
          await hospitalService.getPatientPrescriptions('PAT_RX');
      final activePrescriptions = await hospitalService.getActivePrescriptions(
        'PAT_RX',
      );

      // Assert
      expect(prescription.patientId, 'PAT_RX');
      expect(prescription.doctorId, 'DOC_RX');
      expect(prescription.items.length, 1);
      expect(prescription.isValid, isTrue);

      expect(patientPrescriptions.length, 1);
      expect(activePrescriptions.length, 1);
    });

    test('Doctor Performance Metrics', () async {
      // Arrange
      final doctor = Doctor(
        id: 'DOC_PERF',
        name: 'Dr. Performance',
        email: 'perf@hospital.com',
        phoneNumber: '123-456-7899',
        joinDate: DateTime.now(),
        department: 'Surgery',
        specialization: 'General Surgery',
        licenseNumber: 'PERF123',
      );

      final patient = Patient(
        id: 'PAT_PERF',
        name: 'Perf Patient',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Female',
        phoneNumber: '123-456-7900',
        email: 'perf@patient.com',
        address: 'Perf Address',
        bloodType: 'AB+',
        emergencyPhone: '123-456-7901',
      );

      // Act
      await hospitalService.hireStaff(doctor);
      await hospitalService.admitPatient(patient);

      // Schedule and complete an appointment
      final appointment = await hospitalService.scheduleAppointment(
        patientId: 'PAT_PERF',
        doctorId: 'DOC_PERF',
        scheduledTime: DateTime.now().add(const Duration(minutes: 30)),
        reason: 'Performance test',
      );

      await hospitalService.startAppointment(appointment.id);
      await hospitalService.completeAppointment(appointment.id, 'Test notes');

      final performance = await hospitalService.getDoctorPerformance(
        'DOC_PERF',
      );

      // Assert
      expect(performance['totalAppointments'], 1);
      expect(performance['completedAppointments'], 1);
      expect(performance['completionRate'], 100.0);
    });
  });
}
