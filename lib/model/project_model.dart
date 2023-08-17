import 'dart:convert';

import 'package:task_master/model/stepper_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProjectModel {
  final String id;
  final String adminId;
  final String uniqueId;

  final String color;
  final String taskGroup;
  final String projectName;
  final String startDate;
  final String endDate;
  final String logo;
  final List<String>? team;
  final List<StepperModel>? stepper;
  final bool endProject;
  final String status;
  ProjectModel({
    required this.id,
    required this.adminId,
    required this.uniqueId,
    required this.color,
    required this.taskGroup,
    required this.projectName,
    required this.startDate,
    required this.endDate,
    required this.logo,
    required this.team,
    required this.stepper,
    required this.endProject,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'adminId': adminId,
      'uniqueId': uniqueId,
      'color': color,
      'taskGroup': taskGroup,
      'projectName': projectName,
      'startDate': startDate,
      'endDate': endDate,
      'logo': logo,
      'team': team,
      'stepper': stepper?.map((x) => x.toMap()).toList(),
      'endProject': endProject,
      'status': status,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['_id'] ?? '',
      adminId: map['adminId'] ?? '',
      uniqueId: map['uniqueId'] ?? '',
      color: map['color'] ?? '',
      taskGroup: map['taskGroup'] ?? '',
      projectName: map['projectName'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      logo: map['logo'] ?? '',
      team:
          map['team'] != null ? List<String>.from((map['team'] ?? [''])) : [''],
      stepper: map['stepper'] != null
          ? List<StepperModel>.from(
              (map['stepper'] ?? [0]).map<StepperModel?>(
                (x) => StepperModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      endProject: map['endProject'] as bool,
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
