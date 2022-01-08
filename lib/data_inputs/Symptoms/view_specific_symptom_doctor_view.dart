import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
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
      home: SpecificSymptomViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificSymptomViewAsDoctor extends StatefulWidget {
  SpecificSymptomViewAsDoctor({Key key, this.title, this.userUID, this.index, this.thissymp}) : super(key: key);
  final Symptom thissymp;
  final String title;
  String userUID;
  int index;
  @override
  _SpecificSymptomViewAsDoctorState createState() => _SpecificSymptomViewAsDoctorState();
}

class _SpecificSymptomViewAsDoctorState extends State<SpecificSymptomViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;

  List<Symptom> listtemp = [];
  // Symptom listtemp = new Symptom();
  String symptomName = "";
  String intensityLvl = "";
  String symptomFelt = "";
  String symptomDate = "";
  String symptomTime = "";
  String symptomTrigger = "";
  List<String> recurring = [""];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    getMedicineIntake();
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
          title: Text('My Symptom'),

        ),
        body:  Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            Expanded(
                              child: Text(symptomName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:Color(0xFF4A6572),
                                  )
                              ),
                            ),

                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        height: 350,
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
                                            Text("Intensity Level",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(intensityLvl,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text("Symptom Area",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(symptomFelt,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Recurring Symptom Trigger",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            if (symptomTrigger.toString() != "") ...[
                                              Text(symptomTrigger,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ]else ...[
                                              Text("The recurring symptom has no trigger.",
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                if (recurring[0].toString() != "") ...[
                                                  Text("Recurring",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            if (recurring[0].toString() != "") ...[
                                              Text(recurring.toString(),
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],




                                          ]
                                      ),
                                    ),
                                  ))
                            ]
                        )
                    ),
                    Visibility(
                      visible: hasImage,
                      child: InteractiveViewer(
                        clipBehavior: Clip.none,
                        minScale: minScale,
                        maxScale: maxScale,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset('assets/images/body.PNG'
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        height: 100,
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


                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Symptom manifested on",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(symptomDate + " " + symptomTime,
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
        )
    );


  }
// Widget buildCopy() => Row(children: [
//   TextField(controller: controller),
//   IconButton(
//       icon: Icon(Icons.content_copy),
//       onPressed: (){
//         FlutterClipboard.copy(text);
//       },
//   )
//
// ],)
  void getMedicineIntake() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    var userUID = widget.userUID;
    final readsymptom = databaseReference.child('users/' + userUID + '/vitals/health_records/symptoms_list/');
    int index = widget.index;
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        listtemp.add(Symptom.fromJson(jsonString));
        // final readDoctorName = databaseReference.child('users/' + medication.prescribedBy + '/personal_info/');
        // readDoctorName.once().then((DataSnapshot snapshot){
        //   Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        //   print(temp2);
        //   doctor = Users.fromJson(temp2);
        //   prescribedBy = doctor.lastname + " " + doctor.firstname;
        // });
      });
      symptomName = listtemp[index].symptomName;
      intensityLvl = listtemp[index].intensityLvl.toString();
      symptomFelt = listtemp[index].symptomFelt;
      symptomDate = "${listtemp[index].symptomDate.month.toString().padLeft(2, "0")}/${listtemp[index].symptomDate.day.toString().padLeft(2, "0")}/${listtemp[index].symptomDate.year}";
      symptomTime = "${listtemp[index].symptomTime.hour.toString().padLeft(2, "0")}:${listtemp[index].symptomTime.minute.toString().padLeft(2, "0")}";
      symptomTrigger = listtemp[index].symptomTrigger;
      if(listtemp[index].recurring != null){
        for(int i = 0; i < listtemp[index].recurring.length; i++){
          recurring.add(listtemp[index].recurring[i]);
        }
      }
    });
  }
}