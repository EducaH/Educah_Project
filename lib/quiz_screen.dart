import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:badges/badges.dart' as badges;
import 'package:educah/controller/quiz_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_strings.dart';
import 'controller/student_controller.dart';
import 'model/quiz_choose_answer.dart';
import 'model/student_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.branche});

  final String branche;

  @override
  State<QuizScreen> createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  SharedPreferences? _prefs;
  String themeApp = "light";

  int life = 0;
  List<QuizChooseAnswer> quizzes = [];
  List<QuizChooseAnswer> quizzesShuffle = [];

  late Text questionText;
  String answer = "";
  String answerCorrect = "";
  String questionDescription = "";
  String correctAnswer = "";
  String wrongAnswerOne = "";
  String wrongAnswerTwo = "";
  String wrongAnswerThree = "";
  int winCounter = 0;
  int fallCounter = 0;
  dynamic listSize = 0;
  dynamic position = 0;
  Color myTextColor = Colors.white;
  Color myBackColor = Colors.black;
  Color myBackCorrect = Colors.transparent;
  Color myBackWrong = Colors.transparent;
  bool isButtonActive = true;
  String textButtonNext = "Suivant";

  int colorTitle1 = 0;
  Color colorsTitle1 = Colors.black;

  int colorTitle2 = 0;
  Color colorsTitle2 = Colors.black;

  int colorTitle3 = 0;
  Color colorsTitle3 = Colors.black;

  int colorTitle4 = 0;
  Color colorsTitle4 = Colors.black;

  void loadPref() {
    setState(() {
      themeApp =
          _prefs?.getString(AppStrings.key_theme) ?? AppStrings.text_light;
    });
  }

  void auLancement() {
    listSize = quizzes.length;

    //quizzes?.shuffle();

    if (isButtonActive) {
      updateUI(quizzes, position);
    }
  }

  void updateUI(List<QuizChooseAnswer> quizzes1, int pos) {
    QuizChooseAnswer quiz = quizzes1[pos];

    questionDescription = quiz.questionDescription;

    answerCorrect = quiz.questionCorrectAnswer;

    List<String> questionList = [];

    questionList.add(quiz.questionCorrectAnswer);
    questionList.add(quiz.questionWrongAnswerOne);
    questionList.add(quiz.questionWrongAnswerTwo);
    questionList.add(quiz.questionWrongAnswerThree);

    Random random = Random();

    correctAnswer = questionList.removeAt(random.nextInt(questionList.length));
    wrongAnswerOne = questionList.removeAt(random.nextInt(questionList.length));
    wrongAnswerTwo = questionList.removeAt(random.nextInt(questionList.length));
    wrongAnswerThree =
        questionList.removeAt(random.nextInt(questionList.length));
  }

  void answerWin() {
    winCounter++;
    if (position < listSize) {
      position++;
      //progressValue = (position * 100) / listSize;
    }
    if (position == listSize) {
      textButtonNext = "Terminer";
    }
  }

  void answerFall() {
    fallCounter++;
    life--;
    StudentController.downgradeLife(
        FirebaseAuth.instance.currentUser?.email as String, life);
    if (position < quizzes?.length) {
      position++;
    }
    if (position == quizzes?.length) {
      textButtonNext = "Terminer";
    }
  }

  void changeColorTitle() {
    if (colorTitle1 == 1) {
      colorsTitle1 = Colors.green;
    }
    if (colorTitle1 == -1) {
      colorsTitle1 = Colors.red;
    }

    if (colorTitle2 == 1) {
      colorsTitle2 = Colors.green;
    }
    if (colorTitle2 == -1) {
      colorsTitle2 = Colors.red;
    }

    if (colorTitle3 == 1) {
      colorsTitle3 = Colors.green;
    }
    if (colorTitle3 == -1) {
      colorsTitle3 = Colors.red;
    }

    if (colorTitle4 == 1) {
      colorsTitle4 = Colors.green;
    }
    if (colorTitle4 == -1) {
      colorsTitle4 = Colors.red;
    }
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
        title: Text(widget.branche),
        elevation: 1.0,
        actions: <Widget>[
          StreamBuilder(
            stream: StudentController.showStudent(
                FirebaseAuth.instance.currentUser?.email as String),
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

              life = student?.studentLife as int;

              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -12, end: -8),
                    badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.transparent, elevation: 1.0),
                    badgeContent: Text("${student?.studentLife as int}"),
                    child: Image.asset(
                      'assets/images/red_heart_48px.png',
                      width: 32.0,
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: QuizController.showQuizChooseAnswers(widget.branche),
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

          quizzes = snapshot.data!;

          auLancement();

          return Container(
            child: ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(10.0),
                          child: LinearProgressBar(
                            maxSteps: listSize + 1,
                            progressType: LinearProgressBar.progressTypeDots,
                            currentStep: position,
                            progressColor: Colors.blue,
                            backgroundColor: Colors.black,
                            dotsAxis: Axis.horizontal, // OR Axis.vertical
                            dotsActiveSize: 15,
                            dotsInactiveSize: 10,
                            dotsSpacing: const EdgeInsets.only(
                                right: 10), // also can use any EdgeInsets.
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.red),
                            semanticsLabel: "Label",
                            semanticsValue: "Value",
                            minHeight: 10,
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
