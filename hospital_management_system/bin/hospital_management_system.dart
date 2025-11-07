import 'package:hospital_management_system/data/repositories/staff_repository.dart';
import 'package:hospital_management_system/data/repositories/patient_repository.dart';
import 'package:hospital_management_system/data/repositories/room_repository.dart';
import 'package:hospital_management_system/data/repositories/appointment_repository.dart';
import 'package:hospital_management_system/data/repositories/prescription_repository.dart';
import 'package:hospital_management_system/domain/services/hospital_service.dart';
import 'package:hospital_management_system/ui/console_ui.dart';

void main(List<String> arguments) async {
  print('🔄 Loading Hospital Management System...\n');

  // Initialize repositories
  final staffRepository = StaffRepository();
  final patientRepository = PatientRepository();
  final roomRepository = RoomRepository();
  final appointmentRepository = AppointmentRepository();
  final prescriptionRepository = PrescriptionRepository();

  // Give sufficient time for repositories to load data from JSON files
  // The repository constructors call async _loadData() but can't await it
  // so we need to wait for the data to load
  await Future.delayed(const Duration(seconds: 1));

  // Initialize service with dependencies
  final hospitalService = HospitalService(
    staffRepository: staffRepository,
    patientRepository: patientRepository,
    roomRepository: roomRepository,
    appointmentRepository: appointmentRepository,
    prescriptionRepository: prescriptionRepository,
  );

  // Verify data is loaded and show summary
  try {
    final stats = await hospitalService.getHospitalStats();
    print('✅ System Initialized Successfully!');
    print('━' * 50);
    print('📊 Data Loaded:');
    print(
        '   👨‍⚕️ Staff: ${stats['totalStaff']} (${stats['doctors']} Doctors, ${stats['nurses']} Nurses, ${stats['administrative']} Admin)');
    print('   👤 Patients: ${stats['totalPatients']}');
    print(
        '   🏨 Rooms: ${stats['totalRooms']} (${stats['availableBeds']} beds available)');
    print('   📅 Upcoming Appointments: ${stats['upcomingAppointments']}');
    print('━' * 50);
    print('');
  } catch (e) {
    print('⚠️  Warning: Could not load statistics: $e');
    print('');
  }

  // Initialize and run UI
  final consoleUI = ConsoleUI(hospitalService);
  await consoleUI.run();
}
