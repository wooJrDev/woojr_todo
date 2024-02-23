part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

final class TodoEmptyState extends TodoState {}

final class TodoErrorState extends TodoState {}

final class TodoListState extends TodoState {
  final List<Task> taskList;

  const TodoListState({required this.taskList});

  @override
  List<Object> get props => [taskList];
}
