import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/screens/auth_screen.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/user.dart' as UserModel;
import 'package:task_master/providers/user.dart';
import 'package:task_master/utils/error_handling.dart';
import 'package:task_master/utils/show_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel.User>(
  (ref) => UserNotifier(),
);
final authLoading = StateProvider<bool>((ref) => false);

class AuthService {
  void signWithGoogle(
    BuildContext context,
    WidgetRef? ref,
  ) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      String? deviceToken = await FirebaseMessaging.instance.getToken();

      UserModel.User user = UserModel.User(
        id: '',
        uniqueId: '',
        displayName: googleSignInAccount!.displayName!.toString(),
        email: googleSignInAccount.email,
        mobile: 0,
        profilePicture: googleSignInAccount.photoUrl != ''
            ? googleSignInAccount.photoUrl
            : profilePic,
        followers: [],
        following: [],
        token: '',
        deviceToken: deviceToken!,
        createdAt: '',
      );

      http.Response res = await http.post(
        Uri.parse('$url/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'x-access-token', jsonDecode(res.body)['token']);
            ref!.read(userProvider.notifier).updateUser(res.body);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BottomBar(data: 0),
              ),
            );
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void signWithGitHub({
    required BuildContext context,
  }) async {
    try {
      const String url =
          "https://github.com/login/oauth/authorize?client_id=$clientID&scope=user:email";

      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw "Could not launch $url";
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> getUserData(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      var userData = ref.read(userProvider);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-access-token');

      ref.read(authLoading.notifier).update((state) => true);
      if (token == null) {
        prefs.setString('x-access-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$url/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$url/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-access-token': token
          },
        );
        ref.read(userProvider.notifier).updateUser(userRes.body);

        ref.read(authLoading.notifier).update((state) => false);
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-access-token', '');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AuthScreen()));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
