import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:woojr_todo/add_task_page.dart';
import 'package:woojr_todo/constants.dart';
import 'package:woojr_todo/local_data.dart';
import 'package:woojr_todo/logic/todo/todo_bloc.dart';
import 'package:woojr_todo/task.dart';
import 'package:woojr_todo/todo_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LocalData>(
      create: (context) => LocalData(),
      child: BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(localData: context.read<LocalData>()),
          child: MaterialApp.router(
            routerConfig: _router,
          )),
    );
  }

  final GoRouter _router = GoRouter(routes: <GoRoute>[
    GoRoute(
        path: '/',
        name: AppLocation.homePage,
        builder: (context, state) => const TodoPage(),
        routes: <GoRoute>[
          GoRoute(
            path: 'add',
            name: AppLocation.addTaskPage,
            builder: (context, state) => AddTaskPage(initTask: state.extra as Task?),
          ),
        ])
  ]);
}
