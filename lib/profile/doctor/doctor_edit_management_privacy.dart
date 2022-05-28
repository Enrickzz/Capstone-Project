import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/users.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class doctor_edit_management_privacy extends StatefulWidget {
  final List<Medication_Prescription> thislist;
  final String userUID;
  final String doctorUID;
  final Connection connection;
  final int index;
  doctor_edit_management_privacy({this.thislist, this.userUID, this.doctorUID, this.connection, this.index});
  @override
  _editManagementPrivacyState createState() => _editManagementPrivacyState();
}
final _formKey = GlobalKey<FormState>();
class _editManagementPrivacyState extends State<doctor_edit_management_privacy> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<Connection> connections = [];
  List<Connection> doctor_connection = [];
  Connection curr_connection;
  String doctor1 = "";
  String doctor2 = "";
  bool isAllowedMedicalPrescription = false;
  bool isAllowedFoodPlan = false;
  bool isAllowedExercisePlan = false;
  bool isAllowedVitalsRecording = false;
  bool showDisclaimer = false;
  int index = 1;

  @override
  void initState(){
    super.initState();
    Connection doctorconnection = widget.connection;
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    String doctorUID = widget.doctorUID;
    final readDoctorConnection = databaseReference.child('users/' + userUID + '/personal_info/d2dconnections/');
    readDoctorConnection.once().then((DataSnapshot datasnapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
      if(datasnapshot.value != null){
        temp.forEach((jsonString) {
          // if(jsonString.toString().contains(userUID)){
          connections.add(Connection.fromJson2(jsonString));
          // }
        });
      }
      for(var i = 0; i < connections.length; i++){
        if((connections[i].doctor1 == uid && connections[i].doctor2 == doctorUID) || (connections[i].doctor2 == uid && connections[i].doctor1 == doctorUID)){
          curr_connection = connections[i];
          index = i + 1;
        }
      }
      if(curr_connection != null){
        if(curr_connection.doctor1 == uid){
          if(curr_connection.medpres1.toLowerCase() == "true"){
            isAllowedMedicalPrescription = true;
          }
          if(curr_connection.foodplan1.toLowerCase() == "true"){
            isAllowedFoodPlan = true;
          }
          if(curr_connection.explan1.toLowerCase() == "true"){
            isAllowedExercisePlan = true;
          }
          if(curr_connection.vitals1.toLowerCase() == "true"){
            isAllowedVitalsRecording = true;
          }
        }
        if(curr_connection.doctor2 == uid){
          if(curr_connection.medpres2.toLowerCase() == "true"){
            isAllowedMedicalPrescription = true;
          }
          if(curr_connection.foodplan2.toLowerCase() == "true"){
            isAllowedFoodPlan = true;
          }
          if(curr_connection.explan2.toLowerCase() == "true"){
            isAllowedExercisePlan = true;
          }
          if(curr_connection.vitals2.toLowerCase() == "true"){
            isAllowedVitalsRecording = true;
          }
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    "Edit Management Plan Access",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 12.0),
                  Divider(),
                  SwitchListTile(
                    title: Text('Medical Prescription', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor to see My Prescribed Medications', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showMedicalPrescription();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedMedicalPrescription,
                    onChanged: (value){
                      setState(() {
                        isAllowedMedicalPrescription = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),


                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Food Plan', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor Systems to see My Prescribed Food Plans', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showFoodPlan();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedFoodPlan,
                    onChanged: (value){
                      setState(() {
                        isAllowedFoodPlan = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),

                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Exercise Plan', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor Systems to see My Prescribed Exercise Plans', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showExercise();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedExercisePlan,
                    onChanged: (value){
                      setState(() {
                        isAllowedExercisePlan = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),

                  SizedBox(height: 14.0),
                  SwitchListTile(
                    title: Text('Vitals Recording', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    subtitle: Text('Allow this Doctor Systems to see My Prescribed Vitals Recording', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w900)),
                    secondary: IconButton(
                      icon: Image.asset("assets/images/tite.png"),
                      onPressed: () {
                        showVitalsRecording();

                      },
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: isAllowedVitalsRecording,
                    onChanged: (value){
                      setState(() {
                        isAllowedVitalsRecording = value;
                        // if(isAllowedFoodPlan == true && isAllowedExercisePlan == true && isAllowedMedicalPrescription == true && isAllowedVitalsRecording == true){
                        //   showDisclaimer = false;
                        // }
                        // else{
                        //   showDisclaimer = true;
                        //
                        // }

                      });
                    },
                  ),

                  SizedBox(height: 16.0),
                  Visibility(
                    visible: showDisclaimer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Disclaimer: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                          ),

                        ),
                        SizedBox(height: 8.0),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Your designated management plan for the patient is considered important for other doctors to know about.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                          ),

                        ),

                      ],
                    ),
                  ),
                  Divider(),


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
                          'Change',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          _showMyDialog().then((value){
                            Navigator.pop(context);
                          });
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  Future<void> showMedicalPrescription() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Medical Prescriptions'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed medication for this patient.",
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showFoodPlan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Food Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed food plan for this patient.",
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showExercise() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exercise Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed exercise plan for this patient.",
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showVitalsRecording() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vitals Recording Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text("The digital record for your prescribed vitals recording plan for this patient.",
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Change'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to change access to your management plan?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                try{

                  final User user = auth.currentUser;
                  final uid = user.uid;
                  bool check = false;
                  bool isConnected = false;
                  String userUID = widget.userUID;
                  /// doctorUID = doctor B
                  /// uid = doctor A
                    if(curr_connection.doctor1 == uid){
                      final doctorConnectionsRef = databaseReference.child('users/' + userUID + '/personal_info/d2dconnections/'+ (index).toString());
                      doctorConnectionsRef.update({
                        "medpres1": isAllowedMedicalPrescription.toString(),
                        "foodplan1": isAllowedFoodPlan.toString(),
                        "explan1": isAllowedExercisePlan.toString(),
                        "vitals1": isAllowedVitalsRecording.toString(),
                      });
                    }
                    if(curr_connection.doctor2 == uid){
                      final doctorConnectionsRef = databaseReference.child('users/' + userUID + '/personal_info/d2dconnections/'+ (index).toString());
                      doctorConnectionsRef.update({
                        "medpres2": isAllowedMedicalPrescription.toString(),
                        "foodplan2": isAllowedFoodPlan.toString(),
                        "explan2": isAllowedExercisePlan.toString(),
                        "vitals2": isAllowedVitalsRecording.toString(),
                      });
                    }

                  Navigator.pop(context);
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

}