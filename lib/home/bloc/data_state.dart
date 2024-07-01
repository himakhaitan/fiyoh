part of 'data_bloc.dart';

@immutable
sealed class DataState {}

final class DataInitial extends DataState {
  @override
  List<Object> get props => [];
}

final class DataLoading extends DataState {
  @override
  List<Object> get props => [];
}

final class DataLoaded extends DataState {
  final List<Property> properties;

  DataLoaded({required this.properties});

  @override
  List<Object> get props => [properties];
}

final class DataFailure extends DataState {
  final String error;

  DataFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class DataSuccess extends DataState {
  final List<Property> properties;

  DataSuccess({required this.properties});

  @override
  List<Object> get props => [properties];
}