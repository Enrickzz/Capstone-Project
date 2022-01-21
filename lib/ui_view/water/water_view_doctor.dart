import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/goal_tab/water/change_water_intake_goal.dart';
import 'package:my_app/goal_tab/water/change_water_intake_goal_doctor.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/ui_view/water/wave_view.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';

class WaterViewDoctor extends StatefulWidget {
  const WaterViewDoctor(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.userUID})
      : super(key: key);
  final String userUID;
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _WaterViewDoctorState createState() => _WaterViewDoctorState();
}

class _WaterViewDoctorState extends State<WaterViewDoctor> with TickerProviderStateMixin {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  Water_Goal water_goal = new Water_Goal();
  List<WaterIntake> waterintake_list = [];
  double total_water = 0;
  double waterintake_goal = 0;
  double waterpercentage = 0;
  String lastDrink = "00:00";

  @override
  void initState() {
    super.initState();
    getWaterGoal();
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("setstate");
      });
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 3),
                                      child: Text(
                                        total_water.toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8),
                                      child: Text(
                                        'ml',
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, top: 2, bottom: 14),
                                  child: Text(
                                    'of your daily goal '+waterintake_goal.toStringAsFixed(0)+' ml',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: FitnessAppTheme.darkText,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(context: context,
                                        isScrollControlled: true,
                                        builder: (context) => SingleChildScrollView(child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: change_water_intake_goal_doctor(),
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
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 8, bottom: 16),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.background,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.access_time,
                                          color: FitnessAppTheme.grey
                                              .withOpacity(0.5),
                                          size: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Last drink '+ lastDrink,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.grey
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Image.asset(
                                              'assets/fitness_app/bell.png'),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'You have reached your daily water intake goal!',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              letterSpacing: 0.0,
                                              color: HexColor('#F65283'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: 34,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           color: FitnessAppTheme.nearlyWhite,
                      //           shape: BoxShape.circle,
                      //           boxShadow: <BoxShadow>[
                      //             BoxShadow(
                      //                 color: FitnessAppTheme.nearlyDarkBlue
                      //                     .withOpacity(0.4),
                      //                 offset: const Offset(4.0, 4.0),
                      //                 blurRadius: 8.0),
                      //           ],
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(6.0),
                      //           child: Icon(
                      //             Icons.add,
                      //             color: FitnessAppTheme.nearlyDarkBlue,
                      //             size: 24,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 28,
                      //       ),
                      //       Container(
                      //         decoration: BoxDecoration(
                      //           color: FitnessAppTheme.nearlyWhite,
                      //           shape: BoxShape.circle,
                      //           boxShadow: <BoxShadow>[
                      //             BoxShadow(
                      //                 color: FitnessAppTheme.nearlyDarkBlue
                      //                     .withOpacity(0.4),
                      //                 offset: const Offset(4.0, 4.0),
                      //                 blurRadius: 8.0),
                      //           ],
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(6.0),
                      //           child: Icon(
                      //             Icons.remove,
                      //             color: FitnessAppTheme.nearlyDarkBlue,
                      //             size: 24,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 8, top: 16),
                        child: Container(
                          width: 80,
                          height: 160,
                          decoration: BoxDecoration(
                            color: HexColor('#E8EDFE'),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                                bottomLeft: Radius.circular(80.0),
                                bottomRight: Radius.circular(80.0),
                                topRight: Radius.circular(80.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4),
                            ],
                          ),
                          child: WaveView(
                            percentageValue: waterpercentage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void getWaterGoal () {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readWaterGoal = databaseReference.child('users/' + userUID + '/goal/water_goal/');
    final readWater = databaseReference.child('users/' + userUID + '/goal/water_intake/');
    DateTime now = DateTime.now();
    String datenow = "${now.month.toString().padLeft(2, "0")}/${now.day.toString().padLeft(2, "0")}/${now.year}";
    readWaterGoal.once().then((DataSnapshot snapshot){
      readWater.once().then((DataSnapshot datasnapshot) {
        print("LAST DRINK UPDATED");
        Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
        water_goal = Water_Goal.fromJson(temp);
        waterintake_goal = water_goal.water_goal;
        List<dynamic> temp2 = jsonDecode(jsonEncode(datasnapshot.value));
        temp2.forEach((jsonString) {
          waterintake_list.add(WaterIntake.fromJson(jsonString));
        });
        for(int i=0; i < waterintake_list.length; i++){
          String datecreated = "${waterintake_list[i].dateCreated.month.toString().padLeft(2, "0")}/${waterintake_list[i].dateCreated.day.toString().padLeft(2,"0")}/${waterintake_list[i].dateCreated.year}";
          if(datenow == datecreated){
            total_water += waterintake_list[i].water_intake;
          }
        }
        waterpercentage = double.parse((total_water/ waterintake_goal * 100).toStringAsFixed(1));
        /// getting the latest water
        var latestDate;
        List<WaterIntake> timesortwater = [];
        waterintake_list.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));
        if(waterintake_list.length != 1){
          if(waterintake_list[waterintake_list.length-1].dateCreated == waterintake_list[waterintake_list.length-2].dateCreated){
            latestDate = waterintake_list[waterintake_list.length-1].dateCreated;
            for(int i = 0; i < waterintake_list.length; i++){
              if(waterintake_list[i].dateCreated == latestDate){
                timesortwater.add(waterintake_list[i]);
              }
            }
            timesortwater.sort((a,b) => a.timeCreated.compareTo(b.timeCreated));
            lastDrink = "${timesortwater[timesortwater.length-1].timeCreated.hour.toString().padLeft(2,'0')}:${timesortwater[timesortwater.length-1].timeCreated.minute.toString().padLeft(2,'0')}";
            print("LAST DRINK UPDATED");
            readWaterGoal.update({"current_water": timesortwater[timesortwater.length-1].water_intake.toStringAsFixed(1)});
          }
          else{
            timesortwater = waterintake_list;
            lastDrink = "${timesortwater[timesortwater.length-1].timeCreated.hour.toString().padLeft(2,'0')}:${timesortwater[timesortwater.length-1].timeCreated.minute.toString().padLeft(2,'0')}";
            print("LAST DRINK UPDATED");
            readWaterGoal.update({"current_water": timesortwater[timesortwater.length-1].water_intake.toStringAsFixed(1)});
          }
        }
        else{
          lastDrink = "${waterintake_list[waterintake_list.length-1].timeCreated.hour.toString().padLeft(2,'0')}:${waterintake_list[waterintake_list.length-1].timeCreated.minute.toString().padLeft(2,'0')}";
          print("LAST DRINK UPDATED");
        }

      });
    });
  }
}
