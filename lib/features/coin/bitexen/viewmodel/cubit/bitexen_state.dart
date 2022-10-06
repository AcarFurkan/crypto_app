part of 'bitexen_cubit.dart';

@immutable
abstract class BitexenState {}

class BitexenInitial extends BitexenState {}

class BitexenLoading extends BitexenState {}

class BitexenCompleted extends BitexenState {
  //I PUT İT BECAUSE STREAM BUİLD RETURN TO LATE FROM WAİTİNG TO ACTİVE SO PUT THİS FOR SAFETY--İF STREAM connection state is waiting and if l have bitexencoinlistform completed state app will use it 
  final List<MainCurrencyModel>? bitexenCoinsList;

  BitexenCompleted({
      this.bitexenCoinsList,
  });
}

class BitexenError extends BitexenState {
  final String message;
  BitexenError(this.message);
}
