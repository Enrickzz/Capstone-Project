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
import 'add_heart_rate.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class heart_rate extends StatefulWidget {
  final List<Heart_Rate> hrlist;
  heart_rate({Key key, this.hrlist}): super(key: key);
  @override
  _heart_rateState createState() => _heart_rateState();
}

class _heart_rateState extends State<heart_rate> {
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDateSelected= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Heart_Rate> hrtemp = [];

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readHeartRate = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list');
    String tempBmi = ""; // int
    String tempisResting = ""; //bool
    String tempHRDate = "";
    DateFormat format = new DateFormat("MM/dd/yyyy");
    readHeartRate.once().then((DataSnapshot datasnapshot) {
      hrtemp.clear();
      String temp1 = datasnapshot.value.toString();
      List<String> temp = temp1.split(',');
      Heart_Rate heartRate;
      for(var i = 0; i < temp.length; i++) {
        String full = temp[i].replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("[", "")
            .replaceAll("]", "");
        List<String> splitFull = full.split(" ");
        if(i < 3){
          switch(i){
            case 0: {
              tempBmi = splitFull.last;

            }
            break;
            case 1: {
              tempisResting = splitFull.last;

            }
            break;
            case 2: {
              tempHRDate = splitFull.last;
              heartRate = new Heart_Rate(bpm: int.parse(tempBmi), isResting: parseBool(tempisResting), hr_date: format.parse(tempHRDate));
              hrtemp.add(heartRate);
            }
            break;
          }
        }
        else{
          switch(i%3){
            case 0: {
              tempBmi = splitFull.last;

            }
            break;
            case 1: {
              tempisResting = splitFull.last;

            }
            break;
            case 2: {
              tempHRDate = splitFull.last;
              heartRate = new Heart_Rate(bpm: int.parse(tempBmi), isResting: parseBool(tempisResting), hr_date: format.parse(tempHRDate));
              hrtemp.add(heartRate);
            }
            break;
          }
        }
      }
      for(var i=0;i<hrtemp.length/2;i++){
        var temp = hrtemp[i];
        hrtemp[i] = hrtemp[hrtemp.length-1-i];
        hrtemp[hrtemp.length-1-i] = temp;
      }
    });
    // hrtemp = widget.hrlist;
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
        title: const Text('Heart Rate', style: TextStyle(
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
                      child: add_heart_rate(),
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

  bool parseBool(String temp) {
    if (temp.toLowerCase() == 'Yes') {
      return false;
    } else if (temp.toLowerCase() == 'No') {
      return true;
    }
  }

}