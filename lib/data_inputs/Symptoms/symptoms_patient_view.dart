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
import 'package:my_app/data_inputs/Symptoms/add_symptoms.dart';
import 'package:my_app/data_inputs/Symptoms/specific_symptom_patient_view.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';

import '../../fitness_app_theme.dart';
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
    listtemp.clear();
    getSymptoms();


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

    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("setstate");
        //print(getDateFormatted(listtemp[0].symptomDate.toString()));
        print("LIST TEMP " +listtemp.length.toString());
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
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.medication_outlined ),
                    title: Text(listtemp[index].symptomName,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Intensity Level: " + listtemp[index].intensityLvl.toString(),
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${listtemp[index].symptomDate.month}/${listtemp[index].symptomDate.day}/${listtemp[index].symptomDate.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,



                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificSymptomViewAsPatient()),
                      );
                    }

                ),

              ),
            )
        )

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
    symptoms.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      //print("this is temp : "+temp.toString());
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

    return symptoms;
  }
}
