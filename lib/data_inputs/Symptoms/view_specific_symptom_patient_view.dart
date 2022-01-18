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

import 'edit_symptoms.dart';






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
  SpecificSymptomViewAsPatient({Key key, this.title, this.index, this.thissymp}) : super(key: key);
  final Symptom thissymp;
  final String title;
  int index;
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
  List<Symptom> listtemp = [];
  // Symptom listtemp = new Symptom();
  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;
  String symptom_name = "";
  String intensityLvl = "";
  String symptom_felt = "";
  String symptom_date = "";
  String symptom_time = "";
  String symptom_trigger = "";
  List<String> recurring = [""];
  Symptom thisSymptom;

  @override
  void initState() {
    super.initState();
    listtemp.clear();
    getSymptoms();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    thisSymptom = widget.thissymp;
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        if(thisSymptom.recurring.toString() == "null"){
          thisSymptom.recurring[0] = "";
        }
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
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _showMyDialogDelete().then((value) => setState((){
                      Navigator.pop(context,listtemp);
                      print("NEW LENGTH"  + listtemp.toString());
                    }));
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
                              child: Text( thisSymptom.symptomName,
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
                                      child: edit_symptoms(thislist: listtemp),
                                    ),
                                    ),
                                  ).then((value) =>
                                      Future.delayed(const Duration(milliseconds: 1500), (){
                                        setState((){
                                          print("setstate medication prescription");
                                          print("this pointer = " + value[0].toString() + "\n " + value[1].toString());
                                          if(value != null){
                                            listtemp = value[0];
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
                                            Text(thisSymptom.intensityLvl.toString(),
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
                                            Text(thisSymptom.symptomFelt,
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

                                            if (thisSymptom.symptomTrigger != null && thisSymptom.symptomTrigger.isNotEmpty) ...[
                                              Text(thisSymptom.symptomTrigger,
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
                                                if (thisSymptom.recurring != null) ...[
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
                                            if (thisSymptom.recurring != null) ...[
                                              Text(thisSymptom.recurring.toString(),
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              ],
                                            SizedBox(height: 16),

                                            SizedBox(height: 8),


                                          ],
                                      ),
                                    ),
                                  ))
                            ]
                        )
                    ),
                    SizedBox(height: 10.0),
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
                            child: (Image.network(thisSymptom.imgRef) != null) ? Image.network('' + thisSymptom.imgRef, loadingBuilder: (context, child, loadingProgress) =>
                            (loadingProgress == null) ? child : CircularProgressIndicator(),
                              errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover), fit: BoxFit.cover, ) : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover),
                          ),
                        ),
                      ),
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
                                            Text("${thisSymptom.symptomDate.month.toString().padLeft(2,"0")}/${thisSymptom.symptomDate.day.toString().padLeft(2,"0")}/${thisSymptom.symptomDate.year.toString()}"
                                                + " " +
                                                "${thisSymptom.symptomTime.hour.toString().padLeft(2,"0")}:${thisSymptom.symptomTime.minute.toString().padLeft(2,"0")}",
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
                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < listtemp.length; i++){
                  final bpRef = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/' + (i+1).toString());
                  bpRef.set({
                    "symptom_name": listtemp[i].symptomName.toString(),
                    "intensity_lvl": listtemp[i].intensityLvl.toString(),
                    "symptom_felt": listtemp[i].symptomFelt.toString(),
                    "symptom_date": "${listtemp[i].symptomDate.month.toString().padLeft(2,"0")}/${listtemp[i].symptomDate.day.toString().padLeft(2,"0")}/${listtemp[i].symptomDate.year}",
                    "symptom_time": "${listtemp[i].symptomTime.hour.toString().padLeft(2,"0")}:${listtemp[i].symptomTime.minute.toString().padLeft(2,"0")}",
                    "symptom_isActive": listtemp[i].symptomIsActive.toString(),
                    "symptom_trigger": listtemp[i].symptomTrigger.toString(),
                    "recurring": listtemp[i].recurring,
                    "imgRef": listtemp[i].imgRef.toString(),
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
  List<Symptom> getSymptoms() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
    List<Symptom> symptoms = [];
    symptoms.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      //print("this is temp : "+temp.toString());
      print("pasok here");
      temp.forEach((jsonString) {
        if(!jsonString.toString().contains("recurring")){
          symptoms.add(Symptom.fromJson2(jsonString));
          listtemp.add(Symptom.fromJson2(jsonString));
        }
        else{
          symptoms.add(Symptom.fromJson(jsonString));
          listtemp.add(Symptom.fromJson(jsonString));
        }

        //print(symptoms[0].symptomName);
        //print("symptoms length " + symptoms.length.toString());
      });
    });
    setState(() {
    });
    return symptoms;
  }
}