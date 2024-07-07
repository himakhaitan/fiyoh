part of 'property_bloc.dart';

@immutable
sealed class PropertyState {
}

final class PropertyInitial extends PropertyState {
  @override
  List<Object> get props => [];
}

final class PropertyLoading extends PropertyState {
  @override
  List<Object> get props => [];
}

final class PropertyFailed extends PropertyState {
  final String error;

  PropertyFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class PropertyLoaded extends PropertyState {
  final List<Property> properties;

  PropertyLoaded({required this.properties});

  @override
  List<Object> get props => [properties];
}
