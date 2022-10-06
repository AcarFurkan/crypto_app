 part of'../coin_list_cubit.dart';
extension ListenerExtension on CoinListCubit{
  Stream<List<MainCurrencyModel>> get streamTry =>
      _streamControllerForTry.stream;

  Stream<List<MainCurrencyModel>> get streamUsd =>
      _streamControllerForUsd.stream;

  Stream<List<MainCurrencyModel>> get streamEth =>
      _streamControllerForEth.stream;

  Stream<List<MainCurrencyModel>> get streamBtc =>
      _streamControllerForBtc.stream;

  Stream<List<MainCurrencyModel>> get streamNew =>
      _streamControllerForNew.stream;
       void listenStreamNew() =>
      GechoServiceController.instance.streamNew.listen((event) {
        if (event.error != null) {
          // if somethink went wrong l wont show it anyuser.!!
          emit(CoinListCompleted());
        }
        if (event.data != null) {
          coinListFromDb = getAllListFromDB() ?? [];
          favoriteFeatureAndAlarmTransaction(coinListFromDb, event.data!);
          newCoins = event.data!;
        // emit(CoinListCompleted(
        //     tryCoinsList: tryCoins,
        //     btcCoinsList: btcCoins,
        //     ethCoinsList: ethCoins,
        //     usdtCoinsList: usdtCoins,
        //     newUsdCoinsList: newCoins));
          _streamControllerForNew.sink.add(newCoins);
        } else {
          emit(CoinListCompleted());
        }
      });

  void listenStreamBtc() =>
      GechoServiceController.instance.streamBtc.listen((event) {
        if (event.error != null) {
          // if somethink went wrong l wont show it anyuser.!!
          emit(CoinListCompleted());
        }
        if (event.data != null) {
          coinListFromDb = getAllListFromDB() ?? [];
          favoriteFeatureAndAlarmTransaction(coinListFromDb, event.data!);
          btcCoins = event.data!;
       //  emit(CoinListCompleted(
       //      tryCoinsList: tryCoins,
       //      btcCoinsList: btcCoins,
       //      ethCoinsList: ethCoins,
       //      usdtCoinsList: usdtCoins,
       //      newUsdCoinsList: newCoins));
          _streamControllerForBtc.sink.add(btcCoins);
        } else {
          emit(CoinListCompleted());
        }
      });

  void listenStreamEth() =>
      GechoServiceController.instance.streamEth.listen((event) {
        if (event.error != null) {
          // if somethink went wrong l wont show it anyuser.!!
          emit(CoinListCompleted());
        }
        if (event.data != null) {
          coinListFromDb = getAllListFromDB() ?? [];
          favoriteFeatureAndAlarmTransaction(coinListFromDb, event.data!);
          ethCoins = event.data!;
        //  emit(CoinListCompleted(
        //      tryCoinsList: tryCoins,
        //      btcCoinsList: btcCoins,
        //      ethCoinsList: ethCoins,
        //      usdtCoinsList: usdtCoins,
        //      newUsdCoinsList: newCoins));
        //  _streamControllerForEth.sink.add(ethCoins);
        } else {
          emit(CoinListCompleted());
        }
      });

  void listenStreamTry() =>
      GechoServiceController.instance.streamTry.listen((event) {
        if (event.error != null) {
          // if somethink went wrong l wont show it anyuser.!!
          emit(CoinListCompleted());
        }
        if (event.data != null) {
          coinListFromDb = getAllListFromDB() ?? [];
          favoriteFeatureAndAlarmTransaction(coinListFromDb, event.data!);
          tryCoins = event.data!;
         //emit(CoinListCompleted(
         //    tryCoinsList: tryCoins,
         //    btcCoinsList: btcCoins,
         //    ethCoinsList: ethCoins,
         //    usdtCoinsList: usdtCoins,
         //    newUsdCoinsList: newCoins));
          _streamControllerForTry.sink.add(tryCoins);
        } else {
          emit(CoinListCompleted());
        }
      });

  void listenStreamUsd() =>
      GechoServiceController.instance.streamUsd.listen((event) {
        if (event.error != null) {
          // if somethink went wrong l wont show it anyuser.!!
          emit(CoinListCompleted());
        }
        if (event.data != null) {
          coinListFromDb = getAllListFromDB() ?? [];
          favoriteFeatureAndAlarmTransaction(coinListFromDb, event.data!);
          usdtCoins = event.data!;
         // emit(CoinListCompleted(
         //     tryCoinsList: tryCoins,
         //     btcCoinsList: btcCoins,
         //     ethCoinsList: ethCoins,
         //     usdtCoinsList: usdtCoins,
         //     newUsdCoinsList: newCoins));

          _streamControllerForUsd.sink.add(usdtCoins);
        } else {
          emit(CoinListCompleted());
        }
      });
}