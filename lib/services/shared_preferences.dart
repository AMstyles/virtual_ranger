import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserData {
  //!fields
  static late SharedPreferences _userData;
  static late User user;
  static late bool isLogIn;
  static late String isLog;
  static late String path;

  //!methods
  static Future<void> init() async {
    print('Shared preferences initialized');
    _userData = await SharedPreferences.getInstance();
    user = await getUser();

    await getApplicationDocumentsDirectory().then((value) {
      path = value.path;
    });
  }

  static Future<void> toggleOfflineMode(bool value) async {
    await _userData.setBool('offlineMode', value);
  }

  static Future<bool> getOfflineMode() async {
    return await _userData.getBool('offlineMode') ?? false;
  }

  static canGoOffline(bool value) async {
    await _userData.setBool('canGoOfflineMode', value);
  }

  static Future<bool> getCanGoOffline() async {
    return await _userData.getBool('canGoOfflineMode') ?? false;
  }

  static Future<void> logOut() async {
    await _userData.setString('isLog', '0');
    print('logging out');
    isLogIn = false;
    //setLoddedIn(false);
    await _userData.setBool('isLoggedIn', false);
  }

  //isLoggedIn
  static Future<bool> isLoggedIn() async {
    user = await getUser();
    return await _userData.getBool('isLoggedIn') ?? false;
  }

  static Future setUser(User user) async {
    //save to shared prefs from user class
    //bool to check if user is logged in
    await _userData.setBool('isLoggedIn', true);
    await _userData.setString('isLog', '1');
    await _userData.setString('user_id', user.id);
    await _userData.setString('user_name', user.name);
    await _userData.setString('user_email', user.email);
    await _userData.setString('user_mobile', user.mobile ?? '');
    await _userData.setString('user_country', user.country ?? '');
    await _userData.setString('user_city', user.city ?? '');
    await _userData.setString('user_age_range', user.age_range ?? '');
    await _userData.setString('user_image', user.image ?? '');
    await _userData.setString('user_secret_key', user.secret_key ?? '');
  }

  static Future<User> getUser() async {
    //get fields from shared preferences

    isLog = await _userData.getString('isLog') ?? '0';

    return await User(
      id: await _userData.getString('user_id') ?? '',
      name: await _userData.getString('user_name') ?? '',
      email: await _userData.getString('user_email') ?? '',
      mobile: await _userData.getString('user_mobile'),
      country: await _userData.getString('user_country'),
      city: await _userData.getString('user_city'),
      age_range: await _userData.getString('user_age_range'),
      image: await _userData.getString('user_image'),
      secret_key: await _userData.getString('user_secret_key'),
    );
  }
}
