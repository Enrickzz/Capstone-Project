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

class change_water_intake_goal extends StatefulWidget {
  // final List<Body_Temperature> btlist;
  // add_water_intake({this.btlist});
  @override
  change_waterIntakeState createState() => change_waterIntakeState();
}
final _formKey = GlobalKey<FormState>();
class change_waterIntakeState extends State<change_water_intake_goal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double target_waterintake = 0;
  String unit = 'Milliliter';
  int count = 1;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  DateTime now = new DateTime.now();
  Water_Goal water_goal = new Water_Goal();
  Physical_Parameters pp = new Physical_Parameters();

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
                    'Daily Water Intake Goal',
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
                            hintText: "Water Intake Goals",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter Water Intake Goal' : null,
                          onChanged: (val){
                            setState(() => target_waterintake = double.parse(val));
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
                                print("Milliliter (ml)");
                              } else {
                                isSelected[index] = false;
                                print("Ounce (oz)");
                              }
                            }
                            if(newIndex == 0){
                              print("Milliliter (ml)");
                              unit = "Milliliter";
                            }
                            if(newIndex == 1){
                              print("Ounce (oz)");
                              unit = "Ounce";

                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),



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
                          'Proceed',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:()  {
                          _showMyDialogDelete();

                        },
                      )
                    ],
                  ),

                ]
            )
        )
    );
  }

  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Water Intake Goal'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("Water is essential to good health and helps prevent dehydration. While water needs vary from person to person, we often need at laest 1893 ml or 64 oz of water a day.",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                try{
                  final User user = auth.currentUser;
                  final uid = user.uid;
                  final readWaterGoal = databaseReference.child('users/' + uid + '/goal/water_goal/');
                  final readPPWeight = databaseReference.child('users/' + uid + '/physical_parameters/');
                  if(unit == "Ounce"){
                    target_waterintake *= 29.5735;
                  }
                  readWaterGoal.once().then((DataSnapshot datasnapshot) {
                    readPPWeight.once().then((DataSnapshot snapshot) {
                      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                      print(temp);
                      pp = Physical_Parameters.fromJson(temp);
                      final watergoalRef = databaseReference.child('users/' + uid + '/goal/water_goal/');
                      watergoalRef.update({
                        "water_goal": target_waterintake.toString(),
                        "water_unit": "Milliliter",
                        "dateCreated": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                      });
                      print("Updated Water Goal Successfully! " + uid);
                    });
                  });
                  Future.delayed(const Duration(milliseconds: 1000), (){
                    print("POP HERE ==========");
                    Navigator.pop(context, water_goal);
                  });
                } catch(e) {
                  print("you got an error! $e");
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void getWaterGoal() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWaterGoal = databaseReference.child('users/' + uid + '/goal/water_goal/');
    readWaterGoal.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        water_goal = Water_Goal.fromJson(jsonString);
      });
    });
  }
}