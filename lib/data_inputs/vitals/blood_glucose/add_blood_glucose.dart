import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_glucose/blood_glucose.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure/blood_pressure.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../laboratory_results/lab_results.dart';
import '../../medicine_intake/medication_patient_view.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_blood_glucose extends StatefulWidget {
  final List<Blood_Glucose> thislist;
  add_blood_glucose({this.thislist});
  @override
  _add_blood_glucoseState createState() => _add_blood_glucoseState();
}
final _formKey = GlobalKey<FormState>();
class _add_blood_glucoseState extends State<add_blood_glucose> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double glucose = 0;
  String unitstatus = '';
  DateTime glucoseDate;
  String glucose_date = (new DateTime.now()).toString();
  String glucose_time;
  bool isDateSelected= false;
  int count = 0;
  List<Blood_Glucose> glucose_list = new List<Blood_Glucose>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  String unitStatus = "mmol/L";
  String glucose_status = "";
  var dateValue = TextEditingController();
  var unitValue = TextEditingController();
  List <bool> isSelected = [true, false];

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
                    'Add Blood Glucose Level',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          // controller: unitValue,
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
                            hintText: "Blood Glucose Level",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Blood Glucose Level' : null,
                          onChanged: (val){
                            setState(() => glucose = double.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 8,),
                      ToggleButtons(
                        isSelected: isSelected,
                        highlightColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        children: <Widget> [
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('mmol/L')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('mg/dL')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelected.length; index++){
                              if (index == newIndex) {
                                isSelected[index] = true;
                                print("mmol/L");
                              } else {
                                isSelected[index] = false;
                                print("mg/dL");
                              }
                            }
                            // if(newIndex == 0 && unitStatus != "mmol/L"){
                            if(newIndex == 0){
                              print("mmol/L");
                              unitStatus = "mmol/L";
                              // unitValue.text = glucose.toStringAsFixed(2);
                              // print(glucose.toStringAsFixed(2));
                            }
                            // if(newIndex == 1 && unitStatus != "mg/dL"){
                            if(newIndex == 1){
                              print("mg/dL");
                              unitStatus = "mg/dL";
                              // glucose = glucose / 18;
                              // unitValue.text = glucose.toStringAsFixed(2);
                              // print(glucose.toStringAsFixed(2));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    showCursor: true,
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
                      hintText: "Status when you took your blood glucose level",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter status when you took your blood glucose level' : null,
                    onChanged: (val){
                      setState(() => unitstatus = val);
                    },
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
                        if(value != null && value != glucoseDate){
                          setState(() {
                            glucoseDate = value;
                            isDateSelected = true;
                            glucose_date = "${glucoseDate.month}/${glucoseDate.day}/${glucoseDate.year}";
                          });
                          dateValue.text = glucose_date + "\r";
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
                            glucose_time = "$hours:$min";
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
                          if(unitStatus == "mmol/L"){
                            glucose = glucose * 18;
                          }
                          print(glucose.toStringAsFixed(2));
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readGlucose = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list');
                            readGlucose.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Blood_Glucose bloodGlucose;
                              if(glucose < 80){
                                glucose_status = "low";
                              }
                              else if (glucose >= 80 && glucose <= 120){
                                glucose_status = "normal";
                              }
                              else if(glucose > 120){
                                glucose_status = "high";
                              }
                              if(datasnapshot.value == null){
                                final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + 0.toString());
                                glucoseRef.set({"glucose": glucose.toString(), "unit_status": unitstatus.toString(),"glucose_status": glucose_status.toString(), "bloodGlucose_date": glucose_date.toString(), "bloodGlucose_time": glucose_time.toString()});
                                print("Added Blood Glucose Successfully! " + uid);
                              }
                              else{
                                // String tempGlucose = "";
                                // String tempStatus = "";
                                // String tempGlucoseStatus = "";
                                // String tempGlucoseDate = "";
                                // String tempGlucoseTime = "";
                                //
                                // for(var i = 0; i < temp.length; i++){
                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                //   List<String> splitFull = full.split(" ");
                                //   switch(i%5){
                                //     case 0: {
                                //       tempGlucose = splitFull.last;
                                //     }
                                //     break;
                                //     case 1: {
                                //       tempGlucoseTime = splitFull.last;
                                //     }
                                //     break;
                                //     case 2: {
                                //       tempStatus = splitFull.last;
                                //     }
                                //     break;
                                //     case 3: {
                                //       tempGlucoseStatus = splitFull.last;
                                //     }
                                //     break;
                                //     case 4: {
                                //       tempGlucoseDate = splitFull.last;
                                //       bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), bloodGlucose_unit: tempStatus, bloodGlucose_status: tempGlucoseStatus, bloodGlucose_date: format.parse(tempGlucoseDate),bloodGlucose_time: timeformat.parse(tempGlucoseTime));
                                //       glucose_list.add(bloodGlucose);
                                //     }
                                //     break;
                                //   }
                                // }
                                getBloodGlucose();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = glucose_list.length--;
                                  print("count " + count.toString());
                                  final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + count.toString());
                                  glucoseRef.set({"glucose": glucose.toString(), "unit_status": unitstatus.toString(),"glucose_status": glucose_status.toString(), "bloodGlucose_date": glucose_date.toString(), "bloodGlucose_time": glucose_time.toString()});
                                  print("Added Blood Glucose Successfully! " + uid);
                                });

                                };


                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              glucose_list.add(new Blood_Glucose(glucose: glucose, bloodGlucose_unit: unitstatus, bloodGlucose_status: glucose_status, bloodGlucose_date: format.parse(glucose_date), bloodGlucose_time: timeformat.parse(glucose_time)));
                              for(var i=0;i<glucose_list.length/2;i++){
                                var temp = glucose_list[i];
                                glucose_list[i] = glucose_list[glucose_list.length-1-i];
                                glucose_list[glucose_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, glucose_list);
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
  void getBloodGlucose() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBC = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/');
    readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        glucose_list.add(Blood_Glucose.fromJson(jsonString));
      });
    });
  }
}