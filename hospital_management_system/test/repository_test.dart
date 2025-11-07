import 'package:test/test.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/data/repositories/staff_repository.dart';
import 'package:hospital_management_system/data/repositories/patient_repository.dart';
import 'package:hospital_management_system/data/repositories/room_repository.dart';

void main() {
  group('Repository Tests', () {
    test('Staff Repository CRUD Operations', () async {
      final repository = StaffRepository();

      // Wait for data to load and then clear it
      await Future.delayed(Duration(milliseconds: 100));
      await repository.clearAll();

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

      // Create
      await repository.addStaff(doctor);

      // Read
      final retrieved = await repository.getStaffById('D001');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Dr. Test');

      // Update
      final updatedDoctor = Doctor(
        id: 'D001',
        name: 'Dr. Test Updated',
        email: 'updated@hospital.com',
        phoneNumber: '123-456-7899',
        joinDate: DateTime.now(),
        department: 'Neurology',
        specialization: 'Neurology',
        licenseNumber: 'TEST123',
      );

      await repository.updateStaff(updatedDoctor);
      final afterUpdate = await repository.getStaffById('D001');
      expect(afterUpdate!.name, 'Dr. Test Updated');

      // Delete
      final deleteResult = await repository.deleteStaff('D001');
      expect(deleteResult, isTrue);

      final afterDelete = await repository.getStaffById('D001');
      expect(afterDelete, isNull);
    });

    test('Patient Repository Search Functionality', () async {
      final repository = PatientRepository();

      // Wait for data to load and then clear it
      await Future.delayed(Duration(milliseconds: 100));
      await repository.clearAll();

      final patient1 = Patient(
        id: 'P001',
        name: 'John Smith',
        dateOfBirth: DateTime(1980, 1, 1),
        gender: 'Male',
        phoneNumber: '123-456-7890',
        email: 'john@test.com',
        address: '123 Main St',
        bloodType: 'A+',
        emergencyPhone: '123-456-7891',
      );

      final patient2 = Patient(
        id: 'P002',
        name: 'Maria Garcia',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Female',
        phoneNumber: '123-456-7892',
        email: 'maria@test.com',
        address: '456 Oak Ave',
        bloodType: 'O+',
        emergencyPhone: '123-456-7893',
      );

      await repository.addPatient(patient1);
      await repository.addPatient(patient2);

      // Search by name
      final resultsByName = await repository.searchPatients('john');
      expect(resultsByName.length, 1);
      expect(resultsByName.first.name, 'John Smith');

      // Search by phone
      final resultsByPhone = await repository.searchPatients('7892');
      expect(resultsByPhone.length, 1);
      expect(resultsByPhone.first.phoneNumber, '123-456-7892');

      // Search by email
      final resultsByEmail = await repository.searchPatients('maria@test.com');
      expect(resultsByEmail.length, 1);
      expect(resultsByEmail.first.email, 'maria@test.com');
    });

    test('Room Repository Availability Filtering', () async {
      final repository = RoomRepository();

      // Wait for data to load and then clear it
      await Future.delayed(Duration(milliseconds: 100));
      await repository.clearAll();

      final room1 = Room(
        id: 'R001',
        number: '101',
        type: RoomType.privateRoom,
        capacity: 1,
        pricePerDay: 200.0,
      );

      final room2 = Room(
        id: 'R002',
        number: '102',
        type: RoomType.privateRoom,
        capacity: 1,
        pricePerDay: 200.0,
      );

      await repository.addRoom(room1);
      await repository.addRoom(room2);

      // Assign patient to room1
      room1.beds.first.assignPatient('P001');
      await repository.updateRoom(room1);

      final availableRooms = await repository.getAvailableRooms();
      expect(availableRooms.length, 1);
      expect(availableRooms.first.id, 'R002');
    });
  });
}
