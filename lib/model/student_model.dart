class Student {
  String studentName = "";
  String studentEmail = "";
  String studentPhotoUrl = "";
  String studentSchoolName = "";
  String studentLevel = "";
  String studentDepartment = "";
  int studentLife = 0;
  int studentMojo = 0;

  Student(
      this.studentName,
      this.studentEmail,
      this.studentPhotoUrl,
      this.studentSchoolName,
      this.studentLevel,
      this.studentDepartment,
      this.studentLife,
      this.studentMojo);

  Student.fromFirestore(Map<String, dynamic> snapshot) {
    studentName = snapshot['studentName'];
    studentEmail = snapshot['studentEmail'];
    studentPhotoUrl = snapshot['studentPhotoUrl'];
    studentSchoolName = snapshot['studentSchoolName'];
    studentLevel = snapshot['studentLevel'];
    studentDepartment = snapshot['studentDepartment'];
    studentLife = snapshot['studentLife'];
    studentMojo = snapshot['studentMojo'];
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (studentName != null) 'studentName': studentName,
      if (studentEmail != null) 'studentEmail': studentEmail,
      if (studentPhotoUrl != null) 'studentPhotoUrl': studentPhotoUrl,
      if (studentSchoolName != null) 'studentSchoolName': studentSchoolName,
      if (studentLevel != null) 'studentLevel': studentLevel,
      if (studentDepartment != null) 'studentDepartment': studentDepartment,
      if (studentLife != null) 'studentLife': studentLife,
      if (studentMojo != null) 'studentMojo': studentMojo
    };
  }
}
