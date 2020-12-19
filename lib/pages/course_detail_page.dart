import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_course_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/course.dart';

SqfliteCourseRepository courseRepository =
    SqfliteCourseRepository(DatabaseMigration.get);
final List<String> choices = const <String>[
  'Save Virtual Course & Back',
  'Delete Virtual Course',
  'Back to List'
];

const mnuSave = 'Save Virtual Course & Back';
const mnuDelete = 'Delete Virtual Course';
const mnuBack = 'Back to List';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  CourseDetailPage(this.course);

  @override
  State<StatefulWidget> createState() => CourseDetailPageState(course);
}

class CourseDetailPageState extends State<CourseDetailPage> {
  Course course;
  CourseDetailPageState(this.course);
  List<String> techStackList = ["Android", "PHP", "SQL", "JAVA"];
  String techStack = 'Android';
  TextEditingController nombreController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nombreController.text = this.course.name;
    priceController.text = course.price.toString();

    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(course.name),
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
                      controller: nombreController,
                      style: textStyle,
                      onChanged: (value) => this.updateName(),
                      decoration: InputDecoration(
                          labelText: "Nombre",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextField(
                          controller: priceController,
                          style: textStyle,
                          onChanged: (value) => this.updatePrice(),
                          decoration: InputDecoration(
                              labelText: "Precio",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        )),
                    DropdownButton<String>(
                        value: techStack,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          course.techStack = newValue;
                          setState(() {
                            techStack = newValue;
                          });
                        },
                        items: <String>["Android", "PHP", "SQL", "JAVA"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList())
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
        if (course.id == null) {
          return;
        }
        result = await courseRepository.delete(course);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Virtual Course"),
            content: Text("The Course has been deleted"),
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
    if (course.id != null) {
      debugPrint('update');
      courseRepository.update(course);
    } else {
      debugPrint('insert');
      courseRepository.insert(course);
    }
    Navigator.pop(context, true);
  }

  void updateTechStack(String value) {
    course.techStack = value;
    setState(() {
      techStack = value;
    });
  }

  String retrieveTechStack(String value) {
    return techStackList.firstWhere((element) => element == value);
  }

  void updateName() {
    course.name = nombreController.text;
  }

  void updatePrice() {
    course.price = double.tryParse(priceController.text);
  }
}
