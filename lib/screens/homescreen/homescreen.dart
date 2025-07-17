// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqlite_demo/config/app_colors.dart';
import 'package:sqlite_demo/db/db_helper.dart';
import 'package:sqlite_demo/model/student_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var studentDatas = [];
  String greeting = "Good \nMorning!";
  void getGreeting() {
    var hour = DateTime.now().hour;
    //print("Current hour : $hour");
    if (hour >= 1 && hour < 12) {
      setState(() {
        greeting = "Good \nMorning!";
      });
    } else if (hour >= 12 && hour < 18) {
      setState(() {
        greeting = "Good \nAfternoon!";
      });
    } else {
      setState(() {
        greeting = "Good \nEvening!";
      });
    }
  }

  void loadData() async {
    var data = await DbHelper.readStudents();

    setState(() {
      studentDatas = data;
    });

    print("Student data : $studentDatas");
    // print("Student name : ${studentDatas[3]["first_name"]}");

    var student = StudentModel.fromJson(studentDatas[0]);

    print(("Stundet name : ${student.firstName}"));
    print(("Stundet name : ${student.lastName}"));
    print(("Stundet dob : ${student.dob}"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
    getGreeting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addButton(),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            buildOptions(),
            buildStudentList(),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/addStudent",
          arguments: [
            false,
            null,
          ],
        ).then(
          (value) {
            loadData();
          },
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      color: AppColors.primaryColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment:Alignment.topRight,
              child: Icon(Icons.search,
              color: Colors.white,
              size: 30,
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: FittedBox(
                child: Text(
                  greeting.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: FittedBox(
                child: Text(
                  "You have ${studentDatas.length} Student(s) in your database",
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptions() {
    return Container();
  }

  Widget buildStudentList() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "All Student".toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/addStudent",
                    arguments: [
                      false,
                      null,
                    ],
                  ).then(
                    (value) {
                      loadData();
                    },
                  );
                },
                child: Text(
                  "View All".toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 25,
              )
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 20),
            itemBuilder: (context, index) {
              var student = StudentModel.fromJson(studentDatas[index]);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 35,
                      backgroundImage: FileImage(
                        File(student.profile),
                      ),
                      child: student.profile.isEmpty
                          ? Text(
                              "${student.firstName[0]}${student.lastName[0]}"
                                  .toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : SizedBox(),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          "Full Name : ${student.firstName} ${student.lastName}",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Gender : ${student.gender}",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            radius: 30,
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  Text(
                                                    "${student.firstName} ${student.lastName}",
                                                    style: GoogleFonts
                                                        .spaceGrotesk(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: student.gender ==
                                                              "Male"
                                                          ? Colors.blue
                                                              .withValues(
                                                                  alpha: 0.1)
                                                          : Colors.pink
                                                              .withValues(
                                                                  alpha: 0.1),
                                                      border: Border.all(
                                                        color: student.gender ==
                                                                "Male"
                                                            ? Colors.blue
                                                            : Colors.pink,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      student.gender,
                                                      style: GoogleFonts
                                                          .spaceGrotesk(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                        color: student.gender ==
                                                                "Male"
                                                            ? Colors.blue
                                                            : Colors.pink,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                "DOB : ${student.dob}",
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                      thickness: 1,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                          context,
                                          "/addStudent",
                                          arguments: [
                                            true,
                                            student,
                                          ],
                                        ).then(
                                          (value) {
                                            loadData();
                                          },
                                        );
                                      },
                                      title: Text(
                                        "Update Student",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Update Student Details",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      leading: Icon(Icons.edit),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        DbHelper.deleteStudent(student.id);
                                        loadData();
                                      },
                                      iconColor: Colors.red,
                                      textColor: Colors.red,
                                      title: Text(
                                        "Delete Student",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Delete Student Details",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      leading: Icon(Icons.delete),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.more_horiz_sharp,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: studentDatas.length,
          )
        ],
      ),
    );
  }
}


//image
//Widget : Image.asset, Image.network, Image.file
//ImageProvider : AssetImage, NetworkImage, FileImage