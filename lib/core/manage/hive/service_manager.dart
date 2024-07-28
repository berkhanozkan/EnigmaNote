import 'hive_manager.dart';

class ServiceManager {
  ServiceManager._() {
    _noteManager = NoteHiveManager();
  }
  late final NoteHiveManager _noteManager;

  static ServiceManager instance = ServiceManager._();

  NoteHiveManager get service => _noteManager;
}
