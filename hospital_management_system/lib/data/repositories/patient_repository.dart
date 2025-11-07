import 'dart:convert';
import 'dart:io';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/interfaces.dart';

class PatientRepository implements IPatientRepository {
  final Map<String, Patient> _patientStorage = {};
  final String _filePath = 'data/patients.json';

  PatientRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final patient = Patient.fromJson(jsonItem);
          _patientStorage[patient.id] = patient;
        }
      }
    } catch (e) {
      print('Error loading patient data: $e');
    }
  }

  @override
  Future<void> addPatient(Patient patient) async {
    if (_patientStorage.containsKey(patient.id)) {
      throw Exception('Patient with ID ${patient.id} already exists');
    }
    _patientStorage[patient.id] = patient;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList =
          _patientStorage.values.map((patient) => patient.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving patient data: $e');
    }
  }

  @override
  Future<Patient?> getPatientById(String id) async {
    return _patientStorage[id];
  }

  @override
  Future<List<Patient>> getAllPatients() async {
    return _patientStorage.values.toList();
  }

  @override
  Future<void> updatePatient(Patient patient) async {
    if (!_patientStorage.containsKey(patient.id)) {
      throw Exception('Patient with ID ${patient.id} not found');
    }
    _patientStorage[patient.id] = patient;
    await _saveData();
  }

  @override
  Future<bool> deletePatient(String id) async {
    if (_patientStorage.containsKey(id)) {
      _patientStorage.remove(id);
      await _saveData();
      return true;
    }
    return false;
  }

  @override
  Future<List<Patient>> searchPatients(String query) async {
    final lowerQuery = query.toLowerCase();
    return _patientStorage.values.where((patient) {
      return patient.name.toLowerCase().contains(lowerQuery) ||
          patient.id.toLowerCase().contains(lowerQuery) ||
          patient.phoneNumber.contains(lowerQuery) ||
          patient.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Method to clear all data (useful for testing)
  Future<void> clearAll() async {
    _patientStorage.clear();
    await _saveData();
  }
}
