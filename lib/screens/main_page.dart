import 'package:appbook/helpers/db_get_helper.dart';
import 'package:appbook/screens/app_list_page.dart';
import 'package:appbook/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatelessWidget {
  MainPage() {

    // 환경변수값을 db에서 가져온다.
    getEnv();
    
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'AppBook',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text('AppBook').tr(),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Home'.tr(),
                        icon: Icon(Icons.home),
                      ),
                      Tab(text: 'My Apps'.tr(), icon: Icon(Icons.favorite)),
                      Tab(text: 'All Apps'.tr(), icon: Icon(Icons.apps))
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    HomePage(),
                    ApplicationListPage(true),
                    ApplicationListPage(false)
                  ],
                ))));
  }
}
