import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String roomId;
  final int occupancy;
  final int floor;
  final String roomNumber;

  Room({
    required this.roomId,
    required this.occupancy,
    required this.floor,
    required this.roomNumber,
  });

  factory Room.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Room(
      roomId: doc.id,
      occupancy: doc['occupancy'],
      floor: doc['floor'],
      roomNumber: doc['room_number'],
    );
  }
}