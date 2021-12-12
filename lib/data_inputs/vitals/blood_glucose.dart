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
import 'add_blood_glucose.dart';
import 'add_blood_pressure.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class blood_glucose extends StatefulWidget {
  final List<Blood_Glucose> bglist;
  blood_glucose({Key key, this.bglist}): super(key: key);
  @override
  _blood_glucoseState createState() => _blood_glucoseState();
}

class _blood_glucoseState extends State<blood_glucose> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Blood_Glucose> bgtemp = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readMedication = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list');
    String tempGlucose = "";
    String tempStatus = "";
    String tempGlucoseDate;
    DateFormat format = new DateFormat("MM/dd/yyyy");
    readMedication.once().then((DataSnapshot datasnapshot) {
      bgtemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Blood_Glucose bloodGlucose;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 3){
          print("i value" + i.toString());
          switch(i){
            case 0: {
              print("1st switch i = 0 " + splitFull.last);
              tempGlucose = splitFull.last;
            }
            break;
            case 1: {
              print("1st switch i = 2 " + splitFull.last);
              tempGlucoseDate = splitFull.last;

            }
            break;
            case 2: {
              print("1st switch i = 3 " + splitFull.last);
              tempStatus = splitFull.last;
              bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), status: tempStatus, bloodGlucose_date: format.parse(tempGlucoseDate));
              bgtemp.add(bloodGlucose);
            }
            break;
          }
        }
        else{
          switch(i%3){
            case 0: {
              tempGlucose = splitFull.last;
            }
            break;
            case 1: {
              tempGlucoseDate = splitFull.last;
            }
            break;
            case 2: {
              tempStatus = splitFull.last;
              bloodGlucose = new Blood_Glucose(glucose: double.parse(tempGlucose), status: tempStatus, bloodGlucose_date: format.parse(tempGlucoseDate));
              bgtemp.add(bloodGlucose);
            }
            break;
          }
        }
      }
      for(var i=0;i<bgtemp.length/2;i++){
        var temp = bgtemp[i];
        bgtemp[i] = bgtemp[bgtemp.length-1-i];
        bgtemp[bgtemp.length-1-i] = temp;
      }
    });
    bgtemp = widget.bglist;
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
        title: const Text('Blood Glucose Level', style: TextStyle(
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
                      child: add_blood_glucose(),
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