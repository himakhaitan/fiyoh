import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/models/transaction.dart' as transaction;
class Booking {
  final String id;
  final String roomId;
  final String propertyId;
  final String tenantId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String status;
  final List<transaction.Transaction> transactions;

  Booking({
    required this.id,
    required this.roomId,
    required this.propertyId,
    required this.tenantId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    this.transactions = const [],
  });

  factory Booking.fromDocumentSnapshot(DocumentSnapshot doc, List<transaction.Transaction> transactions) {
    return Booking(
      id: doc.id,
      roomId: doc['room_id'],
      propertyId: doc['property_id'],
      tenantId: doc['tenant_id'],
      checkInDate: doc['check_in_date'] != null ? (doc['check_in_date'] as Timestamp).toDate() : null,
      checkOutDate: doc['check_out_date'] != null ? (doc['check_out_date'] as Timestamp).toDate() : null,
      status: doc['status'],
      transactions: transactions,
    );
  }
}

