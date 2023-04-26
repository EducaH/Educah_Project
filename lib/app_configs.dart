import 'package:shared_preferences/shared_preferences.dart';

class AppConfigs {
  final prefs = SharedPreferences.getInstance();
  static const String keyFirst = "key_first";
  static const String keyIntro = "key_intro";
  static const String keyTheme = "key_theme";
  static bool isFirst = true;
  static bool hasIntro = true;
  static String appTheme = "light";

  static void setPrefs(bool valFirst, bool valIntro, String valTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyFirst, valFirst);
    await prefs.setBool(keyIntro, valIntro);
    await prefs.setString(keyTheme, valTheme);
  }

  static void loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isFirst = prefs.getBool(keyFirst) ?? true;
    hasIntro = prefs.getBool(keyIntro) ?? true;
    appTheme = prefs.getString(keyTheme) ?? "light";
    print("FIRST: $isFirst -- INTRO: $hasIntro -- THEME: $appTheme");
  }

  // SharedPreferences? get prefs => _prefs;
  //
  // set prefs(SharedPreferences value) {
  //   _prefs = value;
  // }

  // static Future<void> getAppIntro() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   hasIntro = prefs.getBool(keyIntro)!;
  // }
  //
  // static Future<void> setAppIntro(bool val) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(keyIntro, val);
  // }
  //
  // static Future<void> getAppTheme() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   appTheme = prefs.getString(keyTheme);
  // }
  //
  // static Future<void> setAppTheme(String val) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(keyTheme, val);
  // }
}