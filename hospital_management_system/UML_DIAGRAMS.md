# Hospital Management System - UML Diagrams

## 1. Class Diagram - Domain Entities

```mermaid
classDiagram
    %% Staff Hierarchy
    class Staff {
        <<abstract>>
        -String id
        -String name
        -String email
        -String phoneNumber
        -DateTime joinDate
        -String department
        +String role
        +toJson() Map~String, dynamic~
    }
    
    class Doctor {
        -String specialization
        -String licenseNumber
        -List~String~ appointmentIds
        -List~String~ qualifications
        +addAppointment(appointmentId)
        +removeAppointment(appointmentId)
        +addQualification(qualification)
        +toJson() Map~String, dynamic~
    }
    
    class Nurse {
        -String ward
        -String shift
        -List~String~ specialties
        +addSpecialty(specialty)
        +toJson() Map~String, dynamic~
    }
    
    class Administrative {
        -String position
        -List~String~ responsibilities
        +addResponsibility(responsibility)
        +toJson() Map~String, dynamic~
    }
    
    Staff <|-- Doctor
    Staff <|-- Nurse
    Staff <|-- Administrative
    
    %% Patient
    class Patient {
        -String id
        -String name
        -DateTime dateOfBirth
        -String gender
        -String address
        -String phoneNumber
        -String email
        -String bloodType
        -List~String~ medicalHistory
        -List~String~ appointmentIds
        -List~String~ prescriptionIds
        -List~String~ allergies
        -List~String~ medicalConditions
        +int age
        +addMedicalHistory(history)
        +addAppointment(appointmentId)
        +addPrescription(prescriptionId)
        +addAllergy(allergy)
        +fromJson() Patient
        +toJson() Map~String, dynamic~
    }
    
    %% Room & Bed
    class Room {
        -String id
        -String number
        -RoomType type
        -int capacity
        -double pricePerDay
        -List~String~ equipment
        -List~Bed~ beds
        +int availableBedsCount
        +int occupiedBedsCount
        +int maintenanceBedsCount
        +getAvailableBed() Bed?
        +addEquipment(item)
        +fromJson() Room
        +toJson() Map~String, dynamic~
    }
    
    class Bed {
        -String id
        -String roomId
        -int bedNumber
        -BedStatus status
        -String? patientId
        -DateTime? assignedDate
        -DateTime? dischargeDate
        +assignPatient(patientId)
        +dischargePatient()
        +setMaintenance()
        +Duration? occupancyDuration
        +toJson() Map~String, dynamic~
    }
    
    class RoomType {
        <<enumeration>>
        GENERAL_WARD
        PRIVATE_ROOM
        ICU
        EMERGENCY
        OPERATING_ROOM
        CONSULTATION_ROOM
        MATERNITY
    }
    
    class BedStatus {
        <<enumeration>>
        AVAILABLE
        OCCUPIED
        MAINTENANCE
    }
    
    Room "1" *-- "many" Bed : contains
    Room --> RoomType
    Bed --> BedStatus
    Bed --> Patient : assigned to
    
    %% Appointment
    class Appointment {
        -String id
        -String patientId
        -String doctorId
        -DateTime scheduledTime
        -DateTime? actualStartTime
        -DateTime? actualEndTime
        -String reason
        -AppointmentStatus status
        -String notes
        -String appointmentType
        -String? roomId
        +bool isUpcoming
        +bool isPast
        +bool isInProgress
        +startAppointment()
        +complete()
        +cancel()
        +markAsNoShow()
        +fromJson() Appointment
        +toJson() Map~String, dynamic~
    }
    
    class AppointmentStatus {
        <<enumeration>>
        SCHEDULED
        IN_PROGRESS
        COMPLETED
        CANCELLED
        NO_SHOW
    }
    
    Appointment --> AppointmentStatus
    Appointment --> Patient
    Appointment --> Doctor
    Appointment --> Room
    
    %% Prescription
    class Prescription {
        -String id
        -String patientId
        -String doctorId
        -DateTime issueDate
        -String diagnosis
        -List~Medication~ items
        -double totalCost
        -String instructions
        -DateTime? followUpDate
        -bool isFilled
        -String? notes
        +bool isValid
        +fromJson() Prescription
        +toJson() Map~String, dynamic~
    }
    
    class Medication {
        -String name
        -String dosage
        -String frequency
        -String? notes
        -double cost
        -bool isValid
        +String dosageDescription
        +fromJson() Medication
        +toJson() Map~String, dynamic~
    }
    
    Prescription "1" *-- "many" Medication : contains
    Prescription --> Patient
    Prescription --> Doctor
```

