import 'package:appbook/data/static_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';

// doc로 application을 만들어서 리턴한다.
Application _makeApplicationByDoc(DocumentSnapshot doc, String iconData) {
  String packageName = doc.documentID;
  String appName = doc.data['app_name'];
  String versionName = doc.data['version_name'];
  int installTime = doc.data['install_time'];
  int category = doc.data['category'];
  String appIcon = doc.data['app_icon'];
  Map<dynamic, dynamic> map = {
    'app_name': appName == null ? 'no name' : appName,
    'apk_file_path': 'apk_file_path',
    'package_name': packageName == null ? 'no package name' : packageName,
    'version_name': versionName == null ? 'no version name' : versionName,
    'version_code': 1,
    'data_dir': 'data_dir',
    'system_app': false,
    'install_time': installTime == null ? 0 : installTime,
    'update_time': installTime == null ? 0 : installTime,
    'category': category == null ? -1 : category,
  };

  if (appIcon != null) {
    map['app_icon'] = appIcon;
  } else if (iconData != null) {
    map['app_icon'] = iconData;
  }

  Application app = Application(map);
  return app;
}

// 검색중인 앱만 리턴
// 해당 카테고리 중에서 선택..
List<Application> getSearchingApplicationsOnly(List<Application> apps) {
  // 지정된 카테고리만 남김
  if (!StaticData.allCategory) {
    apps.removeWhere(
        (element) => element.category != StaticData.currentCategory);
  }

  // 검색중이 아니라면 그냥 리턴
  if (StaticData.searchingPackageName == null ||
      StaticData.searchingPackageName.isEmpty) {
    return apps;
  }

  var reg = RegExp(StaticData.searchingPackageName, caseSensitive: false);
  apps.removeWhere((element) => reg.firstMatch(element.appName) == null);

  return apps;
}

// 서버에 있는 모든 앱을 리턴한다.
// 단, 서버에 있는 앱 리턴할때는 검색할때만 리턴한다.
Future<List<Application>> getApplicationsOnServer() async {
  bool isSearching = StaticData.isSearching();
  var db = Firestore.instance;
  var collection = db.collection('app_detail');

  var qs = await collection.getDocuments();
  var applications = List<Application>();

  var reg = isSearching
      ? RegExp(StaticData.searchingPackageName, caseSensitive: false)
      : null;

  for (var doc in qs.documents) {
    // 서버에서 가져올때는 무조건 검색 결과만 가져온다
    // 카테고리 일치하는지 체크
    if (!StaticData.allCategory) {
      int category = doc.data['category'];
      if (category != StaticData.currentCategory.index) continue;
    }

    if (reg != null) {
      if (reg.firstMatch(doc.data['app_name']) == null) continue;
    }

    var icon; //await _downloadIcon(doc.documentID);
    Application app = _makeApplicationByDoc(doc, icon);
    if (app != null) {
      applications.add(app);
    }
  }

  return applications;
}

// 설치되어 있는 app을 모두 가져온다.
Future<List<Application>> getInstalledApplications() async {
  // 없으면 가져온다.
  // 처음에만 가져오기 대문에 검색과정과 상관없이 모두넣는다.
  // 어차피 처음에는 검색이 안된 상태로 들어오기 때문에 모두 담아도된다.
  if (StaticData.myApps.length == 0) {
    var value = await DeviceApps.getInstalledApplications(
        includeAppIcons: false,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);

    var apps = value;
    for (var app in apps) {
      StaticData.myApps[app.packageName] = app;
    }

    return apps;
  }
  // 있으면 그냥 담는다.
  else {
    var apps = List<Application>();

    apps.addAll(StaticData.myApps.values);
    apps = getSearchingApplicationsOnly(apps);
    return apps;
  }
}
