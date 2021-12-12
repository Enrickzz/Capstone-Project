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
import 'add_body_temperature.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class body_temperature extends StatefulWidget {
  final List<Body_Temperature> btlist;
  body_temperature({Key key, this.btlist}): super(key: key);
  @override
  _body_temperatureState createState() => _body_temperatureState();
}

class _body_temperatureState extends State<body_temperature> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Body_Temperature> bttemp = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readTemperature = databaseReference.child('users/' + uid + '/vitals/health_records/body_temperature_list');
    String tempUnit = "";
    String tempTemperature = "";
    String tempTemperatureDate = "";

    DateFormat format = new DateFormat("MM/dd/yyyy");
    readTemperature.once().then((DataSnapshot datasnapshot) {
      bttemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Body_Temperature bodyTemperature;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 3){
          switch(i){
            case 0: {
              print("1st switch tempUnit " + splitFull.last);
              tempUnit = splitFull.last;
            }
            break;
            case 1: {
              print("1st switch tempTemperature " + splitFull.last);
              tempTemperatureDate = splitFull.last;

            }
            break;
            case 2: {
              print("1st switch tempTemperatureDate " + splitFull.last);
              tempTemperature = splitFull.last;
              bodyTemperature = new Body_Temperature(unit: tempUnit, temperature: double.parse(tempTemperature),bt_date: format.parse(tempTemperatureDate));
              bttemp.add(bodyTemperature);
            }
            break;
          }
        }
        else{
          switch(i%3){
            case 0: {
              tempUnit = splitFull.last;
            }
            break;
            case 1: {
              tempTemperatureDate = splitFull.last;
            }
            break;
            case 2: {
              tempTemperature = splitFull.last;
              bodyTemperature = new Body_Temperature(unit: tempUnit, temperature: double.parse(tempTemperature),bt_date: format.parse(tempTemperatureDate));
              bttemp.add(bodyTemperature);
            }
            break;
          }
        }
      }
      for(var i=0;i<bttemp.length/2;i++){
        var temp = bttemp[i];
        bttemp[i] = bttemp[bttemp.length-1-i];
        bttemp[bttemp.length-1-i] = temp;
      }
    });
    bttemp = widget.btlist;
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
        title: const Text('Body Temperature', style: TextStyle(
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
                      child: add_body_temperature(),
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