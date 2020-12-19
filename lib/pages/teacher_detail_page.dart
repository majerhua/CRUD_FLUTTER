import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_teacher_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/teacher.dart';

SqfliteTeacherRepository teacherRepository =
    SqfliteTeacherRepository(DatabaseMigration.get);
final List<String> choices = const <String>[
  'Save Teacher & Back',
  'Delete Teacher',
  'Back to List'
];

const mnuSave = 'Save Teacher & Back';
const mnuDelete = 'Delete Teacher';
const mnuBack = 'Back to List';

class TeacherDetailPage extends StatefulWidget {
  final Teacher teacher;
  TeacherDetailPage(this.teacher);

  @override
  State<StatefulWidget> createState() => TeacherDetailPageState(teacher);
}

class TeacherDetailPageState extends State<TeacherDetailPage> {
  Teacher teacher;
  TeacherDetailPageState(this.teacher);
  final semesterList = [1, 2, 3, 4];
  final creditList = [3, 4, 6, 8, 10];
  int semester = 1;
  int credits = 4;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = this.teacher.name;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(teacher.name),
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
        if (teacher.id == null) {
          return;
        }
        result = await teacherRepository.delete(teacher);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Teacher"),
            content: Text("The teacher has been deleted"),
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
    if (teacher.id != null) {
      debugPrint('update');
      teacherRepository.update(teacher);
    } else {
      debugPrint('insert');
      teacherRepository.insert(teacher);
      print("INSERT");
    }
    Navigator.pop(context, true);
  }

  void updateName() {
    teacher.name = nameController.text;
  }
}