## 2. Class Diagram - Repository Layer (Data Access)

```mermaid
classDiagram
    %% Repository Interfaces
    class IStaffRepository {
        <<interface>>
        +addStaff(staff) Future~void~
        +getStaffById(id) Future~Staff?~
        +getStaffByRole(role) Future~List~Staff~~
        +getAllStaff() Future~List~Staff~~
        +updateStaff(staff) Future~void~
        +deleteStaff(id) Future~bool~
    }
    
    class IPatientRepository {
        <<interface>>
        +addPatient(patient) Future~void~
        +getPatientById(id) Future~Patient?~
        +getAllPatients() Future~List~Patient~~
        +updatePatient(patient) Future~void~
        +deletePatient(id) Future~bool~
        +searchPatients(query) Future~List~Patient~~
    }
    
    class IRoomRepository {
        <<interface>>
        +addRoom(room) Future~void~
        +getRoomById(id) Future~Room?~
        +getRoomsByType(type) Future~List~Room~~
        +getAllRooms() Future~List~Room~~
        +updateRoom(room) Future~void~
        +getAvailableRooms() Future~List~Room~~
    }
    
    class IAppointmentRepository {
        <<interface>>
        +scheduleAppointment(appointment) Future~void~
        +getAppointmentById(id) Future~Appointment?~
        +getAppointmentsByPatient(patientId) Future~List~Appointment~~
        +getAppointmentsByDoctor(doctorId) Future~List~Appointment~~
        +getUpcomingAppointments() Future~List~Appointment~~
        +getAppointmentsByDate(date) Future~List~Appointment~~
        +updateAppointment(appointment) Future~void~
        +cancelAppointment(id) Future~bool~
    }
    
    class IPrescriptionRepository {
        <<interface>>
        +addPrescription(prescription) Future~void~
        +getPrescriptionById(id) Future~Prescription?~
        +getPrescriptionsByPatient(patientId) Future~List~Prescription~~
        +getActivePrescriptions(patientId) Future~List~Prescription~~
        +updatePrescription(prescription) Future~void~
        +getPrescriptionsByDoctor(doctorId) Future~List~Prescription~~
    }
    
    %% Concrete Implementations
    class StaffRepository {
        -Map~String, Staff~ staffStorage
        -String filePath
        -bool isLoaded
        -loadData() Future~void~
        -ensureLoaded() Future~void~
        -fromJson(json) Staff
        -saveData() Future~void~
    }
    
    class PatientRepository {
        -Map~String, Patient~ patientStorage
        -String filePath
        -loadData() Future~void~
        -saveData() Future~void~
    }
    
    class RoomRepository {
        -Map~String, Room~ roomStorage
        -String filePath
        -loadData() Future~void~
        -saveData() Future~void~
    }
    
    class AppointmentRepository {
        -Map~String, Appointment~ appointmentStorage
        -String filePath
        -loadData() Future~void~
        -saveData() Future~void~
    }
    
    class PrescriptionRepository {
        -Map~String, Prescription~ prescriptionStorage
        -String filePath
        -loadData() Future~void~
        -saveData() Future~void~
    }
    
    IStaffRepository <|.. StaffRepository
    IPatientRepository <|.. PatientRepository
    IRoomRepository <|.. RoomRepository
    IAppointmentRepository <|.. AppointmentRepository
    IPrescriptionRepository <|.. PrescriptionRepository
```

## 3. Class Diagram - Service Layer (Business Logic)

