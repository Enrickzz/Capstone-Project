import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/blood_pressure_patient_view.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../../notifications.dart';
import '../../laboratory_results/lab_results_patient_view.dart';
import '../../medicine_intake/medication_patient_view.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_blood_pressure extends StatefulWidget {
  final List<Blood_Pressure> thislist;
  add_blood_pressure({this.thislist});
  @override
  _add_blood_pressureState createState() => _add_blood_pressureState();
}
final _formKey = GlobalKey<FormState>();
class _add_blood_pressureState extends State<add_blood_pressure> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String systolic_pressure = '';
  String diastolic_pressure = '';
  String pressure_level = "";
  DateTime bpDate;
  String bp_time;
  String bp_date = (new DateTime.now()).toString();
  int count = 0;
  bool isDateSelected= false;
  List<Blood_Pressure> bp_list = new List<Blood_Pressure>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List<Notifications> notifsList = new List<Notifications>();
  List<Recommendation> recommList = new List<Recommendation>();

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Container(
        key: _formKey,
        color:Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
                topRight:Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Add Blood Pressure',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width:0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize),
                            hintText: "Systolic Pressure",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Systolic Pressure' : null,
                          onChanged: (val){
                            setState(() => systolic_pressure = val);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text('/'),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                width:0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize),
                            hintText: "Diastolic Pressure",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Diastolic Pressure' : null,
                          onChanged: (val){
                            setState(() => diastolic_pressure = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100)
                      ).then((value){
                        if(value != null && value != bpDate){
                          setState(() {
                            bpDate = value;
                            isDateSelected = true;
                            bp_date = "${bpDate.month}/${bpDate.day}/${bpDate.year}";
                          });
                          dateValue.text = bp_date + "\r";
                        }
                      });

                      final initialTime = TimeOfDay(hour:12, minute: 0);
                      await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: TimeOfDay.now().hour,
                            minute: (TimeOfDay.now().minute - TimeOfDay.now().minute % 10 + 10)
                                .toInt()),
                      ).then((value){
                        if(value != null && value != time){
                          setState(() {
                            time = value;
                            final hours = time.hour.toString().padLeft(2,'0');
                            final min = time.minute.toString().padLeft(2,'0');
                            bp_time = "$hours:$min";
                            dateValue.text += "$hours:$min";
                            print("data value " + dateValue.text);
                          });
                        }
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dateValue,
                        showCursor: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width:0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "Date and Time",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select Date and Time' : null,
                        onChanged: (val){

                          print(dateValue);
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list');
                            readBP.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Blood_Pressure bloodPressure;
                              if(datasnapshot.value == null){
                                if(int.parse(systolic_pressure) < 90 || int.parse(diastolic_pressure) < 60){
                                  pressure_level = "low";
                                  print(pressure_level);
                                }
                                else if (int.parse(systolic_pressure) <= 120 && int.parse(systolic_pressure) >= 90 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                  pressure_level = "normal";
                                  print(pressure_level);
                                }
                                else if (int.parse(systolic_pressure) <= 129 && int.parse(systolic_pressure) >= 120 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                  pressure_level = "elevated";
                                  print(pressure_level);
                                }
                                else if (int.parse(systolic_pressure) > 130  || int.parse(diastolic_pressure) > 80){
                                  pressure_level = "high";
                                  print(pressure_level);
                                }
                                final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + 0.toString());
                                bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),"pressure_level": pressure_level.toString(),  "bp_date": bp_date.toString(), "bp_time":bp_time.toString()});
                                print("Added medication Successfully! " + uid);
                              }
                              else{
                                if(int.parse(systolic_pressure) < 90 || int.parse(diastolic_pressure) < 60){
                                  pressure_level = "low";
                                  print(pressure_level);
                                }
                                else if (int.parse(systolic_pressure) <= 120 && int.parse(systolic_pressure) >= 90 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                  pressure_level = "normal";
                                  print(pressure_level);
                                }
                                else if (int.parse(systolic_pressure) <= 129 && int.parse(systolic_pressure) >= 120 && int.parse(diastolic_pressure) <= 80 && int.parse(diastolic_pressure) >= 60){
                                  pressure_level = "elevated";
                                  print(pressure_level);
                                }
                                else if (int.parse(systolic_pressure) >= 130  || int.parse(diastolic_pressure) > 80){
                                  pressure_level = "high";
                                  print(pressure_level);
                                }
                                getBloodPressure();
                                Future.delayed(const Duration(milliseconds: 1500), (){
                                  // count = bp_list.length--;
                                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + (bp_list.length--).toString());
                                  bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),"pressure_level": pressure_level.toString(),  "bp_date": bp_date.toString(), "bp_time":bp_time.toString()});
                                  print("Added Blood Pressure Successfully! " + uid);
                                });

                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + bp_list.length.toString());
                              String message, title;
                              int priority;
                              bp_list.add(new Blood_Pressure(systolic_pressure: systolic_pressure, diastolic_pressure: diastolic_pressure,pressure_level: pressure_level, bp_date: format.parse(bp_date), bp_time: timeformat.parse(bp_time)));
                              for(var i=0;i<bp_list.length/2;i++){
                                var temp = bp_list[i];
                                bp_list[i] = bp_list[bp_list.length-1-i];
                                bp_list[bp_list.length-1-i] = temp;
                              }
                              if(double.parse(systolic_pressure) <= 120 && double.parse(diastolic_pressure) <= 80 ){
                                print("YOU ARE NORMAL");
                                Navigator.pop(context, bp_list);
                              }else if(double.parse(systolic_pressure) > 120 &&  double.parse(systolic_pressure) < 130 && double.parse(diastolic_pressure) < 80 ){
                                print("YOUR BP IS ELEVATED!");
                                addtoNotifs("Blood Pressure is elevated", "Elevated BP", "1");
                                Navigator.pop(context, bp_list);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => mainScreen()),
                                // );
                                // Widget cancelButton = TextButton(
                                //   child: Text("Cancel"),
                                //   onPressed:  () {
                                //     Navigator.pop(context, false);
                                //   },
                                // );
                                // Widget continueButton = TextButton(
                                //   child: Text("Continue"),
                                //   onPressed:  () {
                                //
                                //     },
                                // );
                                //
                                // // set up the AlertDialog
                                // AlertDialog alert = AlertDialog(
                                //   title: Text("Warning"),
                                //   content: Text("Your BP is elevated"),
                                //   actions: [
                                //     cancelButton,
                                //     continueButton,
                                //   ],
                                // );
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return alert;
                                //   },
                                // );
                              }else if(double.parse(systolic_pressure) >= 130 &&  double.parse(systolic_pressure) < 140 && double.parse(diastolic_pressure) >= 80 && double.parse(diastolic_pressure) <= 89 ){
                                print("YOU ARE ON STAGE 1 HIGH BP");
                                addtoNotifs("Blood Pressure is on Stage 1 Alert Level", "STAGE 1 HIGH BP", "2");
                                addtoRecommendation("Drink 2 glasses of water right away", "Control your ass", "2");
                                Navigator.pop(context, bp_list);
                              }else if(double.parse(systolic_pressure) >= 140 &&  double.parse(systolic_pressure) <= 180 && double.parse(diastolic_pressure) >= 90 && double.parse(diastolic_pressure) <= 119){
                                print("YOU ARE ON STAGE 2 HIGH BP");
                                addtoNotifs("Blood Pressure is on Stage 2 Alert Level", "Stage 2 High BP", "3");
                                addtoRecommendation("Drink 2 glasses of water right away", "Control your ass", "2");
                                Navigator.pop(context, bp_list);
                              }else if(double.parse(systolic_pressure) > 180 && double.parse(diastolic_pressure) >= 120 ){
                                print("YOU ARE HYPERTENSIVE");
                                addtoNotifs("Blood Pressure has reached hypertension", "Hypertensive", "4");
                                addtoRecommendation("Drink 2 glasses of water right away", "Control your ass", "2");
                                Navigator.pop(context, bp_list);
                              }
                              print("POP HERE ==========");
                            });
                          } catch(e) {
                            print("you got an error! $e");
                          }
                          // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  void addtoNotifs(String message, String title, String priority){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    getNotifs();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        notifRef.set({"message": message, "title":title, "priority": priority, "notif_time": bp_time.toString(), "notif_date": bp_date.toString(), "category": "bloodpressure"});
      }else{
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + (notifsList.length--).toString());
        notifRef.set({"message": message, "title":title, "priority": priority, "notif_time": bp_time.toString(), "notif_date": bp_date.toString(), "category": "bloodpressure"});

      }
    });
  }
  void addtoRecommendation(String message, String title, String priority){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"message": message, "title":title, "priority": priority, "rec_time": bp_time.toString(), "rec_date": bp_date.toString(), "category": "bprecommend"});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"message": message, "title":title, "priority": priority, "rec_time": bp_time.toString(), "rec_date": bp_date.toString(), "category": "bprecommend"});

      }
    });
  }
  void getBloodPressure() {
    bp_list.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bp_list.add(Blood_Pressure.fromJson(jsonString));
      });
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
        notifsList.add(Notifications.fromJson(jsonString));
      });
    });
  }
  void getRecomm() {
    recommList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(Recommendation.fromJson(jsonString));
      });
    });
  }

}