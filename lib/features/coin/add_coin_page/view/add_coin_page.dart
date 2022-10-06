import 'package:coin_with_architecture/product/repository/service/market/gecho/gecho_service_controller.dart';

import '../../list_all_coin_page/viewmodel/cubit/coin_list_cubit.dart';

import '../../../../core/constant/app/app_constant.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../viewmodel/cubit/add_coin_cubit.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCoinPage extends StatelessWidget {
  const AddCoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCoinCubit, AddCoinState>(
      listener: (context, state) {
        if (state is AddCoinAlreadyExist) {
          showScaffoldMessage(
              context, LocaleKeys.AddCoinPage_coinAlreadExist.locale);
        }
        if (state is AddCoinAlreadyAdded) {
          showScaffoldMessage(
              context, LocaleKeys.AddCoinPage_coinAlreadAdded.locale);
        }
        if (state is AddCoinSuccessfullylAdded) {
          MainCurrencyModel model = state.currency;
          model.isFavorite = true;
          context.read<CoinListCubit>().updateFromFavorites(model);
          //context.read<CoinCubit>().updateCompletedList(); 
          GechoServiceController.instance.fetchNewGechoUsdCoinListManual(); 
          showScaffoldMessage(context, LocaleKeys.AddCoinPage_coinAdded.locale);
          context.read<CoinListCubit>().updateCompletedList();
        }
      },
      builder: (context, state) {
        if (state is AddCoinInitial) {
          return Scaffold(
            appBar: buildAppBar(context),
            body: Padding(
              padding: context.paddingLow,
              child: const Center(child: Text("INITIAL")),
            ),
          );
        } else if (state is AddCoinError) {
          return Scaffold(
            appBar: buildAppBar(context),
            body: Padding(
              padding: context.paddingLow,
              child: Center(child: Image.asset(AppConstant.instance.IMAGE_404)),
            ),
          );
        } else if (state is AddCoinCompleted) {
          MainCurrencyModel result = state.currency;
          return Scaffold(
            appBar: buildAppBar(context),
            floatingActionButton: buildFloatingActionButton(context),
            body: Padding(
              padding: context.paddingLow,
              child: buildListViewBody(result, context),
            ),
          );
        } else {
          return Scaffold(
            appBar: buildAppBar(context),
            body: Padding(
              padding: context.paddingLow,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        }
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: "no",
      onPressed: () => context.read<AddCoinCubit>().addCoin(),
      label: buildFloatingActionButtonContent(context),
    );
  }

  Row buildFloatingActionButtonContent(BuildContext context) {
    return Row(
      children: [
        Text(LocaleKeys.AddCoinPage_addYourNewLisr.locale),
        SizedBox(
          width: context.lowValue,
        ),
        const Icon(Icons.add)
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(LocaleKeys.AddCoinPage_appBarTitle.locale),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => context.read<AddCoinCubit>().clearAll(),
            icon: const Icon(Icons.delete_outline))
      ],
    );
  }

  ListView buildListViewBody(MainCurrencyModel result, BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: currencyPriceCardItem(
                  context,
                  LocaleKeys.CoinDetailPage_lowOf24Hour.locale,
                  result.lowOf24h ?? ""),
            ),
            Expanded(
              child: currencyPriceCardItem(
                  context,
                  LocaleKeys.CoinDetailPage_highLowOf24Hour.locale,
                  result.highOf24h ?? ""),
            ),
          ],
        ),
        currencyPriceCardItem(
            context, LocaleKeys.AddCoinPage_id.locale, result.id),
        currencyPriceCardItem(context, LocaleKeys.AddCoinPage_name.locale,
            result.name.toUpperCase()),
        currencyPriceCardItem(context, LocaleKeys.AddCoinPage_lastPrice.locale,
            result.lastPrice ?? ""),
        currencyPriceCardItem(context, LocaleKeys.AddCoinPage_lastUpdate.locale,
            result.lastUpdate ?? ""),
        // buildAddButton(context)
      ],
    );
  }

  OutlinedButton buildAddButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () => context.read<AddCoinCubit>().addCoin(),
        child: Text(LocaleKeys.AddCoinPage_addYourNewLisr.locale));
  }

  Card currencyPriceCardItem(BuildContext context, String title, String price) {
    return Card(
      child: Padding(
        padding: context.paddingLow,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: title + ": ", style: context.textTheme.headline6),
            TextSpan(text: price, style: context.textTheme.subtitle1)
          ]),
        ),
      ),
    );
  }

  void showScaffoldMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: context.midDuration,
    ));
  }
}
