import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:woojr_todo/constants.dart';
import 'package:woojr_todo/logic/todo/todo_bloc.dart';
import 'package:woojr_todo/task.dart';
import 'package:woojr_todo/widget/app_text.dart';

class AddTaskPage extends StatefulWidget {
  final Task? initTask;
  const AddTaskPage({this.initTask, super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController taskNameController = TextEditingController();

  @override
  void initState() {
    taskNameController.text = widget.initTask?.taskName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColour.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(color: AppColour.darkBlueShade04),
              ),
              Container(
                height: 50,
                decoration: const BoxDecoration(color: AppColour.darkBlueShade03),
              ),
              Container(
                height: 50,
                decoration: const BoxDecoration(color: AppColour.darkBlueShade02),
              ),
              Container(
                height: 50,
                decoration: const BoxDecoration(color: AppColour.darkBlueShade01),
              ),
              Container(
                padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppText(
                          text: "Add a task",
                          fontSize: 22,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(
                            Icons.clear,
                            color: AppColour.blue,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const AppText(
                      text: "Task title",
                      fontSize: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autofocus: true,
                            style: const TextStyle(fontFamily: "MavenPro", fontSize: 20),
                            controller: taskNameController,
                            onFieldSubmitted: (newValue) {
                              context.read<TodoBloc>()
                                ..add(
                                    TodoAddTaskEvent(task: Task(taskName: taskNameController.text)))
                                ..add(TodoAddTaskEvent(
                                    task: Task(taskName: taskNameController.text)));
                              // context
                              //     .read<TodoBloc>()
                              //     .add(TodoAddTaskEvent(task: Task(taskName: "Something")));
                              context.pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              widget.initTask == null
                                  ? () {
                                      context
                                          .read<TodoBloc>()
                                          .add(TodoAddTaskEvent(task: Task(taskName: "asdasd")));
                                      // context.read<TodoBloc>().add(TodoAddTaskEvent(
                                      //     task: Task(taskName: taskNameController.text)));
                                    }
                                  : context.read<TodoBloc>().add(TodoUpdateTaskEvent(
                                      task: widget.initTask!
                                          .copyWith(taskName: taskNameController.text),
                                      taskID: widget.initTask!.taskID));
                              context.pop();
                            },
                            child: const Icon(
                              Icons.keyboard_double_arrow_right,
                              size: 55,
                              color: AppColour.blue,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
