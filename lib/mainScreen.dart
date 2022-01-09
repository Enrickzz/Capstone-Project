import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/main.dart';
import 'package:my_app/models/tabIcon_data.dart';
import 'package:my_app/my_diary/my_exercises.dart';
import 'package:my_app/places.dart';
import 'package:my_app/profile/patient/profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'dashboards/dashboards.dart';
import 'fitness_app_theme.dart';
import 'index2/index2.dart';
import 'index2/food_list.dart';
import 'index2/meals.dart';
import 'goal_tab/goals.dart';
import 'my_diary/exercise_screen.dart';
import 'package:my_app/registration.dart';
import 'package:my_app/storage_service.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CardioVascular Disease'),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              print("Sign out user");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
               await FirebaseAuth.instance.signOut();

            },
          ),
        ],
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: mainScreen(),
    // );
  }
}

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = Dashboards(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  InkWell(onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => registration()),
                    )
                  }, child: Container(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFFAC252B),
                        fontSize: 50,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  ),
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      Dashboards(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      // my_exercises(animationController: animationController);
                  goals(animationController: animationController);
                });
              });
            }else if(index ==2){
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      // food_list(animationController: animationController);
                      places();
                });
              });
            }else if(index ==3){
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      index3(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}