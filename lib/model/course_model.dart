class Course {
  final int? courseId;
  final String? courseName;
  final String? courseDescription;
  final String? courseLevel;

  Course(
      {this.courseId,
      this.courseName,
      this.courseDescription,
      this.courseLevel});

  factory Course.fromFirestore(Map<String, dynamic> snapshot) {
    return Course(
        courseId: snapshot['courseId'],
        courseName: snapshot['courseName'],
        courseDescription: snapshot['courseDescription'],
        courseLevel: snapshot['courseLevel']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (courseId != null) 'courseId': courseId,
      if (courseName != null) 'courseName': courseName,
      if (courseDescription != null) 'courseDescription': courseDescription,
      if (courseLevel != null) 'courseLevel': courseLevel,
    };
  }
}
