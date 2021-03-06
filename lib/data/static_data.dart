import 'package:device_apps/device_apps.dart';

import 'env.dart';
import 'user_data.dart';

class StaticData {
  static String _searchingPackageName = '';
  static String get searchingPackageName => _searchingPackageName;
  static set searchingPackageName(var packageName) =>
      _searchingPackageName = packageName;

  // 검색중인지?
  static bool isSearching() {
    // 검색중이 아니라면 그냥 리턴
    if (StaticData.searchingPackageName == null ||
        StaticData.searchingPackageName.isEmpty) {
      return false;
    }
    return true;
  }

  static String _currentIconUrl = '';
  static String get currentIconUrl => _currentIconUrl;
  static set currentIconUrl(var pn) => _currentIconUrl = pn;

  static Application _currentApplication;
  // ignore: non_constant_identifier_names
  static Application get currentApplication => _currentApplication;
  static set currentApplication(var ca) => _currentApplication = ca;

  static String _currentEmail = '';
  static String get currentEmail => _currentEmail;
  static set currentEmail(var email) => _currentEmail = email;

  // 설치되어 있는 앱들
  static Map<String, Application> _myApps = Map<String, Application>();
  static Map<String, Application> get myApps => _myApps;

  // 카테고리
  static bool _allCategory = true;
  static bool get allCategory => _allCategory;
  static set allCategory(var all) => _allCategory = all;

  static ApplicationCategory _currentCategory = ApplicationCategory.audio;
  static ApplicationCategory get currentCategory => _currentCategory;
  static set currentCategory(var category) => _currentCategory = category;

  // 환경설정 변수
  static Env _env = Env();
  static Env get env => _env;
  static set env(var env) => _env = env;

  // user data
  static UserData _userData =
      UserData(like: 0, unlike: 0, reply: 0, newLike: 0, newUnlike: 0);
  static UserData get userData => _userData;
  static set userData(var ud) => _userData = ud;
}
