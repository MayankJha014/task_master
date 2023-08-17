import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProjectBox extends StatelessWidget {
  final String projectName;
  final Color cardColor;
  final Color progressIndicator;
  final double progress;
  final int deadline;
  final int person;
  const ProjectBox(
      {super.key,
      required this.projectName,
      required this.cardColor,
      required this.progressIndicator,
      required this.progress,
      required this.deadline,
      required this.person});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.90,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage(
            'assets/18.png',
          ),
          fit: BoxFit.fill,
          opacity: 0.50,
        ),
        color: cardColor,
      ),
      child: Stack(
        children: [
          Positioned(top: -75, right: 0, child: Image.asset('assets/rect.png')),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(255, 253, 253, 0.4),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "$person",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  projectName,
                  maxLines: 2,
                  style: GoogleFonts.lato(
                    fontSize: 40,
                    color: Colors.white,
                    wordSpacing: 2,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LinearPercentIndicator(
                    width: size.width * 0.35,
                    animation: true,
                    lineHeight: 12.0,
                    animationDuration: 2000,
                    curve: Curves.easeInOut,
                    percent: progress,
                    backgroundColor: Colors.blueGrey[50],
                    center: Text(
                      "${progress * 100}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    barRadius: const Radius.circular(16),
                    progressColor: progressIndicator,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(255, 253, 253, 0.4),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 16,
                            child: Image(
                              image: AssetImage('assets/google.png'),
                              width: 20,
                              height: 25,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "$deadline days",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
