import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String bookingId;
  final double amount;
  final String status;
  final DateTime transactionTimestamp;
  final String transactionType;
  final DateTime? startDate;
  final DateTime? endDate;

  Transaction({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.status,
    required this.transactionTimestamp,
    required this.transactionType,
    required this.startDate,
    required this.endDate,
  });

  factory Transaction.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Transaction(
      id: doc.id,
      bookingId: doc['booking_id'],
      amount: doc['amount'].toDouble(),
      status: doc['status'],
      transactionTimestamp:
          (doc['transaction_timestamp'] as Timestamp).toDate(),
      transactionType: doc['transaction_type'],
      startDate: doc['start_date'] != null
          ? (doc['start_date'] as Timestamp).toDate()
          : null,
      endDate: doc['end_date'] != null
          ? (doc['end_date'] as Timestamp).toDate()
          : null,
    );
  }
}
