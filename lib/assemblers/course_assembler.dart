import 'package:flutter_sqlite/assemblers/assembler.dart';
import 'package:flutter_sqlite/model/course.dart';

class CourseAssembler implements Assembler<Course> {
  final tableName = 'courses';
  final columnId = 'id';
  final columnName = 'name';
  final columnPrice = 'price';
  final columnTechStack = 'techStack';

  @override
  Course fromMap(Map<String, dynamic> query) {
    Course course =
        Course(query[columnName], query[columnPrice], query[columnTechStack]);
    return course;
  }

  @override
  Map<String, dynamic> toMap(Course course) {
    return <String, dynamic>{
      columnName: course.name,
      columnPrice: course.price,
      columnTechStack: course.techStack
    };
  }

  Course fromDbRow(dynamic row) {
    return Course.withId(
        row[columnId], row[columnName], row[columnPrice], row[columnTechStack]);
  }

  @override
  List<Course> fromList(result) {
    List<Course> courses = List<Course>();
    var count = result.length;
    for (int i = 0; i < count; i++) {
      courses.add(fromDbRow(result[i]));
    }
    return courses;
  }
}
