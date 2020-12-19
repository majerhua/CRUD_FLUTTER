import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_course_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/course.dart';
import 'package:flutter_sqlite/pages/course_detail_page.dart';

class CourseListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CourseListPageState();
}

class CourseListPageState extends State<CourseListPage> {
  SqfliteCourseRepository courseRepository =
      SqfliteCourseRepository(DatabaseMigration.get);
  List<Course> courses;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (courses == null) {
      courses = List<Course>();
      getData();
    }
    return Scaffold(
      body: courseListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Course('', 1, 4, 0, ''));
        },
        tooltip: "Add new Course",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView courseListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 5.0,
          child: ListTile(
            title: Text(this.courses[position].name),
            subtitle: Text('Credits: ' +
                this.courses[position].credits.toString() +
                ' - ' +
                this.courses[position].description.toString()),
            onTap: () {
              debugPrint("Tapped on " + this.courses[position].id.toString());
              navigateToDetail(this.courses[position]);
            },
          ),
        );
      },
    );
  }

  void getData() {
    final coursesFuture = courseRepository.getList();
    coursesFuture.then((courseList) {
      setState(() {
        courses = courseList;
        count = courseList.length;
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

  void navigateToDetail(Course course) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseDetailPage(course)),
    );
    if (result == true) {
      getData();
    }
  }
}
