import 'dart:convert';

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
import 'package:my_app/data_inputs/Symptoms/symptoms.dart';
import '../lab_results.dart';
import '../medication.dart';
import 'body_temperature.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class add_body_temperature extends StatefulWidget {
  final List<Body_Temperature> btlist;
  add_body_temperature({this.btlist});
  @override
  _add_body_temperatureState createState() => _add_body_temperatureState();
}
final _formKey = GlobalKey<FormState>();
class _add_body_temperatureState extends State<add_body_temperature> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double temperature = 0;
  String unit = 'Celsius';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String temperature_date = (new DateTime.now()).toString();
  DateTime temperatureDate;
  String temperature_time;
  bool isDateSelected= false;
  int count = 0;
  List<Body_Temperature> body_temp_list = new List<Body_Temperature>();
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
                    'Add Body Temperature',
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
                            hintText: "Temperature",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Temperature' : null,
                          onChanged: (val){
                            setState(() => temperature = double.parse(val));
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
                              child: Text('Celsius (°C)')
                          ),
                          Padding (
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Fahrenheit (°F)')
                          ),
                        ],
                        onPressed:(int newIndex){
                          setState(() {
                            for (int index = 0; index < isSelected.length; index++){
                              if (index == newIndex) {
                                isSelected[index] = true;
                                print("Celsius (°C)");
                              } else {
                                isSelected[index] = false;
                                print("Fahrenheit (°F)");
                              }
                            }
                            if(newIndex == 0){
                              print("Celsius (°C)");
                              unit = "Celsius";
                            }
                            if(newIndex == 1){
                              print("Fahrenheit (°F)");
                              unit = "Fahrenheit";

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
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100)
                      ).then((value){
                        if(value != null && value != temperatureDate){
                          setState(() {
                            temperatureDate = value;
                            isDateSelected = true;
                            temperature_date = "${temperatureDate.month}/${temperatureDate.day}/${temperatureDate.year}";
                          });
                          dateValue.text = temperature_date + "\r";
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
                            temperature_time = "$hours:$min";
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
                            final readTemperature = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/');
                            readTemperature.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');

                              Body_Temperature body_temperature;


                              if(datasnapshot.value == null){
                                final temperatureRef = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/' + 0.toString());
                                temperatureRef.set({"unit": unit.toString(), "temperature": temperature.toString(), "bt_date": temperature_date.toString()});
                                print("Added Body Temperature Successfully! " + uid);
                              }
                              else{
                                // String tempUnit = "";
                                // String tempTemperature = "";
                                // String tempTemperatureDate = "";
                                // String tempTemperatureTime = "";
                                // for(var i = 0; i < temp.length; i++){
                                //   String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
                                //   List<String> splitFull = full.split(" ");
                                //   switch(i%4){
                                //     case 0: {
                                //       print("i value" + i.toString() + splitFull.last);
                                //       tempUnit = splitFull.last;
                                //     }
                                //     break;
                                //     case 1: {
                                //       print("i value" + i.toString() + splitFull.last);
                                //       tempTemperatureDate = splitFull.last;
                                //     }
                                //     break;
                                //     case 2: {
                                //       print("i value" + i.toString() + splitFull.last);
                                //       tempTemperature = splitFull.last;
                                //     }
                                //     break;
                                //     case 3: {
                                //       print("i value" + i.toString() + splitFull.last);
                                //       tempTemperatureTime = splitFull.last;
                                //       body_temperature = new Body_Temperature(unit: tempUnit, temperature: double.parse(tempTemperature),bt_date: format.parse(tempTemperatureDate), bt_time: timeformat.parse(tempTemperatureTime));
                                //       body_temp_list.add(body_temperature);
                                //     }
                                //     break;
                                //   }
                                // }
                                getBodyTemp();
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = body_temp_list.length--;
                                  print("count " + count.toString());
                                  final temperatureRef = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/' + count.toString());
                                  temperatureRef.set({"unit": unit.toString(), "temperature": temperature.toString(), "bt_date": temperature_date.toString(), "bt_time": temperature_time.toString()});
                                  print("Added Body Temperature Successfully! " + uid);
                                });

                              }

                            });

                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("SYMPTOMS LENGTH: " + body_temp_list.length.toString());
                              body_temp_list.add(new Body_Temperature(unit: unit, temperature: temperature,bt_date: format.parse(temperature_date), bt_time: timeformat.parse(temperature_time)));
                              for(var i=0;i<body_temp_list.length/2;i++){
                                var temp = body_temp_list[i];
                                body_temp_list[i] = body_temp_list[body_temp_list.length-1-i];
                                body_temp_list[body_temp_list.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, body_temp_list);
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
  void getBodyTemp() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBT = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list/');
    readBT.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        body_temp_list.add(Body_Temperature.fromJson(jsonString));
      });
    });
  }
}