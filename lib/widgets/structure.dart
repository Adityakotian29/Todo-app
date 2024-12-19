import 'package:flutter/material.dart';

class Structure extends StatelessWidget {
  const Structure({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.undo,
    required this.tasks,
    required this.onUndo,
  });

  final String id; 
  final String name;
  final String category;
  final String date;
  final List undo;
  final List tasks;
  final Function(Structure) onUndo; 

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id), 
      onDismissed: (direction) {
        undo.add(Structure(id: id, name: name, category: category, date: date, undo: undo, tasks: tasks, onUndo: onUndo));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Task has been completed"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                onUndo(this); 
              },
            ),
          ),
        );
      },
      direction: DismissDirection.horizontal,
      child: Card(
        child: ListTile(
          title: Text(name, style: Theme.of(context).textTheme.bodyLarge),
          subtitle: Text('$category and due date $date'),
          onTap: (){},
        ),
      ),
    );
  }
}
