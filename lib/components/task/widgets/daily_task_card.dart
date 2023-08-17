// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/task/screens/today_task.dart';
import 'package:task_master/components/task/services/task_services.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/task_model.dart';

class DailyTaskCard extends ConsumerStatefulWidget {
  final TaskModel task;
  final String chips;
  const DailyTaskCard({
    super.key,
    required this.task,
    required this.chips,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DailyTaskCardState();
}

class _DailyTaskCardState extends ConsumerState<DailyTaskCard> {
  Future<void> endTask() async {
    await TaskService().endTask(
      context: context,
      id: widget.task.id,
      endTask: "Completed",
      ref: ref,
    );
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BottomBar(data: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.task.status != 'Completed') {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 170,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 28.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            "Selected task is completed",
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              endTask();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 13,
                              ),
                              margin: const EdgeInsets.only(
                                top: 20,
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
                                    "Task Completed",
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
                      ],
                    ),
                  );
                });
          } else {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 170,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 28.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            "Task is already completed",
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TodayTask(activeChips: 0),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 13,
                              ),
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 20,
                                      spreadRadius: 1,
                                      offset: Offset(10, 12),
                                      color: Colors.black38,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Done",
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
                      ],
                    ),
                  );
                });
          }
        },
        child: (widget.chips == 'All')
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorData[int.parse(widget.task.color)],
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: (Colors.grey[500])!,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.task.taskGroup,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.pink[100],
                              ),
                              child: Icon(
                                Icons.business_center_rounded,
                                color: Colors.pink[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: Text(
                          widget.task.task,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.watch_later_rounded,
                                    color: Colors.deepPurple[100],
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '10:00 AM',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.purple[100],
                              ),
                              child: Text(
                                widget.task.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[900],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : (widget.task.status == widget.chips)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF4e5ae8),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: (Colors.grey[500])!,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.task.taskGroup,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.pink[100],
                                  ),
                                  child: Icon(
                                    Icons.business_center_rounded,
                                    color: Colors.pink[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Text(
                              widget.task.task,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.watch_later_rounded,
                                        color: Colors.deepPurple[100],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        '10:00 AM',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple[100],
                                  ),
                                  child: Text(
                                    widget.task.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo[900],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Container());
  }
}
