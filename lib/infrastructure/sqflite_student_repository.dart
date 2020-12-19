import 'package:flutter_sqlite/assemblers/student_assembler.dart';
import 'package:flutter_sqlite/infrastructure/student_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/student.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteStudentRepository implements StudentRepository {
  final assembler = StudentAssembler();

  @override
  DatabaseMigration databaseMigration;

  SqfliteStudentRepository(this.databaseMigration);

  @override
  Future<int> insert(Student student) async {
    final db = await databaseMigration.db();
    var id = await db.insert(assembler.tableName, assembler.toMap(student));
    return id;
  }

  @override
  Future<int> delete(Student student) async {
    final db = await databaseMigration.db();
    int result = await db.delete(assembler.tableName,
        where: assembler.columnId + " = ?", whereArgs: [student.id]);
    return result;
  }

  @override
  Future<int> update(Student course) async {
    final db = await databaseMigration.db();
    int result = await db.update(assembler.tableName, assembler.toMap(course),
        where: assembler.columnId + " = ?", whereArgs: [course.id]);
    return result;
  }

  @override
  Future<List<Student>> getList() async {
    final db = await databaseMigration.db();
    var result = await db.rawQuery("SELECT * FROM students order by name ASC");
    List<Student> students = assembler.fromList(result);
    return students;
  }

  Future<int> getCount() async {
    final db = await databaseMigration.db();
    var result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM students'));
    return result;
  }
}
