import 'dart:convert';

import 'package:flutter/material.dart';

class Task {
  final String taskID;
  String taskName;
  bool isComplete;

  Task({required this.taskName, this.isComplete = false}) : taskID = _genTaskID();

  static String _genTaskID() {
    return UniqueKey().toString();
  }

  @override
  String toString() => 'Task(taskID: $taskID, taskName: $taskName, isComplete: $isComplete)';

  Task copyWith({
    String? taskName,
    bool? isComplete,
  }) {
    return Task(
      taskName: taskName ?? this.taskName,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskID': taskID,
      'taskName': taskName,
      'isComplete': isComplete,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'] ?? '',
      isComplete: map['isComplete'] ?? false,
    );
  }

  // // String toJson() => json.encode(toMap());
  static String listToJson({required List<Task> taskList}) =>
      jsonEncode({"taskList": taskList.map((task) => task.toMap()).toList()});

  static List<Task> listFromJson({required String jsonData}) {
    List<dynamic> rawList = jsonDecode(jsonData)['taskList'];
    List<Task> todoList = rawList.map((task) => Task.fromMap(task)).toList();
    return todoList;
  }
  // factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.taskID == taskID &&
        other.taskName == taskName &&
        other.isComplete == isComplete;
  }

  @override
  int get hashCode => taskID.hashCode ^ taskName.hashCode ^ isComplete.hashCode;
}
