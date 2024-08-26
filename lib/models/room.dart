import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final int occupancy;
  final int floor;
  final String roomNumber;
  final List<Map<String, String>> tenants;

  Room({
    required this.id,
    required this.occupancy,
    required this.floor,
    required this.roomNumber,
    this.tenants = const [],
  });

  factory Room.fromDocumentSnapshot(DocumentSnapshot doc) {
    
    List<Map<String, String>> tenants = [];
    doc['tenants'].forEach((value) {
      Map<String, String> tenant = {};
      tenant['tenant_id'] = value['tenant_id'];
      tenant['booking_id'] = value['booking_id'];
      tenants.add(tenant);
    });

    return Room(
      id: doc.id,
      occupancy: doc['occupancy'],
      floor: doc['floor'],
      roomNumber: doc['room_number'],
      tenants: tenants,
    );
  }
}
