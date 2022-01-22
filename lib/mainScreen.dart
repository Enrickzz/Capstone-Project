import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/main.dart';
import 'package:my_app/models/tabIcon_data.dart';
import 'package:my_app/places.dart';
import 'package:my_app/profile/patient/profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'dashboards/dashboards.dart';
import 'fitness_app_theme.dart';
import 'goal_tab/goals.dart';
import 'package:my_app/registration.dart';
import 'package:my_app/storage_service.dart';
import 'package:scheduled_timer/scheduled_timer.dart';

import 'models/users.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  @override
  void initState() {
    initNotif();
    DateTime a = new DateTime.now();
    String sa= a.toString();
    sa = sa.substring(0,sa.indexOf(" "));
    print("DATE TIME " + DateTime.parse("$sa 10:00:00").toString() );
    DateTime am10 = DateTime.parse("$sa 10:00:00");
    DateTime pm2 = DateTime.parse("$sa 14:00:00");
    DateTime pm9 = DateTime.parse("$sa 21:00:00");
    print("DATES");
    print(am10.toString());print(pm2.toString());print(pm9.toString());
    Future.delayed(const Duration(milliseconds: 1200), (){
      if(thisuser.usertype == "Patient"){
        schedulefood(am10);schedulefood(pm2);schedulefood(pm9);
      }
    });
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
  void addtoNotifs(String message, String title, String priority){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    getNotifs();
    String redirect= "Patient meal management";
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "remind food", "redirect": redirect});
      }else{
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + (notifsList.length--).toString());
        notifRef.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "remind food", "redirect": redirect});
      }
    });
  }
  void getNotifs() {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });
    });
  }
  void schedulefood(DateTime thistime) async{
    ScheduledTimer example1;
    print("SCHEDULE FOOD NOTIF");
    DateTime a = new DateTime.now();
    String sa= a.toString();
    sa = sa.substring(0,sa.indexOf(" "));
    DateTime am10 = DateTime.parse("$sa 10:00:00");
    DateTime pm2 = DateTime.parse("$sa 14:00:00");
    DateTime pm9 = DateTime.parse("$sa 21:00:00");
     example1 = await ScheduledTimer(
        id: 'example1',
        onExecute: () {
          print('Execute Scheduled add');
          if(thistime == am10){
            addNotifsall(1);
          }else if(thistime == pm2){
            addNotifsall(2);
          }else if(thistime == pm9){
            addNotifsall(3);
          }
        },
        defaultScheduledTime: thistime,
        onMissedSchedule: () {
          example1.execute();
        });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect){
      print ("ADDED TO NOTIFICATIONS");
      getNotifs2(uid);
      final ref = databaseReference.child('users/' + uid + '/notifications/');
      ref.once().then((DataSnapshot snapshot) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "heartrate", "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
          ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "heartrate", "redirect": redirect});

        }
      });
    }
  void getNotifs2(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void addNotifsall(int check){
    final User user = auth.currentUser;
    final uid = user.uid;

    if(check == 1){
      addtoNotifs("We notice that you have not recorded any meal for your breakfast today.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
          "Eat Breakfast!",
          "2");
    }else if( check == 2){
      addtoNotifs("We notice that you have not recorded any meal for your lunch.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
          "Eat Lunch!",
          "2");
    }else if( check == 3){
      addtoNotifs("We notice that you have not recorded any meal for dinner.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
          "Eat Dinner!",
          "2");
    }
    print("ADDING NOW");
    final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    readConnections.once().then((DataSnapshot snapshot2) {
      print(snapshot2.value);
      print("CONNECTION");
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
      temp.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString)) ;
        Connection a = Connection.fromJson(jsonString);
        print(a.uid);
        var readUser = databaseReference.child("users/" + a.uid + "");
        Users checkSS = new Users();
        readUser.once().then((DataSnapshot snapshot){
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          temp.forEach((key, jsonString) {
            checkSS = Users.fromJson(temp);
          });
          if(checkSS.usertype=="Family member / Caregiver"){
            if(check == 1){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their breakfast today.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Breakfast",
                  "3",
                  a.uid,
                  "Support food management");
            }else if( check == 2){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their lunch.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Lunch",
                  "3",
                  a.uid,
                  "Support food management");
            }else if( check == 3){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their dinner.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Dinner",
                  "3",
                  a.uid,
                  "Support food management");
            }
          }
        });
      });
    });
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