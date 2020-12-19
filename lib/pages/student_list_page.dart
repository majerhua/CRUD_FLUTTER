import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_student_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/student.dart';
import 'package:flutter_sqlite/pages/student_detail_page.dart';

class StudentListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudentListPageState();
}

class StudentListPageState extends State<StudentListPage> {
  SqfliteStudentRepository studentRepository =
      SqfliteStudentRepository(DatabaseMigration.get);
  List<Student> students;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (students == null) {
      students = List<Student>();
      getData();
    }
    return Scaffold(
      body: studentListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Student(''));
        },
        tooltip: "Add new Student",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView studentListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 5.0,
          child: ListTile(
            title: Text(this.students[position].name),
            subtitle: Text(this.students[position].id.toString()),
            onTap: () {
              debugPrint("Tapped on " + this.students[position].id.toString());
              navigateToDetail(this.students[position]);
            },
          ),
        );
      },
    );
  }

  void getData() {
    final studentsFuture = studentRepository.getList();
    studentsFuture.then((studentList) {
      setState(() {
        students = studentList;
        count = studentList.length;
      });
    });
  }

  Color getColor(int semester) {
    switch (semester) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.yellow;
        break;
      case 4:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Student student) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentDetailPage(student)),
    );
    if (result == true) {
      getData();
    }
  }
}
