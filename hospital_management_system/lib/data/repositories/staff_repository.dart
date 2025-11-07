import 'dart:convert';
import 'dart:io';
import '../../domain/entities/staff.dart';
import '../../domain/repositories/interfaces.dart';

class StaffRepository implements IStaffRepository {
  final Map<String, Staff> _staffStorage = {};
  final String _filePath = 'data/staff.json';
  bool _isLoaded = false;

  StaffRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final staff = _fromJson(jsonItem);
          _staffStorage[staff.id] = staff;
        }
        _isLoaded = true;
        print('✓ Loaded ${_staffStorage.length} staff members');
      }
    } catch (e) {
      print('Error loading staff data: $e');
      _isLoaded = true; // Mark as loaded even on error to prevent hanging
    }
  }

  Future<void> _ensureLoaded() async {
    int attempts = 0;
    while (!_isLoaded && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
  }

  Staff _fromJson(Map<String, dynamic> json) {
    final role = json['role'];
    switch (role) {
      case 'Doctor':
        return Doctor(
          id: json['id'],
          name: json['name'],
          email: json['email'],
          phoneNumber: json['phoneNumber'],
          joinDate: DateTime.parse(json['joinDate']),
          department: json['department'],
          specialization: json['specialization'],
          licenseNumber: json['licenseNumber'],
          qualifications: List<String>.from(json['qualifications'] ?? []),
        );
      case 'Nurse':
        return Nurse(
          id: json['id'],
          name: json['name'],
          email: json['email'],
          phoneNumber: json['phoneNumber'],
          joinDate: DateTime.parse(json['joinDate']),
          department: json['department'],
          ward: json['ward'],
          shift: json['shift'],
          specialties: List<String>.from(json['specialties'] ?? []),
        );
      case 'Administrative':
        return Administrative(
          id: json['id'],
          name: json['name'],
          email: json['email'],
          phoneNumber: json['phoneNumber'],
          joinDate: DateTime.parse(json['joinDate']),
          department: json['department'],
          position: json['position'],
          responsibilities: List<String>.from(json['responsibilities'] ?? []),
        );
      default:
        throw Exception('Unknown staff role: $role');
    }
  }

  @override
  Future<void> addStaff(Staff staff) async {
    if (_staffStorage.containsKey(staff.id)) {
      throw Exception('Staff with ID ${staff.id} already exists');
    }
    _staffStorage[staff.id] = staff;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList =
          _staffStorage.values.map((staff) => staff.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving staff data: $e');
    }
  }

  @override
  Future<Staff?> getStaffById(String id) async {
    await _ensureLoaded();
    return _staffStorage[id];
  }

  @override
  Future<List<Staff>> getStaffByRole(String role) async {
    await _ensureLoaded();
    print('[Repository] Getting staff by role: $role');
    print('[Repository] Total staff in memory: ${_staffStorage.length}');
    
    final filtered = _staffStorage.values.where((s) => s.role == role).toList();
    print('[Repository] Found ${filtered.length} staff with role $role');
    
    if (filtered.isNotEmpty) {
      print('[Repository] Sample staff: ${filtered.first.name} (${filtered.first.role})');
    }
    
    return filtered;
  }

  @override
  Future<List<Staff>> getAllStaff() async {
    await _ensureLoaded();
    return _staffStorage.values.toList();
  }

  @override
  Future<void> updateStaff(Staff staff) async {
    if (!_staffStorage.containsKey(staff.id)) {
      throw Exception('Staff with ID ${staff.id} not found');
    }
    _staffStorage[staff.id] = staff;
  }

  @override
  Future<bool> deleteStaff(String id) async {
    if (_staffStorage.containsKey(id)) {
      _staffStorage.remove(id);
      await _saveData();
      return true;
    }
    return false;
  }

  // Method to clear all data (useful for testing)
  Future<void> clearAll() async {
    _staffStorage.clear();
    await _saveData();
  }
}
