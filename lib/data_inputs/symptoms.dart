import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';

import '../fitness_app_theme.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class symptoms extends StatefulWidget {
  final List<Symptom> symptomlist1;
  symptoms({Key key, this.symptomlist1})
      : super(key: key);
  @override
  _symptomsState createState() => _symptomsState();
}

class _symptomsState extends State<symptoms> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> items = List<String>.generate(10000, (i) => 'Item $i');
  TimeOfDay time;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Symptom> listtemp=[];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  @override
  void initState() {
    super.initState();
    List<Symptom> symptomsList = new List<Symptom>();
    final User user = auth.currentUser;
    final uid = user.uid;
    final symptomsRef = databaseReference.child('users/' + uid +'/vitals/health_records/symptoms_list/');
    int tempIntesityLvl = 0;
    String tempSymptomName = "";
    String tempSymptomDate = "";
    String tempSymptomFelt = "";
    String tempSymptomTime = "";
    bool tempIsActive;
    listtemp.clear();
    listtemp = getSymptoms();


    // symptomsRef.once().then((DataSnapshot datasnapshot){
    //   listtemp.clear();
    //   String temp1 = datasnapshot.value.toString();
    //   List<String> temp = temp1.split(',');
    //   Symptom symptom;
    //
    //   for(var i = 0; i < temp.length; i++){
    //     String full = temp[i].replaceAll("{", "").replaceAll("}", "").replaceAll("[", "").replaceAll("]", "");
    //     List<String> splitFull = full.split(" ");
    //       switch(i%6){
    //         case 0: {
    //           print("1st switch intensity lvl " + splitFull.last);
    //           tempIntesityLvl = int.parse(splitFull.last);
    //         }
    //         break;
    //         case 1: {
    //           print("1st switch symptom name " + splitFull.last);
    //           tempSymptomName = splitFull.last;
    //         }
    //         break;
    //         case 2: {
    //           print("1st switch symptom date " + splitFull.last);
    //           tempSymptomDate = splitFull.last;
    //
    //         }
    //         break;
    //         case 3: {
    //           print("1st switch symptom time " + splitFull.last);
    //
    //
    //         }
    //         break;
    //         case 4: {
    //           print("1st switch is active " + splitFull.last);
    //           tempSymptomTime = splitFull.last;
    //         }
    //         break;
    //         case 5: {
    //           print("1st switch symptom felt " + splitFull.last);
    //           tempSymptomFelt = splitFull.last;
    //           // symptom = new Symptom(symptom_name: tempSymptomName, intesity_lvl: tempIntesityLvl, symptom_felt: tempSymptomFelt,symptom_date: format.parse(tempSymptomDate), symptom_time: timeformat.parse(tempSymptomTime), symptom_isActive: tempIsActive);
    //           listtemp.add(symptom);
    //         }
    //         break;
    //       }
    //
    //   }
    //   for(var i=0;i<listtemp.length/2;i++){
    //     var temp = listtemp[i];
    //     listtemp[i] = listtemp[listtemp.length-1-i];
    //     listtemp[listtemp.length-1-i] = temp;
    //   }
    // });

    print(listtemp.toString());

    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
        print(getDateFormatted(listtemp[0].symptomDate.toString()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text('Symptoms', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: add_symptoms(thislist: listtemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate symptoms");
                    if(value != null){
                      listtemp = value;
                    }
                    print("SYMP LENGTH AFTER SETSTATE  =="  + listtemp.length.toString() );
                  }));
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listtemp.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 140,
                child: Stack(
                    children: [
                      Positioned (
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.7),
                                      Colors.white
                                    ]
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.grey.withOpacity(0.6),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ]
                            )
                        ),
                      ),
                      Positioned(
                        top: 25,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [

                              SizedBox(
                                width: 10,
                              ),
                              // Text(
                              //     '' + getDateFormatted(listtemp[index].symptomDate.toString()) + getTimeFormatted(listtemp[index].symptomTime.toString())+" \n" + "Name: " +listtemp[index].symptomName+
                              //         "\nI felt " + listtemp[index].symptomFelt + " \n"
                              //         "The intensity was "+ listtemp[index].intensityLvl.toString()+ " \n" +
                              //         "trigger "+ listtemp[index].symptomTrigger + "recurring during: "+ listtemp[index].recurring[0] + " ," + listtemp[index].recurring[1] + " ," + listtemp[index].recurring[2] + " \n",
                              //     style: TextStyle(
                              //         color: Colors.black,
                              //         fontSize: 18
                              //     )
                              // ),

                            ],
                          ),
                        ),
                      ),
                    ]
                )
            ),
          );
        },
      ),

    );
  }
  String getDateFormatted (String date){
    var dateTime = DateTime.tryParse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    var dateTime = DateTime.tryParse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  List<Symptom> getSymptoms() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
    List<Symptom> symptoms = [];
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      print(temp);
      temp.forEach((jsonString) {
        symptoms.add(Symptom.fromJson(jsonString));
        print(symptoms[0].symptomName);
      });
    });

    return symptoms;
  }
}
