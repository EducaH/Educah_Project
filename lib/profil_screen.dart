import 'dart:async';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:educah/controller/student_controller.dart';
import 'package:educah/intro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import 'app_strings.dart';
import 'model/student_model.dart';

bool? isConnected;
var url;

class ProfilScreen extends StatefulWidget {
  const ProfilScreen(
      {super.key, required this.studentEmail, required this.isExist});

  final String studentEmail;
  final bool isExist;

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  SharedPreferences? _prefs;
  bool hasIntro = true;
  String themeApp = "light";

  StreamSubscription? subscription;

  final formKey = GlobalKey<FormState>();

  late Widget formBuild;
  var fieldName;
  var fieldEmail;
  var fieldPhoto;
  var fieldSchool;
  var fieldLevel;
  var fieldDepartment;

  File? imageFile;
  final picker = ImagePicker();

  void loadPref() {
    setState(() {
      themeApp = _prefs?.getString(AppStrings.key_theme) ?? "light";
      hasIntro = _prefs?.getBool(AppStrings.key_intro) ?? true;
    });
  }

  Widget showNextScreen() {
    Widget screen;
    if (hasIntro) {
      screen = const IntroScreen();
    } else {
      screen = const Center(child: Text("HOME SCREEN"));
    }
    return screen;
  }

