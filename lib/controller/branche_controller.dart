import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/branche_model.dart';

class BrancheController {
  static var database = FirebaseFirestore.instance;

  static String addBranche(Branche branche) {
    String id = "";
    database
        .collection("branches")
        .add(branche.toFirestore())
        .then((DocumentReference doc) => id = doc.id);
    return id;
  }

  static Stream<List<Branche>> showBranches(String branche) {
    return database.collection("branches").where("brancheCategory", isEqualTo: branche).snapshots().map((event) =>
        event.docs.map((e) => Branche.fromFirestore(e.data())).toList());
  }
}