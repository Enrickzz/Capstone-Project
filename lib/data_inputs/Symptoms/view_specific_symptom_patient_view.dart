import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
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
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    getSymptoms();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 3000), (){
      downloadUrls();
      thisSymptom = listtemp[widget.index];
      setState(() {
        print("listtemp index at " + listtemp[widget.index].symptomName.toString());
        isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 2000), (){
        setState(() {
          if(thisSymptom.recurring.toString() == "null"){
            thisSymptom.recurring[0] = "";
          }
          print("setstate");
        });
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
                    int initLeng = listtemp.length;
                    _showMyDialogDelete().then((value) => setState((){
                      if(initLeng != listtemp.length){
                        Navigator.pop(context,listtemp);
                      }
                    }));
                  },
                  child: Icon(
                    Icons.delete,
                  ),
                )
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, listtemp);
            return true;
          },
          child:  isLoading
              ? Center(
            child: CircularProgressIndicator(),
          ): new Scrollbar(
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
                                        child: edit_symptoms( index: widget.index, thislist: listtemp,),
                                      ),
                                      ),
                                    ).then((value) {
                                      Future.delayed(const Duration(milliseconds: 1500), (){
                                        setState((){
                                          if(value != null){
                                            Symptom updated = value;
                                            thisSymptom.symptomName = updated.symptomName;
                                            thisSymptom.intensityLvl =  updated.intensityLvl;
                                            thisSymptom.symptomFelt =  updated.symptomFelt;
                                            thisSymptom.symptomDate =  updated.symptomDate;
                                            thisSymptom.symptomTime =  updated.symptomTime;
                                            thisSymptom.symptomTrigger =  updated.symptomTrigger;
                                            thisSymptom.recurring =  updated.recurring;

                                            listtemp[widget.index].symptomName = updated.symptomName;
                                            listtemp[widget.index].intensityLvl =  updated.intensityLvl;
                                            listtemp[widget.index].symptomFelt =  updated.symptomFelt;
                                            listtemp[widget.index].symptomDate =  updated.symptomDate;
                                            listtemp[widget.index].symptomTime =  updated.symptomTime;
                                            listtemp[widget.index].symptomTrigger =  updated.symptomTrigger;
                                            listtemp[widget.index].recurring =  updated.recurring;
                                            setState(() {

                                            });

                                          }
                                        });
                                      });
                                    });
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
                      showimg(thisSymptom.imgRef),

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
                Navigator.pop(context, listtemp);

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
      for(var i=0;i<listtemp.length/2;i++){
        var temp = listtemp[i];
        listtemp[i] = listtemp[listtemp.length-1-i];
        listtemp[listtemp.length-1-i] = temp;
      }
      symptom_name = listtemp[widget.index].symptomName;
      intensityLvl =  listtemp[widget.index].intensityLvl.toString();
      symptom_felt =  listtemp[widget.index].symptomFelt;
      symptom_date =  listtemp[widget.index].symptomDate.toString();
      symptom_time =  listtemp[widget.index].symptomTime.toString();
      symptom_trigger =  listtemp[widget.index].symptomTrigger;
      recurring =  listtemp[widget.index].recurring;
    });

    setState(() {
    });
    return symptoms;
  }
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return SizedBox(height: 10.0);
    }else{
      return Visibility(
        visible: hasImage,
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          minScale: minScale,
          maxScale: maxScale,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
              (loadingProgress == null) ? child : CircularProgressIndicator()),
            ),
          ),
        ),
      );
    }
  }
  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl="null";
    for(var i = 0 ; i < listtemp.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+listtemp[i].imgRef.toString());
      if(listtemp[i].imgRef.toString() != "null"){
        downloadurl = await ref.getDownloadURL();
        listtemp[i].imgRef = downloadurl;
      }
      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
      isLoading = false;
    });
    return downloadurl;
  }
}

