// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProjectCard extends StatefulWidget {
  final String projectName;
  final Color cardColor;
  final Color progressIndicator;
  final double progress;
  final int deadline;
  final String person;
  final String logo;

  const ProjectCard({
    Key? key,
    required this.projectName,
    required this.cardColor,
    required this.progress,
    required this.person,
    required this.deadline,
    required this.progressIndicator,
    required this.logo,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.65,
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
        color: widget.cardColor,
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15),
      //   color: widget.cardColor,
      // ),
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
                              widget.person,
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
                  // const Padding(
                  //   padding: EdgeInsets.all(5.0),
                  //   child: CircleAvatar(
                  //     radius: 16,
                  //     backgroundColor: Colors.white,
                  //     child: Icon(
                  //       Icons.edit,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  widget.projectName,
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
                    percent: widget.progress,
                    backgroundColor: Colors.blueGrey[50],
                    center: Text(
                      "${widget.progress * 100}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    barRadius: const Radius.circular(16),
                    progressColor: widget.progressIndicator,
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
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 16,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image: NetworkImage(widget.logo),
                                width: 20,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              "${widget.deadline} days",
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
