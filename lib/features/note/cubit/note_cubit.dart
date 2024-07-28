import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/manage/hive/hive_manager.dart';
import '../../../model/note_model.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final IHiveManager<NoteModel> _noteHive;
  bool isLoading = false;
  NoteCubit(this._noteHive) : super(NoteInitial());

  Future<void> changeLoadingStatus() async {
    isLoading = !isLoading;
    emit(NoteLoadingState(isLoading));
  }

  Future<void> getNotes() async {
    changeLoadingStatus();
    List<NoteModel>? noteList = _noteHive.getValues()?.cast<NoteModel>() ?? [];
    changeLoadingStatus();
    emit(NoteGetState(noteList));
  }

  Future<bool> saveNote(NoteModel model) async {
    changeLoadingStatus();
    bool result = await _noteHive.addItem(model);
    changeLoadingStatus();
    emit(NoteCompleteState(result));
    return result;
  }

  Future<bool> updateNote(NoteModel model) async {
    changeLoadingStatus();
    bool result = await _noteHive.updateItem(model);
    changeLoadingStatus();
    emit(NoteCompleteState(result));
    return result;
  }

  Future<bool> removeNote(String key) async {
    return await _noteHive.removeItem(key);
  }
}
