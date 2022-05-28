import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  @override
  void initState() {
    super.initState();
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


