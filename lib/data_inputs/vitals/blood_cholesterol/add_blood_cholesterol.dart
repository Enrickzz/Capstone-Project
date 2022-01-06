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
import 'blood_cholesterol.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_blood_cholesterol extends StatefulWidget {
  final List<Blood_Cholesterol> cholList;
  add_blood_cholesterol({Key key, this.cholList});
  @override
  _add_blood_cholesterolState createState() => _add_blood_cholesterolState();
}
final _formKey = GlobalKey<FormState>();
class _add_blood_cholesterolState extends State<add_blood_cholesterol> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double total_cholesterol = 0;
  double ldl_cholesterol = 0;
  double hdl_cholesterol = 0;
  double triglycerides = 0;
  DateTime cholesterolDate;
  String cholesterol_date = (new DateTime.now()).toString();
  String cholesterol_time;
  bool isDateSelected= false;
  int count = 0;
  List<Blood_Cholesterol> cholesterol_list = new List<Blood_Cholesterol>();
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
                    'Add Blood Cholesterol Level',
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
                      hintText: "Total Cholesterol (mg/dL)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Total Cholesterol (mg/dL)' : null,
                    onChanged: (val){
                      setState(() => total_cholesterol = double.parse(val));
                    },
                  ),
                  SizedBox(height: 8.0),
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
                      hintText: "LDL Cholesterol (mg/dL)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter LDL Cholesterol (mg/dL)' : null,
                    onChanged: (val){
                      setState(() => ldl_cholesterol = double.parse(val));
                    },
                  ),
                  SizedBox(height: 8.0),
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
                      hintText: "HDL Cholesterol (mg/dL)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter HDL Cholesterol (mg/dL)' : null,
                    onChanged: (val){
                      setState(() => hdl_cholesterol = double.parse(val));
                    },
                  ),
                  SizedBox(height: 8.0),
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
                      hintText: "Triglycerides (mg/dL)",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Triglycerides (mg/dL)' : null,
                    onChanged: (val){
                      setState(() => triglycerides = double.parse(val));
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
                        if(value != null && value != cholesterolDate){
                          setState(() {
                            cholesterolDate = value;
                            isDateSelected = true;
                            cholesterol_date = "${cholesterolDate.month}/${cholesterolDate.day}/${cholesterolDate.year}";
                          });
                          dateValue.text = cholesterol_date + "\r";
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
                            cholesterol_time = "$hours:$min";
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
                            final readCholesterol = databaseReference.child('users/' + uid + '/vitals/health_records/blood_cholesterol_list');
                            readCholesterol.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              Blood_Cholesterol cholesterol;
                              if(datasnapshot.value == null){
                                final cholesterolRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_cholesterol_list/' + 0.toString());
                                cholesterolRef.set({"total_cholesterol": total_cholesterol.toString(), "ldl_cholesterol": ldl_cholesterol.toString(), "hdl_cholesterol": hdl_cholesterol.toString(), "triglycerides": triglycerides.toString(), "cholesterol_date": cholesterol_date.toString()});
                                print("Added Blood Cholesterol Successfully! " + uid);
                              }
                              else{
                                String tempTotalCholesterol = "";
                                String tempLdlCholesterol = "";
                                String tempHdlCholesterol = "";
                                String tempTriglycerides = "";
                                String tempCholesterolDate;
                                for(var i = 0; i < temp.length; i++){
                                  String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                  List<String> splitFull = full.split(" ");
                                  print("i value" + i.toString());
                                  print("i value modulu " + (i%5).toString());
                                  switch(i%5){
                                    case 0: {
                                      tempTotalCholesterol = splitFull.last;
                                    }
                                    break;
                                    case 1: {
                                      tempCholesterolDate = splitFull.last;
                                    }
                                    break;
                                    case 2: {
                                      tempTriglycerides = splitFull.last;
                                    }
                                    break;
                                    case 3: {
                                      tempLdlCholesterol = splitFull.last;
                                    }
                                    break;
                                    case 4: {
                                      tempHdlCholesterol = splitFull.last;
                                      cholesterol = new Blood_Cholesterol(total_cholesterol: double.parse(tempTotalCholesterol), ldl_cholesterol: double.parse(tempLdlCholesterol), hdl_cholesterol: double.parse(tempHdlCholesterol),triglycerides: double.parse(tempTriglycerides), cholesterol_date: format.parse(tempCholesterolDate));
                                      cholesterol_list.add(cholesterol);
                                    }
                                    break;
                                  }


                                }
                                count = cholesterol_list.length;
                                print("count " + count.toString());
                                //this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date

                                // symptoms_list.add(symptom);

                                // print("symptom list  " + symptoms_list.toString());
                                final cholesterolRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_cholesterol_list/' + count.toString());
                                cholesterolRef.set({"total_cholesterol": total_cholesterol.toString(), "ldl_cholesterol": ldl_cholesterol.toString(), "hdl_cholesterol": hdl_cholesterol.toString(), "triglycerides": triglycerides.toString(), "cholesterol_date": cholesterol_date.toString()});
                                print("Added Blood Cholesterol Successfully! " + uid);
                              }

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              cholesterol_list.add(new Blood_Cholesterol(total_cholesterol: total_cholesterol, ldl_cholesterol: ldl_cholesterol, hdl_cholesterol: hdl_cholesterol,triglycerides: triglycerides, cholesterol_date: format.parse(cholesterol_date)));
                              for(var i=0;i<cholesterol_list.length/2;i++){
                                var temp = cholesterol_list[i];
                                cholesterol_list[i] = cholesterol_list[cholesterol_list.length-1-i];
                                cholesterol_list[cholesterol_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, cholesterol_list);
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
}