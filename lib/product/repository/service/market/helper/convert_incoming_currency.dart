import '../opensea/opensea_service.dart';

import '../../../../model/coin/my_coin_model.dart';
import 'package:intl/intl.dart';

import '../../../../../core/enums/price_control.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../response_models/bitexen/bitexen_response_model.dart';
import '../../../../response_models/gecho/gecho_service_model.dart';
import '../../../../response_models/genelpara/genelpara_service_model.dart';
import '../../../../response_models/hurriyet/hurriyet_response_model.dart';
import '../../../../response_models/truncgil/truncgil_response_model.dart';
import '../bitexen/bitexen_service.dart';
import '../gecho/gecho_service.dart';
import '../genelpara/genelpara_service.dart';
import '../hurriyet/hurriyet_service.dart';
import '../truncgil/truncgil_service.dart';
import '../../../../response_models/opensea/opensea_response_model.dart';

class CurrencyConverter {
  static CurrencyConverter? _instance;
  static CurrencyConverter get instance {
    _instance ??= CurrencyConverter._init();
    return _instance!;
  }

  CurrencyConverter._init();

  Future<ResponseModel<MainCurrencyModel>> convertBitexenCoinToMyCoin(
      String name) async {
    var response = await BitexenService.instance.getCoinByName(name);

    Bitexen? bitexenCoin = response.data;
    MainCurrencyModel? myCoin;
    if (bitexenCoin != null) {
      myCoin = mainCurrencyGeneratorFromBitexenModel(bitexenCoin);
    }
    return ResponseModel<MainCurrencyModel>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertBitexenListCoinToMyCoinList() async {
    var response = await BitexenService.instance.getAllCoins();
    List<Bitexen>? bitexenCoinList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (bitexenCoinList != null) {
      myCoin = bitexenCoinList
          .map((e) => mainCurrencyGeneratorFromBitexenModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<MainCurrencyModel>>
      convertNftCollectionToMainCurrency() async {
    var response = await OpenSeaService.instance.getCollection();

    OpenSea? collection = response.data;
    MainCurrencyModel? myCurrency;
    if (collection != null) {
      myCurrency = mainCurrencyGeneratorFromOpenSeaModel(collection);
    }
    return ResponseModel<MainCurrencyModel>(
        data: myCurrency, error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromOpenSeaModel(OpenSea collection) {
    return MainCurrencyModel(
      name: "ninja",
      lastPrice: collection.floorPrice.toString(),
      id: "ninja" + "opensea" + "ETH",
      //changeOf24H: collection.change24H,
      counterCurrencyCode: "ETH",
      //lowOf24h: collection.low24H,
      //highOf24h: collection.high24H,
    ); //DateFormat.jms().format(date)/// DateFormat.jms().format(date)
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertGenelParaStockListToMyMainCurrencyList() async {
    var response = await GenelParaService.instance.getAllGenelParaStocksList();

    List<GenelPara>? genelParaStocksList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (genelParaStocksList != null) {
      myCoin = genelParaStocksList
          .map((e) => mainCurrencyGeneratorFromGenelParaStockModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromGenelParaStockModel(GenelPara e) {
    return MainCurrencyModel(
      counterCurrencyCode: "TRY",
      name: e.id ?? "",
      lastPrice: (e.alis ?? 0).toString(),
      id: (e.id != null ? e.id! + "genelPara" + "TRY" : ""),
      changeOf24H: (e.degisim ?? 0).toString(),
    );
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertHurriyetStockListToMyMainCurrencyList() async {
    var response = await HurriyetService.instance.getAllHurriyetStocks();

    List<Hurriyet>? hurriyetStocksList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (hurriyetStocksList != null) {
      myCoin = hurriyetStocksList
          .map((e) => mainCurrencyGeneratorFromHurriyetStockModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromHurriyetStockModel(Hurriyet e) {
    return MainCurrencyModel(
        counterCurrencyCode: "TRY",
        name: e.sembol ?? "",
        lastPrice: (e.alis ?? 0).toString(),
        id: (e.sembol != null ? e.sembol! + "hurriyet" + "TRY" : ""),
        changeOf24H: (e.yuzdedegisim ?? 0).toString(),
        lowOf24h: (e.dusuk ?? 0).toString(),
        highOf24h: (e.yuksek ?? 0).toString(),
        lastUpdate: DateFormat.jms().format(e.tarih!));
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertTruncgilListToMyMainCurrencyList() async {
    var response = await TruncgilService.instance.getAllTruncgil();
    List<Truncgil>? truncgilCoinList = response.data;
    List<MainCurrencyModel>? myCoin;

    if (truncgilCoinList != null) {
      myCoin = truncgilCoinList
          .map((e) => mainCurrencyGeneratorFromTrungilModel(e))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<List<MainCurrencyModel>>>
      convertGechoCoinListByCurrencyToMyCoinList(String name,
          {List<String>? idList}) async {
    var response =
        await GechoService.instance.getAllCoinsByCurrency(name, idList: idList);
    List<Gecho>? gechoCoinList = response.data;
    List<MainCurrencyModel>? myCoin;
    if (gechoCoinList != null) {
      myCoin = gechoCoinList
          .map((e) => mainCurrencyGeneratorFromGechoModel(e, name))
          .toList();
    }
    return ResponseModel<List<MainCurrencyModel>>(
        data: myCoin, error: response.error);
  }

  Future<ResponseModel<MainCurrencyModel>>
      convertGechoCoinListByCurrencyToMyCoinId(
    String id,
  ) async {
    var response = await GechoService.instance.getCoinsById(id);
    List<Gecho>? gechoCoinList = response.data;
    List<MainCurrencyModel>? myCoin;
    if (gechoCoinList != null) {
      myCoin = gechoCoinList
          .map((e) => mainCurrencyGeneratorFromGechoModel(e, "USD"))
          .toList();
    }
    return ResponseModel<MainCurrencyModel>(
        data: (myCoin != null && myCoin.isNotEmpty) ? myCoin[0] : null,
        error: response.error);
  }

  MainCurrencyModel mainCurrencyGeneratorFromBitexenModel(Bitexen coin) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        (double.parse(coin.timestamp ?? "0") * 1000).round());

    return MainCurrencyModel(
        name: coin.market!.baseCurrencyCode!,
        lastPrice: coin.lastPrice,
        id: coin.market!.baseCurrencyCode! +
            "bitexen" +
            coin.market!.counterCurrencyCode!,
        changeOf24H: coin.change24H,
        counterCurrencyCode: coin.market?.counterCurrencyCode,
        lowOf24h: coin.low24H,
        highOf24h: coin.high24H,
        lastUpdate: dateConvert(date
            .toLocal())); //DateFormat.jms().format(date)/// DateFormat.jms().format(date)
  }

  String dateConvert(DateTime date) {
    var h = date.hour.toString();
    var m = date.minute.toString();
    var s = date.second.toString();
    if (s.length == 1) {
      s = "0" + s;
    }
    if (m.length == 1) {
      m = "0" + m;
    }
    if (h.length == 1) {
      h = "0" + h;
    }
    return "$h:$m:$s";
  }

  MainCurrencyModel mainCurrencyGeneratorFromGechoModel(
      Gecho coin, String currecny) {
    return MainCurrencyModel(
        counterCurrencyCode: currecny,
        name: coin.symbol ?? "",
        lastPrice: (coin.currentPrice ?? 0).toString(),
        id: (coin.id != null ? coin.id! + "gecho" + currecny : ""),
        changeOf24H: (coin.priceChangePercentage24H ?? 0).toString(),
        lowOf24h: (coin.low24H ?? 0).toString(),
        highOf24h: (coin.high24H ?? 0).toString(),
        lastUpdate: dateConvert(coin.lastUpdated==null ?
            DateTime(2022, 1, 1)
                .toLocal():coin.lastUpdated!.toLocal())); //DateFormat.jms().format(coin.lastUpdated!)
  }

  MainCurrencyModel mainCurrencyGeneratorFromTrungilModel(Truncgil e) {
    return MainCurrencyModel(
        name: e.name ?? "",
        lastPrice: e.buy,
        id: e.id ?? "",
        changeOf24H: e.change,
        counterCurrencyCode: "TRY",
        lastUpdate: e.updateDate);
  }

  String percentageCotnrol(String percentage) {
    if (percentage[0] == "-") {
      return PriceLevelControl.DESCREASING.name;
    } else if (double.parse(percentage) > 0) {
      //  L AM NOT SURE FOR THIS TRY IT
      return PriceLevelControl.INCREASING.name;
    } else {
      return PriceLevelControl.CONSTANT.name;
    }
  }
}
