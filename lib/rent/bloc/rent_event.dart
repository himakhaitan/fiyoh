part of 'rent_bloc.dart';

@immutable
sealed class RentEvent {}

class GetRentData extends RentEvent {
  GetRentData();

  @override
  List<Object> get props => [];
}