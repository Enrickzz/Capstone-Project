import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:my_app/goal_tab/sleep/my_sleep.dart';
import 'package:my_app/goal_tab/water/my_water.dart';
import 'package:my_app/goal_tab/weight/my_weight.dart';
import 'package:my_app/goal_tab/exercises/my_exercises.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/notifications/notifications._patients.dart';
import 'package:my_app/services/auth.dart';
import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';
import '../goal_tab/meals/my_meals.dart';

class goals extends StatefulWidget {
  const goals({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _goalsState createState() => _goalsState();
}

class _goalsState extends State<goals>
    with TickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> topBarAnimation;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  final AuthService _auth = AuthService();

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  final List<String> tabs = ['My Meals', 'My Exercises', 'My Weight', 'My Water', 'My Sleep'];
  TabController controller;
  List<String> generate =  List<String>.generate(100, (index) => "$index ror");

  double topBarOpacity = 0.0;
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String bday= "";
  String date;
  String hours,min;
  int lengFin = 0;
  List<Connection> connections = new List<Connection>();
  Users thisuser = new Users();
  List<distressSOS> SOS = new List<distressSOS>();
  int lengSOS = 0;
  @override
  void initState() {
    super.initState();
    initNotif();
    getNotifs();
    getRecomm();
    controller = TabController(length: 5, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 3000), (){
      setState(() {
        print("Set State this");
      });
    });

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = my_meals(animationController: animationController);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController?.dispose();
    super.dispose();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(tabs[controller.index],
            style: TextStyle(
                color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
              onTap: () async {
                final User user = auth.currentUser;
                final uid = user.uid;
                final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
                Users patient = new Users();
                String contactNum="";
                String contactNumFName = "";
                String contactNumLName = "";
                await readPatient.once().then((DataSnapshot snapshotPatient) {
                  Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
                  patientTemp.forEach((key, jsonString) {
                    patient = Users.fromJson(patientTemp);
                  });
                }).then((value) async {
                  if(patient.emergency_contact == null){
                    await FlutterPhoneDirectCaller.callNumber("911").then((value) {
                      notifySS();
                    });
                    final readSOS = databaseReference.child('users/' + uid + '/SOSCalls/');
                    readSOS.once().then((DataSnapshot snapshot) async {
                      if (snapshot.value == null) {
                        final ref = databaseReference.child(
                            'users/' + uid + '/SOSCalls/' + 0.toString());
                        ref.set({
                          "full_name": " ",
                          "rec_date": date,
                          "rec_time": "$hours:$min",
                          "reason": "", "number": "911",
                          "note": "",
                          "call_desc": "",
                        });
                      }
                      else{
                        getSOS().then((value) {
                          final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + lengSOS.toString());
                          ref.set({
                            "full_name": " ",
                            "rec_date": date,
                            "rec_time": "$hours:$min",
                            "reason": "","number": "911",
                            "note": "",
                            "call_desc": "",
                          });
                        });
                      }
                    });
                  }else{
                    final readContactNum = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/contact_no/' /** contact_number ni SS*/);
                    final readContactLNumName = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/lastname/' /** last name ni SS*/);
                    final readContactFNumName = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/firstname/' /** first name ni SS*/);
                    await readContactNum.once().then((DataSnapshot contact) {
                      readContactLNumName.once().then((DataSnapshot lastname) {
                        contactNumLName = lastname.value.toString();
                      });
                      readContactFNumName.once().then((DataSnapshot firstname) {
                        contactNumFName = firstname.value.toString();
                      });
                      contactNum = contact.value.toString();
                    }).then((value) async{
                      print(">>>YAY");
                      await FlutterPhoneDirectCaller.callNumber(contactNum).then((value) {
                        notifySS();
                      });
                      final readSOS = databaseReference.child('users/' + uid + '/SOSCalls/');
                      readSOS.once().then((DataSnapshot snapshot) async {
                        if (snapshot.value == null) {
                          final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + 0.toString());
                          ref.set({
                            "full_name": "$contactNumFName $contactNumLName",
                            "rec_date": date,
                            "rec_time": "$hours:$min",
                            "reason": "","number": contactNum,
                            "note": "",
                            "call_desc": "",
                          });
                        } else {
                          getSOS().then((value) {
                            final ref = databaseReference.child('users/' + uid + '/SOSCalls/' + lengSOS.toString());
                            ref.set({
                              "full_name": "$contactNumFName $contactNumLName",
                              "rec_date": date,
                              "rec_time": "$hours:$min",
                              "reason": "","number": contactNum,
                              "note": "",
                              "call_desc": "",
                            });
                          });
                        }
                      });
                    });
                  }
                });

              },
              child: Image.asset(
                'assets/images/emergency.png',
                width: 32,
                height: 32,
              )
          ),
          SizedBox(width: 24),
          Container(
            margin: EdgeInsets.only( top: 16, right: 16,),

            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => notifications(animationController: widget.animationController)),
                );
              },
              child: Stack(
                children: <Widget>[
                  Icon(Icons.notifications, ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: checkNotifs(),
                      constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                      child: Text( '!', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: controller,
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs:<Widget>[
            Tab(
              text: 'My Meals', icon: Image.asset('assets/fitness_app/meals.png',
                width: 24,
                height:24,),
            ),
            Tab(
              text: 'My Exercises', icon: Image.asset('assets/fitness_app/exercises.png',
                width: 24,
                height:24)
            ),
            Tab(
              text: 'My Weight', icon: Image.asset('assets/fitness_app/weight.png',
              width: 24,
              height:24,),
            ),
            Tab(
              text: 'My Water', icon: Image.asset('assets/fitness_app/water.png',
              width: 24,
              height:24,),
            ),
            Tab(
              text: 'My Sleep', icon: Image.asset('assets/fitness_app/sleep.png',
              width: 24,
              height:24,),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          tabBody = my_meals(animationController: animationController),
          tabBody = my_exercises(animationController: animationController),
          tabBody = my_weight(animationController: animationController),
          tabBody = my_water(animationController: animationController),
          tabBody = my_sleep(animationController: animationController),
        ],
      ),
    );

  }
  void getRecomm() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void notifySS(){
    final User user = auth.currentUser;
    final uid = user.uid;
    final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    readConnections.once().then((DataSnapshot snapshot2) {
      print(snapshot2.value);
      print("CONNECTION");
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
      temp.forEach((jsonString) async {
        connections.add(Connection.fromJson(jsonString)) ;
        Connection a = Connection.fromJson(jsonString);
        print(a.doctor1);
        if(uid != a.doctor1){
          await addtoNotif("Your <type> "+ thisuser.firstname+ " has used his panic button! Check on the patient immediately",
              thisuser.firstname + " used SOS!",
              "3",
              a.doctor1,
              "SOS", "",
              date ,
              hours.toString() +":"+min.toString());
        }
      });
    });
  }
  Future<void> addtoNotif(String message, String title, String priority,String uid, String redirect,String category, String date, String time)async {
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) async{
      int leng = await getNotifs2(uid).then((value) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + lengFin.toString());
          ref.set({"id": lengFin.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }
        return value;
      });

    });
  }
  Future<int> getNotifs2(String passedUid) async {
    notifsList.clear();
    final uid = passedUid;
    List<RecomAndNotif> tempL=[];
    final readBP = databaseReference.child('users/' + passedUid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        RecomAndNotif a = RecomAndNotif.fromJson(jsonString);
        notifsList.add(RecomAndNotif.fromJson(jsonString));
        tempL.add(a);
      });
      notifsList = notifsList.reversed.toList();
    }).then((value) {
      print("LENGFIN = " + lengFin.toString());
      lengFin = tempL.length;
      return tempL.length;
    });
  }
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call Failed!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You have not chosen an Emergency contact'),
              ],
            ),
          ),
        );
      },
    );
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
  Future<int> getSOS() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    int count = 0;
    final readBP = databaseReference.child('users/' + uid + '/SOSCalls/');
    await readBP.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        count++;
        SOS.add(distressSOS.fromJson(jsonString));
      });
      lengSOS = count;
      return count;
    });
  }
  void getNotifs() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  Decoration checkNotifs() {
    if(notifsList.isNotEmpty || recommList.isNotEmpty){
      return BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6));
    }else{
      return BoxDecoration();
    }
  }
}


