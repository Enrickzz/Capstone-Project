import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:my_app/goal_tab/sleep/change_sleep_goal.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/users.dart';
import 'package:my_app/ui_view/meals/meals_list_view.dart';

import '../Sleep_StackedBarChart.dart';


class time_asleep_doctor extends StatefulWidget {

  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbitToken;
  const time_asleep_doctor({Key key, this.animationController, this.animation, this.fitbitToken})
      : super(key: key);
  @override
  State<time_asleep_doctor> createState() => _time_asleepState();
}

class _time_asleepState extends State<time_asleep_doctor> {
  final DateTime now = DateTime.now();
  Oxygen latestSleep = new Oxygen();
  Sleep_Goal sleepGoal = new Sleep_Goal();
  String time_asleep_hr = "";
  String time_asleep_min = "";
  String sleep_goal_hr = "";
  String sleep_goal_min = "";
  String to_go_hr = "";
  String to_go_min = "";
  DateTime timeAsleep;
  DateTime sleepgoal;
  List<Oxygen> sleep_list = [];
  List<OrdinalSales> rem=[];
  List<OrdinalSales> light=[];
  List<OrdinalSales> deep=[];
  List<OrdinalSales> wake=[];


  @override
  void initState() {
    super.initState();
    getLatestSleep();
    getSleepGoal();
    Future.delayed(const Duration(milliseconds: 1500),(){
      setState(() {
        to_go_hr = sleepgoal.difference(timeAsleep).inHours.toString();
        to_go_min = (sleepgoal.difference(timeAsleep).inMinutes % 60).toString();
        print("Set State");
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      time_asleep_hr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'hr',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      time_asleep_min,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'min',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          to_go_hr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' hr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' '+ to_go_min,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' min',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1, bottom: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'to go to meet your goal!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 4, top: 0),
                                    child: Text(
                                      'time asleep',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: FitnessAppTheme.darkText),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 8, bottom: 8),
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.background,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 8, bottom: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            sleep_goal_hr + ' hr ' + sleep_goal_min + ' min',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: FitnessAppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              'Sleep goal',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(context: context,
                                                isScrollControlled: true,
                                                builder: (context) => SingleChildScrollView(child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: MediaQuery.of(context).viewInsets.bottom),
                                                  child: change_sleep_goal(),
                                                ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Edit Goal',
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontSize: 16,
                                                color: FitnessAppTheme.nearlyDarkBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void getLatestSleep() async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=1"),
        headers: {
          'Authorization': "Bearer "+ widget.fitbitToken
        });
    List<Oxygen> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    if(sleep[0].dateOfSleep == "${now.year}-${now.month.toString().padLeft(2,"0")}-${now.day.toString().padLeft(2,"0")}"){
      latestSleep = sleep[0];
      Duration duration = new Duration(milliseconds: latestSleep.duration);
      getTimeAsleep(duration);
      time_asleep_hr = duration.inHours.toString();
    }
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
  }

  void getTimeAsleep(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    time_asleep_hr = "${twoDigits(duration.inHours)}";
    time_asleep_min = "$twoDigitMinutes";
    timeAsleep = new DateTime(now.year,now.month,now.day,int.parse(time_asleep_hr), int.parse(time_asleep_min));
    // timeAsleep.hour = time_asleep_hr;
    // timeAsleep.minute = time_asleep_min;
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void getSleepGoal() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWaterIntake = databaseReference.child('users/' + uid + '/goal/sleep_goal/');
    readWaterIntake.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      sleepGoal = Sleep_Goal.fromJson(temp);
      print("SLEEP GOAL");
      print(sleepGoal.duration);
      Duration duration = new Duration(minutes: sleepGoal.duration);
      print(duration.toString());
      getSleepGoalDuration(duration);
    });
  }
  void getSleepGoalDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    sleep_goal_hr = "${twoDigits(duration.inHours)}";
    sleep_goal_min = "$twoDigitMinutes";
    sleepgoal = new DateTime(now.year,now.month,now.day,int.parse(sleep_goal_hr), int.parse(sleep_goal_min));
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  void getSleep() async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer "+ widget.fitbitToken
        });
    List<Oxygen> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleep_list = sleep;

    String a;
    for(var i = 0 ; i < sleep_list.length ; i ++){
      rem.add(new OrdinalSales("", 0));
      deep.add(new OrdinalSales("", 0));
      light.add(new OrdinalSales("", 0));
      wake.add(new OrdinalSales("", 0));
      print("i is ");
      print(i);
      for(var j = 0 ; j < sleep[i].levels.data.length; j++){
        a = sleep[i].levels.data[j].dateTime;
        a = a.substring(0, a.indexOf("T"));
        print("j is ");
        print(j);
        print("date");
        print(a);
        print("DATA");
        print(sleep[i].levels.data[j].seconds);
        print("LEVEL");
        print(sleep[i].levels.data[j].level);
        rem[i].date = a;
        deep[i].date = a;
        light[i].date = a;
        wake[i].date = a;
        if(sleep[i].levels.data[j].level == "rem" || sleep[i].levels.data[j].level == "restless"){
          rem[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "deep" || sleep[i].levels.data[j].level  == "asleep"){
          deep[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "light" || sleep[i].levels.data[j].level  == "restless"){
          light[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "wake" || sleep[i].levels.data[j].level  == "awake"){
          wake[i].sales += sleep[i].levels.data[j].seconds;
        }
      }
    }
  }

}
