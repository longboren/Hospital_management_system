import 'package:hospital_management_system/domain/entities/prescription.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';

import 'data/repositories/staff_repository.dart';
import 'data/repositories/patient_repository.dart';
import 'data/repositories/room_repository.dart';
import 'data/repositories/appointment_repository.dart';
import 'data/repositories/prescription_repository.dart';
import 'domain/services/hospital_service.dart';
import 'ui/console_ui.dart';

void main() {
  // Initialize repositories
  final staffRepository = StaffRepository();
  final patientRepository = PatientRepository();
  final roomRepository = RoomRepository();
  final appointmentRepository = AppointmentRepository();
  final prescriptionRepository = PrescriptionRepository();

  // Initialize service with dependencies
  final hospitalService = HospitalService(
    staffRepository: staffRepository,
    patientRepository: patientRepository,
    roomRepository: roomRepository,
    appointmentRepository: appointmentRepository,
    prescriptionRepository: prescriptionRepository,
  );

  // Add comprehensive sample data
  _initializeSampleData(hospitalService);

  // Initialize and run UI
  final consoleUI = ConsoleUI(hospitalService);
  consoleUI.run();
}

void _initializeSampleData(HospitalService service) async {
  print('Initializing Hospital Management System...');

  // Sample Doctors
  final doctor1 = Doctor(
    id: 'DOC001',
    name: 'Dr. Sarah Wilson',
    email: 's.wilson@cityhospital.com',
    phoneNumber: '+1-555-0101',
    joinDate: DateTime(2020, 3, 15),
    department: 'Cardiology',
    specialization: 'Cardiovascular Surgery',
    licenseNumber: 'MED123456',
    qualifications: [
      'MD Cardiology',
      'PhD Cardiovascular Research',
      'Board Certified',
    ],
  );

  final doctor2 = Doctor(
    id: 'DOC002',
    name: 'Dr. Michael Chen',
    email: 'm.chen@cityhospital.com',
    phoneNumber: '+1-555-0102',
    joinDate: DateTime(2021, 6, 10),
    department: 'Pediatrics',
    specialization: 'Neonatology',
    licenseNumber: 'MED123457',
    qualifications: ['MD Pediatrics', 'Fellowship in Neonatology'],
  );

  final doctor3 = Doctor(
    id: 'DOC003',
    name: 'Dr. Emily Rodriguez',
    email: 'e.rodriguez@cityhospital.com',
    phoneNumber: '+1-555-0103',
    joinDate: DateTime(2019, 1, 20),
    department: 'Orthopedics',
    specialization: 'Sports Medicine',
    licenseNumber: 'MED123458',
    qualifications: ['MD Orthopedics', 'Sports Medicine Fellowship'],
  );

  // Sample Nurses
  final nurse1 = Nurse(
    id: 'NUR001',
    name: 'Jennifer Martinez',
    email: 'j.martinez@cityhospital.com',
    phoneNumber: '+1-555-0201',
    joinDate: DateTime(2022, 2, 14),
    department: 'Emergency',
    ward: 'ER',
    shift: 'Day',
    specialties: ['Emergency Care', 'Trauma Nursing', 'ACLS Certified'],
  );

  final nurse2 = Nurse(
    id: 'NUR002',
    name: 'Robert Johnson',
    email: 'r.johnson@cityhospital.com',
    phoneNumber: '+1-555-0202',
    joinDate: DateTime(2021, 8, 5),
    department: 'ICU',
    ward: 'Intensive Care Unit',
    shift: 'Night',
    specialties: ['Critical Care', 'Ventilator Management', 'PALS Certified'],
  );

  final admin1 = Administrative(
    id: 'ADM001',
    name: 'Lisa Thompson',
    email: 'l.thompson@cityhospital.com',
    phoneNumber: '+1-555-0301',
    joinDate: DateTime(2018, 4, 12),
    department: 'Administration',
    position: 'Hospital Administrator',
    responsibilities: [
      'Budget Management',
      'Staff Coordination',
      'Policy Implementation',
    ],
  );

  final patient1 = Patient(
    id: 'PAT001',
    name: 'John Smith',
    dateOfBirth: DateTime(1985, 5, 15),
    gender: 'Male',
    phoneNumber: '+1-555-1001',
    email: 'john.smith@email.com',
    address: '123 Main Street, Cityville, State 12345',
    bloodType: 'A+',
    emergencyPhone: '+1-555-1002',
    allergies: ['Penicillin', 'Shellfish'],
    medicalConditions: ['Hypertension', 'Type 2 Diabetes'],
  );

  final patient2 = Patient(
    id: 'PAT002',
    name: 'Maria Garcia',
    dateOfBirth: DateTime(1990, 8, 22),
    gender: 'Female',
    phoneNumber: '+1-555-1003',
    email: 'maria.garcia@email.com',
    address: '456 Oak Avenue, Townsville, State 12346',
    bloodType: 'O-',
    emergencyPhone: '+1-555-1004',
    allergies: ['Latex'],
    medicalConditions: ['Asthma'],
  );

  final patient3 = Patient(
    id: 'PAT003',
    name: 'David Kim',
    dateOfBirth: DateTime(1978, 12, 3),
    gender: 'Male',
    phoneNumber: '+1-555-1005',
    email: 'david.kim@email.com',
    address: '789 Pine Road, Villagetown, State 12347',
    bloodType: 'B+',
    emergencyPhone: '+1-555-1006',
    allergies: ['Peanuts'],
    medicalConditions: ['High Cholesterol'],
  );

  final room1 = Room(
    id: 'RM001',
    number: '101',
    type: RoomType.privateRoom,
    capacity: 1,
    pricePerDay: 250.0,
    equipment: ['TV', 'Private Bathroom', 'WiFi', 'Nurse Call Button'],
  );

  final room2 = Room(
    id: 'RM002',
    number: '102',
    type: RoomType.privateRoom,
    capacity: 1,
    pricePerDay: 250.0,
    equipment: ['TV', 'Private Bathroom', 'WiFi', 'Nurse Call Button'],
  );

  final room3 = Room(
    id: 'RM003',
    number: '201',
    type: RoomType.generalWard,
    capacity: 4,
    pricePerDay: 100.0,
    equipment: ['Shared Bathroom', 'Curtain Dividers', 'Nurse Call Button'],
  );

  final room4 = Room(
    id: 'RM004',
    number: '301',
    type: RoomType.icu,
    capacity: 2,
    pricePerDay: 500.0,
    equipment: ['Ventilator', 'Monitor', 'IV Pump', 'Defibrillator'],
  );

  final room5 = Room(
    id: 'RM005',
    number: '401',
    type: RoomType.emergency,
    capacity: 6,
    pricePerDay: 350.0,
    equipment: ['Trauma Bay', 'Monitor', 'Oxygen Supply', 'Emergency Cart'],
  );

  try {
    // Add staff
    await service.hireStaff(doctor1);
    await service.hireStaff(doctor2);
    await service.hireStaff(doctor3);
    await service.hireStaff(nurse1);
    await service.hireStaff(nurse2);
    await service.hireStaff(admin1);

    // Add patient
    await service.admitPatient(patient1);
    await service.admitPatient(patient2);
    await service.admitPatient(patient3);

    // Add rooms
    await service.addRoom(room1);
    await service.addRoom(room2);
    await service.addRoom(room3);
    await service.addRoom(room4);
    await service.addRoom(room5);

    // Assign some patients to bed
    await service.assignPatientToBed('PAT001', RoomType.privateRoom);
    await service.assignPatientToBed('PAT002', RoomType.generalWard);

    // Create sample appointments
    await service.scheduleAppointment(
      patientId: 'PAT001',
      doctorId: 'DOC001',
      scheduledTime: DateTime.now().add(const Duration(hours: 2)),
      reason: 'Routine cardiac checkup',
      appointmentType: 'Follow-up',
    );

    await service.scheduleAppointment(
      patientId: 'PAT002',
      doctorId: 'DOC002',
      scheduledTime: DateTime.now().add(const Duration(days: 1)),
      reason: 'Pediatric consultation',
      appointmentType: 'Initial Visit',
    );

    // Create sample medications
    final medication1 = Medication(
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'daily',
      cost: 0.50,
    );

    final medication2 = Medication(
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'twice daily',
      cost: 0.25,
    );

    // Create sample prescription
    await service.createPrescription(
      patientId: 'PAT001',
      doctorId: 'DOC001',
      diagnosis: 'Hypertension and Type 2 Diabetes',
      items: [medication1, medication2],
      totalCost: 25.0,
      instructions: 'Take with food. Monitor blood pressure regularly.',
      followUpDate: DateTime.now().add(const Duration(days: 30)),
    );

    print(' Sample data initialized successfully!');
    print(
      ' Loaded: 3 Doctors, 2 Nurses, 1 Admin, 3 Patients, 5 Rooms, 2 Appointments, 1 Prescription',
    );
  } catch (e) {
    print(' Error initializing sample data: $e');
  }
}
