import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes/boxes.dart';
import 'package:flutter_hive/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getNotes().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 19.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data[index].title,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    deleteNote(data[index]);
                                  },
                                  child: Icon(Icons.delete, color: Colors.red,)
                              ),
                              SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  _editMyDialog(data[index], data[index].title, data[index].description);
                                },
                                  child: Icon(Icons.edit)
                              ),
                            ],
                          ),
                          Text(data[index].description),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteNote(NotesModel notesModel) async{
    await notesModel.delete();
  }

  Future<void> _editMyDialog(NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Notes'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    notesModel.title = titleController.text;
                    notesModel.description = descriptionController.text;
                    notesModel.save();
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text('Edit')),
          ],
        );
      },
    );
  }


  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Notes'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);
                    final box = Boxes.getNotes();
                    box.add(data);
                    data.save();
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text('Add')),
          ],
        );
      },
    );
  }

}
