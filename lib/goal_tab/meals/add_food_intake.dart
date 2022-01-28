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

  bool unitSelected = false;
  double print_calories = 0;

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  double total_sugar = 0;
  double total_sodium = 0;
  double total_cholesterol = 0;
  double total_calories = 0;
  double total_tfat = 0;
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
                    'Add Food Intake',
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
                            print_calories = double.parse(widget.calories) / double.parse(widget.weight);
                            print_calories *= double.parse(serving_size);
                            // setState(() => temperature = double.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                      Visibility(
                        visible: unitSelected,
                        child: Text(
                          print_calories.toStringAsFixed(1) + ' cal',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
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
                        unitSelected = true;

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
                                double total_cholesterol = 0;
                                double total_protein = 0;
                                double total_potassium = 0;
                                /// total calories
                                total_calories = double.parse(widget.calories) / double.parse(widget.weight);
                                total_calories *= double.parse(serving_size);
                                /// total cholesterol
                                total_cholesterol = double.parse(widget.cholesterol) / double.parse(widget.weight);
                                total_cholesterol *= double.parse(serving_size);
                                /// total fat
                                total_tfat = double.parse(widget.total_fat) / double.parse(widget.weight);
                                total_tfat *= double.parse(serving_size);
                                /// total sugar
                                total_sugar = double.parse(widget.sugar) / double.parse(widget.weight);
                                total_sugar *= double.parse(serving_size);
                                /// total protein
                                total_protein = double.parse(widget.protein) / double.parse(widget.weight);
                                total_protein *= double.parse(serving_size);
                                /// total potassium
                                total_potassium = double.parse(widget.potassium) / double.parse(widget.weight);
                                total_potassium *= double.parse(serving_size);
                                /// total sodium
                                total_sodium = double.parse(widget.sodium) / double.parse(widget.weight);
                                total_sodium *= double.parse(serving_size);


                                foodintakeRef.set({
                                  "img": widget.heroTag,
                                  "foodName": widget.foodName,
                                  "weight": widget.weight.toString(),
                                  "calories": total_calories.toStringAsFixed(0),
                                  "cholesterol": total_cholesterol.toStringAsFixed(1),
                                  "total_fat": total_tfat.toStringAsFixed(1),
                                  "sugar": total_sugar.toStringAsFixed(1),
                                  "protein": total_protein.toStringAsFixed(1),
                                  "potassium": total_potassium.toStringAsFixed(1),
                                  "sodium": total_sodium.toStringAsFixed(1),
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
                                  double total_calories = 0;
                                  total_calories = double.parse(widget.calories) / double.parse(widget.weight);
                                  total_calories *= double.parse(serving_size);
                                  foodintakeRef.set({
                                    "img": widget.heroTag,
                                    "foodName": widget.foodName,
                                    "weight": widget.weight.toString(),
                                    "calories": total_calories.toStringAsFixed(0),
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
                                  calories: int.parse(widget.calories),
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
                              //recom
                              if(total_sugar >= 32){
                                addtoRecommendation("We have detected that you have eaten a meal that contains a high amount of sugar. We recommend that you drink a glass of water to ensure and walk around so you won’t reach hyperglycemia.",
                                    "Too much Sugar!",
                                    "3",
                                    "food_intake");
                              }
                              if(widget.foodName.toString().toLowerCase().contains("coffee") == true){
                                addtoRecommendation("Please refrain from drinking caffeine as it is detrimental to patients with Arrhythmia. Next time please consider drinking tea instead.",
                                    "Had Coffee?",
                                    "3",
                                    "food_intake");
                              }
                              if(total_sodium >= 1500){
                                addtoRecommendation("We recommend that you limit your intake of salty foods for today as you have consumed more than 1500mg of sodium for today. Here is a list of foods that you may opt to have for the rest of the day. Click here to view food recommendations.",
                                    "Too much salt!",
                                    "3",
                                    "food_intake");
                              }
                              if(double.parse(widget.sodium) >= 600){
                                addtoRecommendation("You have eaten a meal with high amounts of sodium, to compensate for this we recommend that you drink 2 glasses of water and eat potassium rich-foods for your next meal. Click here to view food recommendations.",
                                    "Salty food!",
                                    "3",
                                    "food_intake");
                              }
                              if(total_cholesterol >= 300){
                                addtoRecommendation("We recommend that you limit your intake of high cholesterol containing foods for the day as you have already consumed past the 300mg threshold for cholesterol. Here is a list of foods that you may opt to have for the rest of the day. Click here to view food recommendations.",
                                    "Too much cholesterol!",
                                    "3",
                                    "food_intake");
                              }
                              if(total_tfat > (total_calories*.3)){
                                addtoRecommendation("We recommend that you limit your intake of high fat containing foods for the day. Here is a list of foods that you may opt to have for the rest of the day. Click here to view food recommendations.",
                                    "Meals to fatty!",
                                    "3",
                                    "food_intake");
                              }
                              List<String> alcohol = ["Whiskey", "Gin", "Vodka", "beer", "Tequila", "Wine",];
                              bool alc = false;
                              for(var i=0;i < alcohol.length ; i++){
                                if(widget.foodName.toString().toLowerCase().contains(alcohol[i])){
                                  alc = true;
                                }
                              }
                              if(alc == true){
                                addtoRecommendation("We strongly advise you to not consume alcoholic beverages as this is detrimental to your heart condition.",
                                    "Stop Drinking Alcohol",
                                    "3",
                                    "food_intake");
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
  void addtoRecommendation(String message, String title, String priority, String redirect){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "food_intake", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "food_intake", "redirect": redirect});
      }
    });
  }
  void getRecomm() {
    recommList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }
  void getFoodIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFoodIntake = databaseReference.child('users/' + uid + '/intake/food_intake/'+ valueChooseFoodTime+ "/");
    readFoodIntake.once().then((DataSnapshot snapshot){
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

