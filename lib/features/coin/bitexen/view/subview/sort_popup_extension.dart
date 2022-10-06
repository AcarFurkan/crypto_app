part of '../bitexen_page.dart';

extension SortPopupExtension on BitexenPage {
  PopupMenuButton<SortTypes> buildOrderByPopupMenu(BuildContext context) {
    return PopupMenuButton<SortTypes>(
      key: _menuKey,
      child: buildSortCurrentWidget(context),
      onSelected: (value) {
         context.read<BitexenPageGeneralCubit>().setorderByDropDownValue(value);
        context.read<BitexenCubit>().updateCompletedList();
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortTypes>>[
         PopupMenuItem<SortTypes>(
          value: SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE,
          child: Text(LocaleKeys.sortDropDownButton_lastPriceHighToLow.locale),
        ),
        PopupMenuItem<SortTypes>(
          value: SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE,
          child: Text(LocaleKeys.sortDropDownButton_lastPriceLowToHigh.locale),
        ),
        PopupMenuItem<SortTypes>(
          value: SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE,
          child: Text(LocaleKeys.sortDropDownButton_percentageHighToLow.locale),
        ),
        PopupMenuItem<SortTypes>(
          value: SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE,
          child: Text(LocaleKeys.sortDropDownButton_percentageLowToHigh.locale),
        ),
      ],
    );
  }

  Row buildSortCurrentWidget(BuildContext context) {

    SortTypes value =
        context.read<BitexenPageGeneralCubit>().getorderByDropDownValue;
    switch (value) {
         case SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE:
        return buildSortByRow(
            context,
            LocaleKeys.sortDropDownButtonTitle_lastPrice.locale,
            Icons.arrow_downward_rounded); //güncel fiyat
      case SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE:
        return buildSortByRow(
            context,
            LocaleKeys.sortDropDownButtonTitle_lastPrice.locale,
            Icons.arrow_upward_rounded);
      case SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE:
        return buildSortByRow(
            context,
            LocaleKeys.sortDropDownButtonTitle_percentage.locale,
            Icons.arrow_downward_rounded);
      case SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE:
        return buildSortByRow(
            context,
            LocaleKeys.sortDropDownButtonTitle_percentage.locale,
            Icons.arrow_upward_rounded);
      default:
        return buildSortByRow(
            context, "Sort by Last Price", Icons.arrow_downward_rounded);
    }
  }

  Row buildSortByRow(BuildContext context, String text, IconData iconData) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: AutoSizeText(
            text,
            minFontSize: 6,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 2,
          child: Icon(
            iconData,
            size: context.normalValue,
          ),
        )
      ],
    );
  }
}
