
import 'package:flutter_hive/models/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<NotesModel> getNotes() => Hive.box<NotesModel>('notes');
}