import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StepperModel {
  final String taskId;
  final String label;
  final String color;
  final bool isActive;
  StepperModel({
    required this.taskId,
    required this.label,
    required this.color,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'label': label,
      'color': color,
      'isActive': isActive,
    };
  }

  factory StepperModel.fromMap(Map<String, dynamic> map) {
    return StepperModel(
      taskId: map['taskId'] ?? '',
      label: map['label'] ?? '',
      color: map['color'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory StepperModel.fromJson(String source) =>
      StepperModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
