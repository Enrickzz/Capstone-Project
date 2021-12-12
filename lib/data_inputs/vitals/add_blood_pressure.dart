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
  DateTime bpDate;
  String bp_date = "MM/DD/YYYY";
  int count = 0;
  bool isDateSelected= false;
  List<Blood_Pressure> bp_list = new List<Blood_Pressure>();
  DateFormat format = new DateFormat("MM/dd/yyyy");

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
                  Row(
                    children: <Widget>[
                      GestureDetector(
                          child: new Icon(Icons.calendar_today),
                          onTap: ()async{
                            final datePick= await showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime(1900),
                                lastDate: new DateTime(2100)
                            );
                            if(datePick!=null && datePick!=bpDate){
                              setState(() {
                                bpDate=datePick;
                                isDateSelected=true;

                                // put it here
                                bp_date = "${bpDate.month}/${bpDate.day}/${bpDate.year}"; // 08/14/2019
                                // AlertDialog alert = AlertDialog(
                                //   title: Text("My title"),
                                //   content: Text("This is my message."),
                                //   actions: [
                                //
                                //   ],
                                // );

                              });
                            }
                          }
                      ), Container(
                          child: Text(
                              " MM/DD/YYYY ",
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontFamily: defaultFontFamily,
                                fontSize: defaultFontSize,
                                fontStyle: FontStyle.normal,
                              )
                          )
                      ),
                    ],
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
                                final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + 0.toString());
                                bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),  "bp_date": bp_date.toString()});
                                print("Added medication Successfully! " + uid);
                              }
                              else{
                                String tempSystolicPressure = "";
                                String tempDiastolicPressure = "";
                                DateTime tempBPDate;

                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  if(i < 3){
                                    print("i value" + i.toString());
                                    switch(i){
                                      case 0: {
                                        print("1st switch i = 0 " + splitFull.last);
                                        tempBPDate = format.parse(splitFull.last);

                                      }
                                      break;
                                      case 1: {
                                        print("1st switch i = 1 " + splitFull.last);
                                        tempDiastolicPressure = splitFull.last;
                                      }
                                      break;
                                      case 2: {
                                        print("1st switch i = 2 " + splitFull.last);
                                        tempSystolicPressure = splitFull.last;
                                        bloodPressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure, bp_date: tempBPDate);
                                        bp_list.add(bloodPressure);
                                      }
                                      break;
                                    }
                                  }
                                  else{
                                    print("i value" + i.toString());
                                    print("i value modulu " + (i%4).toString());
                                    switch(i%3){
                                      case 0: {
                                        print("2nd switch intensity lvl " + splitFull.last);
                                        tempBPDate = format.parse(splitFull.last);
                                      }
                                      break;
                                      case 1: {
                                        print("2nd switch symptom name " + splitFull.last);
                                        tempDiastolicPressure = splitFull.last;
                                      }
                                      break;
                                      case 2: {
                                        print("2nd switch symptom date " + splitFull.last);
                                        tempSystolicPressure = splitFull.last;
                                        bloodPressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure, bp_date: tempBPDate);
                                        bp_list.add(bloodPressure);

                                      }
                                      break;
                                    }
                                  }

                                }
                                count = bp_list.length;
                                print("count " + count.toString());
                                final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/' + count.toString());
                                bpRef.set({"systolic_pressure": systolic_pressure.toString(), "diastolic_pressure": diastolic_pressure.toString(),  "bp_date": bp_date.toString()});
                                print("Added Blood Pressure Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + bp_list.length.toString());
                              bp_list.add(new Blood_Pressure(systolic_pressure: systolic_pressure, diastolic_pressure: diastolic_pressure, bp_date: format.parse(bp_date)));
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