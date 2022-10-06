import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/app/app_constant.dart';
import '../../../../core/enums/currency_enum.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/connectivity_manager/connectivity_notifer.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../../../../product/widget/component/text_form_field_with_animation.dart';
import '../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import '../viewmodel/cubit/coin_list_cubit.dart';
import '../viewmodel/page_viewmodel/cubit/list_page_general_cubit.dart';
part 'subview/sort_popup_extension.dart';
part 'subview/search_trasactions_extension.dart';
part 'subview/body_extension.dart';
part 'subview/general_transactions.dart';

class CoinListPage extends StatefulWidget {
  const CoinListPage({Key? key}) : super(key: key);

  @override
  State<CoinListPage> createState() => _CoinListPageState();
}

class _CoinListPageState extends State<CoinListPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _menuKey2 = GlobalKey();

  final List<MainCurrencyModel> searchresult = [];

  late TabController _tabController;
  //int selectedIndex = 0;
  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: TabBarView(
          //key: _menuKey2,
          controller: _tabController,
          children: tabBarViewGenerator(context)),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      actions: buildAppBarActions(context),
      bottom: buildTabBar(context),
      title: const LocaleText(text: LocaleKeys.coinListPage_appBarTitle),
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            context.read<ListPageGeneralCubit>().changeIsSearch();
            if (context.read<ListPageGeneralCubit>().isSearhOpen == false) {
              context
                  .read<ListPageGeneralCubit>()
                  .textEditingController
                  ?.clear();
            }
          },
          icon: const Icon(Icons.search))
    ];
  }

  TabBar buildTabBar(BuildContext context) {
    return TabBar(
        //key: _menuKey,
        controller: _tabController,
        indicatorWeight: 0,
        unselectedLabelStyle: context.textTheme.bodyText2,
        indicator: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: context.colors.onBackground,
                    width: context.width * .008))),
        tabs: _tabGenerator(context));
  }

  List<Widget> tabBarViewGenerator(BuildContext context) => CoinCurrency.values
      .map((e) => Center(child: _blocConsumer(e.name)))
      .toList();

  // List<Widget> tabBarViewGenerator2(BuildContext context) => [];

  List<Tab> _tabGenerator(BuildContext context) => CoinCurrency.values
      .map((e) => Tab(child: AutoSizeText(e.name, maxLines: 1)))
      .toList();

  BlocConsumer<CoinListCubit, CoinListState> _blocConsumer(
      String currencyName) {
    return BlocConsumer<CoinListCubit, CoinListState>(
      builder: (context, state) {
        if (state is CoinListInitial) {
          // context.read<CoinListCubit>().fetchAllCoins();
          return _initialStateBody;
        } else if (state is CoinListLoading) {
          return _loadingStateBody;
        } else if (state is CoinListCompleted) {
          if (_tabController.index == 0 && isFirstBuild == true) {
            // _tabController.animateTo(2);
            isFirstBuild = false;
            return _completedStateBodyUsd;
          }

          if (currencyName == CoinCurrency.USD.name) {
            return _completedStateBodyUsd;
          } else if (currencyName == CoinCurrency.TRY.name) {
            return _completedStateBodyTry;
          } else if (currencyName == CoinCurrency.ETH.name) {
            return _completedStateBodyEth;
          } else if (currencyName == CoinCurrency.BTC.name) {
            return _completedStateBodyBtc;
          } else if (currencyName == CoinCurrency.NEW.name) {
            return _completedStateBodyNew;
          } else {
            return _completedStateBodyUsd;
          }
        } else {
          return errorbody;
        }
      },
      listener: (context, state) {
        if (state is CoinListError) {
          if (context.read<ConnectivityNotifier>().connectionStatus ==
              ConnectivityResult.none) {
            context.read<ConnectivityNotifier>().showConnectionErrorSnackBar();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
    );
  }
}
