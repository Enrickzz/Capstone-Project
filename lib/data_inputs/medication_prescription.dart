import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import 'add_medication.dart';
import '../fitness_app_theme.dart';
import '../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class medication_prescription extends StatefulWidget {
  final List<Medication_Prescription> medpreslist;
  medication_prescription({Key key, this.medpreslist}): super(key: key);
  @override
  _medicationPresState createState() => _medicationPresState();
}

class _medicationPresState extends State<medication_prescription> {
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TimeOfDay time;
  List<Medication> medprestemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readMedicationPres = databaseReference.child('users/' + uid + '/vitals/health_records/medications_prescription_list');
    String tempMedicationBName = "";
    String tempMedicationGName = "";
    String tempIntakeTime = "";
    String tempSpecialInstruction = "";
    String tempStartDate = "";
    String tempEndDate = "";

    readMedicationPres.once().then((DataSnapshot datasnapshot) {
      medprestemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Medication_Prescription prescription;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 6){
          switch(i){
            case 0: {
              print("1 " + splitFull.last);
              tempMedicationBName = splitFull.last;
            }
            break;
            case 1: {
              print("2 " + splitFull.last);
              tempMedicationGName = splitFull.last;
            }
            break;
            case 2: {
              print("3 " + splitFull.last);
              tempIntakeTime = splitFull.last;
            }
            break;
            case 3: {
              print("4 " + splitFull.last);
              tempSpecialInstruction = splitFull.last;

            }
            break;
            case 4: {
              print("5 " + splitFull.last);
              tempStartDate = splitFull.last;

            }
            break;
            case 5: {
              print("6 " + splitFull.last);
              tempEndDate = splitFull.last;
              prescription = new Medication_Prescription(generic_name: tempMedicationGName, branded_name: tempMedicationBName, startdate: format.parse(tempStartDate), enddate: format.parse(tempEndDate),intake_time: tempIntakeTime, special_instruction: tempSpecialInstruction));
              medprestemp.add(prescription);
            }
            break;
          }
        }
        else{
          switch(i%6){
            case 0: {
              print("1 " + splitFull.last);
              tempMedicationBName = splitFull.last;
            }
            break;
            case 1: {
              print("2 " + splitFull.last);
              tempMedicationGName = splitFull.last;
            }
            break;
            case 2: {
              print("3 " + splitFull.last);
              tempIntakeTime = splitFull.last;
            }
            break;
            case 3: {
              print("4 " + splitFull.last);
              tempSpecialInstruction = splitFull.last;

            }
            break;
            case 4: {
              print("5 " + splitFull.last);
              tempStartDate = splitFull.last;

            }
            break;
            case 5: {
              print("6 " + splitFull.last);
              tempEndDate = splitFull.last;
              prescription = new Medication_Prescription(generic_name: tempMedicationGName, branded_name: tempMedicationBName, startdate: format.parse(tempStartDate), enddate: format.parse(tempEndDate),intake_time: tempIntakeTime, special_instruction: tempSpecialInstruction));
              medprestemp.add(prescription);
            }
            break;
          }
        }
      }
      for(var i=0;i<medprestemp.length/2;i++){
        var temp = medprestemp[i];
        medprestemp[i] = medprestemp[medprestemp.length-1-i];
      medprestemp[medprestemp.length-1-i] = temp;
      }
    });
    medprestemp = widget.medpreslist;
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
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
        title: const Text('Medication Prescription', style: TextStyle(
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
                        child: add_medication(thislist: medprestemp),
                      ),
                      ),
                    ).then((value) =>
                        Future.delayed(const Duration(milliseconds: 1500), (){
                          setState((){
                            print("setstate medicines");
                            if(value != null){
                              medprestemp = value;
                            }
                            print("medetmp.length == " +medprestemp.length.toString());
                          });
                        }));

                  },
                  child: Icon(
                    Icons.add,
                  )
              )
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: medprestemp.length,
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
                              Text(
                                  '' + getDateFormatted(medprestemp[index].getDate.toString())+getTimeFormatted(medprestemp[index].getTime.toString())+" "
                                      + "\nMedicine: " + medprestemp[index].getName + " "
                                      +"\nDosage "+ medprestemp[index].getDosage.toString()+ " "
                                      +"\nType: "+ medprestemp[index].getType,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                  )
                              ),

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
    print(date);
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    if(date != null){
      var dateTime = DateTime.parse(date);
      var hours = dateTime.hour.toString().padLeft(2, "0");
      var min = dateTime.minute.toString().padLeft(2, "0");
      return "$hours:$min";
    }

  }
}
