import 'package:hive/hive.dart';

import '../../../model/note_model.dart';

class Boxes {
  static Box<NoteModel> getTransactions() => Hive.box<NoteModel>('notesCache');
}
