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
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/symptoms.dart';
import 'add_blood_pressure.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class blood_pressure extends StatefulWidget {
  final List<Blood_Pressure> bplist;
  blood_pressure({Key key, this.bplist}): super(key: key);
  @override
  _blood_pressureState createState() => _blood_pressureState();
}

class _blood_pressureState extends State<blood_pressure> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";

  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Pressure> bptemp = [];

  @override
  void initState(){
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list');
    String tempSystolicPressure = "";
    String tempDiastolicPressure = "";
    String tempBPDate = "";
    DateFormat format = new DateFormat("MM/dd/yyyy");
    readBP.once().then((DataSnapshot datasnapshot) {
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Blood_Pressure blood_pressure = new Blood_Pressure();
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 4){
          switch(i){
            case 0: {
              tempBPDate = splitFull.last;
            }
            break;
            case 1: {
              tempDiastolicPressure = splitFull.last;
            }
            break;
            case 2: {
              tempSystolicPressure = splitFull.last;
              blood_pressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure, bp_date: format.parse(tempBPDate));
              bptemp.add(blood_pressure);
            }
            break;
          }
        }
        else{
          switch(i%3){
            case 0: {
              tempBPDate = splitFull.last;
            }
            break;
            case 1: {
              tempDiastolicPressure = splitFull.last;
            }
            break;
            case 2: {
              tempSystolicPressure = splitFull.last;
              blood_pressure = new Blood_Pressure(systolic_pressure: tempSystolicPressure, diastolic_pressure: tempDiastolicPressure, bp_date: format.parse(tempBPDate));
              bptemp.add(blood_pressure);
            }
            break;
          }
        }
      }
      for(var i=0;i<bptemp.length/2;i++){
        var temp = bptemp[i];
        bptemp[i] = bptemp[bptemp.length-1-i];
        bptemp[bptemp.length-1-i] = temp;
      }
    });
    bptemp = widget.bplist;
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print(bptemp);
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
        title: const Text('Blood Pressure', style: TextStyle(
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
                      child: add_blood_pressure(thislist: bptemp),
                    ),
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),

    );
  }
}