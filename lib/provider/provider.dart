import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/widgets/structure.dart';


class TaskNotifier extends StateNotifier<List<Structure>> {
  TaskNotifier() : super([]);

  final List<Structure> undo = [];

  void addTask(Structure task) {
    state = [...state, task];
  }

  void removeTask(Structure task) {
    undo.add(task);
    state = state.where((t) => t.id != task.id).toList();
  }

  void undoTask(Structure task) {
    undo.remove(task);
    state = [...state, task];
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Structure>>((ref) {
  return TaskNotifier();
});