```mermaid
classDiagram
    class HospitalService {
        -IStaffRepository staffRepository
        -IPatientRepository patientRepository
        -IRoomRepository roomRepository
        -IAppointmentRepository appointmentRepository
        -IPrescriptionRepository prescriptionRepository
        
        %% Staff Management
        +hireStaff(staff) Future~void~
        +getDoctors() Future~List~Doctor~~
        +getNurses() Future~List~Nurse~~
        +getStaffById(id) Future~Staff?~
        +getAllStaff() Future~List~Staff~~
        
        %% Patient Management
        +admitPatient(patient) Future~void~
        +getPatientById(id) Future~Patient?~
        +getAllPatients() Future~List~Patient~~
        +searchPatients(query) Future~List~Patient~~
        
        %% Room Management
        +addRoom(room) Future~void~
        +assignPatientToBed(patientId, type) Future~Bed?~
        +dischargePatientFromBed(patientId) Future~void~
        +getAvailableRooms() Future~List~Room~~
        +getAllRooms() Future~List~Room~~
        
        %% Appointment Management
        +scheduleAppointment(...) Future~Appointment~
        +startAppointment(id) Future~void~
        +completeAppointment(id, notes) Future~void~
        +getUpcomingAppointments() Future~List~Appointment~~
        +getAppointmentsByDoctor(doctorId) Future~List~Appointment~~
        
        %% Prescription Management
        +createPrescription(...) Future~Prescription~
        +getPatientPrescriptions(patientId) Future~List~Prescription~~
        +getActivePrescriptions(patientId) Future~List~Prescription~~
        
        %% Reports & Analytics
        +getHospitalStats() Future~Map~String, dynamic~~
        +getDoctorPerformance(doctorId) Future~Map~String, dynamic~~
    }
    
    HospitalService --> IStaffRepository
    HospitalService --> IPatientRepository
    HospitalService --> IRoomRepository
    HospitalService --> IAppointmentRepository
    HospitalService --> IPrescriptionRepository
```

## 4. Class Diagram - UI Layer

```mermaid
classDiagram
    class ConsoleUI {
        -HospitalService hospitalService
        
        +run() Future~void~
        
        %% Main Menu
        -displayMainMenu() void
        -printWelcomeMessage() void
        -getUserInput(prompt) String
        
        %% Staff Management
        -manageStaff() Future~void~
        -hireDoctor() Future~void~
        -hireNurse() Future~void~
        -hireAdministrative() Future~void~
        -viewAllDoctors() Future~void~
        -viewAllNurses() Future~void~
        -searchStaff() Future~void~
        
        %% Patient Management
        -managePatients() Future~void~
        -admitNewPatient() Future~void~
        -viewAllPatients() Future~void~
        -searchPatient() Future~void~
        -viewPatientDetails() Future~void~
        -updatePatientRecord() Future~void~
        
        %% Room Management
        -manageRooms() Future~void~
        -addNewRoom() Future~void~
        -viewAllRooms() Future~void~
        -viewAvailableRooms() Future~void~
        -assignBedToPatient() Future~void~
        -dischargePatient() Future~void~
        
        %% Appointment Management
        -manageAppointments() Future~void~
        -scheduleNewAppointment() Future~void~
        -viewUpcomingAppointments() Future~void~
        -startAppointment() Future~void~
        -completeAppointment() Future~void~
        
        %% Prescription Management
        -managePrescriptions() Future~void~
        -createNewPrescription() Future~void~
        -viewPatientPrescriptions() Future~void~
        -viewActivePrescriptions() Future~void~
        
        %% Reports
        -viewReports() Future~void~
        -viewHospitalOverview() Future~void~
        -viewDoctorPerformance() Future~void~
    }
    
    ConsoleUI --> HospitalService
```

## 5. Architecture Diagram - Layered Architecture

```mermaid
graph TB
    subgraph Presentation["Presentation Layer"]
        UI[Console UI]
    end
    
    subgraph Business["Business Logic Layer"]
        Service[Hospital Service]
    end
    
    subgraph Domain["Domain Layer"]
        Entities["Domain Entities: Staff, Patient, Room, Appointment, Prescription"]
        Interfaces[Repository Interfaces]
    end
    
    subgraph DataAccess["Data Access Layer"]
        Repos["Repository Implementations: StaffRepository, PatientRepository, RoomRepository, AppointmentRepository, PrescriptionRepository"]
    end
    
    subgraph Storage["Data Storage"]
        JSON["JSON Files: staff.json, patients.json, rooms.json, appointments.json, prescriptions.json"]
    end
    
    UI -->|calls| Service
    Service -->|uses| Interfaces
    Service -->|uses| Entities
    Interfaces -.implements.- Repos
    Repos -->|persists to| JSON
    
    style Presentation fill:#e1f5ff
    style Business fill:#fff3e0
    style Domain fill:#f3e5f5
    style DataAccess fill:#e8f5e9
    style Storage fill:#fce4ec
```

