import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woojr_todo/local_data.dart';
import 'package:woojr_todo/task.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final LocalData localData;

  TodoBloc({required this.localData}) : super(TodoEmptyState()) {
    on<TodoAddTaskEvent>(_todoAddTask);
    on<TodoUpdateTaskEvent>(_todoUpdateTask);
    on<TodoMarkTaskEvent>(_todoMarkTask);
    on<TodoRemoveTaskEvent>(_todoRemoveTask);
    on<TodoAddTempTaskEvent>(_todoAddTempTask);
    on<TodoInitLoadDataEvent>(_todoInitLoadData);
  }

  _todoInitLoadData(TodoInitLoadDataEvent event, Emitter<TodoState> emit) async {
    List<Task> todoList = await localData.loadLocalData();
    emit(TodoListState(taskList: todoList));
  }

  _todoAddTask(TodoAddTaskEvent event, Emitter<TodoState> emit) {
    final state = this.state;
    late final List<Task> taskList;
    if (state is TodoEmptyState) {
      taskList = <Task>[event.task];
    } else if (state is TodoListState) {
      taskList = List.from(state.taskList)..add(event.task);
    }

    localData.saveLocalData(todoList: taskList);
    emit(TodoListState(taskList: taskList));

  }

  _todoUpdateTask(TodoUpdateTaskEvent event, Emitter<TodoState> emit) async {
    try {
      final state = this.state;
      if (state is TodoListState) {
        List<Task> newTaskList = List.from(state.taskList);

        int taskIndex = state.taskList.indexWhere((task) => task.taskID == event.taskID);
        newTaskList[taskIndex] = event.task;
        localData.saveLocalData(todoList: newTaskList);
        emit(TodoLoadingState());
        emit(TodoListState(taskList: newTaskList));
      }
    } on RangeError {
      log("Invalid Task ID: Could not update task name");
      //TODO: Show error message snack bar
      emit(TodoErrorState());
      List<Task> taskList = await localData.loadLocalData();
      emit(TodoListState(taskList: taskList));
    }
  }

  _todoAddTempTask(TodoAddTempTaskEvent event, Emitter<TodoState> emit) async {
    try {
      final state = this.state;
      if (state is TodoEmptyState) {
        emit(TodoListState(taskList: <Task>[Task(taskName: "Pretend To Clean")]));
      } else if (state is TodoListState) {
        List<Task> taskList = List.from(state.taskList)..add(Task(taskName: "Early Dinner"));
        emit(TodoListState(taskList: taskList));
        await localData.saveLocalData(todoList: taskList);
      }
    } catch (e) {}
  }

  _todoMarkTask(TodoMarkTaskEvent event, Emitter<TodoState> emit) async {
    try {
      final state = this.state;
      if (state is TodoListState) {
        int markedTaskIndex = state.taskList.indexWhere((task) => task.taskID == event.task.taskID);
        // List<Task> newTaskList = state.taskList;
        List<Task> newTaskList = List.from(state.taskList);
        newTaskList[markedTaskIndex] =
            newTaskList[markedTaskIndex].copyWith(isComplete: !event.task.isComplete);
        localData.saveLocalData(todoList: newTaskList);
        // emit(TodoLoadingState());
        emit(TodoListState(taskList: newTaskList));
      }
    } on RangeError {
      emit(TodoErrorState());
      //TODO: Show error message (Failed to complete task due to invalid ID) in snackbar
      List<Task> taskList = await localData.loadLocalData();
      emit(TodoListState(taskList: taskList));
    }
  }

  _todoRemoveTask(TodoRemoveTaskEvent event, Emitter<TodoState> emit) {
    final state = this.state;

    if (state is TodoListState) {
      emit(TodoLoadingState());
      List<Task> todoList = List.from(state.taskList)
        ..removeWhere((task) => task.taskID == event.task.taskID);
      emit(TodoListState(taskList: todoList));
      localData.saveLocalData(todoList: todoList);
    }
  }
}
