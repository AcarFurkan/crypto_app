part of 'add_coin_cubit.dart';

@immutable
abstract class AddCoinState {}

class AddCoinInitial extends AddCoinState {}

class AddCoinLoading extends AddCoinState {}

class AddCoinAlreadyExist extends AddCoinState {}

class AddCoinAlreadyAdded extends AddCoinState {}

class AddCoinSuccessfullylAdded extends AddCoinState {
  final MainCurrencyModel currency;
  AddCoinSuccessfullylAdded({
    required this.currency,
  });
}

class AddCoinCompleted extends AddCoinState {
  final MainCurrencyModel currency;
  AddCoinCompleted({
    required this.currency,
  });
}

class AddCoinError extends AddCoinState {}
