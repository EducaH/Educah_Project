import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:educah/intro_screen.dart';
import 'package:educah/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_strings.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SharedPreferences? _prefs;
  bool hasIntro = true;
  String themeApp = "light";
  Color myBackColor = Colors.white;
  String pathImage = AppStrings.path_image_splash_light;

  void loadPref() {
    setState(() {
      themeApp =
          _prefs?.getString(AppStrings.key_theme) ?? AppStrings.text_light;
      hasIntro = _prefs?.getBool(AppStrings.key_intro) ?? true;
    });
  }

  Widget showNextScreen() {
    Widget screen;
    if (FirebaseAuth.instance.currentUser == null) {
      screen = const LoginScreen();
    } else {
      if (hasIntro) {
        screen = const IntroScreen();
      } else {
        screen = const MainScreen();
      }
    }
    return screen;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
      loadPref();
      if (themeApp == AppStrings.text_dark) {
        print('Mode sombre');
        setState(() {
          myBackColor = Colors.black;
          pathImage = AppStrings.path_image_splash_dark;
        });
      } else if (themeApp == AppStrings.text_light) {
        setState(() {
          myBackColor = Colors.white;
          pathImage = AppStrings.path_image_splash_light;
        });
        print('Mode clair');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: pathImage,
        splashIconSize: 500.0,
        duration: 1000,
        nextScreen: showNextScreen(),
        backgroundColor: myBackColor,
        pageTransitionType: PageTransitionType.leftToRight,
        splashTransition: SplashTransition.scaleTransition);
  }
}
