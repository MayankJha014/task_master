import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskContainer extends StatelessWidget {
  final IconData taskIcon;
  final String taskGroup;
  final Color taskcolor;
  final Color taskShade;
  final String taskNum;
  final double progress;
  const TaskContainer({
    super.key,
    required this.taskIcon,
    required this.taskGroup,
    required this.taskNum,
    required this.progress,
    required this.taskcolor,
    required this.taskShade,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: taskShade,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: taskShade,
                ),
                child: Icon(
                  taskIcon,
                  color: taskcolor,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10),
                    child: Text(
                      taskGroup,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      taskNum,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CircularPercentIndicator(
                radius: 22.0,
                lineWidth: 4.50,
                percent: progress,
                center: Text(
                  "${progress * 100}%",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: taskcolor,
                backgroundColor: const Color.fromARGB(255, 252, 228, 236),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
