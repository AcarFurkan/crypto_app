part of'../coin_cubit.dart';
extension BackUpTrasactionExtension on CoinCubit{
   void allCoinIdListBackUpCheck() {
    //_appCacheManager.putItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name,
    //    DateTime(2020, 1, 1).toString());
    String? date =
        _appCacheManager.getItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name);
    if (date != null) {
      DateTime lastUpdate = DateTime.parse(date);
      DateTime now = DateTime.now();
      //print((now.millisecondsSinceEpoch - lastUpdate.millisecondsSinceEpoch) ~/
      //    (1000 * 60));
      int difference =
          (now.millisecondsSinceEpoch - lastUpdate.millisecondsSinceEpoch) ~/
              (1000 * 60 * 60 * 24);
      if ((difference) >= 1) {
        print("DAİLY YEDEKLEMEYE GİRİLDİ");
        _appCacheManager.putItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name,
            DateTime.now().toString());
        updateCoinIdList();
      }
    } else {
      print("NULL A GİRDİK");
      updateCoinIdList();
      _appCacheManager.putItem(
          PreferencesKeys.ID_LIST_LAST_UPDATE.name, DateTime.now().toString());
    }
  }
  Future<void> updateCoinIdList() async {
    //TODO: HATA YÖNETİMİ FİLAN HAK GETİRE
    Map mapFromService = await GechoService.instance.getAllCoinsIdList();
    print(mapFromService.length);
    _coinIdListCacheManager.clearAll();
    _coinIdListCacheManager.addItems(mapFromService);
  }
Future<void> backUpCheck(
      MyUser? myUser, List<MainCurrencyModel> coinListFromDataBase) async {
    if (context.read<UserCubit>().user != null &&
        context.read<UserCubit>().user?.isBackUpActive == true) {
      if (context.read<UserCubit>().user!.updatedAt != null) {
        int day = ((DateTime.now().millisecondsSinceEpoch) -
                context
                    .read<UserCubit>()
                    .user!
                    .updatedAt!
                    .millisecondsSinceEpoch) ~/
            (1000 * 60 * 60 * 24);
        if (myUser!.backUpType == BackUpTypes.daily.name) {
          if (day >= 1) {
            await UserServiceController.instance.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        } else if (myUser.backUpType == BackUpTypes.weekly.name) {
          if (day >= 7) {
            await UserServiceController.instance.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        } else if (myUser.backUpType == BackUpTypes.monthly.name) {
          if (day >= 30) {
            await UserServiceController.instance.updateUserCurrenciesInformation(
                context.read<UserCubit>().user!,
                listCurrency: coinListFromDataBase);
            await context.read<UserCubit>().getCurrentUser();
          }
        }
      }
    } else if (context.read<UserCubit>().user !=
            null && // YOU CAN DELETE THESE"1
        context.read<UserCubit>().user?.isBackUpActive == false) {
      // YOU CAN DELETE THESE
    } else if (context.read<UserCubit>().user ==
        null) {} // YOU CAN DELETE THESE
  }
}