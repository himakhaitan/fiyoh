import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rent_event.dart';
part 'rent_state.dart';

class RentBloc extends Bloc<RentEvent, RentState> {
  RentBloc() : super(RentInitial()) {
    on<RentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
