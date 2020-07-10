import 'dart:typed_data';

import 'package:appbook/data/static_data.dart';
import 'package:appbook/helpers/get_app_detail.dart';
import 'package:appbook/screens/app_detail_page.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationColumn extends StatelessWidget {
  const ApplicationColumn({Key key, @required this.app, @required this.context})
      : super(key: key);

  final Application app;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    Application appTmp = this.app;
    return Column(
      children: <Widget>[
        ListTile(
            leading: appTmp is ApplicationWithIcon
                ? CircleAvatar(
                    backgroundImage: MemoryImage(appTmp.icon),
                    backgroundColor: Colors.white,
                  )
                : FutureBuilder(
                    future: getApplicationIconInDevice(app.packageName),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return CircularProgressIndicator();
                      } else {
                        return CircleAvatar(
                          backgroundImage: MemoryImage(snapshot.data),
                          backgroundColor: Colors.white,
                        );
                      }
                    },
                  ),
            // onTap: () => DeviceApps.openApp(app.packageName),
            onTap: () {
              StaticData.currentApplication = appTmp;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppDetailPage(),
                  ));
            },
            title: app == null
                ? Text('null')
                : Text("${app.appName} (${app.packageName})"),
            subtitle: app == null
                ? Text('null')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text('Version: ${app.versionName}'),
                      // Text(
                      //     'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}'),
                      FutureBuilder(
                        future: getAppCommentCount(app.packageName),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                                child: Container(
                              width: 13,
                              height: 13,
                              margin: EdgeInsets.all(0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ));
                          } else {
                            return Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.comment,
                                    color: Colors.blueGrey,
                                    size: 15,
                                  ),
                                  Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 13),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Icon(Icons.arrow_upward,
                                      color: Colors.red, size: 15),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Icon(
                                    Icons.arrow_downward,
                                    color: Colors.blue,
                                    size: 15,
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  // package에 대한 app icon을 가져옴
  Future<Uint8List> getApplicationIconInDevice(String packageName) async {
    // myapps에서 미리 찾아 본다.
    Application myApp = StaticData.myApps[packageName];
    if (myApp != null && myApp is ApplicationWithIcon) {
      return myApp.icon;
    }

    // 없으면 읽어온다.
    Application app = await DeviceApps.getApp(packageName, true);

    if (app is ApplicationWithIcon) {
      // my apps 에 추가
      if (myApp != null) {
        StaticData.myApps[packageName] = app;
      }

      return app.icon;
    }

    return null;
  }
}