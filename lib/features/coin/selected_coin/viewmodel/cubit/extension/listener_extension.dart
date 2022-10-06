 part of '../coin_cubit.dart';
extension ListenExtension on CoinCubit{
  void listenNewCurriesStream(List<MainCurrencyModel>? coinListFromDataBase) {
    GechoServiceController.instance.streamNew.listen((event) {
      
      if (event.error != null) {
        // if somethink went wrong l wont show it anyuser.!!
        // emit(CoinCompleted());
      }
      if (event.data != null) {
        for (var item in event.data!) {
          if (listOfAllCurrenciesFromService.contains(item)) {
            listOfAllCurrenciesFromService[
                listOfAllCurrenciesFromService.indexOf(item)] = item;
          } else {
            listOfAllCurrenciesFromService.add(item);
          }
        }
        coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();
        if (event.data != null) {
          dataFullTransactions(
              coinListFromDataBase!, listOfAllCurrenciesFromService);
        }

        calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase!);
        _streamController.sink.add(coinListFromDataBase!);
      //  emit(CoinCompleted(myCoinList: coinListFromDataBase));
      } else {}
    });
  }

  void listenUsdStream(List<MainCurrencyModel>? coinListFromDataBase) {
    GechoServiceController.instance.streamUsd.listen((event) async {
      allCoinIdListBackUpCheck(); //FETCH ALL COİN İD LİST
      MyUser? myUser = context.read<UserCubit>().user;

      await backUpCheck(myUser, coinListFromDataBase ?? []);
      if (event.error != null) {}
      if (event.data != null) {
        for (var item in event.data!) {
          if (listOfAllCurrenciesFromService.contains(item)) {
            listOfAllCurrenciesFromService[
                listOfAllCurrenciesFromService.indexOf(item)] = item;
          } else {
            listOfAllCurrenciesFromService.add(item);
          }
        }
        coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();
        if (event.data != null) {
          dataFullTransactions(
              coinListFromDataBase!, listOfAllCurrenciesFromService);
        }
        calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase!);
        _streamController.sink.add(coinListFromDataBase!);
      //  emit(CoinCompleted(myCoinList: coinListFromDataBase));
      } else {}
    });
  }

  void listenBtcStream(List<MainCurrencyModel>? coinListFromDataBase) {
    GechoServiceController.instance.streamBtc.listen((event) {
      if (event.error != null) {}
      if (event.data != null) {
        for (var item in event.data!) {
          if (listOfAllCurrenciesFromService.contains(item)) {
            listOfAllCurrenciesFromService[
                listOfAllCurrenciesFromService.indexOf(item)] = item;
          } else {
            listOfAllCurrenciesFromService.add(item);
          }
        }
        coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();
        if (event.data != null) {
          dataFullTransactions(
              coinListFromDataBase!, listOfAllCurrenciesFromService);
        }
        calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase!);
        _streamController.sink.add(coinListFromDataBase!);
      //  emit(CoinCompleted(myCoinList: coinListFromDataBase));
      } else {}
    });
  }

  void listenEthStream(List<MainCurrencyModel>? coinListFromDataBase) {
    GechoServiceController.instance.streamEth.listen((event) {
      if (event.error != null) {}
      if (event.data != null) {
        for (var item in event.data!) {
          if (listOfAllCurrenciesFromService.contains(item)) {
            listOfAllCurrenciesFromService[
                listOfAllCurrenciesFromService.indexOf(item)] = item;
          } else {
            listOfAllCurrenciesFromService.add(item);
          }
        }
        coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();
        if (event.data != null) {
          dataFullTransactions(
              coinListFromDataBase!, listOfAllCurrenciesFromService);
        }
        calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase!);
        _streamController.sink.add(coinListFromDataBase!);
      //  emit(CoinCompleted(myCoinList: coinListFromDataBase));
      } else {}
    });
  }

  void listenTryStream(List<MainCurrencyModel>? coinListFromDataBase) {
    GechoServiceController.instance.streamTry.listen((event) {
      if (event.error != null) {}
      if (event.data != null) {
        for (var item in event.data!) {
          if (listOfAllCurrenciesFromService.contains(item)) {
            listOfAllCurrenciesFromService[
                listOfAllCurrenciesFromService.indexOf(item)] = item;
          } else {
            listOfAllCurrenciesFromService.add(item);
          }
        }
        coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();
        if (event.data != null) {
          dataFullTransactions(
              coinListFromDataBase!, listOfAllCurrenciesFromService);
        }
        calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase!);
        _streamController.sink.add(coinListFromDataBase!);
       // emit(CoinCompleted(myCoinList: coinListFromDataBase));
      } else {}
    });
  }

  void listenBitexen(List<MainCurrencyModel>? coinListFromDataBase) {
    BitexenServiceController.instance.getStream.listen((event) {
      if (event.error != null) {}
      if (event.data != null) {
        for (var item in event.data!) {
          if (listOfAllCurrenciesFromService.contains(item)) {
            listOfAllCurrenciesFromService[
                listOfAllCurrenciesFromService.indexOf(item)] = item;
          } else {
            listOfAllCurrenciesFromService.add(item);
          }
        }
        coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();
        if (event.data != null) {
          dataFullTransactions(
              coinListFromDataBase!, listOfAllCurrenciesFromService);
        }
        calculatePercentageDifferencesSinceAddedTime(coinListFromDataBase!);
        _streamController.sink.add(coinListFromDataBase!);
      //  emit(CoinCompleted(myCoinList: coinListFromDataBase));
      } else {}
    });
  }

}