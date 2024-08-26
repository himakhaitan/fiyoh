part of 'room_bloc.dart';

@immutable
sealed class RoomEvent {
  @override
  List<Object> get props => [];
}

class GetTenants extends RoomEvent {
  final Room room;

  GetTenants({required this.room});

  @override
  List<Object> get props => [room];
}
