part of '../selected_coin_page.dart';

extension UpdateCoinSelectedPageExtension on SelectedCoinPage {
  Widget _updateCoinSelectedPageExtensionStateView(
      BuildContext context, UpdateSelectedCoinPage state) {
    List<MainCurrencyModel> coinListToShow = state.myCoinList ?? [];
    if (context.read<SelectedPageGeneralCubit>().isSearhOpen &&
        _searchTextEditingController.text != "") {
      coinListToShow = searchResult(coinListToShow, context);
    }
    return Column(
      children: [
        Expanded(flex: 1, child: buildSelectedAndDeleteContainer(context)),
        Expanded(
            flex: context.watch<SelectedPageGeneralCubit>().isSearhOpen == true
                ? 1
                : 0,
            child: buildSearchBox(context)),
        Expanded(
          flex: (context.width * .03).toInt(),
          child: _buildListVieBuilder(coinListToShow, state),
        ),
      ],
    );
  }

  Row buildSelectedAndDeleteContainer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSelectAndDropButton(context),
        _buildDeleteButton(context),
        InkWell(
          onTap: () {
            closeIconTransactions(context);
          },
          child: buildCloseIcon(context),
        )
      ],
    );
  }

  Widget buildSearchBox(BuildContext context) {
    return context.watch<SelectedPageGeneralCubit>().isSearhOpen == true
        ? SizedBox(
            child: Padding(
              padding: context.paddingLow,
              child: _buildSearchBoxTextFormField(context),
            ),
          )
        : Container();
  }

  TextFormField _buildSearchBoxTextFormField(BuildContext context) {
    return TextFormField(
      onChanged: (a) =>
          context.read<SelectedPageGeneralCubit>().textFormFieldChanged(),
      controller: _searchTextEditingController,
      autofocus: true,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  ListView _buildListVieBuilder(
      List<MainCurrencyModel> coinListToShow, UpdateSelectedCoinPage state) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: coinListToShow.length,
        itemBuilder: (context, index) {
          MainCurrencyModel result = coinListToShow[index];
          return RemovableCardItem(
            currency: result,
            context: context,
            isSelectedAll: state.isSelectedAll,
          );
        });
  }

  OutlinedButton _buildDeleteButton(BuildContext context) {
    return OutlinedButton(
        ///////// BUNU DA SEÇİLEN İTEM LİST BOŞSSA AKTİF ETME
        onPressed: () {
          deleteButtonTransactions(context);
        },
        child: Text("Seçilenleri sil"));
  }

  OutlinedButton _buildSelectAndDropButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => buildSelectedAndDropButtonActions(context),
      child: context.watch<SelectedPageGeneralCubit>().isSelectedAll == false
          ? Text("Tümünü seç")
          : Text("Tümünü Bırak"),
    );
  }

  void closeIconTransactions(BuildContext context) {
    context.read<CoinCubit>().clearAllItemsFromToDeletedList();
    context.read<SelectedPageGeneralCubit>().isSelectedAll = false;
    context.read<CoinCubit>().updateCompletedList();
     context.read<SelectedPageGeneralCubit>().setIsDeletedPageOpen();
    //  context.read<CoinCubit>().startAgain();
    context.read<SelectedPageGeneralCubit>().isSearhOpen = false;
    _searchTextEditingController.clear();
  }

  Container buildCloseIcon(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.onPrimary),
        ),
        child: Icon(
          Icons.close_sharp,
          color: context.colors.onPrimary,
        ));
  }

  Future<void> deleteButtonTransactions(BuildContext context) async {
   await context.read<CoinCubit>().deleteItemsFromDb();
    context.read<SelectedPageGeneralCubit>().isSelectedAll = false;
    context.read<SelectedPageGeneralCubit>().isSearhOpen = false;
    context.read<SelectedPageGeneralCubit>().setIsDeletedPageOpen();
    _searchTextEditingController.clear();
    context.read<CoinCubit>().updateCompletedList();
  }

  void buildSelectedAndDropButtonActions(BuildContext context) {
    // BÖYLE ATAMA OLMAZ DÜZELT ŞUNLARI TRUE FALSE YERİNE ! KULLAN
    context.read<SelectedPageGeneralCubit>().changeValue();
    if (context.read<SelectedPageGeneralCubit>().isSelectedAll == true) {
      context.read<CoinCubit>().updatePageForDelete(isSelected: true);
    } else {
      context.read<CoinCubit>().updatePageForDelete(isSelected: false);
    }
  }
}
