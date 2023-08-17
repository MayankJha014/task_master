import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/add_project/services/add_services.dart';
import 'package:task_master/global.dart';
import 'package:task_master/utils/show_snackbar.dart';
import 'package:task_master/utils/utils.dart';

var taskStatusProvider = StateProvider<String>((ref) => 'Ongoing');

class AddProject extends ConsumerStatefulWidget {
  const AddProject({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProjectState();
}

class _AddProjectState extends ConsumerState<AddProject>
    with SingleTickerProviderStateMixin {
  String? value;
  final AddService addService = AddService();
  TextEditingController projectController = TextEditingController();
  TextEditingController projectDescController = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  var taskStatus;
  Uint8List? _image;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  bool loading = false;

  String selectedColor = '0';

  Future<void> addTask() async {
    setState(() {
      loading = true;
    });
    if (value == 'Daily') {
      if (startDate.text.isEmpty ||
          endDate.text.isEmpty ||
          projectController.text.isEmpty ||
          value == null) {
        showSnackbar(context, "Fill all the input value");
        setState(() {
          loading = false;
        });
      } else {
        await addService.dailyTask(
          context: context,
          taskGroup: value!,
          projectName: projectController.text,
          startDate: startDate.text,
          endDate: endDate.text,
          color: selectedColor,
          ref: ref,
          status: taskStatus,
        );
        setState(() {
          loading = false;
        });
      }
    } else {
      if (startDate.text.isEmpty ||
          endDate.text.isEmpty ||
          projectController.text.isEmpty ||
          value == null ||
          _image == null) {
        showSnackbar(context, "Fill all the input value");
        setState(() {
          loading = false;
        });
      } else {
        try {
          await addService.craeteTask(
            context: context,
            taskGroup: value!,
            projectName: projectController.text,
            startDate: startDate.text,
            endDate: endDate.text,
            color: selectedColor,
            ref: ref,
            status: taskStatus,
            logo: _image,
          );
          setState(() {
            loading = false;
          });
        } catch (e) {
          showSnackbar(context, e.toString());
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    startDate.text = ""; //set the initial value of text field
    endDate.text = ""; //set the initial value of text field
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
        setState(() {});
      });
  }

  var dropDownItem = [
    'Work',
    'Personal',
    'Daily',
  ];

  AnimationController? animationController;
  OnTapDown(TapDownDetails details) {
    animationController?.forward();
  }

  OnTapUp(TapUpDetails details) {
    animationController?.reverse();
  }

  OnTapCancel() {
    animationController?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    taskStatus = ref.watch(taskStatusProvider);
    double scale = 1 + animationController!.value;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/scaffold.png',
          ),
          fit: BoxFit.cover,
        ),
        automaticallyImplyLeading: false,
        elevation: 2.5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BottomBar(
                          data: 1,
                        )));
              },
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                // size: 25,
                color: Colors.black,
              ),
            ),
            const Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.notifications,
              size: 25,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/scaffold.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
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
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                        // horizontal: 3.0,
                      ),
                      child: SizedBox(
                        width: size.width * 0.95,
                        child: DropdownButton(
                          enableFeedback: true,
                          elevation: 0,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          value: value,
                          underline: const SizedBox(),
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 40,
                            color: Colors.black,
                          ),
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Text(
                              "Select your Task",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          items: dropDownItem.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                width: size.width * 0.75,
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Task Group',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2.0,
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            items,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              value = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
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
                        controller: projectController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: value == 'Daily' ? 'Task' : 'Project Name',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          hintText: value == 'Daily'
                              ? 'Enter Your Task'
                              : 'Enter Your Project Name',
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
                      horizontal: 25,
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
                            setState(() {
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
                      horizontal: 25,
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
                            setState(() {
                              endDate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                    ),
                  ),
                  value == 'Daily'
                      ? Container()
                      : Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 25,
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
                              child: Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0,
                                        vertical: 10,
                                      ),
                                      child: _image != null
                                          ? Image(
                                              image: MemoryImage(_image!),
                                              width: 30,
                                              height: 30,
                                            )
                                          : Image.asset(
                                              'assets/google.png',
                                              width: 30,
                                              height: 30,
                                            )),
                                  // const Expanded(
                                  //   child: Text(
                                  //     'Google',
                                  //     textAlign: TextAlign.left,
                                  //     style: TextStyle(
                                  //       color: Colors.grey,
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 231, 218, 250),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        selectImage();
                                      },
                                      child: const Text(
                                        'Choose Logo',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 30,
                            right: 15,
                            top: 10,
                            bottom: 10,
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
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedColor = index.toString();
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: colorData[index],
                                        child: selectedColor == index.toString()
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTapDown: OnTapDown,
                  onTapCancel: OnTapCancel,
                  onTapUp: OnTapUp,
                  onTap: loading
                      ? () {}
                      : () {
                          addTask();
                        },
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: loading ? 5 : 20,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                          color: loading ? Colors.grey[800] : buttonColor,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: const Offset(10, 12),
                              color: loading
                                  ? const Color.fromARGB(238, 78, 78, 78)
                                  : const Color.fromARGB(239, 187, 167, 248),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loading
                              ? SizedBox(
                                  width: 90,
                                  height: 50,
                                  child: Center(
                                    child: Lottie.asset(
                                      width: double.infinity,
                                      height: double.infinity,
                                      "assets/loader1.json",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Add Project",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
