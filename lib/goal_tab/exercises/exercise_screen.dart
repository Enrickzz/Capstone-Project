import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/add_blood_pressure.dart';
import 'package:my_app/models/ExRxApi.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/goal_tab/exercises/view_exrx.dart';
import 'package:my_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/ui_view/BMI_chart.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  Exercise_screen_state createState() => Exercise_screen_state();
}

final _formKey = GlobalKey<FormState>();
List<ExercisesTest> listexercises=[];


class Exercise_screen_state extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String search="";
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();


  double topBarOpacity = 0.0;
  @override
  void initState() {

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

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
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      GridImages(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Row(
            children: [
              SizedBox(width: 36),
              Image.asset(
                  "assets/images/exrx.png",
                  width: 90
              ),
              SizedBox(width: 8),
              const Text('Exercises', style: TextStyle(
                  color: Colors.black
              )),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction, key: _formKey,
                    child: Row (
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search here',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                filled: true,
                                errorStyle: TextStyle(fontSize: 15),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                              ),
                              onChanged: (val) {
                                setState(() => search = val);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Text('Search', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            onPressed: () async{
                              await getExercises(search).then((value) => setState((){
                                listexercises=value;
                                FocusScope.of(context).requestFocus(FocusNode());
                              }));

                              final queryParameters = {
                                'exercisename': '$search',
                              };
                              // var uri =
                              // Uri.https('204.235.60.194', 'exrxapi/v1/allinclusive/exercises?', queryParameters);
                              // var response = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$search"),
                              //     headers: {
                              //   'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8yMDQuMjM1LjYwLjE5NFwvZnVzaW9cL3B1YmxpY1wvaW5kZXgucGhwIiwic3ViIjoiNDhiZmE2OTItYzIyZi01NmM1LThjYzYtNjEyZjBjZjZhZTViIiwiaWF0IjoxNjM5OTg1MDc1LCJleHAiOjE2Mzk5ODg2NzUsIm5hbWUiOiJsb3Vpc2V4cngifQ.y277OFo5gHGma1jCKU022ofm9ouDLsEdHgkRsdzyqJ0",
                              // });
                              // print("THIS\n" +response.body.toString());
                            },
                          ),
                        ]
                    )),
              )
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 90),
          itemCount: listexercises.length,
          itemBuilder: (context, index){
            return Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        Container(
                            height: 230,
                            child: Stack(
                                children: [
                                  Positioned(
                                      top: 35,
                                      left: 5,
                                      child: Material(

                                        child: Container(
                                            height: 180.0,
                                            width: 340,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    blurRadius: 20.0)],
                                            )
                                        ),

                                      )),
                                  Positioned(
                                      top: 0,
                                      left: 13,
                                      child: Card(
                                          elevation: 10.0,
                                          shadowColor: Colors.grey.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            height: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                    fit:BoxFit.cover,
                                                    image: NetworkImage("https:"+listexercises[index].largImg1)
                                                )
                                            ),
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top:45,
                                      left: 175,
                                      child: Container(
                                        height: 150,
                                        width: 160,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(listexercises[index].exerciseName,
                                                style: TextStyle(
                                                    fontSize:18,
                                                    color:Color(0xFF363f93),
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              // Text(listexercises[index].exerciseId.toString(),
                                              //   style: TextStyle(
                                              //       fontSize:16,
                                              //       color:Colors.grey,
                                              //       fontWeight: FontWeight.bold
                                              //   ),),
                                              Divider(color: Colors.blue),
                                              Text("" + listexercises[index].apparatusName,
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),
                                              Text("" + listexercises[index].apparatusAbbreviation,
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),

                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20))),
                                                child: Text('View Exercise', style: TextStyle(fontSize: 10),),
                                                onPressed: () {
                                                  showModalBottomSheet(context: context,
                                                    isScrollControlled: true,
                                                    builder: (context) => SingleChildScrollView(child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                                      child: view_exrx(exercise: listexercises[index]),
                                                    ),
                                                    ),
                                                  );
                                                },
                                              )
                                            ]
                                        ),
                                      ))
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            );
          },
        ) ,
        backgroundColor: Colors.transparent,
      ),

    );
  }



  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),

                ),
              ),
            );
          },
        )
      ],
    );
  }
  Future<List<ExercisesTest>> getExercises(String query) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    var response = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
        headers: {
          'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8yMDQuMjM1LjYwLjE5NFwvZnVzaW9cL3B1YmxpY1wvaW5kZXgucGhwIiwic3ViIjoiNDhiZmE2OTItYzIyZi01NmM1LThjYzYtNjEyZjBjZjZhZTViIiwiaWF0IjoxNjQyMjMwNzI4LCJleHAiOjE2NDIyMzQzMjgsIm5hbWUiOiJsb3Vpc2V4cngifQ.UQTc87klxqURIu4xdo-qt9M0RlEzYUyrz2-cp5l4Fm4",
        });
    List<ExercisesTest> exers=[];
    exers = ExRxTest.fromJson(jsonDecode(response.body)).exercises;
    print("EXERS LENGTH " + exers.length.toString());
    for(var i =0; i < exers.length; i++){
      print("EXER NAME = "  + exers[i].exerciseName);
      print("IMG = " + exers[i].largImg1);
    }
    listexercises= exers;
    return exers;
  }
}