import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyoh/models/property.dart';
import 'package:fiyoh/payments/models/payment.dart';
import 'package:fiyoh/utils/format_double.dart';
import 'package:meta/meta.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PaymentBloc() : super(PaymentInitial()) {
    on<DepositTransaction>(
        (event, emit) => _handleDepositTransaction(event, emit));
    on<RentTransaction>((event, emit) => _handleRentTransaction(event, emit));
    on<GetPayments>((event, emit) => _handleGetPayments(event, emit));
  }

  Future<void> _handleGetPayments(
      GetPayments event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      List<Payment> payments = [];
      double total = 0.00;
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
      
      for (Property property in event.propertyIds) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('transactions')
            .where('property_id', isEqualTo: property.id)
            .where('transaction_timestamp',
                isGreaterThanOrEqualTo: startOfMonth)
            .where('transaction_timestamp', isLessThanOrEqualTo: endOfMonth)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          payments
              .add(Payment.fromDocumentSnapshot(doc, property.propertyName));
          total += double.tryParse(doc['amount'].toString()) ?? 0.00;
        }
      }

      emit(PaymentLoaded(total: formatDouble(total), payments: payments));
    } catch (e) {
      print(e);
      emit(PaymentFailed(error: e.toString()));
    }
  }

  Future<void> _handleRentTransaction(
      RentTransaction event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      DateTime startDate = DateTime.parse(event.startDate);
      DateTime endDate = DateTime.parse(event.endDate);

      List<Map<String, dynamic>> createClassificationList() {
        List<Map<String, dynamic>> classification = [];

        double rent = double.tryParse(event.rent) ?? 0.00;
        double food = double.tryParse(event.food) ?? 0.00;
        double electricity = double.tryParse(event.electricity) ?? 0.00;
        double laundry = double.tryParse(event.laundry) ?? 0.00;
        double misc = double.tryParse(event.misc) ?? 0.00;

        if (rent != 0.00) {
          classification.add({'type': 'RENT', 'amount': rent});
        }
        if (food != 0.00) {
          classification.add({'type': 'FOOD', 'amount': food});
        }
        if (electricity != 0.00) {
          classification.add({'type': 'ELECTRICITY', 'amount': electricity});
        }
        if (laundry != 0.00) {
          classification.add({'type': 'LAUNDRY', 'amount': laundry});
        }
        if (misc != 0.00) {
          classification.add({'type': 'MISC', 'amount': misc});
        }

        return classification;
      }

      await _firestore.collection('transactions').add({
        'booking_id': event.bookingId,
        'property_id': event.propertyId,
        'amount': event.amount,
        'payment_method': event.paymentMethod,
        'status': 'PAID',
        'transaction_timestamp': FieldValue.serverTimestamp(),
        'transaction_type': 'RENT',
        'classification': createClassificationList(),
        'start_date': startDate,
        'end_date': endDate,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailed(error: e.toString()));
    }
  }

  Future<void> _handleDepositTransaction(
      DepositTransaction event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      // Create a transaction
      await _firestore.collection('transactions').add({
        'booking_id': event.bookingId,
        'property_id': event.propertyId,
        'amount': event.amount,
        'payment_method': event.paymentMethod,
        'status': 'PAID',
        'transaction_timestamp': FieldValue.serverTimestamp(),
        'transaction_type': 'DEPOSIT',
        'classification': [
          {
            'type': 'REFUNDABLE',
            'amount': double.tryParse(event.refundableAmount) ?? 0.00,
          },
          {
            'type': 'NON_REFUNDABLE',
            'amount': double.tryParse(event.nonRefundableAmount) ?? 0.00,
          }
        ],
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
        'start_date': null,
        'end_date': null,
      });
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailed(error: e.toString()));
    }
  }
}
