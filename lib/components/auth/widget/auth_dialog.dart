import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/global.dart';

Future<void> authDailog(BuildContext context, WidgetRef ref) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      var size = MediaQuery.of(context).size;
      final AuthService authService = AuthService();
      return Dialog(
        elevation: 2,
        insetAnimationDuration: const Duration(milliseconds: 200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  children: [
                    Text(
                      "Sign In",
                      style: GoogleFonts.patuaOne(
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        '''Creates a unique emotional story that
describes better than words''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          authService.signWithGoogle(context, ref);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                height: 25,
                                width: 25,
                              ),
                              Text(
                                "Sign with Google",
                                style: GoogleFonts.patuaOne(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                  color: Colors.black,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          authService.signWithGitHub(context: context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/github.png',
                                width: 25,
                                height: 25,
                              ),
                              Text(
                                "Sign with GitHub",
                                style: GoogleFonts.patuaOne(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
