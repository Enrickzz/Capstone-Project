import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/users.dart';

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
  double desired_weight_low = 0;
  double desired_weight_high = 0;
  String unit = 'Kilograms';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String weight_date = (new DateTime.now()).toString();
  DateTime weightDate;
  String weight_time;
  String indication = "";
  bool isDateSelected= false;
  int count = 1;
  bool isCongratulation = false;
  Weight_Goal weight_goal = new Weight_Goal();
  List<Weight> weights = new List<Weight>();
  Physical_Parameters pp = new Physical_Parameters();
  Additional_Info info = new Additional_Info();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List <bool> isSelected = [true, false];
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  @override
  void initState(){
    initNotif();
    super.initState();
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
                                desired_weight_high = 24.9 * ((pp.height * 0.01) * (pp.height * 0.01));
                                desired_weight_low = 18.5 * ((pp.height * 0.01) * (pp.height * 0.01));
                                double bmiDouble = bmi;
                                print(bmiDouble.toString() + "<<<<<<<<< THIS");
                                if (bmiDouble < 18.5){
                                  addtoRecommendation("We recommend that you change your goals to GAIN more weight. Your desired weight should be around " + desired_weight_low.toStringAsFixed(0),
                                      "Change Weight Goal!",
                                      "2",
                                      "None",
                                      "Immediate");
                                }else if(bmiDouble >= 18.5 && bmiDouble <= 24.9){
                                 //normal
                                }else if(bmiDouble >= 25 && bmiDouble <= 29.9){
                                  addtoRecommendation("We recommend that you change your goals to LOSE weight. Your desired weight should be around " + desired_weight_high.toStringAsFixed(0),
                                      "Change Weight Goal!",
                                      "2",
                                      "None",
                                      "Immediate");
                                }else if(bmiDouble >= 30 && bmiDouble <= 34.9){
                                  addtoRecommendation("We recommend that you change your goals to LOSE weight. Your desired weight should be around " + desired_weight_high.toStringAsFixed(0),
                                      "Change Weight Goal!",
                                      "3",
                                      "None",
                                      "Immediate");
                                }else if(bmiDouble > 35){
                                  addtoRecommendation("We recommend that you change your goals to LOSE weight. Your desired weight should be around " + desired_weight_high.toStringAsFixed(0) + "kg",
                                      "Consult with your Doctor!",
                                      "3",
                                      "None",
                                      "Immediate");
                                }
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

                              });
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              print("weights LENGTH: " + weights.length.toString());
                              weights.add(new Weight(weight: current_weight, bmi: bmi, timeCreated: timeformat.parse(weight_time), dateCreated: format.parse(weight_date)));
                              readWeightGoal.once().then((DataSnapshot weightgoalsnapshot) {
                                Map<String, dynamic> temp3 = jsonDecode(jsonEncode(weightgoalsnapshot.value));
                                weight_goal = Weight_Goal.fromJson2(temp3);
                                final weightgoalRef = databaseReference.child('users/' + uid + '/goal/weight_goal/');
                                final weighPPRef = databaseReference.child('users/' + uid + '/physical_parameters/');
                                if(weight_goal.objective == "Gain"){
                                  if(current_weight >= weight_goal.target_weight){
                                    isCongratulation = true;
                                  }
                                }
                                if(weight_goal.objective == "Lose"){
                                  if(current_weight <= weight_goal.target_weight){
                                    isCongratulation = true;
                                  }
                                }
                                if(weight_goal.objective == "Maintain"){
                                  if(current_weight == weight_goal.target_weight){
                                    isCongratulation = true;
                                  }
                                }
                                weightgoalRef.once().then((DataSnapshot wgoal) {
                                  Map<String, dynamic> temp = jsonDecode(jsonEncode(wgoal.value));
                                  Weight_Goal goal = Weight_Goal.fromJson(temp);
                                  // goal.current_weight
                                  print("GOAL");
                                  print(goal.current_weight);
                                  double check = goal.current_weight - current_weight;
                                  print(check.abs());
                                  if(check.abs() >=5){
                                    final readAddinf = databaseReference.child("users/"+thisuser.uid+"/vitals/additional_info");
                                    readAddinf.once().then((DataSnapshot snapshot) {
                                      Additional_Info userInfo = Additional_Info.fromJson(jsonDecode(jsonEncode(snapshot.value)));
                                      bool check2 = false;
                                      print(snapshot.value);
                                      for(var i = 0; i < userInfo.other_disease.length; i++){
                                        if(userInfo.other_disease[i].contains("Heart Failure")) check2 = true;
                                      }
                                      for(var i = 0 ; i < userInfo.disease.length ; i++ ){
                                        if(userInfo.disease[i].contains("Heart Failure") ){
                                          check2 = true;
                                        }
                                      }
                                      if(check2 == true){
                                        addtoRecommendation("We have notified your doctor regarding your sudden weight change. This can be a sign of the progression of your heart failure and must be attended to by your doctor.",
                                            "Consult With Doctor",
                                            "3",
                                            "None",
                                            "Immediate");
                                        final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                                        readConnections.once().then((DataSnapshot snapshot2) {
                                          print(snapshot2.value);
                                          print("CONNECTION");
                                          List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                          temp.forEach((jsonString) {
                                            connections.add(Connection.fromJson(jsonString)) ;
                                            Connection a = Connection.fromJson(jsonString);
                                            print(a.doctor1);
                                            addtoNotif("Your <type> "+thisuser.firstname+" "+ thisuser.lastname + " who has heart failure has recorded a drastic change in weight. He/she may require your immediate medical attention.",
                                                thisuser.firstname + " has recorded drastic weight changes",
                                                "3",
                                                a.doctor1);
                                          });
                                        });
                                      }
                                    });
                                  }
                                });
                                /// getting the latest weight
                                var latestDate;
                                List<Weight> timesortweights = [];
                                weights.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));

                                if(weights[weights.length-1].dateCreated == weights[weights.length-2].dateCreated){
                                  latestDate = weights[weights.length-1].dateCreated;
                                  for(int i = 0; i < weights.length; i++){
                                    if(weights[i].dateCreated == latestDate){
                                      timesortweights.add(weights[i]);
                                    }
                                  }
                                  timesortweights.sort((a,b) => a.timeCreated.compareTo(b.timeCreated));
                                  weightgoalRef.update({"current_weight": timesortweights[timesortweights.length-1].weight.toStringAsFixed(1)});
                                  weighPPRef.update({"weight": timesortweights[timesortweights.length-1].weight.toStringAsFixed(1)});
                                }
                                else{
                                  timesortweights = weights;
                                  weightgoalRef.update({"current_weight": timesortweights[timesortweights.length-1].weight.toStringAsFixed(1)});
                                  weighPPRef.update({"weight": timesortweights[timesortweights.length-1].weight.toStringAsFixed(1)});
                                }
                              });
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
                      )
                    ],
                  ),

                ]
            )
        )
    );
  }
  void addtoNotif(String message, String title, String priority,String uid) async{
    print ("ADDED TO NOTIFICATIONS");
    notifsList.clear();
    await getNotifs(uid).then((value) {
      final ref = databaseReference.child('users/' + uid + '/notifications/');
      String redirect = "";
      ref.once().then((DataSnapshot snapshot) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "notification", "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
          ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "notification", "redirect": redirect});

        }
      });
    });
  }
  Future<void> getNotifs(String uid) async{
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void addtoRecommendation(String message, String title, String priority, String redirect,String category){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": category, "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": category, "redirect": redirect});
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