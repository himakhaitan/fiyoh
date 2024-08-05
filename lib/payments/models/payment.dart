import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fiyoh/models/transaction.dart';

class Payment extends Transaction {
  final String propertyName;

  Payment({
    required super.id,
    required super.bookingId,
    required super.amount,
    required super.status,
    required super.transactionTimestamp,
    required super.transactionType,
    required super.paymentMethod,
    super.startDate,
    super.endDate,
    required this.propertyName,
  });

  factory Payment.fromDocumentSnapshot(firestore.DocumentSnapshot doc, String propertyName) {
    return Payment(
      id: doc.id,
      bookingId: doc['booking_id'],
      amount: doc['amount'].toDouble(),
      status: doc['status'],
      paymentMethod: doc['payment_method'],
      transactionTimestamp:
          (doc['transaction_timestamp'] as firestore.Timestamp).toDate(),
      transactionType: doc['transaction_type'],
      startDate: doc['start_date'] != null
          ? (doc['start_date'] as firestore.Timestamp).toDate()
          : null,
      endDate: doc['end_date'] != null
          ? (doc['end_date'] as firestore.Timestamp).toDate()
          : null,
      propertyName: propertyName,
    );
  }
}
