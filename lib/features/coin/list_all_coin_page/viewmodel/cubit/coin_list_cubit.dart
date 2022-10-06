import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../../../locator.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';
import '../../../selected_coin/viewmodel/cubit/coin_cubit.dart';
part 'coin_list_state.dart';
part './extensions/listeners_extension.dart';
part './extensions/order_trasnactions_extension.dart';
part './extensions/database_transactions_extension.dart';

class CoinListCubit extends Cubit<CoinListState> {
  CoinListCubit() : super(CoinListInitial());
  final CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();

  final StreamController<List<MainCurrencyModel>> _streamControllerForTry =
      StreamController<List<MainCurrencyModel>>.broadcast();
  final StreamController<List<MainCurrencyModel>> _streamControllerForUsd =
      StreamController<List<MainCurrencyModel>>.broadcast();
  final StreamController<List<MainCurrencyModel>> _streamControllerForBtc =
      StreamController<List<MainCurrencyModel>>.broadcast();
  final StreamController<List<MainCurrencyModel>> _streamControllerForEth =
      StreamController<List<MainCurrencyModel>>.broadcast();
  final StreamController<List<MainCurrencyModel>> _streamControllerForNew =
      StreamController<List<MainCurrencyModel>>.broadcast();

  void startStream() {
    emit(CoinListLoading());
    listenStreamTry();
    listenStreamEth();
    listenStreamBtc();
    listenStreamNew();
    listenStreamUsd();
    emit(CoinListCompleted());
  }

  List<MainCurrencyModel> tryCoins = [];
  List<MainCurrencyModel> btcCoins = [];
  List<MainCurrencyModel> ethCoins = [];
  List<MainCurrencyModel> usdtCoins = [];
  List<MainCurrencyModel> newCoins = [];

  List<MainCurrencyModel> coinListFromDb = [];
  void updateForSearch() {
     emit(CoinListCompleted());
  }

  void updateCompletedList() {
    coinListFromDb = getAllListFromDB() ?? [];
    favoriteFeatureAndAlarmTransaction(coinListFromDb, usdtCoins);
    _streamControllerForUsd.sink.add(usdtCoins);
    favoriteFeatureAndAlarmTransaction(coinListFromDb, tryCoins);
    _streamControllerForTry.sink.add(tryCoins);
    favoriteFeatureAndAlarmTransaction(coinListFromDb, ethCoins);
    _streamControllerForEth.sink.add(ethCoins);
    favoriteFeatureAndAlarmTransaction(coinListFromDb, btcCoins);
    _streamControllerForBtc.sink.add(btcCoins);
    favoriteFeatureAndAlarmTransaction(coinListFromDb, newCoins);
    _streamControllerForNew.sink.add(newCoins);
    //emit(CoinListCompleted(
    //    btcCoinsList: btcCoins,
    //    ethCoinsList: ethCoins,
    //    newUsdCoinsList: newCoins,
    //    tryCoinsList: tryCoins,
    //    usdtCoinsList: usdtCoins));
  }
}
