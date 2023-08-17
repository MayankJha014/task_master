import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/home/widget/project_card.dart';
import 'package:task_master/components/project-detail/screens/project_detail_screen.dart';
import 'package:task_master/components/project-detail/services/project_service.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/project_model.dart';

class ProjectList extends ConsumerStatefulWidget {
  const ProjectList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectListState();
}

class _ProjectListState extends ConsumerState<ProjectList> {
  List<ProjectModel> projectData = [];
  List<ProjectModel> otherProjectData = [];

  void fetchAllProject() async {
    projectData = await ProjectService().fetchAllProject(context, ref);
    setState(() {});
  }

  void fetchOtherTask() async {
    otherProjectData = await ProjectService().fetchOtherProject(context, ref);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllProject();
    fetchOtherTask();
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
            const Text(
              "Your Project",
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
          image: DecorationImage(
            image: AssetImage(
              'assets/scaffold.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    // height: size.height * 0.8,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
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
                                      projectName:
                                          projectData[index].projectName,
                                      cardColor: colorData[
                                          int.parse(projectData[index].color)],
                                      progress: 0.5,
                                      deadline: DateTime.parse(DateFormat(
                                                  'yyyy-MM-dd')
                                              .format(DateTime.parse(
                                                  projectData[index].endDate)))
                                          .difference(DateTime.parse(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(DateTime.now())))
                                          .inDays
                                          .toInt(),
                                      person: projectData[index]
                                          .team!
                                          .length
                                          .toString(),
                                      progressIndicator: const Color.fromARGB(
                                          255, 149, 117, 205),
                                      logo: projectData[index].logo,
                                    ),
                                  ),
                                );
                        }),
                  ),
                  SizedBox(
                    // height: 200,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
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
                                            task: otherProjectData[index],
                                            isAccess: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProjectCard(
                                        projectName:
                                            otherProjectData[index].projectName,
                                        cardColor: colorData[int.parse(
                                            otherProjectData[index].color)],
                                        progress: 0.5,
                                        person: otherProjectData[index]
                                            .team!
                                            .length
                                            .toString(),
                                        deadline: DateTime.parse(
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.parse(
                                                        otherProjectData[index]
                                                            .endDate)))
                                            .difference(
                                                DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())))
                                            .inDays,
                                        progressIndicator: const Color.fromARGB(255, 149, 117, 205),
                                        logo: otherProjectData[index].logo),
                                  ),
                                );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
