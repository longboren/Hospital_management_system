import 'dart:convert';
import 'dart:io';
import '../../domain/entities/prescription.dart';
import '../../domain/repositories/interfaces.dart';

class PrescriptionRepository implements IPrescriptionRepository {
  final Map<String, Prescription> _prescriptionStorage = {};
  final String _filePath = 'data/prescriptions.json';

  PrescriptionRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final prescription = Prescription.fromJson(jsonItem);
          _prescriptionStorage[prescription.id] = prescription;
        }
      }
    } catch (e) {
      print('Error loading prescription data: $e');
    }
  }

  @override
  Future<void> addPrescription(Prescription prescription) async {
    if (_prescriptionStorage.containsKey(prescription.id)) {
      throw Exception('Prescription with ID ${prescription.id} already exists');
    }
    _prescriptionStorage[prescription.id] = prescription;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList = _prescriptionStorage.values
          .map((prescription) => prescription.toJson())
          .toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving prescription data: $e');
    }
  }

  @override
  Future<Prescription?> getPrescriptionById(String id) async {
    return _prescriptionStorage[id];
  }

  @override
  Future<List<Prescription>> getPrescriptionsByPatient(String patientId) async {
    return _prescriptionStorage.values
        .where((prescription) => prescription.patientId == patientId)
        .toList();
  }

  @override
  Future<List<Prescription>> getActivePrescriptions(String patientId) async {
    final prescriptions = await getPrescriptionsByPatient(patientId);
    return prescriptions.where((prescription) => prescription.isValid).toList();
  }

  @override
  Future<void> updatePrescription(Prescription prescription) async {
    if (!_prescriptionStorage.containsKey(prescription.id)) {
      throw Exception('Prescription with ID ${prescription.id} not found');
    }
    _prescriptionStorage[prescription.id] = prescription;
  }

  @override
  Future<List<Prescription>> getPrescriptionsByDoctor(String doctorId) async {
    return _prescriptionStorage.values
        .where((prescription) => prescription.doctorId == doctorId)
        .toList();
  }

  // Method to clear all data (useful for testing)
  Future<void> clearAll() async {
    _prescriptionStorage.clear();
    await _saveData();
  }
}
