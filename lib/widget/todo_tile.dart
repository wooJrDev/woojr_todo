import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:woojr_todo/constants.dart';
import 'package:woojr_todo/task.dart';
import 'package:woojr_todo/widget/app_text.dart';

class TodoTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Task task;
  const TodoTile({required this.task, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.goNamed(AppLocation.addTaskPage, extra: task),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 73,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: AppColour.blue),
              borderRadius: BorderRadius.circular(22)),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Visibility(
                visible: !task.isComplete,
                replacement: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: onTap,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: AppColour.blue),
                          borderRadius: BorderRadius.circular(25),
                          color: AppColour.blue),
                      child: const Icon(
                        Icons.check,
                        color: AppColour.white,
                      ),
                    ),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: onTap,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: AppColour.blue),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 30,
                //   width: 30,
                //   decoration: BoxDecoration(
                //       border: Border.all(width: 2, color: AppColour.blue),
                //       borderRadius: BorderRadius.circular(25)),
                // ),
              ),
              const SizedBox(width: 15),
              AppText(
                text: task.taskName,
                fontSize: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
