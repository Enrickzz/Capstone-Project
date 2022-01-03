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
import 'package:my_app/data_inputs/vitals/respiratory_rate/respiratory_rate.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../laboratory_results/lab_results.dart';
import '../../medicine_intake/medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_respiratory_rate extends StatefulWidget {
  final List<Respiratory_Rate> rList;
  add_respiratory_rate({Key key, this.rList});
  @override
  _add_respiratory_rateState createState() => _add_respiratory_rateState();
}
final _formKey = GlobalKey<FormState>();
class _add_respiratory_rateState extends State<add_respiratory_rate> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  int count = 1;
  int breaths = 0;
  String exercise = 'Yes';
  int bpm =0;
  DateTime bpmdate;
  String bpm_time;
  bool isDateSelected= false;
  String bpm_date = (new DateTime.now()).toString();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  List<Respiratory_Rate> repiratory_list=[];
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
                    'Add Respiratory Rate',
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
                      hintText: "Breaths per minute",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter breaths per minute' : null,
                    onChanged: (val){
                      setState(() => bpm = int.parse(val));
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
                        if(value != null && value != bpmdate){
                          setState(() {
                            bpmdate = value;
                            isDateSelected = true;
                            bpm_date = "${bpmdate.month}/${bpmdate.day}/${bpmdate.year}";
                            print(bpm_date);

                          });
                          dateValue.text = bpm_date.toString() + "\r";
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
                            bpm_time = "$hours:$min";
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
                          setState((){
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[

                      // Container(
                      //     child: Text(
                      //         " MM/DD/YYYY ",
                      //         style: TextStyle(
                      //           color: Color(0xFF666666),
                      //           fontFamily: defaultFontFamily,
                      //           fontSize: defaultFontSize,
                      //           fontStyle: FontStyle.normal,
                      //         )
                      //     )
                      // ),
                    ],
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
                            final readRespiratory = databaseReference.child('users/' + uid + '/vitals/health_records/respiratoryRate_list');
                            readRespiratory.once().then((DataSnapshot datasnapshot) {
                              if(datasnapshot.value == null){
                                final respiratoryRef = databaseReference.child('users/' + uid + '/vitals/health_records/respiratoryRate_list/' + count.toString());
                                respiratoryRef.set({
                                  "bpm": bpm.toString(),
                                  "bpm_date": bpm_date.toString(),
                                  "bpm_time": bpm_time.toString()
                                });

                                print("Added repiratory rate Successfully! " + uid);
                              }else{
                                getRespirations();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = repiratory_list.length;
                                  final respiratoryRef = databaseReference.child('users/' + uid + '/vitals/health_records/respiratoryRate_list/' + count.toString());
                                  respiratoryRef.set({
                                  "bpm": bpm.toString(),
                                  "bpm_date": bpm_date.toString(),
                                  "bpm_time": bpm_time.toString()
                                  });
                                  print("Added repiratory rate Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              repiratory_list.add(new Respiratory_Rate(bpm: bpm, bpm_date: format.parse(bpm_date),bpm_time: timeformat.parse(bpm_time) ));
                              for(var i=0;i<repiratory_list.length/2;i++){
                                var temp = repiratory_list[i];
                                repiratory_list[i] = repiratory_list[repiratory_list.length-1-i];
                                repiratory_list[repiratory_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, repiratory_list);
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
  List<Respiratory_Rate> getRespirations() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/respiratoryRate_list/');
    List<Respiratory_Rate> rlist = [];
    rlist.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        // rlist.add(Respiratory_Rate.fromJson(jsonString));
        repiratory_list.add(Respiratory_Rate.fromJson(jsonString));
      });
    });

    return repiratory_list;
  }
}