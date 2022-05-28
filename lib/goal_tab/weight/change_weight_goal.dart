import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class change_weight_goal extends StatefulWidget {
  // final List<Body_Temperature> btlist;
  // add_water_intake({this.btlist});
  @override
  change_weightGoalState createState() => change_weightGoalState();
}
final _formKey = GlobalKey<FormState>();
class change_weightGoalState extends State<change_weight_goal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  String unit = "Kilograms";
  double target_weight = 0;
  bool isDateSelected= false;
  int count = 1;
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  List <bool> isSelected = [true, false];
  //weight goal
  bool goalSelected = false;
  String valueChooseWeightGoal;
  List<String> listWeightGoal = <String>[
    'Lose', 'Gain', 'Maintain',
  ];
  DateTime now = new DateTime.now();
  Weight_Goal weight_goal = new Weight_Goal();
  Physical_Parameters pp = new Physical_Parameters();


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
                    'Weight Goals',
                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'Current Weight: ' + ' kg',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  SizedBox(height: 20.0),

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
                      hintText: "My Goal is to _________ Weight ",
                    ),
                    isExpanded: true,
                    value: valueChooseWeightGoal,
                    onChanged: (newValue){
                      setState(() {
                        valueChooseWeightGoal = newValue;
                        goalSelected= true;
                      });

                    },
                    items: listWeightGoal.map((valueItem){
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    },
                    ).toList(),
                  ),

                  SizedBox(height: 8),
                  Visibility(
                    visible: goalSelected,
                    child: Row(
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
                              hintText: "Target Weight",
                            ),
                            validator: (val) => val.isEmpty ? 'Enter Water Intake Goal' : null,
                            onChanged: (val){
                              setState(() => target_weight = double.parse(val));
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
                                print("Pounds (ibs)");
                                unit = "Pounds";

                              }
                            });
                          },
                        ),
                      ],
                    ),
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
                          _showMyNewWeigtGoal();

                        },
                      )
                    ],
                  ),

                ]
            )
        )
    );
  }


  Future<void> _showMyNewWeigtGoal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Weight Goal'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("By setting your weight goal you have already taken your first step into a healthier and better lifestyle. We will be here with you every step of the way!",
                  style: TextStyle(fontSize: 16, ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Set'),
              onPressed: () {
                try{
                  final User user = auth.currentUser;
                  final uid = user.uid;
                  final readWeightGoal = databaseReference.child('users/' + uid + '/goal/weight_goal/');
                  final readPPWeight = databaseReference.child('users/' + uid + '/physical_parameters/');
                  if(unit == "Pounds"){
                    target_weight *= 0.453592;
                  }
                  readWeightGoal.once().then((DataSnapshot datasnapshot) {
                    readPPWeight.once().then((DataSnapshot snapshot) {
                      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
                      print(temp);
                      pp = Physical_Parameters.fromJson(temp);
                      final weightgoalRef = databaseReference.child('users/' + uid + '/goal/weight_goal/');
                      weightgoalRef.update({
                        "objective": valueChooseWeightGoal,
                        "target_weight": target_weight.toString(),
                        "current_weight": pp.weight.toString(),
                        "weight": pp.weight.toString(),
                        "dateCreated": "${now.month.toString().padLeft(2,"0")}/${now.day.toString().padLeft(2,"0")}/${now.year}",
                      });
                      print("Updated Weight Goal Successfully! " + uid);
                    });
                  });
                  Future.delayed(const Duration(milliseconds: 1000), (){
                    print("POP HERE ==========");
                    Navigator.pop(context, weight_goal);
                  });
                } catch(e) {
                  print("you got an error! $e");
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
}