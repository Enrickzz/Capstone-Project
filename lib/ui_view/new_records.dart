import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';

import 'meals/meals_list_view.dart';

class new_records extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final String userUID;

  const new_records(
      {Key key, this.animationController, this.animation, this.userUID})
      : super(key: key);

  @override
  _new_recordsState createState() => _new_recordsState();
}

class _new_recordsState extends State<new_records> {

  bool newbloodpressure = false;
  bool newbloodglucose = false;
  bool newoxygensaturation = false;
  bool newheartrate = false;
  List<Blood_Pressure> bp_list = [];
  List<Blood_Glucose> bg_list = [];
  List<Oxygen_Saturation> o2_list = [];
  List<Heart_Rate> hr_list = [];
  bool ifShow = false;
  @override
  void initState() {
    super.initState();
    bp_list.clear();
    bg_list.clear();
    o2_list.clear();
    hr_list.clear();
    getRecords();
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {

      });
    });



  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
        child: AnimatedBuilder(
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
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                        ),
                        height: 25,
                        child: Container(
                          child: Text(
                            'There are new records on:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newbloodpressure,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Blood Pressure',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newbloodglucose,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Blood Glucose',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newoxygensaturation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Oxygen Saturation',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newheartrate,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Heart Rate',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
  void getRecords() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readHR = databaseReference.child('users/' + userUID + '/vitals/health_records/heartrate_list/');
    final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/bp_list/');
    final glucoseRef = databaseReference.child('users/' + userUID + '/vitals/health_records/blood_glucose_list/');
    final oxygenRef = databaseReference.child('users/' + userUID + '/vitals/health_records/oxygen_saturation_list/');
    readHR.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        hr_list.add(Heart_Rate.fromJson(jsonString));
      });
      if(hr_list != null){
        for(int i = 0; i < hr_list.length; i++){
          if(hr_list[i].new_hr != null){
            if(hr_list[i].new_hr == true){
              newheartrate = hr_list[i].new_hr;
            }
            final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/heartrate_list/' + (i+1).toString());
            bpRef.update({"new_hr": false});
          }
        }
      }
    });
    bpRef.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bp_list.add(Blood_Pressure.fromJson(jsonString));
      });
      if(bp_list != null){
        for(int i = 0; i < bp_list.length; i++){
          if(bp_list[i].new_bp != null){
            if(bp_list[i].new_bp == true){
              newbloodpressure = bp_list[i].new_bp;
            }
            final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/bp_list/' + (i+1).toString());
            bpRef.update({"new_bp": false});
          }
        }
      }
    });
    glucoseRef.once().then((DataSnapshot bgsnapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(bgsnapshot.value));
      temp.forEach((jsonString) {
        bg_list.add(Blood_Glucose.fromJson(jsonString));
      });
      if(bg_list != null){
        for(int i = 0; i < bg_list.length; i++){
          if(bg_list[i].new_glucose != null){
            if(bg_list[i].new_glucose == true){
              newbloodglucose = bg_list[i].new_glucose;
            }
            final bgRef = databaseReference.child('users/' + userUID + '/vitals/health_records/blood_glucose_list/' + (i+1).toString());
            bgRef.update({"new_glucose": false});
          }
        }
      }
    });

    oxygenRef.once().then((DataSnapshot o2snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(o2snapshot.value));
      temp.forEach((jsonString) {
        o2_list.add(Oxygen_Saturation.fromJson(jsonString));
      });
      if(o2_list != null){
        for(int i = 0; i < o2_list.length; i++){
          if(o2_list[i].new_o2 != null){
            if(o2_list[i].new_o2 == true){
              newoxygensaturation = o2_list[i].new_o2;
            }
            final bpRef = databaseReference.child('users/' + userUID + '/vitals/health_records/oxygen_saturation_list/' + (i+1).toString());
            bpRef.update({"new_o2": false});
          }
        }
      }
    });
  }
}

