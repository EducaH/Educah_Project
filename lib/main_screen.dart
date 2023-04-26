import 'dart:async';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:educah/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import 'classement_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  SharedPreferences? _prefs;
  static const String keyTheme = "key_theme";
  bool isDark = false;

  static final List<Widget> _tabs = [
    const ClassementScreen(),
    const HomeScreen(),
    const SettingsScreen()
  ];

  StreamSubscription? subscription;

  void loadPref() {
    setState(() {
      isDark = _prefs?.getBool(keyTheme) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    SimpleConnectionChecker simpleConnectionChecker = SimpleConnectionChecker()
      ..setLookUpAddress('pub.dev'); //Optional method to pass the lookup string
    subscription =
        simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        isConnected = connected;
        Fluttertoast.showToast(msg: "$isConnected");
      });
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
      loadPref();
      if (isDark) {
        print('Mode sombre');
        setState(() {
          AdaptiveTheme.of(context).setDark();
        });
      } else {
        setState(() {
          AdaptiveTheme.of(context).setLight();
        });
        print('Mode clair');
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
        home: DefaultTabController(
            length: _tabs.length,
            initialIndex: 1,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('EducaH'),
                elevation: 1.0,
                actions: <Widget>[
                  PopupMenuButton(itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          child: TextButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text("Quitter"),
                                          content: const Text(
                                              "Voulez-vous vraiment quitter l'application ?"),
                                          actions: <Widget>[
                                            TextButton(
                                                child: const Text("Non"),
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                            TextButton(
                                                child: const Text("Oui"),
                                                onPressed: () {
                                                  exit(0);
                                                }),
                                          ],
                                        ));
                              },
                              icon: const Icon(Icons.exit_to_app_rounded),
                              label: const Text("Quitter")))
                    ];
                  })
                ],
              ),
              body: TabBarView(children: _tabs),
              bottomNavigationBar: const RowBottomBar(),
            )),
      ),
    );
  }
}

class RowBottomBar extends StatefulWidget {
  const RowBottomBar({super.key});

  @override
  State<RowBottomBar> createState() => _RowBottomBarState();
}

class _RowBottomBarState extends State<RowBottomBar> {
  dynamic tabDatas = <String, IconData>{
    'Classement': Icons.leaderboard_rounded,
    'Accueil': Icons.home,
    'Paramètres': Icons.settings
  };

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.flip,
      color: Colors.white,
      gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.6, 0.9],
          colors: [Colors.blue, Colors.green, Colors.purple]),
      items: <TabItem>[
        for (final item in tabDatas.entries)
          TabItem(icon: item.value, title: item.key)
      ],
    );
  }
}
