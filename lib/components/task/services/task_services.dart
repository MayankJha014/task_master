import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/task_model.dart';
import 'package:task_master/utils/error_handling.dart';
import 'package:task_master/utils/show_snackbar.dart';

class TaskService {
  Future<List<TaskModel>> fetchAllTask(
      BuildContext context, WidgetRef ref) async {
    var userData = ref.read(userProvider);
    List<TaskModel> taskList = [];
    try {
      http.Response res =
          await http.get(Uri.parse("$url/api/get-task"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': userData.token!,
      });

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              taskList.add(TaskModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ));
            }
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return taskList;
  }

  Future<void> endTask({
    required BuildContext context,
    required String id,
    required String endTask,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    try {
      http.Response res = await http.post(
        Uri.parse('$url/api/end-task/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
        body: jsonEncode({
          'endTask': endTask,
        }),
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            showSnackbar(context, 'Task Ended Successfully');
            //   flutterLocalNotificationsPlugin.show(
            //       0,
            //       "Task Completed SucessFully",
            //       "Congratulation !!!",
            //       NotificationDetails(
            //           android: AndroidNotificationDetails(
            //               channel.id, channel.name, channel.description)));
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
