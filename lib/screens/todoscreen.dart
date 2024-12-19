import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do/widgets/structure.dart';
import 'package:to_do/provider/provider.dart';
import 'package:uuid/uuid.dart';

class Todoscreen extends ConsumerWidget {
  const Todoscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider); 
    final taskNotifier = ref.read(taskProvider.notifier);

    final TextEditingController mytext = TextEditingController();
    String? newvalue;
    String? day;

    void addTask(String name, String category, String date) {
      final uuid = const Uuid();
      taskNotifier.addTask(
        Structure(
          name: name,
          category: category,
          date: date,
          id: uuid.v4(),
          undo: const [],
          tasks: const [],
          onUndo: (task) => taskNotifier.undoTask(task),
        ),
      );
    }

    void sheet() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: mytext,
                            decoration: const InputDecoration(hintText: 'Enter Task'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: newvalue,
                                hint: const Text('Select Category'),
                                items: ['Personal', 'Work', 'Shopping', 'Wishlist', 'Others']
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (String? value) {
                                  setModalState(() {
                                    newvalue = value;
                                  });
                                },
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setModalState(() {
                                      day = DateFormat('dd-MM-yyyy').format(pickedDate);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.calendar_month),
                              ),
                              const SizedBox(height: 16),
                              if (day != null) Text('Selected Day: $day'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (newvalue != null && day != null && mytext.text.isNotEmpty) {
                                  addTask(mytext.text, newvalue!, day!);
                                  mytext.clear();
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Plz enter all the details for ur task"),
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add Task'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        actions: [
          FloatingActionButton(
            onPressed: sheet,
            child: const Icon(Icons.add),
          )
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Add your tasks'))
          : SingleChildScrollView(
              child: Column(
                children: tasks,
              ),
            ),
    );
  }
}
