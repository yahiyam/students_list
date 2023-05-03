import 'package:hive_flutter/adapters.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String age;
  @HiveField(2)
  String clas;
  @HiveField(3)
  String phone;
  NotesModel({
    required this.name,
    required this.age,
    required this.clas,
    required this.phone,
  });
}
