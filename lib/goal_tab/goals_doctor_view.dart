import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/goal_tab/sleep/my_sleep.dart';
import 'package:my_app/goal_tab/water/my_water.dart';
import 'package:my_app/goal_tab/weight/my_weight.dart';
import 'package:my_app/goal_tab/weight/my_weight_doctor.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/my_diary/my_exercises.dart';
import 'package:my_app/notifications/notifications._patients.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/BMI_chart.dart';
import 'package:my_app/my_diary/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/cholesterol_chart.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';
import '../../main.dart';
import '../../my_diary/exercise_screen.dart';
import '../bottom_navigation_view/bottom_bar_view.dart';
import '../index2/meals.dart';
import '../index2/my_meals.dart';
import 'my_stress.dart';

class goals_doctor_view extends StatefulWidget {
  const goals_doctor_view({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _goals_doctor_viewState createState() => _goals_doctor_viewState();
}

class _goals_doctor_viewState extends State<goals_doctor_view>
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

  final List<String> tabs = ["Patient's Meals", "Patient's Exercises", "Patient's Weight", "Patient's Water", "Patient's Sleep", "Patient's Stress" ];
  TabController controller;
  List<String> generate =  List<String>.generate(100, (index) => "$index ror");

  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 6, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 2000), (){
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
    tabBody = meals(animationController: animationController);

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
                  MaterialPageRoute(builder: (context) => notifications()),
                );
              },
              child: Stack(
                children: <Widget>[
                  Icon(Icons.notifications, ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                      constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                      child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
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
              text: "Patient's Meals", icon: Image.asset("assets/fitness_app/meals.png",
                width: 24,
                height:24,),
            ),
            Tab(
              text: "Patient's Exercises", icon: Image.asset("assets/fitness_app/exercises.png",
                width: 24,
                height:24)
            ),
            Tab(
              text: "Patient's Weight", icon: Image.asset("assets/fitness_app/weight.png",
              width: 24,
              height:24,),
            ),
            Tab(
              text: "Patient's Water", icon: Image.asset("assets/fitness_app/water.png",
              width: 24,
              height:24,),
            ),
            Tab(
              text: "Patient's Sleep", icon: Image.asset("assets/fitness_app/sleep.png",
              width: 24,
              height:24,),
            ),
            Tab(
              text: "Patient's Stress", icon: Image.asset("assets/fitness_app/stress.png",
              width: 24,
              height:24,),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          tabBody = meals(animationController: animationController),
          tabBody = my_exercises(animationController: animationController),
          tabBody = my_weight_doctor(animationController: animationController),
          tabBody = my_water(animationController: animationController),
          tabBody = my_sleep(animationController: animationController),
          tabBody = my_stress(animationController: animationController),
        ],
      ),
    );

  }

}
