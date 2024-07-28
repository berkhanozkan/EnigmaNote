part of 'note_cubit.dart';

abstract class NoteState {
  const NoteState();
}

class NoteInitial extends NoteState {}

class NoteLoadingState extends NoteState {
  final bool isLoading;
  NoteLoadingState(this.isLoading);
}

class NoteErrorState extends NoteState {
  final String message;

  NoteErrorState(this.message);
}

class NoteCompleteState extends NoteState {
  final bool isComplete;
  NoteCompleteState(this.isComplete);
}

class NoteGetState extends NoteState {
  final List<NoteModel>? noteList;
  NoteGetState(this.noteList);
}
