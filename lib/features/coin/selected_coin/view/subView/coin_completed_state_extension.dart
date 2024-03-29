part of '../selected_coin_page.dart';

extension CoinCompletedStateExtension on SelectedCoinPage {
  Widget _buildCoinCompletedStateView(
      BuildContext context, CoinCompleted state) {
    List<MainCurrencyModel> coinListToShow = (state.myCoinList ?? []);
    if (coinListToShow.isEmpty) return _buildDontHaveCoin(context);
    return StreamBuilder(
        stream: context.read<CoinCubit>().streamListData,
        builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            coinListToShow =
                coinListToShowTransactions(snapshot.data!, context);
            return buildBodyColumn(context, coinListToShow);
          } else {
            //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
            if (state.myCoinList != null && state.myCoinList!.isNotEmpty) {
              coinListToShow =
                  coinListToShowTransactions(state.myCoinList!, context);
              return buildBodyColumn(context, coinListToShow);
            } else {
              return const Center(child: Text("hellooo"));
            }
          }
        });
  }

  List<MainCurrencyModel> coinListToShowTransactions(
      List<MainCurrencyModel> coinListToShow, BuildContext context) {
    coinListToShow = searchTransaction(context, coinListToShow);
    coinListToShow = context.read<CoinCubit>().orderList(
        context.read<SelectedPageGeneralCubit>().getorderByDropDownValue,
        coinListToShow);
    return coinListToShow;
  }

  List<MainCurrencyModel> searchTransaction(
      BuildContext context, List<MainCurrencyModel> coinListToShow) {
    if (context.read<SelectedPageGeneralCubit>().isSearhOpen &&
        context.read<SelectedPageGeneralCubit>().textEditingController?.text !=
            "") {
      coinListToShow = searchResult(coinListToShow, context);
    }
    return coinListToShow;
  }

  Column buildBodyColumn(
      BuildContext context, List<MainCurrencyModel> coinListToShow) {
    return Column(
      children: [
        Padding(
          padding: context.paddingLowHorizontal,
          child: SizedBox(
            height: context.lowValue * 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 5, child: buildOrderByPopupMenu(context)),
                Expanded(flex: 4, child: buildPriceDropDownButton(context)),
                Expanded(flex: 5, child: buildPercentageDropDrown(context)),
              ],
            ),
          ),
        ),
        BlocBuilder<SelectedPageGeneralCubit, SelectedPageGeneralState>(
            builder: (context, state) {
          return buildTextFormFieldWithAnimation(
            context,
            controller:
                context.read<SelectedPageGeneralCubit>().textEditingController!,
            focusNode: context.watch<SelectedPageGeneralCubit>().myFocusNode,
            isSearchOpen: context.watch<SelectedPageGeneralCubit>().isSearhOpen,
            onChanged: () {
              context.read<CoinCubit>().updatePage();
             },
          );
        }),
        Expanded(
          child: _buildListViewBuilder(coinListToShow),
        ),
      ],
    );
  }

  ListView _buildListViewBuilder(List<MainCurrencyModel> coinListToShow) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: coinListToShow.length,
        itemBuilder: (context, index) {
          MainCurrencyModel result = coinListToShow[index];
          String? priceForShow;
          String? percentageForShow;
          switch (
              context.read<SelectedPageGeneralCubit>().getPriceDropDownValue) {
            case ShowTypesForPrice.LAST_PRICE:
              priceForShow = result.lastPrice;
              break;
            case ShowTypesForPrice.ADDED_PRICE:
              priceForShow = result
                  .addedPrice; // TODO: BUNU BÖYLE YAPTIĞIN İÇİN DETAY SAYFASINA GİDERKEN VERİLER DEĞİŞCEK BUNU UNUTMA YAVRUM
              break;
            default:
              break;
          }
          switch (
              context //********************************************************************************************************************************************* */
                  .read<SelectedPageGeneralCubit>()
                  .getPercentageDropDownValue) {
            case ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_24_HOUR:
              percentageForShow = result.changeOf24H;
              break;
            case ShowTypeEnumForPercentage
                .CHANGE_OF_PERCENTAGE_SINCE_ADDED_TIME:
              percentageForShow = result
                  .changeOfPercentageSincesAddedTime; // TODO: BUNU BÖYLE YAPTIĞIN İÇİN DETAY SAYFASINA GİDERKEN VERİLER DEĞİŞCEK BUNU UNUTMA YAVRUM
              break;
            default:
              break;
          }

          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, "/detailPage", arguments: result),
            onLongPress: () => context
                .read<CoinCubit>()
                .updatePageForDelete(isSelected: false),
            child: _buildListCardItem(
                generateNewMainCurrencyItem(
                    result, percentageForShow, priceForShow),
                context,
                index),
          );
        });
  }

