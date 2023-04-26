import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:badges/badges.dart' as badges;
import 'package:educah/controller/student_controller.dart';
import 'package:educah/model/branche_model.dart';
import 'package:educah/profil_screen.dart';
import 'package:educah/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/branche_controller.dart';
import 'controller/course_controller.dart';
import 'model/course_model.dart';
import 'model/student_model.dart';

String courseName = "";
String courseDescription = "";
String courseLevel = "";
String category = "";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  SharedPreferences? _prefs;
  static const String keyTheme = "key_theme";
  String themeApp = "light";

  bool adLoaded = false;
  late InterstitialAd interstitialAd;
  late RewardedInterstitialAd rewardedInterstitialAd;
  bool adLoaded1 = false;
  late BannerAd bannerAd;

  static const List<IconData> icons = <IconData>[
    Icons.language,
    Icons.biotech,
    Icons.language,
    Icons.android,
    Icons.book,
    Icons.biotech_outlined,
    Icons.language,
    Icons.biotech,
    Icons.language,
    Icons.android,
    Icons.book,
    Icons.biotech_outlined
  ];

  static const List<Color> iconsColor = <Color>[
    Colors.purple,
    Colors.red,
    Colors.brown,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.brown,
    Colors.orange,
    Colors.green,
    Colors.blue
  ];

  Future<void> loadReward(int count) async {
    return RewardedInterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5354046379',
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            rewardedInterstitialAd = ad;
            rewardedInterstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
                  print('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
                print('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
                count = count + 1;
                StudentController.upgradeLife(
                    FirebaseAuth.instance.currentUser?.email as String, count);
              },
              onAdFailedToShowFullScreenContent:
                  (RewardedInterstitialAd ad, AdError error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
              onAdImpression: (RewardedInterstitialAd ad) =>
                  print('$ad impression occurred.'),
            );
            rewardedInterstitialAd.show(
              onUserEarnedReward: (ad, reward) {
                //
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }

  Future<void> loadAd() async {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) => setState(() {
                  bannerAd = ad as BannerAd;
                  adLoaded = true;
                }),
            onAdFailedToLoad: (ad, error) => ad.dispose()));
    return bannerAd.load();
  }

  void loadPref() {
    setState(() {
      themeApp = _prefs?.getString(keyTheme) ?? "light";
    });
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
          AdaptiveTheme.of(context).setDark();
        });
      } else if (themeApp == "light") {
        setState(() {
          AdaptiveTheme.of(context).setLight();
        });
        print('Mode clair');
      }
    });
    loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    //interstitialAd.dispose();
    bannerAd.dispose();
    if (rewardedInterstitialAd != null) {
      rewardedInterstitialAd.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        //Row One
        StreamBuilder<Student>(
          stream: StudentController.showStudent(
              FirebaseAuth.instance.currentUser!.email as String),
          builder: (context, snapshot) {
            Student? student = snapshot.data;

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('NO DATA FOUND'));
            }

            return Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return ProfilScreen(
                                    studentEmail:
                                        student?.studentEmail as String,
                                    isExist: true);
                              }));
                            },
                            child: Hero(
                              tag: 'user-picture',
                              child: isConnected == false
                                  ? CircleAvatar(
                                      radius: 25.0,
                                      child: Text(student?.studentName
                                          .substring(0, 1) as String))
                                  : CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          student?.studentPhotoUrl as String)),
                            ),
                          )),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Hello,',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            student?.studentName as String,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.only(right: 15.0),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.monetization_on_rounded),
                              Text("${student?.studentMojo as int}")
                            ],
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ListView(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text("Your mojos",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(Icons.monetization_on_rounded),
                                      Text("${student?.studentMojo as int}",
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0, bottom: 10.0),
                                    child: Text(
                                        "Continuer à jouer tous les jours pour pouvoir gagner plus de mojos.",
                                        textAlign: TextAlign.center),
                                  ),
                                  const Divider(),
                                  const ListTile(
                                      title: Text(
                                          "Comment gagner plus de mojos:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  const ListTile(
                                    title: Text("Compléter une lecon"),
                                    trailing: Text("10 Mojos"),
                                  ),
                                  const ListTile(
                                    title: Text("Regarder une publicite"),
                                    trailing: Text("5 Mojos"),
                                  ),
                                  const ListTile(
                                    title: Text("Inviter un(e) ami(e)"),
                                    trailing: Text("3 Mojos"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                      badges.Badge(
                        position:
                            badges.BadgePosition.topEnd(top: -12, end: -8),
                        badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.transparent, elevation: 1.0),
                        badgeContent: Text("${student?.studentLife as int}"),
                        child: GestureDetector(
                          child: Image.asset(
                            'assets/images/red_heart_48px.png',
                            width: 32.0,
                          ),
                          onTap: () {
                            if (student?.studentLife as int < 5) {
                              loadReward(student?.studentLife as int);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Vous avez toutes vos vies !');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  //const Icon(Icons.notifications)
                ],
              ),
            );
          },
        ),
        //Row Two
        Container(
          width: bannerAd.size.width.toDouble(),
          height: 100.0,
          alignment: Alignment.center,
          child: adLoaded
              ? AdWidget(ad: bannerAd)
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  margin: const EdgeInsets.only(top: 15.0),
                  padding: const EdgeInsets.only(top: 15.0),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.1, 0.6, 0.9],
                          colors: [Colors.purple, Colors.red, Colors.brown]),
                      color: Colors.white),
                  child: const Text(
                    'ADS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        //Row Three
        Container(
          margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Matières: $courseName',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(courseName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(courseDescription,
                                  textAlign: TextAlign.center),
                            ),
                            const Divider(),
                            StreamBuilder<List<Branche>>(
                              stream:
                                  BrancheController.showBranches(courseName),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: Text('NO DATA FOUND'));
                                }

                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'Aucune branche disponible maintenant !'));
                                } else {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 199.0,
                                    child: SizedBox(
                                      child: ListView.builder(
                                        itemCount: snapshot.data?.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          List<Branche>? branches =
                                              snapshot.data;
                                          category = branches?[0]
                                              .brancheCategory as String;

                                          return ListTile(
                                            title: Text(
                                              branches?[index].brancheName
                                                  as String,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: const Text(
                                                "10 Questions par quiz !"),
                                            // subtitle: Text(
                                            //     "Cours de ${courses?[index].courseCategory as String} !"),
                                            // trailing: CircularPercentIndicator(
                                            //   radius: 20.0,
                                            //   lineWidth: 5.0,
                                            //   percent: (courses?[index].coursePercent as int) / 100,
                                            //   center:
                                            //   Text("${courses?[index].coursePercent as int}%"),
                                            //   progressColor: Colors.green,
                                            //   animation: true,
                                            // ),
                                            onTap: null,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Description',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ),
        //Row Four
        StreamBuilder<List<Course>>(
          stream: CourseController.showAllCourses(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('NO DATA FOUND'));
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 110.0,
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  List<Course>? document = snapshot.data;
                  return Column(
                    children: [
                      Card(
                          margin: const EdgeInsets.all(20.0),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          borderOnForeground: true,
                          child: IconButton(
                            icon: Icon(icons[index], color: iconsColor[index]),
                            onPressed: () {
                              setState(() {
                                courseName =
                                    document?[index].courseName as String;
                                courseDescription = document?[index]
                                    .courseDescription as String;
                                courseLevel =
                                    document?[index].courseLevel as String;
                              });
                            },
                          )),
                      Text(
                        document?[index].courseName as String,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      )
                    ],
                  );
                },
              )),
            );
          },
        ),
        //Row Five
        Container(
          margin: const EdgeInsets.only(
              top: 30.0, bottom: 10.0, left: 10.0, right: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Branches: $category",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 5.0,
        ),
        //Row Six
        StreamBuilder<List<Branche>>(
          stream: BrancheController.showBranches(courseName),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('NO DATA FOUND'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Aucune branche disponible maintenant !'));
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 199.0,
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<Branche>? branches = snapshot.data;
                      category = branches?[0].brancheCategory as String;

                      return Card(
                        elevation: 2.0,
                        borderOnForeground: true,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.0, color: iconsColor[index]),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Icon(icons[index], color: iconsColor[index]),
                          ),
                          title: Text(
                            branches?[index].brancheName as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("10 Questions par quiz !"),
                          onTap: () {
                            setState(() {
                              category = branches?[index].brancheName as String;
                            });
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(category,
                                          textAlign: TextAlign.center),
                                      //content: Text(category),
                                      icon: Icon(icons[index],
                                          color: iconsColor[index]),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Annuler")),
                                        TextButton(
                                          child:
                                              const Text("Commencer le quiz"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return QuizScreen(
                                                  branche: branches?[index]
                                                      .brancheName as String);
                                            }));
                                          },
                                        )
                                      ],
                                    ));
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        )
      ],
    );
  }
}