  Future<void> pickFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        //Save puis Afficher (Idea)
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef =
            storageRef.child("students/photos/${widget.studentEmail}");
        imageRef.putFile(imageFile!);
        String data = await storageRef
            .child("students/photos/${widget.studentEmail}")
            .getDownloadURL();
        // StudentHelper.updatePhoto(widget.studentEmail, data);
        // print("DATA :$data");
        setState(() {
          StudentController.updatePhotoUrl(widget.studentEmail, data);
          print("DATA :$data");
          url = data;
        });
      }
    }
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
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExist ? buildFormUpdate() : buildFormAdd();
  }

  Widget buildFormAdd() {
    url = FirebaseAuth.instance.currentUser?.photoURL as String;
    fieldName = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.displayName);
    fieldEmail =
        TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
    fieldPhoto = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.photoURL);
    fieldSchool = TextEditingController();
    fieldLevel = TextEditingController(text: "NS4");
    fieldDepartment = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                            maxRadius: 50.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(url)))
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                        controller: fieldName,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Put your name',
                            labelText: 'Name',
                            filled: true,
                            prefixIcon: Icon(Icons.person)))),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: fieldEmail,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Put your email',
                        labelText: 'Email',
                        filled: true,
                        prefixIcon: Icon(Icons.mail),
                      ),
                      readOnly: true,
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: fieldSchool,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Put the name of your school',
                          labelText: 'School Name',
                          filled: true,
                          prefixIcon: Icon(Icons.home)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Put the name of your school";
                        }
                        return null;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: fieldLevel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Put your level',
                        labelText: 'Level',
                        filled: true,
                        prefixIcon: Icon(Icons.arrow_circle_up),
                      ),
                      readOnly: true,
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: fieldDepartment,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Put the department of your school',
                          labelText: 'Department',
                          filled: true,
                          prefixIcon: Icon(Icons.location_city)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Put the department of your school";
                        }
                        return null;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            Student student = Student(
                                fieldName.text,
                                fieldEmail.text,
                                url,
                                fieldSchool.text,
                                fieldLevel.text,
                                fieldDepartment.text,
                                5,
                                0);

                            StudentController.addStudent(student);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const IntroScreen();
                            }));
                          });
                        }
                      },
                      child: const Text('Ajouter'),
                    ))
              ]),
        ),
      ),
    );
  }

  Widget buildFormUpdate() {
    url = FirebaseAuth.instance.currentUser?.photoURL as String;
    fieldName = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.displayName);
    fieldEmail =
        TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
    fieldPhoto = TextEditingController(
        text: FirebaseAuth.instance.currentUser?.photoURL);
    fieldSchool = TextEditingController();
    fieldLevel = TextEditingController(text: "NS4");
    fieldDepartment = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
          elevation: 1.0,
        ),
        body: FutureBuilder<Student>(
          future: StudentController.showStudent1(widget.studentEmail),
          builder: (context, snapshot) {
            Student? student = snapshot.data;
            url = student?.studentPhotoUrl;
            fieldName = TextEditingController(text: student?.studentName);
            fieldEmail = TextEditingController(text: student?.studentEmail);
            fieldPhoto = TextEditingController(text: student?.studentPhotoUrl);
            fieldSchool =
                TextEditingController(text: student?.studentSchoolName);
            fieldLevel = TextEditingController(text: student?.studentLevel);
            fieldDepartment =
                TextEditingController(text: student?.studentDepartment);

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isConnected == false
                                  ? const CircleAvatar(
                                      maxRadius: 60.0,
                                      child: Icon(Icons.person))
                                  : Stack(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      children: <Widget>[
                                        CircleAvatar(
                                            maxRadius: 60.0,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(url)),
                                        GestureDetector(
                                          child: const CircleAvatar(
                                              maxRadius: 20.0,
                                              backgroundColor: Colors.grey,
                                              child: Icon(Icons.edit)),
                                          onTap: () => pickFromGallery(),
                                        )
                                      ],
                                    ))
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                              controller: fieldName,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Put your name',
                                  labelText: 'Name',
                                  filled: true,
                                  prefixIcon: const Icon(Icons.person),
                                  suffixIcon: widget.isExist
                                      ? IconButton(
                                          onPressed: () {
                                            //
                                          },
                                          icon: const Icon(Icons.check_rounded))
                                      : null))),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldEmail,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Put your email',
                              labelText: 'Email',
                              filled: true,
                              prefixIcon: Icon(Icons.mail),
                            ),
                            readOnly: true,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldSchool,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Put the name of your school',
                                labelText: 'School Name',
                                filled: true,
                                prefixIcon: const Icon(Icons.home),
                                suffixIcon: widget.isExist
                                    ? IconButton(
                                        onPressed: () {
                                          //
                                        },
                                        icon: const Icon(Icons.check_rounded))
                                    : null),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Put the name of your school";
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldLevel,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Put your level',
                              labelText: 'Level',
                              filled: true,
                              prefixIcon: Icon(Icons.arrow_circle_up),
                            ),
                            readOnly: true,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldDepartment,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Put the department of your school',
                                labelText: 'Department',
                                filled: true,
                                prefixIcon: const Icon(Icons.location_city),
                                suffixIcon: widget.isExist
                                    ? IconButton(
                                        onPressed: () {
                                          //
                                        },
                                        icon: const Icon(Icons.check_rounded))
                                    : null),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Put the department of your school";
                              }
                              return null;
                            },
                          ))
                    ]),
              ),
            );
          },
        ));
  }

  Widget buildFormUpdate1() {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
          elevation: 1.0,
        ),
        body: FutureBuilder<Student>(
          future: StudentController.showStudent1(widget.studentEmail),
          builder: (context, snapshot) {
            Student? student = snapshot.data;
            url = student?.studentPhotoUrl;
            fieldName = TextEditingController(text: student?.studentName);
            fieldEmail = TextEditingController(text: student?.studentEmail);
            fieldPhoto = TextEditingController(text: student?.studentPhotoUrl);
            fieldSchool =
                TextEditingController(text: student?.studentSchoolName);
            fieldLevel = TextEditingController(text: student?.studentLevel);
            fieldDepartment =
                TextEditingController(text: student?.studentDepartment);

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                child: isConnected == false
                                    ? CircleAvatar(
                                        radius: 25.0,
                                        child: Text(student?.studentName
                                            .substring(0, 1) as String))
                                    : CircleAvatar(
                                        maxRadius: 50.0,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                            student?.studentPhotoUrl as String)
                                        //child: photo,
                                        ),
                                onTap: () {
                                  pickFromGallery();
                                },
                              ))
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                              controller: fieldName,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Put your name',
                                labelText: 'Name',
                                filled: true,
                                prefixIcon: Icon(Icons.person),
                              ))),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldEmail,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Put your email',
                              labelText: 'Email',
                              filled: true,
                              prefixIcon: Icon(Icons.mail),
                            ),
                            readOnly: true,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldSchool,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Put the name of your school',
                              labelText: 'School Name',
                              filled: true,
                              prefixIcon: Icon(Icons.home),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldLevel,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Put your level',
                              labelText: 'Level',
                              filled: true,
                              prefixIcon: Icon(Icons.arrow_circle_up),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: fieldDepartment,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Put the department of your school',
                              labelText: 'Department',
                              filled: true,
                              prefixIcon: Icon(Icons.location_city),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (await StudentController.isStudentExist(
                                  fieldEmail.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("ALREADY EXIST"),
                                        duration: Duration(seconds: 10)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("NOT EXIST"),
                                        duration: Duration(seconds: 10)));
                                setState(() {
                                  StudentController.addStudent(student!);
                                  final storageRef =
                                      FirebaseStorage.instance.ref();
                                  final imageRef = storageRef.child(
                                      "students/photos/${widget.studentEmail}");
                                  imageRef.putFile(imageFile!);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return Container();
                                  }));
                                });
                              }
                            },
                            child: const Text('Update'),
                          ))
                    ]),
              ),
            );
          },
        ));
  }
}
