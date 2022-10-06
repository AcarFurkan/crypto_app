import 'dart:async';

import '../../../../model/coin/my_coin_model.dart';

import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../helper/convert_incoming_currency.dart';

class BitexenServiceController {
  final int timerSecond = 2;
   final StreamController<IResponseModel<List<MainCurrencyModel>>>
      _streamController =
      StreamController<IResponseModel<List<MainCurrencyModel>>>.broadcast();
  static BitexenServiceController? _instance;
  static BitexenServiceController get instance {
    _instance ??= BitexenServiceController._init();
    return _instance!;
  }

  BitexenServiceController._init() {
    _previousbitexenCoins = ResponseModel(data: []);
    _lastbitexenCoins = ResponseModel(data: []);
  }

  late Timer timer;

  late IResponseModel<List<MainCurrencyModel>> _previousbitexenCoins;
  late IResponseModel<List<MainCurrencyModel>> _lastbitexenCoins;
  IResponseModel<List<MainCurrencyModel>> get getBitexenCoins =>
      _lastbitexenCoins;

   Stream<IResponseModel<List<MainCurrencyModel>>> get getStream {
    return _streamController.stream;
  }

  Future<void> fetchBitexenCoinListEveryTwoSecond() async {
    await fetchDataTrarnsactions();
    timer = Timer.periodic(Duration(seconds: timerSecond), (timer) async {
      await fetchDataTrarnsactions();
      if (_previousbitexenCoins.data != null &&
          _lastbitexenCoins.data != null) {
        if (_previousbitexenCoins.data!.isNotEmpty &&
            _lastbitexenCoins.data!.isNotEmpty) {
          lastPriceControl(
              _previousbitexenCoins.data!, _lastbitexenCoins.data!);
          //BURAYA DA KONABİLİR EMİN DEĞİLİM BİTSİN SİNK İ KONTROL EDECEĞİM.
        }
        transferLastListToPreviousList(
            _previousbitexenCoins.data!, _lastbitexenCoins.data!);
      }
    });
  }

  Future<void> fetchDataTrarnsactions() async {
    ResponseModel<List<MainCurrencyModel>> response =
        await CurrencyConverter.instance.convertBitexenListCoinToMyCoinList();
    if (response.error != null) {
      _lastbitexenCoins = ResponseModel<List<MainCurrencyModel>>(
          data: _lastbitexenCoins.data, error: response.error);
      _streamController.sink.add(ResponseModel<List<MainCurrencyModel>>(
          data: _lastbitexenCoins.data, error: response.error));
    } else if (response.data != null) {
      _lastbitexenCoins = response;
      _streamController.sink.add(_lastbitexenCoins);
    } else {
      //TODO:BUNU YAPMAMA GEREK VAR MI
      _lastbitexenCoins =
          ResponseModel<List<MainCurrencyModel>>(data: _lastbitexenCoins.data);
      _streamController.sink.add(_lastbitexenCoins);
    }
  }

  void transferLastListToPreviousList(
      List<MainCurrencyModel> previousList, List<MainCurrencyModel> lastList) {
    previousList.clear();
    for (var item in lastList) {
      previousList.add(item);
    }
  }

  void lastPriceControl(
      //TODO: BURDA EĞER İLK 100 COİN DEĞİŞİRSE PATLARSIN HABERİN OLA IDE GORE KONTROL YAP
      List<MainCurrencyModel> previousList,
      List<MainCurrencyModel> lastList) {
    if (lastList.length == previousList.length) {
      for (var i = 0; i < lastList.length; i++) {
        double lastPrice = double.parse(lastList[i].lastPrice ?? "0");
        double previousPrice = double.parse(previousList[i].lastPrice ?? "0");
        if (lastPrice > previousPrice) {
          lastList[i].priceControl = PriceLevelControl.INCREASING.name;
        } else if (previousPrice > lastPrice) {
          lastList[i].priceControl = PriceLevelControl.DESCREASING.name;
        } else {
          lastList[i].priceControl = PriceLevelControl.CONSTANT.name;
        }
      }
    }
  }
}
