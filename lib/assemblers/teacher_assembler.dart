import 'package:flutter_sqlite/assemblers/assembler.dart';
import 'package:flutter_sqlite/model/teacher.dart';

class TeacherAssembler implements Assembler<Teacher> {
  final tableName = 'teachers';
  final columnId = 'id';
  final columnName = 'name';
  final columnGrade = 'grade';

  @override
  Teacher fromMap(Map<String, dynamic> query) {
    Teacher teacher = Teacher(query[columnName], query[columnGrade]);
    return teacher;
  }

  @override
  Map<String, dynamic> toMap(Teacher teacher) {
    return <String, dynamic>{
      columnName: teacher.name,
      columnGrade: teacher.grade
    };
  }

  Teacher fromDbRow(dynamic row) {
    return Teacher.withId(row[columnId], row[columnName], row[columnGrade]);
  }

  @override
  List<Teacher> fromList(result) {
    List<Teacher> teachers = List<Teacher>();
    var count = result.length;
    for (int i = 0; i < count; i++) {
      teachers.add(fromDbRow(result[i]));
    }
    return teachers;
  }
}
