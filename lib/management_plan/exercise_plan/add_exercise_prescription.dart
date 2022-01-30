import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_exercise_prescription extends StatefulWidget {
  final List<ExPlan> thislist;
  String userUID;
  add_exercise_prescription({this.thislist, this.userUID});
  @override
  _addExercisePrescriptionState createState() => _addExercisePrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addExercisePrescriptionState extends State<add_exercise_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateFormat format = new DateFormat("MM/dd/yyyy");
  int count = 1;
  List<ExPlan> exercise_list = new List<ExPlan>();
  int frequency = 1;
  DateTimeRange dateRange;
  String startdate;
  String enddate;
  String purpose = "";
  String type;
  String intensity = "";
  String important_notes = "";
  String prescribedBy = "";
  DateTime now =  DateTime.now();
  List<String> listExercise = <String>[
    'Body weights', 'Cardio', 'Cycle', 'Stretching', 'Treadmill'
  ];

  String getFrom(){
    if(dateRange == null){
      return 'From';
    }
    else{
      return DateFormat('MM/dd/yyyy').format(dateRange.start);

    }
  }

  String getUntil(){
    if(dateRange == null){
      return 'Until';
    }
    else{
      return DateFormat('MM/dd/yyyy').format(dateRange.end);

    }
  }

  Future pickDateRange(BuildContext context) async{
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours:24 * 3)),
    );

    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if(newDateRange == null) return;

    setState(() => {
      dateRange = newDateRange,
      startdate = "${dateRange.start.month}/${dateRange.start.day}/${dateRange.start.year}",
      enddate = "${dateRange.end.month}/${dateRange.end.day}/${dateRange.end.year}",

    });
    print("date Range " + dateRange.toString());
  }
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
                    'Add Exercise Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
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
                      hintText: "Purpose of Plan",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Purpose Field' : null,
                    onChanged: (val){
                      setState(() => purpose = val);
                    },
                  ),
                  SizedBox(height: 8),

                  DropdownButtonFormField(
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
                      hintText: "Type of Exercise/Activity",
                    ),
                    isExpanded: true,
                    value: type,
                    onChanged: (newValue){
                      setState(() {
                        type = newValue;
                      });

                    },
                    items: listExercise.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),

                  SizedBox(height: 8),

                  // TextFormField(
                  //   showCursor: true,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       borderSide: BorderSide(
                  //         width:0,
                  //         style: BorderStyle.none,
                  //       ),
                  //     ),
                  //     filled: true,
                  //     fillColor: Color(0xFFF2F3F5),
                  //     hintStyle: TextStyle(
                  //         color: Color(0xFF666666),
                  //         fontFamily: defaultFontFamily,
                  //         fontSize: defaultFontSize),
                  //     hintText: "Activity/Exercise Instructions",
                  //   ),
                  //   validator: (val) => val.isEmpty ? 'Enter Type of Workout' : null,
                  //   onChanged: (val){
                  //     setState(() => type = val);
                  //   },
                  // ),
                  //
                  // SizedBox(height: 8.0),

                  TextFormField(
                    showCursor: true,
                    maxLines: 6,
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
                      hintText: "Important Notes/Assessments",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Important Notes' : null,
                    onChanged: (val){
                      setState(() => important_notes = val);
                    },
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
                            String doctor_name = "";
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            final readDoctor = databaseReference.child('users/' + uid + '/personal_info/');
                            Users doctor = new Users();
                            readDoctor.once().then((DataSnapshot snapshot) {
                              Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                              doctor = Users.fromJson(temp);
                              doctor_name = doctor.firstname + " " + doctor.lastname;
                            });
                            final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/exercise_prescription/');
                            readFoodPlan.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print(temp1);
                              if(datasnapshot.value == null){
                                final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/exercise_prescription/' + count.toString());
                                foodplanRef.set({"purpose": purpose.toString(), "type": type.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctor_name});
                                print("Added Food Plan Successfully! " + uid);
                              }
                              else{
                                getExercise();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = exercise_list.length--;
                                  final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/exercise_prescription/' + count.toString());
                                  foodplanRef.set({"purpose": purpose.toString(), "type": type.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}", "doctor_name": doctor_name});
                                  print("Added Exercise Plan Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + exercise_list.length.toString());
                              exercise_list.add(new ExPlan(purpose: purpose, type: type,important_notes: important_notes, prescribedBy: uid, dateCreated: now, doctor_name: doctor_name));
                              for(var i=0;i<exercise_list.length/2;i++){
                                var temp = exercise_list[i];
                                exercise_list[i] = exercise_list[exercise_list.length-1-i];
                                exercise_list[exercise_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              ExPlan a = new ExPlan(purpose: purpose, type: type,important_notes: important_notes, prescribedBy: uid,
                                  dateCreated: now, doctor_name: doctor_name);

                              Navigator.pop(context,a );
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
  void getExercise() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readprescription = databaseReference.child('users/' + userUID + '/management_plan/exercise_prescription/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        exercise_list.add(ExPlan.fromJson(jsonString));
      });
    });
  }
}