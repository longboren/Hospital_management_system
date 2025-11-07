import 'dart:io';
import '../domain/entities/staff.dart';
import '../domain/entities/patient.dart';
import '../domain/entities/room.dart';
import '../domain/entities/appointment.dart';
import '../domain/entities/prescription.dart';
import '../domain/services/hospital_service.dart';

class ConsoleUI {
  final HospitalService _hospitalService;

  ConsoleUI(this._hospitalService);

  Future<void> run() async {
    _printWelcomeMessage();

    while (true) {
      _displayMainMenu();
      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          await _manageStaff();
          break;
        case '2':
          await _managePatients();
          break;
        case '3':
          await _manageRooms();
          break;
        case '4':
          await _manageAppointments();
          break;
        case '5':
          await _managePrescriptions();
          break;
        case '6':
          await _viewReports();
          break;
        case '0':
          print('\n👋 Thank you for using Hospital Management System!');
          print('Goodbye!');
          exit(0);
        default:
          print('❌ Invalid choice. Please try again.');
      }
    }
  }

  void _printWelcomeMessage() {
    print('''
    
╔══════════════════════════════════════════════════════════════╗
║                   HOSPITAL MANAGEMENT SYSTEM                 ║
║                      Version 1.0.0                          ║
║                  Professional Edition                       ║
╚══════════════════════════════════════════════════════════════╝
    ''');
  }

  void _displayMainMenu() {
    print('\n${'=' * 60}');
    print('🏥 MAIN MENU');
    print('=' * 60);
    print('1. 👨‍⚕️  Staff Management');
    print('2. 👤 Patient Management');
    print('3. 🏨 Room & Bed Management');
    print('4. 📅 Appointment Management');
    print('5. 💊 Prescription Management');
    print('6. 📊 Reports & Analytics');
    print('0. 🚪 Exit');
    print('-' * 60);
  }

  // Staff Management
  Future<void> _manageStaff() async {
    while (true) {
      print('\n👨‍⚕️ STAFF MANAGEMENT');
      print('-' * 40);
      print('1. Hire New Doctor');
      print('2. Hire New Nurse');
      print('3. Hire Administrative Staff');
      print('4. View All Doctors');
      print('5. View All Nurses');
      print('6. Search Staff');
      print('0. Back to Main Menu');

      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          _hireDoctor();
          break;
        case '2':
          _hireNurse();
          break;
        case '3':
          _hireAdministrative();
          break;
        case '4':
          await _viewAllDoctors();
          break;
        case '5':
          await _viewAllNurses();
          break;
        case '6':
          await _searchStaff();
          break;
        case '0':
          return;
        default:
          print('❌ Invalid choice.');
      }
    }
  }

  void _hireDoctor() async {
    print('\n🎓 HIRE NEW DOCTOR');
    print('-' * 40);

    try {
      final id = _getUserInput('Enter Doctor ID: ');
      final name = _getUserInput('Enter Full Name: ');
      final email = _getUserInput('Enter Email: ');
      final phone = _getUserInput('Enter Phone Number: ');
      final department = _getUserInput('Enter Department: ');
      final specialization = _getUserInput('Enter Specialization: ');
      final license = _getUserInput('Enter License Number: ');

      final qualificationsInput = _getUserInput(
        'Enter Qualifications (comma-separated): ',
      );
      final qualifications = qualificationsInput
          .split(',')
          .map((q) => q.trim())
          .where((q) => q.isNotEmpty)
          .toList();

      final doctor = Doctor(
        id: id,
        name: name,
        email: email,
        phoneNumber: phone,
        joinDate: DateTime.now(),
        department: department,
        specialization: specialization,
        licenseNumber: license,
        qualifications: qualifications,
      );

      await _hospitalService.hireStaff(doctor);
      print('✅ Doctor hired successfully!');
      _printStaffDetails(doctor);
    } catch (e) {
      print('❌ Error hiring doctor: $e');
    }
  }

  void _hireNurse() async {
    print('\n👩‍⚕️ HIRE NEW NURSE');
    print('-' * 40);

    try {
      final id = _getUserInput('Enter Nurse ID: ');
      final name = _getUserInput('Enter Full Name: ');
      final email = _getUserInput('Enter Email: ');
      final phone = _getUserInput('Enter Phone Number: ');
      final department = _getUserInput('Enter Department: ');
      final ward = _getUserInput('Enter Ward: ');
      final shift = _getUserInput('Enter Shift (Day/Night): ');

      final specialtiesInput = _getUserInput(
        'Enter Specialties (comma-separated): ',
      );
      final specialties = specialtiesInput
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final nurse = Nurse(
        id: id,
        name: name,
        email: email,
        phoneNumber: phone,
        joinDate: DateTime.now(),
        department: department,
        ward: ward,
        shift: shift,
        specialties: specialties,
      );

      await _hospitalService.hireStaff(nurse);
      print('✅ Nurse hired successfully!');
      _printStaffDetails(nurse);
    } catch (e) {
      print('❌ Error hiring nurse: $e');
    }
  }

  void _hireAdministrative() async {
    print('\n💼 HIRE ADMINISTRATIVE STAFF');
    print('-' * 40);

    try {
      final id = _getUserInput('Enter Staff ID: ');
      final name = _getUserInput('Enter Full Name: ');
      final email = _getUserInput('Enter Email: ');
      final phone = _getUserInput('Enter Phone Number: ');
      final department = _getUserInput('Enter Department: ');
      final position = _getUserInput('Enter Position: ');

      final responsibilitiesInput = _getUserInput(
        'Enter Responsibilities (comma-separated): ',
      );
      final responsibilities = responsibilitiesInput
          .split(',')
          .map((r) => r.trim())
          .where((r) => r.isNotEmpty)
          .toList();

      final admin = Administrative(
        id: id,
        name: name,
        email: email,
        phoneNumber: phone,
        joinDate: DateTime.now(),
        department: department,
        position: position,
        responsibilities: responsibilities,
      );

      await _hospitalService.hireStaff(admin);
      print('✅ Administrative staff hired successfully!');
      _printStaffDetails(admin);
    } catch (e) {
      print('❌ Error hiring administrative staff: $e');
    }
  }

  Future<void> _viewAllDoctors() async {
    print('\n👨‍⚕️ ALL DOCTORS');
    print('-' * 60);

    try {
      print('Fetching doctors from service...');
      final doctors = await _hospitalService.getDoctors();
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
    } catch (e) {
      print('❌ Error fetching doctors: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _viewAllNurses() async {
    print('\n👩‍⚕️ ALL NURSES');
    print('-' * 60);

    try {
      final nurses = await _hospitalService.getNurses();

      if (nurses.isEmpty) {
        print('No nurses found.');
        return;
      }

      for (int i = 0; i < nurses.length; i++) {
        final nurse = nurses[i];
        print('${i + 1}. ${nurse.name}');
        print('   ID: ${nurse.id}');
        print('   Ward: ${nurse.ward}');
        print('   Shift: ${nurse.shift}');
        print('   Department: ${nurse.department}');
        print('   Email: ${nurse.email}');
        print('   Phone: ${nurse.phoneNumber}');
        if (nurse.specialties.isNotEmpty) {
          print('   Specialties: ${nurse.specialties.join(', ')}');
        }
        print('-' * 40);
      }
    } catch (e) {
      print('❌ Error fetching nurses: $e');
    }
  }

  Future<void> _searchStaff() async {
    final query = _getUserInput('Enter staff name or ID to search: ');
    if (query.isEmpty) return;

    try {
      final allStaff = await _hospitalService.getAllStaff();
      final results = allStaff.where((staff) {
        return staff.name.toLowerCase().contains(query.toLowerCase()) ||
            staff.id.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (results.isEmpty) {
        print('❌ No staff found matching "$query"');
        return;
      }

      print('\n🔍 SEARCH RESULTS');
      print('-' * 50);
      for (final staff in results) {
        _printStaffDetails(staff);
      }
    } catch (e) {
      print('❌ Error searching staff: $e');
    }
  }

  void _printStaffDetails(Staff staff) {
    print('\n📋 STAFF DETAILS');
    print('-' * 30);
    print('ID: ${staff.id}');
    print('Name: ${staff.name}');
    print('Role: ${staff.role}');
    print('Department: ${staff.department}');
    print('Email: ${staff.email}');
    print('Phone: ${staff.phoneNumber}');
    print('Join Date: ${_formatDate(staff.joinDate)}');

    if (staff is Doctor) {
      print('Specialization: ${staff.specialization}');
      print('License: ${staff.licenseNumber}');
      if (staff.qualifications.isNotEmpty) {
        print('Qualifications: ${staff.qualifications.join(', ')}');
      }
    } else if (staff is Nurse) {
      print('Ward: ${staff.ward}');
      print('Shift: ${staff.shift}');
      if (staff.specialties.isNotEmpty) {
        print('Specialties: ${staff.specialties.join(', ')}');
      }
    } else if (staff is Administrative) {
      print('Position: ${staff.position}');
      if (staff.responsibilities.isNotEmpty) {
        print('Responsibilities: ${staff.responsibilities.join(', ')}');
      }
    }
  }

  // Patient Management
  Future<void> _managePatients() async {
    while (true) {
      print('\n👤 PATIENT MANAGEMENT');
      print('-' * 40);
      print('1. Admit New Patient');
      print('2. View All Patients');
      print('3. Search Patient');
      print('4. Assign Patient to Bed');
      print('5. Discharge Patient');
      print('0. Back to Main Menu');

      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          await _admitPatient();
          break;
        case '2':
          await _viewAllPatients();
          break;
        case '3':
          await _searchPatient();
          break;
        case '4':
          await _assignPatientToBed();
          break;
        case '5':
          await _dischargePatient();
          break;
        case '0':
          return;
        default:
          print('❌ Invalid choice.');
      }
    }
  }

  Future<void> _admitPatient() async {
    print('\n🏥 ADMIT NEW PATIENT');
    print('-' * 40);

    try {
      final id = _getUserInput('Enter Patient ID: ');
      final name = _getUserInput('Enter Full Name: ');
      final dobInput = _getUserInput('Enter Date of Birth (YYYY-MM-DD): ');
      final gender = _getUserInput('Enter Gender: ');
      final phone = _getUserInput('Enter Phone Number: ');
      final email = _getUserInput('Enter Email: ');
      final address = _getUserInput('Enter Address: ');
      final bloodType = _getUserInput('Enter Blood Type: ');
      final emergencyPhone = _getUserInput('Enter Emergency Contact Phone: ');

      final allergiesInput = _getUserInput(
        'Enter Allergies (comma-separated): ',
      );
      final allergies = allergiesInput
          .split(',')
          .map((a) => a.trim())
          .where((a) => a.isNotEmpty)
          .toList();

      final conditionsInput = _getUserInput(
        'Enter Medical Conditions (comma-separated): ',
      );
      final conditions = conditionsInput
          .split(',')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();

      final patient = Patient(
        id: id,
        name: name,
        dateOfBirth: DateTime.parse(dobInput),
        gender: gender,
        phoneNumber: phone,
        email: email,
        address: address,
        bloodType: bloodType,
        emergencyPhone: emergencyPhone,
        allergies: allergies,
        medicalConditions: conditions,
      );

      await _hospitalService.admitPatient(patient);
      print('✅ Patient admitted successfully!');
      _printPatientDetails(patient);
    } catch (e) {
      print('❌ Error admitting patient: $e');
    }
  }

  Future<void> _viewAllPatients() async {
    print('\n👤 ALL PATIENTS');
    print('-' * 60);

    try {
      final patients = await _hospitalService.getAllPatients();

      if (patients.isEmpty) {
        print('No patients found.');
        return;
      }

      for (int i = 0; i < patients.length; i++) {
        final patient = patients[i];
        print('${i + 1}. ${patient.name} (${patient.age} years)');
        print('   ID: ${patient.id}');
        print('   Gender: ${patient.gender}');
        print('   Phone: ${patient.phoneNumber}');
        print('   Blood Type: ${patient.bloodType}');
        print('   Appointments: ${patient.appointmentIds.length}');
        print('   Prescriptions: ${patient.prescriptionIds.length}');
        print('-' * 40);
      }
    } catch (e) {
      print('❌ Error fetching patients: $e');
    }
  }

  Future<void> _searchPatient() async {
    final query = _getUserInput('Enter patient name, ID, or phone to search: ');
    if (query.isEmpty) return;

    try {
      final results = await _hospitalService.searchPatients(query);

      if (results.isEmpty) {
        print('❌ No patients found matching "$query"');
        return;
      }

      print('\n🔍 SEARCH RESULTS');
      print('-' * 50);
      for (final patient in results) {
        _printPatientDetails(patient);
      }
    } catch (e) {
      print('❌ Error searching patients: $e');
    }
  }

  Future<void> _assignPatientToBed() async {
    print('\n🛏️ ASSIGN PATIENT TO BED');
    print('-' * 40);

    try {
      final patientId = _getUserInput('Enter Patient ID: ');
      final patient = await _hospitalService.getPatientById(patientId);

      if (patient == null) {
        print('❌ Patient not found.');
        return;
      }

      for (final type in RoomType.values) {
        print('${type.index + 1}. ${type.displayName}');
      }

      final roomChoice = _getUserInput('Select room type (number): ');
      final roomType = RoomType.values[int.parse(roomChoice) - 1];

      final bed = await _hospitalService.assignPatientToBed(
        patientId,
        roomType,
      );

      if (bed != null) {
        print('✅ Patient assigned to bed successfully!');
        print('Bed ID: ${bed.id}');
        print('Room ID: ${bed.roomId}');
        print('Bed Number: ${bed.bedNumber}');
        print('Assigned Date: ${_formatDate(DateTime.now())}');
      } else {
        print('❌ No available beds found for the selected room type.');
      }
    } catch (e) {
      print('❌ Error assigning patient to bed: $e');
    }
  }

  Future<void> _dischargePatient() async {
    final patientId = _getUserInput('Enter Patient ID to discharge: ');

    try {
      await _hospitalService.dischargePatientFromBed(patientId);
      print('✅ Patient discharged successfully!');
    } catch (e) {
      print('❌ Error discharging patient: $e');
    }
  }

  void _printPatientDetails(Patient patient) {
    print('\n📋 PATIENT DETAILS');
    print('-' * 30);
    print('ID: ${patient.id}');
    print('Name: ${patient.name}');
    print('Age: ${patient.age} years');
    print('Gender: ${patient.gender}');
    print('Phone: ${patient.phoneNumber}');
    print('Email: ${patient.email}');
    print('Address: ${patient.address}');
    print('Blood Type: ${patient.bloodType}');
    print(
      'Emergency Contact: ${patient.emergencyPhone}',
    );

    if (patient.allergies.isNotEmpty) {
      print('Allergies: ${patient.allergies.join(', ')}');
    }

    if (patient.medicalConditions.isNotEmpty) {
      print('Medical Conditions: ${patient.medicalConditions.join(', ')}');
    }

    print('Total Appointments: ${patient.appointmentIds.length}');
    print('Total Prescriptions: ${patient.prescriptionIds.length}');
  }

  // Room Management
  Future<void> _manageRooms() async {
    while (true) {
      print('\n🏨 ROOM MANAGEMENT');
      print('-' * 40);
      print('1. Add New Room');
      print('2. View All Rooms');
      print('3. View Available Rooms');
      print('4. View Room Details');
      print('0. Back to Main Menu');

      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          await _addRoom();
          break;
        case '2':
          await _viewAllRooms();
          break;
        case '3':
          await _viewAvailableRooms();
          break;
        case '4':
          await _viewRoomDetails();
          break;
        case '0':
          return;
        default:
          print('❌ Invalid choice.');
      }
    }
  }

  Future<void> _addRoom() async {
    print('\n➕ ADD NEW ROOM');
    print('-' * 40);

    try {
      final id = _getUserInput('Enter Room ID: ');
      final number = _getUserInput('Enter Room Number: ');

      print('\nSelect Room Type:');
      for (final type in RoomType.values) {
        print('${type.index + 1}. ${type.displayName}');
      }

      final typeChoice = _getUserInput('Enter room type (number): ');
      final roomType = RoomType.values[int.parse(typeChoice) - 1];

      final capacity = int.parse(_getUserInput('Enter Room Capacity: '));
      final price = double.parse(_getUserInput('Enter Price per Day: '));

      final equipmentInput = _getUserInput(
        'Enter Equipment (comma-separated): ',
      );
      final equipment = equipmentInput
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final room = Room(
        id: id,
        number: number,
        type: roomType,
        capacity: capacity,
        pricePerDay: price,
        equipment: equipment,
      );

      await _hospitalService.addRoom(room);
      print('✅ Room added successfully!');
      _printRoomDetails(room);
    } catch (e) {
      print('❌ Error adding room: $e');
    }
  }

  Future<void> _viewAllRooms() async {
    print('\n🏨 ALL ROOMS');
    print('-' * 60);

    try {
      final rooms = await _hospitalService.getAllRooms();

      if (rooms.isEmpty) {
        print('No rooms found.');
        return;
      }

      for (final room in rooms) {
        _printRoomSummary(room);
      }
    } catch (e) {
      print('❌ Error fetching rooms: $e');
    }
  }

  Future<void> _viewAvailableRooms() async {
    print('\n✅ AVAILABLE ROOMS');
    print('-' * 60);

    try {
      final rooms = await _hospitalService.getAvailableRooms();

      if (rooms.isEmpty) {
        print('No available rooms found.');
        return;
      }

      for (final room in rooms) {
        _printRoomSummary(room);
      }
    } catch (e) {
      print('❌ Error fetching available rooms: $e');
    }
  }

  Future<void> _viewRoomDetails() async {
    final roomId = _getUserInput('Enter Room ID: ');

    try {
      // This would need a getRoomById method in the service
      final allRooms = await _hospitalService.getAllRooms();
      final room = allRooms.firstWhere((r) => r.id == roomId);

      _printRoomDetails(room);
    } catch (e) {
      print('❌ Room not found or error fetching room details: $e');
    }
  }

  void _printRoomSummary(Room room) {
    print('${room.number} - ${room.type.displayName}');
    print('   ID: ${room.id}');
    print('   Capacity: ${room.capacity} beds');
    print('   Available: ${room.availableBedsCount} beds');
    print('   Occupied: ${room.occupiedBedsCount} beds');
    print('   Price: \$${room.pricePerDay}/day');
    print('-' * 40);
  }

  void _printRoomDetails(Room room) {
    print('\n🏨 ROOM DETAILS');
    print('-' * 30);
    print('ID: ${room.id}');
    print('Number: ${room.number}');
    print('Type: ${room.type.displayName}');
    print('Capacity: ${room.capacity} beds');
    print('Available Beds: ${room.availableBedsCount}');
    print('Occupied Beds: ${room.occupiedBedsCount}');
    print('Maintenance Beds: ${room.maintenanceBedsCount}');
    print('Price per Day: \$${room.pricePerDay}');

    if (room.equipment.isNotEmpty) {
      print('Equipment: ${room.equipment.join(', ')}');
    }

    print('\nBeds:');
    for (final bed in room.beds) {
      final status = bed.status == BedStatus.available
          ? '✅ Available'
          : bed.status == BedStatus.occupied
              ? '🛌 Occupied'
              : '🔧 Maintenance';
      print('  Bed ${bed.bedNumber}: $status');
      if (bed.patientId != null) {
        print('    Patient ID: ${bed.patientId}');
        print('    Assigned: ${_formatDate(bed.assignedDate!)}');
      }
    }
  }

  // Appointment Management
  Future<void> _manageAppointments() async {
    while (true) {
      print('\n📅 APPOINTMENT MANAGEMENT');
      print('-' * 40);
      print('1. Schedule New Appointment');
      print('2. View Upcoming Appointments');
      print('3. View Doctor Appointments');
      print('4. Start Appointment');
      print('5. Complete Appointment');
      print('0. Back to Main Menu');

      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          await _scheduleAppointment();
          break;
        case '2':
          await _viewUpcomingAppointments();
          break;
        case '3':
          await _viewDoctorAppointments();
          break;
        case '4':
          await _startAppointment();
          break;
        case '5':
          await _completeAppointment();
          break;
        case '0':
          return;
        default:
          print('❌ Invalid choice.');
      }
    }
  }

  Future<void> _scheduleAppointment() async {
    print('\n📅 SCHEDULE NEW APPOINTMENT');
    print('-' * 40);

    try {
      final patientId = _getUserInput('Enter Patient ID: ');
      final doctorId = _getUserInput('Enter Doctor ID: ');
      final dateInput = _getUserInput('Enter Appointment Date (YYYY-MM-DD): ');
      final timeInput = _getUserInput('Enter Appointment Time (HH:MM): ');
      final reason = _getUserInput('Enter Reason: ');
      final type = _getUserInput('Enter Appointment Type (optional): ');

      final date = DateTime.parse(dateInput);
      final timeParts = timeInput.split(':');
      final scheduledTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      final appointment = await _hospitalService.scheduleAppointment(
        patientId: patientId,
        doctorId: doctorId,
        scheduledTime: scheduledTime,
        reason: reason,
        appointmentType: type.isEmpty ? null : type,
      );

      print('✅ Appointment scheduled successfully!');
      _printAppointmentDetails(appointment);
    } catch (e) {
      print('❌ Error scheduling appointment: $e');
    }
  }

  Future<void> _viewUpcomingAppointments() async {
    print('\n📅 UPCOMING APPOINTMENTS');
    print('-' * 60);

    try {
      final appointments = await _hospitalService.getUpcomingAppointments();

      if (appointments.isEmpty) {
        print('No upcoming appointments.');
        return;
      }

      for (final appointment in appointments) {
        _printAppointmentSummary(appointment);
      }
    } catch (e) {
      print('❌ Error fetching appointments: $e');
    }
  }

  Future<void> _viewDoctorAppointments() async {
    final doctorId = _getUserInput('Enter Doctor ID: ');

    try {
      final appointments = await _hospitalService.getAppointmentsByDoctor(
        doctorId,
      );

      if (appointments.isEmpty) {
        print('No appointments found for this doctor.');
        return;
      }

      print('\n📅 DOCTOR APPOINTMENTS');
      print('-' * 60);
      for (final appointment in appointments) {
        _printAppointmentSummary(appointment);
      }
    } catch (e) {
      print('❌ Error fetching doctor appointments: $e');
    }
  }

  Future<void> _startAppointment() async {
    final appointmentId = _getUserInput('Enter Appointment ID to start: ');

    try {
      await _hospitalService.startAppointment(appointmentId);
      print('✅ Appointment started successfully!');
    } catch (e) {
      print('❌ Error starting appointment: $e');
    }
  }

  Future<void> _completeAppointment() async {
    final appointmentId = _getUserInput('Enter Appointment ID to complete: ');
    final notes = _getUserInput('Enter appointment notes: ');

    try {
      await _hospitalService.completeAppointment(appointmentId, notes);
      print('✅ Appointment completed successfully!');
    } catch (e) {
      print('❌ Error completing appointment: $e');
    }
  }

  void _printAppointmentSummary(Appointment appointment) {
    final status = _getAppointmentStatusEmoji(appointment.status);
    print(
      '$status ${appointment.scheduledTime} - ${appointment.appointmentType}',
    );
    print('   ID: ${appointment.id}');
    print('   Patient: ${appointment.patientId}');
    print('   Doctor: ${appointment.doctorId}');
    print('   Reason: ${appointment.reason}');
    print('   Status: ${appointment.status.name}');
    print('-' * 40);
  }

  void _printAppointmentDetails(Appointment appointment) {
    print('\n📅 APPOINTMENT DETAILS');
    print('-' * 30);
    print('ID: ${appointment.id}');
    print('Patient ID: ${appointment.patientId}');
    print('Doctor ID: ${appointment.doctorId}');
    print('Scheduled: ${_formatDateTime(appointment.scheduledTime)}');
    print('Type: ${appointment.appointmentType}');
    print('Reason: ${appointment.reason}');
    print(
      'Status: ${_getAppointmentStatusEmoji(appointment.status)} ${appointment.status.name}',
    );

    if (appointment.actualStartTime != null) {
      print('Started: ${_formatDateTime(appointment.actualStartTime!)}');
    }

    if (appointment.actualEndTime != null) {
      print('Completed: ${_formatDateTime(appointment.actualEndTime!)}');
    }

    if (appointment.notes != null) {
      print('Notes: ${appointment.notes}');
    }
  }

  String _getAppointmentStatusEmoji(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return '⏰';
      case AppointmentStatus.inProgress:
        return '🔵';
      case AppointmentStatus.completed:
        return '✅';
      case AppointmentStatus.cancelled:
        return '❌';
      case AppointmentStatus.noShow:
        return '🚫';
    }
  }

  // Prescription Management
  Future<void> _managePrescriptions() async {
    while (true) {
      print('\n💊 PRESCRIPTION MANAGEMENT');
      print('-' * 40);
      print('1. Create New Prescription');
      print('2. View Patient Prescriptions');
      print('3. View Active Prescriptions');
      print('0. Back to Main Menu');

      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          await _createPrescription();
          break;
        case '2':
          await _viewPatientPrescriptions();
          break;
        case '3':
          await _viewActivePrescriptions();
          break;
        case '0':
          return;
        default:
          print('❌ Invalid choice.');
      }
    }
  }

  Future<void> _createPrescription() async {
    print('\n💊 CREATE NEW PRESCRIPTION');
    print('-' * 40);

    try {
      final patientId = _getUserInput('Enter Patient ID: ');
      final doctorId = _getUserInput('Enter Doctor ID: ');
      final diagnosis = _getUserInput('Enter Diagnosis: ');
      final instructions = _getUserInput('Enter Instructions: ');

      final followUpInput = _getUserInput(
        'Enter Follow-up Date (YYYY-MM-DD, optional): ',
      );
      final followUpDate =
          followUpInput.isEmpty ? null : DateTime.parse(followUpInput);

      final items = <Medication>[];
      var addMore = true;
      var totalCost = 0.0;

      while (addMore) {
        print('\n➕ ADD MEDICATION');
        final name = _getUserInput('Enter Medication Name: ');
        final dosage = _getUserInput('Enter Dosage: ');
        final frequency = _getUserInput('Enter Frequency: ');
        final cost = double.parse(_getUserInput('Enter Cost: '));
        final notes = _getUserInput('Enter Notes (optional): ');

        items.add(Medication(
          name: name,
          dosage: dosage,
          frequency: frequency,
          cost: cost,
          notes: notes,
        ));
        totalCost += cost;

        final continueInput = _getUserInput('Add another medication? (y/n): ');
        addMore = continueInput.toLowerCase() == 'y';
      }

      final prescription = await _hospitalService.createPrescription(
        patientId: patientId,
        doctorId: doctorId,
        diagnosis: diagnosis,
        instructions: instructions,
        followUpDate: followUpDate,
        items: items,
        totalCost: totalCost,
      );

      print('✅ Prescription created successfully!');
      _printPrescriptionDetails(prescription);
    } catch (e) {
      print('❌ Error creating prescription: $e');
    }
  }

  Future<void> _viewPatientPrescriptions() async {
    final patientId = _getUserInput('Enter Patient ID: ');

    try {
      final prescriptions = await _hospitalService.getPatientPrescriptions(
        patientId,
      );

      if (prescriptions.isEmpty) {
        print('No prescriptions found for this patient.');
        return;
      }

      print('\n💊 PATIENT PRESCRIPTIONS');
      print('-' * 60);
      for (final prescription in prescriptions) {
        _printPrescriptionSummary(prescription);
      }
    } catch (e) {
      print('❌ Error fetching prescriptions: $e');
    }
  }

  Future<void> _viewActivePrescriptions() async {
    final patientId = _getUserInput('Enter Patient ID: ');

    try {
      final prescriptions = await _hospitalService.getActivePrescriptions(
        patientId,
      );

      if (prescriptions.isEmpty) {
        print('No active prescriptions found for this patient.');
        return;
      }

      print('\n💊 ACTIVE PRESCRIPTIONS');
      print('-' * 60);
      for (final prescription in prescriptions) {
        _printPrescriptionSummary(prescription);
      }
    } catch (e) {
      print('❌ Error fetching active prescriptions: $e');
    }
  }

  void _printPrescriptionSummary(Prescription prescription) {
    final status = prescription.isValid ? '✅ Active' : '❌ Expired';
    print('$status Prescription ${prescription.id}');
    print('   Date: ${_formatDate(prescription.issueDate)}');
    print('   Doctor: ${prescription.doctorId}');
    print('   Diagnosis: ${prescription.diagnosis}');
    print('   Total Cost: \$${prescription.totalCost.toStringAsFixed(2)}');
    print('   Medications: ${prescription.items.length}');
    print('-' * 40);
  }

  void _printPrescriptionDetails(Prescription prescription) {
    print('\n💊 PRESCRIPTION DETAILS');
    print('-' * 30);
    print('ID: ${prescription.id}');
    print('Patient ID: ${prescription.patientId}');
    print('Doctor ID: ${prescription.doctorId}');
    print('Issue Date: ${_formatDate(prescription.issueDate)}');
    print('Diagnosis: ${prescription.diagnosis}');
    print('Status: ${prescription.isValid ? "✅ Valid" : "❌ Invalid"}');
    print('Total Cost: \$${prescription.totalCost.toStringAsFixed(2)}');

    print('Instructions: ${prescription.instructions}');

    if (prescription.followUpDate != null) {
      print('Follow-up Date: ${_formatDate(prescription.followUpDate!)}');
    }

    print('\nMedications:');
    for (final item in prescription.items) {
      print('  💊 ${item.name}');
      print('     Dosage: ${item.dosageDescription}');
      print('     Cost: \$${item.cost.toStringAsFixed(2)}');
      print(
        '     Status: ${item.isValid ? "✅ Active" : "❌ Completed/Expired"}',
      );
    }
  }

  // Reports & Analytics
  Future<void> _viewReports() async {
    while (true) {
      print('\n📊 REPORTS & ANALYTICS');
      print('-' * 40);
      print('1. Hospital Statistics');
      print('2. Doctor Performance');
      print('3. Financial Summary');
      print('0. Back to Main Menu');

      final choice = _getUserInput('Enter your choice: ');

      switch (choice) {
        case '1':
          await _viewHospitalStats();
          break;
        case '2':
          await _viewDoctorPerformance();
          break;
        case '3':
          await _viewFinancialSummary();
          break;
        case '0':
          return;
        default:
          print('❌ Invalid choice.');
      }
    }
  }

  Future<void> _viewHospitalStats() async {
    print('\n📊 HOSPITAL STATISTICS');
    print('-' * 50);

    try {
      final stats = await _hospitalService.getHospitalStats();

      print('👥 STAFF');
      print('  Total Staff: ${stats['totalStaff']}');
      print('  Doctors: ${stats['doctors']}');
      print('  Nurses: ${stats['nurses']}');
      print('  Administrative: ${stats['administrative']}');

      print('\n👤 PATIENTS');
      print('  Total Patients: ${stats['totalPatients']}');

      print('\n🏨 ROOMS & BEDS');
      print('  Total Rooms: ${stats['totalRooms']}');
      print('  Available Beds: ${stats['availableBeds']}');
      print('  Occupied Beds: ${stats['occupiedBeds']}');
      print('  Maintenance Beds: ${stats['maintenanceBeds']}');
      print('  Occupancy Rate: ${stats['occupancyRate'].toStringAsFixed(1)}%');

      print('\n📅 APPOINTMENTS');
      print('  Upcoming Appointments: ${stats['upcomingAppointments']}');
      print('  Today\'s Appointments: ${stats['todayAppointments']}');

      print('\n💰 FINANCIAL');
      print(
        '  Estimated Daily Revenue: \$${stats['estimatedDailyRevenue'].toStringAsFixed(2)}',
      );
    } catch (e) {
      print('❌ Error fetching hospital statistics: $e');
    }
  }

  Future<void> _viewDoctorPerformance() async {
    final doctorId = _getUserInput('Enter Doctor ID: ');

    try {
      final performance = await _hospitalService.getDoctorPerformance(doctorId);

      print('\n📊 DOCTOR PERFORMANCE');
      print('-' * 40);
      print('Total Appointments: ${performance['totalAppointments']}');
      print('Completed Appointments: ${performance['completedAppointments']}');
      print('Cancelled Appointments: ${performance['cancelledAppointments']}');
      print(
        'Completion Rate: ${performance['completionRate'].toStringAsFixed(1)}%',
      );
      print('Total Prescriptions: ${performance['totalPrescriptions']}');
      print('Active Prescriptions: ${performance['activePrescriptions']}');
    } catch (e) {
      print('❌ Error fetching doctor performance: $e');
    }
  }

  Future<void> _viewFinancialSummary() async {
    print('\n💰 FINANCIAL SUMMARY');
    print('-' * 40);

    try {
      final stats = await _hospitalService.getHospitalStats();
      final dailyRevenue = stats['estimatedDailyRevenue'] as double;
      final monthlyRevenue = dailyRevenue * 30;
      final yearlyRevenue = dailyRevenue * 365;

      print('Daily Revenue: \$${dailyRevenue.toStringAsFixed(2)}');
      print('Monthly Revenue (est.): \$${monthlyRevenue.toStringAsFixed(2)}');
      print('Yearly Revenue (est.): \$${yearlyRevenue.toStringAsFixed(2)}');
      print('Occupancy Rate: ${stats['occupancyRate'].toStringAsFixed(1)}%');
    } catch (e) {
      print('❌ Error fetching financial summary: $e');
    }
  }

  // Utility Methods
  String _getUserInput(String prompt) {
    stdout.write('👉 $prompt');
    return stdin.readLineSync()?.trim() ?? '';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

}
