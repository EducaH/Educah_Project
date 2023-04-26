import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:educah/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_strings.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  SharedPreferences? _prefs;
  bool isFirst = true;
  String themeApp = "light";

  Future<void> _setPrefFirst(bool val) async {
    await _prefs?.setBool(AppStrings.key_first, val);
  }

  Future<void> _setPrefIntro(bool val) async {
    await _prefs?.setBool(AppStrings.key_intro, val);
  }

  void loadPref() {
    setState(() {
      isFirst = _prefs?.getBool(AppStrings.key_first) ?? true;
      themeApp =
          _prefs?.getString(AppStrings.key_theme) ?? AppStrings.text_light;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.text_title_intro_screen),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: IntroductionScreen(
          next: const Icon(Icons.navigate_next),
          showSkipButton: true,
          skip: const Text("Skip"),
          onDone: () {
            loadPref();
            if (isFirst) {
              _setPrefFirst(false);
              _setPrefIntro(false);
            }
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const MainScreen();
            }));
          },
          done: const Text("Done"),
          dotsFlex: 4,
          pages: [
            PageViewModel(
                titleWidget: Image.asset(AppStrings.path_image_logo),
                body: AppStrings.text_welcome),
            PageViewModel(
                body:
                    "Beaucoup de choses à apprendre pour preparer votre examen",
                titleWidget:
                    Image.asset(AppStrings.path_screenshot_one, width: 200.0)),
            PageViewModel(
                body: "Apprenez beaucoup de choses pour preparer votre examen",
                titleWidget:
                    Image.asset(AppStrings.path_screenshot_two, width: 200.0)),
            PageViewModel(
                body: "Jouer au quiz pour memoriser les lecons",
                titleWidget: Image.asset(AppStrings.path_screenshot_three,
                    width: 200.0)),
            PageViewModel(
                body:
                    "Participer chaque jour pour rester a la tete du classement",
                titleWidget:
                    Image.asset(AppStrings.path_screenshot_four, width: 200.0))
          ],
        ),
      ),
    );
  }
}
