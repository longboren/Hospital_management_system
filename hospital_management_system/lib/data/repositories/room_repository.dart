import 'dart:convert';
import 'dart:io';
import '../../domain/entities/room.dart';
import '../../domain/repositories/interfaces.dart';

class RoomRepository implements IRoomRepository {
  final Map<String, Room> _roomStorage = {};
  final String _filePath = 'data/rooms.json';

  RoomRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final room = Room.fromJson(jsonItem);
          _roomStorage[room.id] = room;
        }
      }
    } catch (e) {
      print('Error loading room data: $e');
    }
  }

  @override
  Future<void> addRoom(Room room) async {
    if (_roomStorage.containsKey(room.id)) {
      throw Exception('Room with ID ${room.id} already exists');
    }
    _roomStorage[room.id] = room;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList =
          _roomStorage.values.map((room) => room.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving room data: $e');
    }
  }

  @override
  Future<Room?> getRoomById(String id) async {
    return _roomStorage[id];
  }

  @override
  Future<List<Room>> getRoomsByType(RoomType type) async {
    return _roomStorage.values.where((room) => room.type == type).toList();
  }

  @override
  Future<List<Room>> getAllRooms() async {
    return _roomStorage.values.toList();
  }

  @override
  Future<void> updateRoom(Room room) async {
    if (!_roomStorage.containsKey(room.id)) {
      throw Exception('Room with ID ${room.id} not found');
    }
    _roomStorage[room.id] = room;
  }

  @override
  Future<List<Room>> getAvailableRooms() async {
    return _roomStorage.values
        .where((room) => room.availableBedsCount > 0)
        .toList();
  }

  // Method to clear all data (useful for testing)
  Future<void> clearAll() async {
    _roomStorage.clear();
    await _saveData();
  }
}
