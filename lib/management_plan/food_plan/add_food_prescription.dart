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
class add_food_prescription extends StatefulWidget {
  final List<FoodPlan> thislist;
  final String userUID;
  add_food_prescription({this.thislist, this.userUID});
  @override
  _addFoodPrescriptionState createState() => _addFoodPrescriptionState();
}
final _formKey = GlobalKey<FormState>();
class _addFoodPrescriptionState extends State<add_food_prescription> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  DateFormat format = new DateFormat("MM/dd/yyyy");
  int count = 1;
  // List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  List<FoodPlan> foodplan_list = new List<FoodPlan>();
  String purpose = "";
  String food = "";
  String quantity_food = "0";
  String consumption_time = "";
  String important_notes = "";
  String prescribedBy = "";
  DateTime now =  DateTime.now();
  List<String> listFoodTime = <String>[
    'Breakfast', 'Lunch','Dinner', 'Snacks'
  ];
  String valueChooseFoodTime;


  // String getFrom(){
  //   if(dateRange == null){
  //     return 'From';
  //   }
  //   else{
  //     return DateFormat('MM/dd/yyyy').format(dateRange.start);
  //
  //   }
  // }
  //
  // String getUntil(){
  //   if(dateRange == null){
  //     return 'Until';
  //   }
  //   else{
  //     return DateFormat('MM/dd/yyyy').format(dateRange.end);
  //
  //   }
  // }

  // Future pickDateRange(BuildContext context) async{
  //   final initialDateRange = DateTimeRange(
  //     start: DateTime.now(),
  //     end: DateTime.now().add(Duration(hours:24 * 3)),
  //   );
  //
  //   final newDateRange = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(DateTime.now().year - 5),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //     initialDateRange: dateRange ?? initialDateRange,
  //   );
  //
  //   if(newDateRange == null) return;
  //
  //   setState(() => {
  //     dateRange = newDateRange,
  //     startdate = "${dateRange.start.month}/${dateRange.start.day}/${dateRange.start.year}",
  //     enddate = "${dateRange.end.month}/${dateRange.end.day}/${dateRange.end.year}",
  //
  //   });
  //   print("date Range " + dateRange.toString());
  // }

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
                    'Add Food Plan',
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
                      hintText: "Purpose",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Purpose' : null,
                    onChanged: (val){
                      setState(() => purpose = val);
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    showCursor: true,
                    keyboardType: TextInputType.multiline,
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
                      hintText: "Diet Plan",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Food' : null,
                    onChanged: (val){
                      setState(() => food = val);
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
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            String userUID = widget.userUID;
                            final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
                            readFoodPlan.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print(temp1);
                              if(datasnapshot.value == null){
                                final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/foodplan/' + count.toString());
                                foodplanRef.set({"purpose": purpose.toString(), "food": food.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}"});
                                print("Added Food Plan Successfully! " + uid);
                              }
                              else{
                                getFoodPlan();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = foodplan_list.length--;
                                  final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/foodplan/' + count.toString());
                                  foodplanRef.set({"purpose": purpose.toString(), "food": food.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}"});
                                  print("Added Food Plan Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("MEDICATION LENGTH: " + foodplan_list.length.toString());
                              foodplan_list.add(new FoodPlan(purpose: purpose, food: food, important_notes: important_notes, prescribedBy: uid, dateCreated: now));
                              for(var i=0;i<foodplan_list.length/2;i++){
                                var temp = foodplan_list[i];
                                foodplan_list[i] = foodplan_list[foodplan_list.length-1-i];
                                foodplan_list[foodplan_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, [foodplan_list, 1]);
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
  void getFoodPlan() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readFood = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
    readFood.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print("temp");
      print(temp);
      temp.forEach((jsonString) {
        foodplan_list.add(FoodPlan.fromJson(jsonString));
      });
    });
  }
}