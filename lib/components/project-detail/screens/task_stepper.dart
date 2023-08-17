import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskStepper extends StatelessWidget {
  final int serial;
  final String title;
  final String desc;
  const TaskStepper(
      {super.key,
      required this.title,
      required this.desc,
      required this.serial});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green,
                child: Text(
                  serial.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 19,
                ),
                width: 2,
                height: 150,
                color: Colors.black,
              ),
              ChatBubble(
                clipper: ChatBubbleClipper10(
                  type: BubbleType.receiverBubble,
                ),
                margin: const EdgeInsets.only(bottom: 70),
                backGroundColor: Colors.purple[200],
                child: Container(
                  width: size.width * 0.65,
                  padding: const EdgeInsets.all(10.0),
                  child: Text(desc),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
