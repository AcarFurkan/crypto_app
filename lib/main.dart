import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constant/app/app_constant.dart';
import 'core/init/notifer/notifer_list.dart';
import 'features/home/landing_page.dart/landing_page.dart';
import 'features/home/landing_page.dart/splash_page.dart';
import 'product/language/language_manager.dart';
import 'product/theme/theme_provider.dart';
import 'product/untility/navigation/route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(MultiProvider(
    providers: ApplicationProvider.instance.providers,
    child: EasyLocalization(
        child: const FutureBuilderForSplash(),
        supportedLocales: LanguageManager.instance.supportedLocales,
        fallbackLocale: const Locale('en', 'US'),
        path: AppConstant.instance.LANG_ASSET_PATH),
  ));
}

class FutureBuilderForSplash extends StatelessWidget {
  const FutureBuilderForSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(context),
      builder: (context, AsyncSnapshot snapshot) {  
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              theme: context.watch<ThemeProvider>().theme,
              debugShowCheckedModeBanner: false,
              home: const Splash());
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: context.watch<ThemeProvider>().theme,
            title: "Crypto Alarm",
            onGenerateRoute: RouteGenerator.routeGenerator,
            home:
                FutureBuilderForIsFirstOpen(), //BUNU NİYE YAZMAMIZ LAZIM ONU ANLAMADIM
          );
        }
      },
    );
  }
}