## 6. Sequence Diagram - Schedule Appointment Flow

```mermaid
sequenceDiagram
    participant User
    participant UI as ConsoleUI
    participant Service as HospitalService
    participant PatientRepo as PatientRepository
    participant StaffRepo as StaffRepository
    participant ApptRepo as AppointmentRepository
    
    User->>UI: Select "Schedule Appointment"
    UI->>User: Request patient ID
    User->>UI: Enter patient ID
    UI->>Service: getPatientById(patientId)
    Service->>PatientRepo: getPatientById(patientId)
    PatientRepo-->>Service: Patient | null
    Service-->>UI: Patient
    
    UI->>User: Request doctor ID
    User->>UI: Enter doctor ID
    UI->>Service: getStaffById(doctorId)
    Service->>StaffRepo: getStaffById(doctorId)
    StaffRepo-->>Service: Staff (Doctor)
    Service-->>UI: Doctor
    
    UI->>User: Request appointment details
    User->>UI: Enter date, time, reason
    
    UI->>Service: scheduleAppointment(...)
    Service->>PatientRepo: getPatientById(patientId)
    PatientRepo-->>Service: Patient
    Service->>StaffRepo: getStaffById(doctorId)
    StaffRepo-->>Service: Doctor
    
    Service->>Service: Create Appointment object
    Service->>ApptRepo: scheduleAppointment(appointment)
    ApptRepo->>ApptRepo: Save to JSON
    ApptRepo-->>Service: void
    
    Service->>Service: Update Patient record
    Service->>PatientRepo: updatePatient(patient)
    PatientRepo-->>Service: void
    
    Service->>Service: Update Doctor record
    Service->>StaffRepo: updateStaff(doctor)
    StaffRepo-->>Service: void
    
    Service-->>UI: Appointment
    UI-->>User: Display success message
```

## 7. Sequence Diagram - View All Doctors Flow

```mermaid
sequenceDiagram
    participant User
    participant UI as ConsoleUI
    participant Service as HospitalService
    participant StaffRepo as StaffRepository
    participant JSON as staff.json
    
    User->>UI: Select "View All Doctors"
    activate UI
    
    UI->>Service: getDoctors()
    activate Service
    
    Service->>StaffRepo: getStaffByRole("Doctor")
    activate StaffRepo
    
    StaffRepo->>StaffRepo: ensureLoaded()<br/>(wait for data)
    
    alt Data not loaded
        StaffRepo->>JSON: Read file
        JSON-->>StaffRepo: JSON data
        StaffRepo->>StaffRepo: Parse JSON to Staff objects
        StaffRepo->>StaffRepo: Store in staffStorage Map
    end
    
    StaffRepo->>StaffRepo: Filter by role "Doctor"
    StaffRepo-->>Service: List<Staff>
    deactivate StaffRepo
    
    Service->>Service: whereType<Doctor>()
    Service-->>UI: List<Doctor>
    deactivate Service
    
    UI->>UI: Format and display doctors
    UI-->>User: Show doctor list
    deactivate UI
```

## 8. Use Case Diagram

```mermaid
graph LR
    subgraph "Hospital Management System"
        UC1[Hire Staff]
        UC2[View Staff]
        UC3[Admit Patient]
        UC4[View Patients]
        UC5[Add Room]
        UC6[Assign Bed]
        UC7[Discharge Patient]
        UC8[Schedule Appointment]
        UC9[Complete Appointment]
        UC10[Create Prescription]
        UC11[View Reports]
    end
    
    Admin((Administrator))
    Doctor((Doctor))
    Nurse((Nurse))
    Receptionist((Receptionist))
    
    Admin --> UC1
    Admin --> UC2
    Admin --> UC5
    Admin --> UC11
    
    Receptionist --> UC3
    Receptionist --> UC4
    Receptionist --> UC6
    Receptionist --> UC7
    Receptionist --> UC8
    
    Doctor --> UC2
    Doctor --> UC4
    Doctor --> UC9
    Doctor --> UC10
    
    Nurse --> UC4
    Nurse --> UC6
    Nurse --> UC7
```

## 9. Component Diagram

