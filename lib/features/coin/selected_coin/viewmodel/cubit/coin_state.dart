part of 'coin_cubit.dart';

@immutable
abstract class CoinState {}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinCompleted extends CoinState {
  final List<MainCurrencyModel>? myCoinList;

  CoinCompleted({this.myCoinList});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoinCompleted && other.myCoinList == myCoinList;
  }

  @override
  int get hashCode => myCoinList.hashCode;
}

class CoinAlarm extends CoinState {
  final MainCurrencyModel itemFromDataBase;
  final String message;
  CoinAlarm({
    required this.itemFromDataBase,
    required this.message,
  });
}

class UpdateSelectedCoinPage extends CoinState {
  final bool isSelectedAll;
  final List<MainCurrencyModel>? myCoinList;
  UpdateSelectedCoinPage(this.isSelectedAll, this.myCoinList);
}

class CoinError extends CoinState {
  final String message;
  CoinError(this.message);
}
