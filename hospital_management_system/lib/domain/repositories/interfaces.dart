import '../entities/staff.dart';
import '../entities/patient.dart';
import '../entities/room.dart';
import '../entities/appointment.dart';
import '../entities/prescription.dart';

// Repository interfaces for dependency inversion
abstract class IStaffRepository {
  Future<void> addStaff(Staff staff);
  Future<Staff?> getStaffById(String id);
  Future<List<Staff>> getStaffByRole(String role);
  Future<List<Staff>> getAllStaff();
  Future<void> updateStaff(Staff staff);
  Future<bool> deleteStaff(String id);
}

abstract class IPatientRepository {
  Future<void> addPatient(Patient patient);
  Future<Patient?> getPatientById(String id);
  Future<List<Patient>> getAllPatients();
  Future<void> updatePatient(Patient patient);
  Future<bool> deletePatient(String id);
  Future<List<Patient>> searchPatients(String query);
}

abstract class IRoomRepository {
  Future<void> addRoom(Room room);
  Future<Room?> getRoomById(String id);
  Future<List<Room>> getRoomsByType(RoomType type);
  Future<List<Room>> getAllRooms();
  Future<void> updateRoom(Room room);
  Future<List<Room>> getAvailableRooms();
}

abstract class IAppointmentRepository {
  Future<void> scheduleAppointment(Appointment appointment);
  Future<Appointment?> getAppointmentById(String id);
  Future<List<Appointment>> getAppointmentsByPatient(String patientId);
  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId);
  Future<List<Appointment>> getUpcomingAppointments();
  Future<List<Appointment>> getAppointmentsByDate(DateTime date);
  Future<void> updateAppointment(Appointment appointment);
  Future<bool> cancelAppointment(String id);
}

abstract class IPrescriptionRepository {
  Future<void> addPrescription(Prescription prescription);
  Future<Prescription?> getPrescriptionById(String id);
  Future<List<Prescription>> getPrescriptionsByPatient(String patientId);
  Future<List<Prescription>> getActivePrescriptions(String patientId);
  Future<void> updatePrescription(Prescription prescription);
  Future<List<Prescription>> getPrescriptionsByDoctor(String doctorId);
}
