import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import '../lab_results.dart';
import '../medication.dart';
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
  String bp_date = "MM/DD/YYYY";
  int count = 0;
  bool isDateSelected= false;
  List<Blood_Pressure> bp_list = new List<Blood_Pressure>();
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
                    'Add Blood Pressure',
                    textAlign: TextAlign.center,
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
                      hintText: "Systolic Pressure",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Systolic Pressure' : null,
                    onChanged: (val){
                      setState(() => systolic_pressure = val);
                    },
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
                      hintText: "Diastolic Pressure",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Diastolic Pressure' : null,
                    onChanged: (val){
                      setState(() => diastolic_pressure = val);
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
                        initialTime: time ?? initialTime,
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
                  SizedBox(height: 18.0),
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
                                String tempSystolicPressure = "";
                                String tempDiastolicPressure = "";
                                String tempBPDate = "";
                                String tempBPTime = "";
                                String tempBPLvl = "";

                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  if(i < 5){
                                    print("i value" + i.toString());
                                    switch(i){
                                      case 0: {
                                        print("1st switch i = 0 " + splitFull.last);
                                        tempBPDate = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempDiastolicPressure = splitFull.last;

                                      }
                                      break;
                                      case 2: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempBPLvl = splitFull.last;

                                      }
                                      break;
                                      case 3: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempBPTime = splitFull.last;
                                      }
                                      break;
                                      case 4: {
                                        print("1st switch i = 2 " + splitFull.last);
                                        tempSystolicPressure = splitFull.last;
                                        bloodPressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure, pressure_level: tempBPLvl, bp_date: format.parse(tempBPDate),bp_time: timeformat.parse(tempBPTime));
                                        bp_list.add(bloodPressure);
                                      }
                                      break;
                                    }
                                  }
                                  else{
                                    print("i value" + i.toString());
                                    print("i value modulu " + (i%4).toString());
                                    switch(i%5){
                                      case 0: {
                                        print("1st switch i = 0 " + splitFull.last);
                                        tempBPDate = splitFull.last;
                                      }
                                      break;
                                      case 1: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempDiastolicPressure = splitFull.last;

                                      }
                                      break;
                                      case 2: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempBPLvl = splitFull.last;
                                      }
                                      break;
                                      case 3: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempBPTime = splitFull.last;
                                      }
                                      break;
                                      case 4: {
                                        print("1st switch i = 2 " + splitFull.last);
                                        tempSystolicPressure = splitFull.last;
                                        bloodPressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure, pressure_level: tempBPLvl, bp_date: format.parse(tempBPDate),bp_time: timeformat.parse(tempBPTime));
                                        bp_list.add(bloodPressure);
                                      }
                                      break;
                                    }
                                  }

                                }
                                count = bp_list.length;
                                print("count " + count.toString());
                                final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + count.toString());
                                bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),"pressure_level": pressure_level.toString(),  "bp_date": bp_date.toString(), "bp_time":bp_time.toString()});
                                print("Added Blood Pressure Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + bp_list.length.toString());
                              bp_list.add(new Blood_Pressure(systolic_pressure: systolic_pressure, diastolic_pressure: diastolic_pressure,pressure_level: pressure_level, bp_date: format.parse(bp_date), bp_time: timeformat.parse(bp_time)));
                              for(var i=0;i<bp_list.length/2;i++){
                                var temp = bp_list[i];
                                bp_list[i] = bp_list[bp_list.length-1-i];
                                bp_list[bp_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, bp_list);
                            });


                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => blood_pressure(bplist: bp_list)),
                            // );

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
}