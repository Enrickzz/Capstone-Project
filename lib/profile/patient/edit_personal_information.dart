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
class edit_personal_information extends StatefulWidget {
  // final List<FoodPlan> thislist;
  // final String userUID;
  edit_personal_information();
  @override
  _editPersonalInformation createState() => _editPersonalInformation();
}
final _formKey = GlobalKey<FormState>();
class _editPersonalInformation extends State<edit_personal_information> {


  final _formKey = GlobalKey<FormState>();

  //birthday
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "";
  bool isDateSelected= false;
  var dateValue = TextEditingController();




  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  //
  // DateFormat format = new DateFormat("MM/dd/yyyy");
  // int count = 1;
  // // List<Medication_Prescription> prescription_list = new List<Medication_Prescription>();
  // List<FoodPlan> foodplan_list = new List<FoodPlan>();
  // String purpose = "";
  // String food = "";
  // String quantity_food = "0";
  // String consumption_time = "";
  // String important_notes = "";
  // String prescribedBy = "";
  // DateTime now =  DateTime.now();
  // List<String> listFoodTime = <String>[
  //   'Breakfast', 'Lunch','Dinner', 'Snacks'
  // ];
  // String valueChooseFoodTime;



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
                    'Edit My Personal Information',
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
                            hintText: "First Name *",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter First Name' : null,
                          onChanged: (val){
                            // setState(() => firstname = val);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
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
                            hintText: "Last Name *",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Last Name' : null,
                          onChanged: (val){
                            // setState(() => lastname = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: ()async{
                      final datePick= await showDatePicker(
                          context: context,
                          initialDate: DateTime(1990, 1),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime.now()
                      );
                      if(datePick!=null && datePick!=birthDate){
                        setState(() {
                          birthDate=datePick;
                          isDateSelected=true;

                          // put it here
                          birthDateInString = "${birthDate.month}/${birthDate.day}/${birthDate.year}";
                          dateValue.text = birthDateInString;
                        });
                      }
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
                          hintText: "Birthday *",
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'Select Birthday' : null,
                        onChanged: (val){
                          print(dateValue);
                          setState((){

                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.accessibility_rounded,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Weight (kg) *",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Weight in KG' : null,
                    onChanged: (val){
                      // setState(() => weight = val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly],
                    // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    // onChanged: (val){
                    //   setState(() => genderIn = val);
                    // },
                  ),SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    showCursor: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.accessibility_rounded,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Height (cm) *",
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Height in cm' : null,
                    onChanged: (val){
                      // setState(() => height = val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly],
                    // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    // onChanged: (val){
                    //   setState(() => genderIn = val);
                    // },
                  ),SizedBox(
                    height: 8,
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
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:()  {

                          // Navigator.pop(context);
                        },
                        // onPressed:() async {
                        //   try{
                        //     final User user = auth.currentUser;
                        //     final uid = user.uid;
                        //     String userUID = widget.userUID;
                        //     consumption_time = valueChooseFoodTime;
                        //     final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
                        //     readFoodPlan.once().then((DataSnapshot datasnapshot) {
                        //       String temp1 = datasnapshot.value.toString();
                        //       print(temp1);
                        //       if(datasnapshot.value == null){
                        //         final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/foodplan/' + count.toString());
                        //         foodplanRef.set({"purpose": purpose.toString(), "food": food.toString(), "quantity_food": quantity_food.toString(), "consumption_time": consumption_time.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}"});
                        //         print("Added Food Plan Successfully! " + uid);
                        //       }
                        //       else{
                        //         getFoodPlan();
                        //         Future.delayed(const Duration(milliseconds: 1000), (){
                        //           count = foodplan_list.length--;
                        //           final foodplanRef = databaseReference.child('users/' + userUID + '/management_plan/foodplan/' + count.toString());
                        //           foodplanRef.set({"purpose": purpose.toString(), "food": food.toString(), "quantity_food": quantity_food.toString(), "consumption_time": consumption_time.toString(), "important_notes": important_notes.toString(), "prescribedBy": uid, "dateCreated": "${now.month}/${now.day}/${now.year}"});
                        //           print("Added Food Plan Successfully! " + uid);
                        //         });
                        //       }
                        //     });
                        //     Future.delayed(const Duration(milliseconds: 1000), (){
                        //       print("MEDICATION LENGTH: " + foodplan_list.length.toString());
                        //       foodplan_list.add(new FoodPlan(purpose: purpose, food: food,quantity_food: double.parse(quantity_food), consumption_time: consumption_time, important_notes: important_notes, prescribedBy: uid, dateCreated: now));
                        //       for(var i=0;i<foodplan_list.length/2;i++){
                        //         var temp = foodplan_list[i];
                        //         foodplan_list[i] = foodplan_list[foodplan_list.length-1-i];
                        //         foodplan_list[foodplan_list.length-1-i] = temp;
                        //       }
                        //       print("POP HERE ==========");
                        //       Navigator.pop(context, [foodplan_list, 1]);
                        //     });
                        //   } catch(e) {
                        //     print("you got an error! $e");
                        //   }
                        //   // Navigator.pop(context);
                        // },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }

}