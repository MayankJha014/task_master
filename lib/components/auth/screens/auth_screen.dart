import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_master/components/auth/widget/auth_dialog.dart';
import 'package:task_master/global.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
        setState(() {});
      });
  }

  OnTapDown(TapDownDetails details) {
    _animationController?.forward();
  }

  OnTapUp(TapUpDetails details) {
    _animationController?.reverse();
  }

  OnTapCancel() {
    _animationController?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 + _animationController!.value;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Task Management &",
                style: GoogleFonts.patuaOne(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  letterSpacing: 1,
                ),
              ),
              Text(
                "To-Do List",
                style: GoogleFonts.patuaOne(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  letterSpacing: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18.0,
                ),
                child: Text(
                  '''This productive tool is designed to help
you better manage your task
project-wise conveniently!''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: secondaryColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15,
                ),
                child: GestureDetector(
                  onTap: () {
                    authDailog(context, ref);
                  },
                  onTapDown: OnTapDown,
                  onTapCancel: OnTapCancel,
                  onTapUp: OnTapUp,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "",
                          ),
                          Text(
                            "Let's Start",
                            style: GoogleFonts.patuaOne(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                letterSpacing: 1,
                                color: Colors.white),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen>
//     with SingleTickerProviderStateMixin {
//   AnimationController? _animationController;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//       lowerBound: 0.0,
//       upperBound: 0.2,
//     )..addListener(() {
//         setState(() {});
//       });
//   }

//   OnTapDown(TapDownDetails details) {
//     _animationController?.forward();
//   }

//   OnTapUp(TapUpDetails details) {
//     _animationController?.reverse();
//   }

//   OnTapCancel() {
//     _animationController?.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double scale = 1 + _animationController!.value;
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/background.png'),
//           ),
//         ),
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 "Task Management &",
//                 style: GoogleFonts.patuaOne(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 22,
//                   letterSpacing: 1,
//                 ),
//               ),
//               Text(
//                 "To-Do List",
//                 style: GoogleFonts.patuaOne(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 22,
//                   letterSpacing: 1,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 18.0,
//                 ),
//                 child: Text(
//                   '''This productive tool is designed to help
// you better manage your task
// project-wise conveniently!''',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     height: 1.4,
//                     color: secondaryColor,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30.0,
//                   vertical: 15,
//                 ),
//                 child: GestureDetector(
//                   onTap: () {
//                     authDailog(context, ref);
//                   },
//                   onTapDown: OnTapDown,
//                   onTapCancel: OnTapCancel,
//                   onTapUp: OnTapUp,
//                   child: Transform.scale(
//                     scale: scale,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 10,
//                       ),
//                       decoration: BoxDecoration(
//                           color: buttonColor,
//                           boxShadow: const [
//                             BoxShadow(
//                               blurRadius: 20,
//                               spreadRadius: 1,
//                               offset: Offset(10, 12),
//                               color: Color.fromARGB(239, 187, 167, 248),
//                             ),
//                           ],
//                           borderRadius: BorderRadius.circular(10)),
//                       width: double.infinity,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "",
//                           ),
//                           Text(
//                             "Let's Start",
//                             style: GoogleFonts.patuaOne(
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 16,
//                                 letterSpacing: 1,
//                                 color: Colors.white),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(right: 10.0),
//                             child: Icon(
//                               Icons.arrow_forward_ios_rounded,
//                               color: Colors.white,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
