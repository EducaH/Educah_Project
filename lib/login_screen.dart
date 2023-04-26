import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:educah/intro_screen.dart';
import 'package:educah/main_screen.dart';
import 'package:educah/profil_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_strings.dart';
import 'controller/student_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  SharedPreferences? _prefs;
  bool hasIntro = true;
  String themeApp = "light";

  void loadPref() {
    setState(() {
      themeApp =
          _prefs?.getString(AppStrings.key_theme) ?? AppStrings.text_light;
      hasIntro = _prefs?.getBool(AppStrings.key_intro) ?? true;
    });
  }

  Widget showNextScreen() {
    Widget screen;
    if (hasIntro) {
      screen = const IntroScreen();
    } else {
      screen = const MainScreen();
    }
    return screen;
  }

  void checkStudent() async {
    if (await StudentController.isStudentExist(
        FirebaseAuth.instance.currentUser!.email as String)) {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return showNextScreen();
        }));
      });
    } else {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ProfilScreen(
              studentEmail: FirebaseAuth.instance.currentUser!.email as String,
              isExist: false);
        }));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
    FirebaseUIAuth.configureProviders([
      GoogleProvider(
          clientId:
              '263099780198-d26clv3jlhe455m416nv9peviid784l0.apps.googleusercontent.com'),
      EmailAuthProvider(),
      //PhoneAuthProvider()
    ]);

    return SignInScreen(
      headerBuilder: (_, __, ___) => Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Image.asset(AppStrings.path_image_ic_launcher_round)),
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          checkStudent();
        })
      ],
    );
  }
}
