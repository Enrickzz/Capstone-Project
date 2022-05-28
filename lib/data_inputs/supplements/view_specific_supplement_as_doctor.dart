import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/users.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificSupplementViewAsDoctor(),
    );
  }
}

class SpecificSupplementViewAsDoctor extends StatefulWidget {
  SpecificSupplementViewAsDoctor({Key key, this.userUID, this.index}) : super(key: key);
  // final String title;
  String userUID;
  int index;
  @override
  _SpecificSupplementViewAsDoctorState createState() => _SpecificSupplementViewAsDoctorState();
}

class _SpecificSupplementViewAsDoctorState extends State<SpecificSupplementViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Supplement_Prescription> listtemp = [];
  // Supplement_Prescription listtemp = new Supplement_Prescription();
  Users doctor = new Users();
  String supplement_name = "";
  String intake_time = "";
  String dosage = "";
  String prescription_unit = "";
  String dateCreated = "";


  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    getSupplement();
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
                              child: Text( supplement_name,
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
                                            Text(dosage + " ",
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
                                            Text(intake_time,
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
  void getSupplement() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    var userUID = widget.userUID;
    int index = widget.index;
    final readsupplement = databaseReference.child('users/' + userUID + '/management_plan/supplement_prescription_list/');
    readsupplement.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        listtemp.add(Supplement_Prescription.fromJson(jsonString));
        // final readDoctorName = databaseReference.child('users/' + supplement.prescribedBy + '/personal_info/');
        // readDoctorName.once().then((DataSnapshot snapshot){
        //   Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        //   print(temp2);
        //   doctor = Users.fromJson(temp2);
        //   prescribedBy = doctor.lastname + " " + doctor.firstname;
        // });
      });
      supplement_name = listtemp[index].supplement_name;
      intake_time = listtemp[index].intake_time;
      dosage = listtemp[index].dosage.toString();
      prescription_unit = listtemp[index].prescription_unit;
      dateCreated = "${listtemp[index].dateCreated.month}/${listtemp[index].dateCreated.day}/${listtemp[index].dateCreated.year}";

    });
  }
}

