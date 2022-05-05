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
      home: SpecificPrescriptionViewAsSupport(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificPrescriptionViewAsSupport extends StatefulWidget {
  SpecificPrescriptionViewAsSupport({Key key, this.title, this.index, this.thislist}) : super(key: key);
  final String title;
  final List<Medication_Prescription> thislist;
  int index;
  @override
  _SpecificPrescriptionViewAsPatientState createState() => _SpecificPrescriptionViewAsPatientState();
}

class _SpecificPrescriptionViewAsPatientState extends State<SpecificPrescriptionViewAsSupport> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Medication_Prescription> prestemp = [];
  Medication_Prescription prescription = new Medication_Prescription();
  Users doctor = new Users();
  String generic_name = "";
  String dosage = "";
  String unit = "";
  String frequency = "";
  String special_instruction = "";
  String startDate = "";
  String endDate = "";
  String prescribedBy = "";
  String dateCreated = "";
  String brand_name = "";



  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    // getPrescription();
    prestemp = widget.thislist;
    int index = widget.index;
    brand_name = prestemp[index].branded_name;
    generic_name = prestemp[index].generic_name;
    dosage = prestemp[index].dosage.toString();
    unit = prestemp[index].prescription_unit.toString();
    frequency = prestemp[index].intake_time;
    special_instruction = prestemp[index].special_instruction;
    startDate = "${prestemp[index].startdate.month}/${prestemp[index].startdate.day}/${prestemp[index].startdate.year}";
    endDate = "${prestemp[index].enddate.month}/${prestemp[index].enddate.day}/${prestemp[index].enddate.year}";
    dateCreated = "${prestemp[index].datecreated.month}/${prestemp[index].datecreated.day}/${prestemp[index].datecreated.year}";
    prescribedBy = prestemp[index].doctor_name;
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
          title: Text('Doctor Prescriptions'),
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
                              child: Text( "Prescription Medicine",
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
                                            Text("Brand Name",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(brand_name,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text("Generic Name",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(generic_name,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
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
                                            Text(dosage + " " + unit,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text("How many times a day?",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(frequency,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text("Special Instructions",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(special_instruction,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text("Date Period",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(startDate + ' - ' + endDate,
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
                                            Text("Prescribed by",
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
                                                Text("Date Prescribed",
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
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return Image.asset("assets/images/no-image.jpg");
    }else{
      return Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
      (loadingProgress == null) ? child : CircularProgressIndicator());
    }
  }
  void getPrescription() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/management_plan/medication_prescription_list/');
    int index = widget.index;
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        prestemp.add(Medication_Prescription.fromJson(jsonString));
      });
      brand_name = prestemp[index].branded_name;
      generic_name = prestemp[index].generic_name;
      dosage = prestemp[index].dosage.toString();
      unit = prestemp[index].prescription_unit.toString();
      frequency = prestemp[index].intake_time;
      special_instruction = prestemp[index].special_instruction;
      startDate = "${prestemp[index].startdate.month}/${prestemp[index].startdate.day}/${prestemp[index].startdate.year}";
      endDate = "${prestemp[index].enddate.month}/${prestemp[index].enddate.day}/${prestemp[index].enddate.year}";
      dateCreated = "${prestemp[index].datecreated.month}/${prestemp[index].datecreated.day}/${prestemp[index].datecreated.year}";
      prescribedBy = prestemp[index].doctor_name;
    });
  }
}