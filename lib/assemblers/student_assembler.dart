import 'package:flutter_sqlite/assemblers/assembler.dart';
import 'package:flutter_sqlite/model/student.dart';

class StudentAssembler implements Assembler<Student> {
  final tableName = 'students';
  final columnId = 'id';
  final columnName = 'name';

  @override
  Student fromMap(Map<String, dynamic> query) {
    Student student = Student(query[columnName]);
    return student;
  }

  @override
  Map<String, dynamic> toMap(Student student) {
    return <String, dynamic>{columnName: student.name};
  }

  Student fromDbRow(dynamic row) {
    return Student.withId(row[columnId], row[columnName]);
  }

  @override
  List<Student> fromList(result) {
    List<Student> students = List<Student>();
    var count = result.length;
    for (int i = 0; i < count; i++) {
      students.add(fromDbRow(result[i]));
    }
    return students;
  }
}
