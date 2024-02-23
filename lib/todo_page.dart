import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:woojr_todo/constants.dart';
import 'package:woojr_todo/local_data.dart';
import 'package:woojr_todo/logic/todo/todo_bloc.dart';
import 'package:woojr_todo/task.dart';
import 'package:woojr_todo/widget/app_text.dart';
import 'package:woojr_todo/widget/todo_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    context.read<TodoBloc>().add(TodoInitLoadDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: GestureDetector(
        onTap: () => context.goNamed(AppLocation.addTaskPage),
        child: const Icon(
          Icons.add,
          size: 55,
          color: AppColour.darkBlue,
          shadows: [Shadow(color: Colors.black, blurRadius: 20.0, offset: Offset(0, 2.0))],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30, bottom: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  AppText(
                    text: "Greetings \nMake it a beautiful day",
                    fontSize: 20,
                  ),
                  Spacer(),
                  Icon(
                    Icons.sunny,
                    color: AppColour.orange,
                    size: 35,
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    context.read<TodoBloc>().add(TodoInitLoadDataEvent());
                    return Future.delayed(const Duration(milliseconds: 800));
                  },
                  child: ListView(
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: ExpansionTile(
                          title: const AppText(
                            text: "Completed",
                            fontSize: 20,
                          ),
                          tilePadding: EdgeInsets.zero,
                          collapsedIconColor: AppColour.blue,
                          iconColor: AppColour.darkBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          children: [
                            BlocBuilder<TodoBloc, TodoState>(
                              builder: (context, state) {
                                if (state is TodoListState) {
                                  List<Task> completedTask = state.taskList
                                      .where((task) => task.isComplete == true)
                                      .toList();
                                  return ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 15),
                                    itemCount: completedTask.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Dismissible(
                                      key: ValueKey(UniqueKey()),
                                      onDismissed: (direction) {
                                        // direction == DismissDirection.
                                        context
                                            .read<TodoBloc>()
                                            .add(TodoRemoveTaskEvent(task: completedTask[index]));
                                      },
                                      child: TodoTile(
                                        task: completedTask[index],
                                        onTap: () => context
                                            .read<TodoBloc>()
                                            .add(TodoMarkTaskEvent(task: completedTask[index])),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      Card(
                        elevation: 0,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: ExpansionTile(
                          title: const AppText(
                            text: "Things To Do",
                            fontSize: 20,
                          ),
                          shape: InputBorder.none,
                          tilePadding: EdgeInsets.zero,
                          collapsedIconColor: AppColour.orange,
                          iconColor: AppColour.darkBlue,
                          initiallyExpanded: true,
                          children: [
                            BlocBuilder<TodoBloc, TodoState>(
                              builder: (context, state) {
                                if (state is TodoListState) {
                                  List<Task> pendingTask = state.taskList
                                      .where((task) => task.isComplete == false)
                                      .toList();
                                  return ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 15),
                                    itemCount: pendingTask.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Dismissible(
                                      onDismissed: (direction) => context
                                          .read<TodoBloc>()
                                          .add(TodoRemoveTaskEvent(task: pendingTask[index])),
                                      key: ValueKey(UniqueKey()),
                                      child: TodoTile(
                                        task: pendingTask[index],
                                        onTap: () => context
                                            .read<TodoBloc>()
                                            .add(TodoMarkTaskEvent(task: pendingTask[index])),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // child:
              ),
            ],
          ),
        ),
      ),
    );
  }
}
