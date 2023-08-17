import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/components/project-detail/screens/stepper_dailog.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/project_model.dart';
import 'package:task_master/model/task_model.dart';
import 'package:task_master/model/user.dart';
import 'package:task_master/utils/error_handling.dart';
import 'package:task_master/utils/notifcation_manager.dart';
import 'package:task_master/utils/show_snackbar.dart';
import 'package:http/http.dart' as http;

class ProjectService {
  Future<List<User>> fetchSearchFriends({
    required BuildContext context,
    required String displayName,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    List<User> friendsList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/add-friend/$displayName'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
      );

      if (context.mounted) {
        httpErrorHanding(
            res: res,
            context: context,
            onSuccess: () {
              for (int i = 0; i < jsonDecode(res.body).length; i++) {
                friendsList.add(
                  User.fromJson(
                    jsonEncode(
                      jsonDecode(res.body)[i],
                    ),
                  ),
                );
              }
            });
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return friendsList;
  }

  Future<List<TaskModel>> fetchTaskOfStepper({
    required BuildContext context,
    required String projectId,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    List<TaskModel> taskList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/get-stepper-task/$projectId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
      );

      if (context.mounted) {
        httpErrorHanding(
            res: res,
            context: context,
            onSuccess: () {
              for (int i = 0; i < jsonDecode(res.body).length; i++) {
                taskList.add(
                  TaskModel.fromJson(
                    jsonEncode(
                      jsonDecode(res.body)[i],
                    ),
                  ),
                );
              }
            });
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return taskList;
  }

  Future<void> dailyTask({
    required BuildContext context,
    required String taskGroup,
    required String projectId,
    required String task,
    required String label,
    required String startDate,
    required String endDate,
    required String color,
    required List<AssignedUserModel> assignedUser,
    required WidgetRef ref,
    required String status,
  }) async {
    var userData = ref.read(userProvider);
    try {
      http.Response res = await http.post(
        Uri.parse('$url/api/add-task/stepper/$projectId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
        body: jsonEncode({
          'projectId': projectId,
          'assignedUser': assignedUser,
          "color": color,
          "label": label,
          "isActive": false,
          "task": task,
          "status": status,
          "startDate": startDate,
          "endDate": endDate,
          "taskGroup": taskGroup,
          'taskId': ''
        }),
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BottomBar(
                      data: 0,
                    )));
            NotificationManager().simpleNotificationShow(
                detail: '$task created sucessfully',
                heading: 'Task Master',
                hashCode: 0);
            showSnackbar(context, 'Task Added Successfully!');
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> addFriends({
    required BuildContext context,
    required String id,
    required String userId,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    try {
      http.Response res = await http.post(
        Uri.parse('$url/api/add-friend/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
          'Authorization':
              "key=AAAAwj-x4S8:APA91bH_6X6OXCHvCtM_RD2VHKGVGCjCg5wyu1XNnt85nVGCXl86ipATMLerHM5sZ8ae3xG6AmFDNXYkyvDzje1LKtBUI31y4qtjbuOezFEIsW4pwlARt7NmVp81lHKzOXveen5BeCRz"
        },
        body: jsonEncode({
          'uid': userId,
        }),
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            showSnackbar(context, 'Friends Added');
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> endProject({
    required BuildContext context,
    required String id,
    required bool endProject,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    try {
      http.Response res = await http.post(
        Uri.parse('$url/api/end-project/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
        body: jsonEncode({
          'endProject': endProject,
        }),
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            Navigator.pop(context);
            NotificationManager().simpleNotificationShow(
                detail: 'Task completed successfully. Congratulation',
                heading: 'Task Master',
                hashCode: 0);

            showSnackbar(context, 'Project Ended Successfully');
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> taskCompleted({
    required BuildContext context,
    required String projectId,
    required bool projectCompletion,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    try {
      http.Response res = await http.post(
        Uri.parse('$url/api/activate-task/$projectId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
        body: jsonEncode({
          'activateTask': projectCompletion,
          'userId': userData.id,
        }),
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () async {
            showSnackbar(context, 'Task Completed');
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<List<User>> getFriends({
    required BuildContext context,
    required String id,
    required WidgetRef ref,
  }) async {
    var userData = ref.read(userProvider);
    List<User> friendsList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/api/get-friend/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              friendsList.add(
                User.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return friendsList;
  }

  Future<List<ProjectModel>> fetchAllProject(
      BuildContext context, WidgetRef ref) async {
    var userData = ref.read(userProvider);
    List<ProjectModel> projectList = [];
    try {
      http.Response res =
          await http.get(Uri.parse("$url/api/get-project"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': userData.token!,
      });

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              projectList.add(ProjectModel.fromJson(
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
    return projectList;
  }

  Future<List<ProjectModel>> fetchOtherProject(
      BuildContext context, WidgetRef ref) async {
    var userData = ref.read(userProvider);
    List<ProjectModel> projectList = [];
    try {
      http.Response res =
          await http.get(Uri.parse("$url/api/get-project-other"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': userData.token!,
      });

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              projectList.add(ProjectModel.fromJson(
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
    return projectList;
  }
}
