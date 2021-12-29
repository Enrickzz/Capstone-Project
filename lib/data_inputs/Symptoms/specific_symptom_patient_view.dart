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
      home: SpecificSymptomViewAsPatient(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificSymptomViewAsPatient extends StatefulWidget {
  SpecificSymptomViewAsPatient({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SpecificSymptomViewAsPatientState createState() => _SpecificSymptomViewAsPatientState();
}

class _SpecificSymptomViewAsPatientState extends State<SpecificSymptomViewAsPatient> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<Medication_Prescription> prestemp = [];
  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;


  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
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
                              child: Text( "Symptom Name here",
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
                                      child: edit_medication_prescription(thislist: prestemp),
                                    ),
                                    ),
                                  ).then((value) =>
                                      Future.delayed(const Duration(milliseconds: 1500), (){
                                        setState((){
                                          print("setstate medication prescription");
                                          print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                                          if(value != null){
                                            prestemp = value[0];
                                          }
                                        });
                                      }));
                                },
                                // child: Padding(
                                // padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text( "Delete",
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
                                            Text("Put Intensity level here",
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
                                            Text("Put here area of symptom",
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Recurring",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text("Put here morning, afternoon, evening",
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Symptom Trigger",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text("Put here symptom trigger",
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
                                            Text("Put date and time here",
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

}