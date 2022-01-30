import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/management_plan/vitals_plan/edit_vitals_prescription.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'package:my_app/additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'package:my_app/dialogs/policy_dialog.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/management_plan/medication_prescription/add_medication_prescription.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/edit_medication_prescription.dart';






class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificVitalsPrescriptionViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificVitalsPrescriptionViewAsDoctor extends StatefulWidget {
  SpecificVitalsPrescriptionViewAsDoctor({Key key, this.title, this.userUID, this.index, this.thislist}) : super(key: key);
  final String title;
  String userUID;
  int index;
  List<Vitals> thislist;
  @override
  _SpecificVitalsPrescriptionViewAsDoctorState createState() => _SpecificVitalsPrescriptionViewAsDoctorState();
}

class _SpecificVitalsPrescriptionViewAsDoctorState extends State<SpecificVitalsPrescriptionViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Vitals> templist = [];
  Users doctor = new Users();
  String purpose = "";
  String type = "";
  String frequency = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";
  bool prescribedDoctor = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    final User user = auth.currentUser;
    final uid = user.uid;
    templist.clear();
    templist = widget.thislist;
    purpose = templist[widget.index].purpose;
    type = templist[widget.index].type;
    frequency = templist[widget.index].frequency.toString();
    important_notes = templist[widget.index].important_notes;
    prescribedBy = templist[widget.index].doctor_name;
    dateCreated = "${templist[widget.index].dateCreated.month}/${templist[widget.index].dateCreated.day}/${templist[widget.index].dateCreated.year}";
    if(templist[widget.index].prescribedBy == uid){
      prescribedDoctor = true;
    }
    // getFoodplan();

    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Vitals Recording Plan'),
          actions: [
            Visibility(
              visible: prescribedDoctor,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      int initLeng=templist.length;
                      _showMyDialogDelete().then((value) {
                        if(initLeng != templist.length){
                          Navigator.pop(context,value);
                        }
                      });
                    },
                    child: Icon(
                      Icons.delete,
                    ),
                  )
              ),
            ),
          ],
        ),
        body:  WillPopScope(
          onWillPop: () async{
            Navigator.pop(context,templist);
            return true;
          },
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Column(
                    children: [
                      Visibility(
                        visible: prescribedDoctor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Expanded(
                                  child: Text( "Vitals Recording Plan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:Color(0xFF4A6572),
                                      )
                                  ),
                                ),
                                Visibility(
                                  visible: prescribedDoctor,
                                  child: InkWell(
                                      highlightColor: Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      onTap: () {
                                        showModalBottomSheet(context: context,
                                          isScrollControlled: true,
                                          builder: (context) => SingleChildScrollView(child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: edit_vitals_prescription(index: widget.index, thislist: widget.thislist, userUID: widget.userUID),
                                          ),
                                          ),
                                        ).then((value) =>
                                            Future.delayed(const Duration(milliseconds: 1500), (){
                                              setState((){
                                                Vitals newV = value;
                                                purpose = newV.purpose;
                                                type = newV.type;
                                                frequency = newV.frequency.toString();
                                                important_notes = newV.important_notes;
                                                prescribedBy = newV.prescribedBy;
                                                dateCreated = "${newV.dateCreated.month}/${newV.dateCreated.day}/${newV.dateCreated.year}";

                                                templist[widget.index].purpose =purpose;
                                                templist[widget.index].type = type;
                                                templist[widget.index].frequency = int.parse(frequency.toString());
                                                templist[widget.index].important_notes = important_notes;
                                                templist[widget.index].prescribedBy =prescribedBy;
                                                templist[widget.index].dateCreated =  newV.dateCreated;
                                                setState(() {

                                                });
                                              });
                                            }));
                                      },
                                      // child: Padding(
                                      // padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Text( "Edit",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color:Color(0xFF2633C5),

                                              )
                                          ),
                                        ],
                                      )
                                    // )
                                  ),
                                )
                              ]
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 400,
                          // height: 500, if may contact number and email
                          // margin: EdgeInsets.only(bottom: 50),
                          child: Stack(
                              children: [
                                Positioned(
                                    child: Material(
                                      child: Center(
                                        child: Container(
                                            width: 340,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    blurRadius: 20.0)],
                                            )
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Purpose",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(purpose,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Text("Recorded Vital",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(type,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text("Frequency",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Record " + frequency + " times a day.",
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text("Important Notes/Assessments",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(important_notes,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                            ]
                                        ),
                                      ),
                                    ))
                              ]
                          )
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 150,
                          // height: 500, if may contact number and email
                          // margin: EdgeInsets.only(bottom: 50),
                          child: Stack(
                              children: [
                                Positioned(
                                    child: Material(
                                      child: Center(
                                        child: Container(
                                            width: 340,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    blurRadius: 20.0)],
                                            )
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Planned by",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Dr." + prescribedBy,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Text("Date Planned",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(dateCreated,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                            ]
                                        ),
                                      ),
                                    ))
                              ]
                          )
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        )
    );


  }
  void getFoodplan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    final readVitals = databaseReference.child('users/' + userUID + '/management_plan/vitals_plan/');
    int index = widget.index;
    List<Vitals> temp1 = [];
    readVitals.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        temp1.add(Vitals.fromJson(jsonString));
      });
      for(var i=0;i<temp1.length/2;i++){
        var temp = temp1[i];
        temp1[i] = temp1[temp1.length-1-i];
        temp1[temp1.length-1-i] = temp;
      }
      final readDoctorName = databaseReference.child('users/' + temp1[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      if(temp1[index].prescribedBy == uid){
        prescribedDoctor = true;
      }
      purpose = temp1[index].purpose;
      type = temp1[index].type;
      frequency = temp1[index].frequency.toString();
      important_notes = temp1[index].important_notes ;
      dateCreated = "${temp1[index].dateCreated.month}/${temp1[index].dateCreated.day}/${temp1[index].dateCreated.year}";
    });
  }
  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                final User user = auth.currentUser;
                final uid = user.uid;
                int initial_length = templist.length;
                templist.removeAt(widget.index);
                /// delete fields
                for(int i = 1; i <= initial_length; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/vitals_plan/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < templist.length; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/vitals_plan/' + (i+1).toString());
                  bpRef.set({
                    "purpose": templist[i].purpose.toString(),
                    "type": templist[i].type.toString(),
                    "frequency": templist[i].frequency.toString(),
                    "important_notes": templist[i].important_notes.toString(),
                    "prescribedBy": templist[i].prescribedBy.toString(),
                    "dateCreated": "${templist[i].dateCreated.month.toString().padLeft(2,"0")}/${templist[i].dateCreated.day.toString().padLeft(2,"0")}/${templist[i].dateCreated.year}",
                  });
                }
                Navigator.pop(context, templist);
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

