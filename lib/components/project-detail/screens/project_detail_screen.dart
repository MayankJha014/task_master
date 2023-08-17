// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/project-detail/screens/search_screen.dart';
import 'package:task_master/components/project-detail/screens/stepper_dailog.dart';
import 'package:task_master/components/project-detail/services/project_service.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/project_model.dart';
import 'package:task_master/model/task_model.dart';
import 'package:task_master/model/user.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final ProjectModel task;
  final bool isAccess;
  const ProjectDetailScreen({
    super.key,
    required this.task,
    required this.isAccess,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  final ProjectService projectService = ProjectService();
  @override
  List data = [
    "Start",
    "Think",
    'Create',
    'Problem',
    "Solving",
    "Thank you",
  ];

  bool isActive = false;

  String? taskId;

  List<User> friendsList = [];

  @override
  void initState() {
    super.initState();
    getFriendsList();
    getStepperTaskList();
    setState(() {});
  }

  List<TaskModel> stepperTaskList = [];

  Future<void> endProject() async {
    await projectService.endProject(
      context: context,
      id: widget.task.id,
      endProject: true,
      ref: ref,
    );
    if (context.mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    }
  }

  Future<void> taskCompleted(String taskuId) async {
    await projectService.taskCompleted(
      context: context,
      projectId: taskuId,
      projectCompletion: true,
      ref: ref,
    );
    if (context.mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    }
  }

  void getStepperTaskList() async {
    stepperTaskList = await projectService.fetchTaskOfStepper(
        context: context, projectId: widget.task.id, ref: ref);
    setState(() {});
  }

  bool taskIsCompleted({required int value}) {
    if (stepperTaskList.isNotEmpty) {
      var data = stepperTaskList[value];
      if (data.assignedUser.isNotEmpty) {
        int? datanui;
        (value < data.assignedUser.length) ? datanui = value : datanui = 0;
        return data.assignedUser[datanui].isCompleted;
      } else {
        return false;
      }
    }
    return false;
  }

  void getFriendsList() async {
    friendsList = await projectService.getFriends(
      context: context,
      id: widget.task.id,
      ref: ref,
    );
    setState(() {});
  }

  void navigateSearchScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          taskId: taskId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          data: 0,
                        )));
              },
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                // size: 25,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: size.width * 0.60,
              child: Center(
                child: Text(
                  widget.task.projectName,
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
          vertical: 0,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border(
                  //   bottom: BorderSide(),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      height: size.height * 0.09,
                      child: ListView.builder(
                          itemCount: friendsList.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              width: size.width * 0.15,
                              child: friendsList == []
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            friendsList[index].profilePicture ==
                                                    ''
                                                ? profilePic
                                                : friendsList[index]
                                                    .profilePicture!,
                                          ),
                                        ),
                                        Text(
                                          friendsList[index].displayName,
                                          // maxLines: 1,
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                            );
                          }),
                    ),
                    widget.task.endProject || !widget.isAccess
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.deepPurple,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    taskId = widget.task.id;
                                  });
                                  navigateSearchScreen();
                                },
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.group_add_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              widget.task.endProject || !widget.isAccess
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            stepperDailog(context, ref,
                                projectId: widget.task.id, team: friendsList);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black,
                            ),
                            child: Text(
                              "Add Task",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                width: 2,
                height: 50,
                color: Colors.black,
              ),
              widget.task.stepper!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        // vertical: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.grey[400],
                                  child: const Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  stepperTaskList.isEmpty
                                      ? ""
                                      : stepperTaskList[0].taskGroup,
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 19,
                                ),
                                width: 2,
                                height: 150,
                                color: Colors.black,
                              ),
                              Column(
                                children: [
                                  ChatBubble(
                                    clipper: ChatBubbleClipper10(
                                      type: BubbleType.receiverBubble,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    backGroundColor: Colors.grey[400],
                                    child: Container(
                                      width: size.width * 0.65,
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Text(
                                        "Create your first task and start your Project Journey ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      stepperDailog(context, ref,
                                          projectId: widget.task.id,
                                          team: friendsList);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black,
                                      ),
                                      child: Text(
                                        "Add Task",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      width: size.width,
                      height: size.height * 0.7,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.task.stepper!.length,
                          itemBuilder: (context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                // vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: CircleAvatar(
                                          radius: 17,
                                          backgroundColor: (taskIsCompleted(
                                                  value: index))
                                              ? colorData[int.parse(
                                                  stepperTaskList[index].color)]
                                              : Colors.blueGrey,
                                          child: Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          stepperTaskList.isEmpty
                                              ? ""
                                              : stepperTaskList[index].task,
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  index + 1 == data.length
                                      ? Container()
                                      : Row(
                                          children: [
                                            (widget.task.stepper!.length - 1) ==
                                                    index
                                                ? Container()
                                                : Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 19,
                                                    ),
                                                    width: 2,
                                                    height: 150,
                                                    color: Colors.black,
                                                  ),
                                            Column(
                                              children: [
                                                ChatBubble(
                                                  clipper: ChatBubbleClipper10(
                                                    type: BubbleType
                                                        .receiverBubble,
                                                  ),
                                                  margin: ((widget.task.stepper!
                                                                  .length -
                                                              1) ==
                                                          index)
                                                      ? const EdgeInsets.only(
                                                          bottom: 10, left: 50)
                                                      : const EdgeInsets.only(
                                                          bottom: 30),
                                                  backGroundColor:
                                                      (stepperTaskList.isEmpty
                                                              ? false
                                                              : taskIsCompleted(
                                                                  value: index))
                                                          ? colorData[int.parse(
                                                              stepperTaskList[
                                                                      index]
                                                                  .color)]
                                                          : Colors.grey[400],
                                                  child: Container(
                                                    width: size.width * 0.65,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      widget
                                                          .task
                                                          .stepper![index]
                                                          .label,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                (widget.task.endProject)
                                                    ? Container()
                                                    : Row(
                                                        children: [
                                                          (taskIsCompleted(
                                                                  value: index))
                                                              ? Container()
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    taskCompleted(widget
                                                                        .task
                                                                        .stepper![
                                                                            index]
                                                                        .taskId);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .all(5),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                      border: Border
                                                                          .all(),
                                                                    ),
                                                                    child: Text(
                                                                      "Completed",
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                          (!taskIsCompleted(
                                                                      value:
                                                                          index)) ||
                                                                  ((widget.task.stepper!
                                                                              .length -
                                                                          1) !=
                                                                      index) ||
                                                                  !widget
                                                                      .isAccess
                                                              ? Container()
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    endProject();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .all(5),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      color: Colors
                                                                              .grey[
                                                                          900],
                                                                      border: Border
                                                                          .all(),
                                                                    ),
                                                                    child: Text(
                                                                      "End Project",
                                                                      style: GoogleFonts
                                                                          .lato(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  !widget.task.endProject
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: CircleAvatar(
                                                radius: 17,
                                                backgroundColor:
                                                    colorData[index],
                                                child: Text(
                                                  (index + 2).toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                "End",
                                                style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                ],
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
