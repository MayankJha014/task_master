// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:task_master/components/project-detail/services/project_service.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/user.dart';
import 'package:task_master/utils/show_snackbar.dart';

class AssignedUserModel {
  final String userId;
  final bool isCompleted;
  AssignedUserModel({
    required this.userId,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'isCompleted': isCompleted,
    };
  }

  factory AssignedUserModel.fromMap(Map<String, dynamic> map) {
    return AssignedUserModel(
      userId: map['userId'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignedUserModel.fromJson(String source) =>
      AssignedUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

Future<void> stepperDailog(BuildContext context, WidgetRef ref,
    {required String projectId, required List<User> team}) async {
  int selectedColor = 0;
  int? selectedIndex;
  final TextEditingController taskController = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController labelController = TextEditingController();

  final List<AssignedUserModel> taskData = [];
  final formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      var size = MediaQuery.of(context).size;
      void asignDailyTask() {
        if (taskController.text != '' &&
            startDate.text != '' &&
            endDate.text != '' &&
            labelController.text != '') {
          ProjectService().dailyTask(
            context: context,
            taskGroup: 'Daily',
            projectId: projectId,
            task: taskController.text,
            startDate: startDate.text,
            endDate: endDate.text,
            color: selectedColor.toString(),
            assignedUser: taskData,
            ref: ref,
            status: "OnGoing",
            label: labelController.text,
          );
        } else {
          showSnackbar(context, 'Fill all input');
        }
      }

      return AlertDialog(
        elevation: 2,
        // insetAnimationDuration: const Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: StatefulBuilder(builder: (BuildContext context, mySetState) {
          return SizedBox(
            height: size.height * 0.8,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Add Task",
                              style: GoogleFonts.patuaOne(
                                fontWeight: FontWeight.normal,
                                fontSize: 22,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 1,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: labelController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Title',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            hintText: 'Enter Your Title',
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 1,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextField(
                          controller: taskController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Task',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            hintText: 'Enter Your Task ',
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 15,
                      ),
                      child: Text(
                        "Colors:",
                        style: GoogleFonts.patuaOne(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                        width: size.width * 0.7,
                        height: 50,
                        padding: const EdgeInsets.only(left: 1.0),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                            ),
                            itemCount: colorData.length,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    mySetState(() => selectedColor = index);
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: colorData[index],
                                    child: selectedColor == index
                                        ? const Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : Container(),
                                  ),
                                ),
                              );
                            })),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 1,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          controller: startDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                          decoration: InputDecoration(
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 45,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.deepPurple[800],
                                size: 30,
                              ), //icon of text field
                              labelText: "Start Date",
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ) //label text of field
                              ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              mySetState(() {
                                startDate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 1,
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextField(
                          controller: endDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 45,
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.calendar_month,
                              color: Colors.deepPurple[800],
                              size: 30,
                            ), //icon of text field
                            labelText: "End Date",
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            //label text of field
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              mySetState(() {
                                endDate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Team:",
                              style: GoogleFonts.patuaOne(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                              width: size.width,
                              height: 70,
                              padding: const EdgeInsets.only(left: 1.0),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: team.length,
                                  itemBuilder: (context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              mySetState(() {
                                                selectedIndex = index;
                                                taskData.any((element) =>
                                                        element.userId ==
                                                        team[selectedIndex!].id)
                                                    ? print(
                                                        "Value already Present")
                                                    : taskData.add(
                                                        AssignedUserModel(
                                                          userId: team[
                                                                  selectedIndex!]
                                                              .id,
                                                          isCompleted: false,
                                                        ),
                                                      );
                                              });
                                            },
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                team[index].profilePicture == ''
                                                    ? profilePic
                                                    : team[index]
                                                        .profilePicture!,
                                              ),
                                              child: taskData.any((element) =>
                                                      element.userId ==
                                                      team[index].id)
                                                  ? const Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                      size: 16,
                                                    )
                                                  : Container(),
                                            ),
                                          ),
                                          Text(
                                            team[index].displayName,
                                            // maxLines: 1,
                                            style: GoogleFonts.openSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    );
                                  })),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        asignDailyTask();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: buttonColor,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: Offset(10, 12),
                                color: Color.fromARGB(239, 187, 167, 248),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Task",
                              style: GoogleFonts.patuaOne(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}
