class QuizChooseAnswer {
  int questionId = 0;
  String questionBranche = "";
  String questionDescription = "";
  String questionCorrectAnswer = "";
  String questionWrongAnswerOne = "";
  String questionWrongAnswerTwo = "";
  String questionWrongAnswerThree = "";

  QuizChooseAnswer(
      this.questionId,
      this.questionBranche,
      this.questionDescription,
      this.questionCorrectAnswer,
      this.questionWrongAnswerOne,
      this.questionWrongAnswerTwo,
      this.questionWrongAnswerThree);

  QuizChooseAnswer.fromFirestore(Map<String, dynamic> snapshot) {
    questionId = snapshot['questionId'];
    questionBranche = snapshot['questionBranche'];
    questionDescription = snapshot['questionDescription'];
    questionCorrectAnswer = snapshot['questionCorrectAnswer'];
    questionWrongAnswerOne = snapshot['questionWrongAnswerOne'];
    questionWrongAnswerTwo = snapshot['questionWrongAnswerTwo'];
    questionWrongAnswerThree = snapshot['questionWrongAnswerThree'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (questionId != null) 'questionId': questionId,
      if (questionBranche != null) 'questionBranche': questionBranche,
      if (questionDescription != null)
        'questionDescription': questionDescription,
      if (questionCorrectAnswer != null)
        'questionCorrectAnswer': questionCorrectAnswer,
      if (questionWrongAnswerOne != null)
        'questionWrongAnswerOne': questionWrongAnswerOne,
      if (questionWrongAnswerTwo != null)
        'questionWrongAnswerTwo': questionWrongAnswerTwo,
      if (questionWrongAnswerThree != null)
        'questionWrongAnswerThree': questionWrongAnswerThree
    };
  }
}
