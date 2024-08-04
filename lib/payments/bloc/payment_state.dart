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

final class PaymentSuccess extends PaymentState {
  PaymentSuccess();

  @override
  List<Object> get props => [];
}
