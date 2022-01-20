import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/data_inputs/supplements/edit_supplements.dart';
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
      home: SpecificSupplementViewAsPatient(),
    );
  }
}

class SpecificSupplementViewAsPatient extends StatefulWidget {
  SpecificSupplementViewAsPatient({Key key, this.index}) : super(key: key);
  // final String title;
  // String userUID;
  int index;
  @override
  _SpecificSupplementViewAsPatientState createState() => _SpecificSupplementViewAsPatientState();
}

class _SpecificSupplementViewAsPatientState extends State<SpecificSupplementViewAsPatient> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Supplement_Prescription> listtemp = [];
  String supplement_name = "";
  String dosage = "";
  String unit = "";
  String frequency = "";
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
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _showMyDialogDelete();
                    // showModalBottomSheet(context: context,
                    //   isScrollControlled: true,
                    //   builder: (context) => SingleChildScrollView(child: Container(
                    //     padding: EdgeInsets.only(
                    //         bottom: MediaQuery.of(context).viewInsets.bottom),
                    //     child: add_supplement_prescription(thislist: supptemp),
                    //   ),
                    //   ),
                    // ).then((value) =>
                    //     Future.delayed(const Duration(milliseconds: 1500), (){
                    //       setState((){
                    //         print("setstate supplement prescription");
                    //         print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                    //         if(value != null){
                    //           supptemp = value[0];
                    //         }
                    //       });
                    //     }));
                  },
                  child: Icon(
                    Icons.delete,
                  ),
                )
            ),
          ],
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
                            InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {
                                  showModalBottomSheet(context: context,
                                    isScrollControlled: true,
                                    builder: (context) => SingleChildScrollView(child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: edit_supplement_prescription(index: widget.index),
                                    ),
                                    ),
                                  ).then((value) =>
                                      Future.delayed(const Duration(milliseconds: 1500), (){
                                        setState((){
                                          print("setstate medication prescription");
                                          print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                                          if(value != null){
                                            // prestemp = value[0];
                                          }
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


                                    // SizedBox(
                                    //   height: 38,
                                    //   width: 26,
                                    //   // child: Icon(
                                    //   //   Icons.arrow_forward,
                                    //   //   color: FitnessAppTheme.darkText,
                                    //   //   size: 18,
                                    //   // ),
                                    // ),
                                  ],
                                )
                              // )
                            )
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
                                            Text(frequency + " times a day",
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
                int initial_length = listtemp.length;
                listtemp.removeAt(widget.index);
                // List<int> delete_list = [];
                // for(int i = 0; i < listtemp.length; i++){
                //   if(_selected[i]){
                //     delete_list.add(i);
                //   }
                // }
                // delete_list.sort((a,b) => b.compareTo(a));
                // for(int i = 0; i < delete_list.length; i++){
                //   listtemp.removeAt(delete_list[i]);
                // }
                /// delete fields
                for(int i = 1; i <= initial_length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < listtemp.length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/' + (i+1).toString());
                  bpRef.set({
                    "supplement_name": listtemp[i].supplement_name.toString(),
                    "intake_time": listtemp[i].intake_time.toString(),
                    "supp_dosage": listtemp[i].dosage.toString(),
                    "medical_prescription_unit": listtemp[i].prescription_unit.toString(),
                    "dateCreated": "${listtemp[i].dateCreated.month.toString().padLeft(2,"0")}/${listtemp[i].dateCreated.day.toString().padLeft(2,"0")}/${listtemp[i].dateCreated.year}",
                  });
                }
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
  void getSupplement() {
    final User user = auth.currentUser;
    final uid = user.uid;
    // var userUID = widget.userUID;
    int index = widget.index;
    final readsupplement = databaseReference.child('users/' + uid + '/management_plan/supplement_prescription_list/');
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
      dosage = listtemp[index].dosage.toStringAsFixed(2);
      unit = listtemp[index].prescription_unit.toString();
      frequency = listtemp[index].intake_time;
      dateCreated = "${listtemp[index].dateCreated.month}/${listtemp[index].dateCreated.day}/${listtemp[index].dateCreated.year}";

    });
  }
}

