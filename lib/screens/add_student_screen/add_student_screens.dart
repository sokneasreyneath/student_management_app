// ignore_for_file: avoid_print

import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_demo/config/app_colors.dart';
import 'package:sqlite_demo/db/db_helper.dart';

class AddStudentScreens extends StatefulWidget {
  const AddStudentScreens({super.key});

  @override
  State<AddStudentScreens> createState() => _AddStudentScreensState();
}

class _AddStudentScreensState extends State<AddStudentScreens> {
  var fnCtrl = TextEditingController();
  var lnCtrl = TextEditingController();
  String selectDOB = "";
  String gender = "";
  String selectProfile = "";

  void chooseProfile(ImageSource source) async {
    var imagePicked = await ImagePicker().pickImage(source: source);

    print("Image: ${imagePicked!.path}");

    setState(() {
      selectProfile = imagePicked.path;
    });
  }

  var isUpdate = false;
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadData() {
    var student = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    isUpdate = student[0];
    if (student[1] != null) {
      fnCtrl.text = student[1].firstName;
      lnCtrl.text = student[1].lastName;
      selectDOB = student[1].dob;
      selectProfile = student[1].profile;
      gender = student[1].gender;
      id = student[1].id;
    }
    setState(() {
      isInit = true;
    });
  }

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      loadData();
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Add Student",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSelectProfile(),
              SizedBox(
                height: 30,
              ),
              Text(
                "First Name",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              buildTextField(
                hint: "Enter first name",
                controller: fnCtrl,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Last Name",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              buildTextField(
                hint: "Enter last name",
                controller: lnCtrl,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Gender",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              _buildGenderSelector(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Date of Birth",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
              buildDobSelector(),
              SizedBox(
                height: 40,
              ),
              buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectProfile() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Choose Options"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      chooseProfile(ImageSource.camera);
                    },
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      chooseProfile(ImageSource.gallery);
                    },
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  ),
                ],
              ),
              actionsPadding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              contentPadding: EdgeInsets.only(left: 20, right: 20),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancle"),
                ),
              ],
            );
          },
        );
      },
      child: Center(
        child: badges.Badge(
          badgeContent: Icon(
            Icons.add,
            color: Colors.white,
          ),
          position: badges.BadgePosition.bottomEnd(
            bottom: 5,
            end: 5,
          ),
          child: Container(
            width: 150,
            height: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: selectProfile.isEmpty
                ? SizedBox()
                : Image.file(
                    File(selectProfile),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hint,
        hintStyle: GoogleFonts.spaceGrotesk(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Radio(
          value: "Male",
          groupValue: gender,
          onChanged: (value) {
            print(value);
            setState(() {
              gender = value!;
            });
          },
        ),
        Text(
          "Male",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Radio(
          value: "Female",
          groupValue: gender,
          onChanged: (value) {
            print(value);
            setState(() {
              gender = value!;
            });
          },
        ),
        Text(
          "Female",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildDobSelector() {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        ).then(
          (value) {
            print(value);
            setState(() {
              //EEE : day of the week (mon, tue ...)
              //EEEE : full day of the week (Monday, Tuesday ...)
              //dd : day of the month (01, 02, ...)
              //MMM : short month name (Jan, Feb, ...)
              //MMMM : full month name (January, February, ...)
              //yyyy : full year (2023, 2024, ...)
              //yy : short year (23, 24, ...)

              selectDOB = DateFormat("EEE, dd MMMM yyyy").format(value!);
            });
          },
        );
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            selectDOB.isEmpty ? "Select DOB " : selectDOB,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () {
        if (fnCtrl.text.isEmpty ||
            lnCtrl.text.isEmpty ||
            selectDOB.isEmpty ||
            gender.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Please fill all fields")));
        } else {
          isUpdate
              ? DbHelper.updateStudent(
                  fn: fnCtrl.text,
                  ln: lnCtrl.text,
                  gender: gender,
                  dob: selectDOB,
                  profile: selectProfile,
                  id: id,
                )
              : DbHelper.insertStudent(
                  fn: fnCtrl.text,
                  ln: lnCtrl.text,
                  gender: gender,
                  dob: selectDOB,
                  profile: selectProfile);

          if (isUpdate) {
            Navigator.pop(context);
          }
          setState(() {
            fnCtrl.clear();
            lnCtrl.clear();
            gender = "";
            selectDOB = "";
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(isUpdate
                    ? "Student update Successfully!"
                    : "Student added Successfully")),
          );
        }
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            isUpdate ? "Update Student" : "Add Student",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


//radio button
//showDatePicker //showCupertinoDatePicker