part of 'coin_list_cubit.dart';

@immutable
abstract class CoinListState {}

class CoinListInitial extends CoinListState {}

class CoinListLoading extends CoinListState {}

class CoinListCompleted extends CoinListState {
  final List<MainCurrencyModel>? tryCoinsList;
  final List<MainCurrencyModel>? usdtCoinsList;
  final List<MainCurrencyModel>? btcCoinsList;
  final List<MainCurrencyModel>? ethCoinsList;
  final List<MainCurrencyModel>? newUsdCoinsList;
   CoinListCompleted(
      {  this.usdtCoinsList,
        this.btcCoinsList,
        this.ethCoinsList,
        this.tryCoinsList,
        this.newUsdCoinsList,
       });
}

class CoinListError extends CoinListState {
  final String message;
  CoinListError(this.message);
}
