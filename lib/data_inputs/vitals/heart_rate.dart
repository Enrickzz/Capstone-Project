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
import '../../fitness_app_theme.dart';
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
    String tempHRTime = "";
    DateFormat format = new DateFormat("MM/dd/yyyy");
    DateFormat timeformat = new DateFormat("hh:mm");

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
        if(i < 4){
          switch(i){
            case 0: {
              print("i = " + i.toString() + splitFull.last);
              tempHRTime = splitFull.last;

            }
            break;
            case 1: {
              print("i = " + i.toString() + splitFull.last);
              tempBmi = splitFull.last;

            }
            break;
            case 2: {
              print("i = " + i.toString() + splitFull.last);
              tempisResting = splitFull.last;
            }
            break;
            case 3: {
              print("i = " + i.toString() + splitFull.last);
              tempHRDate = splitFull.last;
              heartRate = new Heart_Rate(bpm: int.parse(tempBmi), isResting: parseBool(tempisResting), hr_date: format.parse(tempHRDate), hr_time: timeformat.parse(tempHRTime));
              hrtemp.add(heartRate);
            }
            break;
          }
        }
        else{
          switch(i%4){
            case 0: {
              tempHRTime = splitFull.last;
            }
            break;
            case 1: {
              tempBmi = splitFull.last;

            }
            break;
            case 2: {
              tempisResting = splitFull.last;
            }
            break;
            case 3: {
              tempHRDate = splitFull.last;
              heartRate = new Heart_Rate(bpm: int.parse(tempBmi), isResting: parseBool(tempisResting), hr_date: format.parse(tempHRDate), hr_time: timeformat.parse(tempHRTime));
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
    hrtemp = widget.hrlist;
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print(hrtemp);
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
                      child: add_heart_rate(thislist: hrtemp),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate blood_pressure");
                    if(value != null){
                      hrtemp = value;
                    }
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
          itemCount: hrtemp.length,
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
                                    '' + getDateFormatted(hrtemp[index].getDate.toString())+getTimeFormatted(hrtemp[index].getTime.toString())+" "
                                        +"\nHeart rate: "+ hrtemp[index].getBPM.toString() + " BPM"
                                        +"\nResting: "+ hrtemp[index].getisResting.toString() + "  " ,
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
        )

    );
  }

  bool parseBool(String temp) {
    if (temp.toLowerCase() == 'false') {
      return false;
    } else if (temp.toLowerCase() == 'true') {
      return true;
    }
  }
  String getDateFormatted (String date){
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }

}