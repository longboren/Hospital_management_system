import 'package:hospital_management_system/data/repositories/staff_repository.dart';
import 'package:hospital_management_system/data/repositories/patient_repository.dart';
import 'package:hospital_management_system/data/repositories/room_repository.dart';
import 'package:hospital_management_system/data/repositories/appointment_repository.dart';
import 'package:hospital_management_system/data/repositories/prescription_repository.dart';
import 'package:hospital_management_system/domain/services/hospital_service.dart';

void main() async {
  print(' Testing doctor display...\n');

  // Initialize repositories
  final staffRepository = StaffRepository();
  final patientRepository = PatientRepository();
  final roomRepository = RoomRepository();
  final appointmentRepository = AppointmentRepository();
  final prescriptionRepository = PrescriptionRepository();

  // Wait for data to load
  await Future.delayed(const Duration(seconds: 1));

  // Initialize service
  final hospitalService = HospitalService(
    staffRepository: staffRepository,
    patientRepository: patientRepository,
    roomRepository: roomRepository,
    appointmentRepository: appointmentRepository,
    prescriptionRepository: prescriptionRepository,
  );

  print('\n ALL DOCTORS');
  print('-' * 60);

  try {
    print('Fetching doctors from service...');
    final doctors = await hospitalService.getDoctors();
    print('Retrieved ${doctors.length} doctors');

    if (doctors.isEmpty) {
      print('No doctors found.');
      return;
    }

    for (int i = 0; i < doctors.length; i++) {
      final doctor = doctors[i];
      print('${i + 1}. ${doctor.name}');
      print('   ID: ${doctor.id}');
      print('   Specialization: ${doctor.specialization}');
      print('   Department: ${doctor.department}');
      print('   Email: ${doctor.email}');
      print('   Phone: ${doctor.phoneNumber}');
      print('   License: ${doctor.licenseNumber}');
      print('   Appointments: ${doctor.appointmentIds.length}');
      if (doctor.qualifications.isNotEmpty) {
        print('   Qualifications: ${doctor.qualifications.join(', ')}');
      }
      print('-' * 40);
    }
  } catch (e, stackTrace) {
    print(' Error fetching doctors: $e');
    print('Stack trace: $stackTrace');
  }

  print('\n Test completed!');
}
