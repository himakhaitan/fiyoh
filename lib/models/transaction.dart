
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String transactionId;
  final String transactionType;
  final double amount;
  final String bookingId;
  final String userId;
  final String status;
  final DateTime paymentDate;
  final String rentMonth;
  final String rentYear;

  Transaction({
    required this.transactionId,
    required this.transactionType,
    required this.amount,
    required this.bookingId,
    required this.userId,
    required this.status,
    required this.paymentDate,
    required this.rentMonth,
    required this.rentYear,
  });

  factory Transaction.fromDocumentSnapshot(DocumentSnapshot doc) {
    
    return Transaction(
      transactionId: doc.id,
      transactionType: doc['transactionType'],
      amount: doc['amount'] as double,
      bookingId: doc['bookingId'],
      userId: doc['userId'],
      status: doc['status'],
      paymentDate: doc['paymentDate'].toDate(),
      rentMonth: doc['rentMonth'],
      rentYear: doc['rentYear'],
    );
  }
}