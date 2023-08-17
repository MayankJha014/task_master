// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/components/home/widget/project_card.dart';
import 'package:task_master/components/home/widget/task_container.dart';
import 'package:task_master/components/project-detail/screens/project_detail_screen.dart';
import 'package:task_master/components/project-detail/services/project_service.dart';
import 'package:task_master/components/task/services/task_services.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/project_model.dart';
import 'package:task_master/model/task_model.dart';
import 'package:task_master/utils/notifcation_manager.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<ProjectModel> projectData = [];
  List<ProjectModel> otherProjectData = [];

  Future fetchAllProject() async {
    projectData = await ProjectService().fetchAllProject(context, ref);
    setState(() {});
  }

  void fetchOtherTask() async {
    otherProjectData = await ProjectService().fetchOtherProject(context, ref);
    setState(() {});
  }

  List<TaskModel> taskData = [];

  void fetchAllTask() async {
    taskData = await TaskService().fetchAllTask(context, ref);
    setState(() {});
  }

  @override
  void initState() {
    FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    AwesomeNotifications().isNotificationAllowed().then(
      (value) {
        if (!value) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    fetchAllTask();
    fetchAllProject();
    fetchOtherTask();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: size.height * 0.09,
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/scaffold.png',
          ),
          fit: BoxFit.cover,
        ),
        // backgroundColor: const Color.fromARGB(190, 236, 239, 241),
        elevation: 0.5,

        shadowColor: const Color.fromARGB(255, 121, 29, 179),
        leading: Center(
          child: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              user.profilePicture!,
            ),
            // fit: BoxFit.fill,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello!",
                  style: TextStyle(
                    color: Colors.black,
                    height: 2,
                    fontSize: 16,
                  ),
                ),
                Text(
                  user.displayName,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 20,
                      letterSpacing: 0.9,
                      height: 1.2,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  // showNotification();
                  NotificationManager().simpleNotificationShow(
                      detail: 'This page is under development',
                      heading: 'Developer',
                      hashCode: 0);
                },
                child: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          // color: Color.fromARGB(192, 236, 239, 241),
          image: DecorationImage(
              image: AssetImage(
                'assets/scaffold.png',
              ),
              fit: BoxFit.cover),
        ),
        child: projectData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Your Projects",
                            style: GoogleFonts.openSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: shadowColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 9),
                              child: Text(
                                "${projectData.length + otherProjectData.length}",
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            height: size.height * 0.26,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: projectData.length,
                                itemBuilder: (context, int index) {
                                  return projectData[index].endProject
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProjectDetailScreen(
                                                    task: projectData[index],
                                                    isAccess: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ProjectCard(
                                                projectName: projectData[index]
                                                    .projectName,
                                                cardColor: colorData[int.parse(
                                                    projectData[index].color)],
                                                progress: 0.5,
                                                deadline: DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(projectData[index].endDate)))
                                                    .difference(DateTime.parse(
                                                        DateFormat('yyyy-MM-dd').format(
                                                            DateTime.now())))
                                                    .inDays
                                                    .toInt(),
                                                person: projectData[index]
                                                    .team!
                                                    .length
                                                    .toString(),
                                                progressIndicator:
                                                    const Color.fromARGB(
                                                        255, 149, 117, 205),
                                                logo: projectData[index].logo),
                                          ),
                                        );
                                }),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: otherProjectData.isEmpty
                                    ? 0
                                    : otherProjectData.length,
                                itemBuilder: (context, int index) {
                                  return otherProjectData[index].endProject
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProjectDetailScreen(
                                                    task:
                                                        otherProjectData[index],
                                                    isAccess: false,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ProjectCard(
                                                projectName:
                                                    otherProjectData[index]
                                                        .projectName,
                                                cardColor: colorData[int.parse(
                                                    otherProjectData[index]
                                                        .color)],
                                                progress: 0.5,
                                                deadline: DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(otherProjectData[index].endDate)))
                                                    .difference(DateTime.parse(
                                                        DateFormat('yyyy-MM-dd').format(
                                                            DateTime.now())))
                                                    .inDays
                                                    .toInt(),
                                                person: otherProjectData[index]
                                                    .team!
                                                    .length
                                                    .toString(),
                                                progressIndicator:
                                                    const Color.fromARGB(255, 149, 117, 205),
                                                logo: otherProjectData[index].logo),
                                          ),
                                        );
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Task Group",
                            style: GoogleFonts.openSans(
                              fontSize: 17,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: shadowColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 9),
                              child: Text(
                                "3",
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BottomBar(data: 1),
                          ),
                        );
                      },
                      child: TaskContainer(
                        taskIcon: Icons.business_center_rounded,
                        taskGroup: 'Task Group',
                        taskNum: '${taskData.length} Task',
                        progress: 0.8,
                        taskcolor: (Colors.pink[400])!,
                        taskShade: (Colors.pink[100])!,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BottomBar(data: 2),
                          ),
                        );
                      },
                      child: TaskContainer(
                        taskIcon: Icons.person,
                        taskGroup: 'Personal Project',
                        taskNum:
                            '${projectData.where((x) => x.taskGroup == "Personal").length + otherProjectData.where((x) => x.taskGroup == "Personal").length} Project',
                        progress: 0.2,
                        taskcolor: (Colors.purple[400])!,
                        taskShade: (Colors.purple[100])!,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BottomBar(data: 2),
                          ),
                        );
                      },
                      child: TaskContainer(
                        taskIcon: Icons.menu_book_rounded,
                        taskGroup: 'Work Project',
                        taskNum:
                            '${projectData.where((x) => x.taskGroup == "Work").length + otherProjectData.where((x) => x.taskGroup == "Personal").length} Task',
                        progress: 0.2,
                        taskcolor: (Colors.deepOrange[400])!,
                        taskShade: (Colors.orange[200])!,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
