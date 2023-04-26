import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/student_model.dart';

class StudentController {
  static var database = FirebaseFirestore.instance;

  static void addStudent(Student student) {
    database
        .collection("students")
        .doc(student.studentEmail)
        .set(student.toFirestore());
  }

  static Future<bool> isStudentExist(String docId) async {
    final ref = database.collection("students").doc(docId);
    final doc = await ref.get();
    return doc.exists;
  }

  static Stream<Student> showStudent(String docId) {
    final ref = database.collection("students").doc(docId);
    return ref.snapshots().map(
        (event) => Student.fromFirestore(event.data() as Map<String, dynamic>));
  }

  static Stream<List<Student>> showAllStudents() {
    return database
        .collection("students")
        .orderBy("studentMojo", descending: true)
        .limit(30)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Student.fromFirestore(e.data())).toList());
  }

  static Future<Student> showStudent1(String docId) async {
    final ref = database.collection("students").withConverter<Student>(
        fromFirestore: (snapshot, options) =>
            Student.fromFirestore(snapshot.data()!),
        toFirestore: (value, options) => value.toFirestore());
    return await ref.doc(docId).get().then((value) => value.data()!);
  }

  static void removeStudent(String docId) {
    database.collection("students").doc(docId).delete();
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("students/photos/$docId");
    imageRef.delete();
    FirebaseAuth.instance.currentUser!.delete();
    FirebaseAuth.instance.currentUser == null;
  }

  static int getLife(String docId) {
    final ref = database.collection("students").doc(docId);
    final life = ref.snapshots().map(
        (event) => Student.fromFirestore(event.data() as Map<String, dynamic>));
    return 0;
  }

  static Future<void> updatePhotoUrl(String docId, String data) async {
    await database.collection("students").doc(docId).update(
        {"studentPhotoUrl": data}).then((value) => print("Photo url update !"));
  }

  static Future<void> upgradeLife(String docId, int life) async {
    await database
        .collection("students")
        .doc(docId)
        .update({"studentLife": life}).then((value) => print("Life upgrade !"));
  }

  static Future<void> downgradeLife(String docId, int life) async {
    await database.collection("students").doc(docId).update(
        {"studentLife": life}).then((value) => print("Life downgrade !"));
  }
}
