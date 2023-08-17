// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:task_master/components/add_project/screens/add_project.dart';
import 'package:task_master/components/home/screen/home.dart';
import 'package:task_master/components/profile/profile.dart';
import 'package:task_master/components/projects/screen/project_screen.dart';
import 'package:task_master/components/task/screens/today_task.dart';
import 'package:task_master/global.dart';

class BottomBar extends StatefulWidget {
  int data;
  BottomBar({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void updatePage(int page) {
    setState(() {
      widget.data = 0;
      widget.data = page;
    });
  }

  List<Widget> pages = [
    const HomeScreen(),
    TodayTask(
      activeChips: 0,
    ),
    const ProjectList(),
    const Profile(),
    // const AddProject(),
  ];

  List<IconData> iconData = [
    Icons.home,
    Icons.calendar_month_rounded,
    Icons.description_rounded,
    Icons.people,
  ];

  @override
  Widget build(BuildContext context) {
    // _page = widget.data;
    return Scaffold(
      body: pages[widget.data],
      floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddProject(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconData, //list of icons
        activeIndex: widget.data,
        activeColor: const Color.fromARGB(255, 113, 4, 255),
        inactiveColor: const Color.fromARGB(255, 147, 48, 172),
        splashColor: buttonColor,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: updatePage,
        shadow: const Shadow(
            color: Color.fromARGB(255, 121, 29, 179),
            blurRadius: 15,
            offset: Offset(0, 5)),
        backgroundColor: const Color.fromRGBO(238, 233, 255, 1),
      ),
    );
  }
}
