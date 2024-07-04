part of 'data_bloc.dart';

@immutable
sealed class DataEvent {
  @override
  List<Object> get props => [];
}

class GetProperties extends DataEvent {
  GetProperties();

  @override
  List<Object> get props => [];
}

class AdjustRoomsDetails extends DataEvent {
  final Property property;
  final List<String> addedRooms;
  final String occupancy;

  AdjustRoomsDetails({required this.property, required this.addedRooms, required this.occupancy});

  @override
  List<Object> get props => [property, addedRooms];
}
