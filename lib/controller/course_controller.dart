import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course_model.dart';

class CourseController {
  static var database = FirebaseFirestore.instance;

  static String addCourse(Course course) {
    String id = "";
    database
        .collection("courses")
        .add(course.toFirestore())
        .then((DocumentReference doc) => id = doc.id);
    return id;
  }

  static Stream<List<Course>> showAllCourses() {
    return database.collection("courses").where("courseLevel", isEqualTo: "NS4").snapshots().map((event) =>
        event.docs.map((e) => Course.fromFirestore(e.data())).toList());
    // return database.collection("courses").snapshots().map((event) =>
    //     event.docs.map((e) => Course.fromFirestore(e.data())).toList());
  }
}