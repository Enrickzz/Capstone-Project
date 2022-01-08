import 'dart:convert';

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
import 'package:my_app/goal_tab/water/water_intake_patient_view.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_water_intake extends StatefulWidget {
  // final List<Body_Temperature> btlist;
  // add_water_intake({this.btlist});
  @override
  add_waterIntakeState createState() => add_waterIntakeState();
}
final _formKey = GlobalKey<FormState>();
class add_waterIntakeState extends State<add_water_intake> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  int water_intake = 0;
  String unit = 'Milimeter';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String waterintake_date = (new DateTime.now()).toString();
  DateTime waterintakeDate;
  String waterintake_time;
  String indication = "";
  bool isDateSelected= false;
  int count = 1;
  Water_Goal water_goal = new Water_Goal();
  List<WaterIntake> waterintake_list = new List<WaterIntake>();
  Physical_Parameters pp = new Physical_Parameters();
  Additional_Info info = new Additional_Info();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List <bool> isSelected = [true, false];

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
                    'Log Water Intake',
                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
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
                            hintText: "Water Intake",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Water Intake' : null,
                          onChanged: (val){
                            setState(() => water_intake = int.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 8,),
                      ToggleButtons(
                        isSelected: isSelected,
                        highlightColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        children: <Widget> [
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Milliliter (ml)')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Ounce (oz)')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelected.length; index++){
                              if (index == newIndex) {
                                isSelected[index] = true;
                                print('Milliliter (ml)');
                              } else {
                                isSelected[index] = false;
                                print("Ounce (oz)");
                              }
                            }
                            if(newIndex == 0){
                              print('Milliliter (ml)');
                              unit = "Milliliter";
                              print(unit);
                            }
                            if(newIndex == 1){
                              print("Ounce (oz)");
                              unit = "Ounce";
                              print(unit);
                            }
                          });
                        },
                      ),
                    ],
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
                        if(value != null && value != waterintakeDate){
                          setState(() {
                            waterintakeDate = value;
                            isDateSelected = true;
                            waterintake_date = "${waterintakeDate.month}/${waterintakeDate.day}/${waterintakeDate.year}";
                          });
                          dateValue.text = waterintake_date + "\r";
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
                            waterintake_time = "$hours:$min";
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
                  // DropdownButton(
                  //   hint: Text("Select items:"),
                  //   dropdownColor: Colors.grey,
                  //   icon: Icon(Icons.arrow_drop_down),
                  //   iconSize: 36,
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //   ),
                  //   value: valueChoose,
                  //   onChanged:(value) {
                  //     setState(() {
                  //       valueChoose = value;
                  //     });
                  //   },
                  //   items: degrees.map((valueItem) {
                  //     return DropdownMenuItem(
                  //         value: valueItem,
                  //         child: Text(valueItem),
                  //     );
                  //   })
                  // ),
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
                            final readWaterIntake = databaseReference.child('users/' + uid + '/goal/water_intake/');
                            final readWaterGoal = databaseReference.child('users/' + uid + '/goal/water_goal/');
                            if(unit == "Ounce"){
                              String temp = "";
                              temp = (water_intake * 29.5735).toStringAsFixed(0);
                              water_intake = int.parse(temp);
                            }
                            readWaterIntake.once().then((DataSnapshot datasnapshot) {
                                if(datasnapshot.value == null){
                                  final waterintakeRef = databaseReference.child('users/' + uid + '/goal/water_intake/' + count.toString());
                                  waterintakeRef.set({"water_intake": water_intake.toString(), "dateCreated": waterintake_date,"timeCreated": waterintake_time});
                                  print("Added Water Intake Successfully! " + uid);
                                }
                                else{
                                  getWaterIntake();
                                  Future.delayed(const Duration(milliseconds: 1000), (){
                                    count = waterintake_list.length--;
                                    final waterintakeRef = databaseReference.child('users/' + uid + '/goal/water_intake/' + count.toString());
                                    waterintakeRef.set({"water_intake": water_intake.toString(), "dateCreated": waterintake_date,"timeCreated": waterintake_time});
                                    print("Added Water Intake Successfully! " + uid);
                                  });
                                }
                                readWaterGoal.once().then((DataSnapshot weightgoalsnapshot) {
                                  Map<String, dynamic> temp3 = jsonDecode(jsonEncode(weightgoalsnapshot.value));
                                  print(temp3);
                                  water_goal = Water_Goal.fromJson(temp3);
                                });

                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              waterintake_list.add(new WaterIntake(water_intake: water_intake, timeCreated: timeformat.parse(waterintake_time), dateCreated: format.parse(waterintake_date)));
                              for(var i=0;i<waterintake_list.length/2;i++){
                                var temp = waterintake_list[i];
                                waterintake_list[i] = waterintake_list[waterintake_list.length-1-i];
                                waterintake_list[waterintake_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, waterintake_list);
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
  void getWaterIntake() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWaterIntake = databaseReference.child('users/' + uid + '/goal/water_intake/');
    readWaterIntake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        waterintake_list.add(WaterIntake.fromJson(jsonString));
      });
    });
  }
  // void getIndication() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final readAddInfo = databaseReference.child('users/' + uid + '/vitals/additional_info/');
  //   int age;
  //   readAddInfo.once().then((DataSnapshot snapshot) {
  //     Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
  //     print("temp2");
  //     print(temp2);
  //     info = Additional_Info.fromJson2(temp2);
  //     age = getAge(info.birthday);
  //
  //     if(unit == "Fahrenheit"){
  //       temperature = (temperature - 32) * 5/9;
  //       unit = "Celsius";
  //     }
  //     /// NORMAL
  //     double highest = 0;
  //     /// infant 0 - 10
  //     if(age <= 10 && age >= 0){
  //       if(temperature >= 35.5 && temperature <= 37.5){
  //         indication = "normal";
  //       }
  //       highest = 37.5;
  //     }
  //     /// 11 - 65
  //     if(age <= 65 && age >= 11){
  //       if(temperature >= 36.4 && temperature <= 37.6){
  //         indication = "normal";
  //       }
  //       highest = 37.6;
  //     }
  //     /// 65 above
  //     if(age > 65){
  //       if(temperature >= 35.8 && temperature <= 36.9){
  //         indication = "normal";
  //       }
  //       highest = 36.9;
  //     }
  //     /// LOW GRADE FEVER
  //     if(temperature >= highest && temperature <= 38){
  //       indication = "low grade fever";
  //     }
  //     /// HIGH GRADE FEVER
  //     if(temperature > 38){
  //       indication = "high grade fever";
  //     }
  //
  //   });
  // }

  int getAge (DateTime birthday) {
    DateTime today = new DateTime.now();
    String days1 = "";
    String month1 = "";
    String year1 = "";
    int d = int.parse(DateFormat("dd").format(birthday));
    int m = int.parse(DateFormat("MM").format(birthday));
    int y = int.parse(DateFormat("yyyy").format(birthday));
    int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));
    int age = 0;
    age = y1 - y;
    print(age);

    // dec < jan
    if(m1 < m){
      print("month --");
      age--;
    }
    else if (m1 == m){
      if(d1 < d){
        print("day --");
        age--;
      }
    }
    return age;
  }
}