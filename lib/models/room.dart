import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String roomId;
  final int occupancy;
  final int floor;
  final String roomNumber;
  final List<Map<String, String>>? tenants;

  Room({
    required this.roomId,
    required this.occupancy,
    required this.floor,
    required this.roomNumber,
    this.tenants,
  });

  factory Room.fromDocumentSnapshot(DocumentSnapshot doc) {
    
    List<Map<String, String>> tenants = [];
    doc['tenants'].forEach((value) {
      Map<String, String> tenant = {};
      tenant['user_id'] = value['user_id'];
      tenant['booking_id'] = value['booking_id'];
    });

    return Room(
      roomId: doc.id,
      occupancy: doc['occupancy'],
      floor: doc['floor'],
      roomNumber: doc['room_number'],
      tenants: tenants,
    );
  }
}
