import 'package:hive_flutter/hive_flutter.dart';
import 'package:students_list/models/notes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
