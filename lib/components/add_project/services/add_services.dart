import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/components/project-detail/screens/stepper_dailog.dart';
import 'package:task_master/global.dart';
import 'package:task_master/model/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:task_master/model/task_model.dart';
import 'package:task_master/utils/error_handling.dart';
import 'package:task_master/utils/show_snackbar.dart';
import 'package:task_master/utils/storage_methods.dart';

class AddService {
  Future<void> craeteTask({
    required BuildContext context,
    required String taskGroup,
    required String projectName,
    required String startDate,
    required String endDate,
    required String color,
    required WidgetRef ref,
    required String status,
    required dynamic logo,
  }) async {
    var userData = ref.read(userProvider);
    try {
      String? photoUrl;
      if (logo != '') {
        photoUrl = await StorageMethod()
            .uploadImageToStorage("posts", logo!, true, ref);
      }
      ProjectModel project = ProjectModel(
        adminId: '',
        id: '',
        uniqueId: '',
        color: color,
        taskGroup: taskGroup,
        projectName: projectName,
        status: status,
        startDate: startDate,
        endDate: endDate,
        team: [],
        logo: photoUrl!,
        endProject: false,
        stepper: [],
      );
      http.Response res = await http.post(
        Uri.parse('$url/api/create-post'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
        body: project.toJson(),
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
            showSnackbar(context, 'Project Created Successfully!');
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> dailyTask({
    required BuildContext context,
    required String taskGroup,
    required String projectName,
    required String startDate,
    required String endDate,
    required String color,
    required WidgetRef ref,
    required String status,
  }) async {
    var userData = ref.read(userProvider);
    try {
      TaskModel taskModel = TaskModel(
        projectId: '',
        id: '',
        assignedUser: [
          AssignedUserModel(userId: userData.id, isCompleted: false),
        ],
        color: color,
        taskGroup: taskGroup,
        task: projectName,
        status: status,
        startDate: startDate,
        endDate: endDate,
        isActive: false,
      );
      http.Response res = await http.post(
        Uri.parse('$url/api/daily-task'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': userData.token!,
        },
        body: taskModel.toJson(),
      );

      if (context.mounted) {
        httpErrorHanding(
          res: res,
          context: context,
          onSuccess: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BottomBar(
                      data: 1,
                    )));
            showSnackbar(context, 'Task Added Successfully!');
          },
        );
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
