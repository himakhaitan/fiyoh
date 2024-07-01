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


