import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import 'controller/student_controller.dart';
import 'model/student_model.dart';

bool? isConnected;

class ClassementScreen extends StatefulWidget {
  const ClassementScreen({super.key});

  @override
  State<ClassementScreen> createState() => ClassementScreenState();
}

class ClassementScreenState extends State<ClassementScreen> {
  StreamSubscription? subscription;

  @override
  void initState() {
    // TODO: implement initState
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Student>>(
      stream: StudentController.showAllStudents(),
      builder: (context, snapshot) {
        List<Student>? students = snapshot.data;

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("EMPTY"));
        }

        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${index + 1}- ",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  isConnected == false
                      ? CircleAvatar(
                          maxRadius: 20.0,
                          child: Text(students?[index]
                              .studentName
                              .substring(0, 1) as String))
                      : CircleAvatar(
                          maxRadius: 20.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              students?[index].studentPhotoUrl as String)),
                ],
              ),
              title: Text(students?[index].studentName as String,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
              subtitle: Text(students?[index].studentSchoolName as String,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 10.0)),
              trailing: Text("${students?[index].studentMojo} Mojos",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Fluttertoast.showToast(
                    msg: students?[index].studentName as String,
                    backgroundColor: Colors.purple);
              },
            );
          },
        );
      },
    );
  }
}
