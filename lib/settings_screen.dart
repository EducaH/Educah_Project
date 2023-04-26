import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:educah/app_strings.dart';
import 'package:educah/controller/student_controller.dart';
import 'package:educah/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences? _prefs;
  static const String keySound = "key_sound";
  static const String keyVibrate = "key_vibrate";
  bool hasIntro = false;
  bool isDark = false;
  bool isSound = false;
  bool isVibrate = false;
  String themeApp = "light";
  Color myTextColor = Colors.white;
  MaterialColor myIconColor = Colors.blue;

  void loadPref() {
    setState(() {
      hasIntro = _prefs?.getBool(AppStrings.key_intro) ?? true;
      isSound = _prefs?.getBool(keySound) ?? false;
      isVibrate = _prefs?.getBool(keyVibrate) ?? false;
      themeApp = _prefs?.getString(AppStrings.key_theme) ?? "light";
    });
  }

  Future<void> _setPrefIntro(bool val) async {
    await _prefs?.setBool(AppStrings.key_intro, val);
    loadPref();
  }

  Future<void> _setPrefSound(bool val) async {
    await _prefs?.setBool(keySound, val);
    loadPref();
  }

  Future<void> _setPrefVibrate(bool val) async {
    await _prefs?.setBool(keyVibrate, val);
    loadPref();
  }

  Future<void> _setPrefTheme(String val) async {
    await _prefs?.setString(AppStrings.key_theme, val);
    loadPref();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
      loadPref();
      if (themeApp == "dark") {
        print('Mode sombre');
        setState(() {
          myTextColor = Colors.white;
          myIconColor = Colors.orange;
          AdaptiveTheme.of(context).setDark();
        });
      } else if (themeApp == "light") {
        setState(() {
          myTextColor = Colors.black;
          myIconColor = Colors.blue;
          AdaptiveTheme.of(context).setLight();
        });
        print('Mode clair');
      } else {
        setState(() {
          AdaptiveTheme.of(context).setSystem();
        });
        print('Mode system');
      }
    });
  }

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
        title: 'Adaptive Theme Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "Général",
                style: TextStyle(
                    color: myTextColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.music_note_rounded,
                  color: myIconColor,
                ),
                title: Text("Son", style: TextStyle(color: myTextColor)),
                trailing: Switch(
                  value: isSound,
                  activeColor: Colors.white,
                  activeTrackColor: myIconColor,
                  inactiveTrackColor: myIconColor,
                  onChanged: (value) {
                    _setPrefSound(!isSound);
                    loadPref();
                  },
                )),
            ListTile(
                leading: Icon(
                  Icons.vibration_rounded,
                  color: myIconColor,
                ),
                title: Text("Ecran d'introduction",
                    style: TextStyle(color: myTextColor)),
                trailing: Switch(
                  value: hasIntro,
                  activeColor: Colors.white,
                  activeTrackColor: myIconColor,
                  inactiveTrackColor: myIconColor,
                  onChanged: (value) {
                    _setPrefIntro(!hasIntro);
                    loadPref();
                  },
                )),
            ListTile(
                leading: Icon(
                  Icons.dark_mode_rounded,
                  color: myIconColor,
                ),
                title: Text("Thème", style: TextStyle(color: myTextColor)),
                trailing: themeApp == "light"
                    ? Image.asset("assets/images/summer_48px.png",
                        width: 30.0, height: 30.0)
                    : Image.asset("assets/images/night_48px.png",
                        width: 30.0, height: 30.0),
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text("Choisir Thème"),
                        children: <Widget>[
                          ListTile(
                            leading: Image.asset(
                                "assets/images/summer_48px.png",
                                width: 30.0,
                                height: 30.0),
                            title: const Text("Mode clair"),
                            trailing: themeApp == "light"
                                ? const Icon(Icons.check_rounded)
                                : null,
                            onTap: () => Navigator.pop(context, "light"),
                          ),
                          ListTile(
                            leading: Image.asset("assets/images/night_48px.png",
                                width: 30.0, height: 30.0),
                            title: const Text("Mode sombre"),
                            trailing: themeApp == "dark"
                                ? const Icon(Icons.check_rounded)
                                : null,
                            onTap: () => Navigator.pop(context, "dark"),
                          ),
                          ListTile(
                            leading: Image.asset(
                                "assets/images/summer_48px.png",
                                width: 30.0,
                                height: 30.0),
                            title: const Text("Mode système"),
                            trailing: themeApp == "system"
                                ? const Icon(Icons.check_rounded)
                                : null,
                            onTap: () => Navigator.pop(context, "system"),
                          )
                        ],
                      );
                    },
                  ).then((returnVal) {
                    if (returnVal != null) {
                      _setPrefTheme(returnVal);
                      loadPref();
                      if (returnVal == "dark") {
                        print('Mode sombre');
                        setState(() {
                          myTextColor = Colors.white;
                          myIconColor = Colors.orange;
                          AdaptiveTheme.of(context).setDark();
                        });
                      } else if (returnVal == "light") {
                        setState(() {
                          myTextColor = Colors.black;
                          myIconColor = Colors.blue;
                          AdaptiveTheme.of(context).setLight();
                        });
                        print('Mode clair');
                      } else {
                        setState(() {
                          AdaptiveTheme.of(context).setSystem();
                        });
                        print('Mode system');
                      }
                      Fluttertoast.showToast(msg: returnVal);
                    }
                  });
                }),
            const Divider(),
            ListTile(
              title: Text(
                "Application",
                style: TextStyle(
                    color: myTextColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.info_rounded,
                  color: myIconColor,
                ),
                title: Text("A propos d'EducaH",
                    style: TextStyle(color: myTextColor)),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationIcon:
                          Image.asset('assets/images/logo.png', width: 50),
                      applicationName: "EducaH",
                      applicationVersion: "1.0",
                      applicationLegalese:
                          "Merci d'avoir télécharger EducaH !");
                }),
            ListTile(
                leading: Icon(
                  Icons.share_rounded,
                  color: myIconColor,
                ),
                title: Text("Partager l'application",
                    style: TextStyle(color: myTextColor)),
                onTap: () {
                  Share.share("Partager l'application", subject: "EducaH");
                }),
            ListTile(
                leading: Icon(
                  Icons.shop,
                  color: myIconColor,
                ),
                title: Text("Evaluer l'application",
                    style: TextStyle(color: myTextColor)),
                onTap: () => launchUrl(Uri.parse(
                    "https://play.google.com/store/apps/details?id=ht.educah"))),
            ListTile(
                leading: Icon(
                  Icons.email_rounded,
                  color: myIconColor,
                ),
                title: Text("Contacter EducaH",
                    style: TextStyle(color: myTextColor)),
                onTap: () =>
                    launchUrl(Uri.parse("mailto:educahapp@gmail.com"))),
            ListTile(
                leading: Icon(
                  Icons.privacy_tip_rounded,
                  color: myIconColor,
                ),
                title: Text("Termes et conditions",
                    style: TextStyle(color: myTextColor)),
                onTap: () {
                  // FirebaseAuth.instance.signOut();
                  // //Navigator.popUntil(context, ModalRoute.withName("/Login"));
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //   return const Login();
                  // }));
                }),
            const Divider(),
            ListTile(
              title: Text(
                "Mon compte",
                style: TextStyle(
                    color: myTextColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: myIconColor,
                ),
                title:
                    Text("Deconnecter", style: TextStyle(color: myTextColor)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginScreen();
                  }));
                }),
            ListTile(
                leading: Icon(
                  Icons.delete_rounded,
                  color: myIconColor,
                ),
                title: Text("Supprimer mon compte",
                    style: TextStyle(color: myTextColor)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Suppression compte"),
                        content: const Text(
                            "Si vous supprimer votre compte, toutes vos donnees seront egalement supprimees, voulez-vous confirmer ?"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Annuler")),
                          TextButton(
                            child: const Text("Confirmer"),
                            onPressed: () {
                              StudentController.removeStudent(FirebaseAuth
                                  .instance.currentUser!.email as String);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return const LoginScreen();
                              }));
                            },
                          )
                        ],
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