```mermaid
graph TB
    subgraph UI["UI Layer"]
        ConsoleUI[Console UI]
    end
    
    subgraph Service["Service Layer"]
        HospitalService[Hospital Service]
    end
    
    subgraph Domain["Domain Layer"]
        Staff[Staff Entities]
        Patient[Patient Entity]
        Room[Room Entities]
        Appointment[Appointment Entity]
        Prescription[Prescription Entity]
        RepoInterfaces[Repository Interfaces]
    end
    
    subgraph Repository["Repository Layer"]
        StaffRepo[Staff Repository]
        PatientRepo[Patient Repository]
        RoomRepo[Room Repository]
        ApptRepo[Appointment Repository]
        PrescRepo[Prescription Repository]
    end
    
    subgraph Data["Data Storage"]
        StaffJSON[staff.json]
        PatientJSON[patients.json]
        RoomJSON[rooms.json]
        ApptJSON[appointments.json]
        PrescJSON[prescriptions.json]
    end
    
    ConsoleUI -->|uses| HospitalService
    HospitalService -->|depends on| RepoInterfaces
    HospitalService -->|uses| Staff
    HospitalService -->|uses| Patient
    HospitalService -->|uses| Room
    HospitalService -->|uses| Appointment
    HospitalService -->|uses| Prescription
    
    RepoInterfaces -.implements.- StaffRepo
    RepoInterfaces -.implements.- PatientRepo
    RepoInterfaces -.implements.- RoomRepo
    RepoInterfaces -.implements.- ApptRepo
    RepoInterfaces -.implements.- PrescRepo
    
    StaffRepo -->|reads/writes| StaffJSON
    PatientRepo -->|reads/writes| PatientJSON
    RoomRepo -->|reads/writes| RoomJSON
    ApptRepo -->|reads/writes| ApptJSON
    PrescRepo -->|reads/writes| PrescJSON
    
    style UI fill:#e1f5ff
    style Service fill:#fff3e0
    style Domain fill:#f3e5f5
    style Repository fill:#e8f5e9
    style Data fill:#fce4ec
```

## 10. State Diagram - Appointment Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Scheduled: Create Appointment
    
    Scheduled --> InProgress: Start Appointment
    Scheduled --> Cancelled: Cancel
    Scheduled --> NoShow: Mark as No-Show
    
    InProgress --> Completed: Complete Appointment
    InProgress --> Cancelled: Cancel (emergency)
    
    Completed --> [*]
    Cancelled --> [*]
    NoShow --> [*]
    
    note right of Scheduled
        Patient and doctor are assigned
        Scheduled time is set
    end note
    
    note right of InProgress
        actualStartTime recorded
        Doctor is with patient
    end note
    
    note right of Completed
        actualEndTime recorded
        Notes added
        Duration calculated
    end note
```

## 11. State Diagram - Bed Status Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Available: Create Bed
    
    Available --> Occupied: Assign Patient
    Available --> Maintenance: Set Maintenance
    
    Occupied --> Available: Discharge Patient
    Occupied --> Maintenance: Emergency Maintenance
    
    Maintenance --> Available: Complete Maintenance
    
    Available --> [*]: Remove Bed
    
    note right of Available
        Ready for patient assignment
        No patient assigned
    end note
    
    note right of Occupied
        Patient assigned
        assignedDate recorded
        Billing active
    end note
    
    note right of Maintenance
        Under repair/cleaning
        Cannot be assigned
    end note
```

## 12. Deployment Diagram

```mermaid
graph TB
    subgraph "User Machine"
        Terminal[Terminal/Console]
        DartVM[Dart VM]
        
        subgraph "Application"
            App[Hospital Management<br/>System Executable]
        end
        
        subgraph "File System"
            DataDir[data/ directory]
            StaffFile[staff.json]
            PatientFile[patients.json]
            RoomFile[rooms.json]
            ApptFile[appointments.json]
            PrescFile[prescriptions.json]
        end
    end
    
    Terminal --> DartVM
    DartVM --> App
    App <--> DataDir
    DataDir --> StaffFile
    DataDir --> PatientFile
    DataDir --> RoomFile
    DataDir --> ApptFile
    DataDir --> PrescFile
    
    style Terminal fill:#e1f5ff
    style DartVM fill:#fff3e0
    style App fill:#f3e5f5
    style DataDir fill:#e8f5e9
```

