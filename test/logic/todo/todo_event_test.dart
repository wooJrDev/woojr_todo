import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:woojr_todo/local_data.dart';
import 'package:woojr_todo/logic/todo/todo_bloc.dart';
import 'package:woojr_todo/task.dart';

class MockTodoBloc extends MockBloc<TodoEvent, TodoState> implements TodoBloc {}

class MockLocalData extends Mock implements LocalData {}

class MockTask extends Mock implements Task {}

class MockTodoAddTaskEvent extends Mock implements TodoAddTaskEvent {}

void main() {
  late MockTask mockTask;

  setUp(() {
    mockTask = MockTask();
  });

  group("TodoAddTaskEvent", () {
    late TodoAddTaskEvent sutEvent;
    setUp(() {
      sutEvent = TodoAddTaskEvent(task: mockTask);
    });

    test("Validate TodoAddTaskEvent equality", () {
      expect(sutEvent, equals(TodoAddTaskEvent(task: mockTask)));
    });

    test("Validate TodoAddTaskEvent props", () {
      expect(sutEvent.props, <Object>[mockTask]);
    });
  });

  group("TodoUpdateTaskEvent", () {
    late TodoUpdateTaskEvent sutEvent;
    const String mockID = "001";
    setUp(() {
      sutEvent = TodoUpdateTaskEvent(taskID: mockID, task: mockTask);
    });

    test("Validate TodoUpdateTaskEvent equality", () {
      expect(sutEvent, equals(TodoUpdateTaskEvent(taskID: mockID, task: mockTask)));
    });

    test("Validate TodoUpdateTaskEvent props", () {
      expect(sutEvent.props, <Object>[mockTask, mockID]);
    });
  });

  group("TodoRemoveTaskEvent", () {
    late TodoRemoveTaskEvent sutEvent;
    setUp(() {
      sutEvent = TodoRemoveTaskEvent(task: mockTask);
    });

    test("Validate TodoUpdateTaskEvent equality", () {
      expect(sutEvent, equals(TodoRemoveTaskEvent(task: mockTask)));
    });

    test("Validate TodoUpdateTaskEvent props", () {
      expect(sutEvent.props, <Object>[mockTask]);
    });
  });
}
