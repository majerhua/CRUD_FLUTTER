import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_student_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/student.dart';

SqfliteStudentRepository studentRepository =
    SqfliteStudentRepository(DatabaseMigration.get);
final List<String> choices = const <String>[
  'Save Student & Back',
  'Delete Student',
  'Back to List'
];

const mnuSave = 'Save Student & Back';
const mnuDelete = 'Delete Student';
const mnuBack = 'Back to List';

class StudentDetailPage extends StatefulWidget {
  final Student student;
  StudentDetailPage(this.student);

  @override
  State<StatefulWidget> createState() => StudentDetailPageState(student);
}

class StudentDetailPageState extends State<StudentDetailPage> {
  Student student;
  StudentDetailPageState(this.student);
  final semesterList = [1, 2, 3, 4];
  final creditList = [3, 4, 6, 8, 10];
  int semester = 1;
  int credits = 4;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = this.student.name;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(student.name),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      style: textStyle,
                      onChanged: (value) => this.updateName(),
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    )
                  ],
                )
              ],
            )));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (student.id == null) {
          return;
        }
        result = await studentRepository.delete(student);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Student"),
            content: Text("The Student has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    if (student.id != null) {
      debugPrint('update');
      studentRepository.update(student);
    } else {
      debugPrint('insert');
      studentRepository.insert(student);
      print("INSERT");
    }
    Navigator.pop(context, true);
  }

  void updateName() {
    student.name = nameController.text;
  }
}
