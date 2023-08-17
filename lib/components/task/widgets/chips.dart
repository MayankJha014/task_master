// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:task_master/global.dart';

class ChipsTask extends StatefulWidget {
  int activeChips;
  ChipsTask({
    Key? key,
    required this.activeChips,
  }) : super(key: key);

  @override
  State<ChipsTask> createState() => _ChipsTaskState();
}

class _ChipsTaskState extends State<ChipsTask> {
  List chips = [
    'All',
    'To-Do List',
    'In Progress',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
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
    );
  }
}
