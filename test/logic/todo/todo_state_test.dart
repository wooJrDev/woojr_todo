import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:woojr_todo/logic/todo/todo_bloc.dart';
import 'package:woojr_todo/task.dart';

class MockTaskList extends Mock implements List<Task> {}

void main() {
  group("TodoListState", () {
    late MockTaskList mockTaskList;
    late TodoListState sut;

    setUp(() {
      mockTaskList = MockTaskList();
      sut = TodoListState(taskList: mockTaskList);
    });
    test("Validate TodoListState equality", () {
      expect(sut, equals(TodoListState(taskList: mockTaskList)));
    });

    test("Validate TodoListState props", () {
      expect(sut.props, <Object>[mockTaskList]);
    });
  });
}
