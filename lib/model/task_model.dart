import 'dart:convert';

import 'package:task_master/components/project-detail/screens/stepper_dailog.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TaskModel {
  final String id;
  final String projectId;
  final List<AssignedUserModel> assignedUser;
  final String color;
  final String taskGroup;
  final String task;
  final String startDate;
  final String endDate;
  final String status;
  final bool isActive;
  TaskModel({
    required this.projectId,
    required this.id,
    required this.assignedUser,
    required this.color,
    required this.taskGroup,
    required this.task,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'projectId': projectId,
      'assignedUser': assignedUser.map((x) => x.toMap()).toList(),
      'color': color,
      'taskGroup': taskGroup,
      'task': task,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'isActive': isActive,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['_id'] ?? '',
      projectId: map['projectId'] ?? '',
      assignedUser: List<AssignedUserModel>.from(
        (map['assignedUser'] ?? [0]).map<AssignedUserModel>(
          (x) => AssignedUserModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      color: map['color'] ?? '',
      taskGroup: map['taskGroup'] ?? '',
      task: map['task'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      status: map['status'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
