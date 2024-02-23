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
    // LocalData.loadLocalData();
  }

  _todoInitLoadData(TodoInitLoadDataEvent event, Emitter<TodoState> emit) async {
    List<Task> todoList = await localData.loadLocalData();
    if (todoList.isNotEmpty) {
      emit(TodoListState(taskList: todoList));
    }
  }

  _todoAddTask(TodoAddTaskEvent event, Emitter<TodoState> emit) {
    final state = this.state;
    if (state is TodoEmptyState) {
      //TODO: see if you can make this cleaner (don't duplicate savelocaldata)
      localData.saveLocalData(todoList: <Task>[event.task]);
      emit(TodoListState(taskList: <Task>[event.task]));
    } else if (state is TodoListState) {
      localData.saveLocalData(todoList: List.from(state.taskList)..add(event.task));
      emit(TodoListState(taskList: List.from(state.taskList)..add(event.task)));
    }
  }

  _todoUpdateTask(TodoUpdateTaskEvent event, Emitter<TodoState> emit) {
    final state = this.state;
    if (state is TodoListState) {
      List<Task> newTaskList = state.taskList;
      int taskIndex = state.taskList.indexWhere((task) => task.taskID == event.taskID);
      newTaskList[taskIndex] = event.task;
      emit(TodoListState(taskList: newTaskList));
      localData.saveLocalData(todoList: newTaskList);
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
    } catch (e) {
      print(e);
    }
  }

  _todoMarkTask(TodoMarkTaskEvent event, Emitter<TodoState> emit) {
    final state = this.state;
    if (state is TodoListState) {
      // Task markedTask = state.taskList.singleWhere((task) => task.taskID == event.task.taskID);
      // markedTask.isComplete = !markedTask.isComplete;
      int markedTaskIndex = state.taskList.indexWhere((task) => task.taskID == event.task.taskID);
      List<Task> newTaskList = state.taskList;
      newTaskList[markedTaskIndex] =
          newTaskList[markedTaskIndex].copyWith(isComplete: !event.task.isComplete);
      localData.saveLocalData(todoList: newTaskList);
      emit(TodoEmptyState());
      emit(TodoListState(taskList: newTaskList));
      // emit(TodoEmptyState());
      // emit(TodoListState(taskList: newTaskList));
    }
  }

  _todoRemoveTask(TodoRemoveTaskEvent event, Emitter<TodoState> emit) {
    final state = this.state;

    if (state is TodoListState) {
      emit(TodoEmptyState());
      List<Task> todoList = List.from(state.taskList)
        ..removeWhere((task) => task.taskID == event.task.taskID);
      emit(TodoListState(taskList: todoList));
      localData.saveLocalData(todoList: todoList);
    }
  }
}
