import 'package:flutter_sqlite/assemblers/assembler.dart';
import 'package:flutter_sqlite/model/course.dart';

class CourseAssembler implements Assembler<Course> {
  final tableName = 'courses';
  final columnId = 'id';
  final columnName = 'name';
  final columnDescription = 'description';
  final columnSemester = 'semester';
  final columnCredits = 'credits';
  final columnResearch = 'research';

  @override
  Course fromMap(Map<String, dynamic> query) {
    Course course = Course(query[columnId], query[columnSemester],
        query[columnCredits], query[columnResearch], query[columnDescription]);
    return course;
  }

  @override
  Map<String, dynamic> toMap(Course course) {
    return <String, dynamic>{
      columnName: course.name,
      columnDescription: course.description,
      columnSemester: course.semester,
      columnCredits: course.credits,
      columnResearch: course.research
    };
  }

  Course fromDbRow(dynamic row) {
    return Course.withId(row[columnId], row[columnName], row[columnSemester],
        row[columnCredits], row[columnResearch], row[columnDescription]);
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
