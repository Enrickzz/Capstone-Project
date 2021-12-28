import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/data_inputs/Symptoms/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
import '../../fitness_app_theme.dart';
import 'add_blood_pressure.dart';
import 'add_respiratory_rate.dart';
import '../add_lab_results.dart';
import '../add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class respiratory_rate extends StatefulWidget {
  final List<Respiratory_Rate> rList;
  respiratory_rate({Key key, this.rList});
  @override
  _respiratory_rateState createState() => _respiratory_rateState();
}

class _respiratory_rateState extends State<respiratory_rate> {
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
  List<Respiratory_Rate> respiratory_list=[];

  @override
  void initState(){
    super.initState();
    print("initstate");
    respiratory_list.clear();
    getRespirations();
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("setstate");
        //print(getDateFormatted(listtemp[0].symptomDate.toString()));
        print("LIST RESP " +respiratory_list.length.toString());
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
        title: const Text('Respiratory Rate', style: TextStyle(
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
                      child: add_respiratory_rate(rList: respiratory_list),
                    ),
                    ),
                  ).then((value) => setState((){
                    if(value != null){
                      respiratory_list = value;
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
          itemCount: respiratory_list.length,
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
                                    '' +getTimeFormatted(respiratory_list[index].bpm_time.toString()) + " \n" + respiratory_list[index].bpm.toString(),
                                    // "trigger "+ listtemp[index].symptomTrigger + "recurring during: "+ listtemp[index].recurring[0] + " ," + listtemp[index].recurring[1] + " ," + listtemp[index].recurring[2] + " \n",
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
  List<Respiratory_Rate> getRespirations() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/respiratoryRate_list/');
    List<Respiratory_Rate> rlist = [];
    rlist.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
         // rlist.add(Respiratory_Rate.fromJson(jsonString));
          respiratory_list.add(Respiratory_Rate.fromJson(jsonString));
      });
    });

    return respiratory_list;
  }
}