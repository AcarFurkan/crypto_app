 part of'../coin_cubit.dart';
extension SortExtension on CoinCubit{
    orderList(SortTypes type, List<MainCurrencyModel> list) {
    switch (type) {
      case SortTypes.NO_SORT:
        return list;
      case SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE:
        // _orderByHighToLowForLastPrice(list);
        return _orderByHighToLowForLastPrice(list);
      case SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE:
        return _orderByLowToHighForLastPrice(list);
      case SortTypes.HIGH_TO_LOW_FOR_ADDED_PRICE:
        return _orderByHighToLowForAddedPrice(list);
      case SortTypes.LOW_TO_HIGH_FOR_ADDED_PRICE:
        return _orderByLowToHighForAddedPrice(list);
      case SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE:
        return _orderByHighToLowForPercentage(list);
      case SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE:
        return _orderByLowToHighForPercentage(list);
      default:
        break;
    }
  }

   _orderByHighToLowForAddedPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.addedPrice ?? "0")
        .compareTo(double.parse(b.addedPrice ?? "0")));
    return list.reversed.toList();
  }

  _orderByLowToHighForAddedPrice(List<MainCurrencyModel> list) {
    list.sort((a, b) => double.parse(a.addedPrice ?? "0")
        .compareTo(double.parse(b.addedPrice ?? "0")));
    return list;
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