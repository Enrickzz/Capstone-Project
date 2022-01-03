import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/blood_pressure.dart';
import 'package:my_app/data_inputs/vitals/heart_rate/heart_rate.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../laboratory_results/lab_results.dart';
import '../../medicine_intake/medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_heart_rate extends StatefulWidget {
  final List<Heart_Rate> thislist;
  add_heart_rate({this.thislist});
  @override
  _add_heart_rateState createState() => _add_heart_rateState();
}
final _formKey = GlobalKey<FormState>();
class _add_heart_rateState extends State<add_heart_rate> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int beats = 0;
  String isResting = 'false';
  DateTime heartRateDate;
  String heartRate_date = (new DateTime.now()).toString();
  String heartRate_time;
  String hr_status ="";
  bool isDateSelected= false;
  int count = 0;
  List<Heart_Rate> heartRate_list = new List<Heart_Rate>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  var heartRateValue = TextEditingController();

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
                    'Add Heart Rate',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: heartRateValue,
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
                      hintText: "Number of Beats (15 seconds x 4)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Number of Beats' : null,
                    onChanged: (val){

                      setState(() =>

                      beats = int.parse(val));
                    },
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget> [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Did you just finish exercising?",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: defaultFontSize),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio(
                                value: "Yes",
                                groupValue: isResting,
                                onChanged: (value){
                                  setState(() {
                                    this.isResting = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Text("Yes"),
                          SizedBox(width: 16),
                          Radio(
                            value: "No",
                            groupValue: isResting,
                            onChanged: (value){
                              setState(() {
                                this.isResting = value;
                              });
                            },
                          ),
                          Text("No"),
                          SizedBox(width: 16)
                        ],
                      )
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
                        if(value != null && value != heartRateDate){
                          setState(() {
                            heartRateDate = value;
                            isDateSelected = true;
                            heartRate_date = "${heartRateDate.month}/${heartRateDate.day}/${heartRateDate.year}";
                          });
                          dateValue.text = heartRate_date + "\r";
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
                            heartRate_time = "$hours:$min";
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
                          Navigator.pop(context, widget.thislist);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                         beats *= 4;
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readHeartRate = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list');
                            readHeartRate.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Heart_Rate heartRate;
                              if(datasnapshot.value == null){
                                final heartRateRef = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/' + 0.toString());
                                if(isResting.toLowerCase() =='yes'){
                                  hr_status = "Active";
                                }
                                else{
                                  hr_status = "Resting";
                                }
                                heartRateRef.set({"HR_bpm": beats.toString(), "hr_status": hr_status, "hr_date": heartRate_date.toString(), "hr_time": heartRate_time.toString()});
                                print("Added Heart Rate Successfully! " + uid);
                              }
                              else{
                                // String tempbeats = "";
                                // String tempisResting;
                                // String tempHeartRateDate;
                                // String tempHeartRateTime;
                                // print(temp.length);
                                // for(var i = 0; i < temp.length; i++){
                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                //   List<String> splitFull = full.split(" ");
                                //     switch(i%4){
                                //       case 0: {
                                //         print("2nd switch i = " + i.toString() + splitFull.last);
                                //         tempHeartRateTime = splitFull.last;
                                //       }
                                //       break;
                                //       case 1: {
                                //         print("2nd switch i = " + i.toString() + splitFull.last);
                                //         tempbeats = splitFull.last;
                                //       }
                                //       break;
                                //       case 2: {
                                //         print("2nd switch i = " + i.toString() + splitFull.last);
                                //         tempisResting = splitFull.last;
                                //       }
                                //       break;
                                //       case 3: {
                                //         print("2nd switch i = " + i.toString() + splitFull.last);
                                //         tempHeartRateDate = splitFull.last;
                                //         heartRate = new Heart_Rate(bpm: int.parse(tempbeats), hr_status: tempisResting, hr_date: format.parse(tempHeartRateDate), hr_time: timeformat.parse(tempHeartRateTime));
                                //         heartRate_list.add(heartRate);
                                //       }
                                //       break;
                                //     }
                                // }
                                getHeartRate();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = heartRate_list.length--;
                                  print("count " + count.toString());
                                  if(isResting.toLowerCase() =='yes'){
                                    hr_status = "Active";
                                  }
                                  else{
                                    hr_status = "Resting";
                                  }
                                  final heartRateRef = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/' + count.toString());
                                  heartRateRef.set({"HR_bpm": beats.toString(), "hr_status": hr_status, "hr_date": heartRate_date.toString(), "hr_time": heartRate_time.toString()});
                                  print("Added Heart Rate Successfully! " + uid);
                                });

                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + heartRate_list.length.toString());
                              heartRate_list.add(new Heart_Rate(bpm: beats, hr_status: hr_status, hr_date: format.parse(heartRate_date),hr_time: timeformat.parse(heartRate_time)));
                              for(var i=0;i<heartRate_list.length/2;i++){
                                var temp = heartRate_list[i];
                                heartRate_list[i] = heartRate_list[heartRate_list.length-1-i];
                                heartRate_list[heartRate_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, heartRate_list);
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
  bool parseBool(String temp) {
    if (temp.toLowerCase() == 'yes') {
      return false;
    } else if (temp.toLowerCase() == 'no') {
      return true;
    }
    else{
      print("error parsing bool");
    }
  }
  void getHeartRate() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readHR = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/');
    readHR.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        heartRate_list.add(Heart_Rate.fromJson(jsonString));
      });
    });
  }
}
