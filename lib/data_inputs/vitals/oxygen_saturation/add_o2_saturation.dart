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
import '../../laboratory_results/lab_results_patient_view.dart';
import '../../medicine_intake/medication_patient_view.dart';
import 'o2_saturation_patient_view.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_o2_saturation extends StatefulWidget {
  final List<Oxygen_Saturation> o2list;
  add_o2_saturation({this.o2list});
  @override
  _add_o2_saturationState createState() => _add_o2_saturationState();
}
final _formKey = GlobalKey<FormState>();
class _add_o2_saturationState extends State<add_o2_saturation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int spo2 = 0;
  bool isDateSelected= false;
  DateTime oxygenDate;
  String oxygen_date = (new DateTime.now()).toString();
  String oxygen_time = "";
  String oxygen_status = "";
  int count = 0;
  List<Oxygen_Saturation> oxygen_list = new List<Oxygen_Saturation>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();

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
                    'Add Oxygen Saturation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),

                  TextFormField(
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
                      hintText: "Oxygen Saturation (%SpO2)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Oxygen Saturation (%SpO2)' : null,
                    onChanged: (val){
                      setState(() => spo2 = int.parse(val));
                    },
                  ),
                  SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                          context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime.now().subtract(Duration(days: 30)),
                        lastDate: new DateTime.now(),
                      ).then((value){
                        if(value != null && value != oxygenDate){
                          setState(() {
                            oxygenDate = value;
                            isDateSelected = true;
                            oxygen_date = "${oxygenDate.month}/${oxygenDate.day}/${oxygenDate.year}";
                          });
                          dateValue.text = oxygen_date + "\r";
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
                            oxygen_time = "$hours:$min";
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
                            final readOxygen = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list');
                            readOxygen.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Oxygen_Saturation oxygen;
                              if(spo2 < 90){
                                oxygen_status = "critical";
                              }
                              else if(spo2 >= 90 && spo2 <= 95){
                                oxygen_status = "alarming";
                              }
                              else if (spo2 > 95 && spo2 <= 100){
                                oxygen_status = "normal";
                              }
                              else {
                                oxygen_status = "error";
                              }
                              if(datasnapshot.value == null){
                                final oxygenRef = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/' + 0.toString());
                                oxygenRef.set({"oxygen_saturation": spo2.toString(),"oxygen_status": oxygen_status.toString(), "os_date": oxygen_date.toString(), "os_time": oxygen_time.toString()});
                                print("Added Oxygen Saturation Successfully! " + uid);
                              }
                              else{
                                // String tempOxygen = "";
                                // String tempOxygenStatus = "";
                                // String tempOxygenDate = "";
                                // String tempOxygenTime = "";
                                //
                                // for(var i = 0; i < temp.length; i++){
                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                //   List<String> splitFull = full.split(" ");
                                //   switch(i%4){
                                //     case 0: {
                                //       tempOxygen = splitFull.last;
                                //     }
                                //     break;
                                //     case 1: {
                                //       tempOxygenDate = splitFull.last;
                                //     }
                                //     break;
                                //     case 2: {
                                //       tempOxygenStatus = splitFull.last;
                                //     }
                                //     break;
                                //     case 3: {
                                //       tempOxygenTime = splitFull.last;
                                //       oxygen = new Oxygen_Saturation(oxygen_saturation: int.parse(tempOxygen),oxygen_status: tempOxygenStatus, os_date: format.parse(tempOxygenDate), os_time: timeformat.parse(tempOxygenTime));
                                //       oxygen_list.add(oxygen);
                                //     }
                                //     break;
                                //   }
                                // }
                                getOxygenSaturation();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = oxygen_list.length--;
                                  print("count " + count.toString());
                                  //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                  // symptoms_list.add(symptom);

                                  // print("symptom list  " + symptoms_list.toString());
                                  final oxygenRef = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/' + count.toString());
                                  oxygenRef.set({"oxygen_saturation": spo2.toString(),"oxygen_status": oxygen_status.toString(), "os_date": oxygen_date.toString(), "os_time": oxygen_time.toString()});
                                  print("Added Oxygen Saturation Successfully! " + uid);
                                });

                              }

                            });

                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + oxygen_list.length.toString());
                              oxygen_list.add(new Oxygen_Saturation(oxygen_saturation: spo2,oxygen_status: oxygen_status, os_date: format.parse(oxygen_date), os_time: timeformat.parse(oxygen_time)));
                              for(var i=0;i<oxygen_list.length/2;i++){
                                var temp = oxygen_list[i];
                                oxygen_list[i] = oxygen_list[oxygen_list.length-1-i];
                                oxygen_list[oxygen_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, oxygen_list);
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
  void getOxygenSaturation() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readOS = databaseReference.child('users/' + uid + '/vitals/health_records/oxygen_saturation_list/');
    readOS.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        oxygen_list.add(Oxygen_Saturation.fromJson(jsonString));
      });
    });
  }
}