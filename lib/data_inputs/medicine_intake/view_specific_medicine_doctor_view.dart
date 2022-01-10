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
import '../../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../../dialogs/policy_dialog.dart';
import '../../fitness_app_theme.dart';
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
      home: SpecificMedicineIntakeViewAsDoctor(),
    );
  }
}

class SpecificMedicineIntakeViewAsDoctor extends StatefulWidget {
  SpecificMedicineIntakeViewAsDoctor({Key key, this.userUID, this.index}) : super(key: key);
  // final String title;
  String userUID;
  int index;
  @override
  _SpecificSupplementViewAsDoctorState createState() => _SpecificSupplementViewAsDoctorState();
}

class _SpecificSupplementViewAsDoctorState extends State<SpecificMedicineIntakeViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Medication> listtemp = [];
  Medication medication = new Medication();
  String medicine_name = "";
  String medicine_dosage = "";
  String medicine_type = "";
  String medicine_date = "";
  String medicine_time = "";
  String medicine_unit = "";

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
                              child: Text( medicine_name,
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
                        height: 200,
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
                                            Row(
                                              children: [
                                                Text("Dosage",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text( medicine_dosage + medicine_unit,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Time Taken",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(medicine_time,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),


                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Date Taken",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(medicine_date,
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
                print('Deleted');
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
    final readintake = databaseReference.child('users/' + userUID + '/vitals/health_records/medications_list/');
    int index = widget.index;
    readintake.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        listtemp.add(Medication.fromJson(jsonString));
        // final readDoctorName = databaseReference.child('users/' + medication.prescribedBy + '/personal_info/');
        // readDoctorName.once().then((DataSnapshot snapshot){
        //   Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        //   print(temp2);
        //   doctor = Users.fromJson(temp2);
        //   prescribedBy = doctor.lastname + " " + doctor.firstname;
        // });
      });
      medicine_name = listtemp[index].medicine_name;
      medicine_type = listtemp[index].medicine_type;
      medicine_unit = listtemp[index].medicine_unit;
      medicine_dosage = listtemp[index].medicine_dosage.toString();
      medicine_date = "${listtemp[index].medicine_date.month.toString().padLeft(2, "0")}/${listtemp[index].medicine_date.day.toString().padLeft(2, "0")}/${listtemp[index].medicine_date.year}";
      medicine_time = "${listtemp[index].medicine_time.hour.toString().padLeft(2, "0")}:${listtemp[index].medicine_time.minute.toString().padLeft(2, "0")}";
    });
  }
}

