import 'package:flutter/material.dart';

import '../../../../../core/constant/app/app_constant.dart';
import '../../../../../core/extension/string_extension.dart';
import '../../../../../product/language/locale_keys.g.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);
  final String email = "coinalarmhelp@gmail.com";
  final String twitter = "@furkan_acar20";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.helpPage_appBarTitle.locale)),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.height / 4,
              child: Image.asset(AppConstant.instance.SUPPORT_IMAGE_PATH),
            ),
            ListTile(
              title: Row(
                children: [
                  Text(LocaleKeys.helpPage_supportEmailText.locale),
                  SelectableText(email),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Text(LocaleKeys.helpPage_supportTwitterText.locale),
                  SelectableText(twitter),
                ],
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.helpPage_information.locale),
              subtitle:
                  Text(LocaleKeys.helpPage_informationTextIfCloseApp.locale),
            ),
          ],
        )));
  }
}
//Center(child: Image.asset(AppConstant.instance.HELP_IMAGE_PATH)),