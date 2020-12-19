import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_sqlite/common/app_constants.dart';
import 'package:flutter_sqlite/pages/course_list_page.dart';
import 'package:flutter_sqlite/pages/teacher_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  Widget content = CourseListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text(
            AppConstants.appBarTitle,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(FontAwesomeIcons.bars),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(FontAwesomeIcons.solidBell,
                    size: 25, color: Colors.white),
              ),
              onTap: () {
                print("INBOX!");
              },
            ),
          ],
        ),
      ),
      body: content,
      bottomNavigationBar: _indexBottom(),
    );
  }

  Widget _indexBottom() => BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.graduationCap),
            label: 'Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userTie),
            label: 'Docentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userGraduate),
            label: 'Estudiantes',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                content = CourseListPage();
                break;
              case 1:
                content = TeacherListPage();
                break;
            }
          });
        },
      );
}
