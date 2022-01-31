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
import 'package:my_app/management_plan/exercise_plan/specific_exercise_plan_doctor_view.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/management_plan/medication_prescription/specific_medical_prescription_viewAsDoctor.dart';
import '../../fitness_app_theme.dart';
import 'package:my_app/data_inputs/medicine_intake/add_medication.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/management_plan/food_plan/add_food_prescription.dart';
import 'package:my_app/management_plan/food_plan/specific_food_plan_doctor_view.dart';

import 'add_exercise_prescription.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class exercise_prescription_doctor_view extends StatefulWidget {
  final List<Medication_Prescription> preslist;
  final int pointer;
  String userUID;
  final List<Connection> connection_list;
  exercise_prescription_doctor_view({Key key, this.preslist, this.pointer, this.userUID, this.connection_list}): super(key: key);
  @override
  _exercise_prescriptionState createState() => _exercise_prescriptionState();
}

class _exercise_prescriptionState extends State<exercise_prescription_doctor_view> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<ExPlan> extemp = [];
  List<Connection> connection_list = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  String purpose = "";
  String dateCreated = "";
  Users doctor = new Users();
  List<String> doctor_names = [];

  @override
  void initState() {
    super.initState();
    // final User user = auth.currentUser;
    // final uid = user.uid;
    connection_list.clear();
    extemp.clear();
    connection_list = widget.connection_list;
    getExercise(connection_list);
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
          title: const Text('Exercise and Activity Planner', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: add_exercise_prescription(thislist: extemp, userUID: widget.userUID),
                      ),
                      ),
                    ).then((value) =>
                        Future.delayed(const Duration(milliseconds: 1500), (){
                          setState((){
                            if(value != null){
                              setState(() {
                                extemp.insert(0, value);
                                doctor_names.insert(0, doctor.lastname);
                              });
                            }
                          });
                        }));
                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),
          ],
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
                    title: Text("Purpose: " + extemp[index].purpose ,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Planned by: Dr." + extemp[index].doctor_name,
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
                        MaterialPageRoute(builder: (context) => SpecificExercisePrescriptionViewAsDoctor(thislist: extemp,userUID: widget.userUID, index: index)),
                      ).then((value) {
                        if(value!= null){
                          extemp = value;
                          setState(() {

                          });
                        }
                      });
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
  void getExercise(List<Connection> connections) {
    final User user = auth.currentUser;
    final uid = user.uid;
    List<int> delete_list = [];
    String userUID = widget.userUID;
    final readExPlan = databaseReference.child('users/' + userUID + '/management_plan/exercise_prescription/');
    readExPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        extemp.add(ExPlan.fromJson(jsonString));
      });
      for(int i = 0; i < extemp.length; i++){
        final readDoctor = databaseReference.child('users/' + extemp[i].prescribedBy + '/personal_info/');
        readDoctor.once().then((DataSnapshot snapshot){
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          if(temp != null){
            doctor = Users.fromJson(temp);
            doctor_names.add(doctor.lastname);
          }
        });
      }
        setState(() {
          for(int i = 0; i < extemp.length; i++){
            if(extemp[i].prescribedBy != uid){
              for(int j = 0; j < connections.length; j++){
                if(extemp[i].prescribedBy == connections[j].createdBy){
                  if(connections[j].explan != "true"){
                    /// dont add
                    delete_list.add(i);
                  }
                  else{
                    /// add
                  }
                }
              }
            }
            // final readDoctor = databaseReference.child('users/' + extemp[i].prescribedBy + '/personal_info/');
            // readDoctor.once().then((DataSnapshot snapshot){
            //   Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
            //   if(temp != null){
            //     doctor = Users.fromJson(temp);
            //     doctor_names.add(doctor.lastname);
            //   }
            // });
          }
        });
        delete_list.sort((a, b) => b.compareTo(a));
        for(int i = 0; i < delete_list.length; i++){
          extemp.removeAt(delete_list[i]);
        }
        for(var i=0;i<extemp.length/2;i++){
          var temp = extemp[i];
          extemp[i] = extemp[extemp.length-1-i];
          extemp[extemp.length-1-i] = temp;
        }
      });

  }
}