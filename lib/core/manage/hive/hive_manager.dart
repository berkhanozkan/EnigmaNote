import 'package:hive_flutter/hive_flutter.dart';

import '../../../model/note_model.dart';
import 'boxes.dart';

abstract class IHiveManager<T> {
  List<T>? getValues();
  Future<bool> removeItem(String key);
  Future<bool> addItem(T item);
  Future<bool> updateItem(T item);
}

class NoteHiveManager extends IHiveManager<NoteModel> {
  final String _key = 'notesCache';
  final Box<NoteModel> _noteBox = Boxes.getTransactions();

  @override
  Future<bool> removeItem(String key) async {
    try {
      await _noteBox.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  List<NoteModel>? getValues() {
    List<NoteModel>? values = _noteBox.values.toList();
    return values;
  }

  @override
  Future<bool> addItem(NoteModel item) async {
    try {
      //throw ("Exception");
      await _noteBox.put(item.key, item);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateItem(NoteModel item) async {
    try {
      // throw ("Exception");
      await _noteBox.put(item.key, item);
      return true;
    } catch (e) {
      return false;
    }
  }
}
