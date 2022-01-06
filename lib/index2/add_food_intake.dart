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
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/view_medical_prescription_as_doctor.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class add_food_intake extends StatefulWidget {
  final heroTag;
  final foodName;
  final weight;
  final calories;
  final cholesterol;
  final total_fat;
  final sugar;
  final protein;
  final potassium;
  final sodium;

  add_food_intake({
    this.heroTag,
    this.foodName,
    this.weight,
    this.calories,
    this.cholesterol,
    this.total_fat,
    this.sugar,
    this.protein,
    this.potassium,
    this.sodium
  });
  @override
  _addFoodIntakeState createState() => _addFoodIntakeState();
}
final _formKey = GlobalKey<FormState>();
class _addFoodIntakeState extends State<add_food_intake> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  // added by borj
  List<String> listFoodTime = <String>[
    'Breakfast', 'Lunch','Dinner', 'Snacks'
  ];
  String valueChooseFoodTime;
  int count = 1;
  String valueFoodUnit;
  String serving_size = "";
  List<String> listFoodUnit =['Grams'];
  List<FoodIntake> foodintake_list = [];
  DateTime now = new DateTime.now();

  var dateValue = TextEditingController();
  String intake_date = (new DateTime.now()).toString();
  DateTime foodIntakeDate;
  bool isDateSelected= false;







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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            hintText: "Serving Size",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Serving Size' : null,
                          onChanged: (val){
                            serving_size = val;
                            // setState(() => temperature = double.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        '###' + ' cal',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),

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
                      hintText: "Food Unit: ",
                    ),
                    isExpanded: true,
                    value: valueFoodUnit,
                    onChanged: (newValue){
                      setState(() {
                        // valueFoodUnit = newValue;

                      });
                    },
                    items: listFoodUnit.map((valueItem){
                      return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem)
                      );
                    },
                    ).toList(),
                  ),


                  SizedBox(height: 8.0),
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
                      hintText: "I ate this for:",
                    ),
                    isExpanded: true,
                    value: valueChooseFoodTime,
                    onChanged: (newValue){
                      setState(() {
                        valueChooseFoodTime = newValue;
                      });

                    },
                    items: listFoodTime.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),

                  GestureDetector(
                    onTap: ()async{
                      await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime.now().subtract(Duration(days: 30)),
                        lastDate: new DateTime.now(),
                      ).then((value){
                        if(value != null && value != foodIntakeDate){
                          setState(() {
                            foodIntakeDate = value;
                            isDateSelected = true;
                            intake_date = "${foodIntakeDate.month}/${foodIntakeDate.day}/${foodIntakeDate.year}";
                          });
                          dateValue.text = intake_date + "\r";
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
                          hintText: "Date",
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
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:()  {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/'+ valueChooseFoodTime+ "/");
                            readFoodIntake.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print(temp1);
                              if(datasnapshot.value == null){
                                final foodintakeRef = databaseReference.child('users/' + uid + '/intake/food_intake/'+ valueChooseFoodTime+ "/" + count.toString());
                                foodintakeRef.set({
                                  "img": widget.heroTag,
                                  "foodName": widget.foodName,
                                  "weight": widget.weight.toString(),
                                  "calories": widget.calories.toString(),
                                  "cholesterol": widget.cholesterol.toString(),
                                  "total_fat": widget.total_fat.toString(),
                                  "sugar": widget.sugar.toString(),
                                  "protein": widget.protein.toString(),
                                  "potassium": widget.potassium.toString(),
                                  "sodium": widget.sodium.toString(),
                                  "serving_size": serving_size,
                                  "food_unit": valueFoodUnit,
                                  "mealtype": valueChooseFoodTime,
                                  "intakeDate": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                                });
                                print("Added Food Intake Successfully! " + uid);
                              }
                              else{
                                getFoodIntake();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = foodintake_list.length--;
                                  final foodintakeRef = databaseReference.child('users/' + uid + '/intake/food_intake/'+ valueChooseFoodTime+ "/" + count.toString());
                                  foodintakeRef.set({
                                    "img": widget.heroTag,
                                    "foodName": widget.foodName,
                                    "weight": widget.weight.toString(),
                                    "calories": widget.calories.toString(),
                                    "cholesterol": widget.cholesterol.toString(),
                                    "total_fat": widget.total_fat.toString(),
                                    "sugar": widget.sugar.toString(),
                                    "protein": widget.protein.toString(),
                                    "potassium": widget.potassium.toString(),
                                    "sodium": widget.sodium.toString(),
                                    "serving_size": serving_size,
                                    "food_unit": valueFoodUnit,
                                    "mealtype": valueChooseFoodTime,
                                    "intakeDate": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                                  });
                                  print("Added Food Intake Successfully! " + uid);
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              foodintake_list.add(new FoodIntake(
                                  img: widget.heroTag,
                                  foodName: widget.foodName,
                                  weight: double.parse(widget.weight),
                                  calories: double.parse(widget.calories),
                                  cholesterol: double.parse(widget.cholesterol),
                                  total_fat: double.parse(widget.total_fat),
                                  sugar: double.parse(widget.sugar),
                                  protein: double.parse(widget.protein),
                                  potassium: double.parse(widget.potassium),
                                  sodium: double.parse(widget.sodium),
                                  serving_size: double.parse(serving_size),
                                  food_unit: valueFoodUnit,
                                  mealtype: valueChooseFoodTime,
                                  intakeDate: "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                              ));
                              for(var i=0;i<foodintake_list.length/2;i++){
                                var temp = foodintake_list[i];
                                foodintake_list[i] = foodintake_list[foodintake_list.length-1-i];
                                foodintake_list[foodintake_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, [foodintake_list, 1]);
                            });
                          } catch(e) {
                            print("you got an error! $e");
                          }

                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  void getFoodIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsupplement = databaseReference.child('users/' + uid + '/intake/food_intake/'+ valueChooseFoodTime+ "/");
    readsupplement.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print("this is temp");
      print(temp);
      if(temp != null){
        temp.forEach((jsonString) {
          foodintake_list.add(FoodIntake.fromJson(jsonString));
        });
      }
    });
  }
}

