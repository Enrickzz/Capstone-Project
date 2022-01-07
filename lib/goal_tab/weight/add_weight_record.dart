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
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_weight_record extends StatefulWidget {
  // final List<Body_Temperature> btlist;
  // add_water_intake({this.btlist});
  @override
  add_weightState createState() => add_weightState();
}
final _formKey = GlobalKey<FormState>();
class add_weightState extends State<add_weight_record> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double current_weight = 0;
  double bmi = 0;
  String unit = 'Kilograms';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String weight_date = (new DateTime.now()).toString();
  DateTime weightDate;
  String weight_time;
  String indication = "";
  bool isDateSelected= false;
  int count = 1;
  Weight_Goal weight_goal = new Weight_Goal();
  List<Weight> weights = new List<Weight>();
  bool isCongratulation = false;
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
                    'Log Weight',
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
                            hintText: "Weight",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Temperature' : null,
                          onChanged: (val){
                            setState(() => current_weight = double.parse(val));
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
                              child: Text('Kilograms (kg)')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Pounds (ibs)')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelected.length; index++){
                              if (index == newIndex) {
                                isSelected[index] = true;
                                print("Kilograms (kg)");
                              } else {
                                isSelected[index] = false;
                                print("Pounds (ibs)");
                              }
                            }
                            if(newIndex == 0){
                              print("Kilograms (kg)");
                              unit = "Kilograms";
                            }
                            if(newIndex == 1){
                              print("Fahrenheit (ibs)");
                              unit = "Pounds";

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
                        if(value != null && value != weightDate){
                          setState(() {
                            weightDate = value;
                            isDateSelected = true;
                            weight_date = "${weightDate.month}/${weightDate.day}/${weightDate.year}";
                          });
                          dateValue.text = weight_date + "\r";
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
                            weight_time = "$hours:$min";
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
                        onPressed: (){
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readWeight = databaseReference.child('users/' + uid + '/goal/weight/');
                            final readheight = databaseReference.child('users/' + uid + '/physical_parameters/');
                            final readWeightGoal = databaseReference.child('users/' + uid + '/goal/weight_goal/');
                            if(unit == "Pounds"){
                              current_weight *= 0.453592;
                            }
                            readWeight.once().then((DataSnapshot datasnapshot) {
                              readheight.once().then((DataSnapshot snapshot) {
                                Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                                pp = Physical_Parameters.fromJson(temp);
                                bmi = current_weight / ((pp.height * 0.01) * (pp.height * 0.01));

                              if(datasnapshot.value == null){
                                final weightRef = databaseReference.child('users/' + uid + '/goal/weight/' + count.toString());
                                weightRef.set({"weight": current_weight.toStringAsFixed(1),"bmi": bmi.toStringAsFixed(1) , "dateCreated": weight_date,"timeCreated": weight_time});
                                print("Added Weight Successfully! " + uid);
                              }
                              else{
                                getWeight();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = weights.length--;
                                  final weightRef = databaseReference.child('users/' + uid + '/goal/weight/' + count.toString());
                                  weightRef.set({"weight": current_weight.toStringAsFixed(1),"bmi": bmi.toStringAsFixed(1) , "dateCreated": weight_date,"timeCreated": weight_time});
                                  print("Added Weight Successfully! " + uid);
                                });
                              }
                                readWeightGoal.once().then((DataSnapshot weightgoalsnapshot) {
                                  Map<String, dynamic> temp3 = jsonDecode(jsonEncode(weightgoalsnapshot.value));
                                  print(temp3);
                                  weight_goal = Weight_Goal.fromJson2(temp3);
                                  print(weight_goal.weight_goal);
                                  if(weight_goal.objective == "Gain"){
                                    if(current_weight >= double.parse(weight_goal.weight_goal)){
                                      isCongratulation = true;
                                    }
                                  }
                                  if(weight_goal.objective == "Lose"){
                                    if(current_weight <= double.parse(weight_goal.weight_goal)){
                                      isCongratulation = true;
                                    }
                                  }
                                  if(weight_goal.objective == "Maintain"){
                                    if(current_weight == double.parse(weight_goal.weight_goal)){
                                      isCongratulation = true;
                                    }
                                  }
                                });
                              });
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("weights LENGTH: " + weights.length.toString());
                              weights.add(new Weight(weight: current_weight, bmi: bmi, timeCreated: timeformat.parse(weight_time), dateCreated: format.parse(weight_date)));
                              for(var i=0;i<weights.length/2;i++){
                                var temp = weights[i];
                                weights[i] = weights[weights.length-1-i];
                                weights[weights.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, weights);
                            });

                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("isCongratulation");
                              print(isCongratulation);
                              if(isCongratulation){
                                _showCongratulations();
                              }
                            });

                          } catch(e) {
                            print("you got an error! $e");
                          }

                        },
                        // onPressed:() async {
                        //   try{
                        //     final User user = auth.currentUser;
                        //     final uid = user.uid;
                        //     final readTemperature = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/');
                        //     readTemperature.once().then((DataSnapshot datasnapshot) {
                        //       String temp1 = datasnapshot.value.toString();
                        //       print("temp1 " + temp1);
                        //
                        //
                        //       if(datasnapshot.value == null){
                        //         final temperatureRef = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/' + count.toString());
                        //         getIndication();
                        //         Future.delayed(const Duration(milliseconds: 1000), (){
                        //           temperatureRef.set({"unit": unit.toString(), "temperature": temperature.toStringAsFixed(1), "bt_date": temperature_date.toString(), "bt_time": temperature_time.toString(), "indication": indication.toString()});
                        //           print("Added Body Temperature Successfully! " + uid);
                        //         });
                        //       }
                        //       else{
                        //         // String tempUnit = "";
                        //         // String tempTemperature = "";
                        //         // String tempTemperatureDate = "";
                        //         // String tempTemperatureTime = "";
                        //         // for(var i = 0; i < temp.length; i++){
                        //         //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                        //         //   List<String> splitFull = full.split(" ");
                        //         //   switch(i%4){
                        //         //     case 0: {
                        //         //       print("i value" + i.toString() + splitFull.last);
                        //         //       tempUnit = splitFull.last;
                        //         //     }
                        //         //     break;
                        //         //     case 1: {
                        //         //       print("i value" + i.toString() + splitFull.last);
                        //         //       tempTemperatureDate = splitFull.last;
                        //         //     }
                        //         //     break;
                        //         //     case 2: {
                        //         //       print("i value" + i.toString() + splitFull.last);
                        //         //       tempTemperature = splitFull.last;
                        //         //     }
                        //         //     break;
                        //         //     case 3: {
                        //         //       print("i value" + i.toString() + splitFull.last);
                        //         //       tempTemperatureTime = splitFull.last;
                        //         //       body_temperature = new Body_Temperature(unit: tempUnit, temperature: double.parse(tempTemperature),bt_date: format.parse(tempTemperatureDate), bt_time: timeformat.parse(tempTemperatureTime));
                        //         //       body_temp_list.add(body_temperature);
                        //         //     }
                        //         //     break;
                        //         //   }
                        //         // }
                        //         getBodyTemp();
                        //         getIndication();
                        //         Future.delayed(const Duration(milliseconds: 1000), (){
                        //           count = body_temp_list.length--;
                        //           print("count " + count.toString());
                        //           final temperatureRef = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/' + count.toString());
                        //           temperatureRef.set({"unit": unit.toString(), "temperature": temperature.toStringAsFixed(1), "bt_date": temperature_date.toString(), "bt_time": temperature_time.toString(), "indication": indication.toString()});
                        //           print("Added Body Temperature Successfully! " + uid);
                        //         });
                        //
                        //       }
                        //
                        //     });
                        //
                        //     Future.delayed(const Duration(milliseconds: 1000), (){
                        //       print("SYMPTOMS LENGTH: " + body_temp_list.length.toString());
                        //       body_temp_list.add(new Body_Temperature(unit: unit, temperature: temperature,bt_date: format.parse(temperature_date), bt_time: timeformat.parse(temperature_time), indication: indication));
                        //       for(var i=0;i<body_temp_list.length/2;i++){
                        //         var temp = body_temp_list[i];
                        //         body_temp_list[i] = body_temp_list[body_temp_list.length-1-i];
                        //         body_temp_list[body_temp_list.length-1-i] = temp;
                        //       }
                        //       print("POP HERE ==========");
                        //       Navigator.pop(context, body_temp_list);
                        //     });
                        //
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
  void getWeightGoal() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeightGoal = databaseReference.child('users/' + uid + '/goal/weight_goal/');
    readWeightGoal.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        weight_goal = Weight_Goal.fromJson(jsonString);
      });
    });
  }
  void getWeight() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWeight = databaseReference.child('users/' + uid + '/goal/weight/');
    readWeight.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        weights.add(Weight.fromJson(jsonString));
      });
    });
  }


  Future<void> _showCongratulations() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("You have achieved the goal you have set for your weight. We are so proud of your progress towards a healthier lifestyle. You can set your a new weight goal for yourself if you want.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it'),
              onPressed: () {
                print('Save');
                Navigator.of(context).pop();

              },
            ),

          ],
        );
      },
    );
  }
}