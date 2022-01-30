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
class edit_exercise_prescription extends StatefulWidget {
  final List<ExPlan> thislist;
  String userUID;
  final int index;
  edit_exercise_prescription({this.thislist, this.userUID, this.index});
  @override
  _editExercisePrescriptionState createState() => _editExercisePrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _editExercisePrescriptionState extends State<edit_exercise_prescription> {
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
  String type = "";
  String intensity = "";
  String important_notes = "";
  String prescribedBy = "";
  DateTime now =  DateTime.now();

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
                    'Edit Exercise Plan',
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
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
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
                    validator: (val) => val.isEmpty ? 'Enter Type of Workout' : null,
                    onChanged: (val){
                      setState(() => type = val);
                    },
                  ),




                  SizedBox(height: 8.0),

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
                            exercise_list = widget.thislist;
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            int index = ((exercise_list.length + 1) - (widget.index+1)) ;
                            final foodplanRef = databaseReference.child('users/' + widget.userUID + '/management_plan/exercise_prescription/' + index.toString());
                            foodplanRef.update({
                              "purpose": purpose.toString(),
                              "type": type.toString(),
                              "important_notes": important_notes.toString(),
                              "prescribedBy": uid,
                              "dateCreated": "${now.month}/${now.day}/${now.year}"});
                            Future.delayed(const Duration(milliseconds: 1500), (){
                              index = widget.index;
                              exercise_list[index].purpose = purpose.toString();
                              exercise_list[index].type = type.toString();
                              exercise_list[index].important_notes = important_notes.toString();
                              exercise_list[index].prescribedBy = prescribedBy.toString();
                              exercise_list[index].dateCreated = now;
                              print("POP HERE ==========");
                              ExPlan newEP = exercise_list[index];
                              Navigator.pop(context, newEP);
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
      print("temp");
      print(temp);
      temp.forEach((jsonString) {
        exercise_list.add(ExPlan.fromJson(jsonString));
      });
    });
  }
}