part of '../coin_cubit.dart';

extension DataBaseTrasactions on CoinCubit {
  Future<void> addToDb(MainCurrencyModel incomingCoin) async =>
      await _cacheManager.putItem(incomingCoin.id, incomingCoin);
  Future<void> deleteItemsFromDb() async {
    if (_itemsToBeDelete != null) {
      //_cacheManager.clearAll();  send a value like if  isselectedAll true and run it
      List<MainCurrencyModel>? list = _fetchAllAddedCoinsFromDatabase();

      if (list!.length == _itemsToBeDelete!.length) {
        print("all");
        await _cacheManager.clearAll();
        clearAllItemsFromToDeletedList();
      } else {
        print("single");
        for (var item in _itemsToBeDelete!) {
          await _cacheManager.removeItem(item);
        }
      }

      clearAllItemsFromToDeletedList();
      print(_fetchAllAddedCoinsFromDatabase());
    }
  }

  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() =>
      _cacheManager.getValues();

  void saveDeleteFromFavorites(MainCurrencyModel coin) {
    _cacheManager.getItem(coin.id);
    if (coin.isFavorite) {
      _cacheManager.putItem(coin.id, coin);
    } else {
      if (coin.isAlarmActive) {
        _cacheManager.putItem(coin.id, coin);
      } else {
        _cacheManager.removeItem(coin.id);
      }
    }
  }
}
