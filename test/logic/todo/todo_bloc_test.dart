import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:woojr_todo/local_data.dart';
import 'package:woojr_todo/logic/todo/todo_bloc.dart';
import 'package:woojr_todo/task.dart';

class MockLocalData extends Mock implements LocalData {}

class MockTask extends Mock implements Task {}

void main() {
  late MockLocalData mockLocalData;
  late TodoBloc sut;
  late MockTask mockTask;

  final List<Task> mockTaskListData = <Task>[
    Task(taskName: "Test the floor"),
    Task(taskName: "Test the tree"),
    // Task(taskName: "Test the room"),
  ];

  final List<Task> mockTaskListData2 = <Task>[
    Task(taskName: "Test the waters", isComplete: true),
    Task(taskName: "Test the ballroom"),
    Task(taskName: "Test the room"),
  ];

  final Task mockTaskData = Task(taskName: "Test a task name");
  final Task mockTaskData2 = Task(taskName: "Test a task name2");

  setUp(() {
    mockLocalData = MockLocalData();
    sut = TodoBloc(localData: mockLocalData);
    mockTask = MockTask();
  });

  group("TodoBloc", () {
    // test("Ensure no error is produced", () {
    //   expect(sut, returnsNormally);
    // });

    test("Validate initial state", () {
      expect(TodoBloc(localData: mockLocalData).state, equals(TodoEmptyState()));
    });
  });

  group("_todoInitLoadData", () {
    setUp(() {
      when(
        () => mockLocalData.loadLocalData(),
      ).thenAnswer((invocation) async => mockTaskListData);
    });

    blocTest<TodoBloc, TodoState>(
      "Validate if loadLocalData is invoked",
      build: () => sut,
      act: (bloc) => bloc.add(TodoInitLoadDataEvent()),
      verify: (bloc) => verify(() => mockLocalData.loadLocalData()).called(1),
    );

    blocTest<TodoBloc, TodoState>(
      "Inovke _todoInitiLoadData, emits TodoListState with data if localdata is not empty",
      build: () => sut,
      act: (bloc) async => bloc.add(TodoInitLoadDataEvent()),
      expect: () => [TodoListState(taskList: mockTaskListData)],
    );

    blocTest<TodoBloc, TodoState>(
      "Inovke _todoInitiLoadData, emits TodoListState with empty list if localdata is indeed empty",
      build: () {
        when(
          () => mockLocalData.loadLocalData(),
        ).thenAnswer((invocation) async => []);
        return sut;
      },
      act: (bloc) async => bloc.add(TodoInitLoadDataEvent()),
      expect: () => [TodoListState(taskList: [])],
    );
  });

  group("_todoAddTask", () {
    blocTest<TodoBloc, TodoState>("""Validate if saveLocalData is invoked,
       emits TodoListState,
       and TodoListState contains added tasks""",
        build: () => sut,
        setUp: () {
          when(() => mockLocalData.saveLocalData(todoList: [mockTaskData]))
              .thenAnswer((invocation) async {});
        },
        act: (bloc) {
          bloc.add(TodoAddTaskEvent(task: mockTaskData));

          when(() => mockLocalData.saveLocalData(todoList: [mockTaskData, mockTaskData]))
              .thenAnswer((invocation) async {});

          bloc.add(TodoAddTaskEvent(task: mockTaskData));
        },
        verify: (bloc) {
          verify(() => mockLocalData.saveLocalData(todoList: [mockTaskData])).called(1);
          verify(() => mockLocalData.saveLocalData(todoList: [mockTaskData, mockTaskData]))
              .called(1);
          expect(bloc.state, equals(TodoListState(taskList: [mockTaskData, mockTaskData])));
        });
    //* """Validate if saveLocalData is invoked, emits TodoListState, and TodoListState contains added tasks"""

    //! Validate if initState is error state then try adding task
  });

  group("_todoUpdateTask", () {
    late List<Task> newTestTaskList;

    blocTest<TodoBloc, TodoState>(
        "Validate if invalid Task ID is passed, emit TodoErrorState, reload localData and emit TodoListState",
        build: () => sut,
        setUp: () {
          when(() => mockLocalData.loadLocalData()).thenAnswer((invocation) async {
            return mockTaskListData;
          });
        },
        seed: () => TodoListState(taskList: mockTaskListData),
        act: (bloc) => bloc.add(TodoUpdateTaskEvent(task: mockTaskData, taskID: "a")),
        verify: (bloc) {
          verify(
            () => mockLocalData.loadLocalData(),
          ).called(1);
        },
        expect: () => [TodoErrorState(), TodoListState(taskList: mockTaskListData)]);

    blocTest<TodoBloc, TodoState>(
        "Validate normal behaviour: invoked saveLocalData when state is TodoListState",
        build: () => sut,
        setUp: () {
          newTestTaskList = mockTaskListData;
          // newTestTaskList[0] = newTestTaskList[0].copyWith(taskName: "Test New Task Name");
          when(
            () => mockLocalData.saveLocalData(todoList: newTestTaskList),
          ).thenAnswer((invocation) async {});
        },
        seed: () => TodoListState(taskList: mockTaskListData),
        act: (bloc) => bloc
            .add(TodoUpdateTaskEvent(task: newTestTaskList[0], taskID: mockTaskListData[0].taskID)),
        verify: (bloc) {
          verify(
            () => mockLocalData.saveLocalData(todoList: mockTaskListData),
          ).called(1);

          expect(bloc.state, equals(TodoListState(taskList: newTestTaskList)));
        },
        expect: () => [TodoLoadingState(), TodoListState(taskList: newTestTaskList)]
        //* Respond to missing/invalid task ID when updating task
        //* Try catch error state
        );

    blocTest<TodoBloc, TodoState>(
      "Validate error state",
      build: () => sut,
      seed: () => TodoErrorState(),
      act: (bloc) => bloc.add(TodoUpdateTaskEvent(task: mockTaskData, taskID: mockTaskData.taskID)),
      expect: () => [],
    );

    blocTest<TodoBloc, TodoState>(
      "Validate empty state",
      build: () => sut,
      seed: () => TodoEmptyState(),
      act: (bloc) => bloc.add(TodoUpdateTaskEvent(task: mockTaskData, taskID: mockTaskData.taskID)),
      expect: () => [],
    );
  });

  group("_todoMarkTask", () {
    blocTest<TodoBloc, TodoState>(
      "Validate empty state",
      build: () => sut,
      seed: () => TodoErrorState(),
      act: (bloc) => bloc.add(TodoMarkTaskEvent(task: mockTaskData)),
      expect: () => [],
    );

    blocTest<TodoBloc, TodoState>(
      "Validate error state",
      build: () => sut,
      seed: () => TodoEmptyState(),
      act: (bloc) => bloc.add(TodoMarkTaskEvent(task: mockTaskData)),
      expect: () => [],
    );

    blocTest<TodoBloc, TodoState>(
      "Validate invalid task ID: invoke loadLocalData, emit TodoErrorState and TodoListState",
      build: () => sut,
      setUp: () {
        when(() => mockLocalData.loadLocalData()).thenAnswer((invocation) async {
          return mockTaskListData;
        });
        // when(
        //   () => mockLocalData.saveLocalData(todoList: mockTaskListData),
        // ).thenAnswer((invocation) async {});
      },
      seed: () => TodoListState(taskList: mockTaskListData),
      act: (bloc) => bloc.add(TodoMarkTaskEvent(task: mockTaskData)),
      expect: () => [TodoErrorState(), TodoListState(taskList: mockTaskListData)],
    );

    late List<Task> newList;
    late List<Task> newnewList;
    late Task newTask;
    //*  You know how bloc sometimes doesn't get refreshed even though u change the data?
    //* It's most likely because of referenced memory - Meaning creating a new list usually just copies the list by referencing the original list
    //* Thus, when you change something from the new list you are actually mutating the original list alongside
    //* If you want to actively create a new list, use List.from()
    //*------------------------
    //* Because of that, creating a test based on random ID is difficult right now as I cannot replicate the exact result due to different Task ID in the list
    // */
    blocTest<TodoBloc, TodoState>(
      "Validate normal behaviour: Valid Task ID, invoke saveLocalData, emit TodoLoadingState and TodoListState",
      build: () => sut,
      setUp: () {
        // mockTaskListData[1] = mockTaskListData[1].copyWith(isComplete: true);\
        newList = List.from(mockTaskListData);
        newnewList = List.from(newList);
        newTask = newList[1].copyWith(isComplete: true);
        newnewList[1] = newTask;

        when(
          () => mockLocalData.saveLocalData(todoList: newnewList),
        ).thenAnswer((invocation) async {});
      },
      seed: () => TodoListState(taskList: newList),
      act: (bloc) => bloc.add(TodoMarkTaskEvent(task: newnewList[0])),
      expect: () => [TodoLoadingState(), TodoListState(taskList: newnewList)],
    );

    //*Validate normal behaviour: Valid Task ID, saveLocalData, emit TodoLoadingState and TodoListState
  });

  group("_todoRemoveTask", () {
    blocTest<TodoBloc, TodoState>(
      "Validate empty state",
      build: () => sut,
      seed: () => TodoEmptyState(),
      act: (bloc) => bloc.add(TodoRemoveTaskEvent(task: mockTaskData)),
      expect: () => [],
    );

    blocTest<TodoBloc, TodoState>(
      "Validate error state",
      build: () => sut,
      seed: () => TodoErrorState(),
      act: (bloc) => bloc.add(TodoRemoveTaskEvent(task: mockTaskData)),
      expect: () => [],
    );

    blocTest<TodoBloc, TodoState>(
      "Validate invalid Task ID: emit TodoLoadingState, emit TodoListState, list does not change, invoke savelocalData ",
      build: () => sut,
      setUp: () {
        when(() => mockLocalData.saveLocalData(todoList: mockTaskListData))
            .thenAnswer((invocation) async {});
      },
      seed: () => TodoListState(taskList: mockTaskListData),
      act: (bloc) => bloc.add(TodoRemoveTaskEvent(task: mockTaskData)),
      expect: () => [TodoLoadingState(), TodoListState(taskList: mockTaskListData)],
      verify: (bloc) {
        verify(() => mockLocalData.saveLocalData(todoList: mockTaskListData)).called(1);
      },
    );

    //*Validate normal behaviour
    late final List<Task> newTaskList;
    blocTest<TodoBloc, TodoState>(
      """Validate normal behaviour: 
      emit TodoLoadingState, 
      emit TodoListState, 
      task is removed from list, 
      invoke savelocalData""",
      build: () => sut,
      setUp: () {
        newTaskList = List.from(mockTaskListData)..removeAt(0);
        when(() => mockLocalData.saveLocalData(todoList: newTaskList))
            .thenAnswer((invocation) async {});
      },
      seed: () => TodoListState(taskList: mockTaskListData),
      act: (bloc) => bloc.add(TodoRemoveTaskEvent(task: mockTaskListData[0])),
      expect: () => [TodoLoadingState(), TodoListState(taskList: newTaskList)],
      verify: (bloc) {
        verify(() => mockLocalData.saveLocalData(todoList: newTaskList)).called(1);
      },
    );
  });
}
