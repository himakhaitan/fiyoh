import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String bookingId;
  final String roomId;
  final String propertyId;
  final String tenantId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String status;
  final List<String> transactions;

  Booking({
    required this.bookingId,
    required this.roomId,
    required this.propertyId,
    required this.tenantId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.transactions,
  });

  factory Booking.fromDocumentSnapshot(DocumentSnapshot doc) {
    List<String> transactions = [];
    doc['transactions'].forEach((value) {
      transactions.add(value);
    });

    return Booking(
      bookingId: doc.id,
      roomId: doc['room_id'],
      propertyId: doc['property_id'],
      tenantId: doc['tenant_id'],
      checkInDate: doc['check_in_date'] != null
          ? (doc['check_in_date'] as Timestamp).toDate()
          : null,
      checkOutDate: doc['check_out_date'] != null
          ? (doc['check_out_date'] as Timestamp).toDate()
          : null,
      status: doc['status'],
      transactions: transactions,
    );
  }
}

