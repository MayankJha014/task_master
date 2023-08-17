import 'package:flutter/material.dart';

Color buttonColor = const Color(0xf05f33e1);
Color secondaryColor = const Color.fromRGBO(92, 92, 92, 1);
Color shadowColor = const Color.fromRGBO(238, 233, 255, 1);

// const String url = 'http://3.111.253.22:5000';
const String url = 'http://192.168.1.2:5000';
const String profilePic =
    'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1631&q=80';

const String clientID = '9815c2918556162fbc68';
const String clientSecret = '99e3c26e1769bef058c6da92c4eae05a8264feef';
List colorData = [
  const Color.fromARGB(255, 80, 192, 0),
  const Color.fromARGB(255, 38, 0, 173),
  Colors.deepPurple[400],
  Colors.indigo[400],
  Colors.amber[800],
  Colors.orange[800],
];

Color ColorChosser({required int index}) {
  switch (index) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.blue;
    default:
      return Colors.green;
  }
}
