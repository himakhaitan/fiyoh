part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class DepositTransaction extends PaymentEvent {
  final String bookingId;
  final String propertyId;
  final double amount;
  final String paymentMethod;
  final String status;
  final String refundableAmount;
  final String nonRefundableAmount;

  DepositTransaction({
    required this.bookingId,
    required this.propertyId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.refundableAmount,
    required this.nonRefundableAmount,
  });
}

class RentTransaction extends PaymentEvent {
  final String bookingId;
  final String propertyId;
  final double amount;
  final String paymentMethod;
  final String startDate;
  final String endDate;
  final String rent;
  final String food;
  final String electricity;
  final String laundry;
  final String misc;

  RentTransaction({
    required this.bookingId,
    required this.amount,
    required this.propertyId,
    required this.paymentMethod,
    required this.startDate,
    required this.endDate,
    required this.rent,
    required this.food,
    required this.electricity,
    required this.laundry,
    required this.misc,
  });
}

class GetPayments extends PaymentEvent {
  final List<Property> propertyIds;

  GetPayments({required this.propertyIds});
}