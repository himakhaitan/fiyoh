part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}

final class PaymentLoading extends PaymentState {
  @override
  List<Object> get props => [];
}

final class PaymentFailed extends PaymentState {
  final String error;

  PaymentFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class PaymentLoaded extends PaymentState {
  final String total;
  final List<Payment> payments;

  PaymentLoaded({required this.total, required this.payments});

  @override
  List<Object> get props => [total, payments];
}

final class PaymentSuccess extends PaymentState {
  PaymentSuccess();

  @override
  List<Object> get props => [];
}
