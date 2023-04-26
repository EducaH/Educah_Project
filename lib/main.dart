import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:educah/app_strings.dart';
import 'package:educah/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  SharedPreferences? _prefs;
  bool isFirst = true;
  String themeApp = "light";

  void loadPref() {
    setState(() {
      themeApp =
          _prefs?.getString(AppStrings.key_theme) ?? AppStrings.text_light;
      isFirst = _prefs?.getBool(AppStrings.key_first) ?? true;
      print("MAIN THEME: $themeApp");
    });
  }

  Future<void> _setPrefFirst(bool val) async {
    await _prefs?.setBool(AppStrings.key_first, val);
  }

  Future<void> _setPrefIntro(bool val) async {
    await _prefs?.setBool(AppStrings.key_intro, val);
  }

  Future<void> _setPrefTheme(String val) async {
    await _prefs?.setString(AppStrings.key_theme, val);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
      loadPref();
      if (isFirst) {
        _setPrefFirst(true);
        _setPrefIntro(true);
        _setPrefTheme("light");
      }
      if (themeApp == AppStrings.text_dark) {
        print('Mode sombre');
        setState(() {
          AdaptiveTheme.of(context).setDark();
        });
      } else if (themeApp == AppStrings.text_light) {
        setState(() {
          AdaptiveTheme.of(context).setLight();
        });
        print('Mode clair');
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.orange,
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              title: AppStrings.app_name,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              theme: theme,
              darkTheme: darkTheme,
            ));
  }
}
