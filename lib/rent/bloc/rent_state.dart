part of 'rent_bloc.dart';

@immutable
sealed class RentState {}

final class RentInitial extends RentState {
  @override
  List<Object> get props => [];
}

final class RentLoading extends RentState {
  @override
  List<Object> get props => [];
}

final class RentFailed extends RentState {
  final String error;

  RentFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class RentLoaded extends RentState {
  final List<RentData> rentDataList;
  RentLoaded({required this.rentDataList});

  @override
  List<Object> get props => [rentDataList];
}
