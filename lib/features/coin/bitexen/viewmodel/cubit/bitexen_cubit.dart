import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import 'package:meta/meta.dart';

import '../../../../../locator.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/bitexen/bitexen_service_controller.dart';

part 'bitexen_state.dart';

class BitexenCubit extends Cubit<BitexenState> {
  BitexenCubit() : super(BitexenInitial());
  final CoinCacheManager _coinCacheManager = locator<CoinCacheManager>();
  final StreamController<List<MainCurrencyModel>>
      _streamControllerForBitexenData =
      StreamController<List<MainCurrencyModel>>.broadcast();

  Stream<List<MainCurrencyModel>> get streamBitexenData {
    return _streamControllerForBitexenData.stream;
  }

  Timer? timer;
  List<MainCurrencyModel> bitexenCoins = [];
  List<MainCurrencyModel> coinListFromDb = [];

  void updateCompletedList() {
    if (bitexenCoins.isNotEmpty) {
      coinListFromDb = getAllListFromDB() ?? [];
      favoriteFeatureAndAlarmTransaction(coinListFromDb, bitexenCoins);
      _streamControllerForBitexenData.sink.add(bitexenCoins);
      emit(BitexenCompleted(bitexenCoinsList: bitexenCoins));
    }
  }

  //all fetch and emit transactions inside consturctor.
  void startStream() {
    emit(BitexenLoading());

    BitexenServiceController.instance.getStream.listen((event) {
      if (event.error != null) {
        // if somethink went wrong l wont show it anyuser.!!
        emit(BitexenCompleted());
      }
      if (event.data != null) {
        coinListFromDb = getAllListFromDB() ?? [];
        favoriteFeatureAndAlarmTransaction(coinListFromDb, event.data!);
        bitexenCoins = event.data!;
        _streamControllerForBitexenData.sink.add(bitexenCoins);
        emit(BitexenCompleted(bitexenCoinsList: bitexenCoins));
      } else {
        emit(BitexenCompleted());
      }
    });
  }

  Future<void> fetchAllCoins() async {
    emit(BitexenLoading());
    // dataTransaction();
    timer = Timer.periodic(const Duration(milliseconds: 5000), (Timer t) async {
      coinListFromDb = getAllListFromDB() ?? [];
      //  dataTransaction();
    });
  }

  int count = 0;
  void dataTransaction(List<MainCurrencyModel> listFromService) {
    bitexenCoins.clear();
    var response = fetchBitexenCoinListFromService();
    if (response.error != null) {
      emit(BitexenError("Bitexen ERRRRRRRRRRRRORRRR"));
    }
    if (response.data != null) {
      for (var item in response.data!) {
        bitexenCoins.add(item);
        favoriteFeatureAndAlarmTransaction(coinListFromDb, bitexenCoins);
      }

      emit(BitexenCompleted());
    }
  }

  IResponseModel<List<MainCurrencyModel>> fetchBitexenCoinListFromService() {
    return BitexenServiceController.instance.getBitexenCoins;
  }

  Stream<IResponseModel<List<MainCurrencyModel>>> getStreamFromService() {
    return BitexenServiceController.instance.getStream;
  }

  void favoriteFeatureAndAlarmTransaction(
      List<MainCurrencyModel> incomingCoinListFromDb,
      List<MainCurrencyModel> incomingListFromService) {
    for (var itemFromDb in incomingCoinListFromDb) {
      for (var itemFromService in incomingListFromService) {
        if (itemFromDb.id == itemFromService.id) {
          itemFromService.isFavorite = itemFromDb.isFavorite;
          itemFromService.isAlarmActive = itemFromDb.isAlarmActive;
        }
      }
    }
  }

  void updateFromFavorites(MainCurrencyModel coin) {
    getFormDb(coin.id);
    if (coin.isFavorite) {
      _coinCacheManager.putItem(coin.id, coin);
    } else {
      if (coin.isAlarmActive) {
        _coinCacheManager.putItem(coin.id, coin);
      } else {
        _coinCacheManager.removeItem(coin.id);
      }
    }
  }

  MainCurrencyModel? getFormDb(String id) {
    return _coinCacheManager.getItem(id);
  }

  List<MainCurrencyModel>? getAllListFromDB() {
    return _coinCacheManager.getValues();
  }

  orderList(SortTypes type, List<MainCurrencyModel> list) {
    switch (type) {
      case SortTypes.NO_SORT:
        return list;
      case SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE:
        // _orderByHighToLowForLastPrice(list);
        return _orderByHighToLowForLastPrice(list);
      case SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE:
        return _orderByLowToHighForLastPrice(list);

      case SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE:
        return _orderByHighToLowForPercentage(list);
      case SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE:
        return _orderByLowToHighForPercentage(list);
      default:
        break;
    }
  }

  _orderByHighToLowForLastPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.lastPrice ?? "0")
        .compareTo(double.parse(b.lastPrice ?? "0")));
    return list.reversed.toList();
  }

  _orderByLowToHighForLastPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.lastPrice ?? "0")
        .compareTo(double.parse(b.lastPrice ?? "0")));
    return list;
  }

  _orderByHighToLowForPercentage(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.changeOf24H ?? "0")
        .compareTo(double.parse(b.changeOf24H ?? "0")));
    return list.reversed.toList();
  }

  _orderByLowToHighForPercentage(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.changeOf24H ?? "0")
        .compareTo(double.parse(b.changeOf24H ?? "0")));
    return list;
  }
}
