class StudentModel {
  int id;
  String firstName;
  String lastName;
  String gender;
  String dob;
  String profile;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.profile,
  });

  //create factory constructor
  //method 1
  // StudentModel.fromJson(Map<String, dynamic> data)
  //     : id = data["id"],
  //       firstName = data["first_name"],
  //       lastName = data["last_name"],
  //       gender = data["gender"],
  //       dob = data["dob"];

  //method 2
  factory StudentModel.fromJson(Map<String, dynamic> data) {
    return StudentModel(
      id: data["id"],
      firstName: data["first_name"],
      lastName: data["last_name"],
      gender: data["gender"],
      dob: data["dob"],
      profile: data["profile"] ?? "",
    );
  }

  static fromjson(studentData) {}
}

// var student = StudentModel(1, "", "", "", "");
// var student2 = StudentModel(studentDatas[index]);
