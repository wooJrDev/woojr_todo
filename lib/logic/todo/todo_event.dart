part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

final class TodoAddTaskEvent extends TodoEvent {
  final Task task;

  const TodoAddTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

final class TodoUpdateTaskEvent extends TodoEvent {
  final String taskID;
  final Task task;

  const TodoUpdateTaskEvent({required this.task, required this.taskID});

  @override
  List<Object> get props => [task, taskID];
}

final class TodoMarkTaskEvent extends TodoEvent {
  final Task task;

  const TodoMarkTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

final class TodoRemoveTaskEvent extends TodoEvent {
  final Task task;

  const TodoRemoveTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

final class TodoInitLoadDataEvent extends TodoEvent {}

final class TodoAddTempTaskEvent extends TodoEvent {}
