import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/components/profile/privacy_policy.dart';
import 'package:task_master/components/project-detail/services/project_service.dart';
import 'package:task_master/components/task/services/task_services.dart';
import 'package:task_master/model/project_model.dart';
import 'package:task_master/model/task_model.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  List profileData = [
    'Projects',
    'Privacy Policy',
    'Friends',
    'Log-Out',
  ];

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
    // TODO: implement initState
    super.initState();
    fetchAllProject();
    fetchOtherTask();
    fetchAllTask();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.read(userProvider);
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
            const Text(
              "Profile",
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
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(192, 236, 239, 241),
          image: DecorationImage(
              image: AssetImage(
                'assets/scaffold.png',
              ),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: ,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 40,
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(
                      data.profilePicture!,
                    ),
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  data.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                data.uniqueId,
                style: const TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: (Colors.grey[300])!,
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Projects",
                            style: GoogleFonts.aldrich(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${projectData.length + otherProjectData.length}",
                            style: GoogleFonts.aldrich(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tasks",
                            style: GoogleFonts.aldrich(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${taskData.length}",
                            style: GoogleFonts.aldrich(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Accuracy",
                            style: GoogleFonts.aldrich(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "20%",
                            style: GoogleFonts.aldrich(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 15,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: (Colors.grey[400])!,
                        )
                      ]),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 5.0,
                    ),
                    child: Column(
                      children: [
                        // GestureDetector(
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //       vertical: 8.0,
                        //       horizontal: 5.0,
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text(
                        //           "Profile",
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w600,
                        //             color: Colors.grey[800],
                        //           ),
                        //         ),
                        //         const Icon(
                        //           Icons.arrow_right_rounded,
                        //           size: 40,
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_right_rounded,
                                  size: 40,
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            AuthService().logOut(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_right_rounded,
                                  size: 40,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // child: Column(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: const [
                  //         Text(
                  //           'Setting',
                  //         ),
                  //         Icon(
                  //           Icons.arrow_right_rounded,
                  //           size: 50,
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
