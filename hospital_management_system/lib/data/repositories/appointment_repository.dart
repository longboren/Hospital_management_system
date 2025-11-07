import 'dart:convert';
import 'dart:io';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/interfaces.dart';

class AppointmentRepository implements IAppointmentRepository {
  final Map<String, Appointment> _appointmentStorage = {};
  final String _filePath = 'data/appointments.json';

  AppointmentRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final appointment = Appointment.fromJson(jsonItem);
          _appointmentStorage[appointment.id] = appointment;
        }
      }
    } catch (e) {
      print('Error loading appointment data: $e');
    }
  }

  @override
  Future<void> scheduleAppointment(Appointment appointment) async {
    if (_appointmentStorage.containsKey(appointment.id)) {
      throw Exception('Appointment with ID ${appointment.id} already exists');
    }
    _appointmentStorage[appointment.id] = appointment;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList = _appointmentStorage.values
          .map((appointment) => appointment.toJson())
          .toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving appointment data: $e');
    }
  }

  @override
  Future<Appointment?> getAppointmentById(String id) async {
    return _appointmentStorage[id];
  }

  @override
  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    return _appointmentStorage.values
        .where((appointment) => appointment.patientId == patientId)
        .toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId) async {
    return _appointmentStorage.values
        .where((appointment) => appointment.doctorId == doctorId)
        .toList();
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments() async {
    return _appointmentStorage.values.where((a) => a.isUpcoming).toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    return _appointmentStorage.values.where((appointment) {
      return appointment.scheduledTime.year == date.year &&
          appointment.scheduledTime.month == date.month &&
          appointment.scheduledTime.day == date.day;
    }).toList();
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    if (!_appointmentStorage.containsKey(appointment.id)) {
      throw Exception('Appointment with ID ${appointment.id} not found');
    }
    _appointmentStorage[appointment.id] = appointment;
  }

  @override
  Future<bool> cancelAppointment(String id) async {
    final appointment = _appointmentStorage[id];
    if (appointment != null) {
      appointment.cancel();
      await _saveData();
      return true;
    }
    return false;
  }

  // Method to clear all data useful for testing
  Future<void> clearAll() async {
    _appointmentStorage.clear();
    await _saveData();
  }
}
