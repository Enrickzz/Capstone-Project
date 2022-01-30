import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/management_plan/exercise_plan/specific_exercise_plan_patient_view.dart';
import 'package:my_app/management_plan/exercise_plan/specific_exercise_plan_supp_view.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsDoctor.dart';
import '../../fitness_app_theme.dart';
import 'package:my_app/data_inputs/medicine_intake/add_medication.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/management_plan/food_plan/add_food_prescription.dart';
import 'package:my_app/management_plan/food_plan/specific_food_plan_patient_view.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class exercise_prescription_supp_view extends StatefulWidget {
  final AnimationController animationController;
  final List<Medication_Prescription> preslist;
  final int pointer;
  exercise_prescription_supp_view({Key key,this.animationController, this.preslist, this.pointer}): super(key: key);
  @override
  _exercise_prescriptionState createState() => _exercise_prescriptionState();
}

class _exercise_prescriptionState extends State<exercise_prescription_supp_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<ExPlan> extemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  Users doctor = new Users();

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    extemp.clear();
    getExercise();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF2F3F8),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('My Exercise and Activity Planner', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,

        ),
        body: ListView.builder(
            itemCount: extemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.fitness_center ),
                    title: Text("Purpose: "  + extemp[index].purpose ,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Planned by: Dr."  + extemp[index].doctor_name,
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${extemp[index].dateCreated.month}/${extemp[index].dateCreated.day}/${extemp[index].dateCreated.year}" ,
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,


                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificExercisePrescriptionViewAsSupport(animationController: widget.animationController, thislist: extemp, index: index)),
                      );
                    }

                ),

              ),
            )
        )
    );
  }
  String getDateFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    if(date != null){
      var dateTime = DateTime.parse(date);
      var hours = dateTime.hour.toString().padLeft(2, "0");
      var min = dateTime.minute.toString().padLeft(2, "0");
      return "$hours:$min";
    }
  }
  void getExercise() {
    final User user = auth.currentUser;
    final uid = user.uid;
    print("get exercise");
    final readExPlan = databaseReference.child('users/' + uid + '/management_plan/exercise_prescription/');
    readExPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        extemp.add(ExPlan.fromJson(jsonString));
      });
      extemp = extemp.reversed.toList();
    });
  }
}