import 'package:hive_flutter/adapters.dart';

import '../tool/constants/hive_constants.dart';

part 'note_model.g.dart';

@HiveType(typeId: HiveConstants.NOTE_TYPE_ID)
class NoteModel {
  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool? isEncrypt;

  @HiveField(4)
  String? key;

  @HiveField(5)
  String? password;

  NoteModel(
      {this.title, this.description, this.isEncrypt, this.key, this.password});

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
      title: json['title'] ?? json['title'],
      description: json['description'] ?? json['description'],
      isEncrypt: json['isEncrypt'] ?? json['isEncrypt'],
      key: json['key'] ?? json['key'],
      password: json["password"] ?? json["password"]);

  Map<String, dynamic> toJson() => {
        "title": title ?? title,
        "description": description ?? description,
        "isEncrypt": isEncrypt ?? isEncrypt,
        "key": key ?? key,
        "password": password ?? password
      };
}
