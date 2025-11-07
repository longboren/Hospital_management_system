import 'package:test/test.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/domain/entities/appointment.dart';
import 'package:hospital_management_system/domain/entities/prescription.dart';

void main() {
  group('Domain Entities Unit Tests', () {
    test('Staff Inheritance and Role Assignment', () {
      final doctor = Doctor(
        id: 'D001',
        name: 'Dr. Test',
        email: 'test@hospital.com',
        phoneNumber: '123-456-7890',
        joinDate: DateTime.now(),
        department: 'Cardiology',
        specialization: 'Cardiology',
        licenseNumber: 'TEST123',
      );

      final nurse = Nurse(
        id: 'N001',
        name: 'Nurse Test',
        email: 'nurse@hospital.com',
        phoneNumber: '123-456-7891',
        joinDate: DateTime.now(),
        department: 'Emergency',
        ward: 'ER',
        shift: 'Day',
      );

      final admin = Administrative(
        id: 'A001',
        name: 'Admin Test',
        email: 'admin@hospital.com',
        phoneNumber: '123-456-7892',
        joinDate: DateTime.now(),
        department: 'Administration',
        position: 'Manager',
      );

      expect(doctor, isA<Staff>());
      expect(doctor.role, 'Doctor');
      expect(nurse.role, 'Nurse');
      expect(admin.role, 'Administrative');
    });

    test('Patient Age Calculation and Medical Records', () {
      final now = DateTime.now();
      final birthDate = DateTime(now.year - 30, now.month, now.day);
      final patient = Patient(
        id: 'P001',
        name: 'Test Patient',
        dateOfBirth: birthDate,
        gender: 'Male',
        phoneNumber: '123-456-7890',
        email: 'patient@test.com',
        address: 'Test Address',
        bloodType: 'A+',
        emergencyPhone: '123-456-7891',
        allergies: ['Penicillin'],
        medicalConditions: ['Hypertension'],
      );

      expect(patient.age, 30);
      expect(patient.allergies, contains('Penicillin'));
      expect(patient.medicalConditions, contains('Hypertension'));

      patient.addAllergy('Latex');
      expect(patient.allergies, contains('Latex'));

      patient.addMedicalCondition('Diabetes');
      expect(patient.medicalConditions, contains('Diabetes'));
    });

    test('Room and Bed Management', () {
      final room = Room(
        id: 'R001',
        number: '101',
        type: RoomType.privateRoom,
        capacity: 2,
        pricePerDay: 200.0,
      );

      expect(room.beds.length, 2);
      expect(room.availableBedsCount, 2);

      final bed = room.getAvailableBed();
      expect(bed, isNotNull);

      bed!.assignPatient('P001');
      expect(room.availableBedsCount, 1);
      expect(bed.status, BedStatus.occupied);
      expect(bed.patientId, 'P001');

      bed.dischargePatient();
      expect(room.availableBedsCount, 2);
      expect(bed.status, BedStatus.available);
      expect(bed.patientId, isNull);
    });

    test('Appointment Lifecycle', () {
      final appointment = Appointment(
        id: 'A001',
        patientId: 'P001',
        doctorId: 'D001',
        scheduledTime: DateTime.now().add(const Duration(hours: 2)),
        reason: 'Checkup',
      );

      expect(appointment.status, AppointmentStatus.scheduled);
      expect(appointment.isUpcoming, isTrue);

      appointment.startAppointment();
      expect(appointment.status, AppointmentStatus.inProgress);
      expect(appointment.actualStartTime, isNotNull);

      appointment.complete();
      expect(appointment.status, AppointmentStatus.completed);
      expect(appointment.actualEndTime, isNotNull);

      expect(appointment.duration, isNotNull);
    });

    test('Prescription and Medication Management', () {
      final medication = Medication(
        name: 'Test Medication',
        dosage: '500mg',
        frequency: 'daily',
        cost: 10.0,
      );

      final prescription = Prescription(
        id: 'RX001',
        patientId: 'P001',
        doctorId: 'D001',
        issueDate: DateTime.now(),
        diagnosis: 'Test Diagnosis',
        items: [medication],
        totalCost: 10.0,
        instructions: 'Test Instructions',
      );

      expect(prescription.items.length, 1);

      final item = prescription.items.first;
      expect(item.name, 'Test Medication');
      expect(item.isValid, isTrue);
      expect(item.cost, greaterThan(0));

      expect(prescription.totalCost, greaterThan(0));
      expect(prescription.isValid, isTrue);
    });

    test('JSON Serialization', () {
      final doctor = Doctor(
        id: 'D001',
        name: 'Dr. Test',
        email: 'test@hospital.com',
        phoneNumber: '123-456-7890',
        joinDate: DateTime.now(),
        department: 'Cardiology',
        specialization: 'Cardiology',
        licenseNumber: 'TEST123',
      );

      final patient = Patient(
        id: 'P001',
        name: 'Test Patient',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Male',
        phoneNumber: '123-456-7891',
        email: 'patient@test.com',
        address: 'Test Address',
        bloodType: 'A+',
        emergencyPhone: '123-456-7892',
      );

      final doctorJson = doctor.toJson();
      final patientJson = patient.toJson();

      expect(doctorJson['id'], 'D001');
      expect(doctorJson['role'], 'Doctor');
      expect(patientJson['id'], 'P001');
      expect(patientJson['age'], greaterThan(20));
    });
  });
}
