import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant/app/app_constant.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../product/language/locale_keys.g.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  @override
  void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
showDialog();
    });

  }
  showDialog(){
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(LocaleKeys.welcomeAlertDialogTitle.locale), 
            content: Text( LocaleKeys.welcomeAlertDialog.locale),
            actions: [CupertinoDialogAction(child: Text(LocaleKeys.welcomeAlertDialogAction.locale),onPressed: (){Navigator.pop(context);}, )],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: buildFloatingActionButton(context),
        body: Column(
          children: [
            const Spacer(),
            Expanded(
                flex: (context.width * 0.015).toInt(),
                child: buildWelcomeImage()),
            buildLoginRegisterButton(context),
            Spacer(
              flex: (context.width * 0.006).toInt(),
            ) // as
          ],
        ));
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.popAndPushNamed(context, "/home"),
      label: buildFloatingActionButtonContent(),
    );
  }

  Row buildFloatingActionButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(LocaleKeys.landingPage_passButton.locale),
        const Icon(Icons.arrow_forward_ios)
      ],
    );
  }

  Image buildWelcomeImage() => Image.asset(AppConstant.instance.WELCOME_PAGE);

  OutlinedButton buildLoginRegisterButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.popAndPushNamed(context, "/home");
        //  Navigator.pushNamed(context, "/settingsGeneral");
        Navigator.pushNamed(
            context, "/userSettings"); //bundan sonra geri kısmını bir düşün
      },
      child: buildButtonText(context),
    );
  }

  Text buildButtonText(BuildContext context) =>
      Text(LocaleKeys.landingPage_loginRegisterButton.locale);
}
