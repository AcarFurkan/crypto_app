part of '../coin_list_page.dart';

extension BodyExtension on _CoinListPageState {
  Center get _initialStateBody =>
      const Center(child: CupertinoActivityIndicator());
  Center get _loadingStateBody =>
      const Center(child: CupertinoActivityIndicator());
  Center get errorbody =>
      Center(child: Image.asset(AppConstant.instance.IMAGE_404));

  Widget _completedStateBody(CoinListCompleted state, BuildContext context) {
    Stream<List<MainCurrencyModel>> stream = getCoinListStream();
//  print("3333333");
//     List<MainCurrencyModel> coinListToShow =
//              findRightList(state, context);
//coinListToShow =
//                coinListToShowTransactions(coinListToShow, context,state);
//            return buildBodyColumn(context, coinListToShow);
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
           List<MainCurrencyModel> coinListToShow =
              findRightList(state, context);
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
 
            coinListToShow = coinListToShowTransactions(
              snapshot.data!,
            );
            return buildBodyColumn(coinListToShow);
          } else {
            //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
            if (state.usdtCoinsList != null &&
                state.usdtCoinsList!.isNotEmpty) {
 
              var listFound = findRightList(state, context);
              coinListToShow = coinListToShowTransactions(
                listFound,
              );
              return buildBodyColumn(coinListToShow);
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          }
        });
  }

  Widget get _completedStateBodyUsd => StreamBuilder(
      stream: context.read<CoinListCubit>().streamUsd,
      builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
       // print("USDDDDDD");
        List<MainCurrencyModel> coinListToShow = [];
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          coinListToShow = coinListToShowTransactions(snapshot.data!);
          return buildBodyColumn(coinListToShow);
        } else {
          //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
          if (context.read<CoinListCubit>().usdtCoins.isNotEmpty) {
            coinListToShow = coinListToShowTransactions(
                context.read<CoinListCubit>().usdtCoins);
            return buildBodyColumn(coinListToShow);
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        }
      });

  Widget get _completedStateBodyTry => StreamBuilder(
      stream: context.read<CoinListCubit>().streamTry,
      builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
     //   print("TRYYY");

        List<MainCurrencyModel> coinListToShow = [];
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          coinListToShow = coinListToShowTransactions(snapshot.data!);
          return buildBodyColumn(coinListToShow);
        } else {
          //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
          if (context.read<CoinListCubit>().tryCoins.isNotEmpty) {
            coinListToShow = coinListToShowTransactions(
                context.read<CoinListCubit>().tryCoins);
            return buildBodyColumn(coinListToShow);
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        }
      });

  Widget get _completedStateBodyEth => StreamBuilder(
      stream: context.read<CoinListCubit>().streamEth,
      builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
//print("ETHHHHH");

        List<MainCurrencyModel> coinListToShow = [];
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          coinListToShow = coinListToShowTransactions(
            snapshot.data!,
          );
          return buildBodyColumn(coinListToShow);
        } else {
          //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
          if (context.read<CoinListCubit>().ethCoins.isNotEmpty) {
            coinListToShow = coinListToShowTransactions(
                context.read<CoinListCubit>().ethCoins);
            return buildBodyColumn(coinListToShow);
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        }
      });

  Widget get _completedStateBodyBtc => StreamBuilder(
      stream: context.read<CoinListCubit>().streamBtc,
      builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
   //     print("BTTCCC");
//
        List<MainCurrencyModel> coinListToShow = [];
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          coinListToShow = coinListToShowTransactions(
            snapshot.data!,
          );
          return buildBodyColumn(coinListToShow);
        } else {
          //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
          if (context.read<CoinListCubit>().btcCoins.isNotEmpty) {
            coinListToShow = coinListToShowTransactions(
                context.read<CoinListCubit>().btcCoins);
            return buildBodyColumn(coinListToShow);
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        }
      });

  Widget get _completedStateBodyNew => StreamBuilder(
      stream: context.read<CoinListCubit>().streamNew,
      builder: (context, AsyncSnapshot<List<MainCurrencyModel>> snapshot) {
        List<MainCurrencyModel> coinListToShow = [];
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          coinListToShow = coinListToShowTransactions(snapshot.data!);
          return buildBodyColumn(coinListToShow);
        } else {
          //I HAVE TO MADE İT BECAUSE WHEN STREAM BUİLDER İS WAİTİNG STATE L HAVE TO SHOW LOADİNG SCREEN EVERYTİME. I SOLVE İT WİTH A LİTTLE BİT HACKİNG
          if (context.read<CoinListCubit>().usdtCoins.isNotEmpty) {
            coinListToShow = coinListToShowTransactions(
                context.read<CoinListCubit>().newCoins);
            return buildBodyColumn(coinListToShow);
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        }
      });

  Column buildBodyColumn(List<MainCurrencyModel> coinListToShow) {
    String currencyName = getCurrencyName;
     return Column(
      children: [
        buildFirstRow(currencyName),
        buildTextFormField,
        buildListView(coinListToShow, currencyName),
      ],
    );
  }

  Widget buildListViewBuilder(
          List<MainCurrencyModel> coinListToShow, String currencyName) =>
      Scrollbar(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: coinListToShow.length,
          itemBuilder: (context, index) {
            var result = coinListToShow[index];
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/detailPage",
                  arguments: result),
              child: Hero(
                tag: result.id,
                child: ListCardItem(
                    coin: result,
                    index: index,
                    voidCallback: () {
                      context.read<CoinListCubit>().updateFromFavorites(result);
                      context.read<CoinCubit>().updateCompletedList();
                    }),
              ),
            );
          },
        ),
      );

  get buildTextFormField => buildTextFormFieldWithAnimation(context,
          controller:
              context.read<ListPageGeneralCubit>().textEditingController!,
          focusNode: context.watch<ListPageGeneralCubit>().myFocusNode,
          isSearchOpen: context.watch<ListPageGeneralCubit>().isSearhOpen,
          onChanged: () {
         context.read<CoinListCubit>().updateForSearch();
      });

  Padding buildFirstRow(String currencyName) => Padding(
        padding: context.paddingLowHorizontal,
        child: SizedBox(
          height: context.lowValue * 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(flex: 5, child: Text("  Sembol")),
              const Spacer(flex: 2),
              const Expanded(flex: 5, child: Text(" LastPrice")),
              Expanded(
                  flex: 6,
                  child: buildOrderByPopupMenu(
                      context, menuKeyTransactions(currencyName, context))),
            ],
          ),
        ),
      );

  Expanded buildListView(
          List<MainCurrencyModel> coinListToShow, String currencyName) =>
      Expanded(
        flex: (context.height * .02).toInt(),
        child: buildListViewBuilder(coinListToShow, currencyName),
      );
}
