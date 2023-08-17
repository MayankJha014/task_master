// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/components/task/services/task_services.dart';
import 'package:task_master/components/task/widgets/daily_task_card.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/task_model.dart';

class TodayTask extends ConsumerStatefulWidget {
  int activeChips;
  TodayTask({
    super.key,
    required this.activeChips,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodayTaskState();
}

class _TodayTaskState extends ConsumerState<TodayTask> {
  List<TaskModel>? taskData;

  void fetchAllTask() async {
    taskData = await TaskService().fetchAllTask(context, ref);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAllTask();
  }

  List chips = [
    'All',
    'OnGoing',
    'Completed',
  ];

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var userData = ref.watch(userProvider);
    DateTime selecDate =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(selectedDate));
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
        child: taskData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      child: DatePicker(
                        DateTime.parse(userData.createdAt),
                        height: 100,
                        width: 80,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: buttonColor,
                        selectedTextColor: Colors.white,
                        deactivatedColor: Colors.white,
                        dateTextStyle: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: Colors
                        ),
                        monthTextStyle: GoogleFonts.lato(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          // color: Colors
                        ),
                        dayTextStyle: GoogleFonts.lato(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          // color: Colors
                        ),
                        onDateChange: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ListView.builder(
                        itemCount: chips.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.activeChips = 0;
                                widget.activeChips = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                                top: 25,
                                left: 10,
                                bottom: 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.activeChips == index
                                      ? buttonColor
                                      : const Color.fromRGBO(237, 232, 255, 1),
                                ),
                                child: Text(
                                  chips[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: widget.activeChips == index
                                        ? Colors.white
                                        : Colors.indigo[800],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.6,
                      child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: taskData!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (selecDate.isAfter(DateTime.parse(
                                            taskData![index].startDate)) &&
                                        selecDate.isBefore(DateTime.parse(
                                            taskData![index].endDate)) ||
                                    selecDate.isAtSameMomentAs(DateTime.parse(
                                        taskData![index].endDate)) ||
                                    selecDate.isAtSameMomentAs(DateTime.parse(
                                        taskData![index].startDate)))
                                ? (taskData![index].status ==
                                        chips[widget.activeChips])
                                    ? DailyTaskCard(
                                        task: taskData![index],
                                        chips: chips[widget.activeChips],
                                      )
                                    : (taskData![index].taskGroup == 'Daily')
                                        ? DailyTaskCard(
                                            task: taskData![index],
                                            chips: chips[widget.activeChips],
                                          )
                                        : Container()
                                : Container();
                          }),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) {
        return const SizedBox(
          height: 500,
          width: 500,
          child: Text('hi'),
        );
      },
      onClosing: () {},
    );
  }
}
