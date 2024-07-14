part of 'room_bloc.dart';

@immutable
sealed class RoomState {}

final class RoomInitial extends RoomState {
  @override
  List<Object> get props => [];
}

final class RoomLoading extends RoomState {
  @override
  List<Object> get props => [];
}

final class RoomFailed extends RoomState {
  final String error;

  RoomFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class RoomLoaded extends RoomState {
  final List<String> tenants;

  RoomLoaded({required this.tenants});

  @override
  List<Object> get props => [tenants];
}