//I made this because I took a reference type error
  MainCurrencyModel generateNewMainCurrencyItem(MainCurrencyModel result,
          String? percentageForShow, String? priceForShow) =>
      MainCurrencyModel(
          id: result.id,
          lastPrice: priceForShow,
          name: result.name,
          changeOf24H: percentageForShow,
          addedPrice: result.addedPrice,
          changeOfPercentageSincesAddedTime:
              result.changeOfPercentageSincesAddedTime,
          counterCurrencyCode: result.counterCurrencyCode,
          highOf24h: result.highOf24h,
          isAlarmActive: result.isAlarmActive,
          isFavorite: result.isFavorite,
          isMaxAlarmActive: result.isMaxAlarmActive,
          isMaxLoop: result.isMaxLoop,
          max: result.max,
          isMinAlarmActive: result.isMinAlarmActive,
          isMinLoop: result.isMaxLoop,
          lastUpdate: result.lastUpdate,
          lowOf24h: result.lowOf24h,
          maxAlarmAudio: result.maxAlarmAudio,
          min: result.min,
          minAlarmAudio: result.minAlarmAudio,
          percentageControl: result.percentageControl,
          priceControl: result.priceControl);

  Hero _buildListCardItem(
      MainCurrencyModel result, BuildContext context, int index) {
    return Hero(
      tag: result.id,
      child: ListCardItem(
        coin: result,
        voidCallback: () =>
            context.read<CoinCubit>().saveDeleteFromFavorites(result),
        index: index,
      ),
    );
  }

  ListView _buildDontHaveCoin(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      children: [
        SizedBox(
          height: context.height * 0.12,
        ),
        SizedBox(
            height: context.height * 0.5,
            child: InkWell(
                onTap: () {
                  context.read<HomeViewModel>().selectedIndex =
                      context.read<HomeViewModel>().selectedIndex + 1;
                  context.read<HomeViewModel>().animateToPage =
                      context.read<HomeViewModel>().selectedIndex;
                },
                child: SvgPicture.asset(AppConstant.instance.ADD_IMAGE_PATH))),
      ],
    );
  }

  DropdownButtonHideUnderline buildPercentageDropDrown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ShowTypeEnumForPercentage>(
        alignment: Alignment.centerRight,
        dropdownColor: context.theme.appBarTheme.backgroundColor,
        value:
            context.read<SelectedPageGeneralCubit>().getPercentageDropDownValue,
        items: <ShowTypeEnumForPercentage>[
          ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_24_HOUR,
          ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_SINCE_ADDED_TIME
        ] //'%Change of 24H', '%Profit/Loss'
            .map<DropdownMenuItem<ShowTypeEnumForPercentage>>(
                (ShowTypeEnumForPercentage value) {
          return DropdownMenuItem<ShowTypeEnumForPercentage>(
              value: value, child: buildDropDownPercentageText(value, context));
        }).toList(),
        style: context.textTheme.caption,
        onChanged: (ShowTypeEnumForPercentage? newValue) {
          context.read<SelectedPageGeneralCubit>().setPercentageDropDownValue(
              newValue ??
                  ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_24_HOUR);
          //setState(() {
          //  dropdownValue = newValue!;
          //});
        },
      ),
    );
  }

  AutoSizeText buildDropDownPercentageText(
      ShowTypeEnumForPercentage type, BuildContext context) {
    switch (type) {
      case ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_24_HOUR:
        return AutoSizeText(
            LocaleKeys.percentageDropDownButton_changeOf24.locale,
            style: TextStyle(color: context.textTheme.bodyText1?.color));
      case ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_SINCE_ADDED_TIME:
        return AutoSizeText(
            LocaleKeys.percentageDropDownButton_profitLoss.locale,
            style: TextStyle(color: context.textTheme.bodyText1?.color));

      default:
        return AutoSizeText(
            LocaleKeys.percentageDropDownButton_changeOf24.locale,
            style: TextStyle(color: context.textTheme.bodyText1?.color));
    }
  }

  DropdownButtonHideUnderline buildPriceDropDownButton(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ShowTypesForPrice>(
        alignment: Alignment.centerRight,
        dropdownColor: context.theme.appBarTheme.backgroundColor,
        value: context.read<SelectedPageGeneralCubit>().getPriceDropDownValue,
        items: <ShowTypesForPrice>[
          ShowTypesForPrice.LAST_PRICE,
          ShowTypesForPrice.ADDED_PRICE
        ] //'Last Price', 'Added Price'
            .map<DropdownMenuItem<ShowTypesForPrice>>(
                (ShowTypesForPrice value) {
          return DropdownMenuItem<ShowTypesForPrice>(
              value: value, child: buildDropDownPriceText(value, context));
        }).toList(),
        style: context.textTheme.caption,
        onChanged: (ShowTypesForPrice? newValue) {
          context
              .read<SelectedPageGeneralCubit>()
              .setPriceDropDownValue(newValue ?? ShowTypesForPrice.LAST_PRICE);
        },
      ),
    );
  }

  AutoSizeText buildDropDownPriceText(
      ShowTypesForPrice type, BuildContext context) {
    switch (type) {
      case ShowTypesForPrice.LAST_PRICE:
        return AutoSizeText(LocaleKeys.priceDropDownButton_lastPrice.locale,
            style: TextStyle(color: context.textTheme.bodyText1?.color));
      case ShowTypesForPrice.ADDED_PRICE:
        return AutoSizeText(LocaleKeys.priceDropDownButton_addedPrice.locale,
            style: TextStyle(color: context.textTheme.bodyText1?.color));

      default:
        return AutoSizeText(LocaleKeys.priceDropDownButton_lastPrice.locale,
            style: TextStyle(color: context.textTheme.bodyText1?.color));
    }
  }
}
