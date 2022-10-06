// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/core/enums/locale_keys_enum.dart';
import 'package:coin_with_architecture/core/extension/context_extension.dart';
import 'package:coin_with_architecture/product/alarm_manager/alarm_manager.dart';
import 'package:coin_with_architecture/product/language/locale_keys.g.dart';
import 'package:coin_with_architecture/product/repository/cache/app_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/cache/coin_id_list_cache_manager.dart';
import 'package:coin_with_architecture/product/repository/service/market/gecho/gecho_service.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/src/provider.dart';

import '../../../../../core/enums/back_up_enum.dart';

import '../../../../../locator.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import '../../../../../product/model/user/my_user_model.dart';
import '../../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../../product/repository/service/market/bitexen/bitexen_service_controller.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';
import '../../../../../product/repository/service/user_service_controller/user_service_controller.dart';
import '../../../../authentication/viewmodel/cubit/user_cubit.dart';
import '../../../../settings/subpage/audio_settings/model/audio_model.dart';

part 'coin_state.dart';
part './extension/listener_extension.dart';
part './extension/back_up_trasactions.dart';
part './extension/service_transactions.dart';
part './extension/alarm_trasactions.dart';
part './extension/sort_trasactions.dart';
part './extension/database_trasactions.dart';

enum levelControl { INCREASING, DESCREASING, CONSTANT }
enum SortTypes {
  NO_SORT,
  HIGH_TO_LOW_FOR_LAST_PRICE,
  LOW_TO_HIGH_FOR_LAST_PRICE,
  HIGH_TO_LOW_FOR_PERCENTAGE,
  LOW_TO_HIGH_FOR_PERCENTAGE,
  HIGH_TO_LOW_FOR_ADDED_PRICE,
  LOW_TO_HIGH_FOR_ADDED_PRICE,
}

class CoinCubit extends Cubit<CoinState> {
  CoinCubit({required this.context}) : super(CoinInitial());
  final StreamController<List<MainCurrencyModel>> _streamController =
      StreamController<List<MainCurrencyModel>>.broadcast();
      
  BuildContext context;

  //I added this to update view when user try to change sort type
  List<MainCurrencyModel> listOfAllCurrenciesFromService = [];
  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  
  List<String>? _itemsToBeDelete;
  List<String>? get itemsToBeDelete => _itemsToBeDelete;
  
  final CoinIdListCacheManager _coinIdListCacheManager =
      locator<CoinIdListCacheManager>();

  final AppCacheManager _appCacheManager = locator<AppCacheManager>();
   
   Stream<List<MainCurrencyModel>> get streamListData =>
      _streamController.stream;

  void updatePage() =>
      emit(CoinCompleted(myCoinList: _fetchAllAddedCoinsFromDatabase()));

  void startStream() {
    emit(CoinLoading());
    List<MainCurrencyModel>? coinListFromDataBase =
        _fetchAllAddedCoinsFromDatabase();

    coinListFromDataBase ??= [];
    listenNewCurriesStream(coinListFromDataBase);
    listenUsdStream(coinListFromDataBase);
    listenBtcStream(coinListFromDataBase);
    listenEthStream(coinListFromDataBase);
    listenTryStream(coinListFromDataBase);
    listenBitexen(coinListFromDataBase);
     emit(CoinCompleted(myCoinList: coinListFromDataBase));
  }

  void updateCompletedList() {
    var coinListFromDataBase = _fetchAllAddedCoinsFromDatabase();// I AM NOT SURE
      _streamController.sink.add(coinListFromDataBase!);
      emit(CoinCompleted(myCoinList: coinListFromDataBase));
     
  }

  void calculatePercentageDifferencesSinceAddedTime(List<MainCurrencyModel> list) {
    for (var item in list) {
      double addedPrice = double.parse(item.addedPrice ?? "0");
      double lastPrice = double.parse(item.lastPrice ?? "0");
      double difference = lastPrice - addedPrice;
      item.changeOfPercentageSincesAddedTime =
          ((difference / addedPrice) * 100).toString();
    }
  }

  void dataFullTransactions(
      List<MainCurrencyModel> coinListFromDataBase, //COTAİNSLE KISALT
      List<MainCurrencyModel> coinListFromService) {
    for (var i = 0; i < coinListFromService.length; i++) {
      for (var itemFromDataBase in coinListFromDataBase) {
        if (coinListFromService[i].id == itemFromDataBase.id) {
          MainCurrencyModel currentSeviceItem = coinListFromService[i];
          double lastPrice = double.parse(currentSeviceItem.lastPrice ?? "0");
          arrangeCurrencyByInComingValue(itemFromDataBase, currentSeviceItem);
          alarmControl(lastPrice, itemFromDataBase);
        }
      }
    }
  }

  void arrangeCurrencyByInComingValue(
      MainCurrencyModel itemFromDataBase, MainCurrencyModel currentSeviceItem) {
    itemFromDataBase.changeOf24H = currentSeviceItem.changeOf24H ?? "0";
    itemFromDataBase.lastUpdate = currentSeviceItem.lastUpdate;
    itemFromDataBase.percentageControl = currentSeviceItem.percentageControl;
    itemFromDataBase.priceControl = currentSeviceItem.priceControl;
    itemFromDataBase.lastPrice = currentSeviceItem.lastPrice ?? "0";
    itemFromDataBase.highOf24h = currentSeviceItem.highOf24h ?? "0";
    itemFromDataBase.lowOf24h = currentSeviceItem.lowOf24h ?? "0";
  }


 
  void updatePageForDelete({bool isSelected = false}) => emit(
      UpdateSelectedCoinPage(isSelected, _fetchAllAddedCoinsFromDatabase()));

  void addItemToBeDeletedList(String id) {
    _itemsToBeDelete ??= [];
    for (var item in _itemsToBeDelete!) {
      if (item == id) {
        return;
      }
    }
    _itemsToBeDelete!.add(id);
  }

  void removeItemFromBeDeletedList(String id) {
    _itemsToBeDelete ??= [];
    for (var item in _itemsToBeDelete!) {
      if (item == id) {
        _itemsToBeDelete!.remove(id);
        return;
      }
    }
  }

  void clearAllItemsFromToDeletedList() {
    if (_itemsToBeDelete != null) {
      _itemsToBeDelete!.clear();
    }
  }
}
