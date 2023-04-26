import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/quiz_choose_answer.dart';

class QuizController {
  static var database = FirebaseFirestore.instance;

  static Stream<List<QuizChooseAnswer>> showQuizChooseAnswer(String branche) {
    return database
        .collection("quiz_choose")
        .where("questionBranche", isEqualTo: branche)
        .snapshots()
        .map((event) => event.docs
            .map((e) => QuizChooseAnswer.fromFirestore(e.data()))
            .toList());
  }

  static Future<List<QuizChooseAnswer>> showQuizChooseAnswers(
      String branche) async {
    List<QuizChooseAnswer> quizzes = [];
    final ref = database
        .collection("quiz_choose")
        .where("questionBranche", isEqualTo: branche);
    final docs = await ref.get();
    for (var doc in docs.docs) {
      QuizChooseAnswer quiz = QuizChooseAnswer.fromFirestore(doc.data());
      quizzes.add(quiz);
      print(quiz.questionDescription);
    }
    return quizzes;
  }
}
