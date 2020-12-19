import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/student.dart';

abstract class StudentRepository {
  DatabaseMigration databaseMigration;
  Future<int> insert(Student student);
  Future<int> update(Student student);
  Future<int> delete(Student student);
  Future<List<Student>> getList();
}
