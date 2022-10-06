part of '../coin_list_page.dart';

extension GeneralTransactions on _CoinListPageState {
  Stream<List<MainCurrencyModel>> getCoinListStream( ) {
    Stream<List<MainCurrencyModel>> stream;
    String currencyName = getCurrencyName;
    if (currencyName == CoinCurrency.TRY.name) {
      stream = context.read<CoinListCubit>().streamTry;
    } else if (currencyName == CoinCurrency.BTC.name) {
      stream = context.read<CoinListCubit>().streamBtc;
    } else if (currencyName == CoinCurrency.ETH.name) {
      stream = context.read<CoinListCubit>().streamEth;
    } else if (currencyName == CoinCurrency.NEW.name) {
      stream = context.read<CoinListCubit>().streamNew;
    } else {
      stream = context.read<CoinListCubit>().streamUsd;
    }

    return stream;
  }

  List<MainCurrencyModel> coinListToShowTransactions(
      List<MainCurrencyModel> coinListToShow,
      ) {
   // String currencyName = getCurrencyName;

  //if (currencyName == CoinCurrency.TRY.name) {
  //  coinListToShow = state.tryCoinsList ?? [];
  //} else if (currencyName == CoinCurrency.BTC.name) {
  //  coinListToShow = state.btcCoinsList ?? [];
  //} else if (currencyName == CoinCurrency.ETH.name) {
  //  coinListToShow = state.ethCoinsList ?? [];
  //} else if (currencyName == CoinCurrency.NEW.name) {
  //  coinListToShow = state.newUsdCoinsList ?? [];
  //} else {
  //  coinListToShow = state.usdtCoinsList ?? [];
  //}

    coinListToShow = searchTransaction(context, coinListToShow);

    coinListToShow = context.read<CoinListCubit>().orderList(
        context.read<ListPageGeneralCubit>().getorderByDropDownValue,
        coinListToShow);
    return coinListToShow;
  }
  
  String get getCurrencyName {
    switch (_tabController.index) {
      case 0:
        return CoinCurrency.USD.name;
      case 1:
        return CoinCurrency.TRY.name;
      case 2:
        return CoinCurrency.ETH.name;
      case 3:
        return CoinCurrency.BTC.name;
      case 4:
        return CoinCurrency.NEW.name;
      default:
        return CoinCurrency.USD.name;
    }
  }

  List<MainCurrencyModel> findRightList(
      CoinListCompleted state, BuildContext context) {
    List<MainCurrencyModel> coinListToShow = [];
    String currencyName = getCurrencyName;
     if (currencyName == CoinCurrency.TRY.name) {
      coinListToShow = state.tryCoinsList ?? [];
    } else if (currencyName == CoinCurrency.BTC.name) {
      coinListToShow = state.btcCoinsList ?? [];
    } else if (currencyName == CoinCurrency.ETH.name) {
      coinListToShow = state.ethCoinsList ?? [];
    } else if (currencyName == CoinCurrency.NEW.name) {
      coinListToShow = state.newUsdCoinsList ?? [];
    } else {
      coinListToShow = state.usdtCoinsList ?? [];
    }
    return coinListToShow;
  }

  GlobalKey menuKeyTransactions(String currency, BuildContext context) {
    if (currency == CoinCurrency.USD.name) {
      return context.read<ListPageGeneralCubit>().menuKeyUSD;
    } else if (currency == CoinCurrency.ETH.name) {
      return context.read<ListPageGeneralCubit>().menuKeyETH;
    } else if (currency == CoinCurrency.TRY.name) {
      return context.read<ListPageGeneralCubit>().menuKeyTRY;
    } else if (currency == CoinCurrency.BTC.name) {
      return context.read<ListPageGeneralCubit>().menuKeyBTC;
    } else if (currency == CoinCurrency.NEW.name) {
      return context.read<ListPageGeneralCubit>().menuKeyNEW;
    } else {
      return context.read<ListPageGeneralCubit>().menuKeyUSD;
    }
  }
}
