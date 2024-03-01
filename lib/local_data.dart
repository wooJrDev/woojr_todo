import 'package:shared_preferences/shared_preferences.dart';
import 'package:woojr_todo/constants.dart';
import 'package:woojr_todo/task.dart';

class LocalData {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  Future<void> saveLocalData({required List<Task> todoList}) async {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    // Map json = jsonDecode(todoList);
    // String todoData = json.encode(todoList);
    // print("Todo list $todoList");
    var test = Task.listToJson(taskList: todoList);
    // print("Encoded Todo list $test");

    // dynamic test = json.encode(todoList);
    pref.setString(AppLocalDataKey.todoListKey, test);
  }

  Future<List<Task>> loadLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? localData = pref.getString(AppLocalDataKey.todoListKey);
    // jsonDecode(source)
    List<Task> todoList = localData == null ? [] : Task.listFromJson(jsonData: localData);
    return todoList;
  }

  static resetLocalData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(AppLocalDataKey.todoListKey);
  }
}
