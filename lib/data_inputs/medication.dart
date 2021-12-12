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
class medication extends StatefulWidget {
  final List<Medication> medlist;
  medication({Key key, this.medlist}): super(key: key);
  @override
  _medicationState createState() => _medicationState();
}

class _medicationState extends State<medication> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';

  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Medication> medtemp = [];
  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readMedication = databaseReference.child('users/' + uid + '/medications_list');
    String tempMedicineName = "";
    String tempMedicineType = "";
    String tempMedicineDate = "";
    double tempMedicineDosage = 0;
    DateFormat format = new DateFormat("MM/dd/yyyy");
    readMedication.once().then((DataSnapshot datasnapshot) {
      medtemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Medication medicine;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 4){
          switch(i){
            case 0: {
              tempMedicineType = splitFull.last;

            }
            break;
            case 1: {
              tempMedicineDosage = double.parse(splitFull.last);

            }
            break;
            case 2: {
              tempMedicineDate = splitFull.last;
            }
            break;
            case 3: {
              tempMedicineName = splitFull.last;
              medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: format.parse(tempMedicineDate));
              medtemp.add(medicine);
            }
            break;
          }
        }
        else{
          switch(i%4){
            case 0: {

              tempMedicineType = splitFull.last;
              // tempMedicineDosage = 0;
            }
            break;
            case 1: {
              tempMedicineDosage = double.parse(splitFull.last);

            }
            break;
            case 2: {
              tempMedicineDate = splitFull.last;

            }
            break;
            case 3: {
              tempMedicineName = splitFull.last;
              medicine = new Medication(medicine_name: tempMedicineName, medicine_type: tempMedicineType, medicine_dosage: tempMedicineDosage, medicine_date: format.parse(tempMedicineDate));
              medtemp.add(medicine);
            }
            break;
          }
        }
      }
      for(var i=0;i<medtemp.length/2;i++){
        var temp = medtemp[i];
        medtemp[i] = medtemp[medtemp.length-1-i];
        medtemp[medtemp.length-1-i] = temp;
      }
    });
    medtemp = widget.medlist;
    setState(() {
      print("setstate");
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
        title: const Text('Medication Intake', style: TextStyle(
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
                      child: add_medication(thislist: medtemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate medicines");
                    medtemp = value;
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
        itemCount: medtemp.length,
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
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [

                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                  '' + medtemp[index].getDate.toString()+" " + medtemp[index].getName + " " + medtemp[index].getDosage.toString()+ " " + medtemp[index].getType,
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
}
